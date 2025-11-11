<?php

namespace ExternalSignatoryBook\controllers;
use Attachment\models\AttachmentModel;
use Attachment\models\AttachmentTypeModel;
use Convert\controllers\ConvertPdfController;
use Docserver\models\DocserverModel;
use Resource\controllers\ResController;
use Resource\models\ResModel;
use Slim\Psr7\Request;
use Slim\Psr7\Response;
use SrcCore\models\CoreConfigModel;
use SrcCore\models\CurlModel;
use Respect\Validation\Validator;
use SrcCore\models\DatabaseModel;

class SesileController
{
    public static function getRules($config, $resId, $ruleName) {
        $desc = '';
        if (isset($config['data'][$ruleName])) {
            foreach ($config['data'][$ruleName] -> rule as $modelElements) {
                $type = (string) $modelElements -> type;
                if (strtolower($type) == 'text') {
                    $value = (string) $modelElements -> value;
                    $desc .= $value;
                } else if(strtolower($type) == 'database') {
                    $tables = [];
                    $whereArray = [];
                    $select = (string) $modelElements -> select;
                    $column = (string) $modelElements -> column_name;
                    $table = (string) $modelElements -> table;
                    $left_join = (string) $modelElements -> left_join;
                    $res_id_column = (string) $modelElements -> res_id_column;
                    $where = (string) $modelElements -> where;

                    foreach(explode(',', $table) as $_ta) {
                        $tables[] = trim($_ta);
                    }

                    if (!empty($where)) {
                        $whereArray = [$where];
                    }

                    if (!empty($left_join)) {
                        $left_join = explode(',', $left_join);
                    }

                    array_push($whereArray, $res_id_column . ' = ?');
                    $res = DatabaseModel::select([
                        'select'    => [$select],
                        'table'     => $tables,
                        'left_join' => $left_join ?: [],
                        'where'     => $whereArray,
                        'data'      => [$resId]
                    ]);
                    if ($res and count($res)) {
                        if ($column) {
                            $desc .= $res[0][$column];
                        } else {
                            $desc .= $res[0][$select];
                        }
                    }
                }
            }
        }
        return $desc;
    }

