<?php

namespace ExternalSignatoryBook\controllers;

use Attachment\models\AttachmentModel;
use Attachment\models\AttachmentTypeModel;
use Convert\controllers\ConvertPdfController;
use Docserver\models\DocserverModel;
use Entity\models\ListInstanceModel;
use Resource\controllers\ResController;
use Resource\models\ResModel;
use Respect\Validation\Validator;
use SrcCore\models\CoreConfigModel;
use SrcCore\models\CurlModel;
use User\models\UserModel;
use Group\controllers\PrivilegeController;
use Entity\models\ListInstanceHistoryDetailModel;
use History\controllers\HistoryController;
use Action\models\ActionModel;
use Slim\Psr7\Request;
use Slim\Psr7\Response;
use SrcCore\models\DatabaseModel;

class LexPersonaController
{
    public static function CreateWorkflow($aArgs)
    {
        $bodyData = [
            "name" => "[MEM] " . $aArgs['subject'],
            "steps" => [],
            "templateId" => $aArgs['config']['data']['templateId'],
            "notifiedEvents" => [],
            "watchers" => [],
        ];

        if(!empty($aArgs['observerUser'])){
            $bodyData["watchers"][] = [
                "email" => $aArgs['observerUser'],
                "notifiedEvents" => []
            ];
            //notifiedEvents: CC
            if ($aArgs['config']['data']['notifiedEventsCC']->recipientRefused == 'Y') {
                $bodyData["watchers"][0]["notifiedEvents"][] = "recipientRefused";
            }
            if ($aArgs['config']['data']['notifiedEventsCC']->recipientFinished == 'Y') {
                $bodyData["watchers"][0]["notifiedEvents"][] = "recipientFinished";
            }
            if ($aArgs['config']['data']['notifiedEventsCC']->workflowStarted == 'Y') {
                $bodyData["watchers"][0]["notifiedEvents"][] = "workflowStarted";
            }
            if ($aArgs['config']['data']['notifiedEventsCC']->workflowStopped == 'Y') {
                $bodyData["watchers"][0]["notifiedEvents"][] = "workflowStopped";
            }
            if ($aArgs['config']['data']['notifiedEventsCC']->workflowFinished == 'Y') {
                $bodyData["watchers"][0]["notifiedEvents"][] = "workflowFinished";
            }
            if ($aArgs['config']['data']['notifiedEventsCC']->workflowFinishedDownloadLink == 'Y') {
                $bodyData["watchers"][0]["notifiedEvents"][] = "workflowFinishedDownloadLink";
            }
        }


        //notifiedEvent: Owner
        if ($aArgs['config']['data']['notifiedEventsOwner']->recipientRefused == 'Y') {
            $bodyData["notifiedEvents"][] = "recipientRefused";
        }
        if ($aArgs['config']['data']['notifiedEventsOwner']->recipientFinished == 'Y') {
            $bodyData["notifiedEvents"][] = "recipientFinished";
        }
        if ($aArgs['config']['data']['notifiedEventsOwner']->workflowStarted == 'Y') {
            $bodyData["notifiedEvents"][] = "workflowStarted";
        }
        if ($aArgs['config']['data']['notifiedEventsOwner']->workflowStopped == 'Y') {
            $bodyData["notifiedEvents"][] = "workflowStopped";
        }
        if ($aArgs['config']['data']['notifiedEventsOwner']->workflowFinished == 'Y') {
            $bodyData["notifiedEvents"][] = "workflowFinished";
        }
        if ($aArgs['config']['data']['notifiedEventsOwner']->workflowFinishedDownloadLink == 'Y') {
            $bodyData["notifiedEvents"][] = "workflowFinishedDownloadLink";
        }


        // Search For consentPage :
        $curlResponse = CurlModel::exec([
            'url'           => rtrim($aArgs['config']['data']['url']) . '/api/consentPages',
            'headers'       => ['Authorization: Bearer ' . $aArgs['config']['data']['tokenAPI']],
            'method'        => 'GET',
            'queryParams' => ['items.name' => urlencode($aArgs['config']['data']['consentPage'])],
        ]);

        if (empty($curlResponse['response']['items'])) {
            return ['errors' => 'La page de consentement' . $aArgs['config']['data']['consentPage'] . ' n\'existe pas'];
        }
        else {
            $consentPage = $curlResponse['response']['items'][0]['id'];
        }

        //Search for approvalConsentPage
        $curlResponse = CurlModel::exec([
            'url'           => rtrim($aArgs['config']['data']['url']) . '/api/consentPages',
            'headers'       => ['Authorization: Bearer ' . $aArgs['config']['data']['tokenAPI']],
            'method'        => 'GET',
            'queryParams' => ['items.name' => urlencode($aArgs['config']['data']['approvalConsentPage'])],
        ]);

        if (empty($curlResponse['response']['items'])) {
            return ['errors' => 'La page de consentement' . $aArgs['config']['data']['consentPage'] . ' n\'existe pas'];
        }
        else {
            $defaultApprovalConsentPage = $curlResponse['response']['items'][0]['id'];
        }
        $exist = false;
        //pre-process to verify visa-workflow users on Api Side.
        foreach ($aArgs['listInstance'] as $key => $value) {

            //to be deleted later
            if ($aArgs['config']['data']['externalIdMandatory'] == 'N') {
                $url = rtrim($aArgs['config']['data']['url']) . '/api/users/?items.email=' . $value['userMail'];
            }
            else {
                $url  = rtrim($aArgs['config']['data']['url']) . '/api/users/?items.id=' . $value['external_id']['lexPersonaId'];
            }
            $curlResponse = CurlModel::exec([
                'url'           => $url,
                'headers'       => ['Authorization: Bearer ' . $aArgs['config']['data']['tokenAPI'], 'Content-Type: application/json'],
                'method'        => 'GET',
            ]);
            if ($curlResponse['code'] != 200) {
                return ['errors' => $curlResponse['errors']];
            }
            elseif (empty($curlResponse['response']['items'])) {
                return ['errors' => 'L\'utilisateur ' . $value['userMail'] . ' n\'existe pas dans LexPersona'];
            }
            $userIdLexPersona = $curlResponse['response']['items'][0]['id'];
            $userEmailLexPersona = $curlResponse['response']['items'][0]['email'];
            $userPreferences = UserModel::getById([
                'select' => ['preferences'],
                'id' => $value['item_id']
            ]);
            $preferences = json_decode($userPreferences['preferences'], true);

            if ($value['item_mode'] == 'visa' && $aArgs['config']['data']['groupApproval'] == 'Y') {
                foreach ($bodyData['steps'] as $key => $value) {
                    if ($value["stepType"] == "approval" && !empty($preferences['consentPage'])) {
                        $bodyData['steps'][intval($key)]['recipients'][] = ["consentPageId" => $preferences['consentPage'],  "userId" => $userIdLexPersona,  "email" => $userEmailLexPersona];
                        $exist = true;
                        break;
                    }
                    if ($value["stepType"] == "approval") {
                        $bodyData['steps'][intval($key)]['recipients'][] = ["consentPageId" => $defaultApprovalConsentPage,  "userId" => $userIdLexPersona,  "email" => $userEmailLexPersona];
                        $exist = true;
                        break;
                    }
                }
                if (!$exist) {
                    $bodyData['steps'][] = [
                        "stepType" => "approval",
                        "recipients" => [],
                        "maxInvites" => $aArgs['config']['data']['maxInvites'],
                        "validityPeriod" => $aArgs['config']['data']['validityPeriod']
                    ];
                    $index = count($bodyData["steps"]) - 1;
                    if (!empty($preferences['consentPage'])) {
                        $bodyData['steps'][$index]['recipients'][] = ["consentPageId" => $preferences['consentPage'],  "userId" => $userIdLexPersona,  "email" => $userEmailLexPersona];
                    }
                    else {
                        $bodyData['steps'][$index]['recipients'][] = ["consentPageId" => $defaultApprovalConsentPage,  "userId" => $userIdLexPersona,  "email" => $userEmailLexPersona];
                    }
                }
            }
            elseif ($value['item_mode'] == 'visa' && $aArgs['config']['data']['groupApproval'] == 'N') {
                $bodyData['steps'][] = [
                    "stepType" => "approval",
                    "recipients" => [["consentPageId" => $defaultApprovalConsentPage,  "userId" => $userIdLexPersona,  "email" => $userEmailLexPersona]],
                    "maxInvites" => $aArgs['config']['data']['maxInvites'],
                    "validityPeriod" => $aArgs['config']['data']['validityPeriod']
                ];
            }
            elseif ($value['item_mode'] == 'sign' && $aArgs['config']['data']['groupSignatory'] == 'Y') {
                foreach ($bodyData['steps'] as $key => $value) {
                    if ($value["stepType"] == "signature" && !empty($preferences['consentPage'])) {
                        $recipient = ["consentPageId" => $preferences['consentPage'],  "userId" => $userIdLexPersona,  "email" => $userEmailLexPersona];
                        if ($value['selectedOrganizationId'] != 'Aucune fonction') {
                            $recipient["organizationId"] = $value['selectedOrganizationId'];
                        }
                        $bodyData['steps'][intval($key)]['recipients'][] = $recipient;
                        $exist = true;
                        break;
                    }
                    if ($value["stepType"] == "signature") {
                        $recipient = ["consentPageId" => $consentPage,  "userId" => $userIdLexPersona,  "email" => $userEmailLexPersona];
                        if ($value['selectedOrganizationId'] != 'Aucune fonction') {
                            $recipient["organizationId"] = $value['selectedOrganizationId'];
                        }
                        $bodyData['steps'][intval($key)]['recipients'][] = $recipient;
                        $exist = true;
                        break;
                    }
                }
                if (!$exist) {
                    $bodyData['steps'][] = [
                        "stepType" => "signature",
                        "recipients" => [],
                        "maxInvites" => $aArgs['config']['data']['maxInvites'],
                        "validityPeriod" => $aArgs['config']['data']['validityPeriod']
                    ];
                    $index = count($bodyData["steps"]) - 1;
                    if (!empty($preferences['consentPage'])) {
                        $recipient = [
                            "consentPageId" => $preferences['consentPage'],
                            "userId" => $userIdLexPersona,
                            "email" => $userEmailLexPersona
                        ];
                        if ($value['selectedOrganizationId'] != 'Aucune fonction') {
                            $recipient["organizationId"] = $value['selectedOrganizationId'];
                        }
                        $bodyData['steps'][$index]['recipients'][] = $recipient;
                    } else {
                        $recipient = [
                            "consentPageId" => $consentPage,
                            "userId" => $userIdLexPersona,
                            "email" => $userEmailLexPersona
                        ];
                        if ($value['selectedOrganizationId'] != 'Aucune fonction') {
                            $recipient["organizationId"] = $value['selectedOrganizationId'];
                        }
                        $bodyData['steps'][$index]['recipients'][] = $recipient;
                    }
                }
            }
            elseif ($value['item_mode'] == 'sign' && $value['selectedOrganizationId'] == 'Aucune fonction' && $aArgs['config']['data']['groupSignatory'] == 'N') {
                $bodyData['steps'][] = [
                    "stepType" => "signature",
                    "recipients" => [["consentPageId" => $consentPage,  "userId" => $userIdLexPersona,  "email" => $userEmailLexPersona]],
                    "maxInvites" => $aArgs['config']['data']['maxInvites'],
                    "validityPeriod" => $aArgs['config']['data']['validityPeriod']
                ];
            }
            else {
                $bodyData['steps'][] = [
                    "stepType" => "signature",
                    "recipients" => [["consentPageId" => $consentPage,  "userId" => $userIdLexPersona,  "email" => $userEmailLexPersona, "organizationId"=>  $value['selectedOrganizationId']]],
                    "maxInvites" => $aArgs['config']['data']['maxInvites'],
                    "validityPeriod" => $aArgs['config']['data']['validityPeriod']
                ];
            }
        }
        $curlResponse = CurlModel::exec([
            'url'           => rtrim($aArgs['config']['data']['url']) . '/api/users/' . $aArgs['config']['data']['userId'] . '/workflows',
            'headers'       => ['Authorization: Bearer ' . $aArgs['config']['data']['tokenAPI'], 'Content-Type: application/json'],
            'method'        => 'POST',
            'body'          => json_encode($bodyData)
        ]);

        if (empty($curlResponse['response']['id'])) {
            return ['errors' => 'workflow n a pas pu être crée'];
        }
        return ['workflowId' =>  $curlResponse["response"]["id"]];
    }

