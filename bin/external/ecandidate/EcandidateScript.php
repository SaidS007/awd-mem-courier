<?php

/**
 * Copyright Maarch since 2008 under licence GPLv3.
 * See LICENCE.txt file at the root folder for more details.
 * This file is part of Maarch software.
 *
 */

/**
 * @brief E-candidate Script
 * @author pierreyvon.bezert@edissyum.com
 * @author nathan.cheval@edissyum.com
 */


Use SrcCore\models\CurlModel;
use History\controllers\HistoryController;

chdir('../../..');

require 'vendor/autoload.php';

EcandidateScript::getNewApplicationsFromEcandidate($argv);
EcandidateScript::sendNewApplicationsToEcandidate($argv);
EcandidateScript::getApplicationsResponses($argv);
EcandidateScript::sendFinalResponses($argv);


class EcandidateScript {
    public static function getNewApplicationsFromEcandidate(array $args) {
        $customId = null;
        if (!empty($args[1]) && $args[1] == '--customId' && !empty($args[2])) {
            $customId = $args[2];
        }

        $configuration = EcandidateScript::getXmlLoaded(['path' => 'bin/external/ecandidate/config.xml', 'customId' => $customId]);
        if (empty($configuration)) {
            self::writeLog($customId, ['message' => "[ERROR] [GET_APPLICATIONS] File bin/external/ecandidate/config.xml does not exist"]);
            exit();
        }

        $apiKey = (string) $configuration -> ecandidate -> apiKey;
        $ecandidateUrl = (string) $configuration -> ecandidate -> url;
        if (empty($ecandidateUrl)) {
            self::writeLog($customId, ['message' => "[ERROR] [GET_APPLICATIONS] E-Candidate url is missing"]);
            return;
        } else if (empty($apiKey)) {
            self::writeLog($customId, ['message' => "[ERROR] [GET_APPLICATIONS] E-Candidate api key is missing"]);
            return;
        }

        $memUrl      = (string) $configuration -> mem -> url;
        $memUser     = (string) $configuration -> mem -> user;
        $memPassword = (string) $configuration -> mem -> password;
        if (empty($memUrl) || empty($memUser) || empty($memPassword)) {
            self::writeLog($customId, ['message' => "[ERROR] [GET_APPLICATIONS] File bin/external/ecandidate/config.xml mem url/user/password is empty"]);
            return;
        }

        $status = (string) $configuration -> getApplications -> status;
        $typeId = (string) $configuration -> getApplications -> typeId;
        $company = (string) $configuration -> getApplications -> company;
        $modelId = (string) $configuration -> getApplications -> modelId;
        $priority = (string) $configuration -> getApplications -> priority;
        $entityId = (string) $configuration -> getApplications -> entityId;
        $destination = (string) $configuration -> getApplications -> destination;
        $contactType = (string) $configuration -> getApplications -> contactType;
        $contactPurposeId = (string) $configuration -> getApplications -> contactPurposeId;

        \SrcCore\models\DatabasePDO::reset();
        new \SrcCore\models\DatabasePDO(['customId' => $customId]);

        $responseApplications = CurlModel::exec([
            'url'       => $ecandidateUrl . '/candidatures',
            'method'    => 'GET',
            'headers'   => ["Authorization: {$apiKey}"],
            'noLogs'    => true
        ]);

        if (!empty($responseApplications['errors'])) {
            self::writeLog($customId, ['message' => "[ERROR] [GET_APPLICATIONS] [/candidature] [{$responseApplications['code']}] Error while contacting E-Candidate : {$responseApplications['response']['message']}"]);
            return;
        }

        foreach ($responseApplications['response'] as $application) {
            $applicationDetailsUrl = $ecandidateUrl . '/candidature/' . $application['id'];
            $responseApplicationDetails = CurlModel::exec([
                'url'       => $applicationDetailsUrl,
                'method'    => 'GET',
                'headers'   => ["Authorization: {$apiKey}"],
                'noLogs'    => true
            ]);

            $documents = [];
            foreach ($responseApplicationDetails['response']['documents'] as $document) {
                $applicationDocumentUrl = $applicationDetailsUrl . '/document/' . $document['id'];
                $response = CurlModel::exec([
                    'url'       => $applicationDocumentUrl,
                    'method'    => 'GET',
                    'headers'   => ["Authorization: {$apiKey}"],
                    'noLogs'    => true
                ]);

                $documents[] = [
                    'id'        => $document['id'],
                    'name'      => $response['response']['nom_document'],
                    'content'   => $response['response']['document']
                ];
            }

            $contact = [
                'email' => trim($responseApplicationDetails['response']['meta_info']['email']),
                'lastname' => trim($responseApplicationDetails['response']['meta_info']['nom']),
                'firstname' => trim($responseApplicationDetails['response']['meta_info']['prenom']),
            ];

            if (!empty($responseApplicationDetails['response']['meta_info']['telFixe'])) {
                $contact['phone'] = trim($responseApplicationDetails['response']['meta_info']['telFixe']);
                $contact['phone'] = str_replace('-', '', $contact['phone']);
            } else if (!empty($responseApplicationDetails['response']['meta_info']['telPortable'])) {
                $contact['phone'] = trim($responseApplicationDetails['response']['meta_info']['telPortable']);
                $contact['phone'] = str_replace('-', '', $contact['phone']);
            } else {
                $contact['phone'] = '';
            }

            if (empty($contact['lastname'])) {
                $contact['company']  = $company;
            }

            preg_match('/^(\d+)[, ]*(.*)/', $responseApplicationDetails['response']['meta_info']['adresse'], $matches);
            if (empty($matches)) {
                $contact['addressStreet'] = $responseApplicationDetails['response']['meta_info']['adresse'];
            } else {
                $contact['addressNumber'] = $matches[1];
                $contact['addressStreet'] = $matches[2];
            }

            $contact['externalId']      = ['e-candidate' => $application['id']];
            $contact['addressPostcode'] = trim($responseApplicationDetails['response']['meta_info']['cp']);
            $contact['addressTown']     = trim($responseApplicationDetails['response']['meta_info']['ville']);

            $response = CurlModel::exec([
                'url'       => $memUrl . '/contacts',
                'method'    => 'POST',
                'headers'   => ['content-type: application/json'],
                'basicAuth' => ['user' => $memUser, 'password' => $memPassword],
                'body'      => json_encode($contact),
                'noLogs'    => true
            ]);

            if (!in_array($response['code'], [200, 201]) && !empty($response['response']['errors'])) {
                self::writeLog($customId, ['message' => "[ERROR] [GET_APPLICATIONS] [/contacts] [{$response['code']}] Error while contacting MEM : {$response['response']['errors']}"]);
                return;
            }

            $contactId = $response['response']['id'];

            $body = [
                'modelId'       => $modelId,
                'encodedFile'   => base64_encode($responseApplicationDetails['response']['info_offre']),
                'doctype'       => $typeId,
                'status'        => $status,
                'format'        => 'html',
                'subject'       => $responseApplicationDetails['response']['meta_info']['offre'] . ' - ' . $contact['lastname'] . ' ' . $contact['firstname'],
                'externalId'    => ['e-candidate' => $application['id']],
                'senders'       => [['id' => $contactId, 'type' => 'contact']],
                'documentDate'  => $responseApplicationDetails['response']['meta_info']['created'],
                'destination'   => $entityId,
                'priority'      => $priority,
                'chrono'        => true
            ];

            $response = CurlModel::exec([
                'url'       => $memUrl . '/resources',
                'method'    => 'POST',
                'headers'   => ['content-type: application/json'],
                'basicAuth' => ['user' => $memUser, 'password' => $memPassword],
                'body'      => json_encode($body),
                'noLogs'    => false
            ]);

            if (!in_array($response['code'], [200, 201]) && !empty($response['response']['errors'])) {
                self::writeLog($customId, ['message' => "[ERROR] [GET_APPLICATIONS] [/resources] [{$response['code']}] Error while contacting MEM : {$response['response']['errors']}"]);
                return;
            }

            $resId = $response['response']['resId'];
            self::writeLog($customId, ['message' => "[INFO] [GET_APPLICATIONS] Application n°{$application['id']} retrieve to MEM Courrier with res_id {$resId}"]);

            $responseEntityDetails = CurlModel::exec([
                'url'       => $memUrl . '/entities/' . $destination .'/details',
                'method'    => 'GET',
                'headers'   => ['content-type: application/json'],
                'basicAuth' => ['user' => $memUser, 'password' => $memPassword],
                'noLogs'    => true
            ]);

            $bodyListinstanceVisa = [];
            $bodyListinstanceVisa['data']['resId'] = $resId;
            $bodyListinstanceVisa['data']['listInstances'] = [];
            foreach ($responseEntityDetails['response']['entity']['visaCircuit']['items'] as $item) {
                $bodyListinstanceVisa['data']['listInstances'][] = [
                    'difflist_type' => 'VISA_CIRCUIT',
                    'item_mode'     => $item['mode'],
                    'item_id'       => $item['id'],
                    'item_type'     => $item['type'],
                    'sequence'      => $item['sequence']
                ];
            }

            $bodyListinstanceVisa['data']['listInstances'][] = [
                'difflist_type' => 'entity_id',
                'item_mode'     => 'dest',
                'item_id'       => 'superadmin',
                'item_type'     => 'user_id'
            ];

            CurlModel::exec([
                'url'       => $memUrl . '/listinstances',
                'method'    => 'PUT',
                'headers'   => ['content-type: application/json'],
                'basicAuth' => ['user' => $memUser, 'password' => $memPassword],
                'body'      => json_encode($bodyListinstanceVisa),
                'noLogs'    => true
            ]);

            $bodyListinstanceDiff = [];
            $bodyListinstanceDiff['data']['resId'] = $resId;
            $bodyListinstanceDiff['data']['listInstances'] = [];

            $dest = $responseEntityDetails['response']['entity']['listTemplate']['items']['dest'][0];
            $bodyListinstanceDiff['data']['listInstances'][] = [
                'difflist_type' => 'entity_id',
                'item_mode'     => 'dest',
                'item_id'       => $dest['id'],
                'item_type'     => $dest['type'],
                'sequence'      => $dest['sequence']
            ];

            if (!empty($responseEntityDetails['response']['entity']['listTemplate']['items']['cc'])) {
                foreach ($responseEntityDetails['response']['entity']['listTemplate']['items']['cc'] as $item) {
                    $bodyListinstanceDiff['data']['listInstances'][] = [
                        'difflist_type' => 'entity_id',
                        'item_mode'     => 'cc',
                        'item_id'       => $item['item_id'],
                        'item_type'     => $item['item_type'],
                        'sequence'      => $item['sequence']
                    ];
                };

                CurlModel::exec([
                    'url'       => $memUrl . '/listinstances',
                    'method'    => 'PUT',
                    'headers'   => ['content-type: application/json'],
                    'basicAuth' => ['user' => $memUser, 'password' => $memPassword],
                    'body'      => json_encode($bodyListinstanceDiff),
                    'noLogs'    => true
                ]);
            }

            foreach ($documents as $document) {
                $bodyAttachment = [
                    'externalId'    => ['e-candidate' => $document['id']],
                    'format'        => 'pdf',
                    'resIdMaster'   => $resId,
                    'title'         => $document['name'],
                    'type'          => 'simple_attachment',
                    'encodedFile'   => $document['content']
                ];

                CurlModel::exec([
                    'url'       => $memUrl . '/attachments',
                    'method'    => 'POST',
                    'headers'   => ['content-type: application/json'],
                    'basicAuth' => ['user' => $memUser, 'password' => $memPassword],
                    'body'      => json_encode($bodyAttachment),
                    'noLogs'    => true
                ]);
            }

            CurlModel::exec([
                'url'       => $ecandidateUrl . '/candidature/' . $application['id'],
                'method'    => 'PUT',
                'headers'   => ["Authorization: {$apiKey}", 'Content-Type: application/x-www-form-urlencoded'],
                'body'      => 'num_maarch=' . $resId,
                'noLogs'    => false
            ]);
        }
    }

