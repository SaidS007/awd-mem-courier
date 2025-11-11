<?php

/**
 * Copyright Maarch since 2008 under licence GPLv3.
 * See LICENCE.txt file at the root folder for more details.
 * This file is part of Maarch software.
 *
 */

/**
 * @brief Resource Controller
 * @author dev@maarch.org
 */

namespace Resource\controllers;

use AcknowledgementReceipt\models\AcknowledgementReceiptModel;
use Action\models\ActionModel;
use Attachment\controllers\AttachmentTypeController;
use Attachment\models\AttachmentModel;
use Basket\models\BasketModel;
use Basket\models\GroupBasketModel;
use Convert\controllers\ConvertPdfController;
use Convert\models\AdrModel;
use CustomField\models\CustomFieldModel;
use Docserver\models\DocserverModel;
use Docserver\models\DocserverTypeModel;
use Email\models\EmailModel;
use Entity\models\EntityModel;
use Entity\models\ListInstanceModel;
use Exception;
use Folder\models\FolderModel;
use Folder\models\ResourceFolderModel;
use Group\controllers\GroupController;
use Group\controllers\PrivilegeController;
use Group\models\GroupModel;
use History\controllers\HistoryController;
use IndexingModel\models\IndexingModelFieldModel;
use MaarchCourrier\Core\Infrastructure\Environment;
use MessageExchange\models\MessageExchangeModel;
use Note\models\NoteModel;
use Priority\models\PriorityModel;
use RegisteredMail\controllers\RegisteredMailController;
use RegisteredMail\models\RegisteredMailModel;
use Resource\models\ResModel;
use Resource\models\ResourceContactModel;
use Resource\models\UserFollowedResourceModel;
use Respect\Validation\Validator;
use Search\controllers\SearchController;
use Shipping\models\ShippingModel;
use Slim\Psr7\Request;
use SrcCore\controllers\CoreController;
use SrcCore\controllers\PreparedClauseController;
use SrcCore\http\Response;
use SrcCore\models\CoreConfigModel;
use SrcCore\models\TextFormatModel;
use SrcCore\models\ValidatorModel;
use Status\models\StatusModel;
use Tag\models\ResourceTagModel;
use Throwable;
use User\controllers\UserController;
use User\models\UserModel;
use SignatureBook\controllers\SignatureBookController;
use Entity\models\ListTemplateModel;
use Entity\models\ListTemplateItemModel;
use Resource\Infrastructure\RetrieveResourceFactory;
use SrcCore\controllers\UrlController; // EDISSYUM - NCH01 Addulact Démarches Simplifiées
use SrcCore\models\CurlModel; // EDISSYUM - NCH01 Addulact Démarches Simplifiées
use Entity\controllers\ListTemplateController; // EDISSYUM - NCH01 Amélioration de l'écran de qualification pour récupérer les données par défaut
use Doctype\models\DoctypeModel; // EDISSYUM - EME01 Ajout du connecteur Neocity
use Entity\controllers\ListInstanceController;
use setasign\Fpdi\Tcpdf\Fpdi;


class ResController extends ResourceControlController
{
    /**
     * @param Request $request
     * @param Response $response
     * @return Response
     * @throws Exception
     */
    public function create(Request $request, Response $response): Response
    {
        if (!PrivilegeController::canIndex(['userId' => $GLOBALS['id']])) {
            return $response->withStatus(403)->withJson(['errors' => 'Service forbidden']);
        }

        $body = $request->getParsedBody();
        $body = StoreController::setDisabledAndEmptyMandatoryFields($body);

        $control = ResourceControlController::controlResource(['body' => $body]);
        if (!empty($control['errors'])) {
            return $response->withStatus(400)->withJson(['errors' => $control['errors']]);
        }

        $storedResource = StoreController::storeResource($body);

        $resId = $storedResource['resId'];
        $body['encodedFile'] = $storedResource['encodedResource'];

        // EDISSYUM - NCH01 Amélioration des messages d'erreur lors de l'insertion d'un document
        if (empty($resId) || !empty($resId['errors'])) {
            $error = $resId['errors'];
            if (!empty($storedResource['errors'])) {
                $error = $storedResource['errors'];
            }
            return $response->withStatus(500)->withJson(['errors' => '[ResController create] ' . $error]); // EDISSYUM - NCH01 Amélioration des messages d'erreur lors de l'insertion d'un document | Change $resId['errors'] to $error
        }
        // END EDISSYUM - NCH01

        ResController::createAdjacentData(['body' => $body, 'resId' => $resId]);

        if (!empty($body['followed'])) {
            UserFollowedResourceModel::create([
                'userId' => $GLOBALS['id'],
                'resId'  => $resId
            ]);
        }

        if (!empty($body['encodedFile'])) {
            // EDISSYUM - NCH01 Éviter les doublons de fichiers PDF convertis | Commenter ce bloc
//            ConvertPdfController::convert([
//                'encodedFile' => $body['encodedFile'],
//                'format'      => $body['format'],
//                'resId'       => $resId,
//                'collId'      => 'letterbox_coll',
//                'version'     => 1
//            ]);
            // END EDISSYUM - NCH01

            // EDISSYUM - NCH01 Éviter les doublons de fichiers PDF convertis
            if ($body['format'] != 'pdf') {
                ConvertPdfController::convert([
                    'encodedFile' => $body['encodedFile'],
                    'format'      => $body['format'],
                    'resId'       => $resId,
                    'collId'      => 'letterbox_coll',
                    'version'     => 1
                ]);
            }
            // END EDISSYUM - NCH01

            $customId = CoreConfigModel::getCustomId();
            $customId = empty($customId) ? 'null' : $customId;
            exec(
                "php src/app/convert/scripts/FullTextScript.php --customId {$customId} --resId {$resId} " .
                "--collId letterbox_coll --userId {$GLOBALS['id']} > /dev/null &"
            );
        }

        HistoryController::add([
            'tableName' => 'res_letterbox',
            'recordId'  => $resId,
            'eventType' => 'ADD',
            'info'      => _DOC_ADDED,
            'moduleId'  => 'resource',
            'eventId'   => 'resourceCreation',
        ]);

        return $response->withJson(['resId' => $resId]);
    }

    /**
     * @param Request $request
     * @param Response $response
     * @param array $args
     * @return Response
     * @throws Exception
     */
    public function getById(Request $request, Response $response, array $args): Response
    {
        if (
            !Validator::intVal()->validate($args['resId']) ||
            !ResController::hasRightByResId(['resId' => [$args['resId']], 'userId' => $GLOBALS['id']])
        ) {
            return $response->withStatus(403)->withJson(['errors' => 'Document out of perimeter']);
        }

        $queryParams = $request->getQueryParams();

        $select = [
            'model_id',
            'category_id',
            'priority',
            'typist',
            'status',
            'subject',
            'alt_identifier',
            'process_limit_date',
            'closing_date',
            'creation_date',
            'modification_date',
            'integrations',
            'retention_frozen',
            'binding',
            'external_id',
            'external_state'
        ];
        if (empty($queryParams['light'])) {
            $select = array_merge(
                $select,
                [
                    'type_id',
                    'typist',
                    'destination',
                    'initiator',
                    'confidentiality',
                    'doc_date',
                    'admission_date',
                    'departure_date',
                    'barcode',
                    'custom_fields'
                ]
            );
        }

        $document = ResModel::getById([
            'select' => $select,
            'resId'  => $args['resId']
        ]);
        if (empty($document)) {
            return $response->withStatus(400)->withJson(['errors' => 'Document does not exist']);
        }

        $unchangeableData = [
            'resId'            => (int)$args['resId'],
            'modelId'          => $document['model_id'],
            'typist'           => $document['typist'],
            'categoryId'       => $document['category_id'],
            'chrono'           => $document['alt_identifier'],
            'status'           => $document['status'],
            'externalId'        => json_decode($document['external_id'], true), // EDISSYUM - NCH01 Module OCForMEM NextGen
            'closingDate'      => $document['closing_date'],
            'creationDate'     => $document['creation_date'],
            'modificationDate' => $document['modification_date'],
            'retentionFrozen'  => $document['retention_frozen'],
            'binding'          => $document['binding'],
            'integrations'     => json_decode($document['integrations'], true)
        ];
        $formattedData = [
            'subject'          => $document['subject'],
            'processLimitDate' => $document['process_limit_date'],
            'priority'         => $document['priority']
        ];
        if (empty($queryParams['light'])) {
            $formattedData = array_merge($formattedData, [
                'doctype'         => $document['type_id'],
                'typistLabel'     => UserModel::getLabelledUserById(['id' => $document['typist']]),
                'destination'     => $document['destination'],
                'initiator'       => $document['initiator'],
                'confidentiality' => $document['confidentiality'] == 'Y',
                'documentDate'    => $document['doc_date'],
                'arrivalDate'     => $document['admission_date'],
                'departureDate'   => $document['departure_date'],
                'barcode'         => $document['barcode']
            ]);
        }

        $modelFields = IndexingModelFieldModel::get([
            'select' => ['identifier'],
            'where'  => ['model_id = ?'],
            'data'   => [$document['model_id']]
        ]);
        $modelFields = array_column($modelFields, 'identifier');

        foreach ($formattedData as $key => $data) {
            if (!in_array($key, $modelFields)) {
                unset($formattedData[$key]);
            }
        }
        $formattedData = array_merge($unchangeableData, $formattedData);

        if (!empty($formattedData['destination'])) {
            $entity = EntityModel::getByEntityId(
                ['entityId' => $formattedData['destination'], 'select' => ['entity_label', 'id']]
            );
            $formattedData['destination'] = $entity['id'];
            $formattedData['destinationLabel'] = $entity['entity_label'];
        }
        if (!empty($formattedData['initiator'])) {
            $entity = EntityModel::getByEntityId(
                ['entityId' => $formattedData['initiator'], 'select' => ['entity_label', 'id']]
            );
            $formattedData['initiator'] = $entity['id'];
            $formattedData['initiatorLabel'] = $entity['entity_label'];
        }
        if (!empty($formattedData['status'])) {
            $status = StatusModel::getById(
                ['id' => $formattedData['status'], 'select' => ['label_status', 'can_be_modified']]
            );
            $formattedData['statusLabel'] = $status['label_status'];
            $formattedData['statusAlterable'] = $status['can_be_modified'] == 'Y';
        }
        if (!empty($formattedData['priority'])) {
            $priority = PriorityModel::getById(['id' => $formattedData['priority'], 'select' => ['label', 'color']]);
            $formattedData['priorityLabel'] = $priority['label'];
            $formattedData['priorityColor'] = $priority['color'];
        }

        if (in_array('senders', $modelFields)) {
            $formattedData['senders'] = ResourceContactModel::get([
                'select' => ['item_id as id', 'type'],
                'where'  => ['res_id = ?', 'mode = ?'],
                'data'   => [$args['resId'], 'sender']
            ]);
        }
        if (in_array('recipients', $modelFields)) {
            $formattedData['recipients'] = ResourceContactModel::get([
                'select' => ['item_id as id', 'type'],
                'where'  => ['res_id = ?', 'mode = ?'],
                'data'   => [$args['resId'], 'recipient']
            ]);
        }

        if (empty($queryParams['light'])) {
            $formattedData['customFields'] = !empty($document['custom_fields']) ? json_decode(
                $document['custom_fields'],
                true
            ) : [];

            $entities = EntityModel::getWithUserEntities([
                'select' => ['entities.id'],
                'where'  => ['user_id = ?'],
                'data'   => [$GLOBALS['id']]
            ]);
            $entities = array_column($entities, 'id');
            $folders = [];
            if (!empty($entities)) {
                $folders = FolderModel::getWithEntitiesAndResources([
                    'select' => ['distinct(resources_folders.folder_id)'],
                    'where'  => [
                        'resources_folders.res_id = ?',
                        '(entities_folders.entity_id in (?) OR folders.user_id = ? OR keyword = ?)'
                    ],
                    'data'   => [$args['resId'], $entities, $GLOBALS['id'], 'ALL_ENTITIES']
                ]);
            }
            $formattedData['folders'] = array_column($folders, 'folder_id');

            $tags = ResourceTagModel::get(
                ['select' => ['tag_id'], 'where' => ['res_id = ?'], 'data' => [$args['resId']]]
            );
            $formattedData['tags'] = array_column($tags, 'tag_id');

            if ($formattedData['categoryId'] == 'registeredMail') {
                $registeredMailInfo = RegisteredMailController::getFormattedRegisteredMail(['resId' => $args['resId']]);
                foreach ($registeredMailInfo as $key => $value) {
                    $formattedData['registeredMail_' . $key] = $value;
                }
            }
        } else {
            $followed = UserFollowedResourceModel::get([
                'select' => [1],
                'where'  => ['user_id = ?', 'res_id = ?'],
                'data'   => [$GLOBALS['id'], $args['resId']]
            ]);
            $formattedData['followed'] = !empty($followed);

            $registeredMail = RegisteredMailModel::getByResId(
                ['select' => ['deposit_id', 'received_date', 'return_reason'], 'resId' => $args['resId']]
            );
            $formattedData['registeredMail_returnDate'] = $registeredMail['received_date'] ?? null;
            $formattedData['registeredMail_returnReason'] = $registeredMail['return_reason'] ?? null;
            $formattedData['registeredMail_deposit_id'] = $registeredMail['deposit_id'] ?? null;
        }

        if (PrivilegeController::hasPrivilege(['privilegeId' => 'view_technical_infos', 'userId' => $GLOBALS['id']])) {
            $formattedData['externalId'] = json_decode($document['external_id'], true);
        }

        $formattedData['canUpdate'] = ResController::canUpdateFile(['resource' => $formattedData]);
        $formattedData['canDelete'] = false;

        $externalState = json_decode($document['external_state'], true);
        if (array_key_exists('hasDigitalSignature', $externalState)) {
            $formattedData['hasDigitalSignature'] = $externalState['hasDigitalSignature'];
        }

        return $response->withJson($formattedData);
    }

    /**
     * @param array $args
     * @return bool
     */
    public function canUpdateFile(array $args): bool
    {
        $resource = $args['resource'];

        $canUpdate = $GLOBALS['id'] == $resource['typist'];

        $resourcePrivilege = '';

        if (
            PrivilegeController::hasPrivilege(
                ['privilegeId' => 'update_resources_except_in_visa_workflow', 'userId' => $GLOBALS['id']]
            )
        ) {
            $resourcePrivilege = 'update_resources_except_in_visa_workflow';
        }
        if (PrivilegeController::hasPrivilege(['privilegeId' => 'update_resources', 'userId' => $GLOBALS['id']])) {
            $resourcePrivilege = 'update_resources';
        }

        if ($resourcePrivilege == 'update_resources') {
            $canUpdate = true;
        }

        if ($resourcePrivilege == 'update_resources_except_in_visa_workflow') {
            $currentStepByResId = ListInstanceModel::getCurrentStepByResId([
                'select' => ['item_id'],
                'resId'  => $resource['resId']
            ]);

            if (empty($currentStepByResId)) {
                $canUpdate = true;
            } elseif (!empty($currentStepByResId)) {
                if ($resource['integrations']['inSignatureBook']) {
                    $canUpdate = false;
                } else {
                    $canUpdate = true;
                }
            } else {
                $canUpdate = false;
            }
        }

        return $canUpdate;
    }