    public static function handleResponse($aArgs) {
        if ($aArgs['curlResponse']['code'] != 200) {
            CurlModel::exec([
                'url'           => rtrim($aArgs['config']['data']['url']) . '/api/workflows/' . $aArgs['workflowId'],
                'headers'       => ['Authorization: Bearer ' . $aArgs['config']['data']['tokenAPI'], 'Content-Type: application/json'],
                'method'        => 'DELETE',
            ]);
            return ['error' => 'Error during sending documents : ' . json_encode($aArgs['curlResponse']['response']['message'])];
        }
        if (!empty($aArgs['curlResponse']['response']['documents'][0]['id'])) {
            $info = "{$aArgs['action']['label_action']} : [{$aArgs['type']}] " . $aArgs['curlResponse']['response']['documents'][0]['id'];
            HistoryController::add([
                'tableName' => 'res_letterbox',
                'recordId'  => $aArgs['resIdMaster'],
                'eventType' => 'ACTION#' . $aArgs['action']['id'],
                'info'      => $info,
                'moduleId'  => 'resource',
                'eventId'   => "{$aArgs['action']['id']}"
            ]);
            return ['documentId' => $aArgs['curlResponse']['response']['documents'][0]['id']];
        }
    }


    public static function sendDatas($aArgs)
    {
        if (!Validator::intVal()->validate($aArgs['resIdMaster']) || !ResController::hasRightByResId(['resId' => [$aArgs['resIdMaster']], 'userId' => $GLOBALS['id']])) {
            return ['error' => 'Document out of perimeter'];
        }
        $listInstances = $aArgs['data'];
        // Check if no visa circuit is defined
        if (empty($listInstances)) {
            return ['error' => "Veuillez définir un circuit de visa" ];
        }
        foreach ($listInstances as $key => $value) {
            $user = UserModel::getById(['id' => $value['item_id']]);
            $listInstances[$key]['userMail'] = $user['mail'];
            $listInstances[$key]['userFirstName'] = $user['firstname'];
            $listInstances[$key]['external_id'] = json_decode($user['external_id'], true);
        }

        // Get the record from the res_letterBox table
        $mainResource = ResModel::getById([
            'select' => ['res_id', 'subject', 'path', 'filename', 'docserver_id', 'format', 'category_id', 'external_id', 'integrations', 'subject', 'dest_user'],
            'resId'  => $aArgs['resIdMaster']
        ]);
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

        $hasSignableAttachment = false;
        if ($mainResource['category_id'] == 'incoming') {
            foreach ($attachments as $key => $value) {
                if ($attachmentTypes[$value['attachment_type']]) {
                    $hasSignableAttachment = true;
                    break;
                }
            }
            if (!$hasSignableAttachment) {
                return ['error' => 'Veuillez ajouter au moins un document à signer.'];
            }
        }

        if ($aArgs['config']['data']['addCC'] == 'Y') {
            // getConnectedUsers
            $writer = UserModel::getById([
                'select' => ['mail'],
                'id' => $mainResource['dest_user']
            ]);
            $sentInfo = LexPersonaController::CreateWorkflow([
                'config' => $aArgs['config'],
                'listInstance' => $listInstances,
                'subject' => $mainResource['subject'],
                'observerUser' => $writer['mail']
            ]);
        }
        else{
            $sentInfo = LexPersonaController::CreateWorkflow([
                'config' => $aArgs['config'],
                'listInstance' => $listInstances,
                'subject' => $mainResource['subject']
            ]);
        }


        if (!empty($sentInfo['errors'])) {
            return ['error' => $sentInfo['errors']];
        }
        $currentUser = UserModel::getById(['id' => $GLOBALS['id'], 'select' => ['firstname', 'lastname']]);
        if (!empty($aArgs['note']) && $aArgs['config']['data']['sendAnnotation'] == 'Y') {
            $curlResponse = CurlModel::exec([
                'url'           => rtrim($aArgs['config']['data']['url']) . '/api/workflows/' . $sentInfo['workflowId'] . '/comments',
                'headers'       => ['Authorization: Bearer ' . $aArgs['config']['data']['tokenAPI'], 'Content-Type: application/json'],
                'method'        => 'POST',
                'body'          => json_encode([ 'content' => _PREFIXE_NOTE_LEXPERSONA . ' ' . $currentUser['firstname']. ' ' . $currentUser['lastname'] . '] ' . $aArgs['note'] , 'isPublic' => true,]),
            ]);
        }

        $mainDocumentIntegration = json_decode($mainResource['integrations'], true);
        $externalId              = json_decode($mainResource['external_id'], true);
        $action = ActionModel::getById(['id' => $aArgs['actionId']]);
        $collId = 'letterbox_coll';
        $attachmentToFreeze = [];
        // Save the current working directory
        $current_dir = getcwd();

        // Send main document if in signature book
        if ($mainDocumentIntegration['inSignatureBook'] && empty($externalId['signatureBookId']) && $mainResource['category_id'] == 'incoming' && !empty($mainResource['docserver_id'])) {

            $adrMainInfo = ConvertPdfController::getConvertedPdfById(['resId' => $aArgs['resIdMaster'], 'collId' => 'letterbox_coll']);
            $letterboxPath = DocserverModel::getByDocserverId(['docserverId' => $adrMainInfo['docserver_id'], 'select' => ['path_template']]);
            $mainDocumentFilePath = $letterboxPath['path_template'] . str_replace('#', '/', $adrMainInfo['path']) . $adrMainInfo['filename'];
            $directoryPath = $letterboxPath['path_template'] . str_replace('#', '/', $adrMainInfo['path']);
            $fileName = $adrMainInfo['filename'];
            chdir($directoryPath);

            // First Query To create a BLOB:
            $curlResponse = CurlModel::exec([
                'url'           => rtrim($aArgs['config']['data']['url']) . '/api/workflows/' . $sentInfo['workflowId']. '/blobs',
                'headers'       => ['Authorization: Bearer ' . $aArgs['config']['data']['tokenAPI'], 'Content-Type: application/octet-stream'],
                'method'        => 'POST',
                'body' => file_get_contents($fileName)
            ]);

            $idBlob = $curlResponse['response']['id'];
            $bodyData = [
                "parts" => [
                    [
                        "blobs" => [$idBlob],
                        "contentType" => "application/pdf",
                        "filename" => "PJ_doc.pdf"
                    ]
                ]
            ];

            // Second Query to save the blob
            $curlResponse = CurlModel::exec([
                'url'           => rtrim($aArgs['config']['data']['url']) . '/api/workflows/' . $sentInfo['workflowId']. '/blobs/parts?createDocuments=true&ignoreAttachments=false&unzip=true&signatureProfileId=',
                'headers'       => ['Authorization: Bearer ' . $aArgs['config']['data']['tokenAPI'], 'Content-Type: application/json'],
                'method'        => 'POST',
                'body'          => json_encode($bodyData)
            ]);

            $response = LexPersonaController::handleResponse([
                'config' => $aArgs['config'],
                'workflowId' => $sentInfo['workflowId'],
                'curlResponse' => $curlResponse,
                'action' => $action,
                'resIdMaster' => $aArgs['resIdMaster'],
                'type' => 'Document Principal'
            ]);
            if (!empty($response['error'])) {
                return ['error' => $response['error']];
            }
        }

        // Send main document if in signature book
        if ($mainDocumentIntegration['inSignatureBook'] && empty($externalId['signatureBookId']) && $mainResource['category_id'] != 'incoming') {
            if (!empty($mainResource['docserver_id'])) {
                $adrMainInfo = ConvertPdfController::getConvertedPdfById(['resId' => $aArgs['resIdMaster'], 'collId' => 'letterbox_coll']);
                $letterboxPath = DocserverModel::getByDocserverId(['docserverId' => $adrMainInfo['docserver_id'], 'select' => ['path_template']]);
                $mainDocumentFilePath = $letterboxPath['path_template'] . str_replace('#', '/', $adrMainInfo['path']) . $adrMainInfo['filename'];
                $directoryPath = $letterboxPath['path_template'] . str_replace('#', '/', $adrMainInfo['path']);
                $fileName = $adrMainInfo['filename'];
            }
            chdir($directoryPath);

            $curlResponse = CurlModel::exec([
                'url' => rtrim($aArgs['config']['data']['url']) . '/api/workflows/' . $sentInfo['workflowId'] . '/parts?createDocuments=true&ignoreAttachments=false&signatureProfileId=' . $aArgs['config']['data']['signatureProfileId'],
                'headers' => ['Authorization: Bearer ' . $aArgs['config']['data']['tokenAPI'], 'Content-Type: multipart/form-data'],
                'customRequest' => 'POST',
                'method' => 'CUSTOM',
                'body' => [
                    'document' => new \CURLFile($fileName, 'application/pdf')
                ]

            ]);
            $response = LexPersonaController::handleResponse([
                'config' => $aArgs['config'],
                'workflowId' => $sentInfo['workflowId'],
                'curlResponse' => $curlResponse,
                'action' => $action,
                'resIdMaster' => $aArgs['resIdMaster'],
                'type' => 'Document Principal'
            ]);
            if (!empty($response['error'])) {
                return ['error' => $response['error']];
            }
            $attachmentToFreeze[$collId][$aArgs['resIdMaster']] = $response['documentId'];
            // Return to the original working directory
            chdir($current_dir);
        }

        $collId = 'attachments_coll';
        // 'if' condition check if the document type is signable in case the user has chosen to include an attachment
        foreach ($attachments as $key => $value) {
            $adrInfo = ConvertPdfController::getConvertedPdfById(['resId' => $value['res_id'], 'collId' => 'attachments_coll']);
            $docserverInfo = DocserverModel::getByDocserverId(['docserverId' => $adrInfo['docserver_id']]);
            $directoryPath = $docserverInfo['path_template'] . str_replace('#', '/', $adrInfo['path']);
            $fileName = $adrInfo['filename'];
            chdir($directoryPath);
            $label = AttachmentTypeModel::get(['select' => ['label'], 'where' => ["type_id = ?"], 'data' => [$value['attachment_type']]]);

            if (!$attachmentTypes[$value['attachment_type']]) {
                // First Query To create a BLOB:
                $curlResponse = CurlModel::exec([
                    'url'           => rtrim($aArgs['config']['data']['url']) . '/api/workflows/' . $sentInfo['workflowId']. '/blobs',
                    'headers'       => ['Authorization: Bearer ' . $aArgs['config']['data']['tokenAPI'], 'Content-Type: application/octet-stream'],
                    'method'        => 'POST',
                    'body' => file_get_contents($fileName)
                ]);

                $idBlob = $curlResponse['response']['id'];
                $bodyData = [
                    "parts" => [
                        [
                            "blobs" => [$idBlob],
                            "contentType" => "application/pdf",
                            "filename" => "PJ.pdf"
                        ]
                    ]
                ];

                // Second Query to save the blob
                $curlResponse = CurlModel::exec([
                    'url'           => rtrim($aArgs['config']['data']['url']) . '/api/workflows/' . $sentInfo['workflowId']. '/blobs/parts?createDocuments=true&ignoreAttachments=false&unzip=true&signatureProfileId=',
                    'headers'       => ['Authorization: Bearer ' . $aArgs['config']['data']['tokenAPI'], 'Content-Type: application/json'],
                    'method'        => 'POST',
                    'body'          => json_encode($bodyData)
                ]);
                $response = LexPersonaController::handleResponse([
                    'config' => $aArgs['config'],
                    'workflowId' => $sentInfo['workflowId'],
                    'curlResponse' => $curlResponse,
                    'action' => $action,
                    'resIdMaster' => $aArgs['resIdMaster'],
                    'type' => $label[0]['label']
                ]);
                if (!empty($response['error'])) {
                    return ['error' => $response['error']];
                }

            }
            else {
                $curlResponse = CurlModel::exec([
                    'url'           => rtrim($aArgs['config']['data']['url']) . '/api/workflows/' . $sentInfo['workflowId']. '/parts?createDocuments=true&signatureProfileId=' . $aArgs['config']['data']['signatureProfileId'],
                    'headers'       => ['Authorization: Bearer ' . $aArgs['config']['data']['tokenAPI'], 'Content-Type: multipart/form-data'],
                    'customRequest' => 'POST',
                    'method'        => 'CUSTOM',
                    'body'          => [
                        'document' => new \CURLFile($fileName, 'application/pdf')
                    ]
                ]);
                $response = LexPersonaController::handleResponse([
                    'config' => $aArgs['config'],
                    'workflowId' => $sentInfo['workflowId'],
                    'curlResponse' => $curlResponse,
                    'action' => $action,
                    'resIdMaster' => $aArgs['resIdMaster'],
                    'type' => $label[0]['label']
                ]);
                if (!empty($response['error'])) {
                    return ['error' => $response['error']];
                }
                $attachmentToFreeze[$collId][$value['res_id']] = $response['documentId'];
            }
        }

        // Return to the original working directory
        chdir($current_dir);

        // Start The Workflow
        $bodyData = [
            "workflowStatus" => "started"
        ];
        $curlResponse = CurlModel::exec([
            'url'           => rtrim($aArgs['config']['data']['url']) . '/api/workflows/' . $sentInfo['workflowId'],
            'headers'       => ['Authorization: Bearer ' . $aArgs['config']['data']['tokenAPI'], 'Content-Type: application/json'],
            'method'        => 'PATCH',
            'body'          => json_encode($bodyData)
        ]);
        return ['sended' => $attachmentToFreeze];

    }