    public static function sendDatas($aArgs)
    {
        if (!Validator::intVal()->validate($aArgs['resIdMaster']) || !ResController::hasRightByResId(['resId' => [$aArgs['resIdMaster']], 'userId' => $GLOBALS['id']])) {
            return ['error' => 'Document out of perimeter'];
        }
        // Get the record from the res_letterBox table
        $mainResource = ResModel::getById([
            'select' => ['res_id', 'subject', 'path', 'filename', 'docserver_id', 'format', 'category_id', 'external_id', 'integrations', 'subject', 'dest_user'],
            'resId'  => $aArgs['resIdMaster']
        ]);
        $mainDocumentIntegration = json_decode($mainResource['integrations'], true);
        $externalId              = json_decode($mainResource['external_id'], true);

        //create worfklow
        $curlResponse = CurlModel::exec([
            'url' => rtrim($aArgs['config']['data']['url']) . '/api/classeur/',
            'headers' => [
                'token: ' . $aArgs['config']['data']['tokenAPI'],
                'secret: ' . $aArgs['config']['data']['secretAPI'],
            ],
            'method' => 'POST',
            'multipartBody' => [
                'name'          => self::getRules($aArgs['config'], $mainResource['res_id'], 'nameRules') . ' ' . $mainResource['subject'],
                'validation'    => date("d/m/Y"),
                'type'          => $aArgs['selectedFormData']['idSelectedTypeClasseur'],
                'groupe'        => $aArgs['selectedFormData']['idSelectedCircuit'],
                'visibilite'    => '3',
                'desc'          => self::getRules($aArgs['config'], $mainResource['res_id'], 'descriptionRules'),
                'email'         => $aArgs['config']['data']['deposantMail']
            ]
        ]);

        if ($curlResponse['code'] != 200) {
            return ['error' => $curlResponse['errors']];
        }


        $collId = 'letterbox_coll';
        $attachmentToFreeze = [];
        // Send main document if in signature book
        if ($mainDocumentIntegration['inSignatureBook'] && empty($externalId['signatureBookId']) && !empty($mainResource['docserver_id'])) {
            $adrMainInfo = ConvertPdfController::getConvertedPdfById(['resId' => $aArgs['resIdMaster'], 'collId' => 'letterbox_coll']);
            $letterboxPath = DocserverModel::getByDocserverId(['docserverId' => $adrMainInfo['docserver_id'], 'select' => ['path_template']]);
            $directoryPath = $letterboxPath['path_template'] . str_replace('#', '/', $adrMainInfo['path']);
            $fileName = $adrMainInfo['filename'];

            $queryToAddDocument = CurlModel::exec([
                'url'           => rtrim($aArgs['config']['data']['url']) . '/api/classeur/' . $curlResponse['response']['id']  .'/newDocuments',
                'headers'       => [
                    'token: ' . $aArgs['config']['data']['tokenAPI'],
                    'secret: ' . $aArgs['config']['data']['secretAPI'],
                ],
                'customRequest' => 'POST',
                'method'        => 'CUSTOM',
                'body'          => [
                    'document' => new \CURLFile($directoryPath . $fileName, 'application/pdf')
                ]
            ]);
            if ($queryToAddDocument['code'] != 200) {
                return ['error' => $curlResponse['errors']];
            }
            $attachmentToFreeze[$collId][$aArgs['resIdMaster']] = $queryToAddDocument['response']['id'];
        }

        // Get the attachments
        $attachments = AttachmentModel::get([
            'select' => [
                'res_id', 'title', 'identifier', 'attachment_type', 'status', 'typist', 'docserver_id', 'path', 'filename', 'creation_date',
                'validation_date', 'relation', 'origin_id', 'fingerprint', 'format'
            ],
            'where' => ["res_id_master = ?", "attachment_type not in (?)", "status not in ('DEL', 'OBS', 'FRZ', 'TMP', 'SEND_MASS')", "in_signature_book = 'true'"],
            'data' => [$aArgs['resIdMaster'], ['signed_response', 'incoming_mail_attachment']]
        ]);
        // Get attachmenttypes
        $attachmentTypes = AttachmentTypeModel::get(['select' => ['type_id', 'signable']]);
        $attachmentTypes = array_column($attachmentTypes, 'signable', 'type_id');
        $collId = 'attachments_coll';
        foreach ($attachments as $key => $value) {
            $adrInfo = ConvertPdfController::getConvertedPdfById(['resId' => $value['res_id'], 'collId' => 'attachments_coll']);
            $docserverInfo = DocserverModel::getByDocserverId(['docserverId' => $adrInfo['docserver_id']]);
            $directoryPath = $docserverInfo['path_template'] . str_replace('#', '/', $adrInfo['path']);
            $fileName = $adrInfo['filename'];

            if ($attachmentTypes[$value['attachment_type']]) {
                $queryToAddDocument = CurlModel::exec([
                    'url' => rtrim($aArgs['config']['data']['url']) . '/api/classeur/' . $curlResponse['response']['id']  .'/newDocuments',
                    'headers' => [
                        'token: ' . $aArgs['config']['data']['tokenAPI'],
                        'secret: ' . $aArgs['config']['data']['secretAPI'],
                    ],
                    'customRequest' => 'POST',
                    'method' => 'CUSTOM',
                    'body' => [
                        'document' => new \CURLFile($directoryPath . $fileName, 'application/pdf')
                    ]

                ]);
                if ($queryToAddDocument['code'] != 200) {
                    return ['error' => $curlResponse['errors']];
                }
                $attachmentToFreeze[$collId][$value['res_id']] = $queryToAddDocument['response']['id'];
            }
            else {
                return ['error' => 'Les pièces jointe peuvent pas être envoyé au parapheur'];
            }
        }
        $info = _SELECTED_CIRCUIT . $aArgs['selectedFormData']['nameSelectedCircuit'];
        \History\controllers\HistoryController::add([
            'tableName' => 'res_letterbox',
            'recordId'  => $aArgs['resIdMaster'],
            'eventType' => 'ACTION#1',
            'eventId'   => "1",
            'userId'    => $GLOBALS['id'],
            'info'      => $info
        ]);

        $info = _SELECTED_TYPE . $aArgs['selectedFormData']['nameSelectedTypeClasseur'];
        \History\controllers\HistoryController::add([
            'tableName' => 'res_letterbox',
            'recordId'  => $aArgs['resIdMaster'],
            'eventType' => 'ACTION#1',
            'eventId'   => "1",
            'userId'    => $GLOBALS['id'],
            'info'      => $info
        ]);
        return ['sended' => $attachmentToFreeze];
    }