    public static function sendNewApplicationsToEcandidate(array $args) {
        $customId = null;
        if (!empty($args[1]) && $args[1] == '--customId' && !empty($args[2])) {
            $customId = $args[2];
        }

        $language = \SrcCore\models\CoreConfigModel::getLanguage();
        require_once("src/core/lang/lang-{$language}.php");
        if (file_exists("custom/{$customId}/src/core/lang/lang-{$language}.php")) {
            require_once("custom/{$customId}/src/core/lang/lang-{$language}.php");
        }

        $configuration = EcandidateScript::getXmlLoaded(['path' => 'bin/external/ecandidate/config.xml', 'customId' => $customId]);
        if (empty($configuration)) {
            self::writeLog($customId, ['message' => "[ERROR] [SEND_APPLICATIONS] File bin/external/ecandidate/config.xml does not exist"]);
            exit();
        } elseif (empty($configuration->ecandidate->apiKey)) {
            self::writeLog($customId, ['message' => "[ERROR] [SEND_APPLICATIONS] File bin/external/ecandidate/config.xml is not filled enough"]);
            return;
        }

        $apiKey = (string)$configuration->ecandidate->apiKey;
        $ecandidateUrl = (string)$configuration->ecandidate->url;
        if (empty($ecandidateUrl)) {
            self::writeLog($customId, ['message' => "[ERROR] [SEND_APPLICATIONS] E-Candidate url is missing"]);
            return;
        } else if (empty($apiKey)) {
            self::writeLog($customId, ['message' => "[ERROR] [SEND_APPLICATIONS] E-Candidate api key is missing"]);
            return;
        }

        $memUrl = (string)$configuration->mem->url;
        $memUser = (string)$configuration->mem->user;
        $memPassword = (string)$configuration->mem->password;
        if (empty($memUrl) || empty($memUser) || empty($memPassword)) {
            self::writeLog($customId, ['message' => "[ERROR] [SEND_APPLICATIONS] File bin/external/ecandidate/config.xml mem url/user/password is empty"]);
            return;
        }

        $sentApplicationsStatus = (string) $configuration -> sendApplication -> sentApplicationsStatus;
        $errorApplicationsStatus = (string) $configuration -> sendApplication -> errorApplicationsStatus;
        $awaitingApplicationsStatus = (string) $configuration -> sendApplication -> awaitingApplicationsStatus;

        \SrcCore\models\DatabasePDO::reset();
        new \SrcCore\models\DatabasePDO(['customId' => $customId]);

        $body = [
            'select'   => "res_id",
            'clause'   => "status = '$awaitingApplicationsStatus'",
            'withFile' => true,
            'orderBy'  => ["res_id DESC"]
        ];

        $response = CurlModel::exec([
            'url'       => $memUrl . '/res/list',
            'method'    => 'POST',
            'headers'   => ['content-type: application/json'],
            'basicAuth' => ['user' => $memUser, 'password' => $memPassword],
            'body'      => json_encode($body),
            'noLogs'    => true
        ]);

        if (!in_array($response['code'], [200, 201]) && !empty($response['response']['errors'])) {
            self::writeLog($customId, ['message' => "[ERROR] [SEND_APPLICATIONS] [{$response['code']}] Error while contacting MEM : {$response['response']['errors']}"]);
            return;
        }

        foreach ($response['response']['resources'] as $resource) {
            $responseResources = CurlModel::exec([
                'url' => $memUrl . '/resources/' . $resource['res_id'] . '/contacts?type=senders',
                'method' => 'GET',
                'headers' => ['content-type: application/json'],
                'basicAuth' => ['user' => $memUser, 'password' => $memPassword],
                'noLogs' => true
            ]);

            if (!empty($responseResources['response']['contacts'])) {
                $contact = $responseResources['response']['contacts'][0];
                if (!empty($contact)) {
                    if (empty($contact['lastname']) || empty($contact['firstname'])) {
                        self::writeLog($customId, ['message' => _ERROR_NAME_ECANDIDATE]);
                        \Note\models\NoteModel::create(['resId' => $resource['res_id'], 'user_id' => $contact['creator'], 'note_text' => _ERROR_NAME_ECANDIDATE]);
                        \Resource\models\ResModel::update(['set' => ['status' => $errorApplicationsStatus], 'where' => ['res_id = ?'],'data'  => [$resource['res_id']]]);
                        \History\models\BatchHistoryModel::create(['info' => _ERROR_NAME_ECANDIDATE, 'module_name' => 'e-candidate']);
                        continue;
                    } else if (empty($contact['email'])) {
                        self::writeLog($customId, ['message' => _ERROR_EMAIL_ECANDIDATE]);
                        \Note\models\NoteModel::create(['resId' => $resource['res_id'], 'user_id' => $contact['creator'], 'note_text' => _ERROR_EMAIL_ECANDIDATE]);
                        \Resource\models\ResModel::update(['set' => ['status' => $errorApplicationsStatus], 'where' => ['res_id = ?'],'data'  => [$resource['res_id']]]);
                        \History\models\BatchHistoryModel::create(['info' => _ERROR_EMAIL_ECANDIDATE, 'module_name' => 'e-candidate']);
                        continue;
                    } else if (empty($contact['addressPostcode']) || empty($contact['addressTown']) || empty($contact['addressStreet'])) {
                        self::writeLog($customId, ['message' => _ERROR_ADRESSE_ECANDIDATE]);
                        \Note\models\NoteModel::create(['resId' => $resource['res_id'], 'user_id' => $contact['creator'], 'note_text' => _ERROR_ADRESSE_ECANDIDATE]);
                        \Resource\models\ResModel::update(['set' => ['status' => $errorApplicationsStatus], 'where' => ['res_id = ?'],'data'  => [$resource['res_id']]]);
                        \History\models\BatchHistoryModel::create(['info' => _ERROR_ADRESSE_ECANDIDATE, 'module_name' => 'e-candidate']);
                        continue;
                    }

                    $bodyEcandidateApplication = [
                        "email"         => $contact['email'],
                        "idMaarch"      => $resource['res_id'],
                        "nom"           => $contact['lastname'],
                        "nom_document"  => 'Document principal',
                        "prenom"        => $contact['firstname'],
                        "ville"         => $contact['addressTown'],
                        "cp"            => $contact['addressPostcode'],
                        "document"      => $resource['fileBase64Content'],
                        "adresse"       => $contact['addressNumber'] . " " . $contact['addressStreet']
                    ];

                    $response = CurlModel::exec([
                        'url' => $ecandidateUrl . '/candidature',
                        'method' => 'POST',
                        'headers' => ["Authorization: {$apiKey}", 'content-type: application/json'],
                        'body' => json_encode($bodyEcandidateApplication),
                        'noLogs' => true
                    ]);

                    if (!in_array($response['code'], [200, 201]) && !empty($response['response']['message'])) {
                        self::writeLog($customId, ['message' => "[ERROR] [SEND_APPLICATIONS] [{$response['code']}] Error while contacting ECANDIDATE : {$response['response']['errors']}"]);
                        return;
                    }

                    $ecandidateId = $response['response']['candidature']['id'];
                    self::writeLog($customId, ['message' => "[INFO] [SEND_APPLICATIONS] Document n°{$resource['res_id']} sent to E-Candidate with id {$ecandidateId}"]);

                    $body = [
                        'externalInfos' => [
                            [
                                "app" => "e-candidate",
                                "res_id" => $resource['res_id'],
                                "external_id" => (string) $ecandidateId
                            ]
                        ],
                        'status' => $sentApplicationsStatus
                    ];

                    CurlModel::exec([
                        'url' => $memUrl . '/res/externalInfos',
                        'method' => 'PUT',
                        'headers' => ['content-type: application/json'],
                        'basicAuth' => ['user' => $memUser, 'password' => $memPassword],
                        'body' => json_encode($body),
                        'noLogs' => true
                    ]);

                    $responseAttachments = CurlModel::exec([
                        'url' => $memUrl . '/resources/' . $resource['res_id'] . '/attachments',
                        'method' => 'GET',
                        'headers' => ['content-type: application/json'],
                        'basicAuth' => ['user' => $memUser, 'password' => $memPassword],
                        'noLogs' => true
                    ]);
                    $cpt = 0;
                    foreach ($responseAttachments['response']['attachments'] as $attachment) {
                        $responseAttachments = CurlModel::exec([
                            'url'       => $memUrl . '/attachments/' . $attachment['resId'] . '/originalContent?mode=base64',
                            'method'    => 'GET',
                            'headers'   => ['content-type: application/json'],
                            'basicAuth' => ['user' => $memUser, 'password' => $memPassword],
                            'noLogs'    => true
                        ]);

                        $bodyEcandidateApplicationAttachment = [
                            "nom_document"  => $attachment['title'] ?? 'Document ' . $cpt,
                            "document"      => $responseAttachments['response']['encodedDocument']
                        ];

                        $responseInsertAttachment = CurlModel::exec([
                            'url'       => $ecandidateUrl . '/candidature/' . $ecandidateId . '/uploadDoc',
                            'method'    => 'POST',
                            'headers'   => ["Authorization: {$apiKey}", 'content-type: application/json'],
                            'body'      => json_encode($bodyEcandidateApplicationAttachment),
                            'noLogs'    => true
                        ]);

                        if (!in_array($responseInsertAttachment['code'], [200, 201]) && !empty($responseInsertAttachment['response']['message'])) {
                            self::writeLog($customId, ['message' => "[ERROR] [SEND_APPLICATIONS] [/candidature/{$ecandidateId}/uploadDoc] [{$responseInsertAttachment['code']}] Error while contacting E-Candidate : {$responseInsertAttachment['response']['message']}"]);
                            return;
                        }
                        self::writeLog($customId, ['message' => "[INFO] [SEND_APPLICATIONS] Attachment n°{$attachment['resId']} sent to E-Candidate with id {$ecandidateId}"]);
                        $cpt++;
                    }

                    $user = \User\models\UserModel::get(['select' => ['id'], 'where' => ["mode = 'root_invisible'"], 'limit' => 1]);
                    if ($user) {
                        HistoryController::add([
                            'tableName' => 'res_letterbox',
                            'recordId' => $resource['res_id'],
                            'eventType' => 'ADD',
                            'userId' => $user[0]['id'],
                            'info' => _ADD_TO_ECANDIDATE . ' ' . $ecandidateId,
                            'moduleId' => 'resource',
                            'eventId' => 'sendToEcandidate'
                        ]);
                    }
                }
            }
        }
    }