    /**
     * @param Request $request
     * @param Response $response
     * @param array $args
     * @return Response
     * @throws Exception
     */
    public function update(Request $request, Response $response, array $args): Response
    {
        if (!Validator::intVal()->validate($args['resId'])) {
            return $response->withStatus(400)->withJson(['errors' => 'Route resId is not an integer']);
        } elseif (!PrivilegeController::canUpdateResource(['userId' => $GLOBALS['id'], 'resId' => $args['resId']])) {
            // EDISSYUM - NCH01 Fix pour permettre la modification d'un courrier si le typist est égal à l'utilisateur connecté
            $resource = ResModel::getById(['resId' => $args['resId'], 'select' => ['typist', 'dest_user']]);
            if ($resource['typist'] !== $GLOBALS['id'] && $resource['dest_user'] !== $GLOBALS['id']) {
                return $response->withStatus(403)->withJson(['errors' => 'Service forbidden']);
            }
            // return $response->withStatus(403)->withJson(['errors' => 'Service forbidden']);
            // END EDISSYUM - NCH01
        }

        $body = $request->getParsedBody();
        $body = StoreController::setDisabledAndEmptyMandatoryFields($body);

        $queryParams = $request->getQueryParams();

        $onlyDocument = !empty($queryParams['onlyDocument']);

        // EDISSYUM - NCH01 Amélioration de l'écran de qualification pour récupérer les données par défaut
        $fromProcess = !empty($queryParams['fromProcess']) && $queryParams['fromProcess'] == 'true';
        if ($fromProcess && isset($body['destination']) && !empty($body['destination'])) {
            $entity = EntityModel::getById(['id' => $body['destination'], 'select' => ['id', 'entity_id']]);
            ResModel::update([
                'set'   => ['destination' => $entity['entity_id']],
                'where' => ['res_id = ?'],
                'data'  => [$args['resId']]
            ]);
            $listInstance = ListTemplateController::getByEntityIdStatic(['entityId' => $entity['id']]);
            for ($i=0; $i < count($listInstance); $i++) {
                $listInstance[$i]['resId'] = $args['resId'];
                $listInstance[$i]['listInstances'] = $listInstance[$i]['items'];
                unset ($listInstance[$i]['items']);
            }
            ListInstanceController::updateListInstance(['data' => $listInstance, 'userId' => $GLOBALS['id'], 'fullRight' => true]);
        }
        //END EDISSYUM - NCH01

        unset($body['destination']);
        unset($body['diffusionList']);
        $control = ResourceControlController::controlUpdateResource(
            ['body' => $body, 'resId' => $args['resId'], 'onlyDocument' => $onlyDocument]
        );
        if (!empty($control['errors'])) {
            return $response->withStatus(400)->withJson(['errors' => $control['errors']]);
        }

        $resource = ResModel::getById(
            [
                'resId'  => $args['resId'],
                'select' => [
                    'alt_identifier',
                    'filename',
                    'docserver_id',
                    'path',
                    'fingerprint',
                    'version',
                    'model_id',
                    'custom_fields',
                    'integrations'
                ]
            ]
        );
        $resource['integrations'] = json_decode($resource['integrations'], true);

        if (
            !PrivilegeController::hasPrivilege(['privilegeId' => 'update_resources', 'userId' => $GLOBALS['id']]) &&
            PrivilegeController::hasPrivilege(
                ['privilegeId' => 'update_resources_only_in_visa_workflow', 'userId' => $GLOBALS['id']]
            )
        ) {
            $circuit = ListInstanceModel::get([
                'select' => [1],
                'where'  => ['res_id = ?', 'difflist_type = ?', 'process_date is null'],
                'data'   => [$args['resId'], 'VISA_CIRCUIT']
            ]);

            if (
                empty($circuit) || !$resource['integrations']['inSignatureBook'] ||
                !SignatureBookController::isResourceInSignatureBook(
                    ['resId' => $args['resId'], 'userId' => $GLOBALS['id'], 'canUpdateDocuments' => true]
                )
            ) {
                return $response->withStatus(403)->withJson(
                    ['errors' => 'Attachment out of perimeter', 'lang' => 'documentOutOfPerimeter']
                );
            } else {
                $currentStepByResId = ListInstanceModel::getCurrentStepByResId([
                    'select' => ['item_id'],
                    'resId'  => $args['resId']
                ]);

                if ($currentStepByResId['item_id'] == $GLOBALS['id']) {
                    return $response->withStatus(403)->withJson(
                        ['errors' => 'Attachment out of perimeter', 'lang' => 'documentOutOfPerimeter']
                    );
                }
            }
        }

        if (!empty($body['modelId']) && $resource['model_id'] != $body['modelId']) {
            $resourceModelFields = IndexingModelFieldModel::get([
                'select' => ['identifier'],
                'where'  => ['model_id = ?'],
                'data'   => [$resource['model_id']]
            ]);
            $resourceModelFields = array_column($resourceModelFields, 'identifier');

            $newModelFields = IndexingModelFieldModel::get([
                'select' => ['identifier'],
                'where'  => ['model_id = ?'],
                'data'   => [$body['modelId']]
            ]);
            $newModelFields = array_column($newModelFields, 'identifier');

            ResController::resetResourceFields(
                ['oldFieldList' => $resourceModelFields, 'newFieldList' => $newModelFields, 'resId' => $args['resId']]
            );
        }

        if (!empty($resource['filename']) && !empty($body['encodedFile'])) {
            AdrModel::createDocumentAdr([
                'resId'       => $args['resId'],
                'type'        => 'DOC',
                'docserverId' => $resource['docserver_id'],
                'path'        => $resource['path'],
                'filename'    => $resource['filename'],
                'version'     => $resource['version'],
                'fingerprint' => $resource['fingerprint']
            ]);
        }

        if ($onlyDocument) {
            $body = [
                'encodedFile' => $body['encodedFile'],
                'format'      => $body['format']
            ];
        }
        $body['resId'] = $args['resId'];
        $storedResource = StoreController::storeResource($body);

        if (!empty($storedResource['errors'])) {
            return $response->withStatus(500)->withJson(
                ['errors' => '[ResController update] ' . $storedResource['errors']]
            );
        }

        if (!$onlyDocument) {
            ResController::updateAdjacentData(['body' => $body, 'resId' => $args['resId']]);
        }

        if (!empty($body['encodedFile'])) {
            ConvertPdfController::convert([
                'encodedFile' => $body['encodedFile'],
                'format'      => $body['format'],
                'resId'       => $args['resId'],
                'collId'      => 'letterbox_coll',
                'version'     => $resource['version'] + 1
            ]);

            $customId = CoreConfigModel::getCustomId();
            $customId = empty($customId) ? 'null' : $customId;
            exec(
                "php src/app/convert/scripts/FullTextScript.php --customId {$customId} " .
                "--resId {$args['resId']} --collId letterbox_coll --userId {$GLOBALS['id']} > /dev/null &"
            );

            HistoryController::add([
                'tableName' => 'res_letterbox',
                'recordId'  => $args['resId'],
                'eventType' => 'UP',
                'info'      => _FILE_UPDATED . " : {$resource['alt_identifier']}",
                'moduleId'  => 'resource',
                'eventId'   => 'fileModification'
            ]);
        }

        if (!$onlyDocument) {
            HistoryController::add([
                'tableName' => 'res_letterbox',
                'recordId'  => $args['resId'],
                'eventType' => 'UP',
                'info'      => _DOC_UPDATED . " : {$resource['alt_identifier']}",
                'moduleId'  => 'resource',
                'eventId'   => 'resourceModification'
            ]);
        }

        return $response->withStatus(204);
    }

    /**
     * @param Request $request
     * @param Response $response
     * @return Response
     * @throws Exception
     */
    public function updateStatus(Request $request, Response $response): Response
    {
        if (!PrivilegeController::hasPrivilege(['privilegeId' => 'update_status_mail', 'userId' => $GLOBALS['id']])) {
            return $response->withStatus(403)->withJson(['errors' => 'Service forbidden']);
        }

        $data = $request->getParsedBody();

        if (empty($data['status'])) {
            $data['status'] = 'COU';
        }

        $statusInfo = StatusModel::getById(['id' => $data['status'], 'select' => ['label_status']]);
        if (empty($statusInfo)) {
            return $response->withStatus(400)->withJson(['errors' => _STATUS_NOT_FOUND]);
        }
        if (empty($data['historyMessage'])) {
            $data['historyMessage'] = _UPDATE_STATUS;
            $data['historyMessage'] = str_replace("{2}", $statusInfo['label_status'], $data['historyMessage']);

            $data['admin'] = $data['admin'] ?? null;
            if ($data['admin'] == 'true') {
                $data['historyMessage'] = '[' . _ADMINISTRATION . '] ' . $data['historyMessage'];
            }
        }

        $check = Validator::arrayType()->notEmpty()->validate($data['chrono'] ?? []) ||
            Validator::arrayType()->notEmpty()->validate($data['resId'] ?? []);
        $check = $check && Validator::stringType()->notEmpty()->validate($data['status']);
        $check = $check && Validator::stringType()->notEmpty()->validate($data['historyMessage']);
        if (!$check) {
            return $response->withStatus(400)->withJson(['errors' => 'Bad Request']);
        }

        $closedActions = ActionModel::get([
            'select' => ['distinct id_status'],
            'where'  => ['component in (?)'],
            'data'   => [['closeMailAction', 'closeMailWithAttachmentsOrNotesAction', 'closeAndIndexAction']]
        ]);
        $closedStatus = array_column($closedActions, 'id_status');
        $closingDate = in_array($data['status'], $closedStatus) ? 'CURRENT_TIMESTAMP' : null;

        $identifiers = !empty($data['chrono']) ? $data['chrono'] : $data['resId'];
        foreach ($identifiers as $id) {
            if (!empty($data['chrono'])) {
                $document = ResModel::getByAltIdentifier(
                    ['altIdentifier' => trim($id), 'select' => ['res_id', 'status']]
                );
            } else {
                $document = ResModel::getById(['resId' => $id, 'select' => ['res_id', 'status']]);
            }
            if (empty($document)) {
                return $response->withStatus(400)->withJson(['errors' => _DOCUMENT_NOT_FOUND]);
            }
            if (!ResController::hasRightByResId(['resId' => [$document['res_id']], 'userId' => $GLOBALS['id']])) {
                return $response->withStatus(403)->withJson(['errors' => 'Document out of perimeter']);
            }

            if ($closingDate == null) {
                ResModel::update(
                    [
                        'set'   => ['status' => $data['status'], 'closing_date' => $closingDate],
                        'where' => ['res_id = ?'],
                        'data'  => [$document['res_id']]
                    ]
                );
            } else {
                ResModel::update(
                    [
                        'set'   => ['status' => $data['status'], 'closing_date' => $closingDate],
                        'where' => ['res_id = ?', 'closing_date is null'],
                        'data'  => [$document['res_id']]
                    ]
                );
            }

            $statusInfo = StatusModel::getById(['id' => $document['status'], 'select' => ['label_status']]);
            $data['historyMessage'] = str_replace("{1}", $statusInfo['label_status'], $data['historyMessage']);

            // EDISSYUM - NCH01 Add closing_date if status == 'END'
            $eventType = 'UP';
            if ($data['status'] == 'END') {
                $eventType = 'ACTION#';
            }
            // END EDISSYUM - NCH01

            HistoryController::add([
                'tableName' => 'res_letterbox',
                'recordId'  => $document['res_id'],
                'eventType' => $eventType,  // EDISSYUM - NCH01 Add closing_date if status == 'END' | Change 'UP' to $eventType
                'info'      => $data['historyMessage'],
                'moduleId'  => 'resource',
                'eventId'   => 'resup',
            ]);
        }

        return $response->withJson(['success' => 'success']);
    }

    /**
     * @param Request $request
     * @param Response $response
     * @param array $args
     * @return Response
     * @throws Exception
     */
    public function getFileContent(Request $request, Response $response, array $args): Response
    {
        if (
            !Validator::intVal()->validate($args['resId']) ||
            !ResController::hasRightByResId(['resId' => [$args['resId']], 'userId' => $GLOBALS['id']])
        ) {
            return $response->withStatus(403)->withJson(['errors' => 'Document out of perimeter']);
        }

        $retrieveResourceFactory = RetrieveResourceFactory::createRetrieveResource();

        $data = $request->getQueryParams();

        $watermark = true;

        try {
            if (isset($data['watermark']) && $data['watermark'] === "false") {
                $watermark = false;
            }
            $mainFile = $retrieveResourceFactory->getResourceFile($args['resId'], $watermark);
        } catch (Throwable $th) {
            return $response->withStatus(
                $th->getCode() > 500 || $th->getCode() < 100 ? 500 : $th->getCode()
            )->withJson(
                ['errors' => $th->getMessage()]
            );
        }

        $creatorId = $mainFile->getCreatorId();
        $originalFormat = $mainFile->getOriginalFormat();
        $formatFilename = $mainFile->getFormatFilename();
        $pathInfo = $mainFile->getPathInfo();
        $fileContent = $mainFile->getFileContent();

        HistoryController::add([
            'tableName' => 'res_letterbox',
            'recordId'  => $args['resId'],
            'eventType' => 'VIEW',
            'info'      => _DOC_DISPLAYING . " : {$args['resId']}",
            'moduleId'  => 'resource',
            'eventId'   => 'resview',
        ]);

        $mimeAndSize = CoreController::getMimeTypeAndFileSize(['encodedFile' => base64_encode($fileContent)]);
        if (!empty($mimeAndSize['errors'])) {
            return $response->withStatus(400)->withJson(['errors' => $mimeAndSize['errors']]);
        }
        $mimeType = $mimeAndSize['mime'];

        $data['mode'] = $data['mode'] ?? null;
        if ($data['mode'] == 'base64') {
            $listInstance = ListInstanceModel::get([
                'select'  => ['listinstance_id', 'item_id'],
                'where'   => ['res_id = ?', 'signatory = ?'],
                'data'    => [$args['resId'], 'true'],
                'orderBy' => ['listinstance_id desc'],
                'limit'   => 1
            ]);

            $signatoryId = $listInstance[0]['item_id'] ?? $creatorId;

            return $response->withJson([
                'encodedDocument'   => base64_encode($fileContent),
                'originalFormat'    => $originalFormat,
                'filename'          => $formatFilename . '.' . $originalFormat,
                'mimeType'          => $mimeType,
                'originalCreatorId' => $creatorId,
                'signatoryId'       => $signatoryId
            ]);
        } else {
            $response->write($fileContent);
            $contentDisposition = $data['mode'] == 'view' ? 'inline' : 'attachment';
            $response = $response->withAddedHeader(
                'Content-Disposition',
                "{$contentDisposition}; filename={$formatFilename}.{$pathInfo['extension']}"
            );
            return $response->withHeader('Content-Type', $mimeType);
        }
    }

