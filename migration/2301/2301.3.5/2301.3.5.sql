INSERT INTO configurations (privilege, value)
SELECT 'admin_organization_email_signatures', '{"signatures": [{"label": "Signature Organisation", "content": "<div><span><span><strong>[user.firstname] </strong></span></span><span>[user.lastname]</span></div>\\n<div><span><span><span><span><strong>[userPrimaryEntity.entity_label]</strong></span></span></span></span></div>\\n<div><span>[user.phone]</span></div>\\n<div><span><span>[userPrimaryEntity.address_number] [userPrimaryEntity.address_street], [userPrimaryEntity.address_postcode] [userPrimaryEntity.address_town]</span></span></div>\\n<div>&nbsp;</div>"}]}'
WHERE NOT EXISTS (SELECT 1 FROM configurations WHERE privilege = 'admin_organization_email_signatures'); -- EDISSYUM - NCH01 Augmentation du nombre de résultats pour la BAN

ALTER TABLE contacts ADD COLUMN IF NOT EXISTS status CHARACTER VARYING(256) DEFAULT 'OK'; -- EDISSYUM - NCH01 Module OCForMEM NextGen
UPDATE contacts SET status = 'OK'; -- EDISSYUM - NCH01 Module OCForMEM NextGen

DELETE FROM parameters WHERE id = 'enableSerenia'; -- EDISSYUM - NCH01 Implémentation SerenIA

-- EDISSYUM - AMO01 Scripter la modification des templates de notifications
UPDATE templates SET template_content = '<p><span style="font-family: verdana,geneva; font-size: xx-small;">Bonjour [recipient.firstname] [recipient.lastname],</span></p>
                                         <p><span style="font-family: verdana,geneva; font-size: xx-small;"> </span></p>
                                         <p><span style="font-family: verdana,geneva; font-size: xx-small;">Voici la liste des &eacute;v&eacute;nements de l''application qui vous sont notifi&eacute;s ([notification.description]) :</span></p>
                                         <table style="width: 800px; height: 36px;" border="0" cellspacing="1" cellpadding="1">
                                         <tbody>
                                         <tr>
                                         <td style="width: 150px; background-color: #3a7c00;"><span style="font-family: verdana,geneva; font-size: xx-small;"><strong><span style="color: #ffffff;">Date</span></strong></span></td>
                                         <td style="width: 150px; background-color: #3a7c00;"><span style="font-family: verdana,geneva; font-size: xx-small;"><strong><span style="color: #ffffff;">Utilisateur </span></strong></span></td>
                                         <td style="width: 500px; background-color: #3a7c00;"><span style="font-family: verdana,geneva; font-size: xx-small;"><strong><span style="color: #ffffff;">Description</span></strong></span></td>
                                         </tr>
                                         <tr>
                                         <td><span style="font-family: verdana,geneva; font-size: xx-small;">[events.event_date;block=tr;frm=dd/mm/yyyy hh:nn:ss]</span></td>
                                         <td><span style="font-family: verdana,geneva; font-size: xx-small;">[events.user_id]</span></td>
                                         <td><span style="font-family: verdana,geneva; font-size: xx-small;">[events.event_info]</span></td>
                                         </tr>
                                         </tbody>
                                         </table>'
WHERE template_label = '[notification] Notifications événement';