    public static function getDatas(Request $request, Response $response, array $args) {
        $loadedXml = CoreConfigModel::getXmlLoaded(['path' => 'modules/visa/xml/remoteSignatoryBooks.xml']);
        $config = [];
        if (!empty($loadedXml)) {
            $config['id'] = (string)$loadedXml->signatoryBookEnabled;
            foreach ($loadedXml->signatoryBook as $value) {
                if ($value->id == $config['id']) {
                    $config['data'] = (array)$value;
                    break;
                }
            }
        }
        if (empty($config['data']['url'])) {
            return $response->withStatus(400)->withJson(['errors' => 'Url n\'est pas défini sur le fichier xml']);
        }
        if (empty($config['data']['tokenAPI'])) {
            return $response->withStatus(400)->withJson(['errors' => 'Token Api n\'est pas défini sur le fichier xml']);
        }
        if (empty($config['data']['secretAPI'])) {
            return $response->withStatus(400)->withJson(['errors' => 'secret API n\'est pas défini sur le fichier xml']);
        }
        if (empty($config['data']['deposantMail'])) {
            return $response->withStatus(400)->withJson(['errors' => 'deposantMail n\'est pas défini sur le fichier xml']);
        }
        if (empty($config['data']['organizationId'])) {
            return $response->withStatus(400)->withJson(['errors' => 'organizationId n\'est pas défini sur le fichier xml']);
        }
        $curlResponse = CurlModel::exec([
            'url'           => $config['data']['url'] . '/api/user/' . $config['data']['deposantMail'] . '/org/' . $config['data']['organizationId'] . '/circuits',
            'headers' => [
                'token: ' .  $config['data']['tokenAPI'],
                'secret: ' . $config['data']['secretAPI'],
            ],
            'method'        => 'GET',
        ]);
        if ($curlResponse['code'] != 200) {
            return $response->withStatus(400)->withJson(['errors' => $curlResponse['errors']]);
        }
        $circuits = $curlResponse['response'];
        $curlResponse = CurlModel::exec([
            'url'           => 'https://edissyum.sesile4-integration.sictiam.fr/api/classeur/types/',
            'headers'       => ['token: token_88f5e5e389abdd96f7c42178d4309867' , 'secret: secret_340fc9a22cc6b6b33e302cd05e5d7e81'],
            'method'        => 'GET',
        ]);
        if ($curlResponse['code'] != 200) {
            return $response->withStatus(400)->withJson(['errors' => $curlResponse['errors']]);
        }
        $classeurs  = $curlResponse['response'];

        $data = null;
        // Parcours des identifiants de classeur
        foreach ($circuits as $key => $circuit) {
            foreach ($circuit['type_classeur'] as $type) {
                // Recherche du titre du classeur correspondant dans le tableau des classeurs
                foreach ($classeurs as $classeur) {
                    if ($classeur['id'] == $type) {
                        // Stockage du titre du classeur dans le tableau
                        $data = ['id' => $classeur['id'], 'name' => $classeur['nom'] ];
                        break; // Sortie de la boucle dès que le classeur est trouvé
                    }
                }
                $circuits[$key]['typesCompleted'][] = $data;
            }
        }
        return $response->withJson(['Data' => $circuits]);
    }

    public static function retrieveSignedMails($aArgs)
    {
        $version = $aArgs['version'];
        foreach ($aArgs['idsToRetrieve'][$version] as $resId => $value) {
            if (!empty($value['external_id'])) {
                $curlResponse = CurlModel::exec([
                    'url' => rtrim($aArgs['config']['data']['url']) . '/api/document/' . $value['external_id'],
                    'headers' => [
                        'token: ' . $aArgs['config']['data']['tokenAPI'],
                        'secret: ' . $aArgs['config']['data']['secretAPI'],
                    ],
                    'method' => 'GET',
                ]);
                if ($curlResponse['code'] == 200 && $curlResponse['response']['signed']) {
                    $response = CurlModel::exec([
                        'url' => rtrim($aArgs['config']['data']['url']) . '/api/document/' . $value['external_id'] . '/content',
                        'headers' => [
                            'token: ' . $aArgs['config']['data']['tokenAPI'],
                            'secret: ' . $aArgs['config']['data']['secretAPI'],
                            'Content-Type: application/pdf'
                        ],
                        'method' => 'GET',
                    ]);

                    $aArgs['idsToRetrieve'][$version][$resId]['status'] = 'validated';
                    $aArgs['idsToRetrieve'][$version][$resId]['format'] = 'PDF';
                    $aArgs['idsToRetrieve'][$version][$resId]['encodedFile'] = base64_encode($response['raw']);
                }
            }
        }
        return $aArgs['idsToRetrieve'];
    }

}