    public static function getApplicationsResponses(array $args) {
        $customId = null;
        if (!empty($args[1]) && $args[1] == '--customId' && !empty($args[2])) {
            $customId = $args[2];
        }

        $configuration = EcandidateScript::getXmlLoaded(['path' => 'bin/external/ecandidate/config.xml', 'customId' => $customId]);
        if (empty($configuration)) {
            self::writeLog($customId, ['message' => "[ERROR] [GET_RESPONSES] File bin/external/ecandidate/config.xml does not exist"]);
            exit();
        } elseif (empty($configuration -> ecandidate -> apiKey)) {
            self::writeLog($customId, ['message' => "[ERROR] [GET_RESPONSES] File bin/external/ecandidate/config.xml is not filled enough"]);
            return;
        }

        $apiKey = (string) $configuration -> ecandidate -> apiKey;
        $ecandidateUrl = (string) $configuration -> ecandidate -> url;
        if (empty($ecandidateUrl)) {
            self::writeLog($customId, ['message' => "[ERROR] [GET_APPLICATIONS] E-Candidate url is missing"]);
            return;
        } else if (empty($apiKey)) {
            self::writeLog($customId, ['message' => "[ERROR] [GET_APPLICATIONS] E-Candidate api key is missing"]);
            return;
        }

        $memUrl = (string) $configuration -> mem -> url;
        $memUser = (string) $configuration -> mem -> user;
        $memPassword = (string) $configuration -> mem -> password;
        $visaStatus = (string) $configuration -> getResponses -> visaStatus;
        if (empty($memUrl) || empty($memUser) || empty($memPassword)) {
            self::writeLog($customId, ['message' => "[ERROR] [GET_RESPONSES] File bin/external/ecandidate/config.xml mem url/user/password is empty"]);
            return;
        }


        \SrcCore\models\DatabasePDO::reset();
        new \SrcCore\models\DatabasePDO(['customId' => $customId]);

        $responseApplicationResponseContent = CurlModel::exec([
            'url'       => $ecandidateUrl . '/reponses',
            'method'    => 'GET',
            'headers'   => ["Authorization: {$apiKey}"],
            'noLogs'    => true
        ]);

        foreach ($responseApplicationResponseContent['response'] as $response) {
            $resource = \Resource\models\ResModel::get([
                'select' => ['res_id', 'destination', 'type_id'],
                'where'  => ["external_id ->> 'e-candidate' = ?"],
                'data'   => [$response['id_candidature']],
                'limit'  => 1
            ]);

            if (!$resource) {
                self::writeLog($customId, ['message' => "[ERROR] [GET_RESPONSES] Resource not found for response {$response['id_reponse']}"]);
                continue;
            }

            $resId = $resource[0]['res_id'];
            $typeId = $resource[0]['type_id'];
            $destination = $resource[0]['destination'];

            $preAllocatedChrono = \Resource\models\ChronoModel::getChrono([
                'id'        => 'outgoing',
                'entityId'  => $destination,
                'typeId'    => $typeId,
                'resId'     => $resId
            ]);

            # Mettre à jour le numéro de chrono dans l'application E-Candidate
            CurlModel::exec([
                'url'       => $ecandidateUrl . '/reponses/' . $response['id_candidature'] . '/' . $response['id_reponse'] . '/numChrono',
                'method'    => 'PUT',
                'headers'   => ["Authorization: {$apiKey}", 'Content-Type: application/x-www-form-urlencoded'],
                'body'      => 'num_chrono=' . rawurlencode($preAllocatedChrono),
                'noLogs'    => false
            ]);

            $responseApplicationResponseContent = CurlModel::exec([
                'url'       => $ecandidateUrl .'/reponses/' . $response['id_candidature']  . '/' . $response['id_reponse'],
                'method'    => 'GET',
                'headers'   => ["Authorization: {$apiKey}"],
                'noLogs'    => true
            ]);

            $attachmentBody = [
                'encodedFile'     => $responseApplicationResponseContent['response']['corps'],
                'format'          => 'docx',
                'resIdMaster'     => $resId,
                'type'            => 'response_project',
                'title'           => $responseApplicationResponseContent['response']['sujet'],
                'chrono'          => $preAllocatedChrono,
                'inSignatureBook' => true,
                'externalId'      => ['e-candidate' => [
                    "id_reponse"     => $response['id_reponse'],
                    "id_candidature" => $response['id_candidature']
                ]],
            ];

            CurlModel::exec([
                'url'       => $memUrl . '/attachments',
                'method'    => 'POST',
                'headers'   => ['content-type: application/json'],
                'basicAuth' => ['user' => $memUser, 'password' => $memPassword],
                'body'      => json_encode($attachmentBody),
                'noLogs'    => true
            ]);

            $changeStatusBody = [
                "resId" => [$resId],
                "status" => $visaStatus
            ];

            CurlModel::exec([
                'url'       => $memUrl . '/res/resource/status',
                'method'    => 'PUT',
                'headers'   => ['content-type: application/json'],
                'basicAuth' => ['user' => $memUser, 'password' => $memPassword],
                'body'      => json_encode($changeStatusBody),
                'noLogs'    => true
            ]);

            $responseEntityDetails = CurlModel::exec([
                'url'       => $memUrl . '/entities/' . $destination . '/details',
                'method'    => 'GET',
                'headers'   => ['content-type: application/json'],
                'basicAuth' => ['user' => $memUser, 'password' => $memPassword],
                'noLogs'    => true
            ]);

            $bodyListinstanceVisa = [];
            $bodyListinstanceVisa['data']['resId'] = $resId;
            $bodyListinstanceVisa['data']['listInstances'] = [];
            if (isset($responseEntityDetails['response']['entity']['visaTemplate'])) {
                foreach ($responseEntityDetails['response']['entity']['visaTemplate'] as $item) {
                    $bodyListinstanceVisa['data']['listInstances'][] = [
                        'difflist_type' => 'VISA_CIRCUIT',
                        'item_mode'     => $item['item_mode'],
                        'item_id'       => $item['item_id'],
                        'item_type'     => $item['item_type'],
                        'sequence'      => $item['sequence']
                    ];
                }
            }

            $bodyListinstanceVisa['data']['listInstances'][] = [
                'difflist_type' => 'entity_id',
                'item_mode'     => 'dest',
                'item_id'       => 'superadmin',
                'item_type'     => 'user_id'
            ];

            CurlModel::exec([
                'url'       => $memUrl . '/listinstances',
                'method'    => 'PUT',
                'headers'   => ['content-type: application/json'],
                'basicAuth' => ['user' => $memUser, 'password' => $memPassword],
                'body'      => json_encode($bodyListinstanceVisa),
                'noLogs'    => true
            ]);

            $bodyListinstanceDiff = [];
            $bodyListinstanceDiff['data']['resId'] = $resId;
            $bodyListinstanceDiff['data']['listInstances'] = [];

            if (isset($responseEntityDetails['response']['entity']['listTemplate']['dest'])) {
                $dest = $responseEntityDetails['response']['entity']['listTemplate']['dest'][0];
                $bodyListinstanceDiff['data']['listInstances'][] = [
                    'difflist_type' => 'entity_id',
                    'item_mode'     => 'dest',
                    'item_id'       => $dest['item_id'],
                    'item_type'     => $dest['item_type'],
                    'sequence'      => $dest['sequence']
                ];
            }

            if (isset($responseEntityDetails['response']['entity']['listTemplate']['cc'])) {
                foreach ($responseEntityDetails['response']['entity']['listTemplate']['cc'] as $item) {
                    $bodyListinstanceDiff['data']['listInstances'][] = [
                        'difflist_type' => 'entity_id',
                        'item_mode'     => 'cc',
                        'item_id'       => $item['item_id'],
                        'item_type'     => $item['item_type'],
                        'sequence'      => $item['sequence']
                    ];

                }
            }

            if (!empty($bodyListinstanceDiff['data']['listInstances'])) {
                CurlModel::exec([
                    'url'       => $memUrl . '/listinstances',
                    'method'    => 'PUT',
                    'headers'   => ['content-type: application/json'],
                    'basicAuth' => ['user' => $memUser, 'password' => $memPassword],
                    'body'      => json_encode($bodyListinstanceDiff),
                    'noLogs'    => true
                ]);
            }
        }
    }