    /**
     * @param Request $request
     * @param Response $response
     * @param array $args
     * @return Response
     * @throws Exception
     */
    public function getVersionsInformations(Request $request, Response $response, array $args): Response
    {
        if (
            !Validator::intVal()->validate($args['resId']) ||
            !ResController::hasRightByResId(['resId' => [$args['resId']], 'userId' => $GLOBALS['id']])
        ) {
            return $response->withStatus(403)->withJson(['errors' => 'Document out of perimeter']);
        }

        $docVersions = [];
        $pdfVersions = [];
        $signedVersions = [];
        $noteVersions = [];
        $resource = ResModel::getById([
            'resId' => $args['resId'],
            'select' => ['version', 'filename', 'format', 'external_state']
        ]);

        if (empty($resource['filename'])) {
            return $response->withJson(
                ['DOC' => $docVersions, 'PDF' => $pdfVersions, 'SIGN' => $signedVersions, 'NOTE' => $noteVersions]
            );
        }

        $canConvert = ConvertPdfController::canConvert(['extension' => $resource['format']]);

        $convertedDocuments = AdrModel::getDocuments([
            'select'  => ['type', 'version'],
            'where'   => ['res_id = ?', 'type in (?)'],
            'data'    => [$args['resId'], ['DOC', 'PDF', 'SIGN', 'NOTE']],
            'orderBy' => ['version ASC']
        ]);
        if (empty($convertedDocuments)) {
            return $response->withJson(
                [
                    'DOC'     => [$resource['version']],
                    'PDF'     => $pdfVersions,
                    'SIGN'    => $signedVersions,
                    'NOTE'    => $noteVersions,
                    'convert' => $canConvert
                ]
            );
        }

        foreach ($convertedDocuments as $convertedDocument) {
            if ($convertedDocument['type'] == 'DOC') {
                $docVersions[] = $convertedDocument['version'];
            } elseif ($convertedDocument['type'] == 'PDF') {
                $pdfVersions[] = $convertedDocument['version'];
            } elseif ($convertedDocument['type'] == 'SIGN') {
                $signedVersions[] = $convertedDocument['version'];
            } elseif ($convertedDocument['type'] == 'NOTE') {
                $noteVersions[] = $convertedDocument['version'];
            }
        }
        $docVersions[] = $resource['version'];

        $env = new Environment();
        if ($env->isNewInternalParapheurEnabled() && !empty($resource['external_state'])) {
            $externalState = json_decode($resource['external_state'], true);
            if (!empty($externalState['lastUnsignedVersion'])) {
                return $response->withJson(
                    [
                        'DOC'                 => $docVersions,
                        'PDF'                 => $pdfVersions,
                        'SIGN'                => $signedVersions,
                        'NOTE'                => $noteVersions,
                        'lastUnsignedVersion' => $externalState['lastUnsignedVersion'],
                        'convert'             => $canConvert
                    ]
                );
            }
        }

        return $response->withJson(
            [
                'DOC'     => $docVersions,
                'PDF'     => $pdfVersions,
                'SIGN'    => $signedVersions,
                'NOTE'    => $noteVersions,
                'convert' => $canConvert
            ]
        );
    }

    /**
     * @param Request $request
     * @param Response $response
     * @param array $args
     * @return Response
     * @throws Exception
     */
    public function getVersionFileContent(Request $request, Response $response, array $args): Response
    {
        if (
            !Validator::intVal()->validate($args['resId']) ||
            !ResController::hasRightByResId(['resId' => [$args['resId']], 'userId' => $GLOBALS['id']])
        ) {
            return $response->withStatus(403)->withJson(['errors' => 'Document out of perimeter']);
        }

        $queryParams = $request->getQueryParams();

        $type = 'PDF';
        if (!empty($queryParams['type']) && in_array($queryParams['type'], ['PDF', 'SIGN', 'NOTE'])) {
            $type = $queryParams['type'];
        }

        if (
            $type == 'NOTE' && !PrivilegeController::hasPrivilege(
                ['privilegeId' => 'view_documents_with_notes', 'userId' => $GLOBALS['id']]
            )
        ) {
            return $response->withStatus(403)->withJson(['errors' => 'Document out of perimeter']);
        }

        $retrieveResourceFactory = RetrieveResourceFactory::createRetrieveVersionResource();
        try {
            $resourceVersionFile = $retrieveResourceFactory->getResourceFile($args['resId'], $args['version'], $type);
        } catch (Throwable $th) {
            return $response->withStatus(
                $th->getCode() > 500 || $th->getCode() < 100 ? 500 : $th->getCode()
            )->withJson(
                ['errors' => $th->getMessage()]
            );
        }

        $formatFilename = $resourceVersionFile->getFormatFilename();
        $pathInfo = $resourceVersionFile->getPathInfo();
        $fileContent = $resourceVersionFile->getFileContent();

        return $response->withJson(
            [
                'encodedDocument' => base64_encode($fileContent),
                'filename'        => $formatFilename . '_V' . $args['version'] . '.' . $pathInfo['extension']
            ]
        );
    }

    /**
     * @param Request $request
     * @param Response $response
     * @param array $args
     * @return Response
     * @throws Exception
     */
    public function getOriginalFileContent(Request $request, Response $response, array $args): Response
    {
        if (
            !Validator::intVal()->validate($args['resId']) ||
            !ResController::hasRightByResId(['resId' => [$args['resId']], 'userId' => $GLOBALS['id']])
        ) {
            return $response->withStatus(403)->withJson(['errors' => 'Document out of perimeter']);
        }

        $data = $request->getQueryParams();

        $dataMode = $data['mode'] ?? '';
        $signedVersion = false;

        if (isset($data['signedVersion'])) {
            $signedVersion = filter_var(
                $data['signedVersion'],
                FILTER_VALIDATE_BOOLEAN,
                FILTER_NULL_ON_FAILURE
            );

            if (!Validator::boolType()->validate($signedVersion)) {
                return $response->withStatus(403)->withJson(['errors' => 'signedVersion param is not a boolean']);
            }
        }

        $retrieveResourceFactory = RetrieveResourceFactory::createRetrieveOriginalResource();

        try {
            $originalMainFile = $retrieveResourceFactory->getResourceFile($args['resId'], $signedVersion);
        } catch (Throwable $th) {
            return $response->withStatus(
                $th->getCode() > 500 || $th->getCode() < 100 ? 500 : $th->getCode()
            )->withJson(
                ['errors' => $th->getMessage()]
            );
        }

        $formatFilename = $originalMainFile->getFormatFilename();
        $pathInfo = $originalMainFile->getPathInfo();
        $fileContent = $originalMainFile->getFileContent();

        HistoryController::add([
            'tableName' => 'res_letterbox',
            'recordId'  => $args['resId'],
            'eventType' => 'VIEW',
            'info'      => _DOC_DISPLAYING . " : {$args['resId']}",
            'moduleId'  => 'resource',
            'eventId'   => 'resview',
        ]);

        $mimeAndSize = CoreController::getMimeTypeAndFileSize(['encodedFile' => base64_encode($fileContent)]);
        if (!empty($mimeAndSize['errors'])) {
            return $response->withStatus(400)->withJson(['errors' => $mimeAndSize['errors']]);
        }
        $mimeType = $mimeAndSize['mime'];

        if ($dataMode == 'base64') {
            return $response->withJson(
                [
                    'encodedDocument' => base64_encode($fileContent),
                    'extension'       => $pathInfo['extension'],
                    'mimeType'        => $mimeType,
                    'filename'        => $formatFilename . '.' . $pathInfo['extension']
                ]
            );
        } else {
            $response->write($fileContent);
            $response = $response->withAddedHeader(
                'Content-Disposition',
                "attachment; filename={$formatFilename}.{$pathInfo['extension']}"
            );
            return $response->withHeader('Content-Type', $mimeType);
        }
    }

    /**
     * @param Request $request
     * @param Response $response
     * @param array $args
     * @return Response
     * @throws Exception
     */
    public function getThumbnailContent(Request $request, Response $response, array $args): Response
    {
        if (!Validator::intVal()->validate($args['resId'])) {
            return $response->withStatus(403)->withJson(['errors' => 'resId param is not an integer']);
        }

        $retrieveResourceFactory = RetrieveResourceFactory::createRetrieveThumbnailResource();

        try {
            $thumbnailFile = $retrieveResourceFactory->getThumbnailFile($args['resId']);
        } catch (Throwable $th) {
            return $response->withStatus(
                $th->getCode() > 500 || $th->getCode() < 100 ? 500 : $th->getCode()
            )->withJson(
                ['errors' => $th->getMessage()]
            );
        }

        $formatFilename = $thumbnailFile->getFormatFilename();
        $fileContent = $thumbnailFile->getFileContent();

        $mimeAndSize = CoreController::getMimeTypeAndFileSize(['encodedFile' => base64_encode($fileContent)]);
        if (!empty($mimeAndSize['errors'])) {
            return $response->withStatus(400)->withJson(['errors' => $mimeAndSize['errors']]);
        }
        $mimeType = $mimeAndSize['mime'];

        $response->write($fileContent);
        $response = $response->withAddedHeader('Content-Disposition', "inline; filename=$formatFilename");

        return $response->withHeader('Content-Type', $mimeType);
    }

    public function getThumbnailContentByPage(Request $request, Response $response, array $args)
    {
        if (!Validator::intVal()->validate($args['resId'])) {
            return $response->withStatus(403)->withJson(['errors' => 'resId param is not an integer']);
        }
        if (!Validator::intVal()->validate($args['page'])) {
            return $response->withStatus(403)->withJson(['errors' => 'page param is not an integer']);
        }

        $retrieveResourceFactory = RetrieveResourceFactory::createRetrieveThumbnailResourceByPage();

        try {
            $thumbnailFileByPage = $retrieveResourceFactory->getThumbnailFileByPage($args['resId'], $args['page']);
        } catch (Throwable $th) {
            return $response->withStatus(
                $th->getCode() > 500 || $th->getCode() < 100 ? 500 : $th->getCode()
            )->withJson(
                ['errors' => $th->getMessage()]
            );
        }

        $base64Content = base64_encode($thumbnailFileByPage->getFileContent());

        return $response->withJson(
            ['fileContent' => $base64Content, 'pageCount' => $thumbnailFileByPage->getPageCount()]
        );
    }

    /**
     * @param Request $request
     * @param Response $response
     * @param array $args
     * @return Response
     * @throws Exception
     */
    public function getItems(Request $request, Response $response, array $args): Response
    {
        if (
            !Validator::intVal()->validate($args['resId']) ||
            !ResController::hasRightByResId(['resId' => [$args['resId']], 'userId' => $GLOBALS['id']])
        ) {
            return $response->withStatus(403)->withJson(['errors' => 'Document out of perimeter']);
        }

        $document = ResModel::getById([
            'select' => ['linked_resources'],
            'resId'  => $args['resId']
        ]);
        if (empty($document)) {
            return $response->withStatus(400)->withJson(['errors' => 'Document does not exist']);
        }

        $linkedResources = json_decode($document['linked_resources'], true);
        if (!empty($linkedResources)) {
            $linkedResources = ResController::getAuthorizedResources(
                ['resources' => $linkedResources, 'userId' => $GLOBALS['id']]
            );
        }
        $formattedData['linkedResources'] = count($linkedResources);

        $attachments = AttachmentModel::get([
            'select' => ['count(1)'],
            'where'  => ['res_id_master = ?', 'status in (?)', 'attachment_type not in (?)'],
            'data'   => [$args['resId'], ['TRA', 'A_TRA', 'FRZ'], AttachmentTypeController::HIDDEN_ATTACHMENT_TYPES]
        ]);
        $formattedData['attachments'] = $attachments[0]['count'];

        $formattedData['diffusionList'] = 0;
        $formattedData['visaCircuit'] = 0;
        $formattedData['opinionCircuit'] = 0;
        $listInstanceItems = ListInstanceModel::get(
            [
                'select'  => ['count(1)', 'difflist_type'],
                'where'   => ['res_id = ?'],
                'data'    => [$args['resId']],
                'groupBy' => ['difflist_type']
            ]
        );
        foreach ($listInstanceItems as $item) {
            $type = $item['difflist_type'] == 'entity_id' ? 'diffusionList' : ($item['difflist_type'] ==
            'VISA_CIRCUIT' ? 'visaCircuit' : 'opinionCircuit');
            $formattedData[$type] = $item['count'];
        }

        $formattedData['notes'] = NoteModel::countByResId([
            'resId'  => [$args['resId']],
            'userId' => $GLOBALS['id']
        ])[$args['resId']];

        $emails = EmailModel::get(
            [
                'select' => ['count(1)'],
                'where'  => ["document->>'id' = ?", "(status != 'DRAFT' or (status = 'DRAFT' and user_id = ?))"],
                'data'   => [$args['resId'], $GLOBALS['id']]
            ]
        );
        $acknowledgementReceipts = AcknowledgementReceiptModel::get([
            'select' => ['count(1)'],
            'where'  => ['res_id = ?'],
            'data'   => [$args['resId']]
        ]);
        $messageExchanges = MessageExchangeModel::get([
            'select' => ['count(1)'],
            'where'  => ['res_id_master = ?'],
            'data'   => [$args['resId']]
        ]);
        $attachments = AttachmentModel::get([
            'select' => ['res_id'],
            'where'  => ['res_id_master = ?'],
            'data'   => [$args['resId']]
        ]);
        $attachments = array_column($attachments, 'res_id');

        $where = '(document_id = ? and document_type = ?)';
        $data = [$args['resId'], 'resource'];
        if (!empty($attachments)) {
            $where .= ' or (document_id in (?) and document_type = ?)';
            $data[] = $attachments;
            $data[] = 'attachment';
        }
        $shippings = ShippingModel::get([
            'select' => ['count(1)'],
            'where'  => [$where],
            'data'   => $data
        ]);

        $formattedData['emails'] = $emails[0]['count'] + $acknowledgementReceipts[0]['count'] +
            $messageExchanges[0]['count'] + $shippings[0]['count'];

        return $response->withJson($formattedData);
    }

    /**
     * @param Request $request
     * @param Response $response
     * @return Response
     */
    public function getCategories(Request $request, Response $response): Response
    {
        return $response->withJson(['categories' => ResModel::getCategories()]);
    }

    /**
     * @param Request $request
     * @param Response $response
     * @param array $aArgs
     * @return Response
     * @throws Exception
     */
    public function isAllowedForCurrentUser(Request $request, Response $response, array $aArgs): Response
    {
        if (
            !Validator::intVal()->validate($aArgs['resId']) ||
            !ResController::hasRightByResId(['resId' => [$aArgs['resId']], 'userId' => $GLOBALS['id']])
        ) {
            return $response->withJson(['isAllowed' => false]);
        }

        return $response->withJson(['isAllowed' => true]);
    }

