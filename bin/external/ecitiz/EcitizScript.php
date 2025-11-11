<?php

chdir('../../../');
require 'vendor/autoload.php';

$functionCorrespondances = [
    'get_demandes' => 'retrieveDemandes',
    'update_demandes' => 'updateDemandes',
];

if (!empty($argv[3]) && $argv[3] == '--action' && !empty($argv[4])) {
    $action = $argv[4];
    foreach ($functionCorrespondances as $functionName => $function) {
        if ($action == $functionName) {
            EcitizScript::$function($argv);
        }
    }
}

class EcitizScript {
    static function retrieveDemandes(array $args): void {
        if (!empty($args[1]) && $args[1] == '--customId' && !empty($args[2])) {
            $customId = $args[2];
        } else {
            self::writeLog('', ['message' => "[ERROR] [RETRIEVE_DEMANDE] --customId is missing"]);
            exit();
        }

        $configuration = EcitizScript::getXmlLoaded(['path' => 'bin/external/ecitiz/config.xml', 'customId' => $customId]);
        if (empty($configuration)) {
            self::writeLog($customId, ['message' => "[ERROR] [RETRIEVE_DEMANDE] File bin/external/ecitiz/config.xml does not exist"]);
            exit();
        } elseif (empty($configuration -> SETTINGS -> apiKey) || empty($configuration -> SETTINGS -> apiUrl) || empty($configuration -> SETTINGS -> etatDemande) || empty($configuration -> SETTINGS -> minDepotInMinutes) || empty($configuration -> SETTINGS  -> getDemandeApi)) {
            self::writeLog($customId, ['message' => "[ERROR] [RETRIEVE_DEMANDE] File bin/external/ecitiz/config.xml is not filled enough"]);
            exit();
        }

        \SrcCore\models\DatabasePDO::reset();
        new \SrcCore\models\DatabasePDO(['customId' => $customId]);

        // Récupération des paramètres de configuration
        $blueway = $configuration -> EXTRA -> blueWay;

        $apiKey = (string) $configuration -> SETTINGS -> apiKey;
        $apiUrl = (string) $configuration -> SETTINGS -> apiUrl;
        $etatDemande = (string) $configuration -> SETTINGS -> etatDemande;
        $getDemandeApi = (string) $configuration -> SETTINGS -> getDemandeApi;
        $GLOBALS['id'] = (string) $configuration -> SETTINGS -> memSuperUserId;
        $externalIdValue = (string) $configuration -> SETTINGS -> externalIdValue;
        $minDepotInMinutes = (string) $configuration -> SETTINGS ->  minDepotInMinutes;
        $getDemandePiecesApi = (string) $configuration -> SETTINGS -> getDemandePiecesApi;

        // Récupération des données de paramétrage MEM
        $status = (string) $configuration -> MEM_DATA -> status;
        $modelId = (string) $configuration -> MEM_DATA -> model_id;
        $priority = (string) $configuration -> MEM_DATA -> priority;
        $themeCustomId = (int) $configuration -> MEM_DATA -> theme_custom_id;
        $natureCorres = $configuration -> MEM_DATA -> nature_correspondances;
        $typeIdCorres = $configuration -> MEM_DATA -> type_id_correspondances;
        $natureCustomId = (int) $configuration -> MEM_DATA -> nature_custom_id;
        $titreCustomId = (string) $configuration -> MEM_DATA -> titre_custom_id;
        $pjInstruType = (string) $configuration -> MEM_DATA -> pj_instructions_type;
        $pjJustifType = (string) $configuration -> MEM_DATA -> pj_justificative_type;
        $sousThemeCustomId = (int) $configuration -> MEM_DATA -> sous_theme_custom_id;
        $labelDomaineCustomId = (int) $configuration -> MEM_DATA -> domaine_custom_id;
        $default_initiator = (string) $configuration -> MEM_DATA -> default_initiator;
        $destinationCorres = $configuration -> MEM_DATA -> destination_correspondances;
        $default_destination = (string) $configuration -> MEM_DATA -> default_destination;
        $otherInfosCustomId = (string) $configuration -> MEM_DATA -> autres_infos_custom_id;
        $labelSousThemeCustomId = (int) $configuration -> MEM_DATA -> label_sous_theme_custom_id;
        $typeUsagerCustomId = (string) $configuration -> MEM_DATA -> type_usager_custom_id;

        // Récupération des données de paramétrage Contact
        $rnaCustomId = (string) $configuration -> CONTACT_DATA -> rna_custom_id;
        $siretCustomId = (string) $configuration -> CONTACT_DATA -> siret_custom_id;
        $civilityCorres = $configuration -> CONTACT_DATA -> civility_correspondances;
        $serviceCustomId = (int) $configuration -> CONTACT_DATA -> service_custom_id;
        $typeUsageCorres = $configuration -> CONTACT_DATA -> type_usager_correspondances;

        // Préparation des arguments pour la récupération des demandes
        $dateDepotMini = date('Y-m-d', strtotime("-{$minDepotInMinutes} minutes"));
        $heureDepotMini = date('H:i', strtotime("-{$minDepotInMinutes} minutes"));
        $pageSize = (int) $configuration -> SETTINGS -> pageSize;

        // Récupération des demandes
        if ($blueway == 'true')  {
            $getDemandeUrl = $apiUrl . $getDemandeApi;
            $getDemandeUrl .= '&etatDemande=' . $etatDemande;
        } else {
            $getDemandeUrl = $apiUrl . '/' . $getDemandeApi;
            $getDemandeUrl .= '?etatDemande=' . $etatDemande;
        }
        $getDemandeUrl .= '&dateDepotMini=' . $dateDepotMini;
        $getDemandeUrl .= '&heureDepotMini=' . $heureDepotMini;
        $getDemandeUrl .= '&pageSize=' . $pageSize;
        $getDemandeUrl .= '&scope=data_administratives,data_demandeur,data_commentaires';

        $response = \SrcCore\models\CurlModel::exec([
            'url'       => $getDemandeUrl,
            'method'    => 'GET',
            'headers'   => ["apiKey: {$apiKey}"],
            'noLogs'    => 'true'
        ]);

        if ($response['code'] == 403 || $response['code'] == 500 || $response['code'] == 400 || isset($response['response']['libErreur'])) {
            self::writeLog($customId, ['message' => "[ERROR] [RETRIEVE_DEMANDES] Return code is {$response['code']} and error message is : {$response['response']['libErreur']}"]);
            exit();
        }

        if (!empty($response['errors'])) {
            self::writeLog($customId, ['message' => "[ERROR] [RETRIEVE_DEMANDES] {$response['errors']}"]);
            exit();
        }

        if (!empty($response['response'])) {
            if ($response['response']['success'] && $response['response']['data']) {
                if ($response['response']['data']['pagination'] && $response['response']['data']['pagination']['totalCount'] >= 1) {
                    $demandes = $response['response']['data']['results'];
                    foreach ($demandes as $demande) {
                        $numDossier = $demande['numDossier'];
                        $eCitizStatus = $demande['data_administratives']['canalEntree'];
                        $typeUsager = null;
                        $MEMTypeId = null;
                        $civility = null;
                        $nature = null;

                        // Récupération du document principal
                        if ($blueway == 'true')  {
                            $getPrincipalDocument = $apiUrl . $getDemandePiecesApi;
                            $getPrincipalDocument .= '&numDossier=' . $numDossier;
                        } else {
                            $getPrincipalDocument = $apiUrl . '/' . $getDemandePiecesApi;
                            $getPrincipalDocument .= '?numDossier=' . $numDossier;
                        }
                        $getPrincipalDocument .= '&scope=pdf_recapitulatif';
                        $response = \SrcCore\models\CurlModel::exec([
                            'url'       => $getPrincipalDocument,
                            'method'    => 'GET',
                            'headers'   => ["apiKey: {$apiKey}"],
                            'noLogs'    => 'true'
                        ]);

                        if (!empty($response['response'])) {
                            if ($response['response']['success'] && $response['response']['data']) {
                                if ($response['response']['data']['pagination'] && $response['response']['data']['pagination']['totalCount'] >= 1) {
                                    $result = $response['response']['data']['results'];
                                    $filename = $result[0]['pdf_recapitulatif']['nomFichier'];
                                    $file = $result[0]['pdf_recapitulatif']['contenuFichier'];
                                    $format = pathinfo($filename, PATHINFO_EXTENSION);
                                } else {
                                    self::writeLog($customId, ['message' => "[ERROR] [RETRIEVE_DEMANDES] Erreur lors de la récupération du PDF récapitulatif : " . print_r($response['response'], true)]);
                                    exit();
                                }
                            } else {
                                self::writeLog($customId, ['message' => "[ERROR] [RETRIEVE_DEMANDES] Erreur lors de la récupération du PDF récapitulatif : " . print_r($response['response'], true)]);
                                exit();
                            }
                        } else {
                            self::writeLog($customId, ['message' => "[ERROR] [RETRIEVE_DEMANDES] Erreur lors de la récupération du PDF récapitulatif : " . print_r($response['response'], true)]);
                            exit();
                        }

                        $resource = \Resource\models\ResModel::get(['select' => ['res_id'], 'where' => ['external_id #>> \'{' . $externalIdValue . '}\' = ?'], 'data' => [$numDossier]]);
                        if ($resource) {
                            self::writeLog($customId, ['message' => "[ERROR] [RETRIEVE_DEMANDES] Dossier {$numDossier} déjà intégré dans MEM Courrier"]);
                            continue;
                        }

                        // Construction des informations du contact
                        foreach ($civilityCorres -> children() as $civ) {
                            if (strtoupper($civ -> ECITIZ) == strtoupper($demande['data_demandeur']['civilite'])) {
                                $civility = (string) $civ -> MEM;
                            }
                        }

                        foreach ($typeUsageCorres -> children() as $typUsa) {
                            if (strtoupper($typUsa -> ECITIZ) == strtoupper($demande['data_demandeur']['typeUsager'])) {
                                $typeUsager = (string) $typUsa -> MEM;
                            }
                        }

                        if ($civility == null) {
                            self::writeLog($customId, ['message' => "[ERROR] [RETRIEVE_DEMANDES] La civilité ECITIZ ({$demande['data_demandeur']['civilite']}) ne corresponds à aucune entrées dans le table de correspondance"]);
                            continue;
                        }

                        $phone = '';
                        if ($demande['data_demandeur']['contact']['telephone1']) {
                            $phone = $demande['data_demandeur']['contact']['telephone1'];
                        } else if ($demande['data_demandeur']['contact']['telephone2']) {
                            $phone = $demande['data_demandeur']['contact']['telephone2'];
                        } else if ($demande['data_demandeur']['contact']['telephone3']) {
                            $phone = $demande['data_demandeur']['contact']['telephone3'];
                        }

                        // Création ou récupération du contact
                        if (empty($demande['data_demandeur']['contact']['courriel'])) {
                            $lastname = $demande['data_demandeur']['nom'];
                            $firstname = $demande['data_demandeur']['prenoms'];
                            $email = $numDossier . '-' . $lastname . '_' . $firstname . '@ecitizSansMail.fr';
                        } else {
                            $email = $demande['data_demandeur']['contact']['courriel'];
                        }

                        $contact = \Contact\models\ContactModel::getByMail([
                            'select'    => ['id'],
                            'mail'      => $email,
                        ]);

                        if (empty($contact)) {
                            $contactData = [
                                'phone' => $phone,
                                'email' => $email,
                                'civility' => $civility,
                                'lastname' => $demande['data_demandeur']['nom'],
                                'function' => $demande['data_demandeur']['function'],
                                'firstname' => $demande['data_demandeur']['prenoms'],
                                'company' => $demande['data_demandeur']['raisonSociale'],
                                'address_street' => $demande['data_demandeur']['adresse']['voie'],
                                'address_country' => $demande['data_demandeur']['adresse']['pays'],
                                'address_town' => $demande['data_demandeur']['adresse']['commune'],
                                'address_number' => $demande['data_demandeur']['adresse']['numero'],
                                'address_postcode' => $demande['data_demandeur']['adresse']['codePostal'],
                                'address_additional2' => $demande['data_demandeur']['adresse']['lieuDit'],
                                'address_additional1' => $demande['data_demandeur']['adresse']['batiment'] . ' ' . $demande['data_demandeur']['adresse']['complements'],
                                'custom_fields' => json_encode([
                                    $rnaCustomId => $demande['data_demandeur']['rna'],
                                    $titreCustomId => $demande['data_demandeur']['titre'],
                                    $siretCustomId => $demande['data_demandeur']['siret'],
                                    $serviceCustomId => $demande['data_demandeur']['service']
                                ]),
                                'creator' => 1
                            ];
                            $contactId = \Contact\models\ContactModel::create($contactData);
                        } else {
                            $contactId = $contact['id'];
                        }

                        // Récupération de la destination et du service initiateur
                        $initiator = $default_initiator;
                        $destination = $default_destination;
                        foreach ($destinationCorres -> children() as $dest) {
                            if (strtoupper($dest -> ECITIZ) == $demande['data_administratives']['codeSousTheme']) {
                                $destination = (string) $dest -> MEM_DESTINATION;
                                $initiator = (string) $dest -> MEM_INITIATOR;
                            }
                        }

                        // Récupération du type de document
                        foreach ($typeIdCorres -> children() as $type_id) {
                            if ($type_id -> ECITIZ == $eCitizStatus) {
                                $MEMTypeId = (string) $type_id -> MEM;
                            }
                        }

                        if ($MEMTypeId == null) {
                            self::writeLog($customId, ['message' => "[ERROR] [RETRIEVE_DEMANDES] Le canal d'entrée ECITIZ ({$eCitizStatus}) ne corresponds à aucune entrées dans le table de correspondance des types de demandes"]);
                            continue;
                        }

                        foreach ($natureCorres -> children() as $nat) {
                            if (strtoupper($nat -> ECITIZ) == strtoupper($demande['data_administratives']['libelleTypeDemande'])) {
                                $nature = (string) $nat -> MEM;
                            }
                        }

                        $data = [
                            'chrono' => true,
                            'format' => $format,
                            'status' => $status,
                            'modelId' => $modelId,
                            'encodedFile' => $file,
                            'priority' => $priority,
                            'doctype' => $MEMTypeId,
                            'initiator' => $initiator,
                            'destination' => $destination,
                            'senders' => [[
                                'id' => $contactId,
                                'type' => 'contact'
                            ]],
                            'externalId' => [
                                $externalIdValue => $numDossier
                            ],
                            'documentDate' => $demande['data_administratives']['dateCreation'],
                            'subject' => 'Demande n°' . $numDossier . ' du ' . $demande['data_administratives']['dateCreation'],
                            'customFields' => [
                                $natureCustomId => $nature,
                                $typeUsagerCustomId => $typeUsager,
                                $themeCustomId => $demande['data_administratives']['libelleTheme'],
                                $sousThemeCustomId => $demande['data_administratives']['codeSousTheme'],
                                $labelDomaineCustomId => $demande['data_administratives']['libelleDomaine'],
                                $labelSousThemeCustomId => $demande['data_administratives']['libelleSousTheme']
                            ]
                        ];

                        if (isset($demande['data_administratives']['autreInfosRelativeDemande'])) {
                            $data['customFields'][$otherInfosCustomId] = $demande['data_administratives']['autreInfosRelativeDemande'];
                        }

                        $res = (new Resource\controllers\ResController) -> createWithoutRequest($data, $customId);
                        if (!$res['resId']) {
                            self::writeLog($customId, ['message' => "[ERROR] [RETRIEVE_DEMANDES] Erreur lors de la création de la ressource : " . print_r($res, true)]);
                            exit();
                        }
                        $resId = $res['resId'];
                        self::writeLog($customId, ['message' => "[INFO] [RETRIEVE_DEMANDES] Ressource {$numDossier} créée avec succès : resId --> {$resId}"]);

                        // Création des pièce jointe
                        if ($blueway == 'true')  {
                            $getAttachments = $apiUrl . $getDemandePiecesApi;
                            $getAttachments .= '&numDossier=' . $numDossier;
                        } else {
                            $getAttachments = $apiUrl . '/' . $getDemandePiecesApi;
                            $getAttachments .= '?numDossier=' . $numDossier;
                        }
                        $getAttachments .= '&scope=pieces_justificatives,pieces_instruction';
                        $response = \SrcCore\models\CurlModel::exec([
                            'url'       => $getAttachments,
                            'method'    => 'GET',
                            'headers'   => ["apiKey: {$apiKey}"],
                            'noLogs'    => 'true'
                        ]);

                        if (!empty($response['response'])) {
                            if ($response['response']['success'] && $response['response']['data']) {
                                if ($response['response']['data']['pagination'] && $response['response']['data']['pagination']['totalCount'] >= 1) {
                                    $result = $response['response']['data']['results'];
                                    $pjTypes = ['pieces_justificatives', 'pieces_instruction'];
                                    foreach ($result as $res) {
                                        foreach ($pjTypes as $pjType) {
                                            foreach ($res[$pjType] as $pj) {
                                                if (isset($pj['contenuFichier'])) {
                                                    $idPiece = $pj['idPiece'];
                                                    $filename = $pj['nomFichier'];
                                                    $file = $pj['contenuFichier'];
                                                    $format = pathinfo($filename, PATHINFO_EXTENSION);

                                                    $data = [
                                                        'status' => 'A_TRA',
                                                        'format' => $format,
                                                        'title' => $filename,
                                                        'encodedFile' => $file,
                                                        'resIdMaster' => $resId,
                                                        'externalId' => [
                                                            $externalIdValue => $idPiece
                                                        ],
                                                        'type' => $pjType == 'pieces_justificatives' ? $pjJustifType : $pjInstruType,
                                                    ];
                                                    $res = (new \Attachment\controllers\AttachmentController()) -> createWithoutRequest($data, $customId);
                                                    if (!$res['id']) {
                                                        self::writeLog($customId, ['message' => "[ERROR] [RETRIEVE_DEMANDES] Erreur lors de la création de la pièce jointe : " . print_r($res, true)]);
                                                    }
                                                    self::writeLog($customId, ['message' => "[INFO] [RETRIEVE_DEMANDES] Pièce jointe {$idPiece} créée avec succès : resId --> {$res['id']}"]);
                                                }
                                            }
                                        }
                                    }
                                }
                            } else {
                                self::writeLog($customId, ['message' => "[ERROR] [RETRIEVE_DEMANDES] Erreur lors de la récupération du PDF récapitulatif : " . print_r($response['response'], true)]);
                                exit();
                            }
                        } else {
                            self::writeLog($customId, ['message' => "[ERROR] [RETRIEVE_DEMANDES] Erreur lors de la récupération du PDF récapitulatif : " . print_r($response['response'], true)]);
                            exit();
                        }
                    }
                } else {
                    self::writeLog($customId, ['message' => "[INFO] [RETRIEVE_DEMANDES] Aucune demande n'est à traiter"]);
                    exit();
                }
            } else {
                self::writeLog($customId, ['message' => "[ERROR] [RETRIEVE_DEMANDES] Erreur lors de la récupération des demandes : " . print_r($response['response'], true)]);
                exit();
            }
        } else {
            self::writeLog($customId, ['message' => "[INFO] [RETRIEVE_DEMANDES] Aucun contenu renvoyé par l'application e-Citiz"]);
            exit();
        }
    }