    public static function createAttachement($aArgs, $appUrl, $userWS, $passwordWS)
    {
        $opts = [
            CURLOPT_URL => rtrim($appUrl, "/") . '/rest/attachments',
            CURLOPT_HTTPHEADER => [
                'accept:application/json',
                'content-type:application/json',
                'Authorization: Basic ' . base64_encode($userWS. ':' .$passwordWS),
            ],
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_SSL_VERIFYPEER => false,
            CURLOPT_POSTFIELDS => json_encode($aArgs),
            CURLOPT_POST => true
        ];

        $curl = curl_init();
        curl_setopt_array($curl, $opts);
        $rawResponse = curl_exec($curl);
        $error       = curl_error($curl);

        $code = curl_getinfo($curl, CURLINFO_HTTP_CODE);
        if ($code == 404) {
            return ['error' => 'maarchUrl is not correct'];
        }

        if (!empty($error)) {
            return ['error' => $error];
        }

        $return = json_decode($rawResponse, true);
        if (!empty($return['errors'])) {
            return ['error' => json_encode($return['errors'])];
        }
        return $return;

    }

    public static function retrieveDocuments(Request $request, Response $response)
    {
        $body = $request->getParsedBody();
        // Check if the 'signed' key in $body is not a boolean
        if (!is_bool($body['signed'])) {
            return $response->withStatus(400)->withJson(['errors' => 'signed is not a boolean']);
        }

        // Load json config file:
        $customConfig = CoreConfigModel::getJsonLoaded(['path' => 'apps/maarch_entreprise/xml/config.json']);
        $appUrl = $customConfig['config']['maarchUrl'];
        $userWS = $customConfig['signatureBook']['userWS'];
        $passwordWS = $customConfig['signatureBook']['passwordWS'];

        $idsToRetrieve = ['noVersion' => [], 'resLetterbox' => []];


        // récuperer le doc principal.
        foreach ($body['documents'] as $key => $value) {
            $resources = \Resource\models\ResModel::get([
                'select' => ['res_id', 'external_id->>\'signatureBookId\' as external_id', 'subject', 'typist', 'version', 'alt_identifier'],
                'where' => ['external_id->>\'signatureBookId\' IS NOT NULL', 'external_id->>\'signatureBookId\' = \'' . $value['lex_persona_document_id'] . '\'']
            ]);
            if (!empty($resources)) {
                $idsToRetrieve['resLetterbox'][$resources[0]['res_id']] = $resources[0];
                $idsToRetrieve['resLetterbox'][$resources[0]['res_id']]['format'] = $value['format'];
                $idsToRetrieve['resLetterbox'][$resources[0]['res_id']]['encodedFile'] = $value['file_content'];
            }
        }

        // récuperer les attachements :
        foreach ($body['documents'] as $key => $value) {
            $attachments = \Attachment\models\AttachmentModel::get([
                'select' => ['res_id', 'external_id->>\'signatureBookId\' as external_id', 'external_id->>\'xparaphDepot\' as xparaphdepot', 'format', 'res_id_master', 'title', 'identifier', 'attachment_type', 'docserver_id' ,'recipient_id', 'recipient_type', 'typist', 'origin_id', 'relation'],
                'where' => ['status = ?', 'external_id->>\'signatureBookId\' IS NOT NULL', 'external_id->>\'signatureBookId\'  = \'' . $value['lex_persona_document_id'] . '\''],
                'data'  => ['FRZ']
            ]);
            if (!empty($attachments)) {
                $idsToRetrieve['noVersion'][$attachments[0]['res_id']] = $attachments[0];
                $idsToRetrieve['noVersion'][$attachments[0]['res_id']]['format'] = $value['format'];
                $idsToRetrieve['noVersion'][$attachments[0]['res_id']]['encodedFile'] = $value['file_content'];
            }
        }

        if (empty($idsToRetrieve['noVersion']) && empty($idsToRetrieve['resLetterbox'])) {
            return $response->withStatus(400)->withJson(['errors' => " Aucun document n'existe dans la base de données"]);
        }

        // Process Documents (Workflow finished):
        else if ($body['signed']) {
            // Process attachments
            foreach ($idsToRetrieve['noVersion'] as $resId => $value) {
                if (!empty($value['encodedFile'])) {

                    // Delete Attachement if there is any signedResponse.
                    \SrcCore\models\DatabaseModel::delete([
                        'table' => 'res_attachments',
                        'where' => ['res_id_master = ?', 'status = ?', 'relation = ?', 'origin = ?'],
                        'data'  => [$value['res_id_master'], 'SIGN', $value['relation'], $value['res_id'] . ',res_attachments']
                    ]);
                    $listInstances = DatabaseModel::select([
                        'select'    => ['item_id'],
                        'table'     => ['listinstance', 'users'],
                        'left_join' => ['listinstance.item_id = users.id'],
                        'where'     => ['res_id = ?', 'item_type = ?', 'difflist_type = ?', 'item_mode = ?'],
                        'data'      => [$value['res_id_master'], 'user_id', 'VISA_CIRCUIT', 'sign'],
                        'order_by'  => ['sequence DESC'],
                        'limit'     => 1
                    ]);
                    $returnInfo = LexPersonaController::createAttachement([
                        'resIdMaster'       => $value['res_id_master'],
                        'title'             => $value['title'],
                        'chrono'            => $value['identifier'],
                        'recipientId'       => $value['recipient_id'],
                        'recipientType'     => $value['recipient_type'],
                        'typist'            => $value['typist'],
                        'format'            => $value['format'],
                        'type'            => 'signed_response',
                        'encodedFile'       => $value['encodedFile'],
                        'status'            => 'TRA',
                        'inSignatureBook' => true,
                        'originId'        => $resId,
                        'signatory_user_serial_id' => $listInstances[0]['item_id'] ?? null

                    ], $appUrl, $userWS, $passwordWS);

                    // catch errors :
                    if (!empty($returnInfo['error'])) {
                        return $response->withStatus(400)->withJson(['errors' => $returnInfo['error']]);
                    }
                    $resIdStored = $value['res_id_master'];
                }

                \Attachment\models\AttachmentModel::update([
                    'set'     => ['status' => 'SIGN', 'in_signature_book' => 'false'],
                    'postSet' => ['external_id' => "external_id - 'signatureBookId'"],
                    'where'   => ['res_id = ?'],
                    'data'    => [$resId]
                ]);
                $historyInfo = 'La signature de la pièce jointe a été validée dans le parapheur externe';
                $user = \User\models\UserModel::get(['select' => ['id'], 'orderBy' => ["user_id='". $customConfig['signatureBook']['userWS'] ."' desc"], 'limit' => 1]);
                \History\controllers\HistoryController::add([
                    'tableName' => 'res_attachments',
                    'recordId'  => $resId,
                    'eventType' => 'UP',
                    'eventId'      => "attachup",
                    'userId'       => $user[0]['id'],
                    'info'         => $historyInfo
                ]);
            }

            // Process main doc
            foreach ($idsToRetrieve['resLetterbox'] as $resId => $value) {
                if (!empty($value['encodedFile'])) {
                    // cette method enregistre le fichier signer avec une conversion en docx aussi et renvoie l'emplacement.
                    $storeResult = \Docserver\controllers\DocserverController::storeResourceOnDocServer([
                        'collId'          => 'letterbox_coll',
                        'docserverTypeId' => 'DOC',
                        'encodedResource' => $value['encodedFile'],
                        'format'          => 'pdf'
                    ]);
                    \SrcCore\models\DatabaseModel::insert([
                        'table'         => 'adr_letterbox',
                        'columnsValues' => [
                            'res_id'       => $resId,
                            'type'         => in_array($value['status'], ['refused', 'refusedNote', 'validatedNote']) ? 'NOTE' : 'SIGN',
                            'docserver_id' => $storeResult['docserver_id'],
                            'path'         => $storeResult['destination_dir'],
                            'filename'     => $storeResult['file_destination_name'],
                            'version'      => $value['version'],
                            'fingerprint'  => empty($storeResult['fingerPrint']) ? null : $storeResult['fingerPrint']
                        ]
                    ]);
                }

                $info = 'Le document principal a été validé dans le parapheur externe';
                $user = \User\models\UserModel::get(['select' => ['id'], 'orderBy' => ["user_id='". $customConfig['signatureBook']['userWS'] ."' desc"], 'limit' => 1]);
                \History\controllers\HistoryController::add([
                    'tableName' => 'res_letterbox',
                    'recordId'  => $resId,
                    'eventType' => 'ACTION#1',
                    'eventId'      => "1",
                    'userId'       => $user[0]['id'],
                    'info'         => $info
                ]);
                $resIdStored = $resId;
            }

            if (isset($resIdStored)) {
                \Entity\models\ListInstanceModel::update([
                    'set' => [
                        'process_date' => 'CURRENT_TIMESTAMP',
                        'process_comment' => 'Signé via le parapheur externe',
                        'signatory' => 'true'
                    ],
                    'where' => ['res_id = ?', 'difflist_type = ?', 'item_mode = ?'],
                    'data' => [$resIdStored, 'VISA_CIRCUIT', 'sign']
                ]);
                \Entity\models\ListInstanceModel::update([
                    'set' => [
                        'process_date' => 'CURRENT_TIMESTAMP',
                        'process_comment' => 'Visé via le parapheur externe'
                    ],
                    'where' => ['res_id = ?', 'difflist_type = ?', 'item_mode = ?'],
                    'data' => [$resIdStored, 'VISA_CIRCUIT', 'visa']
                ]);
                // Set Notes :
                if (!empty($body['notes'])) {
                    foreach ($body['notes'] as $note) {
                        $pos = strpos($note['note_content'], _PREFIXE_NOTE_LEXPERSONA);
                        if ($pos === false) {
                            $user = \User\models\UserModel::get(['select' => ['id'], 'orderBy' => ["user_id='". $customConfig['signatureBook']['userWS'] ."' desc"], 'limit' => 1]);
                            \Note\models\NoteModel::create([
                                'resId'     => $resIdStored,
                                'user_id'   => $user[0]['id'],
                                'note_text' => $note['note_content'],
                            ]);
                        }
                    }
                }
                \Resource\models\ResModel::update([
                    'set'     => ['status' => $customConfig['signatureBook']['validatedStatus']],
                    'postSet' => ['external_id' => "external_id - 'signatureBookId'"],
                    'where'   => ['res_id = ?'],
                    'data'    => [$resIdStored]
                ]);
                return $response->withJson(['Results ' => "Les documents ont été récupérés avec succès !"]);
            }
        }
        else {
            //Traitement des Attachements :
            foreach ($idsToRetrieve['noVersion'] as $resId => $value) {

                LexPersonaController::createAttachement([
                    'resIdMaster'     => $value['res_id_master'],
                    'title'           => '[REFUSE] ' . $value['title'],
                    'chrono'          => $value['identifier'],
                    'recipientId'     => $value['recipient_id'],
                    'recipientType'   => $value['recipient_type'],
                    'typist'          => $value['typist'],
                    'format'          => $value['format'],
                    'type'            => $value['attachment_type'],
                    'status'          => 'A_TRA',
                    'encodedFile'     => $value['encodedFile'],
                    'inSignatureBook' => false
                ], $appUrl, $userWS, $passwordWS
                );
                \Attachment\models\AttachmentModel::update([
                    'set'     => ['status' => 'A_TRA'],
                    'postSet' => ['external_id' => "external_id - 'signatureBookId'"],
                    'where'   => ['res_id = ?'],
                    'data'    => [$resId]
                ]);
                $resIdStored = $value['res_id_master'];
            }


            // Traitement docs principal :
            foreach ($idsToRetrieve['resLetterbox'] as $resId => $value) {

                $historyInfo = 'La signature des documents a été refusée dans le parapheur externe';
                $user = \User\models\UserModel::get(['select' => ['id'], 'orderBy' => ["user_id='". $customConfig['signatureBook']['userWS'] ."' desc"], 'limit' => 1]);
                \History\controllers\HistoryController::add([
                    'tableName' => 'res_letterbox',
                    'recordId'  => $resId,
                    'eventType' => 'ACTION#1',
                    'eventId'      => "1",
                    'userId'       => $user[0]['id'],
                    'info'         => $historyInfo
                ]);
                $resIdStored = $resId;
            }

            if (isset($resIdStored)) {

                \Entity\models\ListInstanceModel::update([
                    'set' => ['process_date' => null],
                    'where' => ['res_id = ?', 'difflist_type = ?'],
                    'data' => [$resIdStored, 'VISA_CIRCUIT']
                ]);
                // Set Notes :
                if (!empty($body['notes'])) {
                    foreach ($body['notes'] as $note) {
                        $pos = strpos($note['note_content'], _PREFIXE_NOTE_LEXPERSONA);
                        if ($pos === false) {
                            $user = \User\models\UserModel::get(['select' => ['id'], 'orderBy' => ["user_id='". $customConfig['signatureBook']['userWS'] ."' desc"], 'limit' => 1]);
                            \Note\models\NoteModel::create([
                                'resId'     => $resId,
                                'user_id'   => $user[0]['id'],
                                'note_text' => $note['note_content'],
                            ]);
                        }
                    }
                }
                \Resource\models\ResModel::update([
                    'set'     => ['status' => $customConfig['signatureBook']['refusedStatus']],
                    'postSet' => ['external_id' => "external_id - 'signatureBookId'"],
                    'where'   => ['res_id = ?'],
                    'data'    => [$resIdStored]
                ]);
            }

            return $response->withJson(['Results ' => "OK !"]);
        }
    }
    public static function getOrganizations(Request $request, Response $response, array $args)
    {
        // Récupérer les paramètres de la requête GET
        $queryParams = $request->getQueryParams();
        $action = ActionModel::getById(['id' => $queryParams['actionId']]);
        $parametersAction = json_decode($action['parameters'], true);

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
        elseif (empty($config['data']['tokenAPI'])) {
            return $response->withStatus(400)->withJson(['errors' => 'Token Api n\'est pas défini sur le fichier xml']);
        }
        elseif (empty($config['data']['userId'])) {
            return $response->withStatus(400)->withJson(['errors' => 'userId n\'est pas défini sur le fichier xml']);
        }
        elseif (empty($config['data']['consentPage'])) {
            return $response->withStatus(400)->withJson(['error' => 'consentPage n\'est pas défini sur le fichier xml']);
        }

        $firstUserInVisaWorfklow = DatabaseModel::select([
            'select'    => ['listinstance_id', 'sequence', 'item_id'],
            'table'     => ['listinstance'],
            'where'     => ['res_id = ?', 'item_type = ?', 'difflist_type = ?', 'process_date is null', 'item_id = ?'],
            'data'      => [$args['resId'], 'user_id', 'VISA_CIRCUIT', $GLOBALS['id']],
            'order_by'  => ['listinstance_id ASC'],
            'limit'     => 1
        ]);

        // Check if there are results from the first query before proceeding to the second query.
        // Si l'action d'envoi au parapheur vise (visaValidation=true) alors on doit soustraire le viseur en cours du circuit à envoyer
        // sinon on envoit tout le circuit
        if ($parametersAction['visaValidation']) {
            //Check Workflow MemCourrier:
            $listInstances = DatabaseModel::select([
                'select'    => ['listinstance_id', 'item_mode' ,'sequence', 'item_id', 'item_type', 'firstname as item_firstname', 'lastname as item_lastname', 'mail ','viewed', 'process_date', 'process_comment', 'signatory', 'requested_signature', 'delegate'],
                'table'     => ['listinstance', 'users'],
                'left_join' => ['listinstance.item_id = users.id'],
                'where'     => ['res_id = ?', 'item_type = ?', 'difflist_type = ?', 'listinstance_id <> ?' , 'process_date is null'],
                'data'      => [$args['resId'], 'user_id', 'VISA_CIRCUIT', $firstUserInVisaWorfklow[0]['listinstance_id']],
                'order_by'  => ['listinstance_id ASC'],
            ]);
        }
        else {
            $listInstances = DatabaseModel::select([
                'select'    => ['listinstance_id', 'item_mode' ,'sequence', 'item_id', 'item_type', 'firstname as item_firstname', 'lastname as item_lastname', 'mail ','viewed', 'process_date', 'process_comment', 'signatory', 'requested_signature', 'delegate'],
                'table'     => ['listinstance', 'users'],
                'left_join' => ['listinstance.item_id = users.id'],
                'where'     => ['res_id = ?', 'item_type = ?', 'difflist_type = ?', 'process_date is null'],
                'data'      => [$args['resId'], 'user_id', 'VISA_CIRCUIT'],
                'order_by'  => ['listinstance_id ASC'],
            ]);
        }

        // Vérifier si aucun circuit de visa n'est defini
        if (empty($listInstances)) {
            return $response->withStatus(400)->withJson(['errors' => 'Veuillez definir un circuit de visa']);
        }

        // verifier SendApproval.
        // si l'action d'envoi au parapheur ne vise pas (visaValidation=false) ET qu'on envoit pas de viseurs dans LEX (sendApproval=N) ET qu'il y a encore des viseurs qui
        // n'ont pas visé (item_mode=visa) alors on bloque l'envoi
        // si l'action d'envoi au parapheur vise (visaValidation=true) ET qu'on envoit pas de viseurs dans LEX (sendApproval=N) ET que l'utilisateur en cours n'est pas le seul
        // à devoir viser alors on bloque l'envoi
        if ($config['data']['sendApproval'] == 'N') {
            foreach ($listInstances as $value) {
                if ($value['item_mode'] == 'visa') {
                    if (!$parametersAction['visaValidation']) {
                        return $response->withStatus(400)->withJson(['errors' => 'Le paramètre d\'envoi des viseurs vers Lex n\'ayant pas été activé (sendApproval), tous les viseurs doivent intervenir et viser dans MEM avant de procéder à l\'envoi']);
                    } else if ($parametersAction['visaValidation'] && $value['item_id'] != $firstUserInVisaWorfklow[0]['item_id']) {
                        return $response->withStatus(400)->withJson(['errors' => 'Le paramètre d\'envoi des viseurs vers Lex n\'ayant pas été activé (sendApproval), tous les viseurs doivent intervenir et viser dans MEM avant de procéder à l\'envoi']);
                    }
                }
            }
        }

        //verifier la prèsence d'au moins un signataire.
        $signatoryExist = false;
        foreach ($listInstances as $key => $value) {
            if ($value['item_mode'] == 'sign') {
                $signatoryExist = true;
                break;
            }
        }
        if (!$signatoryExist) {
            return $response->withStatus(400)->withJson(['errors' => 'Veuillez ajouter au moins un signataire']);
        }

        foreach ($listInstances as $key => $value) {

            $primaryEntity = UserModel::getPrimaryEntityById(['select' => ['entity_label'], 'id' => $value['item_id']]);
            $listInstances[$key]['item_entity'] = $primaryEntity['entity_label'] ?? '';
            $user = UserModel::getById(['id' => $value['item_id'], 'select' => ['status']]);
            $listInstances[$key]['isValid'] = !empty($user) && !in_array($user['status'], ['SPD', 'DEL']);
            $listInstances[$key]['item_type'] = 'user';
            $itemLabel = $listInstances[$key]['item_firstname'].' '.$listInstances[$key]['item_lastname'];
            $listInstances[$key]['labelToDisplay'] = $itemLabel;
            $listInstances[$key]['delegatedBy'] = null;

            if (!empty($listInstances[$key]['delegate'])) {
                $listInstances[$key]['labelToDisplay'] = UserModel::getLabelledUserById(['id' => $listInstances[$key]['delegate']]);
                $listInstances[$key]['delegatedBy'] = $itemLabel;
            }
            $listInstances[$key]['hasPrivilege'] = true;
            if (empty($value['process_date']) && !PrivilegeController::hasPrivilege(['privilegeId' => 'visa_documents', 'userId' => $value['item_id']]) && !PrivilegeController::hasPrivilege(['privilegeId' => 'sign_document', 'userId' => $value['item_id']])) {
                $listInstances[$key]['hasPrivilege'] = false;
            }
            $user = UserModel::getById(['id' => $value['item_id']]);
            $listInstances[$key]['external_id'] = json_decode($user['external_id'], true);
            if ($config['data']['externalIdMandatory'] == 'N') {
                $url = rtrim($config['data']['url']) . '/api/users/?items.email=' . $listInstances[$key]['mail'];
            }
            else {
                $url  = rtrim($config['data']['url']) . '/api/users/?items.id=' . $listInstances[$key]['external_id']['lexPersonaId'];
            }

            if ($value['item_mode'] == 'sign') {
                //pre-process to verify visa-workflow users on Api Side.
                $curlResponse = CurlModel::exec([
                    'url'           => $url,
                    'headers'       => ['Authorization: Bearer ' . $config['data']['tokenAPI']],
                    'method'        => 'GET',
                ]);
                if (!empty($curlResponse['errors'])) {
                    return $response->withStatus(400)->withJson(['errors' => $curlResponse['errors']]);
                }
                if (empty($curlResponse['response']['items'])) {
                    return $response->withStatus(400)->withJson(['errors' => 'L\'utilisateur ' . $value['item_firstname'] . ' ' . $value['item_lastname'] .' n\'existe pas dans LexPersona']);
                }
                if (empty($curlResponse['response']['items'][0]['organizationTitles'])) {
                    $listInstances[$key]['roles'] = [];
                }
                else {
                    foreach ($curlResponse['response']['items'][0]['organizationTitles'] as $key2 => $value2) {
                        $listInstances[$key]['roles'][$key2]['title'] = $value2['title'];
                        $listInstances[$key]['roles'][$key2]['organizationId'] = $value2['organizationId'];
                    }
                }
            }
            else {
                $listInstances[$key]['roles'] = [];
                $curlResponse = CurlModel::exec([
                    'url'           => $url,
                    'headers'       => ['Authorization: Bearer ' . $config['data']['tokenAPI']],
                    'method'        => 'GET',
                ]);
                if (!empty($curlResponse['errors'])) {
                    return $response->withStatus(400)->withJson(['errors' => $curlResponse['errors']]);
                }
                if (empty($curlResponse['response']['items'])) {
                    return $response->withStatus(400)->withJson(['errors' => 'L\'utilisateur ' . $value['item_firstname'] . ' ' . $value['item_lastname'] .' n\'existe pas dans LexPersona']);
                }
            }
        }
        $hasHistory = ListInstanceHistoryDetailModel::get([
            'select'    => [1],
            'where'     => ['difflist_type = ?', 'res_id = ?'],
            'data'      => ['VISA_CIRCUIT', $args['resId']],
            'groupBy'   => ['listinstance_history_id']
        ]);

        return $response->withJson(['circuit' => $listInstances, 'hasHistory' => count($hasHistory) > 1]);
    }

