<?php

    chdir('../../../');
    require 'vendor/autoload.php';

    $functionCorrespondances = [
        'send_signalements' => 'sendSignalements',
        'synchronize_fields' => 'synchronizeFields',
        'retrieve_signalements' => 'getSignalements', // EDISSYUM - LBE01 -  Amélioration OpenGST partie "retrieve"
        'update_signalements' => 'updateSignalements'
    ];

    if (!empty($argv[3]) && $argv[3] == '--action' && !empty($argv[4])) {
        $action = $argv[4];
        foreach ($functionCorrespondances as $functionName => $function) {
            if ($action == $functionName) {
                OpenGSTScript::$function($argv);
            }
        }
    }

    class OpenGSTScript {
        // EDISSYUM - LBE01 -  Amélioration OpenGST partie "retrieve"
        static function getSignalements(array $args): void {
            if (!empty($args[1]) && $args[1] == '--customId' && !empty($args[2])) {
                $args['customId'] = $args[2];
            } else {
                self::writeLog('', ['message' => "[ERROR] [RETRIEVE_SIGNALEMENT] --customId is missing"]);
                exit();
            }

            $language = \SrcCore\models\CoreConfigModel::getLanguage();
            require_once("src/core/lang/lang-{$language}.php");

            if (file_exists("custom/{$args['customId']}/src/core/lang/lang-{$language}.php")) {
                require_once("custom/{$args['customId']}/src/core/lang/lang-{$language}.php");
            }

            \SrcCore\models\DatabasePDO::reset();
            new \SrcCore\models\DatabasePDO(['customId' => $args['customId']]);
            $configuration = self::getJsonLoaded(['customId' => $args['customId'], 'path' => 'bin/external/opengst/config.json']);
            $openGSTClauses = $configuration['OpenGSTClauses']['retrieveSignalement'];

            self::writeLog($args['customId'], ['message' => "[INFO] ################################################"]);
            $alreadyCreatedResources = \SrcCore\models\DatabaseModel::select([
                'select' => ["external_id #>> '{{$configuration['MEM']['externalId']}, demande_intervention}' as demande_intervention"],
                "table" => ['res_letterbox'],
                'where' => [
                    "status NOT IN (?)",
                    "external_id #>> '{{$configuration['MEM']['externalId']}, demande_intervention}' is NOT NULL"],
                'data' => [['DEL', 'END', $configuration['MEM']['closed_status']]]
            ]);
            $alreadyCreatedIds = [];
            foreach ($alreadyCreatedResources as $resource) {
                if (!empty($resource['demande_intervention'])) {
                    $alreadyCreatedIds[] = $resource['demande_intervention'];
                }
            }

            $alreadyClosedResources = \SrcCore\models\DatabaseModel::select([
                'select' => ["external_id #>> '{{$configuration['MEM']['externalId']}, demande_intervention}' as demande_intervention"],
                "table" => ['res_letterbox'],
                'where' => [
                    "status IN (?)",
                    "external_id #>> '{{$configuration['MEM']['externalId']}, demande_intervention}' is NOT NULL"],
                'data' => [['DEL', 'END']]
            ]);
            $alreadyClosedIds = [];
            foreach ($alreadyClosedResources as $closedResource) {
                if (!empty($closedResource['demande_intervention'])) {
                    $alreadyClosedIds[] = $closedResource['demande_intervention'];
                }
            }

            $domains = [["id", "not in", $alreadyClosedIds]];
            foreach ($openGSTClauses as $clause) {
                if (!empty($clause['column'] && !empty($clause['operator']) && !empty($clause['value']))) {
                    $domains[] = [
                        $clause['column'],
                        $clause['operator'],
                        $clause['value']
                    ];
                }
            }

            $domains[] = [
                'create_date',
                '>=',
                $configuration['OpenGST']['created_date_from']
            ];

            self::setGlobalId($configuration, $args['customId']);
            $args['session'] = self::getSessionID($args, $configuration);
            $getInterventionsParams = [
                "model"   => "openstc.ask",
                "session" => $args['session'],
                "fields"  => ["id", "state", "site1", "partner_id", "create_date", "name", "attachments", "description", "partner_address", "contributions", "service_id"],
                "domain"  => $domains
            ];
            $opengstInterList = self::getInterventions($args, $getInterventionsParams, $configuration);

            foreach ($opengstInterList as $opengstIntervention) {
                $interventionId = $opengstIntervention['id'];
                self::writeLog($args['customId'], ['message' => "[INFO] [RETRIEVE_SIGNALEMENT] Processing OpenGST intervention ID: " . $interventionId]);

                $demandeurId = $opengstIntervention['partner_address'][0] ?? null;
                $siteId = $opengstIntervention['site1'][0] ?? null;
                if ($demandeurId) {
                    $getContactParams = [
                        "route" => '/web/dataset/get',
                        "model" => "res.partner.address",
                        "session" => $args['session'],
                        "fields" => ["email", "function", "name", "phone", "street", "street2", "user_id", "zip", "city"],
                        "ids" => [$demandeurId]
                    ];
                    $contactInfos = self::openGSTQueryGeneric($args, $getContactParams, $configuration);
                    $contact = null;
                    if ($contactInfos) {
                        $contact_id = self::createMEMContactFromOpenGST($args, $contactInfos[0], $configuration);
                        if ($contact_id) {
                            $contact = [['id' => $contact_id, 'type' => 'contact']];
                        }
                    }
                }

                $resId = false;
                if (!in_array($interventionId, $alreadyCreatedIds)) {
                    $resId = self::createMEMResourceFromOpenGST($args, $opengstIntervention, $contact, $configuration);
                    if (!$resId) {
                        self::writeLog($args['customId'], ['message' => "[ERROR] [RETRIEVE_SIGNALEMENT] Could not create resource for OpenGST intervention ID: " . $interventionId]);
                        continue;
                    }
                }

                $attachmentList = []; // EDISSYUM - LBE01 -  Amélioration OpenGST partie "retrieve"
                foreach ($opengstIntervention['attachments'] as $attachment) {
                    $attachmentList[] = $attachment; // EDISSYUM - LBE01 -  Amélioration OpenGST partie "retrieve"
                    $getAttachmentsFileParams = [
                        "route"   => '/web/dataset/get',
                        "model"   => "ir.attachment",
                        "session" => $args['session'],
                        "fields"  => ["datas", "datas_fname", "mime_type"],
                        "ids"      => [$attachment]
                    ];
                    $openGSTAttachment = self::openGSTQueryGeneric($args, $getAttachmentsFileParams, $configuration);
                    if ($openGSTAttachment) {
                        $openGSTAttachment[0]['datas_fname'] = 'Demande d\'intervention n°' . $interventionId . ' : ' . $openGSTAttachment[0]['datas_fname'];
                        self::createMEMAttachmentFromOpenGST($args, $openGSTAttachment[0], $resId, $configuration);
                    }
                }

                $openGSTContribs = self::openGSTQueryGeneric($args, [
                    "session" => $args['session'],
                    "route" => '/web/dataset/search_read',
                    "model" => "openstc.ask.contrib",
                    "fields" => ["note", "create_date", "create_uid", "create_date"],
                    "domain" => [["ask_id", "=", intval($interventionId)]]
                ], $configuration);
                foreach ($openGSTContribs as $contribution) {
                    $noteContent = "Contribution n°" . $contribution['id'] . " : " . $contribution['note'];
                    $note_id = \Note\models\NoteModel::create([
                        "note_text" => $noteContent,
                        "user_id" => $GLOBALS['id'],
                        "resId" => $resId
                    ]);
                    self::insertNotesInOpenGstContrib([
                        'note_id'    => $note_id,
                        'source'     => 'OpenGST',
                        'res_id'     => $resId,
                        'contrib_id' => $contribution['id'],
                        'opengst_id' => $interventionId
                    ]);
                }

                $contributions = self::openGSTQueryGeneric($args, [
                    "route"   => '/web/dataset/search_read',
                    "model"   => "project.task",
                    "session" => $args['session'],
                    "fields"  => ["id", "state", "name", "attachments", "inter_desc"],
                    "domain"  => [["ask_id", "=", intval($interventionId)], ["state", "=", "valid"]]
                ], $configuration);
                foreach ($contributions as $contribution) {
                    foreach ($contribution['attachments'] as $attachment) {
                        if (!in_array($attachment, $attachmentList)) {
                            $getAttachmentsFileParams = [
                                "route" => '/web/dataset/get',
                                "model" => "ir.attachment",
                                "session" => $args['session'],
                                "fields" => ["datas", "datas_fname", "mime_type"],
                                "ids" => [$attachment]
                            ];
                            $openGSTAttachment = self::openGSTQueryGeneric($args, $getAttachmentsFileParams, $configuration);
                            if ($openGSTAttachment) {
                                $openGSTAttachment[0]['datas_fname'] = 'Intervention n°' . $contribution['id'] . ' : ' . $openGSTAttachment[0]['datas_fname'];
                                self::createMEMAttachmentFromOpenGST($args, $openGSTAttachment[0], $resId, $configuration);
                            }
                        }
                    }
                }

                //$opengstIntervention
                if (in_array($opengstIntervention['state'],$configuration['OpenGST']['closed_state']) && !in_array($interventionId, $alreadyClosedIds)) {
                    self::closeMEMResourceFromOpenGST($interventionId, $configuration);
                }


                self::writeLog($args['customId'], ['message' => "[INFO] ################################################\n"]);
               // exit(); // Pour test, dé-commenter pour ne reprendre qu'une seule demande OpenGST
            }
        }
        // END EDISSYUM - LBE01

        static function sendSignalements(array $args): void {
            if (!empty($args[1]) && $args[1] == '--customId' && !empty($args[2])) {
                $args['customId'] = $args[2];
            } else {
                self::writeLog('', ['message' => "[ERROR] [SEND_SIGNALEMENT] --customId is missing"]);
                exit();
            }

            $language = \SrcCore\models\CoreConfigModel::getLanguage();
            require_once("src/core/lang/lang-{$language}.php");

            if (file_exists("custom/{$args['customId']}/src/core/lang/lang-{$language}.php")) {
                require_once("custom/{$args['customId']}/src/core/lang/lang-{$language}.php");
            }

            $configuration = self::getJsonLoaded(['customId' => $args['customId'], 'path' => 'bin/external/opengst/config.json']);

            $mappingChannels = [];
            foreach ($configuration['mapping']['channels'] as $item) {
                $mappingChannels[$item['MEM']] = [
                    'opengst_id' => $item['OpenGST'],
                    'send_email' => $item['sendEmail']
                ];
            }

            $mappingStatus = [];
            foreach ($configuration['mapping']['status'] as $item) {
                $mappingStatus[$item['MEM']] =  $item['OpenGST'];
            }

            \SrcCore\models\DatabasePDO::reset();
            new \SrcCore\models\DatabasePDO(['customId' => $args['customId']]);
            self::setGlobalId($configuration, $args['customId']);

            $dataClause = [];
            $whereClause = [];
            foreach ($configuration['databaseClauses']['sendToOpenGST']['clause'] as $item) {
                $whereClause[] = $item['where'];
                if (!empty($item['data'])) {
                    $dataClause[] = $item['data'];
                }
            }

            $resources = \SrcCore\models\DatabaseModel::select([
                'select'    => [$configuration['databaseClauses']['sendToOpenGST']['select']],
                'table'     => ['res_letterbox'],
                'where'     => $whereClause,
                'data'      => $dataClause
            ]);

            $customFieldsMapping = $configuration['customFields'];
            $args['session'] = self::getSessionID($args, $configuration);
            foreach ($resources as $resource) {
                $customFields = json_decode($resource['custom_fields'], true);
                foreach ($customFieldsMapping as $value) {
                    if (empty($customFields[$value])) {
                        $customFields[$value] = '';
                    }
                }

                if (isset($customFields[$customFieldsMapping['canal']])) {
                    $contactInfos = self::getContactInfos($resource['res_id']);
                    $customType = explode('#', $customFields[$customFieldsMapping['type']])[1];
                    $typist = \User\models\UserModel::getById(['select' => ['firstname, lastname'], 'id' => $resource['typist']]);

                    $serviceId = self::getOpenGSTServiceId($args, ['name' => $customType], $configuration);

                    $OpenGSTtypeIds = \SrcCore\models\DatabaseModel::select([
                        'select' => ['opengst_model'],
                        'table'  => ['opengst_services'],
                        'where'  => ['opengst_service = ?'],
                        'data'   => [$customFields[$customFieldsMapping['type']]]
                    ]);

                    if (empty($OpenGSTtypeIds)) {
                        self::writeLog($args['customId'], ['message' => "[ERROR] [SEND_SIGNALEMENT] Could not find type with id " . $customFields[$customFieldsMapping['type']]]);
                        exit();
                    }
                    $typeId = $OpenGSTtypeIds[0]['opengst_model'];

                    $reportParam = [
                        "type_id" => $typeId,
                        "service" => $serviceId,
                        "contact" => $contactInfos,
                        "res_id" => $resource['res_id'],
                        "subject" => $resource['subject'],
                        "creation_date" => $resource['creation_date'],
                        "alt_identifier" => $resource['alt_identifier'],
                        "infos" => $customFields[$customFieldsMapping['infos']],
                        "canal" => $customFields[$customFieldsMapping['canal']],
                        "domaine" => $customFields[$customFieldsMapping['domaine']],
                        "adresse" => $customFields[$customFieldsMapping['adresse']],
                        "typist" => $typist['firstname'] . ' ' . $typist['lastname'],
                        "quartier" => $customFields[$customFieldsMapping['quartier']],
                        "priorite" => $customFields[$customFieldsMapping['priorite']],
                        "report_subject" => $customFields[$customFieldsMapping['objet']],
                        "type" => explode('#', $customFields[$customFieldsMapping['type']])[1],
                        "canal_opengst" => $mappingChannels[$customFields[$customFieldsMapping['canal']]]
                    ];

                    if ($customFields[$customFieldsMapping['canal']] == 'COURRIER') {
                        $reportParam['report_subject'] = "Courrier_" . $reportParam['report_subject'];
                    }

                    $reportId = self::createOpenGSTReport($args, $reportParam, $configuration);
                    if (!$reportId) {
                        self::writeLog($args['customId'], ['message' => "[ERROR] [SEND_SIGNALEMENT] Could not create report for resource " . $resource['res_id']]);
                        continue;
                    } else {
                        self::writeLog($args['customId'], ['message' => "[INFO] [SEND_SIGNALEMENT] Report " . $reportId . " created for resource " . $resource['res_id']]);
                    }

                    $externalId = json_decode($resource['external_id'], true);
                    $externalId[$configuration['MEM']['externalId']] = ["demande_intervention" => $reportId];
                    $customFields[$customFieldsMapping['status_demande']] = $configuration['MEM']['statusAfterSend'];

                    \Resource\models\ResModel::update([
                        'set'   => [
                            'external_id' => json_encode($externalId),
                            'custom_fields' => json_encode($customFields)
                        ],
                        'where' => ['res_id = ?'],
                        'data'  => [$resource['res_id']]
                    ]);

                    $documents = self::getMEMDocAndAttachments($resource);
                    foreach ($documents as $document) {
                        $reportAttachmentParams = [
                            'report_id' => $reportId,
                            'title' => $document['title'],
                            'file_name' => $document['file_name'],
                            'encoded_document' => $document['encoded_document'],
                        ];
                        self::createOpenGSTAttachment($args, $reportAttachmentParams, $configuration);
                    }

                    $results = \SrcCore\models\DatabaseModel::select([
                        'select' => ['note_id', 'contrib_id'],
                        'table'  => ['opengst_contributions'],
                        'where'  => ['res_id = ?', 'opengst_id = ? OR source IN (?)'],
                        'data'   => [$resource['res_id'], $reportId, "'opengst', '', NULL"]
                    ]);

                    $notesInOpengst = [];
                    foreach ($results as $item) {
                        $notesInOpengst[] = $item['note_id'];
                    }

                    self::insertNotesInOpenGst($args, $externalId, $configuration, $resource['res_id'], $notesInOpengst);

                    if ($reportParam['canal'] != 'COURRIER') {
                        $mailParams = [
                            "status" => "WAITING",
                            "emailModelId" => $configuration['MEMEmailModelId']['sendSignalement'],
                            "resId" => $resource['res_id'],
                            "email" => $contactInfos['email'],
                            "object" => "Accusé d’enregistrement : " . $resource['subject'],
                            "publipostage" => [
                                '###OPENGST_SERVICE###'     => $reportParam['type'],
                                '###OPENGST_SUBJECT###'     => $reportParam['report_subject'],
                                '###OPENGST_REPORT_ID###'   => $reportId
                            ]
                        ];
                        self::sendEmail($args, $mailParams, $configuration);
                    }
                }
            }
        }

        static function updateSignalements(array $args): void {
            if (!empty($args[1]) && $args[1] == '--customId' && !empty($args[2])) {
                $args['customId'] = $args[2];
            } else {
                self::writeLog('', ['message' => "[ERROR] [UPDATE_SIGNALEMENT] --customId is missing"]);
                exit();
            }

            $language = \SrcCore\models\CoreConfigModel::getLanguage();
            require_once("src/core/lang/lang-{$language}.php");

            if (file_exists("custom/{$args['customId']}/src/core/lang/lang-{$language}.php")) {
                require_once("custom/{$args['customId']}/src/core/lang/lang-{$language}.php");
            }

            $configuration = self::getJsonLoaded(['customId' => $args['customId'], 'path' => 'bin/external/opengst/config.json']);

            \SrcCore\models\DatabasePDO::reset();
            new \SrcCore\models\DatabasePDO(['customId' => $args['customId']]);
            self::setGlobalId($configuration, $args['customId']);

            $whereClause = [];
            $dataClause = [];
            foreach ($configuration['databaseClauses']['updateFomOpenGST']['clause'] as $item) {
                $whereClause[] = $item['where'];
                if (!empty($item['data'])) {
                    $dataClause[] = $item['data'];
                }
            }

            $mappingStatus = [];
            foreach ($configuration['mapping']['status'] as $item) {
                $mappingStatus[$item['MEM']] =  $item['OpenGST'];
            }

            $resources = \SrcCore\models\DatabaseModel::select([
                'select'    => [$configuration['databaseClauses']['updateFomOpenGST']['select']],
                'table'     => ['res_letterbox'],
                'where'     => $whereClause,
                'data'      => $dataClause
            ]);

            $customFieldsMapping = $configuration['customFields'];
            $args['session'] = self::getSessionID($args, $configuration);
            foreach ($resources as $resource) {
                $externalId = json_decode($resource['external_id'], true);
                $customFields = json_decode($resource['custom_fields'], true);
                foreach ($customFieldsMapping as $value) {
                    if (empty($customFields[$value])) {
                        $customFields[$value] = '';
                    }
                }

                $reportId = $externalId['opengst']['demande_intervention'];
                $results = \SrcCore\models\DatabaseModel::select([
                    'select' => ['note_id', 'contrib_id'],
                    'table'  => ['opengst_contributions'],
                    'where'  => ['res_id = ?', 'opengst_id = ? OR source IN (?)'],
                    'data'   => [$resource['res_id'], $reportId, "'opengst', '', NULL"]
                ]);

                $contribsInMEM = [];
                $notesInOpengst = [];
                foreach ($results as $item) {
                    $notesInOpengst[] = $item['note_id'];
                    $contribsInMEM[] = $item['contrib_id'];
                }

                $contributionId = self::insertNotesInOpenGst($args, $externalId['opengst']['demande_intervention'], $configuration, $resource['res_id'], $notesInOpengst);
                if ($contributionId) {
                    $contribsInMEM[] = $contributionId;
                }

                $openGSTContribs = self::openGSTQueryGeneric($args, [
                    "session" => $args['session'],
                    "route" => '/web/dataset/search_read',
                    "model" => "openstc.ask.contrib",
                    "fields" => ["note", "create_date", "create_uid", "create_date"],
                    "domain" => [["ask_id", "=", intval($reportId)]]
                ], $configuration);

                foreach ($openGSTContribs as $openGSTContrib) {
                    if (!in_array($openGSTContrib['id'], $contribsInMEM)) {
                        $noteContent = "Note OpenGST de " . $openGSTContrib['create_uid'][1];
                        $noteContent .= " du " . $openGSTContrib['create_date'];
                        $noteContent .= " : " . $openGSTContrib['note'];

                        $note_id = \Note\models\NoteModel::create([
                            "note_text" => $noteContent,
                            "user_id" => $GLOBALS['id'],
                            "resId" => $resource['res_id']
                        ]);

                        self::insertNotesInOpenGstContrib([
                            'note_id'    => $note_id,
                            'source'     => 'OpenGST',
                            'res_id'     => $resource['res_id'],
                            'contrib_id' => $openGSTContrib['id'],
                            'note_date'  => $openGSTContrib['create_date'],
                            'opengst_id' => $reportId
                        ]);
                    }
                }

                $getReportsParams = [
                    "session" => $args['session'],
                    "route"   => '/web/dataset/search_read',
                    "model"   => "openstc.ask",
                    "fields"  => ["id", "state", "validation_order_id", "service_id", "type_id", "geo_point", "merged_into", "note_for_requester"],
                    "domain"  => [["id", "in", [$reportId]]],
                ];

                $openGSTReportList = self::openGSTQueryGeneric($args, $getReportsParams, $configuration);
                $memInterList = [];
                $maarchService = explode('#', $customFields[$customFieldsMapping['type']])[1];
                $memReportStatus = $customFields[$customFieldsMapping['status_demande']];
                $memInterventionStatus = $customFields[$customFieldsMapping['status_intervention']];
                foreach ($openGSTReportList as $openGSTReport) {
                    if ($openGSTReport['id'] == $reportId) {
                        if ($openGSTReport['state'] == 'merged' && $openGSTReport['merged_into']) {
                            $newReportId = $openGSTReport['merged_into'][0];
                            $newLink = false;

                            $newResources = \SrcCore\models\DatabaseModel::select([
                                'select' => ['res_id', 'linked_resources'],
                                'table' => ['res_letterbox'],
                                'where' => ["external_id #>> '{{$configuration['MEM']['externalId']}, demande_intervention}' = ?"],
                                'data' => [$newReportId]
                            ]);
                            foreach ($newResources as $newResource) {
                                $linkedResources = json_decode($newResource['linked_resources'], true);
                                if (!in_array($newResource['res_id'], $linkedResources)) {
                                    $newLink = true;
                                    \Resource\models\ResModel::update([
                                        'set' => [
                                            'linked_resources' => json_encode([$resource['res_id']])
                                        ],
                                        'where' => ['res_id = ?'],
                                        'data' => [$newResource['res_id']]
                                    ]);
                                }
                                $currentLinkedResources = json_decode($resource['linked_resources'], true);

                                if (!in_array($newResource['res_id'], $currentLinkedResources)) {
                                    $currentLinkedResources[] = $newResource['res_id'];
                                    \Resource\models\ResModel::update([
                                        'set' => [
                                            'linked_resources' => json_encode($currentLinkedResources)
                                        ],
                                        'where' => ['res_id = ?'],
                                        'data' => [$resource['res_id']]
                                    ]);
                                }
                            }

                            if ($newLink) {
                                $note_id = \Note\models\NoteModel::create(array(
                                    "resId" => $resource['res_id'],
                                    "user_id" => $GLOBALS['id'],
                                    "note_text" => "La demande a été fusionné dans OpenGST avec la demande D." . $newReportId
                                ));
                                self::insertNotesInOpenGstContrib([
                                    'source'     => 'OpenGST',
                                    'res_id'     => $resource['res_id'],
                                    'note_id'    => $note_id,
                                    'note_date'  => 'NOW()',
                                    'contrib_id' => $contributionId['result'],
                                    'opengst_id' => $reportId
                                ]);
                            }
                        }

                        if ($openGSTReport['service_id'][1] != $maarchService) {
                            $noteContent = "Le type de demande a été modifié dans OpenGST et vaut maintenant : " . $openGSTReport['service_id'][1];

                            $note_id = \Note\models\NoteModel::create([
                                "note_text" => $noteContent,
                                "user_id" => $GLOBALS['id'],
                                "resId" => $resource['res_id']
                            ]);

                            self::insertNotesInOpenGstContrib([
                                'note_id'    => $note_id,
                                'source'     => 'OpenGST',
                                'res_id'     => $resource['res_id'],
                                'contrib_id' => -1,
                                'opengst_id' => $reportId
                            ]);

                            $customFields[$customFieldsMapping['type']] = $openGSTReport['service_id'][1];

                            self::updateCustom([
                                'custom_fields' => $customFields,
                                'res_id'        => $resource['res_id']
                            ]);
                        }

                        if ($openGSTReport['state'] && $openGSTReport['state'] != $memReportStatus) {
                            $contactInfos = self::getContactInfos($resource['res_id']);
                            $reportParams = [
                                "session"         => $args['session'],
                                "newReportStatus" => $openGSTReport['state'],
                                "reportId"        => $reportId,
                                "memParams"       => $resource,
                                "customFields"    => $customFields,
                                "email"           => $contactInfos['email'],
                                "statusMap"       => $mappingStatus
                            ];

                            $params = [
                                "route"     => '/web/dataset/search_read',
                                "model"     => "openstc.ask",
                                "fields"    => ["id", "validation_order_id"],
                                "domain"    => [["id", "in", [$reportId]]],
                            ];
                            $results = self::openGSTQueryGeneric($args, $params, $configuration);

                            $results_voi = [];
                            foreach($results as $validation_order_id) {
                                $params_voi = [
                                    "route"     => '/web/dataset/get',
                                    "model"     => "openbase.validation",
                                    "fields"    => ["note_for_requester"],
                                    "ids"       => [$validation_order_id['validation_order_id'][0]],
                                ];
                                $results_voi = self::openGSTQueryGeneric($args, $params_voi, $configuration);
                                $reportParams['study_note_for_requester'] = $results_voi[0]['note_for_requester'];
                            }

                            $results = \SrcCore\models\DatabaseModel::select([
                                'table'     => ['opengst_contributions'],
                                'select'    => ['contrib_id'],
                                'where'     => ['res_id = ?'],
                                'data'      => [$resource['res_id']]
                            ]);

                            foreach($results as $item) {
                                $contribsInMEM[] = $item['contrib_id'];
                            }

                            if (!array_key_exists('study_note_for_requester', $reportParams)) {
                                $reportParams['study_note_for_requester'] = '';
                            } elseif ($results_voi[0]['note_for_requester']  != '' and !in_array(-2, $contribsInMEM)) {
                                $noteContent = "Une note a été ajoutée à l'étude : " . $results_voi[0]['note_for_requester'];
                                $note_id = \Note\models\NoteModel::create(array(
                                    "note_text" => $noteContent,
                                    "user_id"   => $GLOBALS['id'],
                                    "resId"     => $resource['res_id']
                                ));

                                self::insertNotesInOpenGstContrib([
                                    'note_id'    => $note_id,
                                    'source'     => 'OpenGST',
                                    'res_id'     => $resource['res_id'],
                                    'contrib_id' => -2,
                                ]);
                            }

                            $reportParams['note_for_requester'] = $openGSTReport['note_for_requester'];
                            if (!array_key_exists('note_for_requester', $reportParams)) {
                                $reportParams['note_for_requester'] = '';
                            } elseif ($results_voi[0]['note_for_requester']  != '' and !in_array(-3, $contribsInMEM)) {
                                $noteContent = "Une note a été ajoutée lors de la validation : " . $reportParams['note_for_requester'];
                                $note_id = \Note\models\NoteModel::create([
                                    "note_text" => $noteContent,
                                    "user_id"   => $GLOBALS['id'],
                                    "resId"     => $resource['res_id']
                                ]);

                                self::insertNotesInOpenGstContrib([
                                    'note_id'    => $note_id,
                                    'source'     => 'OpenGST',
                                    'res_id'     => $resource['res_id'],
                                    'contrib_id' => -3,
                                ]);
                            }

                            if($reportParams['study_note_for_requester'] != '') {
                                $reportParams['study_note_for_requester'] = "Information complémentaire de l'étude du service en charge de la demande : \r\n" . $reportParams['study_note_for_requester'];
                            }
                            if($reportParams['note_for_requester'] != '') {
                                $reportParams['note_for_requester'] = "Information complémentaire du service en charge de la demande : \r\n" . $reportParams['note_for_requester'];
                            }

                            self::processReportsStatusChange($args, $reportParams, $configuration, $contribsInMEM);

                            $customFields[$customFieldsMapping['status_demande']] = $openGSTReport['state'];

                            self::updateCustom([
                                'custom_fields' => $customFields,
                                'res_id'        => $resource['res_id']
                            ]);
                        }

                        if (($openGSTReport['state'] == 'valid' or $openGSTReport['state'] == 'finished') and $memInterventionStatus == null) {
                            $params_inters = [
                                "route"     => '/web/dataset/search_read',
                                "model"     => "project.project",
                                "fields"    => ["id", "state"],
                                "domain"    => [["ask_id", "=", intval($reportId)]],
                                "sort"      => "id DESC"
                            ];
                            $opengstInterList = self::openGSTQueryGeneric($args, $params_inters, $configuration);

                            $customFields[$customFieldsMapping['status_intervention']] = $opengstInterList[0]['state'];
                            self::updateCustom([
                                'custom_fields' => $customFields,
                                'res_id'        => $resource['res_id']
                            ]);

                            $externalId = json_decode($resource['external_id'], true);
                            if (array_key_exists('demande_intervention', $externalId[$configuration['MEM']['externalId']])) {
                                $externalId[$configuration['MEM']['externalId']] = [
                                    "demande_intervention" => $externalId[$configuration['MEM']['externalId']]['demande_intervention'],
                                    "intervention" => $opengstInterList[0]['id']
                                ];
                            } else {
                                $externalId[$configuration['MEM']['externalId']] = ["intervention" => $opengstInterList[0]['id']];
                            }

                            \SrcCore\models\DatabaseModel::update([
                                'set'   => [
                                    'external_id' => json_encode($externalId)
                                ],
                                'where' => ['res_id = ?'],
                                'data'  => [$resource['res_id']]
                            ]);
                        }
                    }

                    $memInterList[$customFields[$customFieldsMapping['intervention']]] = $reportId;
                    $memInterList[$customFields[$customFieldsMapping['intervention']]]['inter_status'] = $customFields[$customFieldsMapping['status_intervention']];
                    $memInterList[$customFields[$customFieldsMapping['intervention']]]['res_id'] = $resource['res_id'];
                }

                $getInterventionsParams = [
                    "session" => $args['session'],
                    "fields"  => ["id", "state"],
                    "domain"  => [
                        ["id", "in", array_keys($memInterList)]
                    ]
                ];

                $opengstInterList = self::getInterventions($args, $getInterventionsParams, $configuration);
                foreach ($opengstInterList as $opengstIntervention) {
                    $interventionId = $opengstIntervention['id'];
                    $interventionStatus = $opengstIntervention['state'];

                    if ($interventionStatus != $memInterList[$interventionId]['inter_status']) {
                        $contactInfos = self::getContactInfos($memInterList[$interventionId]['res_id']);
                        $interventionParams = array(
                            "newInterventionStatus" => $interventionStatus,
                            "InterventionId"        => $interventionId,
                            "memParams"             => $memInterList[$interventionId],
                            "email"                 => $contactInfos['email'],
                            "statusMap"             => $mappingStatus
                        );
                        self::processInterventionsStatusChange($args, $interventionParams, $configuration);

                        $customFields[$customFieldsMapping['status_intervention']] = $interventionStatus;
                        self::updateCustom([
                            'custom_fields' => $customFields,
                            'res_id'        => $memInterList[$interventionId]['res_id']
                        ]);
                    }
                }

                \SrcCore\models\DatabaseModel::update([
                    'set'   => [
                        'status' => 'O_COU' ? $memReportStatus == 'wait' || $memReportStatus == 'draft' : 'O_INT'
                    ],
                    'where' => ['res_id = ?'],
                    'data'  => [$resource['res_id']]
                ]);
            }
        }

        public static function synchronizeFields(array $args): void {
            if (!empty($args[1]) && $args[1] == '--customId' && !empty($args[2])) {
                $customId = $args[2];
            } else {
                self::writeLog('', ['message' => "[ERROR] [SEND_SIGNALEMENT] --customId is missing"]);
                exit();
            }

            $configuration = self::getJsonLoaded(['path' => 'bin/external/opengst/config.json', 'customId' => $customId]);
            if (empty($configuration)) {
                self::writeLog($customId, ['message' => "[ERROR] [synchronizeFields] File bin/external/opengst/config.json does not exist"]);
                exit();
            }

            \SrcCore\models\DatabasePDO::reset();
            new \SrcCore\models\DatabasePDO(['customId' => $customId]);

            $opengstServices = [];
            try {
                $file = fopen('/var/share/opengst/services.csv', 'r');
                if (!$file) {
                    self::writeLog($customId, ['message' => "[ERROR] [synchronizeFields] Could not open file /var/share/opengst/services.csv"]);
                    exit();
                }

                while (($line = fgetcsv($file, 1000, '#')) !== FALSE) {
                    $opengstServices[] = [
                        'maarch_label' => $line[0],
                        'opengst_service' => $line[1],
                        'opengst_model' => $line[2] != '' ? $line[2] : '-1'
                    ];
                }
                fclose($file);
            } catch (Exception $e) {
                self::writeLog($customId, ['message' => "[ERROR] [synchronizeFields] Error reading /var/share/opengst/services.csv : " . $e->getMessage()]);
                exit();
            }

            SrcCore\models\DatabaseModel::delete([
                'table' => 'opengst_services',
                'where' => ['true']
            ]);

            foreach ($opengstServices as $opengstService) {
                SrcCore\models\DatabaseModel::insert([
                    'table' => 'opengst_services',
                    'columnsValues' => [
                        'maarch_label' => $opengstService['maarch_label'],
                        'opengst_service' => $opengstService['opengst_model'] . '#' . $opengstService['opengst_service'],
                        'opengst_model' => $opengstService['opengst_model']
                    ]
                ]);
            }
        }

        private static function openGSTQueryGeneric(array $args, array $queryParams, array $configuration) {
            $params = [
                "model"      => $queryParams['model'],
                "context"    => $args['session']['context'],
                "session_id" => $args['session']['session_id'],
            ];

            if (array_key_exists("data", $queryParams)) {
                $params["data"] = $queryParams['data'];
            }
            if (array_key_exists("fields", $queryParams)) {
                $params["fields"] = $queryParams['fields'];
            }
            if (array_key_exists("domain", $queryParams)) {
                $params["domain"] = $queryParams['domain'];
            }
            if (array_key_exists("sort", $queryParams)) {
                $params["sort"] = $queryParams['sort'];
            }
            if (array_key_exists("limit", $queryParams)) {
                $params["limit"] = $queryParams['limit'];
            }
            if (array_key_exists("offset", $queryParams)) {
                $params["offset"] = $queryParams['offset'];
            }
            if (array_key_exists("ids", $queryParams)) {
                $params["ids"] = $queryParams['ids'];
            }

            $body = array(
                'jsonrpc' => '2.0',
                'id'      => "r1",
                'method'  => 'call',
                'params'  => $params
            );

            $response = \SrcCore\models\CurlModel::exec([
                'url'     => $configuration['OpenGST']['url'] . $queryParams['route'],
                'method'  => 'POST',
                'headers' => ['content-type:application/json', $args['session']['cookies']],
                'body'    => json_encode($body),
                'noLogs'  => true
            ]);

            if (!is_array($response['response']) || !array_key_exists('result', $response['response'])) {
                self::writeLog($args['customId'], ['message' => "[ERROR] [OPEN_GST_QUERY_GENERIC] Error running query " . $configuration['OpenGST']['url'] . $queryParams['route'] . " : " . $response['response']['error']['data']['fault_code']]);
                return false;
            }

            if (array_key_exists('records', $response['response']['result'])) {
                return $response['response']['result']['records'];
            }
            return $response['response']['result'];
        }

        private static function createOpenGSTReport(array $args, array $reportParams, array $configuration) {
            $data = [
                'type_id' => $reportParams['type_id'],
                'service_id' => $reportParams['service'],
                'name' => $reportParams['report_subject'] <> '' ? $reportParams['report_subject'] : 'Demande ' . $reportParams['contact']['firstname'] . " " . $reportParams['contact']['lastname']
            ];

            $adresse_inter = $reportParams['adresse'][0];
            $data['site_details'] = $adresse_inter['addressNumber'] . ' ' . $adresse_inter['addressStreet'] . ' ' . $adresse_inter['addressPostcode'] . ' ' . $adresse_inter['addressTown'] . PHP_EOL;
            if (!empty($adresse_inter['longitude'])) {
                $data['geo_point'] = "{\"type\": \"Point\", \"coordinates\": [" . $adresse_inter['longitude'] . ", " . $adresse_inter['latitude'] . "]}";
            }

            $data['description'] = "Numéro de chrono MEM : " . $reportParams['alt_identifier'] . PHP_EOL;
            $data['description'] .= "Saisi par : " . $reportParams['typist'] . PHP_EOL;
            $data['description'] .= "Email demandeur : " . $reportParams['contact']['email'] . PHP_EOL;
            $data['description'] .= "Description : " . $reportParams['infos'];

            $data['site1'] = null;
            $data['is_citizen'] = true;
            $data['people_address'] = "";
            $data['current_date'] = $reportParams['creation_date'];
            $data['people_phone'] = $reportParams['contact']['phone'];
            $data['communication_channel_id'] = $reportParams['canal_opengst']['opengst_id'];
            $data['people_name'] = $reportParams['contact']['firstname'] . " " . $reportParams['contact']['lastname'];

            $body = [
                'id' => "r1",
                'jsonrpc' => '2.0',
                'method' => 'call',
                'params' => [
                    "data" => $data,
                    "model" => "openstc.ask",
                    "context" => $args['session']['context'],
                    "session_id" => $args['session']['session_id']
                ]
            ];

            $response = \SrcCore\models\CurlModel::exec([
                'url'       => $configuration['OpenGST']['url'] . '/web/dataset/create',
                'method'    => 'POST',
                'headers'   => ['content-type:application/json', $args['session']['cookies']],
                'body'      => json_encode($body),
                'noLogs'    => true
            ]);

            $reportID = $response['response']['result']['result'];

            if (!$reportID) {
                self::writeLog($args['customId'], ['message' => "[ERROR] [CREATE_OPENGST_REPORT] Could not create report : " . $response['response']['error']['data']['fault_code']]);
                exit();
            }
            return $reportID;
        }

        private static function createOpenGSTAttachment(array $args, array $reportAttachmentParams, array $configuration) {
            $body = [
                'jsonrpc' => '2.0',
                'id' => "r1",
                'method' => 'call',
                'params' => [
                    "data" => [
                        "datas" => $reportAttachmentParams['encoded_document'],
                        "datas_fname" => $reportAttachmentParams['file_name'],
                        "name" => $reportAttachmentParams['title'],
                        "res_id" => $reportAttachmentParams['report_id'],
                        "res_model" => "openstc.ask"
                    ],
                    "model" => "ir.attachment",
                    "session_id" => $args['session']['session_id'],
                    "context" => $args['session']['context']
                ]
            ];

            $response = \SrcCore\models\CurlModel::exec([
                'url'       => $configuration['OpenGST']['url'] . '/web/dataset/create',
                'method'    => 'POST',
                'headers'   => ['content-type:application/json', $args['session']['cookies']],
                'body'      => json_encode($body),
                'noLogs'    => true
            ]);

            $reportAttachmentId = $response['response']['result']['result'];
            if (!$reportAttachmentId) {
                self::writeLog($args['customId'], ['message' => "[ERROR] [CREATE_OPENGST_REPORT_ATTACHMENT] Could not create report attachment : " . $response['response']['error']['data']['fault_code']]);
                exit();
            }

            return $reportAttachmentId;
        }

        private static function getSessionID(array $args, array $configuration) {
            $body = [
                'jsonrpc' => '2.0',
                'id' => 'r2',
                'method' => 'call',
                'params' => [
                    "context" => [
                        "__ref" => "compound_context",
                        "__contexts" => [
                            [
                                "lang" => "fr_FR",
                                "tz" => "Europe/Paris",
                            ]
                        ]
                    ],
                    "db"        => $configuration['OpenGST']['database'],
                    "login"     => $configuration['OpenGST']['username'],
                    "password"  => $configuration['OpenGST']['password']
                ]
            ];

            $response = \SrcCore\models\CurlModel::exec([
                'url'       => $configuration['OpenGST']['url'] . '/web/session/authenticate',
                'method'    => 'POST',
                'headers'   => ['content-type:application/json'],
                'body'      => json_encode($body),
                'noLogs'    => true
            ]);

            $cookies = [];
            foreach ($response['headers'] as $header) {
                preg_match('/Set-Cookie: ([^;]+).*/i', $header, $match); // EDISSYUM - LBE01 -  Amélioration OpenGST partie "retrieve" | ajout i à la find de la regex
                if (isset($match[1])) {
                    $cookies [] = $match[1];
                }
            }

            $uid = $response['response']['result']['uid'];
            $context = $response['response']['result']['context'];
            $sessionID = $response['response']['result']['session_id'];
            if (!$uid) {
                self::writeLog($args['customId'], ['message' => "[ERROR] [GET_SESSIONID] OpenGST credentials are not valid"]);
                exit();
            }

            return [
                'uid' => $uid,
                'context' => $context,
                'session_id' => $sessionID,
                'cookies' => 'cookie: ' . implode('; ', $cookies)
            ];
        }

        private static function getOpenGSTServiceId(array $args, array $serviceParams, array $configuration) {
            $body = [
                'jsonrpc' => '2.0',
                'id'      => "r1",
                'method'  => 'call',
                'params'  => [
                    "offset"     => 0,
                    "limit"      => false,
                    "fields"     => ["id"],
                    "context"    => $args['session']['context'],
                    "sort"       => "id DESC",
                    "session_id" => $args['session']['session_id'],
                    "model"      => "openstc.service",
                    "domain"     => [["name", "=", $serviceParams['name']]]
                ]
            ];

            $response = \SrcCore\models\CurlModel::exec([
                'url'       => $configuration['OpenGST']['url'] . '/web/dataset/search_read',
                'method'    => 'POST',
                'headers'   => ['content-type:application/json', $args['session']['cookies']],
                'body'      => json_encode($body),
                'noLogs'    => true
            ]);

            if (!array_key_exists('result', $response['response'])) {
                self::writeLog($args['customId'], ['message' => "[ERROR] [GET_OPENGST_SERVICE_ID] Could not get service id : " . $response['response']['error']['data']['fault_code']]);
                exit();
            }

            if ($response['response']['result']['length'] == 0) {
                self::writeLog($args['customId'], ['message' => "[ERROR] [GET_OPENGST_SERVICE_ID] Could not find service with name " . $serviceParams['name']]);
                exit();
            }
            return $response['response']['result']['records'][0]['id'];
        }

        private static function processReportsStatusChange(array $args, array $reportParams, $configuration, $contribsInMEM) {
            $email = $reportParams["email"];
            $reportStatus = $reportParams["newReportStatus"];

            $memStatus = $reportParams['statusMap'][$reportStatus];
            if ($reportParams['customFields']['canal'] != 'COURRIER' && $reportStatus == 'finished') {
                $memStatus = 'END';
            }
            \Resource\models\ResModel::update([
                'set'     => ['status' => $memStatus, 'closing_date' => 'CURRENT_TIMESTAMP'],
                'where'   => ['res_id = ?'],
                'data'    => array($reportParams['memParams']['res_id'])
            ]);

            $reportId = $reportParams['external_id'][$configuration['MEM']['externalId']]['demande_intervention'];

            if ($reportStatus == 'refused') {
                $crtReportParams = [
                    "session" => $args["session"],
                    "fields"  => ["id", "refusal_reason", "state"],
                    "domain"  => [
                        ["id", "=", $reportParams['reportId']]
                    ]
                ];
                $reportInfos = self::getReports($args, $crtReportParams, $configuration);
                $refusalReason = $reportInfos[0]["refusal_reason"];

                if (!in_array('-4', $contribsInMEM)) {
                    $noteContent = "La demande d'intervention n°" . $reportId . ' a été refusée pour le motif suivant : ' . $refusalReason;
                    $note_id = \Note\models\NoteModel::create([
                        "note_text" => $noteContent,
                        "user_id"   => $GLOBALS['id'],
                        "resId"     => $reportParams['memParams']['res_id']
                    ]);

                    self::insertNotesInOpenGstContrib([
                        'note_id'    => $note_id,
                        'source'     => 'OpenGST',
                        'res_id'     => $reportParams['memParams']['res_id'],
                        'contrib_id' => -4,
                    ]);
                }

                if ($reportParams['customFields']['canal'] != 'COURRIER') {
                    $mailParams = [
                        "status" => "WAITING",
                        "email" => $email,
                        "resId" => $reportParams['memParams']['res_id'],
                        "object" => "Refus: " . $reportParams['customFields']['objet'],
                        "emailModelId" => $configuration['MEMEmailModelId']['reportStatusChange']['refused'],
                        "publipostage" => [
                            '###OPENGST_REPORT_ID###' => $reportId,
                            '###OPENGST_REFUSAL_REASONS###' => $refusalReason,
                            '###OPENGST_SERVICE###' => $reportParams['customFields']['type'],
                            '###OPENGST_SUBJECT###' => $reportParams['customFields']['objet'],
                            '###OPENGST_NOTE_FOR_REQUESTER###' => $reportParams['note_for_requester'],
                            '###OPENGST_STUDY_NOTE_FOR_REQUESTER###' => $reportParams['study_note_for_requester']
                        ]
                    ];
                    self::sendEmail($args, $mailParams, $configuration);
                }
            } elseif ($reportStatus == 'to_confirm') {
                if ($reportParams['memParams']['canal'] != 'COURRIER') {
                    $mailParams = [
                        "status" => "WAITING",
                        "email" => $email,
                        "resId" => $reportParams['memParams']['res_id'],
                        "object" => "Mise à l’étude: " . $reportParams['memParams']['objet'],
                        "emailModelId" => $configuration['MEMEmailModelId']['reportStatusChange']['to_confirm'],
                        "publipostage" => [
                            '###OPENGST_REPORT_ID###' => $reportId,
                            '###OPENGST_SERVICE###' => $reportParams['customFields']['type'],
                            '###OPENGST_SUBJECT###' => $reportParams['customFields']['objet'],
                            '###OPENGST_NOTE_FOR_REQUESTER###' => $reportParams['note_for_requester'],
                            '###OPENGST_STUDY_NOTE_FOR_REQUESTER###' => $reportParams['study_note_for_requester']
                        ]
                    ];
                    self::sendEmail($args, $mailParams, $configuration);
                }
            } elseif ($reportStatus == 'valid') {
                if ($reportParams['memParams']['canal'] != 'COURRIER') {
                    $mailParams = [
                        "status" => "WAITING",
                        "email" => $email,
                        "resId" => $reportParams['memParams']['res_id'],
                        "object" => "Validation: " . $reportParams['memParams']['objet'],
                        "emailModelId" => $configuration['MEMEmailModelId']['reportStatusChange']['valid'],
                        "publipostage" => [
                            '###OPENGST_REPORT_ID###' => $reportId,
                            '###OPENGST_SERVICE###' => $reportParams['customFields']['type'],
                            '###OPENGST_SUBJECT###' => $reportParams['customFields']['objet'],
                            '###OPENGST_NOTE_FOR_REQUESTER###' => $reportParams['note_for_requester'],
                            '###OPENGST_STUDY_NOTE_FOR_REQUESTER###' => $reportParams['study_note_for_requester']
                        ]
                    ];
                    self::sendEmail($args, $mailParams, $configuration);
                }
            } elseif ($reportStatus == 'finished') {
                if ($reportParams['memParams']['canal'] != 'COURRIER') {
                    $mailParams = [
                        "status" => "WAITING",
                        "email" => $email,
                        "resId" => $reportParams['memParams']['res_id'],
                        "object" => "Cloture: " . $reportParams['memParams']['objet'],
                        "emailModelId" => $configuration['MEMEmailModelId']['reportStatusChange']['finished'],
                        "publipostage" => [
                            '###OPENGST_SERVICE###' => $reportParams['memParams']['type'],
                            '###OPENGST_SUBJECT###' => $reportParams['memParams']['objet'],
                            '###OPENGST_REPORT_ID###' => $reportParams['memParams']['report_id'],
                            '###OPENGST_NOTE_FOR_REQUESTER###' => $reportParams['note_for_requester'],
                            '###OPENGST_STUDY_NOTE_FOR_REQUESTER###' => $reportParams['study_note_for_requester']
                        ]
                    ];
                    self::sendEmail($args, $mailParams, $configuration);
                }
            }
        }

        private static function getReports(array $args, array $reportParams, $configuration) {
            $body = array(
                'jsonrpc'   => '2.0',
                'id'        => "r1",
                'method'    => 'call',
                'params'    => [
                    "fields"        => $reportParams['fields'],
                    "domain"        => $reportParams['domain'],
                    "sort"          => "id DESC",
                    "limit"         => false,
                    "offset"        => 0,
                    "model"         => "openstc.ask",
                    "session_id"    => $args['session']['session_id'],
                    "context"       => $args['session']['context']
                ]
            );

            $response = \SrcCore\models\CurlModel::exec([
                'url'       => $configuration['OpenGST']['url'] . '/web/dataset/search_read',
                'method'    => 'POST',
                'headers'   => ['content-type:application/json', $args['session']['cookies']],
                'body'      => json_encode($body),
                'noLogs'    => true
            ]);

            $records = $response['response']['result']['records'];
            if (!$records) {
                self::writeLog($args['customId'], ['message' => "[ERROR] [GET_REPORTS] Error while retrieving reports : " . $response['response']['error']['data']['fault_code']]);
                exit();
            }

            return $records;
        }

        private static function processInterventionsStatusChange(array $args, array $interventionParams, $configuration) {
            $interventionStatus = $interventionParams["newInterventionStatus"];
            $previousInterventionStatus = $interventionParams['memParams']['inter_status'];

            $maarchStatus = $interventionParams['statusMap'][$interventionStatus];
            if ($interventionParams['memParams']['canal'] != 'COURRIER' && $interventionStatus == 'finished') {
                $maarchStatus = 'END';
            }
            \Resource\models\ResModel::update([
                'set'    => ['status' => $maarchStatus],
                'where'  => ['res_id = ?'],
                'data'   => [$interventionParams['memParams']['res_id']]
            ]);

            $email = $interventionParams["email"];
            if ($interventionStatus == 'scheduled') {
                if ($interventionParams['customFields']['canal'] != 'COURRIER') {
                    $mailParams = [
                        "status" => "WAITING",
                        "email" => $email,
                        "resId" => $interventionParams['memParams']['res_id'],
                        "object" => "Planification : " . $interventionParams['memParams']['objet'],
                        "emailModelId" => $configuration['MEMEmailModelId']['interventionStatusChange']['scheduled'],
                        "publipostage" => [
                            '###OPENGST_SERVICE###' => $interventionParams['memParams']['type'],
                            '###OPENGST_SUBJECT###' => $interventionParams['memParams']['objet'],
                            '###OPENGST_REPORT_ID###' => $interventionParams['memParams']['report_id'],
                        ]
                    ];
                    self::sendEmail($args, $mailParams, $configuration);
                }
            } elseif ($interventionStatus == 'open' and $previousInterventionStatus == 'scheduled') {
                if ($interventionParams['customFields']['canal'] != 'COURRIER') {
                    $mailParams = [
                        "status" => 'WAITING',
                        "email" => $email,
                        "resId" => $interventionParams['memParams']['res_id'],
                        "object" => "Report : " . $interventionParams['memParams']['report_subject'],
                        "emailModelId" => $configuration['MEMEmailModelId']['interventionStatusChange']['open'],
                        "publipostage" => [
                            '###OPENGST_SERVICE###' => $interventionParams['memParams']['type'],
                            '###OPENGST_SUBJECT###' => $interventionParams['memParams']['objet'],
                            '###OPENGST_REPORT_ID###' => $interventionParams['memParams']['report_id'],
                        ]
                    ];
                    self::sendEmail($args, $mailParams, $configuration);
                }
            }
        }

        private static function getInterventions(array $args, array $interParams, $configuration) {
            $body = [
                'jsonrpc' => '2.0',
                'id'      => "r1",
                'method'  => 'call',
                'params'  => [
                    "fields"     => $interParams['fields'],
                    "domain"     => $interParams['domain'],
                    "sort"       => "id DESC",
                    "limit"      => false,
                    "offset"     => 0,
                    "model"      => $interParams['model'] ?? "project.project", // EDISSYUM - LBE01 -  Amélioration OpenGST partie "retrieve" | ajout $interParams['model']    ??
                    "session_id" => $args['session']['session_id'],
                    "context"    => $args['session']['context']
                ]
            ];

            $response = \SrcCore\models\CurlModel::exec([
                'url'       => $configuration['OpenGST']['url'] . '/web/dataset/search_read',
                'method'    => 'POST',
                'headers'   => ['content-type:application/json', $args['session']['cookies']],
                'body'      => json_encode($body),
                'noLogs'    => true
            ]);

            $records = $response['response']['result']['records'];
            if (!$records) {
                self::writeLog($args['customId'], ['message' => "[ERROR] [GET_INTER] Error while retrieving interventions : " . json_encode($response['response'])]);
                exit();
            }


            return $records;
        }

        private static function insertNotesInOpenGst($args, $reportId, $configuration, $resId, $notesInOpenGST) {
            $notes = \Note\models\NoteModel::get([
                'select' => ["id", "note_text", "TO_CHAR(creation_date, 'DD/MM/YY HH24:MI') AS creation_date", "user_id"],
                'where'  => ['identifier = ?'],
                'data'   => [$resId],
            ]);

            foreach ($notes as $note) {
                if (!in_array($note['id'], $notesInOpenGST)) {
                    $noteTypist = \User\models\UserModel::getById(['id' => $note['user_id']]);
                    $noteContent = "Note MEM de " .  $noteTypist['firstname'] . ' ' . $noteTypist['lastname'];
                    $noteContent .= " du " . $note['creation_date'];
                    $noteContent .= " : " . $note['note_text'];

                    $contributionId = self::openGSTQueryGeneric($args, [
                        "session" => $args['session'],
                        "route"   => '/web/dataset/create',
                        "model"   => "openstc.ask.contrib",
                        "data"    => [
                            "note"   => $noteContent,
                            "ask_id" => $reportId
                        ]
                    ], $configuration);

                    if (!$contributionId) {
                        self::writeLog($args['customId'], ['message' => "[ERROR] [UPDATE_SIGNALEMENT] Could not create contribution for note " . $note['id']]);
                        exit();
                    }
                    self::insertNotesInOpenGstContrib([
                        'source' => 'MEM',
                        'res_id' => $resId,
                        'note_id' => $note['id'],
                        'note_date' => $note['creation_date'],
                        'contrib_id' => $contributionId['result'],
                        'opengst_id' => $reportId
                    ]);
                    return $contributionId['result'];
                }
            }
            return false;
        }

        private static function insertNotesInOpenGstContrib($args) : void {
            \SrcCore\models\DatabaseModel::insert([
                'table'         => 'opengst_contributions',
                'columnsValues' => [
                    'contrib_creation_date' => 'NOW()',
                    'source'                => $args['source'],
                    'res_id'                => $args['res_id'],
                    'note_id'               => $args['note_id'],
                    'note_creation_date'    => $args['note_date'] ?? 'NOW()',
                    'opengst_id'            => $args['opengst_id'],
                    'contrib_id'            => $args['contrib_id']
                ]
            ]);
        }

        private static function getContactInfos($resId) {
            $contacts = \Contact\controllers\ContactController::getParsedContacts(['resId' => $resId, 'mode' => 'sender']);
            return $contacts[0];
        }

        private static function getMEMDocAndAttachments($resource): array {
            $documentsList = [];

            if (!empty($resource) and !empty($resource['filename'])) {
                $document = \Convert\controllers\ConvertPdfController::getConvertedPdfById(['resId' => $resource['res_id'], 'collId' => 'letterbox_coll']);
                $docserver = \Docserver\models\DocserverModel::getByDocserverId(['docserverId' => $resource['docserver_id'], 'select' => ['path_template', 'docserver_type_id']]);
                $pathToDocument = $docserver['path_template'] . str_replace('#', DIRECTORY_SEPARATOR, $resource['path']) . $resource['filename'];
                $fileContent = file_get_contents($pathToDocument);

                $documentsList[] = [
                    'title'             => _MAIN_DOCUMENT,
                    'res_id'            => $resource['res_id'],
                    'file_name'         => $document['filename'],
                    'encoded_document'  => base64_encode($fileContent)
                ];
            }

            $attachments = \Attachment\models\AttachmentModel::get([
                'select' => ['res_id', 'docserver_id', 'res_id_master', 'format', 'title', 'filename', 'signatory_user_serial_id', 'typist', 'attachment_type'],
                'where'  => ['res_id_master = ?', 'status not in (?)'],
                'data'   => [$resource['res_id'], ['DEL']],
                'limit'  => 20
            ]);

            if (empty($attachments[0])) {
                return $documentsList;
            }

            foreach ($attachments as $attachment) {
                $document = \Convert\controllers\ConvertPdfController::getConvertedPdfById(['resId' => $attachment['res_id'], 'collId' => 'attachments_coll']);
                $docserver = \Docserver\models\DocserverModel::getByDocserverId(['docserverId' => $document['docserver_id'], 'select' => ['path_template', 'docserver_type_id']]);
                $pathToDocument = $docserver['path_template'] . str_replace('#', DIRECTORY_SEPARATOR, $document['path']) . $document['filename'];
                $fileContent = file_get_contents($pathToDocument);

                $documentsList[] = [
                    'title'             => $attachment['title'],
                    'res_id'            => $attachment['res_id'],
                    'encoded_document'  => base64_encode($fileContent),
                    'file_name'         => "attachement_" . $attachment['res_id'] . ".pdf"
                ];
            }
            return $documentsList;
        }

        private static function sendEmail(array $args, array $emailParams, $configuration): void {
            $templates = \Template\models\TemplateModel::getWithAssociation([
                'select'    => ['DISTINCT(templates.template_id)', 'templates.template_content'],
                'where'     => ['templates.template_type = ?', 'templates.template_target = ?', 'templates.template_id = ?'],
                'data'      => ['HTML', 'sendmail', $emailParams['emailModelId']],
                'orderBy'   => ['templates.template_id']
            ]);

            if (empty($templates[0])) {
                self::writeLog($args['customId'], ['message' => "[ERROR] [SEND_EMAIL] Template " . $emailParams['emailModelId'] . " does not exist"]);
                exit();
            }

            $template = $templates[0];

            if (empty($template['template_content'])) {
                self::writeLog($args['customId'], ['message' => "[ERROR] [SEND_EMAIL] Template has no content"]);
                return;
            }

            $mergedDocument = \ContentManagement\controllers\MergeController::mergeDocument([
                'content' => $template['template_content'],
                'data' => [
                    'userId' => $GLOBALS['id'],
                    'data' => [
                        'resId' => $emailParams['resId']
                    ]
                ]
            ]);

            $fileContent = base64_decode($mergedDocument['encodedDocument']);
            foreach ($emailParams['publipostage'] as $key => $value) {
                if (gettype($value) == 'array') {
                    $value = json_encode($value);
                }
                $fileContent = str_replace($key, $value, $fileContent);
            }
            $fileContent = str_replace(["&lt;", "&gt;"], ["<", ">"], htmlentities($fileContent, ENT_NOQUOTES, 'UTF-8', FALSE));

            $dom = new DOMDocument();
            $dom -> loadHTML($fileContent);

            $output = $dom->saveHTML();
            $output = '<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />' . $output;

            $body = [
                "cc" => [],
                "cci" => [],
                "options" => [],
                "isHtml" => true,
                "body" => $output,
                "object" => $emailParams['object'],
                "status" => $emailParams['status'],
                "recipients" => [$emailParams['email']],
                "sender" => [
                    "email" => $configuration['MEM']['senderEmail'],
                    "entityId" => null
                ],
                "document" => [
                    "id" => $emailParams['resId'],
                    "isLinked" => false,
                    "original" => false
                ]
            ];

            $response = \SrcCore\models\CurlModel::exec([
                'url'       => $configuration['MEM']['url'] . 'emails',
                'method'    => 'POST',
                'basicAuth' => [
                    'user'      => $configuration['MEM']['username'],
                    'password'  => $configuration['MEM']['password']
                ],
                'headers'   => ['content-type:application/json'],
                'body'      => json_encode($body),
                'noLogs'    => true
            ]);

            if ($response['code'] <> 200) {
                self::writeLog($args['customId'], ['message' => "[ERROR] [SEND_EMAIL] Could not send email : " . $response['response']['errors']]);
                exit();
            }
        }

        private static function updateCustom(array $args)
        {
            \Resource\models\ResModel::update([
                'set'   => ['custom_fields' => json_encode($args['custom_fields'])],
                'where' => ['res_id = ?'],
                'data'  => [$args['res_id']]
            ]);
        }

        public static function writeLog($customId, array $args): void {
            if ($customId) {
                $file = fopen("custom/{$customId}/bin/external/opengst/OpenGSTScript.log", 'a');
            } else {
                $file = fopen('bin/external/opengst/OpenGSTScript.log', 'a');
            }
            fwrite($file, '[' . date('Y-m-d H:i:s') . '] ' . $args['message'] . PHP_EOL);
            fclose($file);

            if (str_starts_with($args['message'], '[ERROR]')) {
                \SrcCore\controllers\LogsController::add([
                    'isTech'    => true,
                    'moduleId'  => 'OpenGST',
                    'level'     => 'ERROR',
                    'tableName' => '',
                    'recordId'  => 'OpenGST',
                    'eventType' => 'OpenGST',
                    'eventId'   => $args['message']
                ]);
            } else {
                \SrcCore\controllers\LogsController::add([
                    'isTech'    => true,
                    'moduleId'  => 'OpenGST',
                    'level'     => 'INFO',
                    'tableName' => '',
                    'recordId'  => 'OpenGST',
                    'eventType' => 'OpenGST',
                    'eventId'   => $args['message']
                ]);
            }

            \History\models\BatchHistoryModel::create(['info' => $args['message'], 'module_name' => 'OpenGST']);
        }

        public static function getJsonLoaded(array $args) {
            if (!empty($args['customId']) && is_file("custom/{$args['customId']}/{$args['path']}")) {
                $path = "custom/{$args['customId']}/{$args['path']}";
            } else {
                $path = $args['path'];
            }

            $file = null;
            if (file_exists($path)) {
                $file = file_get_contents($path);
                $file = json_decode($file, true);
            }

            return $file;
        }

        public static function setGlobalId(array $configuration, $customId): void {
            $userInfo = \User\models\UserModel::getByLogin(['login' => $configuration['MEM']['username'], 'select' => ['id']]);
            if (!empty($userInfo)) {
                $GLOBALS['id'] = $userInfo['id'];
            } else {
                self::writeLog($customId, ['message' => "[ERROR] [SET_GLOBAL_ID] Could not find user with login " . $configuration['MEM']['username']]);
                exit();
            }
        }

        // EDISSYUM - LBE01 -  Amélioration OpenGST partie "retrieve"
        public static function createMEMContactFromOpenGST($args, $contactInfos, $configuration) {
            $contactDatas = [
                'email'             => !empty($contactInfos['email']) ? $contactInfos['email'] : '',
                'function'          => !empty($contactInfos['function']) ? $contactInfos['function'] : '',
                'lastname'          => !empty($contactInfos['name']) ? $contactInfos['name'] : '',
                'phone'             => !empty($contactInfos['phone']) ? $contactInfos['phone'] : '',
                'addressStreet'     => !empty($contactInfos['street']) ? $contactInfos['street'] : '',
                'addressAdditional1'=> !empty($contactInfos['street2']) ? $contactInfos['street2'] : '',
//                'user_id' => $contactInfos['user_id'][0] ?? null,
                'addressPostcode'   => !empty($contactInfos['zip']) ? $contactInfos['zip'] : '',
                'addressTown'       => !empty($contactInfos['city']) ? $contactInfos['city'] : '',
            ];

            $response = \SrcCore\models\CurlModel::exec([
                'url'       => $configuration['MEM']['url'] . 'contacts',
                'method'    => 'POST',
                'basicAuth' => [
                    'user'      => $configuration['MEM']['username'],
                    'password'  => $configuration['MEM']['password']
                ],
                'headers'   => ['content-type:application/json'],
                'body'      => json_encode($contactDatas),
                'noLogs'    => true
            ]);

            if ($response['code'] != 200) {
                self::writeLog($args['customId'], ['message' => "[ERROR] [CREATE_MEM_CONTACT] Could not create contact in MEM : " . $response['response']['context']['message']]);
                return false;
            }

            $contactId = $response['response']['id'];
            if (!$contactId) {
                self::writeLog($args['customId'], ['message' => "[ERROR] [CREATE_MEM_CONTACT] Could not create contact in MEM"]);
                return false;
            }
            self::writeLog($args['customId'], ['message' => "[INFO] [CREATE_MEM_CONTACT] Contact created in MEM with id " . $contactId]);
            return $contactId;
        }

        public static function createMEMResourceFromOpenGST($args, $inter, $contact, $configuration) {

            $destination = $configuration['MEM']['destination'];
            if ( isset($inter['service_id']) && is_string($inter['service_id'][1]) ) {
                $destination_code = trim(explode('-',$inter['service_id'][1])[0]);

                $entity_ids = \SrcCore\models\DatabaseModel::select([
                    'select' => ['id'],
                    'table'  => ['entities'],
                    'where'  => ['entity_id = ?'],
                    'data'   => [$destination_code]
                ]);
                if (!empty($entity_ids)) {
                    $destination = $entity_ids[0]['id'];
                } else {
                    $destination = $configuration['MEM']['destination'];
                }
            }


            $resourceInfos = [
                'chrono'        => True,
                'senders'       => $contact,
                'subject'       => $inter['name'] ?? '',
                'typist'        => $configuration['MEM']['typist'],
                'status'        => $configuration['MEM']['status'],
                'doctype'       => $configuration['MEM']['doctype'],
                'modelId'       => $configuration['MEM']['modelId'],
                'priority'      => $configuration['MEM']['priority'],
                'documentDate'  => $inter['create_date'],
                'arrivalDate'   => date('Y-m-d H:i:s'),
                'destination'   => $destination,
                'externalId'    => [$configuration['MEM']['externalId'] => ['demande_intervention' => $inter['id']]],
                'customFields'  => []
            ];

            if ($configuration['customFields']) {
                if ($configuration['customFields']['site']) {
                    $resourceInfos['customFields'][$configuration['customFields']['site']] = $inter['site1'][1] ?? '';
                }

                if ($configuration['customFields']['intervention_id']) {
                    $resourceInfos['customFields'][$configuration['customFields']['intervention_id']] = $inter['id'] ?? '';
                }

                if ($configuration['customFields']['description']) {
                    $resourceInfos['customFields'][$configuration['customFields']['description']] = $inter['description'] ?? '';
                }
            }

            $response = \SrcCore\models\CurlModel::exec([
                'url'       => $configuration['MEM']['url'] . 'resources',
                'method'    => 'POST',
                'basicAuth' => [
                    'user'      => $configuration['MEM']['username'],
                    'password'  => $configuration['MEM']['password']
                ],
                'headers'   => ['content-type:application/json'],
                'body'      => json_encode($resourceInfos),
                'noLogs'    => true
            ]);

            if ($response['code'] != 200) {
                self::writeLog($args['customId'], ['message' => "[ERROR] [CREATE_MEM_RESOURCE] Could not create contact in MEM : " . $response['response']['errors']]);
                exit();
            }

            $resId = $response['response']['resId'];
            if (!$resId) {
                self::writeLog($args['customId'], ['message' => "[ERROR] [CREATE_MEM_RESOURCE] Could not create resource in MEM"]);
                return false;
            }
            self::writeLog($args['customId'], ['message' => "[INFO] [CREATE_MEM_RESOURCE] Resource created in MEM with resId " . $resId]);
            return $resId;
        }

        public static function createMEMAttachmentFromOpenGST($args, $attachment, $resId, $configuration) {
            $attachmentInfos = [
                'resIdMaster' => $resId,
                'type'        => 'simple_attachment',
                'title'       => $attachment['datas_fname'],
                'encodedFile' => $attachment['datas'],
                'format'      => pathinfo($attachment['datas_fname'], PATHINFO_EXTENSION),
            ];

            $response = \SrcCore\models\CurlModel::exec([
                'url'       => $configuration['MEM']['url'] . 'attachments',
                'method'    => 'POST',
                'basicAuth' => [
                    'user'      => $configuration['MEM']['username'],
                    'password'  => $configuration['MEM']['password']
                ],
                'headers'   => ['content-type:application/json'],
                'body'      => json_encode($attachmentInfos),
                'noLogs'    => true
            ]);

            if ($response['code'] != 200) {
                self::writeLog($args['customId'], ['message' => "[ERROR] [CREATE_MEM_ATTACHMENT] Could not create attachment in MEM : " . $response['response']['errors']]);
            }
            $resId = $response['response']['id'] ?? false;
            if (!$resId) {
                self::writeLog($args['customId'], ['message' => "[ERROR] [CREATE_MEM_ATTACHMENT] Could not attachment contact in MEM"]);
                return false;
            }
            self::writeLog($args['customId'], ['message' => "[INFO] [CREATE_MEM_ATTACHMENT] Attachment created in MEM with resId " . $resId]);
            return true;
        }

        public static function closeMEMResourceFromOpenGST($interventionId, $configuration) {

            \SrcCore\models\DatabaseModel::update([
                'table'     => 'res_letterbox',
                'set'       => [
                    'status'   => $configuration['MEM']['closed_status'],
                ],

                'where' => [
                    "external_id #>> '{{$configuration['MEM']['externalId']}, demande_intervention}' = ?",
                ],
                'data' => [
                    $interventionId
                ]
            ]);

            return true;
        }

        // END EDISSYUM - LBE01
    }
?>