    static function updateDemandes(array $args): void {
        if (!empty($args[1]) && $args[1] == '--customId' && !empty($args[2])) {
            $customId = $args[2];
        } else {
            self::writeLog('', ['message' => "[ERROR] [UPDATE_DEMANDE] --customId is missing"]);
            exit();
        }

        $configuration = EcitizScript::getXmlLoaded(['path' => 'bin/external/ecitiz/config.xml', 'customId' => $customId]);
        if (empty($configuration)) {
            self::writeLog($customId, ['message' => "[ERROR] [UPDATE_DEMANDE] File bin/external/ecitiz/config.xml does not exist"]);
            exit();
        } elseif (empty($configuration -> SETTINGS -> apiKey) || empty($configuration -> SETTINGS -> apiUrl)) {
            self::writeLog($customId, ['message' => "[ERROR] [UPDATE_DEMANDE] File bin/external/ecitiz/config.xml is not filled enough"]);
            exit();
        }

        // Récupération des paramètres de configuration
        $blueway = $configuration -> EXTRA -> blueWay;
        $eCitizStatus = '';
        $sendEmail = 0;
        $sendNotes = 0;
        $sendLastSignedAttachment = 0;

        $statusExist = false;
        $statusAvailable = $configuration -> STATUS;
        $apiKey = (string) $configuration -> SETTINGS -> apiKey;
        $apiUrl = (string) $configuration -> SETTINGS -> apiUrl;
        $sendEmailApi = (string) $configuration -> SETTINGS -> sendEmailApi;
        $sendNotesApi = (string) $configuration -> SETTINGS -> sendNotesApi;
        $updateStatusApi = (string) $configuration -> SETTINGS -> updateStatusApi;
        $externalIdValue = (string) $configuration -> SETTINGS -> externalIdValue;
        $pjNonEngageante = (string) $configuration -> MEM_DATA -> pj_response_non_engageante;

        $listStatus = [];

        \SrcCore\models\DatabasePDO::reset();
        new \SrcCore\models\DatabasePDO(['customId' => $customId]);

        foreach ($statusAvailable -> children() as $stat) {
            $listStatus[] = (string) $stat -> MEM;
        }

        $resources = \Resource\models\ResModel::get([
            'select' => ["res_id", "status", "external_id ->> '{$externalIdValue}' as external_id"],
            'where' => ['status in (?)', "external_id ->> '{$externalIdValue}' is not NULL"],
            'data' => [$listStatus]
        ]);

        if (!$resources || count($resources) == 0) {
            exit();
        }

        foreach ($resources as $resource) {
            $resId = $resource['res_id'];
            $status = $resource['status'];
            $numDossier = $resource['external_id'];

            // Vérification que le status est disponible
            foreach ($statusAvailable -> children() as $stat) {
                if ($stat -> MEM == $status) {
                    $statusExist = true;
                    $sendEmail = (int) $stat -> SENDMAIL;
                    $sendNotes = (int) $stat -> SENDNOTES;
                    $eCitizStatus = (string) $stat -> ECITIZ;
                    $MEMStatusTmp = (string) $stat -> MEM_TMP;
                    $sendLastSignedAttachment = (int) $stat -> SENDLASTSIGNEDATTACH;
                }
            }

            if (!$statusExist) {
                self::writeLog($customId, ['message' => "[ERROR] [UPDATE_DEMANDE] Status {$status} is not available"]);
                continue;
            }

            self::writeLog($customId, ['message' => "[INFO] [UPDATE_DEMANDE] Mise à jour de la demande {$numDossier} vers le status {$eCitizStatus}. Resource {$resId}"]);

            // Mise à jour du status dans e-Citiz
            if ($blueway == 'true') {
                $updateStatApi = $apiUrl . $updateStatusApi;
                $updateStatApi .= '&numDossier=' . $numDossier;
            } else {
                $updateStatApi = $apiUrl . '/' . $updateStatusApi;
                $updateStatApi .= '?numDossier=' . $numDossier;
            }

            $response = \SrcCore\models\CurlModel::exec([
                'url' => $updateStatApi,
                'method' => $blueway == 'true' ? 'POST' : 'PATCH',
                'headers' => array("apiKey: {$apiKey}", "Content-Type: application/json"),
                'body' => '{"etatDemande": "' . $eCitizStatus . '"}',
                'noLogs' => 'true'
            ]);

            // Mise à jour du status dans MEM
            if (isset($MEMStatusTmp)) {
                \SrcCore\models\DatabaseModel::update([
                    'table' => 'res_letterbox',
                    'set' => [
                        'status' => $MEMStatusTmp
                    ],
                    'where' => ['res_id = ?'],
                    'data' => [$resId]
                ]);
            }

            if ($response['code'] == 403 || $response['code'] == 500 || $response['code'] == 400 || isset($response['response']['libErreur'])) {
                self::writeLog($customId, ['message' => "[ERROR] [UPDATE_DEMANDE] Return code is {$response['code']} and error message is : {$response['response']['libErreur']}"]);
                continue;
            }

            if (!empty($response['errors'])) {
                self::writeLog($customId, ['message' => "[ERROR] [UPDATE_DEMANDE] {$response['errors']}"]);
                continue;
            }

            if ($sendEmail) {
                $emails = \Email\models\EmailModel::get([
                    'select' => ['id', 'document', 'object', 'recipients', 'body', 'cc', 'cci', 'document'],
                    'where' => ["status != 'DRAFT'", "document->>'id' = ?::varchar", "document->>'ecitiz_send' is null"],
                    'data' => [$resId]
                ]);

                if ($blueway == 'true') {
                    $sendEmApi = $apiUrl . $sendEmailApi;
                } else {
                    $sendEmApi = $apiUrl . '/' . $sendEmailApi;
                }
                foreach ($emails as $email) {
                    if (!empty($email['recipients'])) {
                        $email['recipients'] = json_decode($email['recipients']);
                        $recipient = $email['recipients'][0];
                    } else {
                        $recipient = [];
                    }

                    $response = \SrcCore\models\CurlModel::exec([
                        'url' => $sendEmApi,
                        'method' => 'POST',
                        'headers' => array("apiKey: {$apiKey}", "Content-Type: application/json"),
                        'body' => json_encode([
                            'numDossier' => $numDossier,
                            'cc' => $email['cc'],
                            'bcc' => $email['cci'],
                            'corps' => $email['body'],
                            'sujet' => $email['object'],
                            'to' => $recipient
                        ]),
                        'noLogs' => 'true'
                    ]);

                    if ($response['code'] == 403 || $response['code'] == 500 || $response['code'] == 400 || isset($response['response']['libErreur'])) {
                        self::writeLog($customId, ['message' => "[ERROR] [ADD_EMAIL] Return code is {$response['code']} and error message is : {$response['response']['libErreur']}"]);
                        continue;
                    }

                    if (!empty($response['errors'])) {
                        self::writeLog($customId, ['message' => "[ERROR] [ADD_EMAIL] {$response['errors']}"]);
                        continue;
                    }

                    $document = (array) json_decode($email['document']);
                    $document['ecitiz_send'] = true;
                    \Email\models\EmailModel::update([
                        'set' => [
                            'document' => json_encode($document)
                        ],
                        'where' => ['id = ?'],
                        'data' => [$email['id']]
                    ]);
                }
            }

            if ($sendNotes) {
                if ($blueway == 'true') {
                    $sendNotApi = $apiUrl . $sendNotesApi;
                } else {
                    $sendNotApi = $apiUrl . '/' . $sendNotesApi;
                }

                $listNotes = \SrcCore\models\DatabaseModel::select([
                    'select'    => ['note_id'],
                    'table'     => ['ecitiz_notes'],
                    'where'     => ['res_id = ?'],
                    'data'      => [$resId]
                ]);

                $notesId = [0];
                if ($listNotes) {
                    $notesId = array_column($listNotes, 'note_id');
                }

                $lastNote = \SrcCore\models\DatabaseModel::select([
                    'select'    => ['notes.id', 'firstname', 'lastname', 'notes.creation_date', 'note_text'],
                    'table'     => ['notes', 'users'],
                    'left_join' => ['users.id = notes.user_id'],
                    'where'     => ['identifier = ?', 'notes.id NOT IN (?)'],
                    'data'      => [$resId, $notesId],
                    'order_by'  => ['notes.id DESC'],
                    'limit'     => 1
                ]);

                $notePj = [];
                $attachmentsIds = [];
                if ($sendLastSignedAttachment) {
                    $listAttachments = \SrcCore\models\DatabaseModel::select([
                        'select'    => ['attachment_id'],
                        'table'     => ['ecitiz_attachments'],
                        'where'     => ['res_id = ?'],
                        'data'      => [$resId]
                    ]);

                    $attachmentsIds = [0];
                    if ($listAttachments) {
                        $attachmentsIds = array_column($listAttachments, 'attachment_id');
                    }

                    $attachments = \SrcCore\models\DatabaseModel::select([
                        'select'    => ['res_id', 'title', 'format', "CONCAT(path_template, '/', path, '/', filename) as path"],
                        'table'     => ['res_attachments', 'docservers'],
                        'left_join' => ['docservers.docserver_id = res_attachments.docserver_id'],
                        'where'     => ['attachment_type IN (?)', 'res_id_master = ?', 'res_attachments.res_id NOT IN (?)'],
                        'data'      => ["signed_response, {$pjNonEngageante}", $resId, $attachmentsIds]
                    ]);

                    if ($attachments) {
                        foreach ($attachments as $key => $attachment) {
                            if (mime_content_type($attachment['path']) !== 'application/pdf') {
                                $oldTitle = $attachment['title'];
                                $attachment = \SrcCore\models\DatabaseModel::select([
                                    'select'    => ["CONCAT(path_template, '/', path, '/', filename) as path"],
                                    'table'     => ['adr_attachments', 'docservers'],
                                    'left_join' => ['docservers.docserver_id = adr_attachments.docserver_id'],
                                    'where'     => ['res_id in (?)', 'type = ?'],
                                    'data'      => [$attachment['res_id'], 'PDF'],
                                ]);
                                if ($attachment) {
                                    $attachment = $attachment[0];
                                    $attachment['title'] = $oldTitle;
                                }
                            }
                            $nomFichier = preg_replace('/[^a-zA-Z0-9\s]/s', '', $attachment['title']) . '.pdf';
                            $nomFichier = str_replace('_', '', $nomFichier);
                            $nomFichier = str_replace(' ', '', $nomFichier);
                            $nomFichier = str_replace('-', '', $nomFichier);
                            $notePj[] = [
                                'nomFichier'     => $nomFichier,
                                'typeMime'       => mime_content_type($attachment['path']),
                                'contenuFichier' => base64_encode(file_get_contents($attachment['path']))
                            ];

                            $attachmentsIds[] = $attachment['res_id'];
                        }
                        if (empty($lastNote)) {
                            $lastNote[] = [
                                'id' => 0,
                                'firstname' => 'e-Citiz',
                                'lastname' => 'e-Citiz',
                                'creation_date' => date("Y-m-d H:i:s"),
                                'note_text' => 'Sans commentaire'
                            ];
                        }
                    }
                }

                if ($lastNote) {
                    $lastNote = $lastNote[0];
                    $response = \SrcCore\models\CurlModel::exec([
                        'url' => $sendNotApi,
                        'method' => 'POST',
                        'headers' => array("apiKey: {$apiKey}", "Content-Type: application/json"),
                        'body' => json_encode([
                            "notifierLusager" => false,
                            'estVisibleUsager' => false,
                            'numDossier' => $numDossier,
                            'piecesJointes' => $notePj,
                            "possibiliteDeReponseUsager" => false,
                            "notifierServiceReponseUsager" => false,
                            'commentaire' => $lastNote['note_text'],
                            'auteur' => $lastNote['lastname'] . ' ' . $lastNote['firstname'],
                            'dateCreation' => date("Y-m-d H:i:s", strtotime($lastNote['creation_date']))
                        ]),
                        'noLogs' => 'true'
                    ]);

                    if ($response['code'] == 403 || $response['code'] == 500 || $response['code'] == 400 || isset($response['response']['libErreur'])) {
                        self::writeLog($customId, ['message' => "[ERROR] [ADD_COMMENTAIRE] Return code is {$response['code']} and error message is : {$response['response']['libErreur']}"]);
                        continue;
                    }

                    if (!empty($response['errors'])) {
                        self::writeLog($customId, ['message' => "[ERROR] [ADD_COMMENTAIRE] {$response['errors']}"]);
                        continue;
                    }

                    \SrcCore\models\DatabaseModel::insert([
                        'table'         => 'ecitiz_notes',
                        'columnsValues' => [
                            'res_id'  => $resId,
                            'note_id' => $lastNote['id'],
                        ]
                    ]);

                    foreach ($attachmentsIds as $attachmentId) {
                        \SrcCore\models\DatabaseModel::insert([
                            'table'         => 'ecitiz_attachments',
                            'columnsValues' => [
                                'res_id'        => $resId,
                                'attachment_id' => $attachmentId,
                            ]
                        ]);
                    }
                }
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
            $file = fopen("custom/{$customId}/bin/external/ecitiz/ecitizScript.log", 'a');
        } else {
            $file = fopen('bin/external/ecitiz/ecitizScript.log', 'a');
        }
        fwrite($file, '[' . date('Y-m-d H:i:s') . '] ' . $args['message'] . PHP_EOL);
        fclose($file);

        if (strpos($args['message'], '[ERROR]') === 0) {
            \SrcCore\controllers\LogsController::add([
                'isTech'    => true,
                'moduleId'  => 'ecitiz',
                'level'     => 'ERROR',
                'tableName' => '',
                'recordId'  => 'e-Citiz',
                'eventType' => 'e-Citiz',
                'eventId'   => $args['message']
            ]);
        } else {
            \SrcCore\controllers\LogsController::add([
                'isTech'    => true,
                'moduleId'  => 'eCitiz',
                'level'     => 'INFO',
                'tableName' => '',
                'recordId'  => 'e-Citiz',
                'eventType' => 'e-Citiz',
                'eventId'   => $args['message']
            ]);
        }

        \History\models\BatchHistoryModel::create(['info' => $args['message'], 'module_name' => 'ecitiz']);
    }
}