    public static function download($aArgs) {

        $decoded_bytes = base64_decode($aArgs['hash']);
        $hex_representation = bin2hex($decoded_bytes);
        $response = CurlModel::exec([
            'url'           => rtrim($aArgs['config']['data']['url']) . '/api/documents/' . $aArgs['document']['external_id'] . '/parts/' . $hex_representation,
            'headers'       => ['Authorization: Bearer ' . $aArgs['config']['data']['tokenAPI']],
            'method'        => 'GET',
            'noLogs' => false,
            'fileResponse' => true
        ]);
        if ($response['code'] != 200) {
            return ['error' => 'une erreur s\'est produit lors de télechargement des pdfs'];
        }
        return ['b64FileContent' => base64_encode($response['response'])];
    }
    public static function retrieveSignedMails($aArgs)
    {
        $config = $aArgs['config'];
        $version = $aArgs['version'];
        foreach ($aArgs['idsToRetrieve'][$version] as $resId => $value) {
            if (!empty($value['external_id'])) {
                $retrievedDocument = CurlModel::exec([
                    'url'           => rtrim($aArgs['config']['data']['url']) . '/api/documents/?items.id=' . $value['external_id'],
                    'headers'       => ['Authorization: Bearer ' . $aArgs['config']['data']['tokenAPI']],
                    'method'        => 'GET',
                ]);
                if (isset($retrievedDocument['response']['items'][0]['workflowId'])) {
                    $workflowId = $retrievedDocument['response']['items'][0]['workflowId'];
                    $curlResponse = CurlModel::exec([
                        'url'           => rtrim($aArgs['config']['data']['url']) . '/api/workflows/' . $workflowId,
                        'headers'       => ['Authorization: Bearer ' . $aArgs['config']['data']['tokenAPI']],
                        'method'        => 'GET',
                    ]);
                    if ($curlResponse['response']['workflowStatus'] == 'finished') {
                        $response = LexPersonaController::download(['config' => $config, 'hash' => $retrievedDocument['response']['items'][0]['parts'][0]['hash'], "document" => $value]);
                        if (!empty($response['error'])) {
                            return ['error' => $response['error']];
                        }
                        $aArgs['idsToRetrieve'][$version][$resId]['status'] = 'validated';
                        $aArgs['idsToRetrieve'][$version][$resId]['format'] = 'PDF';
                        $aArgs['idsToRetrieve'][$version][$resId]['encodedFile'] = $response['b64FileContent'];
                        if ($config['data']['getComments'] == 'Y') {
                            //retrieveComments.
                            $retrievedComments = CurlModel::exec([
                                'url'           => rtrim($aArgs['config']['data']['url']) . '/api/workflows/' . $workflowId . '/comments',
                                'headers'       => ['Authorization: Bearer ' . $aArgs['config']['data']['tokenAPI']],
                                'method'        => 'GET',
                            ]);
                            foreach ($retrievedComments['response'] as $comment) {
                                $pos = strpos($comment['content'], "[Message envoyé par");
                                if ($comment['isPublic'] && !empty(trim($comment['content'])) && $pos === false) {
                                    $noteContent = $comment['lastName'] . ' ' . $comment['firstName'] . ' a laissé un commentaire : ' . $comment['content'];
                                    $aArgs['idsToRetrieve'][$version][$resId]['notes'][] = ['content' => $noteContent];
                                }
                            }
                            LexPersonaController::processVisaWorkflow(['res_id_master' => $value['res_id_master'], 'res_id' => $value['res_id'], 'processSignatory' => true]);
                        }
                    }
                    if ($curlResponse['response']['workflowStatus'] == 'stopped') {
                        foreach ($curlResponse['response']['steps'][0]['logs'] as $log) {
                            if ($log['operation'] == 'refuse') {
                                $user = CurlModel::exec([
                                    'url'           => rtrim($aArgs['config']['data']['url']) . '/api/users/?items.email=' . $log['recipientEmail'],
                                    'headers'       => ['Authorization: Bearer ' . $aArgs['config']['data']['tokenAPI']],
                                    'method'        => 'GET',
                                ]);
                                $name = $user['response']['items'][0]['name'];
                                $noteContent = 'Motif de refus pour [' . $name . '] : ' . $log['reason'];
                                $aArgs['idsToRetrieve'][$version][$resId]['notes'][] = ['content' => $noteContent];
                            }
                        }
                        $aArgs['idsToRetrieve'][$version][$resId]['status'] = 'refused';
                    }
                }
            }
        }
        return $aArgs['idsToRetrieve'];
    }