    public static function sendFinalResponses(array $args) {
        $customId = null;
        if (!empty($args[1]) && $args[1] == '--customId' && !empty($args[2])) {
            $customId = $args[2];
        }

        $configuration = EcandidateScript::getXmlLoaded(['path' => 'bin/external/ecandidate/config.xml', 'customId' => $customId]);
        if (empty($configuration)) {
            self::writeLog($customId, ['message' => "[ERROR] [GET_APPLICATIONS] File bin/external/ecandidate/config.xml does not exist"]);
            exit();
        } elseif (empty($configuration -> ecandidate -> apiKey)) {
            self::writeLog($customId, ['message' => "[ERROR] [GET_APPLICATIONS] apiKey is missing"]);
            return;
        }

        $language = \SrcCore\models\CoreConfigModel::getLanguage();
        require_once("src/core/lang/lang-{$language}.php");
        if (file_exists("custom/{$customId}/src/core/lang/lang-{$language}.php")) {
            require_once("custom/{$customId}/src/core/lang/lang-{$language}.php");
        }

        $apiKey = (string) $configuration -> ecandidate -> apiKey;
        $ecandidateUrl = (string) $configuration -> ecandidate -> url;
        if (empty($ecandidateUrl)) {
            self::writeLog($customId, ['message' => "[ERROR] [SEND_FINAL_RESPONSE] E-Candidate url is missing"]);
            return;
        } else if (empty($apiKey)) {
            self::writeLog($customId, ['message' => "[ERROR] [SEND_FINAL_RESPONSE] E-Candidate api key is missing"]);
            return;
        }

        $memUrl      = (string) $configuration -> mem -> url;
        $memUser     = (string) $configuration -> mem -> user;
        $memPassword = (string) $configuration -> mem -> password;
        if (empty($memUrl) || empty($memUser) || empty($memPassword)) {
            self::writeLog($customId, ['message' => "[ERROR] [SEND_FINAL_RESPONSE] File bin/external/ecandidate/config.xml mem url/user/password is empty"]);
            return;
        }

        \SrcCore\models\DatabasePDO::reset();
        new \SrcCore\models\DatabasePDO(['customId' => $customId]);

        $signedResponses = \SrcCore\models\DatabaseModel::select([
            'select'    => [
                "res_attachments.res_id",
                "res_id_master",
                "res_attachments.external_id #>> '{e-candidate, id_reponse}' as reponse_id",
                "res_attachments.external_id #>> '{e-candidate, id_candidature}' as candidature_id"
            ],
            'table'     => ['res_attachments', 'res_letterbox'],
            'left_join' => ['res_attachments.res_id_master = res_letterbox.res_id'],
            'where'     => ["attachment_type = ?", "res_attachments.status = ?", "res_letterbox.status <> ?", "res_attachments.external_id ->> 'e-candidate' IS NOT NULL"],
            'data'      => ['signed_response', 'SIGN', 'WIMP']
        ]);

        if ($signedResponses) {
            foreach ($signedResponses as $signedResponse) {
                $encodedContent = \Attachment\controllers\AttachmentController::getEncodedDocument(['id' => $signedResponse['res_id']]);
                $bodyEcandidateApplicationAttachment = [
                    'sujet' => _DOCUMENT_SIGNED,
                    'corps' => $encodedContent['encodedDocument']
                ];
                $bodyEcandidateAttachmentUploadDoc = [
                    'nom_document' => _DOCUMENT_SIGNED,
                    'document' => $encodedContent['encodedDocument']
                ];

                $sendSignedResponse = CurlModel::exec([
                    'url'       => $ecandidateUrl . '/reponses/' . $signedResponse['candidature_id']  . '/' . $signedResponse['reponse_id'],
                    'method'    => 'PUT',
                    'headers'   => ["Authorization: {$apiKey}", 'content-type: application/json'],
                    'body'      => json_encode($bodyEcandidateApplicationAttachment),
                    'noLogs'    => true
                ]);

                if (!in_array($sendSignedResponse['code'], [200, 201]) && !empty($sendSignedResponse['response']['message'])) {
                    self::writeLog($customId, ['message' => "[ERROR] [SEND_FINAL_RESPONSE] [{$sendSignedResponse['code']}] Error while contacting E-Candidate : {$sendSignedResponse['response']['message']}"]);
                    continue;
                }

                $sendSignedResponse = CurlModel::exec([
                    'url'       => $ecandidateUrl . '/candidature/' . $signedResponse['candidature_id'] . '/uploadDoc',
                    'method'    => 'POST',
                    'headers'   => ["Authorization: {$apiKey}", 'content-type: application/json'],
                    'body'      => json_encode($bodyEcandidateAttachmentUploadDoc),
                    'noLogs'    => true
                ]);

                if (!in_array($sendSignedResponse['code'], [200, 201])) {
                    $message = $sendSignedResponse['response']['error']['message'] ?? $sendSignedResponse['response']['message'];
                    self::writeLog($customId, ['message' => "[ERROR] [SEND_FINAL_RESPONSE] [{$sendSignedResponse['code']}] Error while contacting E-Candidate : {$message}"]);
                    continue;
                }
                self::writeLog($customId, ['message' => "[INFO] [SEND_FINAL_RESPONSE] Signed attachment n°{$signedResponse['res_id']} sent to E-Candidate with id {$signedResponse['candidature_id']}"]);
                var_dump($signedResponse['res_id_master']);

                \Resource\models\ResModel::update([
                    'set' => ['status' => 'WIMP'],
                    'where' => ['res_id = ?'],
                    'data' => [$signedResponse['res_id_master']]
                ]);
            }
        }
    }