    /**
     * @param Request $request
     * @param Response $response
     * @return Response
     * @throws Exception
     */
    public function updateExternalInfos(Request $request, Response $response): Response
    {
        $data = $request->getParsedBody();

        if (empty($data['externalInfos'])) {
            return $response->withStatus(400)->withJson(['errors' => 'Bad Request : externalInfos is empty']);
        }
        if (empty($data['status'])) {
            return $response->withStatus(400)->withJson(['errors' => 'Bad Request : status is empty']);
        }

        foreach ($data['externalInfos'] as $mail) {
            if (!Validator::intType()->validate($mail['res_id'])) {
                return $response->withStatus(400)->withJson(['errors' => 'Bad Request: invalid res_id']);
            }
            if (!Validator::StringType()->notEmpty()->validate($mail['external_id'])) {
                return $response->withStatus(400)->withJson(
                    ['errors' => 'Bad Request: invalid external_id for element : ' . $mail['res_id']]
                );
            }
        }

        foreach ($data['externalInfos'] as $mail) {
            $document = ResModel::getById(['resId' => $mail['res_id'], 'select' => ['res_id', 'external_id']]);
            if (empty($document)) {
                return $response->withStatus(400)->withJson(['errors' => _DOCUMENT_NOT_FOUND]);
            }
            if (!ResController::hasRightByResId(['resId' => [$document['res_id']], 'userId' => $GLOBALS['id']])) {
                return $response->withStatus(403)->withJson(['errors' => 'Document out of perimeter']);
            }
            $externalId = json_decode($document['external_id'], true);
            // EDISSYUM - PYB01 Rajouter la possibilité de spécifier l'application quand on ajoute un id externe à un courrier
            // $externalId['publikId'] = $mail['external_id'];
            if (isset($mail['app'])) {
                $externalId[$mail['app']] = $mail['external_id'];
            } else {
                $externalId['publikId'] = $mail['external_id'];
            }
            // END EDISSYUM - PYB01
            ResModel::update(
                [
                    'set'   => ['external_id' => json_encode($externalId), 'status' => $data['status']],
                    'where' => ['res_id = ?'],
                    'data'  => [$document['res_id']]
                ]
            );
        }

        return $response->withJson(['success' => 'success']);
    }

    /**
     * @param Request $request
     * @param Response $response
     * @return Response
     * @throws Exception
     */
    public static function setInIntegrations(Request $request, Response $response): Response
    {
        $body = $request->getParsedBody();

        if (empty($body['resources']) || !Validator::arrayType()->validate($body['resources'])) {
            return $response->withStatus(400)->withJson(['errors' => 'Body param resources is missing']);
        }
        if (!ResController::hasRightByResId(['resId' => $body['resources'], 'userId' => $GLOBALS['id']])) {
            return $response->withStatus(403)->withJson(['errors' => 'Document out of perimeter']);
        }

        if (empty($body['integrations']) || !Validator::arrayType()->validate($body['integrations'])) {
            return $response->withStatus(400)->withJson(
                ['errors' => 'Body param integrations is missing or not an array']
            );
        }

        $documents = ResModel::get([
            'select' => ['alt_identifier', 'res_id'],
            'where'  => ['res_id in (?)'],
            'data'   => [$body['resources']]
        ]);
        $documents = array_column($documents, 'alt_identifier', 'res_id');

        if (
            isset($body['integrations']['inSignatureBook']) &&
            Validator::boolType()->validate($body['integrations']['inSignatureBook'])
        ) {
            $inSignatureBook = $body['integrations']['inSignatureBook'] ? 'true' : 'false';

            ResModel::update([
                'postSet' => [
                    'integrations' => "jsonb_set(integrations, '{inSignatureBook}', '" . $inSignatureBook . "')",
                ],
                'where'   => ['res_id in (?)'],
                'data'    => [$body['resources']]
            ]);

            $info = $body['integrations']['inSignatureBook']
                ? _DOC_ADD_TO_SIGNATORY_BOOK
                : _DOC_REMOVE_FROM_SIGNATORY_BOOK;
            foreach ($body['resources'] as $resId) {
                HistoryController::add([
                    'tableName' => 'res_letterbox',
                    'recordId'  => $resId,
                    'eventType' => 'UP',
                    'info'      => $info . " : " . $documents[$resId],
                    'moduleId'  => 'resource',
                    'eventId'   => 'resourceModification',
                ]);
            }
        }

        if (
            isset($body['integrations']['inShipping']) &&
            Validator::boolType()->validate($body['integrations']['inShipping'])
        ) {
            $inShipping = $body['integrations']['inShipping'] ? 'true' : 'false';

            ResModel::update([
                'postSet' => [
                    'integrations' => "jsonb_set(integrations, '{inShipping}', '" . $inShipping . "')",
                ],
                'where'   => ['res_id in (?)'],
                'data'    => [$body['resources']]
            ]);

            $info = $body['integrations']['inShipping'] ? _DOC_ADD_TO_MAILEVA : _DOC_REMOVE_FROM_MAILEVA;
            foreach ($body['resources'] as $resId) {
                HistoryController::add([
                    'tableName' => 'res_letterbox',
                    'recordId'  => $resId,
                    'eventType' => 'UP',
                    'info'      => $info . " : " . $documents[$resId],
                    'moduleId'  => 'resource',
                    'eventId'   => 'resourceModification',
                ]);
            }
        }

        return $response->withStatus(204);
    }

    /**
     * @param Request $request
     * @param Response $response
     * @param array $args
     * @return Response
     * @throws Exception
     */
    public function getField(Request $request, Response $response, array $args): Response
    {
        if (!ResController::hasRightByResId(['resId' => [$args['resId']], 'userId' => $GLOBALS['id']])) {
            return $response->withStatus(403)->withJson(['errors' => 'Document out of perimeter']);
        }

        $authorizedFields = ['destination', 'status', 'externalId'];
        if (!in_array($args['fieldId'], $authorizedFields)) {
            return $response->withStatus(403)->withJson(['errors' => 'Field out of perimeter']);
        }
        $mapping = [
            'destination' => 'destination',
            'status'      => 'status',
            'externalId'  => 'external_id'
        ];

        $resource = ResModel::getById([
            'select' => [$mapping[$args['fieldId']]],
            'resId'  => $args['resId']
        ]);
        if (empty($resource)) {
            return $response->withStatus(400)->withJson(['errors' => 'Document does not exist']);
        }

        $queryParams = $request->getQueryParams();
        if ($args['fieldId'] == 'destination' && !empty($queryParams['alt']) && !empty($resource['destination'])) {
            $entity = EntityModel::getByEntityId(['entityId' => $resource['destination'], 'select' => ['id']]);
            $resource['destination'] = $entity['id'];
        } elseif ($args['fieldId'] == 'externalId') {
            $resource['externalId'] = json_decode($resource['external_id'], true);
        }

        return $response->withJson(['field' => $resource[$args['fieldId']]]);
    }

    /**
     * @param array $aArgs
     * @return array|string[]
     * @throws Exception
     */
    public static function getEncodedDocument(array $aArgs): array
    {
        ValidatorModel::notEmpty($aArgs, ['resId']);
        ValidatorModel::intVal($aArgs, ['resId']);
        ValidatorModel::boolType($aArgs, ['original']);

        $document = ResModel::getById(
            ['select' => ['docserver_id', 'path', 'filename', 'subject', 'fingerprint'], 'resId' => $aArgs['resId']]
        );

        if (empty($aArgs['original'])) {
            $convertedDocument = ConvertPdfController::getConvertedPdfById(
                ['resId' => $aArgs['resId'], 'collId' => 'letterbox_coll']
            );

            if (empty($convertedDocument['errors'])) {
                $document['docserver_id'] = $convertedDocument['docserver_id'];
                $document['path'] = $convertedDocument['path'];
                $document['filename'] = $convertedDocument['filename'];
                $document['fingerprint'] = $convertedDocument['fingerprint'];
            }
        }

        $docserver = DocserverModel::getByDocserverId(
            ['docserverId' => $document['docserver_id'], 'select' => ['path_template', 'docserver_type_id']]
        );
        if (empty($docserver['path_template']) || !file_exists($docserver['path_template'])) {
            return ['errors' => 'Docserver does not exist'];
        }

        $pathToDocument = $docserver['path_template'] .
            str_replace('#', DIRECTORY_SEPARATOR, $document['path']) .
            $document['filename'];
        if (!file_exists($pathToDocument)) {
            return ['errors' => 'Document not found on docserver'];
        }

        $docserverType = DocserverTypeModel::getById(
            ['id' => $docserver['docserver_type_id'], 'select' => ['fingerprint_mode']]
        );
        $fingerprint = StoreController::getFingerPrint(
            ['filePath' => $pathToDocument, 'mode' => $docserverType['fingerprint_mode']]
        );
        if (empty($convertedDocument) && empty($document['fingerprint'])) {
            ResModel::update(
                ['set' => ['fingerprint' => $fingerprint], 'where' => ['res_id = ?'], 'data' => [$aArgs['resId']]]
            );
            $document['fingerprint'] = $fingerprint;
        }
        if ($document['fingerprint'] != $fingerprint) {
            return ['errors' => 'Fingerprints do not match'];
        }

        $fileContent = file_get_contents($pathToDocument);
        if ($fileContent === false) {
            return ['errors' => 'Document not found on docserver'];
        }

        $encodedDocument = base64_encode($fileContent);

        if (!empty($document['subject'])) {
            $document['subject'] = TextFormatModel::formatFilename(
                ['filename' => $document['subject'], 'maxLength' => 30]
            );
        }

        $pathInfo = pathinfo($pathToDocument);
        $fileName = (empty($document['subject']) ? 'document' : $document['subject']) . ".{$pathInfo['extension']}";

        return ['encodedDocument' => $encodedDocument, 'fileName' => $fileName];
    }

    /**
     * @param array $args
     * @return bool
     * @throws Exception
     */
    public static function hasRightByResId(array $args): bool
    {
        ValidatorModel::notEmpty($args, ['resId', 'userId']);
        ValidatorModel::intVal($args, ['userId']);
        ValidatorModel::arrayType($args, ['resId']);

        $resources = array_unique($args['resId']);

        $authorizedResources = ResController::getAuthorizedResources(
            ['resources' => $resources, 'userId' => $args['userId'], 'mode' => 'groups']
        );
        if (count($authorizedResources) != count($resources)) {
            $authorizedResourcesBasket = ResController::getAuthorizedResources(
                ['resources' => $resources, 'userId' => $args['userId'], 'mode' => 'baskets']
            );
            $authorizedResources = array_merge($authorizedResources, $authorizedResourcesBasket);
            $authorizedResources = array_unique($authorizedResources);
            if (count($authorizedResources) != count($resources)) {
                $authorizedResourcesFolders = ResController::getAuthorizedResources(
                    ['resources' => $resources, 'userId' => $args['userId'], 'mode' => 'folders']
                );
                $authorizedResources = array_merge($authorizedResources, $authorizedResourcesFolders);
                $authorizedResources = array_unique($authorizedResources);
                return count($authorizedResources) == count($resources);
            }
        }

        return true;
    }

    /**
     * @param array $args
     * @return array
     * @throws Exception
     */
    public static function getAuthorizedResources(array $args): array
    {
        ValidatorModel::notEmpty($args, ['resources', 'userId']);
        ValidatorModel::intVal($args, ['userId']);
        ValidatorModel::arrayType($args, ['resources']);

        if (UserController::isRoot(['id' => $args['userId']])) {
            return $args['resources'];
        }

        $mode = null;
        if (!empty($args['mode'])) {
            $mode = $args['mode'];
        }

        $user = UserModel::getById(['id' => $args['userId'], 'select' => ['user_id']]);
        $userDataClause = SearchController::getUserDataClause(
            ['userId' => $args['userId'], 'login' => $user['user_id'], 'mode' => $mode]
        );

        $data = [$args['resources']];
        $data = array_merge($data, $userDataClause['searchData']);

        try {
            $res = ResModel::getOnView(
                [
                    'select' => ['res_id'],
                    'where'  => ['res_id in (?)', "({$userDataClause['searchWhere'][0]})"],
                    'data'   => $data
                ]
            );
            return array_column($res, 'res_id');
        } catch (Exception $e) {
            return [];
        }
    }

    /**
     * @param array $args
     * @return void
     * @throws Exception
     */
    private static function createAdjacentData(array $args): void
    {
        ValidatorModel::notEmpty($args, ['resId', 'body']);
        ValidatorModel::intVal($args, ['resId']);
        ValidatorModel::arrayType($args, ['body']);

        $body = $args['body'];

        if (!empty($body['diffusionList'])) {
            foreach ($body['diffusionList'] as $diffusion) {
                if ($diffusion['mode'] == 'dest') {
                    ResModel::update(
                        [
                            'set'   => ['dest_user' => $diffusion['id']],
                            'where' => ['res_id = ?'],
                            'data'  => [$args['resId']]
                        ]
                    );
                }
                ListInstanceModel::create([
                    'res_id'        => $args['resId'],
                    'sequence'      => 0,
                    'item_id'       => $diffusion['id'],
                    'item_type'     => $diffusion['type'] == 'user' ? 'user_id' : 'entity_id',
                    'item_mode'     => $diffusion['mode'],
                    'added_by_user' => $GLOBALS['id'],
                    'difflist_type' => 'entity_id'
                ]);
            }
        } elseif (!empty($body['destination']) && empty($body['emptyDiffusionList'])) { // EDISSYUM - NCH01 Ajout d'une option via l'API pour éviter de remplir la liste de diffusion | Ajout && empty($body['emptyDiffusionList'])
            $where = ['entity_id = ? AND type = ?'];
            $data = [$body['destination'], 'diffusionList'];
            $listTemplate = ListTemplateModel::get(['select' => ['*'], 'where' => $where, 'data' => $data])[0] ??
                [];
            if (!empty($listTemplate)) {
                $listTemplateItems = ListTemplateItemModel::get(
                    ['select' => ['*'], 'where' => ['list_template_id = ?'], 'data' => [$listTemplate['id']]]
                );
                foreach ($listTemplateItems as $itemKey => $value) {
                    if ($value['item_type'] == 'user') {
                        $user = UserModel::getById(
                            [
                                'id'     => $value['item_id'],
                                'select' => ['firstname', 'lastname', 'external_id', 'status']
                            ]
                        );
                        if (empty($user) || in_array($user['status'], ['SPD', 'DEL'])) {
                            if ($listTemplate['type'] == 'diffusionList') {
                                unset($listTemplateItems[$itemKey]);
                                continue;
                            }
                        }
                    }
                }
                $listTemplate['items'] = array_values($listTemplateItems);
                if (!empty($listTemplateItems)) {
                    foreach ($listTemplateItems as $diffusion) {
                        if ($diffusion['item_mode'] == 'dest') {
                            ResModel::update(
                                [
                                    'set'   => ['dest_user' => $diffusion['item_id']], // Fix pour éviter de remonter un mauvais dest_user lors de la création d'un courrier | Remplacer $diffusion['id'] par $diffusion['item_id']
                                    'where' => ['res_id = ?'],
                                    'data'  => [$args['resId']]
                                ]
                            );
                        }
                        ListInstanceModel::create([
                            'res_id'        => $args['resId'],
                            'sequence'      => $diffusion['sequence'],
                            'item_id'       => $diffusion['item_id'],
                            'item_type'     => $diffusion['item_type'] == 'user' ? 'user_id' : 'entity_id',
                            'item_mode'     => $diffusion['item_mode'],
                            'added_by_user' => $GLOBALS['id'],
                            'difflist_type' => 'entity_id'
                        ]);
                    }
                }
            }
        }
        if (!empty($body['folders'])) {
            foreach ($body['folders'] as $folder) {
                ResourceFolderModel::create(['res_id' => $args['resId'], 'folder_id' => $folder]);
            }
        }
        if (!empty($body['tags'])) {
            foreach ($body['tags'] as $tag) {
                ResourceTagModel::create(['res_id' => $args['resId'], 'tag_id' => $tag]);
            }
        }
        if (!empty($body['senders'])) {
            foreach ($body['senders'] as $sender) {
                ResourceContactModel::create(
                    [
                        'res_id'  => $args['resId'],
                        'item_id' => $sender['id'],
                        'type'    => $sender['type'],
                        'mode'    => 'sender'
                    ]
                );
            }
        }
        if (!empty($body['recipients'])) {
            foreach ($body['recipients'] as $recipient) {
                ResourceContactModel::create(
                    [
                        'res_id'  => $args['resId'],
                        'item_id' => $recipient['id'],
                        'type'    => $recipient['type'],
                        'mode'    => 'recipient'
                    ]
                );
            }
        }

        $resource = ResModel::getById(['resId' => $args['resId'], 'select' => ['custom_fields']]);
        $customFields = json_decode($resource['custom_fields'], true);

        $immutableTechnicalCustoms = CustomFieldModel::get(
            ['select' => ['id', 'values'], 'where' => ['mode = ?'], 'data' => ['technical']]
        );
        foreach ($immutableTechnicalCustoms as $immutableTechnicalCustom) {
            $immutableTechnicalCustom['values'] = json_decode($immutableTechnicalCustom['values'], true);

            if (!empty($immutableTechnicalCustom['values']['table'])) {
                $immutableTechnicalCustom['values']['resId'] = $args['resId'];
                $values = CustomFieldModel::getValuesSQL($immutableTechnicalCustom['values']);
                $customFields[$immutableTechnicalCustom['id']] = $values[0]['key'] ?? null;
            }
        }
        if (!empty($customFields)) {
            ResModel::update(
                [
                    'set'   => ['custom_fields' => json_encode($customFields)],
                    'where' => ['res_id = ?'],
                    'data'  => [$args['resId']]
                ]
            );
        }
    }