    public static function processVisaWorkflow($aArgs = []) {
        $resIdMaster = $aArgs['res_id_master'] ?? $aArgs['res_id'];

        $attachments = AttachmentModel::get(['select' => ['count(1)'], 'where' => ['res_id_master = ?', 'status = ?'], 'data' => [$resIdMaster, 'FRZ']]);
        if ((count($attachments) < 2 && $aArgs['processSignatory']) || !$aArgs['processSignatory']) {
            $visaWorkflow = ListInstanceModel::get([
                'select' => ['listinstance_id', 'requested_signature'],
                'where' => ['res_id = ?', 'difflist_type = ?', 'process_date IS NULL'],
                'data' => [$resIdMaster, 'VISA_CIRCUIT'],
                'orderBY' => ['ORDER BY listinstance_id ASC']
            ]);

            if (!empty($visaWorkflow)) {
                foreach ($visaWorkflow as $listInstance) {
                    if ($listInstance['requested_signature']) {
                        // Stop to the first signatory user
                        if ($aArgs['processSignatory']) {
                            ListInstanceModel::update(['set' => ['signatory' => 'true', 'process_date' => 'CURRENT_TIMESTAMP'], 'where' => ['listinstance_id = ?'], 'data' => [$listInstance['listinstance_id']]]);
                        }
                        break;
                    }
                    ListInstanceModel::update(['set' => ['process_date' => 'CURRENT_TIMESTAMP'], 'where' => ['listinstance_id = ?'], 'data' => [$listInstance['listinstance_id']]]);
                }
            }
        }
    }
}