    public static function getXmlLoaded(array $args) {
        if (!empty($args['customId']) && file_exists("custom/{$args['customId']}/{$args['path']}")) {
            $path = "custom/{$args['customId']}/{$args['path']}";
        }
        if (empty($path)) {
            $path = $args['path'];
        }

        $xmlfile = null;
        if (file_exists($path)) {
            $xmlfile = simplexml_load_file($path);
        }

        return $xmlfile;
    }

    public static function writeLog($customId, array $args) {
        if ($customId) {
            $file = fopen("custom/{$customId}/bin/external/ecandidate/EcandidateScript.log", 'a+');
        } else {
            $file = fopen('bin/external/ecandidate/EcandidateScript.log', 'a+');
        }

        fwrite($file, '[' . date('Y-m-d H:i:s') . '] ' . $args['message'] . PHP_EOL);
        fclose($file);

        if (str_starts_with($args['message'], '[ERROR]')) {
            \SrcCore\controllers\LogsController::add([
                'isTech'    => true,
                'moduleId'  => 'E-Candidate',
                'level'     => 'ERROR',
                'tableName' => '',
                'recordId'  => 'E-Candidate',
                'eventType' => 'E-Candidate',
                'eventId'   => $args['message']
            ]);
        } else {
            \SrcCore\controllers\LogsController::add([
                'isTech'    => true,
                'moduleId'  => 'E-Candidate',
                'level'     => 'INFO',
                'tableName' => '',
                'recordId'  => 'E-Candidate',
                'eventType' => 'E-Candidate',
                'eventId'   => $args['message']
            ]);
        }

        \History\models\BatchHistoryModel::create(['info' => $args['message'], 'module_name' => 'E-Candidate']);
    }
}