    /**
     * @param array $args
     * @return void
     * @throws Exception
     */
    private static function updateAdjacentData(array $args): void
    {
        ValidatorModel::notEmpty($args, ['resId', 'body']);
        ValidatorModel::intVal($args, ['resId']);
        ValidatorModel::arrayType($args, ['body']);

        $body = $args['body'];

        $entities = EntityModel::getWithUserEntities([
            'select' => ['entities.id'],
            'where'  => ['user_id = ?'],
            'data'   => [$GLOBALS['id']]
        ]);
        $entities = array_column($entities, 'id');
        if (empty($entities)) {
            $entities = [0];
        }
        $idToDelete = FolderModel::getWithEntitiesAndResources([
            'select' => ['resources_folders.id'],
            'where'  => [
                'resources_folders.res_id = ?',
                '(entities_folders.entity_id in (?) OR folders.user_id = ? OR keyword = ?)'
            ],
            'data'   => [$args['resId'], $entities, $GLOBALS['id'], 'ALL_ENTITIES']
        ]);
        $idToDelete = array_column($idToDelete, 'id');
        if (!empty($idToDelete) && !empty($body['folders'])) { // EDISSYUM - NCH01 Empêcher la suppression d'un dossier lors de la modification d'un courrier | Ajout de && !empty($body['folders'])
            ResourceFolderModel::delete(['where' => ['id in (?)'], 'data' => [$idToDelete]]);
        }
        if (!empty($body['folders'])) {
            foreach ($body['folders'] as $folder) {
                ResourceFolderModel::create(['res_id' => $args['resId'], 'folder_id' => $folder]);
            }
        }
        ResourceTagModel::delete(['where' => ['res_id = ?'], 'data' => [$args['resId']]]);
        if (!empty($body['tags'])) {
            foreach ($body['tags'] as $tag) {
                ResourceTagModel::create(['res_id' => $args['resId'], 'tag_id' => $tag]);
            }
        }
        ResourceContactModel::delete(['where' => ['res_id = ?'], 'data' => [$args['resId']]]);
        if (!empty($body['senders'])) {
            foreach ($body['senders'] as $sender) {
                ResourceContactModel::create(
                    [
                        'res_id'  => $args['resId'],
                        'item_id' => $sender['id'],
                        'type'    => $sender['type'],
                        'mode'    => 'sender'
                    ]
                );
            }
        }
        if (!empty($body['recipients'])) {
            foreach ($body['recipients'] as $recipient) {
                ResourceContactModel::create(
                    [
                        'res_id'  => $args['resId'],
                        'item_id' => $recipient['id'],
                        'type'    => $recipient['type'],
                        'mode'    => 'recipient'
                    ]
                );
            }
        }
    }

    /**
     * @param Request $request
     * @param Response $response
     * @return Response
     * @throws Exception
     */
    public function getList(Request $request, Response $response): Response
    {
        $data = $request->getParsedBody();

        if (!Validator::stringType()->notEmpty()->validate($data['select'])) {
            return $response->withStatus(400)->withJson(['errors' => 'Bad Request: select is not valid']);
        }
        if (!Validator::stringType()->notEmpty()->validate($data['clause'])) {
            return $response->withStatus(400)->withJson(['errors' => 'Bad Request: clause is not valid']);
        }
        if (!empty($data['withFile'])) {
            if (!Validator::boolType()->validate($data['withFile'])) {
                return $response->withStatus(400)->withJson(
                    ['errors' => 'Bad Request: withFile parameter is not a boolean']
                );
            }
        }

        if (!empty($data['orderBy'])) {
            if (!Validator::arrayType()->notEmpty()->validate($data['orderBy'])) {
                return $response->withStatus(400)->withJson(
                    ['errors' => 'Bad Request: orderBy parameter not valid']
                );
            }
        }

        if (!empty($data['limit'])) {
            if (!Validator::intType()->validate($data['limit'])) {
                return $response->withStatus(400)->withJson(
                    ['errors' => 'Bad Request: limit parameter not valid']
                );
            }
        }
        $select = explode(',', $data['select']);

        $sve_start_date = false;
        $keySve = array_search('sve_start_date', array_map('trim', $select));
        if ($keySve !== false) {
            unset($select[$keySve]);
            $sve_start_date = true;
        }

        if ($sve_start_date && empty($select)) {
            $select[] = 'res_id';
        }

        if (
            !PreparedClauseController::isRequestValid(
                [
                    'select'  => $select,
                    'clause'  => $data['clause'],
                    'orderBy' => $data['orderBy'],
                    'limit'   => $data['limit'],
                    'userId'  => $GLOBALS['login']
                ]
            )
        ) {
            return $response->withStatus(400)->withJson(['errors' => _INVALID_REQUEST]);
        }

        $where = [$data['clause']];
        if (!UserController::isRoot(['id' => $GLOBALS['id']])) {
            $groupsClause = GroupController::getGroupsClause([
                'userId' => $GLOBALS['id'],
                'login'  => $GLOBALS['login']
            ]);
            if (empty($groupsClause)) {
                return $response->withStatus(400)->withJson(['errors' => 'User has no groups']);
            }
            $where[] = "({$groupsClause})";
        }

        if ($data['withFile'] === true) {
            $select[] = 'res_id';
        }

        $resources = ResModel::getOnView(
            ['select' => $select, 'where' => $where, 'orderBy' => $data['orderBy'], 'limit' => $data['limit']]
        );
        if (!empty($resources) && $data['withFile'] === true) {
            foreach ($resources as $key => $res) {
                $document = ResModel::getById(
                    ['resId' => $res['res_id'], 'select' => ['path', 'filename', 'docserver_id']]
                );
                if (!empty($document['docserver_id'])) {
                    $docserver = DocserverModel::getByDocserverId(
                        ['docserverId' => $document['docserver_id'], 'select' => ['path_template', 'docserver_type_id']]
                    );
                    if (empty($docserver['path_template']) || !file_exists($docserver['path_template'])) {
                        $resources[$key]['fileBase64Content'] = null;
                    }
                    $pathToDocument = $docserver['path_template'] .
                        str_replace('#', DIRECTORY_SEPARATOR, $document['path']) . $document['filename'];
                    if (!file_exists($pathToDocument)) {
                        $resources[$key]['fileBase64Content'] = null;
                    }
                    $file = file_get_contents($pathToDocument);
                    $base64Content = base64_encode($file);
                    $resources[$key]['fileBase64Content'] = $base64Content;
                } else {
                    $resources[$key]['fileBase64Content'] = null;
                }
            }
        }
        if (!empty($resources) && $sve_start_date) {
            $aResId = array_column($resources, 'res_id');
            $aSveStartDate = AcknowledgementReceiptModel::getByResIds([
                'select'  => ['res_id', 'min(send_date) as send_date'],
                'resIds'  => $aResId,
                'where'   => ['send_date IS NOT NULL', 'send_date != \'\''],
                'groupBy' => ['res_id']
            ]);
            foreach ($resources as $key => $res) {
                $resources[$key]['sve_start_date'] = null;
                foreach ($aSveStartDate as $valueSveStartDate) {
                    if ($res['res_id'] == $valueSveStartDate['res_id']) {
                        $resources[$key]['sve_start_date'] = $valueSveStartDate['send_date'];
                        break;
                    }
                }
            }
        }

        return $response->withJson(['resources' => $resources, 'count' => count($resources)]);
    }

    /**
     * @param Request $request
     * @param Response $response
     * @param array $args
     * @return Response
     */
    public function getProcessingData(Request $request, Response $response, array $args): Response
    {
        if (!Validator::intVal()->validate($args['groupId'] ?? null)) {
            return $response->withStatus(403)->withJson(['errors' => 'groupId param is not an integer']);
        }
        if (!Validator::intVal()->validate($args['userId'] ?? null)) {
            return $response->withStatus(403)->withJson(['errors' => 'userId param is not an integer']);
        }
        if (!Validator::intVal()->validate($args['basketId'] ?? null)) {
            return $response->withStatus(403)->withJson(['errors' => 'basketId param is not an integer']);
        }
        if (!Validator::intVal()->validate($args['resId'] ?? null)) {
            return $response->withStatus(403)->withJson(['errors' => 'resId param is not an integer']);
        }

        $control = ResourceListController::listControl(
            [
                'groupId'       => $args['groupId'],
                'userId'        => $args['userId'],
                'basketId'      => $args['basketId'],
                'currentUserId' => $GLOBALS['id']
            ]
        );
        if (!empty($control['errors'])) {
            return $response->withStatus($control['code'])->withJson(['errors' => $control['errors']]);
        }

        $basket = BasketModel::getById(['id' => $args['basketId'], 'select' => ['basket_id']]);
        $group = GroupModel::getById(['id' => $args['groupId'], 'select' => ['group_id']]);

        $groupBasket = GroupBasketModel::get(
            [
                'select' => ['list_event_data'],
                'where'  => ['basket_id = ?', 'group_id = ?'],
                'data'   => [$basket['basket_id'], $group['group_id']]
            ]
        );

        if (empty($groupBasket[0]['list_event_data'])) {
            return $response->withJson(['listEventData' => null]);
        }

        $listEventData = json_decode($groupBasket[0]['list_event_data'], true);

        if (!empty($listEventData['canUpdateData'])) {
            $status = StatusModel::getByResId(
                ['select' => ['can_be_modified'], 'resId' => $args['resId'], 'collId' => 'letterbox_coll']
            );
            if (empty($status['can_be_modified']) || $status['can_be_modified'] != 'Y') {
                $listEventData['canUpdateData'] = false;
            }
        }

        if (empty($listEventData['canUpdateData'])) {
            $listEventData['canUpdateModel'] = false;
        }

        return $response->withJson(['listEventData' => $listEventData]);
    }

    /**
     * @param Request $request
     * @param Response $response
     * @param array $args
     * @return Response
     * @throws Exception
     */
    public function getResourceFileInformation(Request $request, Response $response, array $args): Response
    {
        if (
            !Validator::intVal()->validate($args['resId']) ||
            !ResController::hasRightByResId(['resId' => [$args['resId']], 'userId' => $GLOBALS['id']])
        ) {
            return $response->withStatus(403)->withJson(['errors' => 'Document out of perimeter']);
        }

        $resource = ResModel::getById([
            'resId'  => $args['resId'],
            'select' => [
                'format',
                'fingerprint',
                'filesize',
                'fulltext_result',
                'creation_date',
                'filename',
                'docserver_id',
                'path',
                'typist',
                'dest_user', // EDISSYUM - NCH01 Fix pour permettre la modification d'un courrier si le typist est égal à l'utilisateur connecté Add dest_user
                'category_id' // EDISSYUM - NCH01 Fix pour permettre la modification d'un courrier si le typist est égal à l'utilisateur connecté Add category_id
            ]
        ]);

        if (!empty($resource['docserver_id'])) {
            $docserver = DocserverModel::getByDocserverId(
                ['docserverId' => $resource['docserver_id'], 'select' => ['path_template']]
            );
            $resource['docserverPathFile'] = $docserver['path_template'] . $resource['path'];
            $resource['docserverPathFile'] = str_replace('//', '/', $resource['docserverPathFile']);
            $resource['docserverPathFile'] = str_replace('#', '/', $resource['docserverPathFile']);
        }

        // EDISSYUM - NCH01 Fix pour permettre la modification d'un courrier si le typist est égal à l'utilisateur connecté
        $dest_user_infos = UserModel::get([
            'select' => ['id'],
            'where'  => ['user_id = ?'],
            'data'   => [$resource['dest_user']]
        ]);
        if(!empty($dest_user_infos)){
            $resource['dest_user'] = $dest_user_infos[0]['id'];
        }
        // END EDISSYUM - NCH01

        $resource['typistLabel'] = UserModel::getLabelledUserById(['id' => $resource['typist']]);
        $resource['creationDate'] = $resource['creation_date'];
        unset($resource['creation_date']);

        $allowedFiles = StoreController::getAllowedFiles();
        $allowedFiles = array_column($allowedFiles, 'canConvert', 'extension');

        $resource['canConvert'] = false;

        if (!empty($resource['format'])) {
            $format = strtoupper($resource['format']);
            $resource['canConvert'] = !empty($allowedFiles[$format]);
        }

        if (!PrivilegeController::hasPrivilege(['privilegeId' => 'view_technical_infos', 'userId' => $GLOBALS['id']])) {
            $resource = [
                'canConvert' => $resource['canConvert'],
                'format'     => $resource['format'],
                'dest_user'     => $resource['dest_user'], // EDISSYUM - NCH01 Fix pour permettre la modification d'un courrier si le typist est égal à l'utilisateur connecté
                'category_id'   => $resource['category_id'], // EDISSYUM - NCH01 Fix pour permettre la modification d'un courrier si le typist est égal à l'utilisateur connecté
                'typist'        => $resource['typist'] // EDISSYUM - NCH01 Fix pour permettre la modification d'un courrier si le typist est égal à l'utilisateur connecté
            ];
        }

        return $response->withJson(['information' => $resource]);
    }