UPDATE templates SET template_content = '<p style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif;">Bonjour <strong>[recipient.firstname] [recipient.lastname]</strong>,</p>
                                         <p>&nbsp;</p>
                                         <p style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif;">Voici les nouvelles annotations sur les courriers suivants :</p>
                                         <table style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; border-collapse: collapse; width: 100%;">
                                         <tbody>
                                         <tr>
                                         <th style="border: 1px solid #ddd; padding: 8px; padding-top: 12px; padding-bottom: 12px; text-align: left; background-color: #3a7c00; color: white;">R&eacute;f&eacute;rence</th>
                                         <th style="border: 1px solid #ddd; padding: 8px; padding-top: 12px; padding-bottom: 12px; text-align: left; background-color: #3a7c00; color: white;">Num</th>
                                         <th style="border: 1px solid #ddd; padding: 8px; padding-top: 12px; padding-bottom: 12px; text-align: left; background-color: #3a7c00; color: white;">Date</th>
                                         <th style="border: 1px solid #ddd; padding: 8px; padding-top: 12px; padding-bottom: 12px; text-align: left; background-color: #3a7c00; color: white;">Objet</th>
                                         <th style="border: 1px solid #ddd; padding: 8px; padding-top: 12px; padding-bottom: 12px; text-align: left; background-color: #3a7c00; color: white;">Note</th>
                                         <th style="border: 1px solid #ddd; padding: 8px; padding-top: 12px; padding-bottom: 12px; text-align: left; background-color: #3a7c00; color: white;">Contact</th>
                                         <th style="border: 1px solid #ddd; padding: 8px; padding-top: 12px; padding-bottom: 12px; text-align: left; background-color: #3a7c00; color: white;">&nbsp;</th>
                                         </tr>
                                         <tr>
                                         <td style="border: 1px solid #ddd; padding: 8px;">[res_letterbox.res_id]</td>
                                         <td style="border: 1px solid #ddd; padding: 8px;">[res_letterbox.# ;frm=0000]</td>
                                         <td style="border: 1px solid #ddd; padding: 8px;">[res_letterbox.doc_date;block=tr;frm=dd/mm/yyyy]</td>
                                         <td style="border: 1px solid #ddd; padding: 8px;">[res_letterbox.subject]</td>
                                         <td style="border: 1px solid #ddd; padding: 8px;">[notes.content;block=tr]</td>
                                         <td style="border: 1px solid #ddd; padding: 8px;">[sender.company;block=tr] [sender.firstname] [sender.lastname]</td>
                                         <td style="border: 1px solid #ddd; padding: 8px; text-align: right;"><a style="text-decoration: none; background: #3A7C00; padding: 5px; color: white; -webkit-box-shadow: 6px 4px 5px 0px rgba(0,0,0,0.75); -moz-box-shadow: 6px 4px 5px 0px rgba(0,0,0,0.75); box-shadow: 6px 4px 5px 0px rgba(0,0,0,0.75);" href="[res_letterbox.linktodetail]" name="detail">D&eacute;tail</a> <a style="text-decoration: none; background: #3A7C00; padding: 5px; color: white; -webkit-box-shadow: 6px 4px 5px 0px rgba(0,0,0,0.75); -moz-box-shadow: 6px 4px 5px 0px rgba(0,0,0,0.75); box-shadow: 6px 4px 5px 0px rgba(0,0,0,0.75);" href="[res_letterbox.linktodoc]" name="doc">Afficher</a></td>
                                         </tr>
                                         </tbody>
                                         </table>
                                         <p>&nbsp;</p>
                                         <p style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; width: 100%; text-align: center; font-size: 9px; font-style: italic; opacity: 0.5;">Message g&eacute;n&eacute;r&eacute; via l''application MEMCourrier</p>'
WHERE template_label = '[notification courrier] Nouvelle annotation';

UPDATE templates SET template_content = '<p style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif;">Bonjour <strong>[recipient.firstname] [recipient.lastname]</strong>,</p>
                                         <p>&nbsp;</p>
                                         <p style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif;">Voici la liste des courriers toujours en attente de traitement :</p>
                                         <table style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; border-collapse: collapse; width: 100%;">
                                         <tbody>
                                         <tr>
                                         <th style="border: 1px solid #ddd; padding: 8px; padding-top: 12px; padding-bottom: 12px; text-align: left; background-color: #3a7c00; color: white;">R&eacute;f&eacute;rence</th>
                                         <th style="border: 1px solid #ddd; padding: 8px; padding-top: 12px; padding-bottom: 12px; text-align: left; background-color: #3a7c00; color: white;">Origine</th>
                                         <th style="border: 1px solid #ddd; padding: 8px; padding-top: 12px; padding-bottom: 12px; text-align: left; background-color: #3a7c00; color: white;">Emetteur</th>
                                         <th style="border: 1px solid #ddd; padding: 8px; padding-top: 12px; padding-bottom: 12px; text-align: left; background-color: #3a7c00; color: white;">Date</th>
                                         <th style="border: 1px solid #ddd; padding: 8px; padding-top: 12px; padding-bottom: 12px; text-align: left; background-color: #3a7c00; color: white;">Objet</th>
                                         <th style="border: 1px solid #ddd; padding: 8px; padding-top: 12px; padding-bottom: 12px; text-align: left; background-color: #3a7c00; color: white;">Type</th>
                                         <th style="border: 1px solid #ddd; padding: 8px; padding-top: 12px; padding-bottom: 12px; text-align: left; background-color: #3a7c00; color: white;">&nbsp;</th>
                                         </tr>
                                         <tr>
                                         <td style="border: 1px solid #ddd; padding: 8px;">[res_letterbox.alt_identifier]</td>
                                         <td style="border: 1px solid #ddd; padding: 8px;">[res_letterbox.typist_label]</td>
                                         <td style="border: 1px solid #ddd; padding: 8px;">[sender.company;block=tr] [sender.firstname] [sender.lastname][sender.function][sender.address_number] [sender.address_street] [sender.address_postcode] [sender.address_town]</td>
                                         <td style="border: 1px solid #ddd; padding: 8px;">[res_letterbox.doc_date;block=tr;frm=dd/mm/yyyy]</td>
                                         <td style="border: 1px solid #ddd; padding: 8px;">[res_letterbox.subject]</td>
                                         <td style="border: 1px solid #ddd; padding: 8px;">[res_letterbox.type_label]</td>
                                         <td style="border: 1px solid #ddd; padding: 8px; text-align: right;"><a style="text-decoration: none; background: #3A7C00; padding: 5px; color: white; -webkit-box-shadow: 6px 4px 5px 0px rgba(0,0,0,0.75); -moz-box-shadow: 6px 4px 5px 0px rgba(0,0,0,0.75); box-shadow: 6px 4px 5px 0px rgba(0,0,0,0.75);" href="[res_letterbox.linktodetail]" name="detail">D&eacute;tail</a> <a style="text-decoration: none; background: #3A7C00; padding: 5px; color: white; -webkit-box-shadow: 6px 4px 5px 0px rgba(0,0,0,0.75); -moz-box-shadow: 6px 4px 5px 0px rgba(0,0,0,0.75); box-shadow: 6px 4px 5px 0px rgba(0,0,0,0.75);" href="[res_letterbox.linktodoc]" name="doc">Afficher</a></td>
                                         </tr>
                                         </tbody>
                                         </table>
                                         <p>&nbsp;</p>
                                         <p style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; width: 100%; text-align: center; font-size: 9px; font-style: italic; opacity: 0.5;">Message g&eacute;n&eacute;r&eacute; via l''application MEMCourrier</p>'
WHERE template_label = '[notification courrier] Alerte 1';

UPDATE templates SET template_content = '<p style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif;">Bonjour <strong>[recipient.firstname] [recipient.lastname]</strong>,</p>
                                         <p>&nbsp;</p>
                                         <p style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif;">Voici la liste des courriers dont la date limite de traitement est d&eacute;pass&eacute;e :</p>
                                         <table style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; border-collapse: collapse; width: 100%;">
                                         <tbody>
                                         <tr>
                                         <th style="border: 1px solid #ddd; padding: 8px; padding-top: 12px; padding-bottom: 12px; text-align: left; background-color: #3a7c00; color: white;">R&eacute;f&eacute;rence</th>
                                         <th style="border: 1px solid #ddd; padding: 8px; padding-top: 12px; padding-bottom: 12px; text-align: left; background-color: #3a7c00; color: white;">Origine</th>
                                         <th style="border: 1px solid #ddd; padding: 8px; padding-top: 12px; padding-bottom: 12px; text-align: left; background-color: #3a7c00; color: white;">Emetteur</th>
                                         <th style="border: 1px solid #ddd; padding: 8px; padding-top: 12px; padding-bottom: 12px; text-align: left; background-color: #3a7c00; color: white;">Date</th>
                                         <th style="border: 1px solid #ddd; padding: 8px; padding-top: 12px; padding-bottom: 12px; text-align: left; background-color: #3a7c00; color: white;">Objet</th>
                                         <th style="border: 1px solid #ddd; padding: 8px; padding-top: 12px; padding-bottom: 12px; text-align: left; background-color: #3a7c00; color: white;">Type</th>
                                         <th style="border: 1px solid #ddd; padding: 8px; padding-top: 12px; padding-bottom: 12px; text-align: left; background-color: #3a7c00; color: white;">&nbsp;</th>
                                         </tr>
                                         <tr>
                                         <td style="border: 1px solid #ddd; padding: 8px;">[res_letterbox.alt_identifier]</td>
                                         <td style="border: 1px solid #ddd; padding: 8px;">[res_letterbox.typist_label]</td>
                                         <td style="border: 1px solid #ddd; padding: 8px;">[sender.company;block=tr] [sender.firstname] [sender.lastname][sender.function][sender.address_number] [sender.address_street] [sender.address_postcode] [sender.address_town]</td>
                                         <td style="border: 1px solid #ddd; padding: 8px;">[res_letterbox.doc_date;block=tr;frm=dd/mm/yyyy]</td>
                                         <td style="border: 1px solid #ddd; padding: 8px;">[res_letterbox.subject]</td>
                                         <td style="border: 1px solid #ddd; padding: 8px;">[res_letterbox.type_label]</td>
                                         <td style="border: 1px solid #ddd; padding: 8px; text-align: right;"><a style="text-decoration: none; background: #3A7C00; padding: 5px; color: white; -webkit-box-shadow: 6px 4px 5px 0px rgba(0,0,0,0.75); -moz-box-shadow: 6px 4px 5px 0px rgba(0,0,0,0.75); box-shadow: 6px 4px 5px 0px rgba(0,0,0,0.75);" href="[res_letterbox.linktodetail]" name="detail">D&eacute;tail</a> <a style="text-decoration: none; background: #3A7C00; padding: 5px; color: white; -webkit-box-shadow: 6px 4px 5px 0px rgba(0,0,0,0.75); -moz-box-shadow: 6px 4px 5px 0px rgba(0,0,0,0.75); box-shadow: 6px 4px 5px 0px rgba(0,0,0,0.75);" href="[res_letterbox.linktodoc]" name="doc">Afficher</a></td>
                                         </tr>
                                         </tbody>
                                         </table>
                                         <p>&nbsp;</p>
                                         <p style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; width: 100%; text-align: center; font-size: 9px; font-style: italic; opacity: 0.5;">Message g&eacute;n&eacute;r&eacute; via l''application MEMCourrier</p>'
WHERE template_label = '[notification courrier] Alerte 2';

UPDATE templates SET template_content = '<p style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif;">Bonjour <strong>[recipient.firstname] [recipient.lastname]</strong>,</p>
                                         <p>&nbsp;</p>
                                         <p style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif;">Voici la liste des nouveaux courriers pr&eacute;sents dans cette bannette:</p>
                                         <table style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; border-collapse: collapse; width: 100%;">
                                         <tbody>
                                         <tr>
                                         <th style="border: 1px solid #ddd; padding: 8px; padding-top: 12px; padding-bottom: 12px; text-align: left; background-color: #3a7c00; color: white;">Bannettes</th>
                                         <th style="border: 1px solid #ddd; padding: 8px; padding-top: 12px; padding-bottom: 12px; text-align: left; background-color: #3a7c00; color: white;">R&eacute;f&eacute;rence</th>
                                         <th style="border: 1px solid #ddd; padding: 8px; padding-top: 12px; padding-bottom: 12px; text-align: left; background-color: #3a7c00; color: white;">Origine</th>
                                         <th style="border: 1px solid #ddd; padding: 8px; padding-top: 12px; padding-bottom: 12px; text-align: left; background-color: #3a7c00; color: white;">Emetteur</th>
                                         <th style="border: 1px solid #ddd; padding: 8px; padding-top: 12px; padding-bottom: 12px; text-align: left; background-color: #3a7c00; color: white;">Date</th>
                                         <th style="border: 1px solid #ddd; padding: 8px; padding-top: 12px; padding-bottom: 12px; text-align: left; background-color: #3a7c00; color: white;">Objet</th>
                                         <th style="border: 1px solid #ddd; padding: 8px; padding-top: 12px; padding-bottom: 12px; text-align: left; background-color: #3a7c00; color: white;">Type</th>
                                         <th style="border: 1px solid #ddd; padding: 8px; padding-top: 12px; padding-bottom: 12px; text-align: left; background-color: #3a7c00; color: white;">&nbsp;</th>
                                         </tr>
                                         <tr>
                                         <td style="border: 1px solid #ddd; padding: 8px;">[res_letterbox.basketName]</td>
                                         <td style="border: 1px solid #ddd; padding: 8px;">[res_letterbox.alt_identifier]</td>
                                         <td style="border: 1px solid #ddd; padding: 8px;">[res_letterbox.typist_label]</td>
                                         <td style="border: 1px solid #ddd; padding: 8px;">[sender.company;block=tr] [sender.firstname] [sender.lastname][sender.function][sender.address_number][sender.address_street][sender.address_postcode][sender.address_town]</td>
                                         <td style="border: 1px solid #ddd; padding: 8px;">[res_letterbox.doc_date;block=tr;frm=dd/mm/yyyy]</td>
                                         <td style="border: 1px solid #ddd; padding: 8px;">[res_letterbox.subject]</td>
                                         <td style="border: 1px solid #ddd; padding: 8px;">[res_letterbox.type_label]</td>
                                         <td style="border: 1px solid #ddd; padding: 8px; text-align: right;"><a style="text-decoration: none; background: #3A7C00; padding: 5px; color: white; -webkit-box-shadow: 6px 4px 5px 0px rgba(0,0,0,0.75); -moz-box-shadow: 6px 4px 5px 0px rgba(0,0,0,0.75); box-shadow: 6px 4px 5px 0px rgba(0,0,0,0.75);" href="[res_letterbox.linktodetail]" name="detail">D&eacute;tail</a> <a style="text-decoration: none; background: #3A7C00; padding: 5px; color: white; -webkit-box-shadow: 6px 4px 5px 0px rgba(0,0,0,0.75); -moz-box-shadow: 6px 4px 5px 0px rgba(0,0,0,0.75); box-shadow: 6px 4px 5px 0px rgba(0,0,0,0.75);" href="[res_letterbox.linktodoc]" name="doc">Afficher</a></td>
                                         </tr>
                                         </tbody>
                                         </table>
                                         <p>&nbsp;</p>
                                         <p style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; width: 100%; text-align: center; font-size: 9px; font-style: italic; opacity: 0.5;">Message g&eacute;n&eacute;r&eacute; via l''application MEMCourrier</p>'
WHERE template_label = '[notification courrier] Diffusion de courrier';
-- END EDISSYUM - AMO01

-- EDISSYUM - NCH01 Amélioration de l'historique de la listinstance pour l'IA
ALTER TABLE listinstance_history_details ADD COLUMN IF NOT EXISTS ai_destination VARCHAR;
ALTER TABLE listinstance_history_details ADD COLUMN IF NOT EXISTS  old_destination VARCHAR;
INSERT INTO parameters (id, description, param_value_string)
SELECT 'ai_action_destination', 'Liste des actions utilisées pour spécifier la destination à utiliser pour l''apprentissage de SerenIA (exemple : 593,18)', ''
WHERE NOT EXISTS (SELECT 1 FROM parameters WHERE id = 'ai_action_destination');
-- END EDISSYUM - NCH01

INSERT INTO parameters (id, description, param_value_string)
SELECT 'defaultStatusSummarySheet', 'Statut par défaut des champs de la fiche de liaison', '{"primaryInformations":false,"senderRecipientInformations":false,"secondaryInformations":true,"systemTechnicalFields":true,"customTechnicalFields":true,"diffusionList":true,"opinionWorkflow":true,"visaWorkflow":true,"visaWorkflowMaarchParapheur":false,"globalNotes":true,"avisNotes":true,"visaNotes":true,"workflowHistory":true,"trafficRecords":true}'
WHERE NOT EXISTS (SELECT 1 FROM parameters WHERE id = 'defaultStatusSummarySheet'); -- EDISSYUM - AMO01 Dissocier les annotations par type + Adapter le paramètre defaultStatusSummarySheet | Ajout de "globalNotes", "avisNotes" et "visaNotes"

-- EDISSYUM - (AMI01 + AMO01) Intégration fiche de liaison au parapheur externe
INSERT INTO parameters (id, description, param_value_string)
SELECT 'defaultParapheurSummarySheet', 'Statut par défaut des champs de la fiche de liaison lors de l''intégration au parapheur', '{"primaryInformations":false,"senderRecipientInformations":false,"secondaryInformations":true,"systemTechnicalFields":true,"customTechnicalFields":true,"diffusionList":true,"opinionWorkflow":true,"visaWorkflow":true,"visaWorkflowMaarchParapheur":false,"globalNotes":true,"avisNotes":true,"visaNotes":true,"workflowHistory":true,"trafficRecords":true}'
WHERE NOT EXISTS (SELECT 1 FROM parameters WHERE id = 'defaultParapheurSummarySheet');

INSERT INTO parameters (id, description, param_value_int)
SELECT 'sendSummarySheet', 'Envoi de la fiche de liaison au parapheur externe', 1
WHERE NOT EXISTS (SELECT 1 FROM parameters WHERE id = 'sendSummarySheet');
-- END EDISSYUM - (AMI01 + AMO01)

INSERT INTO parameters (id, description, param_value_int)
SELECT 'banMaxItems', 'Nombre de résultats maximums pour la BAN', 500
WHERE NOT EXISTS (SELECT 1 FROM parameters WHERE id = 'banMaxItems'); -- EDISSYUM - NCH01 Augmentation du nombre de résultats pour la BAN

INSERT INTO parameters (id, description, param_value_string)
SELECT 'notificationAttachmentsTypeAllowed', 'Liste des types de pièces jointe à envoyer dans les notifications si "Joindre un document" est activé', 'response_project, simple_attachment'
WHERE NOT EXISTS (SELECT 1 FROM parameters WHERE id = 'notificationAttachmentsTypeAllowed'); -- EDISSYUM - NCH01 Rajout de la possibilité d'envoyer les PJ dans les notifications

ALTER TABLE indexing_models ADD COLUMN IF NOT EXISTS force_current_user BOOLEAN DEFAULT FALSE NOT NULL; -- EDISSYUM - NCH01 Ajout d'un paramètre pour forcer l'utilisateur courant en tant qu'attributaire

ALTER TABLE indexing_models ADD COLUMN IF NOT EXISTS no_diffusion_role BOOLEAN DEFAULT FALSE NOT NULL; -- EDISSYUM - NCH01 Ajout d'un paramètre pour ne pas remonter les rôles de diffusion dans l'indexation

ALTER TABLE indexing_models ADD COLUMN IF NOT EXISTS send_main_doc_paraph BOOLEAN DEFAULT FALSE NOT NULL; -- EDISSYUM - NCH01 Ajout d'un paramètre pour envoyer le document principal lors de l'envoi au visa

ALTER TABLE indexing_models ADD COLUMN IF NOT EXISTS generate_ar BOOLEAN DEFAULT FALSE NOT NULL; -- EDISSYUM - NCH01 Rajout d'une option pour pouvoir générer un AR par modèle d'enregistrement

UPDATE parameters SET param_value_string = '2301.3.5' WHERE id = 'database_version';