    /**
     * @param Request $request
     * @param Response $response
     * @return Response
     */
    public function getByExternalId(Request $request, Response $response): Response
    {
        $body = $request->getParsedBody();

        if (!Validator::notEmpty()->validate($body['type'])) {
            return $response->withStatus(403)->withJson(['errors' => 'Missing externalId type']);
        } elseif (!Validator::notEmpty()->validate($body['value'])) {
            return $response->withStatus(403)->withJson(['errors' => 'Missing externalId value']);
        }

        try {
            $document = ResModel::get([
                'select' => ['res_id'],
                'where'  => ["external_id->'" . $body['type'] . "' = ?"],
                'data'   => [$body['value']]
            ]);
        } catch (Exception $exception) {
            return $response->withStatus(400)->withJson(
                ['errors' => 'externalId type or value has wrong format']
            );
        }

        if (empty($document[0]['res_id'])) {
            return $response->withStatus(400)->withJson(['errors' => 'Document not found']);
        }

        return $response->withJson(['resId' => $document[0]['res_id']]);
    }

    /**
     * @param array $args
     * @return bool
     * @throws Exception
     */
    public static function resetResourceFields(array $args): bool
    {
        ValidatorModel::notEmpty($args, ['oldFieldList', 'newFieldList']);
        ValidatorModel::arrayType($args, ['oldFieldList', 'newFieldList']);
        ValidatorModel::intVal($args, ['resId', 'modelId']);

        if (empty($args['resId']) && empty($args['modelId'])) {
            return false;
        }

        $oldFieldList = $args['oldFieldList'];
        $newModelFields = $args['newFieldList'];

        // Set res_letterbox fields to null
        $set = [];
        $setToNull = [
            'confidentiality'    => 'confidentiality',
            'admission_date'     => 'arrivalDate',
            'departure_date'     => 'departureDate',
            'doc_date'           => 'documentDate',
            'process_limit_date' => 'processLimitDate',
            'initiator'          => 'initiator',
            'destination'        => 'destination',
            'priority'           => 'priority'
        ];
        foreach ($setToNull as $key => $field) {
            if (in_array($field, $oldFieldList) && !in_array($field, $newModelFields)) {
                $set[$key] = null;
            }
        }

        $customFieldsToDelete = array_diff($oldFieldList, $newModelFields);
        $customFieldsToDelete = array_filter($customFieldsToDelete, function ($field) {
            return str_contains($field, 'indexingCustomField_');
        });
        $customFieldsToDelete = array_map(function ($field) {
            return explode('_', $field)[1];
        }, $customFieldsToDelete);

        $postSet = ['custom_fields' => 'custom_fields '];
        foreach ($customFieldsToDelete as $item) {
            $postSet['custom_fields'] .= " - '$item'";
        }

        if (!empty($set) || !empty($postSet)) {
            $where = [];
            $data = [];
            if (!empty($args['resId'])) {
                $where = ['res_id = ?'];
                $data = [$args['resId']];
            } elseif (!empty($args['modelId'])) {
                $where = ['model_id = ?'];
                $data = [$args['modelId']];
            }
            ResModel::update(['set' => $set, 'postSet' => $postSet, 'where' => $where, 'data' => $data]);
        }

        return true;
    }

    // EDISSYUM - NCH01 Addulact Démarches Simplifiées
    public function retrieveResourceByAdullactDossierId($dossierId) {
        return ResModel::get([
            'select' => ['res_id'],
            'where'  => ["external_id->'adullact_dossier_id' = ?"],
            'data'   => [$dossierId]
        ]);
    }

    public function createNoteAndAttachment($auth, $resId, $note_value, $attachmentArgs, $prefix) {
        if ($note_value) {
            NoteModel::create([
                'resId'     => $resId,
                'user_id'   => $GLOBALS['id'],
                'note_text' => $prefix . ' : ' . $note_value
            ]);
        }

        if ($attachmentArgs) {
            $data = [
                'status' => 'TRA',
                'title'=> $prefix . ' : ' . $attachmentArgs['filename'],
                'type' => 'incoming_mail_attachment',
                'resIdMaster' => $resId,
                'encodedFile' => base64_encode(file_get_contents($attachmentArgs['url'])),
                'format' => pathinfo($attachmentArgs['filename'], PATHINFO_EXTENSION),
            ];
            CurlModel::exec([
                'url'     => UrlController::getCoreUrl() . 'rest/attachments',
                'headers' =>  ['Authorization: Basic ' . $auth, 'Content-Type: application/json'],
                'method'  => 'POST',
                'body'    => json_encode($data)
            ]);
        }
    }

    public function createHistory($resId, $dossierId, $message) {
        HistoryController::add([
            'tableName' => 'res_letterbox',
            'recordId'  => $resId,
            'eventType' => 'ACTION#ADULLACT',
            'info'      => 'Démarches simplifiées : Dossier n°' . $dossierId . ' ' . $message,
            'moduleId'  => 'adullact',
            'eventId'   => 'adullactUpdate',
        ]);
    }

    public function changeStatus($resId, $status) {
        \Resource\models\ResModel::update([
            'set'     => ['status' => $status],
            'where'   => ['res_id = ?'],
            'data'    => [$resId]
        ]);
    }

    public function createResource($auth, $dossierId, $args, $maarchFields) {
        $data =  [
            'encodedFile'       => $args['encodedFile'],
            'priority'          => $args['priority'],
            'status'            => $args['statusConstruction'],
            'chrono'            => true,
            'doctype'           => $args['doctype'],
            'format'            => 'pdf',
            'modelId'           => $args['modelId'],
            'typist'            => $args['typist'],
            'documentDate'      => $args['documentDate'],
            'subject'           => 'Démarche simplifiée N°' . $dossierId,
            'destination'       => $args['destination'],
            'senders'           => [],
            'processLimitDate'  => Date('Y-m-d', strtotime('+15 days')),
            'externalId'        => ['adullact_dossier_id' => (int) $dossierId],
            'customFields'      => [
                $maarchFields['demandeurCustomId']      => trim($args['demandeur']),
                $maarchFields['instructeurCustomId']    => ''
            ]
        ];
        $createResource = CurlModel::exec([
            'url'     => UrlController::getCoreUrl() . 'rest/resources',
            'headers' => ['Authorization: Basic ' . $auth, 'Content-Type: application/json'],
            'method'  => 'POST',
            'body'    => json_encode($data)
        ]);

        if ($createResource['response'] && empty($createResource['response']['errors'])) {
            $resId = $createResource['response']['resId'];
            $this->createHistory($resId, $dossierId, 'construit');
            return $resId;
        }
        return false;
    }

    public function process($auth, $status, $prefix, $prefixShort, $dossierId, $res, $instructeurs = false, $customInstructeur = false) {
        $adullactRes = $this -> retrieveResourceByAdullactDossierId($dossierId);
        if ($adullactRes) {
            $resId = $adullactRes[0]['res_id'];
            if ($prefix) {
                $this -> createNoteAndAttachment($auth, $resId, $res['motivation'], $res['motivationAttachment'], $prefix);
            }
            if ($res['avis']) {
                $this -> createNoteWithAvis($auth, $resId, $res['avis'], $dossierId);
            }
            $this -> createHistory($resId, $dossierId, $prefixShort);
            $this -> changeStatus($resId, $status);
            if ($instructeurs) {
                $this -> updateInstructeur($resId, $instructeurs, $customInstructeur);
            }
        }
    }

    public function createNoteWithAvis($auth, $resId, $avisList, $dossierId) {
        $notes = NoteModel::get([
            'where' => ['identifier =  ? '],
            'data'  => [$resId]
        ]);

        foreach ($avisList as $avis) {
            $dateAnswer = date('d/m/Y H:i:s', strtotime($avis['dateReponse']));
            $expert = $avis['expert']['email'];
            $noteExist = false;
            $note_prefix = "Avis de " . $expert . " le " . $dateAnswer;
            $note_content = "\n" . $avis['reponse'];
            foreach ($notes as $note) {
                if (str_replace("\n", "", $note['note_text']) == str_replace("\n", "", $note_prefix . ' : ' . $note_content)) {
                    $noteExist = true;
                }
            }

            if (!$noteExist) {
                $this -> createNoteAndAttachment($auth, $resId, $note_content, $avis['attachment'], $note_prefix);
                $this -> createHistory($resId, $dossierId, 'avis de ' . $expert . ' donné');
            }
        }
    }

    public function updateInstructeur($resId, $instructeurs, $customId) {
        \Resource\models\ResModel::update([
            'postSet' => ['custom_fields' => "jsonb_set(custom_fields, '{" . $customId . "}', '\"" . rtrim(trim($instructeurs), ';') . "\"')"],
            'where'   => ['res_id = ?'],
            'data'    => [$resId]
        ]);
    }

    public function getTypeForFields($fields, $fieldsType) {
        for ($cpt = 0; $cpt <= count($fields); $cpt++) {
            foreach ($fieldsType as $fieldType) { // Récupération du type de chaque champs
                if ($fieldType['id'] == $fields[$cpt]['id']) {
                    $fields[$cpt]['type'] = $fieldType['type'];
                    if (isset($fields[$cpt]['champs']) && !empty($fields[$cpt]['champs'])) { // Récupération du type de chaque sous champs
                        for ($cpt1 = 0; $cpt1 <= count($fields[$cpt]['champs']); $cpt1++) {
                            foreach ($fieldType['champDescriptors'] as $fieldType2) {
                                if ($fieldType2['id'] == $fields[$cpt]['champs'][$cpt1]['id']) {
                                    $fields[$cpt]['champs'][$cpt1]['type'] = $fieldType2['type'];
                                }
                            }
                        }
                    }
                }
            }
        }
        return $fields;
    }

    public function generateForm($pdf, $fields, $tabulation='') {
        foreach ($fields as $field) {
            $label = $field['label'];
            $pdf->setCellMargins(0, 0, 0, 0);
            switch ($field['type']) {
                case 'header_section':
                    $pdf->setCellMargins(0, 2, 0, 6);
                    $pdf->SetFont('times', 'B', 11);
                    $pdf->MultiCell(0, 0, $field['label'], 0, 'C', 0, 1, '', '', true);
                    $pdf->SetFont('times', '', 11);
                    break;
                case 'yes_no': case 'checkbox': case 'engagement':
                $yes_no = 'Non';
                if ($field['checked']) $yes_no = 'Oui';
                $value = $pdf->WriteHtml($tabulation . '<b>' . $label . '</b> : ' . $yes_no);
                $pdf->MultiCell(0, 0, $value, 0, '', 0, 1, '', '', true);
                break;
                case 'piece_justificative':
                    $value = $pdf->WriteHtml($tabulation . '<b>' . $field['label'] . '</b> : Voir pièce(s) jointe(s)');
                    $pdf->MultiCell(0, 0, $value, 0, '', 0, 1, '', '', true);
                    break;
                case 'repetition':
                    $pdf->MultiCell(0, 0, $pdf->WriteHtml('<b>' . $label . '</b> : '), 0, '', 0, 1, '', '', true);
                    $this->generateForm($pdf, $field['champs'], '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
                    break;
                case 'carte':
                    $pdf->MultiCell(0, 0, $pdf->WriteHtml($tabulation . '<b>' . $label . '</b> : '), 0, '', 0, 1, '', '', true);
                    $tabulation = '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';
                    foreach ($field['geoAreas'] as $geo) {
                        switch ($geo['geometry']['type']) {
                            case 'Point':
                                $coord = $geo['geometry']['coordinates'];
                                $data = 'https://maps.google.com/?q=' . $coord[1] . ',' . $coord[0];
                                $value = $pdf->WriteHtml($tabulation . '<b>' . $geo['description'] . '</b> : <a href="' . $data . '">Lien vers Google Maps</a>');
                                break;
                            default:
                                $value = $pdf->WriteHtml($tabulation . '<b>' . $geo['description'] . '</b> : Voir formulaire sur le site Démarches Simplifiées');
                        }
                        $pdf->MultiCell(0, 0, $value, 0, '', 0, 1, '', '', true);
                    }
                    $tabulation = '';
                    break;
                case 'titre_identite':
                    $value = $pdf->WriteHtml($tabulation . '<b>' . $label . '</b> : Voir formulaire sur le site Démarches Simplifiées');
                    $pdf->MultiCell(0, 0, $value, 0, '', 0, 1, '', '', true);
                    break;
                case 'dossier_link':
                    $pdf->MultiCell(0, 0, $pdf->WriteHtml('<b>' . $label . '</b> : '), 0, '', 0, 1, '', '', true);
                    $tabulation = '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';
                    $pdf->MultiCell(0, 0, $pdf->WriteHtml($tabulation . '<b>Numéro du dossier</b> : ' . $field['stringValue']), 0, '', 0, 1, '', '', true);
                    $pdf->MultiCell(0, 0, $pdf->WriteHtml($tabulation . '<b>État du dossier</b> : ' . $field['dossier']['state']), 0, '', 0, 1, '', '', true);
                    $pdf->MultiCell(0, 0, $pdf->WriteHtml($tabulation . '<b>Demandeur du dossier</b> : ' . $field['dossier']['usager']['email']), 0, '', 0, 1, '', '', true);
                    $tabulation = '';
                    break;
                default:
                    $value = $pdf->WriteHtml($tabulation . '<b>' . $label . '</b> : ' . $field['stringValue']);
                    $pdf->MultiCell(0, 0, $value, 0, '', 0, 1, '', '', true);
                    break;
            }
        }
        return $pdf;
    }

    public function createPDFFromFields($fields, $dossierId, $args): string {
        $pdf = new Fpdi(PDF_PAGE_ORIENTATION, PDF_UNIT, PDF_PAGE_FORMAT, true, 'UTF-8', false);
        $pdf->SetAuthor('Edissyum Consulting');
        $pdf->SetTitle('Formulaire de demande Démarche Simplifiée');
        $pdf->setPrintHeader(false);
        $pdf->SetMargins(PDF_MARGIN_LEFT, 5, PDF_MARGIN_RIGHT);
        $pdf->SetAutoPageBreak(true, 10);
        $pdf->AddPage();
        $pdf->SetFont('times', 'B', 20);
        $pdf->Cell(0, 0, 'Résumé de la demande Démarche Simplifiée n°' . $dossierId, 0, 1, 'C', 0, '', 0);
        $pdf->SetFont('times', '', 11);
        $pdf->Cell(0, 0, '', 0, 1, 'C', 0, '', 0);
        $pdf->Line(PDF_MARGIN_LEFT + 50, $pdf->getY(), $pdf->getPageWidth() - 50, $pdf->getY());
        $pdf->Cell(0, 0, '', 0, 1, 'C', 0, '', 0);

        $value = $pdf->WriteHtml('<b>Demandeur</b> : ' . $args['demandeur']);
        $pdf->MultiCell(0, 0, $value, 0, '', 0, 1, '', '', true);
        $value = $pdf->WriteHtml('<b>Déposé le</b> : ' . date('d/m/Y à H:i:s', strtotime($args['documentDate'])));
        $pdf->MultiCell(0, 0, $value, 0, '', 0, 1, '', '', true);
        if ($args['lastModificationDate']) {
            $value = $pdf->WriteHtml('<b>Dernière mise à jour le</b> : ' . date('d/m/Y à H:i:s', strtotime($args['lastModificationDate'])));
            $pdf->MultiCell(0, 0, $value, 0, '', 0, 1, '', '', true);
        }
        $pdf->SetFont('times', '', 11);
        $pdf->Cell(0, 0, '', 0, 0, 'C', 0, '', 0);
        $pdf->Line(PDF_MARGIN_LEFT + 50, $pdf->getY(), $pdf->getPageWidth() - 50, $pdf->getY());
        $pdf->Cell(0, 0, '', 0, 1, 'C', 0, '', 0);
        $pdf = $this->generateForm($pdf, $fields);

        $tmpFile = CoreConfigModel::getTmpPath() . "tmp_file_" .rand(). ".pdf";
        $pdf->Output($tmpFile, 'F');
        $encodedFile = file_get_contents($tmpFile);
        unlink($tmpFile);
        return base64_encode($encodedFile);
    }

    public function handleWebHook(Request $request, Response $response) {
        $loadedXml = CoreConfigModel::getXmlLoaded(['path' => 'config/demarches_simplifiees.xml']);
        $authArgs = $args = $maarchFields = [];
        if (!empty($loadedXml)) {
            foreach ($loadedXml->AUTHENTIFICATION->children() as $authSettings) {
                $authArgs[$authSettings->getName()] = (string)$authSettings;
            }

            foreach ($loadedXml->SETTINGS->children() as $settings) {
                $args[$settings->getName()] = (string)$settings;
            }

            foreach ($loadedXml->MAARCH->children() as $maarch) {
                $maarchFields[$maarch->getName()] = (string)$maarch;
            }
        } else {
            return $response->withStatus(400)->withJson(['errors' => 'Config file not found']);
        }

        $auth = base64_encode($authArgs['memUserWsLogin'] . ':' . $authArgs['memUserWsPassword']);
        $body = $request->getParsedBody();
        $dossierId = $body['dossier_id'];

        $data_string = json_encode([
            "query" => "
            query getDossier(\$dossierNumber: Int!) {
                dossier(number: \$dossierNumber) {
                    ...DossierFragment
                }
            }
            
            fragment DossierFragment on Dossier {
                id
                number
                archived
                state
                dateDerniereModification
                datePassageEnConstruction
                datePassageEnInstruction
                dateTraitement
                motivation
                motivationAttachment {
                    ...FileFragment
                }
                pdf {
                    url
                }
                instructeurs {
                    email
                }
                revision {
                    ...RevisionFragment
                }
                champs {
                    ...ChampFragment
                    ...RootChampFragment
                }
                annotations {
                    ...ChampFragment
                    ...RootChampFragment
                }
                avis {
                    ...AvisFragment
                }
                demandeur {
                    ... on PersonnePhysique {
                        civilite
                        nom
                        prenom
                    }
                    ... on PersonneMorale {
                        siret
                        entreprise {
                            siren
                            raisonSociale
                            nom
                            prenom
                        }
                    }
                }
            }
            
            fragment RevisionFragment on Revision {
                id
                champDescriptors {
                    ...ChampDescriptorFragment
                    champDescriptors {
                        ...ChampDescriptorFragment
                    }
                }
                annotationDescriptors {
                    ...ChampDescriptorFragment
                    champDescriptors {
                        ...ChampDescriptorFragment
                    }
                }
            }
            
            fragment AvisFragment on Avis {
                id
                question
                reponse
                dateQuestion
                dateReponse
                expert {
                    email
                }
                attachment {
                    ...FileFragment
                }
            }
            
            fragment GeoAreaFragment on GeoArea {
                id
                source
                description
                geometry {
                    type
                    coordinates
                }
                ... on ParcelleCadastrale {
                    commune
                    numero
                    section
                    prefixe
                    surface
                }
            }
            
            fragment RootChampFragment on Champ {
                ... on RepetitionChamp {
                    champs {
                        ...ChampFragment
                    }
                }
                ... on CarteChamp {
                    geoAreas {
                        ...GeoAreaFragment
                    }
                }
                ... on DossierLinkChamp {
                    dossier {
                        id
                        state
                        usager {
                            email
                        }
                    }
                }
            }
            
            fragment ChampFragment on Champ {
                id
                label
                stringValue
                ... on DateChamp {
                    date
                }
                ... on DatetimeChamp {
                    datetime
                }
                ... on CheckboxChamp {
                    checked: value
                }
                ... on DecimalNumberChamp {
                    decimalNumber: value
                }
                ... on IntegerNumberChamp {
                    integerNumber: value
                }
                ... on CiviliteChamp {
                    civilite: value
                }
                ... on LinkedDropDownListChamp {
                    primaryValue
                    secondaryValue
                }
                ... on MultipleDropDownListChamp {
                    values
                }
                ... on PieceJustificativeChamp {
                    file {
                        ...FileFragment
                    }
                }
                ... on AddressChamp {
                    address {
                        ...AddressFragment
                    }
                }
                ... on CommuneChamp {
                    commune {
                        name
                        code
                    }
                    departement {
                        name
                        code
                    }
                }
            }
            
            fragment ChampDescriptorFragment on ChampDescriptor {
                id
                type
                label
                options
            }
            
            fragment FileFragment on File {
                filename
                contentType
                url
            }
            
            fragment AddressFragment on Address {
                label
                type
                streetAddress
                streetNumber
                streetName
                postalCode
                cityName
                cityCode
                departmentName
                departmentCode
                regionName
                regionCode
            }",
            "variables" => [
                "dossierNumber" => (int)$dossierId
            ]
        ]);
        $res = CurlModel::exec([
            'url' => $authArgs['adullactUrl'],
            'method' => 'POST',
            'headers' => ['Authorization: Bearer ' . $authArgs['adullactToken'], 'Content-Type: application/json'],
            'body' => $data_string
        ]);

        if (!empty($res['response']['errors']) || !empty($res['errors']) || $res['code'] == 404) {
            $message = !empty($res['response']['errors']) ? $res['response']['errors'][0]['message'] : $res['errors'];
            if ($res['code'] == '404') {
                $message = "L'URL de l'instance Démarches Simplifiées est introuvable";
            }
            return $response->withStatus(400)->withJson(['errors' => $message]);
        }

        $res = $res['response']['data']['dossier'];
        if (isset($res['demandeur']['entreprise'])) {
            $demandeur = $res['demandeur']['entreprise'];
            if (isset($demandeur['nom']) && isset($demandeur['prenom'])) {
                $args['demandeur'] = $demandeur['nom'] . ' ' . $demandeur['prenom'] . ' (' . $demandeur['raisonSociale'] . ')';
            } else {
                $args['demandeur'] = $demandeur['raisonSociale'];
            }
        } else {
            $args['demandeur'] = $res['demandeur']['civilite'] . ' ' . $res['demandeur']['nom'] . ' ' . $res['demandeur']['prenom'];
        }

        $args['instructeurs'] = '';
        if (isset($res['instructeurs'])) {
            foreach ($res['instructeurs'] as $instructeur) {
                $args['instructeurs'] .= $instructeur['email'] . ';';
            }
        }

        $args['documentDate'] = $res['datePassageEnConstruction'];
        $args['lastModificationDate'] = $res['dateDerniereModification'];
        $fields = $this -> getTypeForFields($res['champs'], $res['revision']['champDescriptors']);
        switch ($res['state']) {
            case 'en_construction':
                $adullactRes = $this -> retrieveResourceByAdullactDossierId($dossierId);
                if (empty($adullactRes)) {
                    $args['encodedFile'] = $this -> createPDFFromFields($fields, $dossierId, $args);
                    $resId = $this -> createResource($auth, $dossierId, $args, $maarchFields);
                    foreach ($fields as $field) {
                        if ($field['type'] == 'piece_justificative') {
                            $this -> createNoteAndAttachment($auth, $resId, false, $field['file'], 'Pièce justificative');
                        }
                    }
                } else {
                    $this->process($auth, $args['statusConstruction'], false, 'repassé en construction', $dossierId, $res);
                }
                break;
            case 'en_instruction':
                $this -> process($auth, $args['statusInstruction'], false, 'passé en instruction', $dossierId, $res, $args['instructeurs'], $maarchFields['instructeurCustomId']);
                break;
            case 'accepte':
                $this -> process($auth, $args['statusAccepte'], 'Dossier accepté', 'accepté', $dossierId, $res);
                break;
            case 'refuse':
                $this -> process($auth, $args['statusRefuse'], 'Dossier refusé', 'refusé', $dossierId, $res);
                break;
            case 'sans_suite':
                $this -> process($auth, $args['statusSansSuite'], 'Dossier classé sans suite', 'classé sans suite', $dossierId, $res);
                break;
        }
    }
    // EDISSYUM - END NCH01

    // EDISSYUM - NCH01 Récupération d'un document par numéro de chrono
    public function getResourcesByChrono(Request $request, Response $response, array $args)
    {
        $body = $request->getParsedBody();

        $select = ['res_id', 'model_id', 'category_id', 'priority', 'status', 'subject', 'alt_identifier', 'process_limit_date', 'closing_date', 'creation_date', 'modification_date', 'external_id'];
        if (empty($body['light'])) {
            $select = array_merge($select, ['type_id', 'typist', 'destination', 'initiator', 'confidentiality', 'doc_date', 'admission_date', 'departure_date', 'barcode', 'custom_fields']);
        }

        $document = ResModel::getByAltIdentifier(['altIdentifier' => $body['chronoNumber'], 'select' => $select]);

        if (empty($document)) {
            return $response->withStatus(400)->withJson(['errors' => 'Document does not exist']);
        }

        $unchangeableData = [
            'resId'             => $document['res_id'],
            'modelId'           => $document['model_id'],
            'categoryId'        => $document['category_id'],
            'chrono'            => $document['alt_identifier'],
            'status'            => $document['status'],
            'closingDate'       => $document['closing_date'],
            'creationDate'      => $document['creation_date'],
            'modificationDate'  => $document['modification_date'],
            'retentionFrozen'   => $document['retention_frozen'],
            'binding'           => $document['binding'],
            'integrations'      => json_decode($document['integrations'], true)
        ];
        $formattedData = [
            'subject'           => $document['subject'],
            'processLimitDate'  => $document['process_limit_date'],
            'priority'          => $document['priority']
        ];
        if (empty($queryParams['light'])) {
            $formattedData = array_merge($formattedData, [
                'doctype'           => $document['type_id'],
                'typist'            => $document['typist'],
                'typistLabel'       => UserModel::getLabelledUserById(['id' => $document['typist']]),
                'destination'       => $document['destination'],
                'initiator'         => $document['initiator'],
                'confidentiality'   => $document['confidentiality'] == 'Y',
                'documentDate'      => $document['doc_date'],
                'arrivalDate'       => $document['admission_date'],
                'departureDate'     => $document['departure_date'],
                'barcode'           => $document['barcode']
            ]);
        }

        $modelFields = IndexingModelFieldModel::get([
            'select'    => ['identifier'],
            'where'     => ['model_id = ?'],
            'data'      => [$document['model_id']]
        ]);
        $modelFields = array_column($modelFields, 'identifier');

        foreach ($formattedData as $key => $data) {
            if (!in_array($key, $modelFields)) {
                unset($formattedData[$key]);
            }
        }
        $formattedData = array_merge($unchangeableData, $formattedData);

        if (!empty($formattedData['destination'])) {
            $entity = EntityModel::getByEntityId(['entityId' => $formattedData['destination'], 'select' => ['entity_label', 'id']]);
            $formattedData['destination'] = $entity['id'];
            $formattedData['destinationLabel'] = $entity['entity_label'];
        }
        if (!empty($formattedData['initiator'])) {
            $entity = EntityModel::getByEntityId(['entityId' => $formattedData['initiator'], 'select' => ['entity_label', 'id']]);
            $formattedData['initiator'] = $entity['id'];
            $formattedData['initiatorLabel'] = $entity['entity_label'];
        }
        if (!empty($formattedData['status'])) {
            $status = StatusModel::getById(['id' => $formattedData['status'], 'select' => ['label_status', 'can_be_modified']]);
            $formattedData['statusLabel'] = $status['label_status'];
            $formattedData['statusAlterable'] = $status['can_be_modified'] == 'Y';
        }
        if (!empty($formattedData['priority'])) {
            $priority = PriorityModel::getById(['id' => $formattedData['priority'], 'select' => ['label', 'color']]);
            $formattedData['priorityLabel'] = $priority['label'];
            $formattedData['priorityColor'] = $priority['color'];
        }

        if (in_array('senders', $modelFields)) {
            $formattedData['senders'] = ResourceContactModel::get([
                'select'    => ['item_id as id', 'type'],
                'where'     => ['res_id = ?', 'mode = ?'],
                'data'      => [$args['resId'], 'sender']
            ]);
        }
        if (in_array('recipients', $modelFields)) {
            $formattedData['recipients'] = ResourceContactModel::get([
                'select'    => ['item_id as id', 'type'],
                'where'     => ['res_id = ?', 'mode = ?'],
                'data'      => [$args['resId'], 'recipient']
            ]);
        }

        if (empty($queryParams['light'])) {
            $formattedData['customFields'] = !empty($document['custom_fields']) ? json_decode($document['custom_fields'], true) : [];

            $entities = EntityModel::getWithUserEntities([
                'select' => ['entities.id'],
                'where'  => ['user_id = ?'],
                'data'   => [$GLOBALS['id']]
            ]);
            $entities = array_column($entities, 'id');
            $folders = [];
            if (!empty($entities)) {
                $folders = FolderModel::getWithEntitiesAndResources([
                    'select'    => ['distinct(resources_folders.folder_id)'],
                    'where'     => ['resources_folders.res_id = ?', '(entities_folders.entity_id in (?) OR folders.user_id = ? OR keyword = ?)'],
                    'data'      => [$args['resId'], $entities, $GLOBALS['id'], 'ALL_ENTITIES']
                ]);
            }
            $formattedData['folders'] = array_column($folders, 'folder_id');

            $tags = ResourceTagModel::get(['select' => ['tag_id'], 'where' => ['res_id = ?'], 'data' => [$args['resId']]]);
            $formattedData['tags'] = array_column($tags, 'tag_id');

            if ($formattedData['categoryId'] == 'registeredMail') {
                $registeredMailInfo = RegisteredMailController::getFormattedRegisteredMail(['resId' => $args['resId']]);
                foreach ($registeredMailInfo as $key => $value) {
                    $formattedData['registeredMail_' . $key] = $value;
                }
            }
        } else {
            $followed = UserFollowedResourceModel::get([
                'select'    => [1],
                'where'     => ['user_id = ?', 'res_id = ?'],
                'data'      => [$GLOBALS['id'], $args['resId']]
            ]);
            $formattedData['followed'] = !empty($followed);

            $registeredMail = RegisteredMailModel::getByResId(['select' => ['deposit_id', 'received_date', 'return_reason'], 'resId' => $args['resId']]);
            $formattedData['registeredMail_returnDate']   = $registeredMail['received_date'];
            $formattedData['registeredMail_returnReason'] = $registeredMail['return_reason'];
            $formattedData['registeredMail_deposit_id']   = $registeredMail['deposit_id'];
        }

        if (PrivilegeController::hasPrivilege(['privilegeId' => 'view_technical_infos', 'userId' => $GLOBALS['id']])) {
            $formattedData['externalId'] = json_decode($document['external_id'], true);
        }

        return $response->withJson($formattedData);
    }
    // END EDISSYUM - NCH01

    // EDISSYUM - NCH01 Module e-Citiz
    public function createWithoutRequest($body, $customId) {
        $body = StoreController::setDisabledAndEmptyMandatoryFields($body);

        $control = ResourceControlController::controlResource(['body' => $body]);
        if (!empty($control['errors'])) {
            return ['errors' => $control['errors']];
        }

        $resId = StoreController::storeResource($body);
        if (empty($resId) || !empty($resId['errors'])) {
            return ['errors' => '[ResController create] ' . $resId['errors']];
        }

        $resId = $resId['resId'];
        ResController::createAdjacentData(['body' => $body, 'resId' => $resId]);

        if (!empty($body['followed'])) {
            UserFollowedResourceModel::create([
                'userId'    => $GLOBALS['id'],
                'resId'     => $resId
            ]);
        }

        if (!empty($body['encodedFile'])) {
            ConvertPdfController::convert([
                'resId'     => $resId,
                'collId'    => 'letterbox_coll',
                'version'   => 1
            ]);

            $customId = empty($customId) ? 'null' : $customId;
            exec("php src/app/convert/scripts/FullTextScript.php --customId {$customId} --resId {$resId} --collId letterbox_coll --userId {$GLOBALS['id']} > /dev/null &");
        }

        HistoryController::add([
            'tableName' => 'res_letterbox',
            'recordId'  => $resId,
            'eventType' => 'ADD',
            'info'      => 'Courrier créé',
            'moduleId'  => 'resource',
            'eventId'   => 'resourceCreation',
        ]);

        return ['resId' => $resId];
    }
    // EDISSYUM - END NCH01

    // EDISSYUM - EME01 connecteur Neocity
    public function handleWebHookReporting(Request $request, Response $response) {
        $loadedJson  = CoreConfigModel::getJsonLoaded(['path' => 'config/neocity.json']);
        if (empty($loadedJson)) {
            return $response->withStatus(400)->withJson(['errors' => 'Neocity config file not found']);
        }
        if (empty($loadedJson['reporting_content']) || empty($loadedJson['contact_content'] || empty($loadedJson['authentification']))) {
            return $response->withStatus(400)->withJson(['errors' => 'Neocity config file is not well formatted']);
        }

        foreach ($loadedJson['authentification'] as $key => $authSettings) {
            $authArgs[$key] = (string) $authSettings;
        }

        foreach ($loadedJson['reporting_content'] as $reportConfig) {
            if ($reportConfig != null) {
                if (!isset($reportConfig) or empty($reportConfig)) {
                    return $response->withStatus(400)->withJson(['errors' => 'Neocity config is missing reporting content']);
                }
            }
        }

        foreach ($loadedJson['contact_content'] as $contactConfig) {
            if ($contactConfig != null) {
                if (!isset($contactConfig) or empty($contactConfig)) {
                    return $response->withStatus(400)->withJson(['errors' => 'Neocity config is missing in contact content']);
                }
            }
        }

        $reportingConfigs = $loadedJson['reporting_content'];
        $reportingContactConfigs = $loadedJson['contact_content'];
        $body = $request->getParsedBody();
        $contactValues = [];

        foreach ($reportingContactConfigs as $param => $contactParam) {
            switch ($param) {
                case 'civility':
                    if (isset($reportingContactConfigs ['civility']['value']) and !empty($reportingContactConfigs ['civility']['value'])) {
                        $contactValues['civility'] = null;
                        $contactCivility = $body[$reportingContactConfigs['civility']['value']];
                        foreach ($reportingContactConfigs ['civility'] as $key =>$value) {
                            if ($contactCivility == $value) {
                                $contactValues['civility'] = $key;
                            }
                        }
                        if ($contactValues['civility'] == null) {
                            return $response->withStatus(400)->withJson(['errors' => 'the civility doesnt exist please add it to the config file']);
                        }
                    } else {
                        return $response->withStatus(400)->withJson(['errors' => 'the civility field value is missing in config file !']);
                    }
                    break;
                default:
                    $contactValues[$param] = $body[$param];
                    if (!isset($body[$param])) {
                        $contactValues[$param] = $contactParam;
                    }
            }
        }

        $resContact = CurlModel::exec([
            'url'       => UrlController::getCoreUrl() . 'rest/contacts',
            'basicAuth' => ['user' => $authArgs['memUserWsLogin'], 'password' => $authArgs['memUserWsPassword']],
            'headers'   => ['content-type:application/json', 'Accept: application/json'],
            'method'    => 'POST',
            'body'      => json_encode($contactValues)
        ]);

        if (!empty($resContact['errors']) && $resContact['code'] != 200) {
            return $response->withStatus(400)->withJson(['errors' => $resContact['errors']]);
        }

        $resourcesFields = [];
        $customFieldsValues = [];
        foreach ($reportingConfigs as $reportingConfigKey => $reportingConfigValue) {
            switch ($reportingConfigKey) {
                case 'customFields':
                    $fieldsValuesBan = [];
                    foreach ($reportingConfigValue as $key => $value) {
                        if (is_array ($value)) {
                            $banContent = $value[0];
                            foreach ($banContent as $banContentKey => $banContentValue) {
                                if (isset($banContentKey) and !empty($banContentValue) and $banContentKey != "label") {
                                    $fieldsValuesBan [$banContentKey] = $body[$banContentValue];
                                } else {
                                    $fieldsValuesBan [$banContentKey] = "";
                                }
                            }
                            $customFieldsValues[$key] = array($fieldsValuesBan);
                        } else {
                            $field = CustomFieldModel::getById(['select' => ['label'], 'id' => $key]);
                            if (empty($field)) {
                                return $response->withStatus(400)->withJson(['errors' => 'Custom field not found !']);
                            } else {
                                if (array_key_exists($reportingConfigs['customFields'][$key], $body)) {
                                    $customFieldsValues[$key] = $body[$reportingConfigs['customFields'][$key]];
                                } else {
                                    $customFieldsValues[$key] = $reportingConfigs['customFields'][$key];
                                }
                            }
                        }
                    }
                    $resourcesFields['customFields'] = $customFieldsValues;
                    break;
                case 'doctypes':
                    $doctypesArray = $reportingConfigValue;
                    foreach ($doctypesArray as $docTypekey => $docTypeValue) {
                        if ($docTypekey) {
                            if ($docTypekey == 'value') {
                                if ($body[$docTypeValue] == $docTypeValue) {
                                    $resourcesFields['doctype'] = $docTypekey;
                                }
                            } else {
                                $doctypeAvaible = DoctypeModel::getById(['id' => $docTypekey]);
                                if (empty($doctypeAvaible)) {
                                    return $response->withStatus(400)->withJson(['errors' => 'Doctype not found !']);
                                }
                            }
                        }
                    }
                    break;
                case 'externalId':
                    $externelIdArray = [];
                    $externelIdContent = $reportingConfigValue;
                    foreach ($externelIdContent as $externelIdContentKey => $externelIdContentValue) {
                        $externelIdArray[$externelIdContentKey] = $body[$externelIdContentValue];
                    }
                    $resourcesFields['externalId'] = $externelIdArray;
                    break;
                case 'other_mappings':
                    foreach ($reportingConfigValue as $customMapping) {
                        if (!array_key_exists($body[$customMapping['neocityFields']], $customMapping['mapping'])) {
                            return $response->withStatus(400)->withJson(['errors' => 'Neocity category ' . $body[$customMapping['neocityFields']] . " is missing in the mapping"]);
                        }
                        $resourcesFields['customFields'][$customMapping['customId']] = $customMapping['mapping'][$body[$customMapping['neocityFields']]];
                    }
                    break;
                default:
                    if (isset($body[$reportingConfigValue])) {
                        $resourcesFields[$reportingConfigKey] = $body[$reportingConfigValue];
                    } else {
                        $resourcesFields[$reportingConfigKey] = $reportingConfigValue;
                        $resourcesFields['senders'] = [[
                            "id" => $resContact['response']['id'],
                            "type" => 'contact'
                        ]];
                    }
            }
        }

        $encodedFile = $this -> createPDFFromFieldsNeocity($resourcesFields, $body);
        $resId = $this -> createResourceNeocity($authArgs, $resourcesFields, $encodedFile);

        if (empty($resId)) {
            return $response->withStatus(400)->withJson(['errors' => 'creation of new resource process failed !']);
        } else {
            foreach ($body[$reportingConfigs['images']] as $image) {
                $b64_image = base64_encode(file_get_contents($image));
                $image_name = basename($image);
                $data = [
                    'status'        => 'TRA',
                    'title'         => $image_name,
                    'type'          => 'simple_attachment',
                    'resIdMaster'   => $resId,
                    'encodedFile'   => $b64_image,
                    'format'        => pathinfo($image_name, PATHINFO_EXTENSION),
                ];
                $resCurlAttachement = CurlModel::exec([
                    'url'       => UrlController::getCoreUrl() . 'rest/attachments',
                    'basicAuth' => ['user' => $authArgs['memUserWsLogin'], 'password' => $authArgs['memUserWsPassword']],
                    'method'    => 'POST',
                    'headers'   => ['content-type:application/json', 'Accept: application/json'],
                    'body'      => json_encode($data)
                ]);
                if (empty($resCurlAttachement)) {
                    return $response->withStatus(400)->withJson(['errors' => 'creation of new resource attachment process failed !']);
                }
            }
        }
        return $response->withJson(['resId' => $resId]);
    }

    public function createResourceNeocity($auth, $args, $encodedFile) {
        $args = [
            'encodedFile'       => $encodedFile,
            'priority'          => $args['priority'],
            'status'            => $args['status'],
            'chrono'            => $args['chrono'],
            'doctype'           => (int) $args['doctype'],
            'format'            => $args['format'],
            'modelId'           => (int) $args['model_id'],
            'documentDate'      => $args['creation_date'],
            'subject'           => $args['subject']. $args['externalId']['neocity_number'],
            'destination'       => $args['destination'],
            'senders'           => $args['senders'],
            'externalId'        => $args['externalId'],
            'customFields'      => $args['customFields'],
        ];

        $resCurlResource = CurlModel::exec([
            'url'       => UrlController::getCoreUrl() . 'rest/resources',
            'basicAuth' => ['user' => $auth['memUserWsLogin'], 'password' => $auth['memUserWsPassword']],
            'headers'   => ['content-type:application/json', 'Accept: application/json'],
            'method'    => 'POST',
            'body'      => json_encode($args)
        ]);

        if ($resCurlResource['code'] != 200) {
            return ['errors' => 'Error while insert new resource : ' . print_r($resCurlResource, true)];
        }
        return $resCurlResource['response']['resId'];
    }

    public function generateFormNeo($pdf, $fields, $tabulation='') {
        foreach ($fields as $key => $field) {
            $fieldContent = $fields[$key];
            if (is_array($field)) {
                $fieldContent = json_encode($fieldContent);
            }
            $pdf->setCellMargins(0, 0, 0, 0);
            $value = $pdf->WriteHtml($tabulation . '<b>' . $key . '</b> : ' . $fieldContent);
            $pdf->MultiCell(0, 0, $value, 0, '', 0, 1, '', '', true);
        }
        return $pdf;
    }

    public function createPDFFromFieldsNeocity($fields, $args) {
        $pdf = new Fpdi(PDF_PAGE_ORIENTATION, PDF_UNIT, PDF_PAGE_FORMAT, true, 'UTF-8', false);
        $pdf->SetAuthor('Edissyum Consulting');
        $pdf->SetTitle('Demande Neocity');
        $pdf->setPrintHeader(false);
        $pdf->SetMargins(PDF_MARGIN_LEFT, 5, PDF_MARGIN_RIGHT);
        $pdf->SetAutoPageBreak(true, 10);
        $pdf->AddPage();
        $pdf->SetFont('times', 'B', 20);
        $pdf->Cell(0, 0, 'Résumé de la demande Neocity n°: ' . $fields['externalId']['neocity_number'], 0, 1, 'C', 0, '', 0);
        $pdf->SetFont('times', '', 11);
        $pdf->Cell(0, 0, '', 0, 1, 'C', 0, '', 0);
        $pdf->Line(PDF_MARGIN_LEFT + 50, $pdf->getY(), $pdf->getPageWidth() - 50, $pdf->getY());
        $pdf->Cell(0, 0, '', 0, 1, 'C', 0, '', 0);

        $pdf = $this->generateFormNeo($pdf, $args);

        $tmpFile = CoreConfigModel::getTmpPath() . "tmp_file_" . rand() . ".pdf";
        $pdf->Output($tmpFile, 'F');
        $encodedFile = file_get_contents($tmpFile);
        unlink($tmpFile);
        return base64_encode($encodedFile);
    }
    // EDISSYUM - END EME01

    // EDISSYUM - NCH01 Rajout d'une route pour update un external_id
    public function updateExternalId(Request $request, Response $response)
    {
        $data = $request->getParsedBody();

        if (empty($data['externalInfos'])) {
            return $response->withStatus(400)->withJson(['errors' => 'Bad Request : externalInfos is empty']);
        }

        foreach ($data['externalInfos'] as $mail) {
            if (!Validator::intType()->validate($mail['res_id'])) {
                return $response->withStatus(400)->withJson(['errors' => 'Bad Request: invalid res_id']);
            }
            if (!Validator::StringType()->notEmpty()->validate($mail['external_id'])) {
                return $response->withStatus(400)->withJson(['errors' => 'Bad Request: invalid external_id for element : ' . $mail['res_id']]);
            }
        }

        foreach ($data['externalInfos'] as $mail) {
            $document = ResModel::getById(['resId' => $mail['res_id'], 'select' => ['res_id', 'external_id']]);
            if (empty($document)) {
                return $response->withStatus(400)->withJson(['errors' => _DOCUMENT_NOT_FOUND]);
            }
            if (!ResController::hasRightByResId(['resId' => [$document['res_id']], 'userId' => $GLOBALS['id']])) {
                return $response->withStatus(403)->withJson(['errors' => 'Document out of perimeter']);
            }
            $externalId = json_decode($document['external_id'], true);
            if (isset($mail['app'])) {
                $externalId[$mail['app']] = $mail['external_id'];
            } else {
                $externalId['publikId'] = $mail['external_id'];
            }
            ResModel::update(['set' => ['external_id' => json_encode($externalId)], 'where' => ['res_id = ?'], 'data' => [$document['res_id']]]);
        }
        return $response->withJson(['success' => 'success']);
    }
    // END EDISSYUM - NCH01
}
