------------
-- DATA SAMPLE 24
-- (Launch the application to update data to the last tag)
------------
DELETE FROM "actions";
INSERT INTO actions (id, keyword, label_action, id_status, is_system, action_page, component, history, parameters) VALUES (590, '', 'Transmettre pour signature électronique', '_NOSTATUS_', 'N', 'sendToExternalSignatureBook', 'sendExternalSignatoryBookAction', 'Y', '{"successStatus": "PARAPHWAIT"}');
INSERT INTO actions (id, keyword, label_action, id_status, is_system, action_page, component, history, parameters) VALUES (552, 'redirect', 'Vérifier l''affectation puis transmettre au Directeur', 'VALDIR', 'N', 'redirect', 'redirectAction', 'Y', '{"keepCopyForRedirection": true, "keepDestForRedirection:": false, "keepOtherRoleForRedirection": true}');
INSERT INTO actions (id, keyword, label_action, id_status, is_system, action_page, component, history, parameters) VALUES (583, '', 'Réinitialiser le circuit', 'COU', 'N', 'rejection_visa_redactor', 'resetVisaAction', 'Y', '{}');
INSERT INTO actions (id, keyword, label_action, id_status, is_system, action_page, component, history, parameters) VALUES (566, '', 'Valider courrier(s) => DGS', 'VALDGS', 'N', 'confirm_status', 'confirmAction', 'Y', '{}');
INSERT INTO actions (id, keyword, label_action, id_status, is_system, action_page, component, history, parameters) VALUES (568, '', 'Valider courrier(s) => Directeur', 'VALDIR', 'N', 'confirm_status', 'confirmAction', 'Y', '{}');
INSERT INTO actions (id, keyword, label_action, id_status, is_system, action_page, component, history, parameters) VALUES (1, 'redirect', 'Rediriger', 'NEW', 'Y', 'redirect', 'redirectAction', 'Y', '{"keepCopyForRedirection": true, "keepDestForRedirection:": false, "keepOtherRoleForRedirection": true}');
INSERT INTO actions (id, keyword, label_action, id_status, is_system, action_page, component, history, parameters) VALUES (6, '', 'Supprimer le courrier', 'DEL', 'N', 'confirm_status', 'confirmAction', 'Y', '{}');
INSERT INTO actions (id, keyword, label_action, id_status, is_system, action_page, component, history, parameters) VALUES (20, '', 'Cloturer', 'END', 'N', 'close_mail', 'closeMailAction', 'Y', '{"requiredFields": []}');
INSERT INTO actions (id, keyword, label_action, id_status, is_system, action_page, component, history, parameters) VALUES (36, '', 'Envoyer pour avis', 'EAVIS', 'N', 'send_docs_to_recommendation', 'sendToParallelOpinion', 'Y', '{}');
INSERT INTO actions (id, keyword, label_action, id_status, is_system, action_page, component, history, parameters) VALUES (37, '', 'Donner un avis', '_NOSTATUS_', 'N', 'avis_workflow_simple', 'giveOpinionParallelAction', 'Y', '{}');
INSERT INTO actions (id, keyword, label_action, id_status, is_system, action_page, component, history, parameters) VALUES (114, '', 'Marquer comme lu', '', 'N', 'mark_as_read', 'resMarkAsReadAction', 'N', '{}');
INSERT INTO actions (id, keyword, label_action, id_status, is_system, action_page, component, history, parameters) VALUES (400, '', 'Envoyer un AR', '_NOSTATUS_', 'N', 'send_attachments_to_contact', 'createAcknowledgementReceiptsAction', 'Y', '{"mode": "manual"}');
INSERT INTO actions (id, keyword, label_action, id_status, is_system, action_page, component, history, parameters) VALUES (570, '', 'Mettre le courrier en cours de traitement', 'COU', 'N', 'confirm_status', 'confirmAction', 'Y', '{}');
INSERT INTO actions (id, keyword, label_action, id_status, is_system, action_page, component, history, parameters) VALUES (405, '', '1 - Viser et poursuivre le circuit', '_NOSTATUS_', 'N', 'visa_workflow', 'continueVisaCircuitAction', 'Y', '{"successStatus": "EVIS"}');
INSERT INTO actions (id, keyword, label_action, id_status, is_system, action_page, component, history, parameters) VALUES (571, '', 'Renvoyer le courrier réconcilié au service traitant', 'EENV', 'N', 'confirm_status', 'confirmAction', 'Y', '{}');
INSERT INTO actions (id, keyword, label_action, id_status, is_system, action_page, component, history, parameters) VALUES (569, '', 'Demande de réaffectation (erreur orientation)', 'RET', 'N', 'confirm_status', 'confirmAction', 'Y', '{}');
INSERT INTO actions (id, keyword, label_action, id_status, is_system, action_page, component, history, parameters) VALUES (18, 'redirect', 'Transmettre au service', 'NEW', 'N', 'redirect', 'redirectAction', 'Y', '{"keepCopyForRedirection": true, "keepDestForRedirection:": false, "keepOtherRoleForRedirection": true}');
INSERT INTO actions (id, keyword, label_action, id_status, is_system, action_page, component, history, parameters) VALUES (543, '', 'Réconcilier le courrier', '_NOSTATUS_', 'N', 'reconcile', 'reconcileAction', 'Y', '{}');
INSERT INTO actions (id, keyword, label_action, id_status, is_system, action_page, component, history, parameters) VALUES (5, '', 'Remettre en traitement', 'COU', 'N', 'no_confirm_status', 'noConfirmAction', 'Y', '{}');
INSERT INTO actions (id, keyword, label_action, id_status, is_system, action_page, component, history, parameters) VALUES (572, '', 'Mettre dans la bannette à traiter', 'NEW', 'N', 'no_confirm_status', 'noConfirmAction', 'Y', '{}');
INSERT INTO actions (id, keyword, label_action, id_status, is_system, action_page, component, history, parameters) VALUES (577, '', 'Retour au superviseur courrier', 'VALS', 'N', 'confirm_status', 'confirmAction', 'Y', '{}');
INSERT INTO actions (id, keyword, label_action, id_status, is_system, action_page, component, history, parameters) VALUES (557, '', 'Courrier rejeté par le signataire', 'REJ_SIGN', 'N', 'rejection_visa_redactor', 'resetVisaAction', 'Y', '{}');
INSERT INTO actions (id, keyword, label_action, id_status, is_system, action_page, component, history, parameters) VALUES (582, '', 'Mettre en attente de retour parapheur', 'WAIT', 'N', 'no_confirm_status', 'noConfirmAction', 'Y', '{}');
INSERT INTO actions (id, keyword, label_action, id_status, is_system, action_page, component, history, parameters) VALUES (587, '', '5 - Transmettre la réponse signée', 'EENV', 'N', 'visa_workflow', 'continueVisaCircuitAction', 'Y', '{"successStatus": "EENV"}');
INSERT INTO actions (id, keyword, label_action, id_status, is_system, action_page, component, history, parameters) VALUES (559, '', '6 - Renvoyer au viseur précédent', 'EVIS', 'N', 'rejection_visa_previous', 'rejectVisaBackToPreviousAction', 'Y', '{}');
INSERT INTO actions (id, keyword, label_action, id_status, is_system, action_page, component, history, parameters) VALUES (556, '', '7 - Rejeter vers le rédacteur', 'REJ_VISA', 'N', 'rejection_visa_redactor', 'resetVisaAction', 'Y', '{}');
INSERT INTO actions (id, keyword, label_action, id_status, is_system, action_page, component, history, parameters) VALUES (588, '', 'Transmettre au service', 'NEW', 'N', 'confirm_status', 'confirmAction', 'Y', '{}');
INSERT INTO actions (id, keyword, label_action, id_status, is_system, action_page, component, history, parameters) VALUES (591, '', 'Choisir un type de courrier', '_NOSTATUS_', 'N', 'no_confirm_status', 'noConfirmAction', 'Y', '{}');
INSERT INTO actions (id, keyword, label_action, id_status, is_system, action_page, component, history, parameters) VALUES (551, 'redirect', 'Envoyer pour validation superviseur', 'VALS', 'N', 'redirect', 'redirectAction', 'Y', '{"keepCopyForRedirection": true, "keepDestForRedirection:": false, "keepOtherRoleForRedirection": true}');
INSERT INTO actions (id, keyword, label_action, id_status, is_system, action_page, component, history, parameters) VALUES (584, '', 'Envoyer pour validation superviseur', 'VALS', 'N', 'confirm_status', 'confirmAction', 'Y', '{"fillRequiredFields": []}');
INSERT INTO actions (id, keyword, label_action, id_status, is_system, action_page, component, history, parameters) VALUES (553, 'redirect', 'Vérifier l''affectation, envoyer au DGS', 'VALDGS', 'N', 'redirect', 'redirectAction', 'Y', '{"keepCopyForRedirection": true, "keepDestForRedirection:": false, "keepOtherRoleForRedirection": true}');
INSERT INTO actions (id, keyword, label_action, id_status, is_system, action_page, component, history, parameters) VALUES (554, 'redirect', 'Vérifier l''affectation, envoyer au service', 'NEW', 'N', 'redirect', 'redirectAction', 'Y', '{"keepCopyForRedirection": true, "keepDestForRedirection:": false, "keepOtherRoleForRedirection": true}');
INSERT INTO actions (id, keyword, label_action, id_status, is_system, action_page, component, history, parameters) VALUES (558, '', 'Envoyer en circuit de visa', '_NOSTATUS_', 'N', 'send_to_visa', 'sendSignatureBookAction', 'Y', '{"successStatus": "EVIS"}');
INSERT INTO actions (id, keyword, label_action, id_status, is_system, action_page, component, history, parameters) VALUES (576, '', 'Renvoyer pour correction', 'RET', 'N', 'confirm_status', 'confirmAction', 'Y', '{"fillRequiredFields": []}');
INSERT INTO actions (id, keyword, label_action, id_status, is_system, action_page, component, history, parameters) VALUES (565, '', 'Envoyer au(x) service(s)', 'NEW', 'N', 'no_confirm_status', 'noConfirmAction', 'Y', '{}');
INSERT INTO actions (id, keyword, label_action, id_status, is_system, action_page, component, history, parameters) VALUES (589, 'redirect', 'Attribuer à moi-même', '_NOSTATUS_', 'N', 'redirect', 'redirectAction', 'Y', '{"keepCopyForRedirection": true, "keepDestForRedirection:": false, "keepOtherRoleForRedirection": true}');
INSERT INTO actions (id, keyword, label_action, id_status, is_system, action_page, component, history, parameters) VALUES (593, 'redirect', 'Attribuer à un service', 'NEW', 'N', 'redirect', 'redirectAction', 'Y', '{"keepCopyForRedirection": true, "keepDestForRedirection:": false, "keepOtherRoleForRedirection": true}');
INSERT INTO actions (id, keyword, label_action, id_status, is_system, action_page, component, history, parameters) VALUES (594, '', 'Envoyer pour signature manuscrite sans visa', 'IMP', 'N', 'confirm_status', 'confirmAction', 'Y', '{"fillRequiredFields": []}');
INSERT INTO actions (id, keyword, label_action, id_status, is_system, action_page, component, history, parameters) VALUES (545, '', 'Rejeter, refus signataire', 'REJ_SIGN', 'N', 'rejection_visa_redactor', 'resetVisaAction', 'Y', '{}');
INSERT INTO actions (id, keyword, label_action, id_status, is_system, action_page, component, history, parameters) VALUES (580, '', '2 - Viser et envoyer pour signature électronique', 'PARAPHWAIT', 'N', 'sendToExternalSignatureBook', 'sendExternalSignatoryBookAction', 'Y', '{"errorStatus": "REJ_SIGN", "successStatus": "PARAPHWAIT"}');
INSERT INTO actions (id, keyword, label_action, id_status, is_system, action_page, component, history, parameters) VALUES (585, '', '3 - Viser et envoyer pour signature manuscrite', 'IMP', 'N', 'visa_workflow', 'continueVisaCircuitAction', 'Y', '{"successStatus": "IMP"}');
INSERT INTO actions (id, keyword, label_action, id_status, is_system, action_page, component, history, parameters) VALUES (586, '', '4 - Viser et envoyer pour signature (griffe)', 'ESIG', 'N', 'visa_workflow', 'continueVisaCircuitAction', 'Y', '{"successStatus": "ESIG"}');
INSERT INTO actions (id, keyword, label_action, id_status, is_system, action_page, component, history, parameters) VALUES (592, 'redirect', 'Attribuer à un collaborateur', 'NEW', 'N', 'redirect', 'redirectAction', 'Y', '{"keepCopyForRedirection": true, "keepDestForRedirection:": false, "keepOtherRoleForRedirection": true}');

DELETE FROM actions_categories;
INSERT INTO actions_categories (action_id, category_id) VALUES (590, 'incoming');
INSERT INTO actions_categories (action_id, category_id) VALUES (590, 'outgoing');
INSERT INTO actions_categories (action_id, category_id) VALUES (590, 'internal');
INSERT INTO actions_categories (action_id, category_id) VALUES (590, 'ged_doc');
INSERT INTO actions_categories (action_id, category_id) VALUES (590, 'registeredMail');
INSERT INTO actions_categories (action_id, category_id) VALUES (583, 'incoming');
INSERT INTO actions_categories (action_id, category_id) VALUES (583, 'outgoing');
INSERT INTO actions_categories (action_id, category_id) VALUES (583, 'internal');
INSERT INTO actions_categories (action_id, category_id) VALUES (583, 'ged_doc');
INSERT INTO actions_categories (action_id, category_id) VALUES (583, 'registeredMail');
INSERT INTO actions_categories (action_id, category_id) VALUES (566, 'incoming');
INSERT INTO actions_categories (action_id, category_id) VALUES (566, 'outgoing');
INSERT INTO actions_categories (action_id, category_id) VALUES (566, 'internal');
INSERT INTO actions_categories (action_id, category_id) VALUES (566, 'ged_doc');
INSERT INTO actions_categories (action_id, category_id) VALUES (566, 'registeredMail');
INSERT INTO actions_categories (action_id, category_id) VALUES (20, 'incoming');
INSERT INTO actions_categories (action_id, category_id) VALUES (20, 'outgoing');
INSERT INTO actions_categories (action_id, category_id) VALUES (20, 'internal');
INSERT INTO actions_categories (action_id, category_id) VALUES (20, 'ged_doc');
INSERT INTO actions_categories (action_id, category_id) VALUES (18, 'incoming');
INSERT INTO actions_categories (action_id, category_id) VALUES (18, 'outgoing');
INSERT INTO actions_categories (action_id, category_id) VALUES (18, 'internal');
INSERT INTO actions_categories (action_id, category_id) VALUES (18, 'ged_doc');
INSERT INTO actions_categories (action_id, category_id) VALUES (18, 'registeredMail');
INSERT INTO actions_categories (action_id, category_id) VALUES (543, 'incoming');
INSERT INTO actions_categories (action_id, category_id) VALUES (543, 'outgoing');
INSERT INTO actions_categories (action_id, category_id) VALUES (543, 'internal');
INSERT INTO actions_categories (action_id, category_id) VALUES (543, 'ged_doc');
INSERT INTO actions_categories (action_id, category_id) VALUES (543, 'registeredMail');
INSERT INTO actions_categories (action_id, category_id) VALUES (570, 'incoming');
INSERT INTO actions_categories (action_id, category_id) VALUES (570, 'outgoing');
INSERT INTO actions_categories (action_id, category_id) VALUES (570, 'internal');
INSERT INTO actions_categories (action_id, category_id) VALUES (570, 'ged_doc');
INSERT INTO actions_categories (action_id, category_id) VALUES (570, 'registeredMail');
INSERT INTO actions_categories (action_id, category_id) VALUES (405, 'incoming');
INSERT INTO actions_categories (action_id, category_id) VALUES (405, 'outgoing');
INSERT INTO actions_categories (action_id, category_id) VALUES (405, 'internal');
INSERT INTO actions_categories (action_id, category_id) VALUES (405, 'ged_doc');
INSERT INTO actions_categories (action_id, category_id) VALUES (405, 'registeredMail');
INSERT INTO actions_categories (action_id, category_id) VALUES (5, 'incoming');
INSERT INTO actions_categories (action_id, category_id) VALUES (5, 'outgoing');
INSERT INTO actions_categories (action_id, category_id) VALUES (5, 'internal');
INSERT INTO actions_categories (action_id, category_id) VALUES (5, 'ged_doc');
INSERT INTO actions_categories (action_id, category_id) VALUES (5, 'registeredMail');
INSERT INTO actions_categories (action_id, category_id) VALUES (571, 'incoming');
INSERT INTO actions_categories (action_id, category_id) VALUES (571, 'outgoing');
INSERT INTO actions_categories (action_id, category_id) VALUES (571, 'internal');
INSERT INTO actions_categories (action_id, category_id) VALUES (571, 'ged_doc');
INSERT INTO actions_categories (action_id, category_id) VALUES (571, 'registeredMail');
INSERT INTO actions_categories (action_id, category_id) VALUES (569, 'incoming');
INSERT INTO actions_categories (action_id, category_id) VALUES (569, 'outgoing');
INSERT INTO actions_categories (action_id, category_id) VALUES (569, 'internal');
INSERT INTO actions_categories (action_id, category_id) VALUES (588, 'incoming');
INSERT INTO actions_categories (action_id, category_id) VALUES (588, 'outgoing');
INSERT INTO actions_categories (action_id, category_id) VALUES (588, 'internal');
INSERT INTO actions_categories (action_id, category_id) VALUES (588, 'ged_doc');
INSERT INTO actions_categories (action_id, category_id) VALUES (569, 'ged_doc');
INSERT INTO actions_categories (action_id, category_id) VALUES (569, 'registeredMail');
INSERT INTO actions_categories (action_id, category_id) VALUES (572, 'incoming');
INSERT INTO actions_categories (action_id, category_id) VALUES (572, 'outgoing');
INSERT INTO actions_categories (action_id, category_id) VALUES (572, 'internal');
INSERT INTO actions_categories (action_id, category_id) VALUES (572, 'ged_doc');
INSERT INTO actions_categories (action_id, category_id) VALUES (572, 'registeredMail');
INSERT INTO actions_categories (action_id, category_id) VALUES (588, 'registeredMail');
INSERT INTO actions_categories (action_id, category_id) VALUES (577, 'incoming');
INSERT INTO actions_categories (action_id, category_id) VALUES (577, 'outgoing');
INSERT INTO actions_categories (action_id, category_id) VALUES (577, 'internal');
INSERT INTO actions_categories (action_id, category_id) VALUES (577, 'ged_doc');
INSERT INTO actions_categories (action_id, category_id) VALUES (577, 'registeredMail');
INSERT INTO actions_categories (action_id, category_id) VALUES (568, 'incoming');
INSERT INTO actions_categories (action_id, category_id) VALUES (568, 'outgoing');
INSERT INTO actions_categories (action_id, category_id) VALUES (568, 'internal');
INSERT INTO actions_categories (action_id, category_id) VALUES (568, 'ged_doc');
INSERT INTO actions_categories (action_id, category_id) VALUES (568, 'registeredMail');
INSERT INTO actions_categories (action_id, category_id) VALUES (557, 'ged_doc');
INSERT INTO actions_categories (action_id, category_id) VALUES (557, 'incoming');
INSERT INTO actions_categories (action_id, category_id) VALUES (557, 'internal');
INSERT INTO actions_categories (action_id, category_id) VALUES (557, 'outgoing');
INSERT INTO actions_categories (action_id, category_id) VALUES (557, 'registeredMail');
INSERT INTO actions_categories (action_id, category_id) VALUES (582, 'incoming');
INSERT INTO actions_categories (action_id, category_id) VALUES (582, 'outgoing');
INSERT INTO actions_categories (action_id, category_id) VALUES (582, 'internal');
INSERT INTO actions_categories (action_id, category_id) VALUES (582, 'ged_doc');
INSERT INTO actions_categories (action_id, category_id) VALUES (582, 'registeredMail');
INSERT INTO actions_categories (action_id, category_id) VALUES (587, 'incoming');
INSERT INTO actions_categories (action_id, category_id) VALUES (587, 'outgoing');
INSERT INTO actions_categories (action_id, category_id) VALUES (587, 'internal');
INSERT INTO actions_categories (action_id, category_id) VALUES (587, 'ged_doc');
INSERT INTO actions_categories (action_id, category_id) VALUES (587, 'registeredMail');
INSERT INTO actions_categories (action_id, category_id) VALUES (559, 'ged_doc');
INSERT INTO actions_categories (action_id, category_id) VALUES (559, 'incoming');
INSERT INTO actions_categories (action_id, category_id) VALUES (559, 'internal');
INSERT INTO actions_categories (action_id, category_id) VALUES (559, 'outgoing');
INSERT INTO actions_categories (action_id, category_id) VALUES (559, 'registeredMail');
INSERT INTO actions_categories (action_id, category_id) VALUES (556, 'ged_doc');
INSERT INTO actions_categories (action_id, category_id) VALUES (556, 'incoming');
INSERT INTO actions_categories (action_id, category_id) VALUES (556, 'internal');
INSERT INTO actions_categories (action_id, category_id) VALUES (556, 'outgoing');
INSERT INTO actions_categories (action_id, category_id) VALUES (556, 'registeredMail');
INSERT INTO actions_categories (action_id, category_id) VALUES (552, 'incoming');
INSERT INTO actions_categories (action_id, category_id) VALUES (552, 'outgoing');
INSERT INTO actions_categories (action_id, category_id) VALUES (552, 'internal');
INSERT INTO actions_categories (action_id, category_id) VALUES (552, 'ged_doc');
INSERT INTO actions_categories (action_id, category_id) VALUES (552, 'registeredMail');
INSERT INTO actions_categories (action_id, category_id) VALUES (591, 'incoming');
INSERT INTO actions_categories (action_id, category_id) VALUES (591, 'outgoing');
INSERT INTO actions_categories (action_id, category_id) VALUES (591, 'internal');
INSERT INTO actions_categories (action_id, category_id) VALUES (591, 'ged_doc');
INSERT INTO actions_categories (action_id, category_id) VALUES (591, 'registeredMail');
INSERT INTO actions_categories (action_id, category_id) VALUES (554, 'ged_doc');
INSERT INTO actions_categories (action_id, category_id) VALUES (554, 'incoming');
INSERT INTO actions_categories (action_id, category_id) VALUES (554, 'internal');
INSERT INTO actions_categories (action_id, category_id) VALUES (554, 'outgoing');
INSERT INTO actions_categories (action_id, category_id) VALUES (554, 'registeredMail');
INSERT INTO actions_categories (action_id, category_id) VALUES (553, 'ged_doc');
INSERT INTO actions_categories (action_id, category_id) VALUES (553, 'incoming');
INSERT INTO actions_categories (action_id, category_id) VALUES (553, 'internal');
INSERT INTO actions_categories (action_id, category_id) VALUES (553, 'outgoing');
INSERT INTO actions_categories (action_id, category_id) VALUES (553, 'registeredMail');
INSERT INTO actions_categories (action_id, category_id) VALUES (576, 'ged_doc');
INSERT INTO actions_categories (action_id, category_id) VALUES (576, 'incoming');
INSERT INTO actions_categories (action_id, category_id) VALUES (576, 'internal');
INSERT INTO actions_categories (action_id, category_id) VALUES (576, 'outgoing');
INSERT INTO actions_categories (action_id, category_id) VALUES (576, 'registeredMail');
INSERT INTO actions_categories (action_id, category_id) VALUES (589, 'incoming');
INSERT INTO actions_categories (action_id, category_id) VALUES (589, 'outgoing');
INSERT INTO actions_categories (action_id, category_id) VALUES (589, 'internal');
INSERT INTO actions_categories (action_id, category_id) VALUES (589, 'ged_doc');
INSERT INTO actions_categories (action_id, category_id) VALUES (589, 'registeredMail');
INSERT INTO actions_categories (action_id, category_id) VALUES (593, 'incoming');
INSERT INTO actions_categories (action_id, category_id) VALUES (593, 'outgoing');
INSERT INTO actions_categories (action_id, category_id) VALUES (593, 'internal');
INSERT INTO actions_categories (action_id, category_id) VALUES (593, 'ged_doc');
INSERT INTO actions_categories (action_id, category_id) VALUES (593, 'registeredMail');
INSERT INTO actions_categories (action_id, category_id) VALUES (594, 'incoming');
INSERT INTO actions_categories (action_id, category_id) VALUES (594, 'outgoing');
INSERT INTO actions_categories (action_id, category_id) VALUES (594, 'internal');
INSERT INTO actions_categories (action_id, category_id) VALUES (594, 'ged_doc');
INSERT INTO actions_categories (action_id, category_id) VALUES (594, 'registeredMail');
INSERT INTO actions_categories (action_id, category_id) VALUES (580, 'incoming');
INSERT INTO actions_categories (action_id, category_id) VALUES (580, 'outgoing');
INSERT INTO actions_categories (action_id, category_id) VALUES (580, 'internal');
INSERT INTO actions_categories (action_id, category_id) VALUES (580, 'ged_doc');
INSERT INTO actions_categories (action_id, category_id) VALUES (580, 'registeredMail');
INSERT INTO actions_categories (action_id, category_id) VALUES (586, 'incoming');
INSERT INTO actions_categories (action_id, category_id) VALUES (586, 'outgoing');
INSERT INTO actions_categories (action_id, category_id) VALUES (586, 'internal');
INSERT INTO actions_categories (action_id, category_id) VALUES (586, 'ged_doc');
INSERT INTO actions_categories (action_id, category_id) VALUES (586, 'registeredMail');
INSERT INTO actions_categories (action_id, category_id) VALUES (551, 'ged_doc');
INSERT INTO actions_categories (action_id, category_id) VALUES (551, 'incoming');
INSERT INTO actions_categories (action_id, category_id) VALUES (551, 'internal');
INSERT INTO actions_categories (action_id, category_id) VALUES (551, 'outgoing');
INSERT INTO actions_categories (action_id, category_id) VALUES (551, 'registeredMail');
INSERT INTO actions_categories (action_id, category_id) VALUES (584, 'ged_doc');
INSERT INTO actions_categories (action_id, category_id) VALUES (584, 'incoming');
INSERT INTO actions_categories (action_id, category_id) VALUES (584, 'internal');
INSERT INTO actions_categories (action_id, category_id) VALUES (584, 'outgoing');
INSERT INTO actions_categories (action_id, category_id) VALUES (584, 'registeredMail');
INSERT INTO actions_categories (action_id, category_id) VALUES (558, 'ged_doc');
INSERT INTO actions_categories (action_id, category_id) VALUES (558, 'incoming');
INSERT INTO actions_categories (action_id, category_id) VALUES (558, 'internal');
INSERT INTO actions_categories (action_id, category_id) VALUES (558, 'outgoing');
INSERT INTO actions_categories (action_id, category_id) VALUES (558, 'registeredMail');
INSERT INTO actions_categories (action_id, category_id) VALUES (565, 'incoming');
INSERT INTO actions_categories (action_id, category_id) VALUES (565, 'outgoing');
INSERT INTO actions_categories (action_id, category_id) VALUES (565, 'internal');
INSERT INTO actions_categories (action_id, category_id) VALUES (565, 'ged_doc');
INSERT INTO actions_categories (action_id, category_id) VALUES (565, 'registeredMail');
INSERT INTO actions_categories (action_id, category_id) VALUES (592, 'incoming');
INSERT INTO actions_categories (action_id, category_id) VALUES (592, 'outgoing');
INSERT INTO actions_categories (action_id, category_id) VALUES (592, 'internal');
INSERT INTO actions_categories (action_id, category_id) VALUES (592, 'ged_doc');
INSERT INTO actions_categories (action_id, category_id) VALUES (592, 'registeredMail');
INSERT INTO actions_categories (action_id, category_id) VALUES (545, 'ged_doc');
INSERT INTO actions_categories (action_id, category_id) VALUES (545, 'incoming');
INSERT INTO actions_categories (action_id, category_id) VALUES (545, 'internal');
INSERT INTO actions_categories (action_id, category_id) VALUES (545, 'outgoing');
INSERT INTO actions_categories (action_id, category_id) VALUES (545, 'registeredMail');
INSERT INTO actions_categories (action_id, category_id) VALUES (585, 'incoming');
INSERT INTO actions_categories (action_id, category_id) VALUES (585, 'outgoing');
INSERT INTO actions_categories (action_id, category_id) VALUES (585, 'internal');
INSERT INTO actions_categories (action_id, category_id) VALUES (585, 'ged_doc');
INSERT INTO actions_categories (action_id, category_id) VALUES (585, 'registeredMail');

DELETE FROM actions_groupbaskets;
INSERT INTO actions_groupbaskets (id_action, where_clause, group_id, basket_id, used_in_basketlist, used_in_action_page, default_action_list) VALUES
                                                                                                                                                  (577, '', 'DGS', 'ValAtrBasket', 'Y', 'Y', 'N'),
                                                                                                                                                  (552, '', 'DGS', 'ValAtrBasket', 'N', 'Y', 'Y'),
                                                                                                                                                  (554, '', 'DGS', 'ValAtrBasket', 'N', 'Y', 'N'),
                                                                                                                                                  (568, '', 'DGS', 'ValAtrBasket', 'Y', 'N', 'N'),
                                                                                                                                                  (565, '', 'DGS', 'ValAtrBasket', 'Y', 'N', 'N'),
                                                                                                                                                  (37, '', 'MAIRE', 'DdeAvisBasket', 'N', 'Y', 'Y'),
                                                                                                                                                  (20, '', 'AGENT', 'WaitBasket', 'Y', 'Y', 'Y'),
                                                                                                                                                  (545, '', 'AGENT', 'WaitBasket', 'Y', 'Y', 'N'),
                                                                                                                                                  (582, '', 'RESPONSABLE', 'LetterToPrint', 'Y', 'Y', 'Y'),
                                                                                                                                                  (577, '', 'ASSISTDGS', 'ValAtrDGSBasket', 'N', 'Y', 'N'),
                                                                                                                                                  (552, '', 'ASSISTDGS', 'ValAtrDGSBasket', 'N', 'Y', 'Y'),
                                                                                                                                                  (554, '', 'ASSISTDGS', 'ValAtrDGSBasket', 'N', 'Y', 'N'),
                                                                                                                                                  (568, '', 'ASSISTDGS', 'ValAtrDGSBasket', 'Y', 'N', 'N'),
                                                                                                                                                  (565, '', 'ASSISTDGS', 'ValAtrDGSBasket', 'Y', 'N', 'N'),
                                                                                                                                                  (20, '', 'RESPONSABLE', 'WaitBasket', 'Y', 'Y', 'Y'),
                                                                                                                                                  (582, '', 'AGENT', 'LetterToPrint', 'Y', 'Y', 'Y'),
                                                                                                                                                  (577, '', 'DIRECTEUR', 'ValAtrBasket', 'Y', 'Y', 'N'),
                                                                                                                                                  (554, '', 'DIRECTEUR', 'ValAtrBasket', 'N', 'Y', 'Y'),
                                                                                                                                                  (565, '', 'DIRECTEUR', 'ValAtrBasket', 'Y', 'N', 'N'),
                                                                                                                                                  (576, '', 'RESP_COURRIER', 'ValAtrBasket', 'Y', 'Y', 'N'),
                                                                                                                                                  (20, '', 'RESPONSABLE', 'WaitXPBasket', 'N', 'Y', 'Y'),
                                                                                                                                                  (20, '', 'AGENT', 'WaitXPBasket', 'N', 'Y', 'Y'),
                                                                                                                                                  (568, '', 'RESP_COURRIER', 'ValAtrBasket', 'Y', 'N', 'N'),
                                                                                                                                                  (566, '', 'RESP_COURRIER', 'ValAtrBasket', 'Y', 'N', 'N'),
                                                                                                                                                  (565, '', 'RESP_COURRIER', 'ValAtrBasket', 'Y', 'N', 'N'),
                                                                                                                                                  (583, '', 'AGENT', 'SuiviParafBasket', 'Y', 'N', 'Y'),
                                                                                                                                                  (1, '', 'AGENT', 'FindCopyMail', 'N', 'Y', 'Y'),
                                                                                                                                                  (20, '', 'AGENT', 'EenvBasket', 'Y', 'Y', 'Y'),
                                                                                                                                                  (37, '', 'AGENT', 'DdeAvisBasket', 'N', 'Y', 'Y'),
                                                                                                                                                  (114, '', 'AGENT', 'CopyMailBasket', 'Y', 'N', 'Y'),
                                                                                                                                                  (114, '', 'ELU', 'CopyMailBasket', 'Y', 'N', 'Y'),
                                                                                                                                                  (543, '', 'WEBSERVICE', 'RECBASKET', 'Y', 'Y', 'Y'),
                                                                                                                                                  (1, '', 'ELU', 'FindCopyMail', 'N', 'Y', 'Y'),
                                                                                                                                                  (114, '', 'DGS', 'CopyMailBasket', 'Y', 'N', 'Y'),
                                                                                                                                                  (37, '', 'DGS', 'DdeAvisBasket', 'N', 'Y', 'Y'),
                                                                                                                                                  (114, '', 'RESPONSABLE', 'CopyMailBasket', 'Y', 'N', 'Y'),
                                                                                                                                                  (5, '', 'AGENT', 'SupAvisBasket', 'Y', 'Y', 'Y'),
                                                                                                                                                  (5, '', 'RESPONSABLE', 'SupAvisBasket', 'Y', 'Y', 'Y'),
                                                                                                                                                  (5, '', 'RESPONSABLE', 'RetAvisBasket', 'Y', 'Y', 'Y'),
                                                                                                                                                  (583, '', 'RESPONSABLE', 'SuiviParafBasket', 'Y', 'N', 'Y'),
                                                                                                                                                  (114, '', 'MAIRE', 'CopyMailBasket', 'Y', 'N', 'Y'),
                                                                                                                                                  (1, '', 'MAIRE', 'FindCopyMail', 'N', 'Y', 'Y'),
                                                                                                                                                  (5, '', 'AGENT', 'RetAvisBasket', 'Y', 'Y', 'Y'),
                                                                                                                                                  (1, '', 'DGS', 'FindCopyMail', 'N', 'Y', 'Y'),
                                                                                                                                                  (37, '', 'RESPONSABLE', 'DdeAvisBasket', 'N', 'Y', 'Y'),
                                                                                                                                                  (20, '', 'RESPONSABLE', 'EenvBasket', 'Y', 'Y', 'Y'),
                                                                                                                                                  (1, '', 'RESPONSABLE', 'FindCopyMail', 'N', 'Y', 'Y'),
                                                                                                                                                  (552, '', 'RESP_COURRIER', 'ValAtrBasket', 'N', 'Y', 'N'),
                                                                                                                                                  (553, '', 'RESP_COURRIER', 'ValAtrBasket', 'N', 'Y', 'N'),
                                                                                                                                                  (554, '', 'RESP_COURRIER', 'ValAtrBasket', 'N', 'Y', 'Y'),
                                                                                                                                                  (551, '', 'COURRIER', 'SVEToQualify', 'N', 'Y', 'N'),
                                                                                                                                                  (6, '', 'COURRIER', 'SVEToQualify', 'Y', 'N', 'N'),
                                                                                                                                                  (18, '', 'COURRIER', 'SVEToQualify', 'N', 'Y', 'Y'),
                                                                                                                                                  (20, '', 'COURRIER', 'ManualReconBasket', 'Y', 'N', 'N'),
                                                                                                                                                  (571, '', 'COURRIER', 'ManualReconBasket', 'Y', 'N', 'Y'),
                                                                                                                                                  (551, '', 'COURRIER', 'RetourCourrier', 'N', 'Y', 'Y'),
                                                                                                                                                  (6, '', 'COURRIER', 'RetourCourrier', 'Y', 'N', 'N'),
                                                                                                                                                  (18, '', 'COURRIER', 'RetourCourrier', 'N', 'Y', 'N'),
                                                                                                                                                  (20, '', 'ASSISTCAB', 'SuivSignalDailyBasket', 'N', 'Y', 'Y'),
                                                                                                                                                  (545, '', 'RESPONSABLE', 'WaitBasket', 'Y', 'Y', 'N'),
                                                                                                                                                  (587, '', 'MAIRE', 'ParafBasket', 'N', 'Y', 'Y'),
                                                                                                                                                  (559, 'status in (''EVIS'',''ESIG'')
    AND (
        SELECT COUNT(*)
        FROM listinstance
        WHERE res_id=res_view_letterbox.res_id
        AND difflist_type=''VISA_CIRCUIT''
        AND process_date IS NOT NULL
        AND listinstance_id < (
  SELECT listinstance_id
  FROM listinstance
  WHERE process_date IS NULL
  AND res_id=res_view_letterbox.res_id
  AND difflist_type=''VISA_CIRCUIT''
  ORDER BY listinstance_id ASC LIMIT 1)
        GROUP BY listinstance_id ORDER BY listinstance_id DESC LIMIT 1)
    IN (''1'')', 'MAIRE', 'ParafBasket', 'N', 'Y', 'N'),
                                                                                                                                                  (20, '', 'DGS', 'DepartmentBasket', 'N', 'Y', 'Y'),
                                                                                                                                                  (20, '', 'RESPONSABLE', 'DepartmentBasket', 'N', 'Y', 'Y'),
                                                                                                                                                  (543, '', 'COURRIER', 'RECBASKET', 'Y', 'Y', 'Y'),
                                                                                                                                                  (556, '', 'MAIRE', 'ParafBasket', 'N', 'Y', 'N'),
                                                                                                                                                  (36, '', 'AGENT', 'DdeAvisDepasse', 'N', 'Y', 'Y'),
                                                                                                                                                  (5, '', 'AGENT', 'DdeAvisDepasse', 'Y', 'Y', 'N'),
                                                                                                                                                  (36, '', 'RESPONSABLE', 'DdeAvisDepasse', 'N', 'Y', 'Y'),
                                                                                                                                                  (5, '', 'RESPONSABLE', 'DdeAvisDepasse', 'Y', 'Y', 'N'),
                                                                                                                                                  (590, '', 'AGENT', 'FindDdeAvisBasket', 'Y', 'Y', 'Y'),
                                                                                                                                                  (590, '', 'RESPONSABLE', 'FindDdeAvisBasket', 'Y', 'Y', 'Y'),
                                                                                                                                                  (587, '', 'DGS', 'SignBasket', 'N', 'Y', 'Y'),
                                                                                                                                                  (559, 'status in (''EVIS'',''ESIG'')
    AND (
        SELECT COUNT(*)
        FROM listinstance
        WHERE res_id=res_view_letterbox.res_id
        AND difflist_type=''VISA_CIRCUIT''
        AND process_date IS NOT NULL
        AND listinstance_id < (
  SELECT listinstance_id
  FROM listinstance
  WHERE process_date IS NULL
  AND res_id=res_view_letterbox.res_id
  AND difflist_type=''VISA_CIRCUIT''
  ORDER BY listinstance_id ASC LIMIT 1)
        GROUP BY listinstance_id ORDER BY listinstance_id DESC LIMIT 1)
    IN (''1'')', 'DGS', 'SignBasket', 'N', 'Y', 'N'),
                                                                                                                                                  (556, '', 'DGS', 'SignBasket', 'N', 'Y', 'N'),
                                                                                                                                                  (587, '', 'MAIRE', 'SignBasket', 'N', 'Y', 'Y'),
                                                                                                                                                  (587, '(   SELECT item_id
    FROM listinstance
    WHERE process_date IS NULL
    AND res_view_letterbox.res_id=res_id
    AND difflist_type=''VISA_CIRCUIT''
    ORDER BY listinstance_id ASC LIMIT 1)
IN (
    SELECT item_id
    FROM listinstance
    WHERE difflist_type = ''VISA_CIRCUIT''
    and item_mode=''sign''
    and res_view_letterbox.res_id=res_id order by sequence desc LIMIT 1)', 'DGS', 'ParafBasket', 'N', 'Y', 'N'),
                                                                                                                                                  (559, 'status in (''EVIS'',''ESIG'')
    AND (
        SELECT COUNT(*)
        FROM listinstance
        WHERE res_id=res_view_letterbox.res_id
        AND difflist_type=''VISA_CIRCUIT''
        AND process_date IS NOT NULL
        AND listinstance_id < (
  SELECT listinstance_id
  FROM listinstance
  WHERE process_date IS NULL
  AND res_id=res_view_letterbox.res_id
  AND difflist_type=''VISA_CIRCUIT''
  ORDER BY listinstance_id ASC LIMIT 1)
        GROUP BY listinstance_id ORDER BY listinstance_id DESC LIMIT 1)
    IN (''1'')', 'MAIRE', 'SignBasket', 'N', 'Y', 'N'),
                                                                                                                                                  (556, '', 'MAIRE', 'SignBasket', 'N', 'Y', 'N'),
                                                                                                                                                  (587, '', 'RESPONSABLE', 'SignBasket', 'N', 'Y', 'Y'),
                                                                                                                                                  (559, 'status in (''EVIS'',''ESIG'')
    AND (
        SELECT COUNT(*)
        FROM listinstance
        WHERE res_id=res_view_letterbox.res_id
        AND difflist_type=''VISA_CIRCUIT''
        AND process_date IS NOT NULL
        AND listinstance_id < (
  SELECT listinstance_id
  FROM listinstance
  WHERE process_date IS NULL
  AND res_id=res_view_letterbox.res_id
  AND difflist_type=''VISA_CIRCUIT''
  ORDER BY listinstance_id ASC LIMIT 1)
        GROUP BY listinstance_id ORDER BY listinstance_id DESC LIMIT 1)
    IN (''1'')', 'RESPONSABLE', 'SignBasket', 'N', 'Y', 'N'),
                                                                                                                                                  (556, '', 'RESPONSABLE', 'SignBasket', 'N', 'Y', 'N'),
                                                                                                                                                  (592, '', 'AGENT', 'MyBasket', 'N', 'Y', 'N'),
                                                                                                                                                  (593, '', 'AGENT', 'MyBasket', 'N', 'Y', 'N'),
                                                                                                                                                  (20, '', 'AGENT', 'MyBasket', 'Y', 'Y', 'N'),
                                                                                                                                                  (569, '', 'AGENT', 'MyBasket', 'N', 'Y', 'N'),
                                                                                                                                                  (558, '', 'AGENT', 'MyBasket', 'N', 'Y', 'Y'),
                                                                                                                                                  (36, '', 'AGENT', 'MyBasket', 'N', 'Y', 'N'),
                                                                                                                                                  (594, '', 'AGENT', 'MyBasket', 'N', 'Y', 'N'),
                                                                                                                                                  (570, '', 'AGENT', 'MyBasket', 'N', 'Y', 'N'),
                                                                                                                                                  (590, '', 'AGENT', 'MyBasket', 'N', 'Y', 'N'),
                                                                                                                                                  (405, 'status in (''EVIS'')
    AND (
        SELECT item_mode
        FROM listinstance
        WHERE listinstance_id > (
  SELECT listinstance_id
  FROM listinstance
  WHERE process_date IS NULL
  AND res_id=res_view_letterbox.res_id
  AND difflist_type=''VISA_CIRCUIT''
  ORDER BY listinstance_id ASC LIMIT 1)
        ORDER BY listinstance_id ASC LIMIT 1)
    NOT IN (''sign'')
    AND (
        SELECT COUNT(*)
        FROM listinstance
        WHERE res_id=res_view_letterbox.res_id
        AND difflist_type=''VISA_CIRCUIT'')
    NOT IN (''1'')', 'RESPONSABLE', 'ParafBasket', 'N', 'Y', 'Y'),
                                                                                                                                                  (580, 'status in (''EVIS'')
AND (
    SELECT item_id
    FROM listinstance
    WHERE difflist_type = ''VISA_CIRCUIT''
    and item_mode=''visa''
    and res_id=res_view_letterbox.res_id
    order by sequence desc LIMIT 1)
IN (
    SELECT item_id
    FROM listinstance
    WHERE process_date IS NULL
    AND res_view_letterbox.res_id=res_id
    AND difflist_type=''VISA_CIRCUIT''
    ORDER BY listinstance_id ASC LIMIT 1)', 'RESPONSABLE', 'ParafBasket', 'N', 'Y', 'N'),
                                                                                                                                                  (585, 'status in (''EVIS'')
AND (
    SELECT item_id
    FROM listinstance
    WHERE difflist_type = ''VISA_CIRCUIT''
    and item_mode=''visa''
    and res_id=res_view_letterbox.res_id
    order by sequence desc LIMIT 1)
IN (
    SELECT item_id
    FROM listinstance
    WHERE process_date IS NULL
    AND res_view_letterbox.res_id=res_id
    AND difflist_type=''VISA_CIRCUIT''
    ORDER BY listinstance_id ASC LIMIT 1)', 'RESPONSABLE', 'ParafBasket', 'N', 'Y', 'N'),
                                                                                                                                                  (586, 'status in (''EVIS'')
AND (
    SELECT item_id
    FROM listinstance
    WHERE difflist_type = ''VISA_CIRCUIT''
    and item_mode=''visa''
    and res_id=res_view_letterbox.res_id
    order by sequence desc LIMIT 1)
IN (
    SELECT item_id
    FROM listinstance
    WHERE process_date IS NULL
    AND res_view_letterbox.res_id=res_id
    AND difflist_type=''VISA_CIRCUIT''
    ORDER BY listinstance_id ASC LIMIT 1)', 'RESPONSABLE', 'ParafBasket', 'N', 'Y', 'N'),
                                                                                                                                                  (559, 'status in (''EVIS'',''ESIG'')
    AND (
        SELECT COUNT(*)
        FROM listinstance
        WHERE res_id=res_view_letterbox.res_id
        AND difflist_type=''VISA_CIRCUIT''
        AND process_date IS NOT NULL
        AND listinstance_id < (
  SELECT listinstance_id
  FROM listinstance
  WHERE process_date IS NULL
  AND res_id=res_view_letterbox.res_id
  AND difflist_type=''VISA_CIRCUIT''
  ORDER BY listinstance_id ASC LIMIT 1)
        GROUP BY listinstance_id ORDER BY listinstance_id DESC LIMIT 1)
    IN (''1'')', 'RESPONSABLE', 'ParafBasket', 'N', 'Y', 'N'),
                                                                                                                                                  (556, '', 'RESPONSABLE', 'ParafBasket', 'N', 'Y', 'N'),
                                                                                                                                                  (405, 'status in (''EVIS'')
    AND (
        SELECT item_mode
        FROM listinstance
        WHERE listinstance_id > (
  SELECT listinstance_id
  FROM listinstance
  WHERE process_date IS NULL
  AND res_id=res_view_letterbox.res_id
  AND difflist_type=''VISA_CIRCUIT''
  ORDER BY listinstance_id ASC LIMIT 1)
        ORDER BY listinstance_id ASC LIMIT 1)
    NOT IN (''sign'')
    AND (
        SELECT COUNT(*)
        FROM listinstance
        WHERE res_id=res_view_letterbox.res_id
        AND difflist_type=''VISA_CIRCUIT'')
    NOT IN (''1'')', 'DGS', 'ParafBasket', 'N', 'Y', 'N'),
                                                                                                                                                  (580, 'status in (''EVIS'')
AND (
    SELECT item_id
    FROM listinstance
    WHERE difflist_type = ''VISA_CIRCUIT''
    and item_mode=''visa''
    and res_id=res_view_letterbox.res_id
    order by sequence desc LIMIT 1)
IN (
    SELECT item_id
    FROM listinstance
    WHERE process_date IS NULL
    AND res_view_letterbox.res_id=res_id
    AND difflist_type=''VISA_CIRCUIT''
    ORDER BY listinstance_id ASC LIMIT 1)', 'DGS', 'ParafBasket', 'N', 'Y', 'N'),
                                                                                                                                                  (592, '', 'RESPONSABLE', 'MyBasket', 'N', 'Y', 'N'),
                                                                                                                                                  (593, '', 'RESPONSABLE', 'MyBasket', 'N', 'Y', 'N'),
                                                                                                                                                  (20, '', 'RESPONSABLE', 'MyBasket', 'Y', 'Y', 'N'),
                                                                                                                                                  (569, '', 'RESPONSABLE', 'MyBasket', 'N', 'Y', 'N'),
                                                                                                                                                  (558, '', 'RESPONSABLE', 'MyBasket', 'N', 'Y', 'Y'),
                                                                                                                                                  (36, '', 'RESPONSABLE', 'MyBasket', 'N', 'Y', 'N'),
                                                                                                                                                  (594, '', 'RESPONSABLE', 'MyBasket', 'N', 'Y', 'N'),
                                                                                                                                                  (570, '', 'RESPONSABLE', 'MyBasket', 'N', 'Y', 'N'),
                                                                                                                                                  (590, '', 'RESPONSABLE', 'MyBasket', 'N', 'Y', 'N'),
                                                                                                                                                  (585, 'status in (''EVIS'')
AND (
    SELECT item_id
    FROM listinstance
    WHERE difflist_type = ''VISA_CIRCUIT''
    and item_mode=''visa''
    and res_id=res_view_letterbox.res_id
    order by sequence desc LIMIT 1)
IN (
    SELECT item_id
    FROM listinstance
    WHERE process_date IS NULL
    AND res_view_letterbox.res_id=res_id
    AND difflist_type=''VISA_CIRCUIT''
    ORDER BY listinstance_id ASC LIMIT 1)', 'DGS', 'ParafBasket', 'N', 'Y', 'Y'),
                                                                                                                                                  (586, 'status in (''EVIS'')
AND (
    SELECT item_id
    FROM listinstance
    WHERE difflist_type = ''VISA_CIRCUIT''
    and item_mode=''visa''
    and res_id=res_view_letterbox.res_id
    order by sequence desc LIMIT 1)
IN (
    SELECT item_id
    FROM listinstance
    WHERE process_date IS NULL
    AND res_view_letterbox.res_id=res_id
    AND difflist_type=''VISA_CIRCUIT''
    ORDER BY listinstance_id ASC LIMIT 1)', 'DGS', 'ParafBasket', 'N', 'Y', 'N'),
                                                                                                                                                  (591, 'type_label in (''- Sélectionner un type de document -'')', 'COURRIER', 'QualificationBasket', 'N', 'Y', 'N'),
                                                                                                                                                  (559, 'status in (''EVIS'',''ESIG'')
    AND (
        SELECT COUNT(*)
        FROM listinstance
        WHERE res_id=res_view_letterbox.res_id
        AND difflist_type=''VISA_CIRCUIT''
        AND process_date IS NOT NULL
        AND listinstance_id < (
  SELECT listinstance_id
  FROM listinstance
  WHERE process_date IS NULL
  AND res_id=res_view_letterbox.res_id
  AND difflist_type=''VISA_CIRCUIT''
  ORDER BY listinstance_id ASC LIMIT 1)
        GROUP BY listinstance_id ORDER BY listinstance_id DESC LIMIT 1)
    IN (''1'')', 'DGS', 'ParafBasket', 'N', 'Y', 'N'),
                                                                                                                                                  (556, '', 'DGS', 'ParafBasket', 'N', 'Y', 'N'),
                                                                                                                                                  (589, '', 'SERVICE', 'ServiceBasket', 'Y', 'Y', 'N'),
                                                                                                                                                  (592, '', 'SERVICE', 'ServiceBasket', 'N', 'Y', 'Y'),
                                                                                                                                                  (593, '', 'SERVICE', 'ServiceBasket', 'N', 'Y', 'N'),
                                                                                                                                                  (20, '', 'SERVICE', 'ServiceBasket', 'N', 'Y', 'N'),
                                                                                                                                                  (576, '', 'SERVICE', 'ServiceBasket', 'N', 'Y', 'N'),
                                                                                                                                                  (551, 'type_label not in (''- Sélectionner un type de document -'')', 'COURRIER', 'QualificationBasket', 'N', 'Y', 'Y'),
                                                                                                                                                  (6, '', 'COURRIER', 'QualificationBasket', 'Y', 'N', 'N'),
                                                                                                                                                  (18, 'type_label not in (''- Sélectionner un type de document -'')', 'COURRIER', 'QualificationBasket', 'N', 'Y', 'N'),
                                                                                                                                                  (591, 'type_label in (''- Sélectionner un type de document -'')', 'COURRIER', 'EmailToQualify', 'N', 'Y', 'N'),
                                                                                                                                                  (551, 'type_label NOT IN (''- Sélectionner un type de document -'')', 'COURRIER', 'EmailToQualify', 'N', 'Y', 'Y'),
                                                                                                                                                  (6, '', 'COURRIER', 'EmailToQualify', 'Y', 'N', 'N'),
                                                                                                                                                  (18, 'type_label NOT IN (''- Sélectionner un type de document -'')', 'COURRIER', 'EmailToQualify', 'N', 'Y', 'N');

DELETE FROM attachment_types;
INSERT INTO attachment_types (id, type_id, label, visible, email_link, signable, signed_by_default, icon, chrono, version_enabled, new_version_default) VALUES (2, 'response_project', 'Projet de réponse', true, true, true, false, 'R', true, true, true);
INSERT INTO attachment_types (id, type_id, label, visible, email_link, signable, signed_by_default, icon, chrono, version_enabled, new_version_default) VALUES (3, 'signed_response', 'Réponse signée', false, true, false, false, '', true, true, true);
INSERT INTO attachment_types (id, type_id, label, visible, email_link, signable, signed_by_default, icon, chrono, version_enabled, new_version_default) VALUES (7, 'summary_sheet', 'Fiche de liaison', false, false, false, false, '', true, true, true);
INSERT INTO attachment_types (id, type_id, label, visible, email_link, signable, signed_by_default, icon, chrono, version_enabled, new_version_default) VALUES (8, 'acknowledgement_record_management', 'Accusé de réception (Archivage)', false, false, false, false, '', true, true, true);
INSERT INTO attachment_types (id, type_id, label, visible, email_link, signable, signed_by_default, icon, chrono, version_enabled, new_version_default) VALUES (9, 'reply_record_management', 'Réponse au transfert (Archivage)', false, false, false, false, '', true, true, true);
INSERT INTO attachment_types (id, type_id, label, visible, email_link, signable, signed_by_default, icon, chrono, version_enabled, new_version_default) VALUES (10, 'shipping_deposit_proof', 'Preuve de dépôt Maileva', false, false, false, false, 'M', false, false, false);
INSERT INTO attachment_types (id, type_id, label, visible, email_link, signable, signed_by_default, icon, chrono, version_enabled, new_version_default) VALUES (11, 'shipping_acknowledgement_of_receipt', 'Accusé de réception Maileva', false, false, false, false, 'M', false, false, false);
INSERT INTO attachment_types (id, type_id, label, visible, email_link, signable, signed_by_default, icon, chrono, version_enabled, new_version_default) VALUES (4, 'simple_attachment', 'Pièce jointe', true, false, false, false, 'PJ', false, true, true);
INSERT INTO attachment_types (id, type_id, label, visible, email_link, signable, signed_by_default, icon, chrono, version_enabled, new_version_default) VALUES (5, 'incoming_mail_attachment', 'Pièce jointe capturée', false, false, false, false, '', false, true, true);
INSERT INTO attachment_types (id, type_id, label, visible, email_link, signable, signed_by_default, icon, chrono, version_enabled, new_version_default) VALUES (6, 'outgoing_mail', 'Courrier départ spontané', true, false, true, false, 'DS', true, true, true);
-- EDISSYUM - NCH01 Module Open-Capture For MEM
INSERT INTO attachment_types (id, type_id, label, visible, email_link, signable, signed_by_default, icon, chrono, version_enabled, new_version_default) VALUES (13, 'outgoing_mail_signed', 'Courrier départ signé', true, true, true, true, 'R', true, true, false);
-- END EDISSYUM - NCH01
INSERT INTO attachment_types (id, type_id, label, visible, email_link, signable, signed_by_default, icon, chrono, version_enabled, new_version_default) VALUES (14, 'simple_attachment_tosign', 'PJ à signer', true, true, true, false, 'PJ', false, false, false); -- EDISSYUM mise à jour data_fr comme MEM 23
INSERT INTO attachment_types (id, type_id, label, visible, email_link, signable, signed_by_default, icon, chrono, version_enabled, new_version_default) VALUES (15, 'simple_attachment_notosign', 'PJ sans signature requise', true, false, false, false, 'PJ',  false, false, false); -- EDISSYUM mise à jour data_fr comme MEM 23
INSERT INTO attachment_types (id, type_id, label, visible, email_link, signable, signed_by_default, icon, chrono, version_enabled, new_version_default) VALUES (16, 'outgoing_signed', 'Courrier départ signé', true, true, false, true, '', false, false, false); -- EDISSYUM mise à jour data_fr comme MEM 23

DELETE FROM baskets;
INSERT INTO baskets (id, coll_id, basket_id, basket_name, basket_desc, basket_clause, is_visible, enabled, basket_order, color, basket_res_order, flag_notif) VALUES
                                                                                                                                                                  (2, 'letterbox_coll', 'ValAtrBasket', 'Attribution à valider', 'Courriers dont je dois valider l''orientation', '((status = ''VALS'' AND @user_id IN (SELECT user_id FROM usergroup_content WHERE GROUP_id = 3))
    OR (status = ''VALDIR'' AND @user_id IN (SELECT user_id FROM usergroup_content WHERE GROUP_id = 21))
    OR (status = ''VALDGS'' AND @user_id IN (SELECT user_id FROM usergroup_content WHERE GROUP_id = 7))) AND (DESTINATION IN (@my_entities,@subentities[@my_entities]))', 'Y', 'Y', 4, NULL, 'res_id asc', 'N'),
                                                                                                                                                                  (56, 'letterbox_coll', 'QualifiedBasket', 'Courriers qualifiés (48h)', 'Courriers entrants qualifiés depuis moins de 48h', 'creation_date>((NOW() - INTERVAL ''2 day'')) and status not in (''INIT'',''MAQUAL'',''ATTSVE'',''DEL'') and category_id=''incoming''', 'Y', 'Y', 29, NULL, 'creation_date desc', 'N'),
                                                                                                                                                                  (44, 'letterbox_coll', 'WaitXPBasket', 'Mes courriers en attente dans le parapheur électronique', 'Mes courriers en attente dans le parapheur électronique', 'status=''PARAPHWAIT'' AND dest_user=@user_id', 'Y', 'Y', 15, NULL, 'creation_date desc', 'N'),
                                                                                                                                                                  (16, 'letterbox_coll', 'ParafBasket', 'Courriers à viser', 'Courriers à viser', 'status in (''EVIS'') AND ((res_id, @user_id) IN (SELECT res_id, item_id FROM listinstance WHERE difflist_type IN (''VISA_CIRCUIT'') and process_date ISNULL and res_view_letterbox.res_id = res_id order by listinstance_id asc limit 1)) AND (SELECT COUNT(*) FROM listinstance WHERE res_id=res_view_letterbox.res_id AND difflist_type=''VISA_CIRCUIT'') NOT IN (''1'')', 'Y', 'Y', 5, NULL, 'res_id desc', 'Y'),  -- EDISSYUM - AMO01 Modification clause bannette courriers à viser
                                                                                                                                                                  (33, 'letterbox_coll', 'ManualReconBasket', 'Courriers réconciliés manuellement à clôturer', 'Courriers réconciliés manuellement à e-envoyer / à clôturer', 'status IN (''WAIT'', ''NEW'',''IMP'') AND (res_id IN (SELECT res_id_master FROM res_attachments WHERE attachment_type=''signed_response'' AND typist NOT IN (SELECT id FROM users WHERE status <>''DEL'' AND MODE=''rest'')) OR res_id IN (SELECT RL.res_id FROM res_letterbox RL INNER JOIN adr_letterbox AL ON RL.res_id=AL.res_id WHERE AL.type=''SIGN''))', 'Y', 'Y', 20, NULL, 'res_id asc', 'N'),
                                                                                                                                                                  (9, 'letterbox_coll', 'DdeAvisBasket', 'Avis : Avis à émettre', 'Courriers nécessitant un avis', 'status = ''EAVIS'' AND res_id IN (SELECT res_id FROM listinstance WHERE item_type = ''user_id'' AND item_id = @user_id AND item_mode = ''avis'' and process_date is NULL) and opinion_limit_date > now()', 'Y', 'Y', 10, NULL, 'res_id desc', 'Y'),
                                                                                                                                                                  (29, 'letterbox_coll', 'ServiceBasket', 'Courriers à dispatcher', 'Bannette commune de service', '(STATUS IN (''NEW'', ''COU'', ''REJ_SIGN'', ''REJ_VISA'') and UPPER((SELECT user_id FROM users WHERE dest_user=users.id)) in (SELECT UPPER(entity_id) FROM users_entities WHERE user_id=@user_id))', 'Y', 'Y', 21, NULL, 'creation_date desc', 'Y'),
                                                                                                                                                                  (8, 'letterbox_coll', 'RetourCourrier', 'Courriers à corriger', 'Courriers à corriger', 'STATUS=''RET''', 'Y', 'Y', 3, NULL, 'res_id desc', 'N'),
                                                                                                                                                                  (30, 'letterbox_coll', 'EmailToQualify', '@MAILS à qualifier', 'Emails à qualifier', 'status=''MAQUAL''', 'Y', 'Y', 1, NULL, 'creation_date asc', 'N'),
                                                                                                                                                                  (5, 'letterbox_coll', 'CopyMailBasket', 'Courriers en copie', 'Courriers en copie', '(res_id in (select res_id from listinstance WHERE item_type = ''user_id'' and item_id = @user_id and item_mode = ''cc'') or res_id in (select res_id from listinstance WHERE item_type = ''entity_id'' and item_mode = ''cc'' and item_id in (@my_entities_id)) or res_id in (select li.res_id from listinstance li WHERE li.item_type = ''user_id'' and li.item_mode = ''cc'' and (SELECT UPPER(user_id) from users WHERE id=li.item_id) in (SELECT UPPER(entity_id) FROM users_entities WHERE user_id=@user_id))) and status not in (''DEL'', ''VALS'', ''VALDGS'', ''VALDIR'', ''INIT'', ''MAQUAL'', ''RET'') and res_id not in (select res_id from res_mark_as_read WHERE user_id = @user_id)', 'Y', 'Y', 9, NULL, 'res_id desc', 'Y'),
                                                                                                                                                                  (32, 'letterbox_coll', 'WaitBasket', 'Mes courriers en attente de signature manuscrite', 'Mes courriers dans le parapheur papier en attente de signature', 'status=''WAIT'' and dest_user = @user_id', 'Y', 'Y', 17, NULL, 'creation_date desc', 'N'),
                                                                                                                                                                  (3, 'letterbox_coll', 'EenvBasket', 'Mes courriers à envoyer / clôturer', 'Courriers visés/signés prêts à être envoyés', 'status=''EENV'' and dest_user = @user_id', 'Y', 'Y', 18, NULL, 'res_id desc', 'Y'),
                                                                                                                                                                  (28, 'letterbox_coll', 'RECBASKET', 'Courriers à réconcilier (échec)', 'Courriers à réconcilier manuellement (ou à supprimer si erreur de scan ou si le document est déjà reconcilié)', 'status = ''ATTREC''', 'Y', 'Y', 19, NULL, 'res_id asc', 'N'),
                                                                                                                                                                  (58, 'letterbox_coll', 'FindDdeAvisBasket', 'Recherche Demande d''avis (recherche)', 'Permet de retrouver les courriers pour lesquels on a sollicité mon avis dans la recherche', 'res_id IN (SELECT res_id FROM listinstance WHERE item_type = ''user_id'' AND item_id = @user_id AND item_mode = ''avis'')', 'N', 'Y', NULL, NULL, 'res_id asc', 'N'),
                                                                                                                                                                  (57, 'letterbox_coll', 'DdeAvisDepasse', 'Avis : Délai dépassé', 'Avis : Délai dépassé', 'opinion_limit_date < now() and status=''EAVIS'' and (dest_user = @user_id)', 'Y', 'Y', 13, NULL, 'res_id asc', 'N'),
                                                                                                                                                                  (10, 'letterbox_coll', 'SupAvisBasket', 'Avis : En attente de réponse de la part des autres', 'Courriers en attente d''avis', 'status=''EAVIS'' and (DEST_USER = @user_id)  and res_id NOT IN (SELECT res_id FROM listinstance WHERE item_mode = ''avis'' and difflist_type = ''entity_id'' and process_date is not NULL and res_view_letterbox.res_id = res_id group by res_id) AND res_id IN (SELECT res_id FROM listinstance WHERE item_mode = ''avis'' and difflist_type = ''entity_id'' and process_date is NULL and res_view_letterbox.res_id = res_id group by res_id) and opinion_limit_date > now()', 'Y', 'Y', 11, NULL, 'res_id desc', 'N'),
                                                                                                                                                                  (49, 'letterbox_coll', 'SVEToQualify', 'Saisines du formulaire', 'Saisines du formulaire', 'status=''ATTSVE''', 'Y', 'Y', 2, NULL, 'res_id asc', 'N'),
                                                                                                                                                                  (1, 'letterbox_coll', 'QualificationBasket', 'Courriers à qualifier', 'Bannette de qualification', 'status IN (''INIT'')', 'Y', 'Y', 0, NULL, 'res_id asc', 'N'),
                                                                                                                                                                  (27, 'letterbox_coll', 'FindCopyMail', 'Recherche Courrier en copie (recherche)', 'Recherche Courrier en copie', '(res_id in (select res_id from listinstance WHERE item_type = ''user_id'' and item_id = @user_id and item_mode = ''cc'') or res_id in (select res_id from listinstance WHERE item_type = ''entity_id'' and item_mode = ''cc'' and item_id in (@my_entities_id)) or res_id in (select li.res_id from listinstance li WHERE li.item_type = ''user_id'' and li.item_mode = ''cc'' and (SELECT UPPER(user_id) from users WHERE id=li.item_id) in (SELECT UPPER(entity_id) FROM users_entities WHERE user_id=@user_id))) and status not in (''DEL'', ''VALS'', ''VALDGS'', ''VALDIR'', ''INIT'', ''MAQUAL'',''RET'')', 'N', 'Y', NULL, NULL, 'res_id asc', 'N'),
                                                                                                                                                                  (48, 'letterbox_coll', 'ValAtrDGSBasket', 'Attribution à valider par le DGS', 'Courriers dont je dois valider l''orientation à la place du DGS', 'status = ''VALDGS'' AND @user_id IN (SELECT user_id FROM usergroup_content WHERE GROUP_id =25)', 'Y', 'Y', 22, NULL, 'res_id asc', 'N'),
                                                                                                                                                                  (50, 'letterbox_coll', 'ModifDGSBasket', '[SUPERVISION] Courriers modifiés par le DGS', 'Courriers modifiés par le DGS il y a moins de 8 jours', 'status IN (''NEW'', ''COU'') AND res_id::VARCHAR IN (SELECT record_id FROM history WHERE user_id IN (SELECT user_id FROM usergroup_content WHERE GROUP_id IN (7,25)) AND event_id IN (''diffdestuser'', ''diffcopy'') AND (event_date > (now() - interval ''8 day'')))', 'Y', 'Y', 23, NULL, 'res_id asc', 'N'),
                                                                                                                                                                  (17, 'letterbox_coll', 'SuiviParafBasket', '[SUIVI] Mes courriers en circuit de visa/signature', 'Courriers en circulation dans les parapheurs électroniques', 'status in (''ESIG'', ''EVIS'') AND dest_user = @user_id', 'Y', 'Y', 14, NULL, 'res_id desc', 'N'),
                                                                                                                                                                  (51, 'letterbox_coll', 'ModifSupervisBasket', '[SUPERVISION] Courriers modifiés par Superviseur', 'Courriers modifiés par Superviseur il y a moins de 8 jours', 'status IN (''NEW'', ''COU'') AND res_id::VARCHAR IN (SELECT record_id FROM history WHERE user_id IN (SELECT user_id FROM usergroup_content WHERE GROUP_id=3) AND event_id IN (''diffdestuser'', ''diffcopy'') AND (event_date > (now() - interval ''8 day'')))', 'Y', 'Y', 24, NULL, 'res_id asc', 'N'),
                                                                                                                                                                  (55, 'letterbox_coll', 'DelBasket', 'Courriers supprimés (24h)', 'Courriers supprimés (24h)', 'creation_date>((NOW() - INTERVAL ''1 day'')) and status=''DEL''', 'Y', 'Y', 28, NULL, 'res_id desc', 'N'),
                                                                                                                                                                  (4, 'letterbox_coll', 'MyBasket', 'Courriers à traiter', 'Bannette de traitement', 'status in (''NEW'', ''COU'', ''REJ_SIGN'', ''REJ_VISA'') and dest_user = @user_id', 'Y', 'Y', 8, NULL, 'res_id desc', 'Y'),
                                                                                                                                                                  (11, 'letterbox_coll', 'RetAvisBasket', 'Avis : retour(s) de la part des autres', 'Courriers avec avis reçus', 'status=''EAVIS'' and DEST_USER = @user_id and res_id IN (SELECT res_id FROM listinstance WHERE item_mode = ''avis'' and difflist_type = ''entity_id'' and process_date is not NULL and res_view_letterbox.res_id = res_id group by res_id) and opinion_limit_date > now()', 'Y', 'Y', 12, NULL, 'res_id desc', 'Y'),
                                                                                                                                                                  (31, 'letterbox_coll', 'LetterToPrint', 'Mes courriers visés à imprimer pour signature manuscrite', 'Mes courriers visés à imprimer pour signature manuscrite', 'status = ''IMP'' and dest_user = @user_id', 'Y', 'Y', 16, NULL, 'creation_date desc', 'N'),
                                                                                                                                                                  (15, 'letterbox_coll', 'DepartmentBasket', '[SUPERVISION] Courriers en cours', 'Bannette de supervision', 'DESTINATION IN (@my_entities, @subentities[@my_entities]) AND status IN (''NEW'',''COU'',''EVIS'',''ESIG'',''EAVIS'',''EENV'',''WAIT'',''REJ_SIGN'',''REJ_VISA'',''IMP'',''PARAPHWAIT'')', 'Y', 'Y', 7, NULL, 'res_id desc', 'N'),
                                                                                                                                                                  (53, 'letterbox_coll', 'SuivSignalDirBasket', '[SUPERVISION] Courriers signalés', '[SUPERVISION] Courriers signalés', 'DESTINATION IN (@my_entities, @subentities[@my_entities]) AND status IN (''NEW'',''COU'',''EVIS'',''ESIG'',''EAVIS'',''EENV'',''WAIT'',''REJ_SIGN'',''REJ_VISA'',''IMP'',''PARAPHWAIT'') and custom_fields#>>''{"10"}''=''Signalé''', 'Y', 'Y', 25, NULL, 'res_id desc', 'N'),
                                                                                                                                                                  (52, 'letterbox_coll', 'SuivNoSignalDirBasket', '[SUPERVISION] Courriers non signalés', '[SUPERVISION] Courriers non signalés', 'DESTINATION IN (@my_entities, @subentities[@my_entities]) AND status IN (''NEW'',''COU'',''EVIS'',''ESIG'',''EAVIS'',''EENV'',''WAIT'',''REJ_SIGN'',''REJ_VISA'',''IMP'',''PARAPHWAIT'') and custom_fields#>>''{"10"}''<>''Signalé''', 'Y', 'Y', 26, NULL, 'res_id desc', 'N'),
                                                                                                                                                                  (54, 'letterbox_coll', 'SuivSignalDailyBasket', '[SUIVI] Courriers signalés du jour', 'Courriers signalés du jour', 'DESTINATION IN (@my_entities, @subentities[@my_entities]) AND status IN (''NEW'',''COU'',''EVIS'',''ESIG'',''EAVIS'',''EENV'',''WAIT'',''REJ_SIGN'',''REJ_VISA'',''IMP'',''PARAPHWAIT'') and custom_fields#>>''{"10"}''=''Signalé'' and creation_date>((NOW() - INTERVAL ''1 day''))', 'Y', 'Y', 27, NULL, 'res_id desc', 'N'),
                                                                                                                                                                  (59, 'letterbox_coll', 'SignBasket', 'Courriers à signer', 'Courriers à signer', '(status in (''ESIG'') AND ((res_id, @user_id) IN (SELECT res_id, item_id FROM listinstance WHERE difflist_type IN (''VISA_CIRCUIT'') and process_date ISNULL and res_view_letterbox.res_id = res_id order by listinstance_id asc limit 1))) OR (status in (''EVIS'') AND ((res_id, @user_id) IN (SELECT res_id, item_id FROM listinstance WHERE difflist_type IN (''VISA_CIRCUIT'') and process_date ISNULL and res_view_letterbox.res_id = res_id order by listinstance_id asc limit 1))AND (SELECT COUNT(*) FROM listinstance WHERE res_id=res_view_letterbox.res_id AND difflist_type=''VISA_CIRCUIT'') IN (''1''))', 'Y', 'Y', 6, NULL, 'res_id desc', 'N'); -- EDISSYUM - AMO01 Modification clause bannette courriers à signer

INSERT INTO configurations (id, privilege, value) VALUES (2, 'admin_search', '{"listEvent": {"defaultTab": "dashboard"}, "listDisplay": {"subInfos": [{"icon": "fa-traffic-light", "value": "getPriority", "cssClasses": ["align_leftData"]}, {"icon": "fa-calendar", "value": "getCreationAndProcessLimitDates", "cssClasses": ["align_leftData"]}, {"icon": "fa-sitemap", "value": "getAssignee", "cssClasses": ["align_leftData"]}, {"icon": "fa-suitcase", "value": "getDoctype", "cssClasses": ["align_leftData"]}, {"icon": "fa-user", "value": "getRecipients", "cssClasses": ["align_leftData"]}, {"icon": "fa-book", "value": "getSenders", "cssClasses": ["align_leftData"]}], "templateColumns": 6}}');
INSERT INTO configurations (id, privilege, value) VALUES (3, 'admin_sso', '{"url": "", "mapping": [{"ssoId": "", "maarchId": "login"}]}');
INSERT INTO configurations (id, privilege, value) VALUES (5, 'admin_parameters_watermark', '{"font": "helvetica", "posX": 30, "posY": 35, "size": 10, "text": "Copie conforme de [alt_identifier] le [date_now] [hour_now]", "angle": 0, "color": [20, 192, 30], "enabled": false, "opacity": 0.5}'); -- EDISSYUM - AMO01 Désactiver le watermark par défaut
INSERT INTO configurations (id, privilege, value) VALUES (6, 'admin_shippings', '{"uri": "", "authUri": "", "enabled": false}');
INSERT INTO configurations (id, privilege, value) VALUES (8, 'admin_organization_email_signatures', '{"signatures": [{"label": "Signature Organisation", "content": "<div><span><span><strong>[user.firstname] </strong></span></span><span>[user.lastname]</span></div>\\n<div><span><span><span><span><strong>[userPrimaryEntity.entity_label]</strong></span></span></span></span></div>\\n<div><span>[user.phone]</span></div>\\n<div><span><span>[userPrimaryEntity.address_number] [userPrimaryEntity.address_street], [userPrimaryEntity.address_postcode] [userPrimaryEntity.address_town]</span></span></div>\\n<div>&nbsp;</div>"}]}');
INSERT INTO configurations (id, privilege, value) VALUES (9, 'admin_export_seda', '{}');
INSERT INTO configurations (id, privilege, value) VALUES (4, 'admin_document_editors', '{"java": [], "default": "", "onlyoffice": {"ssl": true, "uri": "onlyoffice7.maarchcourrier.com", "port": "443", "token": "", "authorizationHeader": "Authorization"}}');
INSERT INTO configurations (id, privilege, value) VALUES (1, 'admin_email_server', '{"auth": true, "from": "", "host": "", "port": 587, "type": "smtp", "user": "", "online": true, "secure": "tls", "charset": "utf-8", "password": ""}');

INSERT INTO configurations (id, privilege, value) VALUES (13, 'admin_send_secure_email', '{"pastell": {"byDefault": "", "url": "", "login": "", "password": "", "entite": 0, "enabled": false}}'); -- EDISSYUM - ASY01 Implémentation envoie de Mail sécurisé via Pastell

INSERT INTO configurations (id, privilege, value) VALUES (11, 'admin_search_contacts', '{"listDisplay": {"subInfos": [{"icon": "fa-user", "label": "Civilité", "value": "getCivility", "cssClasses": ["align_leftData"]}, {"icon": "fa-calendar", "label": "Date de création", "value": "getCreationDate", "cssClasses": ["align_leftData"]}, {"icon": "fa-user", "label": "Courriel", "value": "getEmail", "cssClasses": ["align_leftData"]}, {"icon": "fa-user", "label": "Téléphone", "value": "getPhone", "cssClasses": ["align_leftData"]}, {"icon": "fa-map-marker-alt", "label": "Numéro de rue", "value": "getAddressNumber", "cssClasses": ["align_leftData"]}, {"icon": "fa-map-marker-alt", "label": "Voie", "value": "getAddressStreet", "cssClasses": ["align_leftData"]}], "templateColumns": 6}}'); -- EDISSYUM NCH01 - Fenetre de recherche de contacts

INSERT INTO configurations (id, privilege, value) VALUES (12, 'admin_search_folders', '{"listEvent": {"defaultTab": "dashboard"}, "listDisplay": {"subInfos": [{"icon": "fa-traffic-light", "value": "getPriority", "cssClasses": ["align_leftData"]}, {"icon": "fa-calendar", "value": "getCreationAndProcessLimitDates", "cssClasses": ["align_leftData"]}, {"icon": "fa-sitemap", "value": "getAssignee", "cssClasses": ["align_leftData"]}, {"icon": "fa-suitcase", "value": "getDoctype", "cssClasses": ["align_leftData"]}, {"icon": "fa-user", "value": "getRecipients", "cssClasses": ["align_leftData"]}, {"icon": "fa-book", "value": "getSenders", "cssClasses": ["align_leftData"]}], "templateColumns": 6}}'); -- EDISSYUM - EME01 Ajout d'une fenêtre pour administrer la recherche des dossiers

INSERT INTO configurations (id, privilege, value) VALUES (14, 'admin_attachments_hosts', '{"nextcloud": {"byDefault": "", "username": "", "password": "", "url": "", "urlExpirationDate": "", "textAddedAboveURLS": ""}}'); -- EDISSYUM - AMO01 Rajout d'une option pour envoyer les PJ via liens épémères

INSERT INTO contacts_search_templates (id, user_id, label, creation_date, query) VALUES (1, 23, 'Tous les contacts', '2021-03-25 11:54:30.273871', '[]'); -- EDISSYUM - NCH01 Fenetre de recherche de contacts

DELETE FROM contacts;
INSERT INTO contacts (id, civility, firstname, lastname, company, department, function, address_number, address_street, address_additional1, address_additional2, address_postcode, address_town, address_country, email, phone, communication_means, notes, creator, creation_date, modification_date, enabled, custom_fields, external_id, sector, lad_indexation) VALUES (3, 1, 'Saïd', 'BELAOUNI', NULL, NULL, NULL, '129', 'AVENUE LOUIS GIRAUD', NULL, NULL, '84200', 'CARPENTRAS', NULL, 'said.belaouni@edissyum.com', '06 37 28 67 19', NULL, NULL, 1, '2022-10-21 16:36:46.776739', NULL, true, '{}', '{}', NULL, false); -- EDISSYUM mise à jour data_fr comme MEM 23

INSERT INTO contacts (id, civility, firstname, lastname, company, department, function, address_number, address_street, address_additional1, address_additional2, address_postcode, address_town, address_country, email, phone, communication_means, notes, creator, creation_date, modification_date, enabled, custom_fields, external_id, sector, lad_indexation) VALUES (2, 1, 'Cédric', 'ROUIRE', 'ADN Avignon Delta Numérique', NULL, NULL, '1', 'RUE DE LA REPUBLIQUE', NULL, NULL, '84000', 'AVIGNON', 'FRANCE', 'president@adn.fr', '04 90 30 00 00', NULL, NULL, 1, '2022-06-02 04:48:52.614806', '2022-06-27 04:05:03.581251', true, NULL, '{}', NULL, false); -- EDISSYUM mise à jour data_fr comme MEM 23

INSERT INTO contacts (id, civility, firstname, lastname, company, department, function, address_number, address_street, address_additional1, address_additional2, address_postcode, address_town, address_country, email, phone, communication_means, notes, creator, creation_date, modification_date, enabled, custom_fields, external_id, sector, lad_indexation) VALUES (1, 1, 'Bernard', 'PASMECHANT', NULL, NULL, NULL, '134', 'LOTISSEMENT DES LILAS', NULL, NULL, '38260', 'SARDIEU', NULL, 'b.pasmechant@gmail.com', '06 33 12 34 56', NULL, NULL, 1, '2022-05-27 09:36:04.128206', '2022-06-27 04:04:53.546201', true, NULL, '{}', NULL, false); -- EDISSYUM mise à jour data_fr comme MEM 23

INSERT INTO contacts (id, civility, firstname, lastname, company, department, function, address_number, address_street, address_additional1, address_additional2, address_postcode, address_town, address_country, email, phone, communication_means, notes, creator, creation_date, modification_date, enabled, custom_fields, external_id, sector, lad_indexation) VALUES (4, NULL, 'La Garenne', NULL, 'Association des parents d''élèves', NULL, NULL, '9', 'IMPASSE DES LILAS', NULL, NULL, '84310', 'MORIERES-LES-AVIGNON', NULL, 'president@asso.fr', '04 90 54 87 63', NULL, NULL, 1, '2022-10-21 16:38:17.145334', NULL, true, '{}', '{}', NULL, false); -- EDISSYUM mise à jour data_fr comme MEM 23

DELETE FROM contacts_civilities;
INSERT INTO contacts_civilities (id, label, abbreviation) VALUES (1, 'Monsieur', 'M.');
INSERT INTO contacts_civilities (id, label, abbreviation) VALUES (2, 'Madame', 'Mme');
INSERT INTO contacts_civilities (id, label, abbreviation) VALUES (3, 'Mademoiselle', 'Mlle');
INSERT INTO contacts_civilities (id, label, abbreviation) VALUES (4, 'Messieurs', 'MM.');
INSERT INTO contacts_civilities (id, label, abbreviation) VALUES (5, 'Mesdames', 'Mmes');
INSERT INTO contacts_civilities (id, label, abbreviation) VALUES (6, 'Mesdemoiselles', 'Mlles');
INSERT INTO contacts_civilities (id, label, abbreviation) VALUES(7, 'Monsieur et Madame', 'M.&Mme'); -- EDISSYUM mise à jour data_fr comme MEM 23
INSERT INTO contacts_civilities (id, label, abbreviation) VALUES(8, 'Monsieur ou Madame', 'M. ou Mme'); -- EDISSYUM mise à jour data_fr comme MEM 23
INSERT INTO contacts_civilities (id, label, abbreviation) VALUES(9, 'Maître', 'Me'); -- EDISSYUM mise à jour data_fr comme MEM 23
INSERT INTO contacts_civilities (id, label, abbreviation) VALUES (10, 'Maîtres', 'Mes'); -- EDISSYUM mise à jour data_fr comme MEM 23
INSERT INTO contacts_civilities (id, label, abbreviation) VALUES (11, 'Autre', 'Autre'); -- EDISSYUM AMO01 Ajout de la civilité Autre

DELETE FROM "contacts_custom_fields_list";
INSERT INTO "contacts_custom_fields_list" ("id", "label", "type", "values") VALUES
                                                                                (2, 'Coordonnées confidentielles avancée', 'radio', '["Oui", "Non"]'),
                                                                                (1, 'Coordonnées confidentielles', 'radio', '["Oui", "Non"]');
-- Déploiement des filtres d'affichage des contacts

DELETE FROM "contacts_filling";
INSERT INTO contacts_filling (id, enable, first_threshold, second_threshold) VALUES (1, true, 33, 66);

-- EDISSYUM mise à jour data_fr comme MEM 23
DELETE FROM "contacts_parameters";
INSERT INTO contacts_parameters (id, identifier, mandatory, filling, searchable, displayable, filtrable) VALUES (1, 'civility', false, true, false, false,true);
INSERT INTO contacts_parameters (id, identifier, mandatory, filling, searchable, displayable, filtrable) VALUES (2, 'firstname', false, true, true, true, false);
INSERT INTO contacts_parameters (id, identifier, mandatory, filling, searchable, displayable, filtrable) VALUES (3, 'lastname', true, true, true, true, false);
INSERT INTO contacts_parameters (id, identifier, mandatory, filling, searchable, displayable, filtrable) VALUES (4, 'company', true, true, true, true, false);
INSERT INTO contacts_parameters (id, identifier, mandatory, filling, searchable, displayable, filtrable) VALUES (5, 'department', false, true, false, true, false);
INSERT INTO contacts_parameters (id, identifier, mandatory, filling, searchable, displayable, filtrable) VALUES (6, 'function', false, false, false, false, true);
INSERT INTO contacts_parameters (id, identifier, mandatory, filling, searchable, displayable, filtrable) VALUES (7, 'addressNumber', false, true, true, true, false);
INSERT INTO contacts_parameters (id, identifier, mandatory, filling, searchable, displayable, filtrable) VALUES (8, 'addressStreet', false, true, true, true, false);
INSERT INTO contacts_parameters (id, identifier, mandatory, filling, searchable, displayable, filtrable) VALUES (9, 'addressAdditional1', false, false, false, false, false);
INSERT INTO contacts_parameters (id, identifier, mandatory, filling, searchable, displayable, filtrable) VALUES (10, 'addressAdditional2', false, false, false, false, false);
INSERT INTO contacts_parameters (id, identifier, mandatory, filling, searchable, displayable, filtrable) VALUES (11, 'addressPostcode', false, true, true, true, false);
INSERT INTO contacts_parameters (id, identifier, mandatory, filling, searchable, displayable, filtrable) VALUES (12, 'addressTown', false, true, true, true, false);
INSERT INTO contacts_parameters (id, identifier, mandatory, filling, searchable, displayable, filtrable) VALUES (13, 'addressCountry', false, false, false, false, true);
INSERT INTO contacts_parameters (id, identifier, mandatory, filling, searchable, displayable, filtrable) VALUES (14, 'email', false, true, false, false, false);
INSERT INTO contacts_parameters (id, identifier, mandatory, filling, searchable, displayable, filtrable) VALUES (15, 'phone', false, true, false, false, false);
INSERT INTO contacts_parameters (id, identifier, mandatory, filling, searchable, displayable, filtrable) VALUES (16, 'notes', true, true, true, true, false);
INSERT INTO contacts_parameters (id, identifier, mandatory, filling, searchable, displayable, filtrable) VALUES (17, 'sector', false, false, false, false, false);
INSERT INTO contacts_parameters (id, identifier, mandatory, filling, searchable, displayable, filtrable) VALUES (18, 'contactCustomField_1', false, false, false, false, false);
INSERT INTO contacts_parameters (id, identifier, mandatory, filling, searchable, displayable, filtrable) VALUES (19, 'contactCustomField_2', false, false, false, false, false);
-- END EDISSYUM

DELETE FROM "custom_fields";
INSERT INTO custom_fields (id, label, type, mode, values) VALUES (1, 'Date de fin de contrat', 'date', 'form', '[]');
INSERT INTO custom_fields (id, label, type, mode, values) VALUES (2, 'Adresse d''intervention', 'banAutocomplete', 'form', '[]');
INSERT INTO custom_fields (id, label, type, mode, values) VALUES (3, 'Nature', 'select', 'form', '["Courrier simple", "Courriel", "Courrier suivi", "Courrier avec AR", "Fax", "Chronopost", "Fedex", "Courrier AR", "Coursier", "Pli numérique", "Autre"]');
INSERT INTO custom_fields (id, label, type, mode, values) VALUES (4, 'Référence courrier expéditeur', 'string', 'form', '[]');
INSERT INTO custom_fields (id, label, type, mode, values) VALUES (5, 'Num recommandé', 'string', 'form', '[]');
-- EDISSYUM mise à jour data_fr comme MEM 23
INSERT INTO custom_fields (id, label, type, mode, values) VALUES (6, 'Destinataire du mail', 'string', 'form', '[]');
INSERT INTO custom_fields (id, label, type, mode, values) VALUES (7, 'Expéditeur du mail', 'string', 'form','[]');
INSERT INTO custom_fields (id, label, type, mode, values) VALUES (8, 'Personne en copie', 'string', 'form', '[]' );
INSERT INTO custom_fields (id, label, type, mode, values) VALUES (9, 'Adresse de réponse', 'string','form','[]');
INSERT INTO custom_fields (id, label, type, mode, values) VALUES (10, 'Signalé', 'radio', 'form', '["Ordinaire","Signalé"]');
-- END EDISSYUM

INSERT INTO difflist_roles (id, role_id, label, keep_in_list_instance) VALUES (1, 'dest', 'Attributaire', false); -- EDISSYUM - NCH01 Modification du libellé destinataire
INSERT INTO difflist_roles (id, role_id, label, keep_in_list_instance) VALUES (2, 'copy', 'En copie', true);
INSERT INTO difflist_roles (id, role_id, label, keep_in_list_instance) VALUES (3, 'visa', 'Pour visa', false);
INSERT INTO difflist_roles (id, role_id, label, keep_in_list_instance) VALUES (4, 'sign', 'Pour signature', false);
INSERT INTO difflist_roles (id, role_id, label, keep_in_list_instance) VALUES (5, 'avis', 'Pour avis', false);
INSERT INTO difflist_roles (id, role_id, label, keep_in_list_instance) VALUES (6, 'avis_copy', 'En copie (avis)', false);
INSERT INTO difflist_roles (id, role_id, label, keep_in_list_instance) VALUES (7, 'avis_info', 'Pour information (avis)', false);


INSERT INTO difflist_types (difflist_type_id, difflist_type_label, difflist_type_roles, allow_entities, is_system) VALUES ('entity_id', 'Diffusion aux services', 'dest copy avis', 'Y', 'Y');
INSERT INTO difflist_types (difflist_type_id, difflist_type_label, difflist_type_roles, allow_entities, is_system) VALUES ('type_id', 'Diffusion selon le type de document', 'dest copy', 'Y', 'Y');
INSERT INTO difflist_types (difflist_type_id, difflist_type_label, difflist_type_roles, allow_entities, is_system) VALUES ('VISA_CIRCUIT', 'Circuit de visa', 'visa sign ', 'N', 'Y');
INSERT INTO difflist_types (difflist_type_id, difflist_type_label, difflist_type_roles, allow_entities, is_system) VALUES ('AVIS_CIRCUIT', 'Circuit d''avis', 'avis ', 'N', 'Y');


INSERT INTO docserver_types (docserver_type_id, docserver_type_label, enabled, fingerprint_mode) VALUES ('DOC', 'Documents numériques', 'Y', 'SHA512');
INSERT INTO docserver_types (docserver_type_id, docserver_type_label, enabled, fingerprint_mode) VALUES ('CONVERT', 'Conversions de formats', 'Y', 'SHA256');
INSERT INTO docserver_types (docserver_type_id, docserver_type_label, enabled, fingerprint_mode) VALUES ('FULLTEXT', 'Plein texte', 'Y', 'SHA256');
INSERT INTO docserver_types (docserver_type_id, docserver_type_label, enabled, fingerprint_mode) VALUES ('TNL', 'Miniatures', 'Y', 'NONE');
INSERT INTO docserver_types (docserver_type_id, docserver_type_label, enabled, fingerprint_mode) VALUES ('TEMPLATES', 'Modèles de documents', 'Y', 'NONE');
INSERT INTO docserver_types (docserver_type_id, docserver_type_label, enabled, fingerprint_mode) VALUES ('ARCHIVETRANSFER', 'Archives numériques', 'Y', 'SHA256');
INSERT INTO docserver_types (docserver_type_id, docserver_type_label, enabled, fingerprint_mode) VALUES ('ACKNOWLEDGEMENT_RECEIPTS', 'Accusés de réception', 'Y', NULL);
INSERT INTO docserver_types (docserver_type_id, docserver_type_label, enabled, fingerprint_mode) VALUES ('MIGRATION', 'Sauvegarde des migrations', 'Y', NULL);


INSERT INTO docservers (id, docserver_id, docserver_type_id, device_label, is_readonly, is_encrypted, size_limit_number, actual_size_number, path_template, creation_date, coll_id) VALUES (1, 'FASTHD_AI', 'DOC', 'Dépôt documentaire issue d''imports de masse', 'Y', false, 50000000000, 1, '/var/docservers/mem/ai/', '2011-01-07 13:43:48.696644', 'letterbox_coll');
INSERT INTO docservers (id, docserver_id, docserver_type_id, device_label, is_readonly, is_encrypted, size_limit_number, actual_size_number, path_template, creation_date, coll_id) VALUES (8, 'FULLTEXT_MLB', 'FULLTEXT', 'Dépôt de l''extraction plein texte des documents numérisés', 'N', false, 50000000000, 0, '/var/docservers/mem/fulltext_resources/', '2015-03-16 14:47:49.197164', 'letterbox_coll');
INSERT INTO docservers (id, docserver_id, docserver_type_id, device_label, is_readonly, is_encrypted, size_limit_number, actual_size_number, path_template, creation_date, coll_id) VALUES (9, 'FULLTEXT_ATTACH', 'FULLTEXT', 'Dépôt de l''extraction plein texte des pièces jointes', 'N', false, 50000000000, 0, '/var/docservers/mem/fulltext_attachments/', '2015-03-16 14:47:49.197164', 'attachments_coll');
INSERT INTO docservers (id, docserver_id, docserver_type_id, device_label, is_readonly, is_encrypted, size_limit_number, actual_size_number, path_template, creation_date, coll_id) VALUES (11, 'ARCHIVETRANSFER', 'ARCHIVETRANSFER', 'Dépôt des archives numériques', 'N', false, 50000000000, 1, '/var/docservers/mem/archive_transfer/', '2017-01-13 14:47:49.197164', 'archive_transfer_coll');
INSERT INTO docservers (id, docserver_id, docserver_type_id, device_label, is_readonly, is_encrypted, size_limit_number, actual_size_number, path_template, creation_date, coll_id) VALUES (3, 'FASTHD_ATTACH', 'DOC', 'Dépôt des pièces jointes', 'N', false, 50000000000, 1, '/var/docservers/mem/attachments/', '2011-01-13 14:47:49.197164', 'attachments_coll');
INSERT INTO docservers (id, docserver_id, docserver_type_id, device_label, is_readonly, is_encrypted, size_limit_number, actual_size_number, path_template, creation_date, coll_id) VALUES (5, 'CONVERT_ATTACH', 'CONVERT', 'Dépôt des formats des pièces jointes', 'N', false, 50000000000, 0, '/var/docservers/mem/convert_attachments/', '2015-03-16 14:47:49.197164', 'attachments_coll');
INSERT INTO docservers (id, docserver_id, docserver_type_id, device_label, is_readonly, is_encrypted, size_limit_number, actual_size_number, path_template, creation_date, coll_id) VALUES (2, 'FASTHD_MAN', 'DOC', 'Dépôt documentaire de numérisation manuelle', 'N', false, 50000000000, 1290730, '/var/docservers/mem/resources/', '2011-01-13 14:47:49.197164', 'letterbox_coll');
INSERT INTO docservers (id, docserver_id, docserver_type_id, device_label, is_readonly, is_encrypted, size_limit_number, actual_size_number, path_template, creation_date, coll_id) VALUES (4, 'CONVERT_MLB', 'CONVERT', 'Dépôt des formats des documents numérisés', 'N', false, 50000000000, 0, '/var/docservers/mem/convert_resources/', '2015-03-16 14:47:49.197164', 'letterbox_coll');
INSERT INTO docservers (id, docserver_id, docserver_type_id, device_label, is_readonly, is_encrypted, size_limit_number, actual_size_number, path_template, creation_date, coll_id) VALUES (12, 'ACKNOWLEDGEMENT_RECEIPTS', 'ACKNOWLEDGEMENT_RECEIPTS', 'Dépôt des AR', 'N', false, 50000000000, 0, '/var/docservers/mem/acknowledgement_receipts/', '2019-04-19 22:22:22.201904', 'letterbox_coll');
INSERT INTO docservers (id, docserver_id, docserver_type_id, device_label, is_readonly, is_encrypted, size_limit_number, actual_size_number, path_template, creation_date, coll_id) VALUES (14, 'MIGRATION', 'MIGRATION', 'Dépôt de sauvegarde des migrations', 'N', false, 50000000000, 0, '/var/docservers/mem/migration/', '2024-06-21 10:59:00.820708', 'migration');
INSERT INTO docservers (id, docserver_id, docserver_type_id, device_label, is_readonly, is_encrypted, size_limit_number, actual_size_number, path_template, creation_date, coll_id) VALUES (7, 'TNL_ATTACH', 'TNL', 'Dépôt des maniatures des pièces jointes', 'N', false, 50000000000, 0, '/var/docservers/mem/thumbnails_attachments/', '2015-03-16 14:47:49.197164', 'attachments_coll');
INSERT INTO docservers (id, docserver_id, docserver_type_id, device_label, is_readonly, is_encrypted, size_limit_number, actual_size_number, path_template, creation_date, coll_id) VALUES (6, 'TNL_MLB', 'TNL', 'Dépôt des maniatures des documents numérisés', 'N', false, 50000000000, 0, '/var/docservers/mem/thumbnails_resources/', '2015-03-16 14:47:49.197164', 'letterbox_coll');
INSERT INTO docservers (id, docserver_id, docserver_type_id, device_label, is_readonly, is_encrypted, size_limit_number, actual_size_number, path_template, creation_date, coll_id) VALUES (10, 'TEMPLATES', 'TEMPLATES', 'Dépôt des modèles de documents', 'N', false, 50000000000, 71511, '/var/docservers/mem/templates/', '2012-04-01 14:49:05.095119', 'templates');

-- EDISSYUM mise à jour data_fr comme MEM 23
TRUNCATE TABLE DOCTYPES_FIRST_LEVEL;
TRUNCATE TABLE DOCTYPES_SECOND_LEVEL;
TRUNCATE TABLE DOCTYPES;
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',407, 'Facture ou avoir', 'Y',1,4, 'conservation', 'compta_3_04', NULL,1800,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',1214, 'Inscription enfant d’âge préscolaire en maternelle', 'Y',2,15, 'destruction', 'compta_3_03', NULL,1080,2,14,1, 'SVA');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',1225, 'Bordereau de recommandé', 'Y',1,1, 'destruction', NULL, 'destruction',360,30,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',1226, 'BORDEREAU DE TRANSFERT ALFRESCO', 'Y',5,19, NULL, NULL, NULL, NULL,30,3,2, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',1227, 'Devis/contrat', 'Y',1,4, NULL, NULL, 'destruction',368,21,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',1216, 'Inscription enfant à l’accueil périscolaire', 'Y',2,15, 'destruction', 'compta_3_03', NULL,1080,2,14,1, 'SVA');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',1218, 'Autorisation concernant dispositifs publicitaire lumineux', 'Y',2,17, 'conservation', 'compta_3_03', NULL,1080,2,14,1, 'SVA');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',101, 'Abonnements – documentation – archives', 'Y',1,1, 'conservation', 'compta_3_03', NULL,1080,30,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',103, 'Demande de documents', 'Y',1,1, 'conservation', 'compta_3_03', NULL,1080,30,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',1212, 'DIA (Déclaration d''''Intention d''''Aliéner)', 'Y',1,10, 'conservation', 'compta_3_05', NULL,360,21,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',1209, 'Délibération', 'Y',3,14, 'conservation', NULL, NULL,3600,21,15,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',1207, 'Arrêté', 'Y',3,14, 'conservation', NULL, NULL,3600,21,15,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',1210, 'Document à qualifier', 'Y',1,1, NULL, NULL, NULL, NULL,21,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',1220, 'Divers Allo Mairie', 'Y',1,11, 'destruction', 'compta_3_03', NULL,1080,21,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',1221, 'Déclaration achèvement des travaux', 'Y',1,10, 'conservation', 'compta_3_05', NULL,3600,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',1204, 'Courrier à qualifier', 'Y',1,1, NULL, NULL, NULL, NULL,21,15,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',1208, 'Décision', 'Y',3,14, 'conservation', NULL, NULL,3600,21,15,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',102, 'Convocation', 'Y',1,1, 'destruction', 'compta_3_03', NULL,1080,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',104, 'Demande de fournitures et matériels', 'Y',1,1, 'destruction', 'compta_3_03', NULL,1080,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',106, 'Demande de renseignements', 'Y',1,1, 'destruction', 'compta_3_03', NULL,1080,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',107, 'Demande mise à jour de fichiers', 'Y',1,1, 'conservation', 'compta_3_03', NULL,1080,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',108, 'Demande Multi-Objet', 'Y',1,1, 'destruction', 'compta_3_03', NULL,1080,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',1211, 'Email', 'Y',1,1, 'conservation', 'compta_3_03', NULL,1080,21,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',109, 'Installation provisoire dans un équipement ville', 'Y',1,1, 'conservation', 'compta_3_04', NULL,1800,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',110, 'Invitation', 'Y',1,1, 'destruction', 'compta_3_03', NULL,1080,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',111, 'Rapport – Compte-rendu – Bilan', 'Y',1,1, 'conservation', 'compta_3_04', NULL,1800,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',201, 'Pétition', 'Y',1,2, 'conservation', 'compta_3_05', NULL,1080,15,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',105, 'Demande de RDV', 'Y',1,1, 'destruction', 'compta_3_03', NULL,360,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',1205, 'Courrier à rapprocher', 'Y',1,1, NULL, NULL, NULL, NULL,21,15,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',112, 'Réservation d''un local communal et scolaire', 'Y',1,1, 'destruction', 'compta_3_03', NULL,1080,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',202, 'Communication', 'Y',1,2, 'conservation', 'compta_3_05', NULL,1080,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',203, 'Politique', 'Y',1,2, 'conservation', 'compta_3_05', NULL,1080,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',204, 'Relations et solidarité internationales ', 'Y',1,2, 'conservation', 'compta_3_05', NULL,3600,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',205, 'Remerciements et félicitations', 'Y',1,2, 'destruction', 'compta_3_03', NULL,1080,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',206, 'Sécurité', 'Y',1,2, 'conservation', 'compta_3_05', NULL,1080,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',207, 'Suggestion', 'Y',1,2, 'destruction', 'compta_3_03', NULL,1080,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',301, 'Culture', 'Y',1,3, 'destruction', 'compta_3_03', NULL,1080,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',303, 'Éducation nationale', 'Y',1,3, 'destruction', 'compta_3_03', NULL,1080,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',304, 'Jeunesse', 'Y',1,3, 'destruction', 'compta_3_03', NULL,1080,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',305, 'Lycées et collèges', 'Y',1,3, 'destruction', 'compta_3_03', NULL,1080,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',306, 'Parentalité', 'Y',1,3, 'conservation', 'compta_3_03', NULL,1080,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',307, 'Petite Enfance', 'Y',1,3, 'conservation', 'compta_3_03', NULL,1080,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',308, 'Sport', 'Y',1,3, 'destruction', 'compta_3_03', NULL,1080,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',401, 'Contestation financière', 'Y',1,4, 'conservation', 'compta_3_05', NULL,3600,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',402, 'Contrat de prêt', 'Y',1,4, 'destruction', 'compta_3_03', NULL,1080,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',403, 'Garantie d''emprunt', 'Y',1,4, 'conservation', 'compta_3_04', NULL,1800,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',404, 'Paiement', 'Y',1,4, 'conservation', 'compta_3_04', NULL,1800,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',406, 'Paiement subvention', 'Y',1,4, 'conservation', 'compta_3_04', NULL,1800,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',408, 'Proposition financière', 'Y',1,4, 'destruction', 'compta_3_03', NULL,1080,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',405, 'Quotient familial', 'Y',1,4, 'conservation', 'compta_3_04', NULL,1800,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',501, 'Hospitalisation d''office', 'Y',1,5, 'destruction', 'compta_3_03', NULL,1080,2,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',502, 'Mise en demeure', 'Y',1,5, 'conservation', 'compta_3_04', NULL,1800,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',504, 'Recours contentieux', 'Y',1,5, 'conservation', 'compta_3_03', NULL,1080,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',505, 'Recours gracieux et réclamations', 'Y',1,5, 'conservation', 'compta_3_03', NULL,1080,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',601, 'Débits de boisson', 'Y',1,6, 'conservation', 'compta_3_05', NULL,3600,60,14,1, 'SVR');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',603, 'Élections', 'Y',1,6, 'destruction', 'compta_3_03', NULL,1080,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',604, 'Étrangers', 'Y',1,6, 'conservation', 'compta_3_03', NULL,1080,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',602, 'Demande d’État Civil (actes)', 'Y',1,6, 'conservation', 'compta_3_05', NULL,3600,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',1206, 'Courriel à qualifier', 'Y',1,1, NULL, NULL, NULL, NULL,21,15,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',605, 'Marché', 'Y',1,6, 'destruction', 'compta_3_03', NULL,1080,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',606, 'Médaille du travail', 'Y',1,6, 'destruction', 'compta_3_03', NULL,360,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',607, 'Stationnement taxi', 'Y',1,6, 'destruction', 'compta_3_03', NULL,1080,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',608, 'Vente au déballage', 'Y',1,6, 'destruction', 'compta_3_03', NULL,1080,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',701, 'Arrêts de travail et maladie', 'Y',1,7, 'conservation', 'compta_3_05', NULL,3600,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',702, 'Assurance du personnel', 'Y',1,7, 'conservation', 'compta_3_03', NULL,1080,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',705, 'Conditions de travail santé', 'Y',1,7, 'conservation', 'compta_3_05', NULL,1080,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',1213, 'Divers : autre demande', 'Y',2,13, 'conservation', 'compta_3_03', NULL,1080,2,14,1, 'SVA');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',706, 'Congés exceptionnels et concours', 'Y',1,7, 'conservation', 'compta_3_03', NULL,1080,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',707, 'Formation', 'Y',1,7, 'conservation', 'compta_3_03', NULL,1080,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',708, 'Instances RH', 'Y',1,7, 'conservation', 'compta_3_03', NULL,1080,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',709, 'Retraite', 'Y',1,7, 'conservation', 'compta_3_03', NULL,1080,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',704, 'Carrière', 'Y',1,7, 'conservation', 'compta_3_05', NULL,360,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',703, 'Candidature', 'Y',1,7, 'destruction', 'compta_3_03', NULL,360,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',1103, 'Demande intervention voirie', 'Y',1,11, 'conservation', 'compta_3_03', NULL,1080,21,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',710, 'Stage', 'Y',1,7, 'destruction', 'compta_3_03', NULL,1080,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',711, 'Syndicats', 'Y',1,7, 'conservation', 'compta_3_05', NULL,3600,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',801, 'Aide à domicile', 'Y',1,8, 'destruction', 'compta_3_05', NULL,3600,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',802, 'Aide Financière', 'Y',1,8, 'destruction', 'compta_3_05', NULL,3600,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',803, 'Animations retraités', 'Y',1,8, 'destruction', 'compta_3_05', NULL,3600,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',804, 'Domiciliation', 'Y',1,8, 'destruction', 'compta_3_05', NULL,3600,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',805, 'Dossier de logement', 'Y',1,8, 'conservation', 'compta_3_05', NULL,3600,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',806, 'Expulsion', 'Y',1,8, 'destruction', 'compta_3_05', NULL,3600,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',807, 'Foyer', 'Y',1,8, 'destruction', 'compta_3_05', NULL,3600,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',808, 'Obligation alimentaire', 'Y',1,8, 'conservation', 'compta_3_05', NULL,3600,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',302, 'Demande scolaire hors inscription et dérogation', 'Y',1,3, 'conservation', 'compta_3_03', NULL,1080,60,14,1, 'SVR');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',503, 'Plainte', 'Y',1,5, 'conservation', 'compta_3_03', NULL,360,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',809, 'RSA', 'Y',1,8, 'conservation', 'compta_3_05', NULL,3600,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',810, 'Scolarisation à domicile', 'Y',1,8, 'conservation', 'compta_3_05', NULL,3600,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',901, 'Aire d''accueil des gens du voyage', 'Y',1,9, 'destruction', 'compta_3_03', NULL,1080,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',902, 'Assainissement', 'Y',1,9, 'destruction', 'compta_3_03', NULL,1080,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',903, 'Assurance et sinistre', 'Y',1,9, 'destruction', 'compta_3_03', NULL,1080,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',904, 'Autorisation d''occupation du domaine public', 'Y',1,9, 'destruction', 'compta_3_03', NULL,1080,60,14,1, 'SVR');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',905, 'Contrat et convention hors marchés publics', 'Y',1,9, 'destruction', 'compta_3_03', NULL,1080,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',907, 'Espaces verts – Environnement – Développement durable', 'Y',1,9, 'destruction', 'compta_3_03', NULL,1080,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',908, 'Hygiène et Salubrité', 'Y',1,9, 'destruction', 'compta_3_03', NULL,1080,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',909, 'Marchés Publics', 'Y',1,9, 'conservation', 'compta_3_03', NULL,1080,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',910, 'Mobiliers urbains', 'Y',1,9, 'destruction', 'compta_3_03', NULL,1080,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',911, 'NTIC', 'Y',1,9, 'conservation', 'compta_3_03', NULL,1080,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',912, 'Opération d''aménagement', 'Y',1,9, 'destruction', 'compta_3_03', NULL,1080,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',913, 'Patrimoine', 'Y',1,9, 'destruction', 'compta_3_03', NULL,1080,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',914, 'Problème de voisinage', 'Y',1,9, 'destruction', 'compta_3_03', NULL,1080,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',915, 'Propreté - encombrants', 'Y',1,9, 'destruction', 'compta_3_03', NULL,1080,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',916, 'Stationnement et circulation', 'Y',1,9, 'destruction', 'compta_3_03', NULL,1080,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',917, 'Transports', 'Y',1,9, 'destruction', 'compta_3_03', NULL,1080,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',918, 'Travaux', 'Y',1,9, 'destruction', 'compta_3_03', NULL,1080,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',1001, 'Alignement', 'Y',1,10, 'conservation', 'compta_3_05', NULL,3600,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',1002, 'Avis d''urbanisme', 'Y',1,10, 'conservation', 'compta_3_05', NULL,3600,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',1003, 'Commerces', 'Y',1,10, 'conservation', 'compta_3_05', NULL,3600,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',1004, 'Numérotation', 'Y',1,10, 'conservation', 'compta_3_05', NULL,3600,60,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',1201, 'Appel téléphonique', 'Y',1,11, 'conservation', 'compta_3_03', NULL,1080,21,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',1222, 'Rapport Photo', 'Y',1,1, 'destruction', NULL, NULL,1560,21,1,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',1102, 'Cimetière', 'Y',2,13, 'conservation', 'compta_3_03', NULL,1080,2,14,1, 'SVA');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',1215, 'Inscription enfant à la cantine', 'Y',2,15, 'destruction', 'compta_3_03', NULL,1080,2,14,1, 'SVA');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',1105, 'Inscription toutes petites sections', 'Y',2,15, 'conservation', 'compta_3_03', NULL,1080,2,14,1, 'SVA');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',1219, 'Autorisation concernant installation d’enseignes sur immeubles…', 'Y',2,17, 'conservation', 'compta_3_03', NULL,1080,2,14,1, 'SVA');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',906, 'Détention de chiens dangereux', 'Y',1,9, 'conservation', 'compta_3_03', NULL,1080,60,14,1, 'SVR');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',1217, 'Autorisation de buvette', 'Y',2,16, 'conservation', 'compta_3_03', NULL,360,2,14,1, 'SVA');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',1202, 'Demande de subventions', 'Y',1,12, 'conservation', 'compta_3_03', 'conservation',10,21,14,1, 'NORMAL');
INSERT INTO doctypes (coll_id, type_id, description, enabled, doctypes_first_level_id, doctypes_second_level_id, retention_final_disposition, retention_rule, action_current_use, duration_current_use, process_delay, delay1, delay2, process_mode) VALUES ('',1228, '- Sélectionner un type de document -', 'Y',1,1, NULL, NULL, NULL, NULL,21,7,1, 'NORMAL');

INSERT INTO doctypes_first_level (doctypes_first_level_id, doctypes_first_level_label, css_style, enabled) VALUES (3, 'ACTES', NULL, 'Y');
INSERT INTO doctypes_first_level (doctypes_first_level_id, doctypes_first_level_label, css_style, enabled) VALUES (5, 'Archivage', NULL, 'Y');
INSERT INTO doctypes_first_level (doctypes_first_level_id, doctypes_first_level_label, css_style, enabled) VALUES (1,
                                                                                                                   'COURRIERS',
                                                                                                                   '#000000',
                                                                                                                   'Y');
INSERT INTO doctypes_first_level (doctypes_first_level_id, doctypes_first_level_label, css_style, enabled) VALUES (2, 'SVE', NULL, 'Y');
INSERT INTO doctypes_first_level (doctypes_first_level_id, doctypes_first_level_label, css_style, enabled)
VALUES (4, 'TOTO', NULL, 'N');


INSERT INTO doctypes_second_level (doctypes_second_level_id, doctypes_second_level_label, doctypes_first_level_id,
                                   css_style, enabled)
VALUES (1, '01. Correspondances', 1, '#000000', 'Y');
INSERT INTO doctypes_second_level (doctypes_second_level_id, doctypes_second_level_label, doctypes_first_level_id,
                                   css_style, enabled)
VALUES (2, '02. Cabinet', 1, '#000000', 'Y');
INSERT INTO doctypes_second_level (doctypes_second_level_id, doctypes_second_level_label, doctypes_first_level_id,
                                   css_style, enabled)
VALUES (3, '03. Éducation', 1, '#000000', 'Y');
INSERT INTO doctypes_second_level (doctypes_second_level_id, doctypes_second_level_label, doctypes_first_level_id,
                                   css_style, enabled)
VALUES (4, '04. Finances', 1, '#000000', 'Y');
INSERT INTO doctypes_second_level (doctypes_second_level_id, doctypes_second_level_label, doctypes_first_level_id,
                                   css_style, enabled)
VALUES (5, '05. Juridique', 1, '#000000', 'Y');
INSERT INTO doctypes_second_level (doctypes_second_level_id, doctypes_second_level_label, doctypes_first_level_id,
                                   css_style, enabled)
VALUES (6, '06. Population ', 1, '#000000', 'Y');
INSERT INTO doctypes_second_level (doctypes_second_level_id, doctypes_second_level_label, doctypes_first_level_id,
                                   css_style, enabled)
VALUES (7, '07. Ressources Humaines', 1, '#000000', 'Y');
INSERT INTO doctypes_second_level (doctypes_second_level_id, doctypes_second_level_label, doctypes_first_level_id,
                                   css_style, enabled)
VALUES (8, '08. Social', 1, '#000000', 'Y');
INSERT INTO doctypes_second_level (doctypes_second_level_id, doctypes_second_level_label, doctypes_first_level_id,
                                   css_style, enabled)
VALUES (9, '09. Technique', 1, '#000000', 'Y');
INSERT INTO doctypes_second_level (doctypes_second_level_id, doctypes_second_level_label, doctypes_first_level_id,
                                   css_style, enabled)
VALUES (10, '10. Urbanisme', 1, '#000000', 'Y');
INSERT INTO doctypes_second_level (doctypes_second_level_id, doctypes_second_level_label, doctypes_first_level_id,
                                   css_style, enabled)
VALUES (11, '11. Allo Mairie', 1, '#000000', 'Y');
INSERT INTO doctypes_second_level (doctypes_second_level_id, doctypes_second_level_label, doctypes_first_level_id,
                                   css_style, enabled)
VALUES (12, '12. Associations', 1, '#000000', 'Y');
INSERT INTO doctypes_second_level (doctypes_second_level_id, doctypes_second_level_label, doctypes_first_level_id,
                                   css_style, enabled)
VALUES (14, 'Actes', 3, NULL, 'Y');
INSERT INTO doctypes_second_level (doctypes_second_level_id, doctypes_second_level_label, doctypes_first_level_id,
                                   css_style, enabled)
VALUES (19, 'GED_Alfresco', 5, NULL, 'Y');
INSERT INTO doctypes_second_level (doctypes_second_level_id, doctypes_second_level_label, doctypes_first_level_id,
                                   css_style, enabled)
VALUES (13, 'SVE: Divers', 2, NULL, 'Y');
INSERT INTO doctypes_second_level (doctypes_second_level_id, doctypes_second_level_label, doctypes_first_level_id,
                                   css_style, enabled)
VALUES (15, 'SVE: Education', 2, NULL, 'Y');
INSERT INTO doctypes_second_level (doctypes_second_level_id, doctypes_second_level_label, doctypes_first_level_id,
                                   css_style, enabled)
VALUES (16, 'SVE: Santé', 2, NULL, 'Y');
INSERT INTO doctypes_second_level (doctypes_second_level_id, doctypes_second_level_label, doctypes_first_level_id,
                                   css_style, enabled)
VALUES (17, 'SVE: Urbanisme', 2, NULL, 'Y');
INSERT INTO doctypes_second_level (doctypes_second_level_id, doctypes_second_level_label, doctypes_first_level_id,
                                   css_style, enabled)
VALUES (18, 'ttt', 4, NULL, 'N');

-- INSERT INTO exports_templates (id, user_id, delimiter, format, data) VALUES (2, 4, ';', 'csv', '[{"value":"doc_date","label":"Date du courrier","isFunction":false},{"value":"getAssignee","label":"Attributaire","isFunction":true},{"value":"getDestinationEntity","label":"Libellé de l''entité traitante","isFunction":true},{"value":"subject","label":"Objet","isFunction":false},{"value":"process_limit_date","label":"Date limite de traitement","isFunction":false}]');
-- INSERT INTO exports_templates (id, user_id, delimiter, format, data) VALUES (1, 4, ';', 'pdf', '[{"value":"doc_date","label":"Date du courrier","isFunction":false},{"value":"type_label","label":"Type de courrier","isFunction":false},{"value":"getAssignee","label":"Attributaire","isFunction":true},{"value":"subject","label":"Objet","isFunction":false},{"value":"process_limit_date","label":"Date limite de traitement","isFunction":false}]');
-- EDISSYUM - NCH01 Fenetre de recherche de contacts

-- EDISSYUM - NCH01 Ne pas remplir certaines tables lors de l'installation (Commenter les lignes INSERT INTO folders)
-- INSERT INTO folders (id, label, public, user_id, parent_id, level) VALUES (1, 'Compétences fonctionnelles', true, 21, NULL, 0);
-- INSERT INTO folders (id, label, public, user_id, parent_id, level) VALUES (2, 'Vie politique', true, 21, 1, 1);
-- INSERT INTO folders (id, label, public, user_id, parent_id, level) VALUES (3, 'Vie citoyenne', true, 21, 1, 1);
-- INSERT INTO folders (id, label, public, user_id, parent_id, level) VALUES (4, 'Administration municipale', true, 21, 1, 1);
-- INSERT INTO folders (id, label, public, user_id, parent_id, level) VALUES (5, 'Ressources humaines', true, 21, 1, 1);
-- INSERT INTO folders (id, label, public, user_id, parent_id, level) VALUES (6, 'Candidatures sur postes ouverts', true, 21, 5, 2);
-- INSERT INTO folders (id, label, public, user_id, parent_id, level) VALUES (7, 'Candidatures spontanées', true, 21, 5, 2);
-- INSERT INTO folders (id, label, public, user_id, parent_id, level) VALUES (8, 'Affaires juridiques', true, 21, 1, 1);
-- INSERT INTO folders (id, label, public, user_id, parent_id, level) VALUES (9, 'Finances', true, 21, 1, 1);
-- INSERT INTO folders (id, label, public, user_id, parent_id, level) VALUES (10, 'Marchés publics', true, 21, 1, 1);
-- INSERT INTO folders (id, label, public, user_id, parent_id, level) VALUES (11, 'Informatique', true, 21, 1, 1);
-- INSERT INTO folders (id, label, public, user_id, parent_id, level) VALUES (12, 'Communication', true, 21, 1, 1);
-- INSERT INTO folders (id, label, public, user_id, parent_id, level) VALUES (13, 'Événements', true, 21, 1, 1);
-- INSERT INTO folders (id, label, public, user_id, parent_id, level) VALUES (14, 'Moyens généraux (matériels et logistiques)', true, 21, 1, 1);
-- INSERT INTO folders (id, label, public, user_id, parent_id, level) VALUES (15, 'Archives', true, 21, 1, 1);
-- INSERT INTO folders (id, label, public, user_id, parent_id, level) VALUES (16, 'Compétences techniques', true, 21, NULL, 0);
-- INSERT INTO folders (id, label, public, user_id, parent_id, level) VALUES (17, 'Population', true, 21, 16, 1);
-- INSERT INTO folders (id, label, public, user_id, parent_id, level) VALUES (18, 'Police - ordre public', true, 21, 16, 1);
-- INSERT INTO folders (id, label, public, user_id, parent_id, level) VALUES (19, 'Stationnement', true, 21, 18, 2);
-- INSERT INTO folders (id, label, public, user_id, parent_id, level) VALUES (20, 'Politique de la ville', true, 21, 16, 1);
-- INSERT INTO folders (id, label, public, user_id, parent_id, level) VALUES (21, 'Urbanisme opérationnel', true, 21, 16, 1);
-- INSERT INTO folders (id, label, public, user_id, parent_id, level) VALUES (22, 'Urbanisme réglementaire', true, 21, 16, 1);
-- INSERT INTO folders (id, label, public, user_id, parent_id, level) VALUES (23, 'Affaires foncières ', true, 21, 16, 1);
-- INSERT INTO folders (id, label, public, user_id, parent_id, level) VALUES (24, 'Développement du territoire ', true, 21, 16, 1);
-- INSERT INTO folders (id, label, public, user_id, parent_id, level) VALUES (25, 'Habitat', true, 21, 16, 1);
-- INSERT INTO folders (id, label, public, user_id, parent_id, level) VALUES (26, 'Biens communaux (domaine privé)', true, 21, 16, 1);
-- INSERT INTO folders (id, label, public, user_id, parent_id, level) VALUES (27, 'Espaces publics urbains (domaine public - voiries -réseaux)', true, 21, 16, 1);
-- INSERT INTO folders (id, label, public, user_id, parent_id, level) VALUES (28, 'Éclairage public', true, 21, 27, 2);
-- INSERT INTO folders (id, label, public, user_id, parent_id, level) VALUES (29, 'Ouvrages d''art', true, 21, 27, 2);
-- INSERT INTO folders (id, label, public, user_id, parent_id, level) VALUES (30, 'Hygiène', true, 21, 16, 1);
-- INSERT INTO folders (id, label, public, user_id, parent_id, level) VALUES (31, 'Santé publique', true, 21, 16, 1);
-- INSERT INTO folders (id, label, public, user_id, parent_id, level) VALUES (32, 'Enseignement', true, 21, 16, 1);
-- INSERT INTO folders (id, label, public, user_id, parent_id, level) VALUES (33, 'Sports', true, 21, 16, 1);
-- INSERT INTO folders (id, label, public, user_id, parent_id, level) VALUES (34, 'Centre de loisirs nautiques', true, 21, 33, 2);
-- INSERT INTO folders (id, label, public, user_id, parent_id, level) VALUES (35, 'Jeunesse', true, 21, 16, 1);
-- INSERT INTO folders (id, label, public, user_id, parent_id, level) VALUES (36, 'Culture', true, 21, 16, 1);
-- INSERT INTO folders (id, label, public, user_id, parent_id, level) VALUES (37, 'Actions sociales', true, 21, 16, 1);
-- INSERT INTO folders (id, label, public, user_id, parent_id, level) VALUES (38, 'Cohésion sociale', true, 21, 16, 1);

DELETE FROM "groupbasket";
INSERT INTO "groupbasket" ("id", "group_id", "basket_id", "list_display", "list_event", "list_event_data") VALUES
                                                                                                               (19, 'AGENT', 'SuiviParafBasket', '{"templateColumns":6,"subInfos":[{"value":"getPriority","label":"Priorit\u00e9","sample":"Urgent","cssClasses":[],"icon":"fa-traffic-light"},{"value":"getDoctype","label":"Type de courrier","sample":"R\u00e9clamation","cssClasses":[],"icon":"fa-suitcase"},{"value":"getAssignee","label":"Attributaire (entit\u00e9 traitante)","sample":"Barbara BAIN (P\u00f4le Jeunesse et Sport)","cssClasses":[],"icon":"fa-sitemap"},{"value":"getRecipients","label":"Destinataire","sample":"Patricia PETIT","cssClasses":[],"icon":"fa-user"},{"value":"getSenders","label":"Exp\u00e9diteur","sample":"Bernard PASMECHANT","cssClasses":[],"icon":"fa-book"},{"value":"getFolders","label":"Dossiers (emplacement fixe)","sample":"Litiges","cssClasses":["align_leftData"],"icon":"fa-folder"},{"value":"getVisaWorkflow","label":"Circuit de visa","sample":"<i style=''color:#006841'' class=''fa fa-check''><\/i> Barbara BAIN -> <i class=''fa fa-hourglass-half''><\/i> <b>Bruno BOULE<\/b> -> <i class=''fa fa-hourglass-half''><\/i> Patricia PETIT","cssClasses":["align_leftData"],"icon":"fa-list-ol"}]}', 'documentDetails', NULL),
                                                                                                               (136, 'AGENT', 'DdeAvisDepasse', '{"templateColumns":5,"subInfos":[{"value":"getPriority","label":"Priorit\u00e9","sample":"Urgent","cssClasses":["align_leftData"],"icon":"fa-traffic-light"},{"value":"getCategory","label":"Cat\u00e9gorie","sample":"Courrier arriv\u00e9e","cssClasses":["align_leftData"],"icon":"fa-exchange-alt"},{"value":"getDoctype","label":"Type de courrier","sample":"R\u00e9clamation","cssClasses":["align_leftData"],"icon":"fa-suitcase"},{"value":"getAssignee","label":"Attributaire (entit\u00e9 traitante)","sample":"Barbara BAIN (P\u00f4le Jeunesse et Sport)","cssClasses":["align_leftData"],"icon":"fa-sitemap"},{"value":"getOpinionLimitDate","label":"Date limite d''envoi des avis","sample":"01-01-2019","cssClasses":["align_leftData"],"icon":"fa-stopwatch"},{"value":"getFolders","label":"Dossiers (emplacement fixe)","sample":"Litiges","cssClasses":["align_leftData"],"icon":"fa-folder"}]}', 'processDocument', '{"defaultTab": "dashboard", "canUpdateData": false, "canGoToNextRes": false, "canUpdateModel": false}'),
                                                                                                               (171, 'AGENT', 'FindDdeAvisBasket', '{"subInfos":[],"templateColumns":0}', 'documentDetails', NULL),
                                                                                                               (172, 'RESPONSABLE', 'FindDdeAvisBasket', '{"subInfos":[],"templateColumns":0}', 'documentDetails', NULL),
                                                                                                               (137, 'RESPONSABLE', 'DdeAvisDepasse', '{"templateColumns":5,"subInfos":[{"value":"getPriority","label":"Priorit\u00e9","sample":"Urgent","cssClasses":["align_leftData"],"icon":"fa-traffic-light"},{"value":"getCategory","label":"Cat\u00e9gorie","sample":"Courrier arriv\u00e9e","cssClasses":["align_leftData"],"icon":"fa-exchange-alt"},{"value":"getDoctype","label":"Type de courrier","sample":"R\u00e9clamation","cssClasses":["align_leftData"],"icon":"fa-suitcase"},{"value":"getAssignee","label":"Attributaire (entit\u00e9 traitante)","sample":"Barbara BAIN (P\u00f4le Jeunesse et Sport)","cssClasses":["align_leftData"],"icon":"fa-sitemap"},{"value":"getOpinionLimitDate","label":"Date limite d''envoi des avis","sample":"01-01-2019","cssClasses":["align_leftData"],"icon":"fa-stopwatch"},{"value":"getFolders","label":"Dossiers (emplacement fixe)","sample":"Litiges","cssClasses":["align_leftData"],"icon":"fa-folder"}]}', 'processDocument', '{"defaultTab": "dashboard", "canUpdateData": false, "canGoToNextRes": false, "canUpdateModel": false}'),
                                                                                                               (173, 'RESPONSABLE', 'SignBasket', '{"templateColumns":7,"subInfos":[{"value":"getPriority","label":"Priorit\u00e9","sample":"Urgent","cssClasses":["align_leftData"],"icon":"fa-traffic-light"},{"value":"getCategory","label":"Cat\u00e9gorie","sample":"Courrier arriv\u00e9e","cssClasses":["align_leftData"],"icon":"fa-exchange-alt"},{"value":"getDoctype","label":"Type de courrier","sample":"R\u00e9clamation","cssClasses":["align_leftData"],"icon":"fa-suitcase"},{"value":"getAssignee","label":"Attributaire (entit\u00e9 traitante)","sample":"Barbara BAIN (P\u00f4le Jeunesse et Sport)","cssClasses":["align_leftData"],"icon":"fa-sitemap"},{"value":"getRecipients","label":"Destinataire","sample":"Patricia PETIT","cssClasses":["align_leftData"],"icon":"fa-user"},{"value":"getSenders","label":"Exp\u00e9diteur","sample":"Bernard PASMECHANT","cssClasses":["align_leftData"],"icon":"fa-book"},{"value":"getCreationAndProcessLimitDates","label":"Date de cr\u00e9ation - Date limite de traitement","sample":"1er janv. - <i class=''fa fa-stopwatch''><\/i>&nbsp;<b style=''color:#8e3e52''>3 jour(s)<\/b>","cssClasses":["align_leftData"],"icon":"fa-calendar"},{"value":"getFolders","label":"Dossiers (emplacement fixe)","sample":"Litiges","cssClasses":["align_leftData"],"icon":"fa-folder"}]}', 'signatureBookAction', '{"goToNextDocument": true, "canUpdateDocuments": true}'),
                                                                                                               (51, 'SERVICE', 'ServiceBasket', '{"templateColumns":7,"subInfos":[{"value":"getPriority","label":"Priorit\u00e9","sample":"Urgent","cssClasses":["align_leftData"],"icon":"fa-traffic-light"},{"value":"getCategory","label":"Cat\u00e9gorie","sample":"Courrier arriv\u00e9e","cssClasses":["align_leftData"],"icon":"fa-exchange-alt"},{"value":"getDoctype","label":"Type de courrier","sample":"R\u00e9clamation","cssClasses":["align_leftData"],"icon":"fa-suitcase"},{"value":"getAssignee","label":"Attributaire (entit\u00e9 traitante)","sample":"Barbara BAIN (P\u00f4le Jeunesse et Sport)","cssClasses":["align_leftData"],"icon":"fa-sitemap"},{"value":"getRecipients","label":"Destinataire","sample":"Patricia PETIT","cssClasses":["align_leftData"],"icon":"fa-user"},{"value":"getSenders","label":"Exp\u00e9diteur","sample":"Bernard PASMECHANT","cssClasses":["align_leftData"],"icon":"fa-book"},{"value":"getCreationAndProcessLimitDates","label":"Date de cr\u00e9ation - Date limite de traitement","sample":"1er janv. - <i class=''fa fa-stopwatch''><\/i>&nbsp;<b style=''color:#8e3e52''>3 jour(s)<\/b>","cssClasses":["align_leftData"],"icon":"fa-calendar"},{"value":"getFolders","label":"Dossiers (emplacement fixe)","sample":"Litiges","cssClasses":["align_leftData"],"icon":"fa-folder"}]}', 'processDocument', '{"defaultTab": "info", "canUpdateData": true, "canGoToNextRes": true, "canUpdateModel": false}'),
                                                                                                               (174, 'MAIRE', 'SignBasket', '{"templateColumns":7,"subInfos":[{"value":"getPriority","label":"Priorit\u00e9","sample":"Urgent","cssClasses":["align_leftData"],"icon":"fa-traffic-light"},{"value":"getCategory","label":"Cat\u00e9gorie","sample":"Courrier arriv\u00e9e","cssClasses":["align_leftData"],"icon":"fa-exchange-alt"},{"value":"getDoctype","label":"Type de courrier","sample":"R\u00e9clamation","cssClasses":["align_leftData"],"icon":"fa-suitcase"},{"value":"getAssignee","label":"Attributaire (entit\u00e9 traitante)","sample":"Barbara BAIN (P\u00f4le Jeunesse et Sport)","cssClasses":["align_leftData"],"icon":"fa-sitemap"},{"value":"getRecipients","label":"Destinataire","sample":"Patricia PETIT","cssClasses":["align_leftData"],"icon":"fa-user"},{"value":"getSenders","label":"Exp\u00e9diteur","sample":"Bernard PASMECHANT","cssClasses":["align_leftData"],"icon":"fa-book"},{"value":"getCreationAndProcessLimitDates","label":"Date de cr\u00e9ation - Date limite de traitement","sample":"1er janv. - <i class=''fa fa-stopwatch''><\/i>&nbsp;<b style=''color:#8e3e52''>3 jour(s)<\/b>","cssClasses":["align_leftData"],"icon":"fa-calendar"},{"value":"getFolders","label":"Dossiers (emplacement fixe)","sample":"Litiges","cssClasses":["align_leftData"],"icon":"fa-folder"}]}', 'signatureBookAction', '{"canUpdateDocuments": true}'),
                                                                                                               (131, 'MAIRE', 'ParafBasket', '{"templateColumns":6,"subInfos":[{"value":"getPriority","label":"Priorit\u00e9","sample":"Urgent","cssClasses":[],"icon":"fa-traffic-light"},{"value":"getDoctype","label":"Type de courrier","sample":"R\u00e9clamation","cssClasses":[],"icon":"fa-suitcase"},{"value":"getAssignee","label":"Attributaire (entit\u00e9 traitante)","sample":"Barbara BAIN (P\u00f4le Jeunesse et Sport)","cssClasses":[],"icon":"fa-sitemap"},{"value":"getRecipients","label":"Destinataire","sample":"Patricia PETIT","cssClasses":[],"icon":"fa-user"},{"value":"getSenders","label":"Exp\u00e9diteur","sample":"Bernard PASMECHANT","cssClasses":[],"icon":"fa-book"},{"value":"getFolders","label":"Dossiers (emplacement fixe)","sample":"Litiges","cssClasses":["align_leftData"],"icon":"fa-folder"},{"value":"getVisaWorkflow","label":"Circuit de visa","sample":"<i style=''color:#006841'' class=''fa fa-check''><\/i> Barbara BAIN -> <i class=''fa fa-hourglass-half''><\/i> <b>Bruno BOULE<\/b> -> <i class=''fa fa-hourglass-half''><\/i> Patricia PETIT","cssClasses":["align_leftData"],"icon":"fa-list-ol"}]}', 'signatureBookAction', '{"canUpdateDocuments": true}'),
                                                                                                               (133, 'ASSISTCAB', 'SuivSignalDailyBasket', '{"templateColumns":7,"subInfos":[{"value":"getPriority","label":"Priorit\u00e9","sample":"Urgent","cssClasses":["align_leftData"],"icon":"fa-traffic-light"},{"value":"getCategory","label":"Cat\u00e9gorie","sample":"Courrier arriv\u00e9e","cssClasses":["align_leftData"],"icon":"fa-exchange-alt"},{"value":"getDoctype","label":"Type de courrier","sample":"R\u00e9clamation","cssClasses":["align_leftData"],"icon":"fa-suitcase"},{"value":"getAssignee","label":"Attributaire (entit\u00e9 traitante)","sample":"Barbara BAIN (P\u00f4le Jeunesse et Sport)","cssClasses":["align_leftData"],"icon":"fa-sitemap"},{"value":"getRecipients","label":"Destinataire","sample":"Patricia PETIT","cssClasses":["align_leftData"],"icon":"fa-user"},{"value":"getSenders","label":"Exp\u00e9diteur","sample":"Bernard PASMECHANT","cssClasses":["align_leftData"],"icon":"fa-book"},{"value":"getCreationAndProcessLimitDates","label":"Date de cr\u00e9ation - Date limite de traitement","sample":"1er janv. - <i class=''fa fa-stopwatch''><\/i>&nbsp;<b style=''color:#8e3e52''>3 jour(s)<\/b>","cssClasses":["align_leftData"],"icon":"fa-calendar"},{"value":"getFolders","label":"Dossiers (emplacement fixe)","sample":"Litiges","cssClasses":["align_leftData"],"icon":"fa-folder"}]}', 'documentDetails', NULL),
                                                                                                               (13, 'AGENT', 'MyBasket', '{"templateColumns":7,"subInfos":[{"value":"getPriority","label":"Priorit\u00e9","sample":"Urgent","cssClasses":[],"icon":"fa-traffic-light"},{"value":"getCategory","label":"Cat\u00e9gorie","sample":"Courrier arriv\u00e9e","cssClasses":[],"icon":"fa-exchange-alt"},{"value":"getDoctype","label":"Type de courrier","sample":"R\u00e9clamation","cssClasses":[],"icon":"fa-suitcase"},{"value":"getAssignee","label":"Attributaire (entit\u00e9 traitante)","sample":"Barbara BAIN (P\u00f4le Jeunesse et Sport)","cssClasses":[],"icon":"fa-sitemap"},{"value":"getRecipients","label":"Destinataire","sample":"Patricia PETIT","cssClasses":[],"icon":"fa-user"},{"value":"getSenders","label":"Exp\u00e9diteur","sample":"Bernard PASMECHANT","cssClasses":[],"icon":"fa-book"},{"value":"getCreationAndProcessLimitDates","label":"Date de cr\u00e9ation - Date limite de traitement","sample":"1er janv. - <i class=''fa fa-stopwatch''><\/i>&nbsp;<b style=''color:#8e3e52''>3 jour(s)<\/b>","cssClasses":["align_rightData"],"icon":"fa-calendar"},{"value":"getFolders","label":"Dossiers (emplacement fixe)","sample":"Litiges","cssClasses":["align_leftData"],"icon":"fa-folder"}]}', 'processDocument', '{"defaultTab": "dashboard", "canUpdateData": false, "canUpdateModel": false}'),
                                                                                                               (132, 'MAIRE', 'DdeAvisBasket', '{"templateColumns":5,"subInfos":[{"value":"getPriority","label":"Priorit\u00e9","sample":"Urgent","cssClasses":[],"icon":"fa-traffic-light"},{"value":"getCategory","label":"Cat\u00e9gorie","sample":"Courrier arriv\u00e9e","cssClasses":[],"icon":"fa-exchange-alt"},{"value":"getDoctype","label":"Type de courrier","sample":"R\u00e9clamation","cssClasses":[],"icon":"fa-suitcase"},{"value":"getParallelOpinionsNumber","label":"Nombre d''avis donn\u00e9s","sample":"<b>3<\/b> avis donn\u00e9(s)","cssClasses":["align_rightData"],"icon":"fa-comment-alt"},{"value":"getOpinionLimitDate","label":"Date limite d''envoi des avis","sample":"01-01-2019","cssClasses":["align_rightData"],"icon":"fa-stopwatch"},{"value":"getFolders","label":"Dossiers (emplacement fixe)","sample":"Litiges","cssClasses":["align_leftData"],"icon":"fa-folder"}]}', 'processDocument', '{"defaultTab": "dashboard", "canUpdateData": false, "canUpdateModel": false}'),
                                                                                                               (74, 'DGS', 'DdeAvisBasket', '{"templateColumns":5,"subInfos":[{"value":"getPriority","label":"Priorit\u00e9","sample":"Urgent","cssClasses":[],"icon":"fa-traffic-light"},{"value":"getCategory","label":"Cat\u00e9gorie","sample":"Courrier arriv\u00e9e","cssClasses":[],"icon":"fa-exchange-alt"},{"value":"getDoctype","label":"Type de courrier","sample":"R\u00e9clamation","cssClasses":[],"icon":"fa-suitcase"},{"value":"getParallelOpinionsNumber","label":"Nombre d''avis donn\u00e9s","sample":"<b>3<\/b> avis donn\u00e9(s)","cssClasses":["align_rightData"],"icon":"fa-comment-alt"},{"value":"getOpinionLimitDate","label":"Date limite d''envoi des avis","sample":"01-01-2019","cssClasses":["align_rightData"],"icon":"fa-stopwatch"},{"value":"getFolders","label":"Dossiers (emplacement fixe)","sample":"Litiges","cssClasses":["align_leftData"],"icon":"fa-folder"}]}', 'processDocument', '{"defaultTab": "dashboard", "canUpdateData": false, "canUpdateModel": false}'),
                                                                                                               (68, 'RESPONSABLE', 'DdeAvisBasket', '{"templateColumns":5,"subInfos":[{"value":"getPriority","label":"Priorit\u00e9","sample":"Urgent","cssClasses":[],"icon":"fa-traffic-light"},{"value":"getCategory","label":"Cat\u00e9gorie","sample":"Courrier arriv\u00e9e","cssClasses":[],"icon":"fa-exchange-alt"},{"value":"getDoctype","label":"Type de courrier","sample":"R\u00e9clamation","cssClasses":[],"icon":"fa-suitcase"},{"value":"getParallelOpinionsNumber","label":"Nombre d''avis donn\u00e9s","sample":"<b>3<\/b> avis donn\u00e9(s)","cssClasses":["align_rightData"],"icon":"fa-comment-alt"},{"value":"getOpinionLimitDate","label":"Date limite d''envoi des avis","sample":"01-01-2019","cssClasses":["align_rightData"],"icon":"fa-stopwatch"},{"value":"getFolders","label":"Dossiers (emplacement fixe)","sample":"Litiges","cssClasses":["align_leftData"],"icon":"fa-folder"}]}', 'processDocument', '{"defaultTab": "dashboard", "canUpdateData": false, "canUpdateModel": false}'),
                                                                                                               (5, 'AGENT', 'DdeAvisBasket', '{"templateColumns":5,"subInfos":[{"value":"getPriority","label":"Priorit\u00e9","sample":"Urgent","cssClasses":[],"icon":"fa-traffic-light"},{"value":"getCategory","label":"Cat\u00e9gorie","sample":"Courrier arriv\u00e9e","cssClasses":[],"icon":"fa-exchange-alt"},{"value":"getDoctype","label":"Type de courrier","sample":"R\u00e9clamation","cssClasses":[],"icon":"fa-suitcase"},{"value":"getParallelOpinionsNumber","label":"Nombre d''avis donn\u00e9s","sample":"<b>3<\/b> avis donn\u00e9(s)","cssClasses":["align_rightData"],"icon":"fa-comment-alt"},{"value":"getOpinionLimitDate","label":"Date limite d''envoi des avis","sample":"01-01-2019","cssClasses":["align_rightData"],"icon":"fa-stopwatch"},{"value":"getFolders","label":"Dossiers (emplacement fixe)","sample":"Litiges","cssClasses":["align_leftData"],"icon":"fa-folder"}]}', 'processDocument', '{"defaultTab": "dashboard", "canUpdateData": false, "canUpdateModel": false}'),
                                                                                                               (130, 'COURRIER', 'SVEToQualify', '{"templateColumns":7,"subInfos":[{"value":"getPriority","label":"Priorit\u00e9","sample":"Urgent","cssClasses":["align_leftData"],"icon":"fa-traffic-light"},{"value":"getCategory","label":"Cat\u00e9gorie","sample":"Courrier arriv\u00e9e","cssClasses":["align_leftData"],"icon":"fa-exchange-alt"},{"value":"getDoctype","label":"Type de courrier","sample":"R\u00e9clamation","cssClasses":["align_leftData"],"icon":"fa-suitcase"},{"value":"getAssignee","label":"Attributaire (entit\u00e9 traitante)","sample":"Barbara BAIN (P\u00f4le Jeunesse et Sport)","cssClasses":["align_leftData"],"icon":"fa-sitemap"},{"value":"getSenders","label":"Exp\u00e9diteur","sample":"Bernard PASMECHANT","cssClasses":["align_leftData"],"icon":"fa-book"},{"value":"getCreationDate","label":"Date de cr\u00e9ation","sample":"1er janv.","cssClasses":["align_leftData"],"icon":"fa-calendar"},{"value":"getProcessLimitDate","label":"Date limite de traitement","sample":"<b style=''color:#8e3e52''>3 jour(s)<\/b>","cssClasses":["align_leftData"],"icon":"fa-stopwatch"},{"value":"getFolders","label":"Dossiers (emplacement fixe)","sample":"Litiges","cssClasses":["align_leftData"],"icon":"fa-folder"}]}', 'processDocument', '{"defaultTab": "info", "canUpdateData": true, "canUpdateModel": false}'),
                                                                                                               (8, 'AGENT', 'SupAvisBasket', '{"templateColumns":5,"subInfos":[{"value":"getPriority","label":"Priorité","sample":"Urgent","cssClasses":[],"icon":"fa-traffic-light"},{"value":"getCategory","label":"Catégorie","sample":"Courrier arrivée","cssClasses":[],"icon":"fa-exchange-alt"},{"value":"getDoctype","label":"Type de courrier","sample":"Réclamation","cssClasses":[],"icon":"fa-suitcase"},{"value":"getParallelOpinionsNumber","label":"Nombre d''avis donnés","sample":"<b>3</b> avis donné(s)","cssClasses":["align_rightData"],"icon":"fa-comment-alt"},{"value":"getOpinionLimitDate","label":"Date limite d''envoi des avis","sample":"01-01-2019","cssClasses":["align_rightData"],"icon":"fa-stopwatch"}]}', 'processDocument', '{"defaultTab": "dashboard", "canUpdateData": true, "canUpdateModel": false}'),
                                                                                                               (10, 'AGENT', 'RetAvisBasket', '{"templateColumns":5,"subInfos":[{"value":"getPriority","cssClasses":[],"icon":"fa-traffic-light"},{"value":"getCategory","cssClasses":[],"icon":"fa-exchange-alt"},{"value":"getDoctype","cssClasses":[],"icon":"fa-suitcase"},{"value":"getParallelOpinionsNumber","cssClasses":["align_rightData"],"icon":"fa-comment-alt"},{"value":"getOpinionLimitDate","cssClasses":["align_rightData"],"icon":"fa-stopwatch"}]}', 'processDocument', '{"defaultTab": "notes"}'),
                                                                                                               (21, 'AGENT', 'EenvBasket', '{"templateColumns":7,"subInfos":[{"value":"getPriority","label":"Priorit\u00e9","sample":"Urgent","cssClasses":[],"icon":"fa-traffic-light"},{"value":"getCategory","label":"Cat\u00e9gorie","sample":"Courrier arriv\u00e9e","cssClasses":[],"icon":"fa-exchange-alt"},{"value":"getDoctype","label":"Type de courrier","sample":"R\u00e9clamation","cssClasses":[],"icon":"fa-suitcase"},{"value":"getAssignee","label":"Attributaire (entit\u00e9 traitante)","sample":"Barbara BAIN (P\u00f4le Jeunesse et Sport)","cssClasses":[],"icon":"fa-sitemap"},{"value":"getRecipients","label":"Destinataire","sample":"Patricia PETIT","cssClasses":[],"icon":"fa-user"},{"value":"getSenders","label":"Exp\u00e9diteur","sample":"Bernard PASMECHANT","cssClasses":[],"icon":"fa-book"},{"value":"getCreationAndProcessLimitDates","label":"Date de cr\u00e9ation - Date limite de traitement","sample":"1er janv. - <i class=''fa fa-stopwatch''><\/i>&nbsp;<b style=''color:#8e3e52''>3 jour(s)<\/b>","cssClasses":["align_rightData"],"icon":"fa-calendar"},{"value":"getFolders","label":"Dossiers (emplacement fixe)","sample":"Litiges","cssClasses":["align_leftData"],"icon":"fa-folder"}]}', 'processDocument', '{"defaultTab": "emails", "canUpdateData": false, "canUpdateModel": false}'),
                                                                                                               (2, 'AGENT', 'CopyMailBasket', '{"templateColumns":7,"subInfos":[{"value":"getPriority","label":"Priorit\u00e9","sample":"Urgent","cssClasses":[],"icon":"fa-traffic-light"},{"value":"getCategory","label":"Cat\u00e9gorie","sample":"Courrier arriv\u00e9e","cssClasses":[],"icon":"fa-exchange-alt"},{"value":"getDoctype","label":"Type de courrier","sample":"R\u00e9clamation","cssClasses":[],"icon":"fa-suitcase"},{"value":"getAssignee","label":"Attributaire (entit\u00e9 traitante)","sample":"Barbara BAIN (P\u00f4le Jeunesse et Sport)","cssClasses":[],"icon":"fa-sitemap"},{"value":"getRecipients","label":"Destinataire","sample":"Patricia PETIT","cssClasses":[],"icon":"fa-user"},{"value":"getSenders","label":"Exp\u00e9diteur","sample":"Bernard PASMECHANT","cssClasses":[],"icon":"fa-book"},{"value":"getCreationAndProcessLimitDates","label":"Date de cr\u00e9ation - Date limite de traitement","sample":"1er janv. - <i class=''fa fa-stopwatch''><\/i>&nbsp;<b style=''color:#8e3e52''>3 jour(s)<\/b>","cssClasses":["align_rightData"],"icon":"fa-calendar"},{"value":"getFolders","label":"Dossiers (emplacement fixe)","sample":"Litiges","cssClasses":["align_leftData"],"icon":"fa-folder"}]}', 'documentDetails', NULL),
                                                                                                               (18, 'RESPONSABLE', 'ParafBasket', '{"templateColumns":6,"subInfos":[{"value":"getPriority","label":"Priorit\u00e9","sample":"Urgent","cssClasses":[],"icon":"fa-traffic-light"},{"value":"getDoctype","label":"Type de courrier","sample":"R\u00e9clamation","cssClasses":[],"icon":"fa-suitcase"},{"value":"getAssignee","label":"Attributaire (entit\u00e9 traitante)","sample":"Barbara BAIN (P\u00f4le Jeunesse et Sport)","cssClasses":[],"icon":"fa-sitemap"},{"value":"getRecipients","label":"Destinataire","sample":"Patricia PETIT","cssClasses":[],"icon":"fa-user"},{"value":"getSenders","label":"Exp\u00e9diteur","sample":"Bernard PASMECHANT","cssClasses":[],"icon":"fa-book"},{"value":"getFolders","label":"Dossiers (emplacement fixe)","sample":"Litiges","cssClasses":["align_leftData"],"icon":"fa-folder"},{"value":"getVisaWorkflow","label":"Circuit de visa","sample":"<i style=''color:#006841'' class=''fa fa-check''><\/i> Barbara BAIN -> <i class=''fa fa-hourglass-half''><\/i> <b>Bruno BOULE<\/b> -> <i class=''fa fa-hourglass-half''><\/i> Patricia PETIT","cssClasses":["align_leftData"],"icon":"fa-list-ol"}]}', 'signatureBookAction', '{"canUpdateDocuments": true}'),
                                                                                                               (39, 'ELU', 'CopyMailBasket', '{"templateColumns":7,"subInfos":[{"value":"getPriority","label":"Priorit\u00e9","sample":"Urgent","cssClasses":[],"icon":"fa-traffic-light"},{"value":"getCategory","label":"Cat\u00e9gorie","sample":"Courrier arriv\u00e9e","cssClasses":[],"icon":"fa-exchange-alt"},{"value":"getDoctype","label":"Type de courrier","sample":"R\u00e9clamation","cssClasses":[],"icon":"fa-suitcase"},{"value":"getAssignee","label":"Attributaire (entit\u00e9 traitante)","sample":"Barbara BAIN (P\u00f4le Jeunesse et Sport)","cssClasses":[],"icon":"fa-sitemap"},{"value":"getRecipients","label":"Destinataire","sample":"Patricia PETIT","cssClasses":[],"icon":"fa-user"},{"value":"getSenders","label":"Exp\u00e9diteur","sample":"Bernard PASMECHANT","cssClasses":[],"icon":"fa-book"},{"value":"getCreationAndProcessLimitDates","label":"Date de cr\u00e9ation - Date limite de traitement","sample":"1er janv. - <i class=''fa fa-stopwatch''><\/i>&nbsp;<b style=''color:#8e3e52''>3 jour(s)<\/b>","cssClasses":["align_rightData"],"icon":"fa-calendar"},{"value":"getFolders","label":"Dossiers (emplacement fixe)","sample":"Litiges","cssClasses":["align_leftData"],"icon":"fa-folder"}]}', 'documentDetails', NULL),
                                                                                                               (43, 'MAIRE', 'CopyMailBasket', '{"templateColumns":7,"subInfos":[{"value":"getPriority","label":"Priorit\u00e9","sample":"Urgent","cssClasses":[],"icon":"fa-traffic-light"},{"value":"getCategory","label":"Cat\u00e9gorie","sample":"Courrier arriv\u00e9e","cssClasses":[],"icon":"fa-exchange-alt"},{"value":"getDoctype","label":"Type de courrier","sample":"R\u00e9clamation","cssClasses":[],"icon":"fa-suitcase"},{"value":"getAssignee","label":"Attributaire (entit\u00e9 traitante)","sample":"Barbara BAIN (P\u00f4le Jeunesse et Sport)","cssClasses":[],"icon":"fa-sitemap"},{"value":"getRecipients","label":"Destinataire","sample":"Patricia PETIT","cssClasses":[],"icon":"fa-user"},{"value":"getSenders","label":"Exp\u00e9diteur","sample":"Bernard PASMECHANT","cssClasses":[],"icon":"fa-book"},{"value":"getCreationAndProcessLimitDates","label":"Date de cr\u00e9ation - Date limite de traitement","sample":"1er janv. - <i class=''fa fa-stopwatch''><\/i>&nbsp;<b style=''color:#8e3e52''>3 jour(s)<\/b>","cssClasses":["align_rightData"],"icon":"fa-calendar"},{"value":"getFolders","label":"Dossiers (emplacement fixe)","sample":"Litiges","cssClasses":["align_leftData"],"icon":"fa-folder"}]}', 'documentDetails', NULL),
                                                                                                               (46, 'AGENT', 'FindCopyMail', '{"subInfos":[],"templateColumns":0}', 'documentDetails', NULL),
                                                                                                               (47, 'ELU', 'FindCopyMail', '{"subInfos":[],"templateColumns":0}', 'documentDetails', NULL),
                                                                                                               (48, 'MAIRE', 'FindCopyMail', '{"subInfos":[],"templateColumns":0}', 'documentDetails', NULL),
                                                                                                               (52, 'COURRIER', 'EmailToQualify', '{"templateColumns":6,"subInfos":[{"value":"getPriority","label":"Priorit\u00e9","sample":"Urgent","cssClasses":["align_leftData"],"icon":"fa-traffic-light"},{"value":"getCategory","label":"Cat\u00e9gorie","sample":"Courrier arriv\u00e9e","cssClasses":["align_leftData"],"icon":"fa-exchange-alt"},{"value":"getDoctype","label":"Type de courrier","sample":"R\u00e9clamation","cssClasses":["align_leftData"],"icon":"fa-suitcase"},{"value":"getAssignee","label":"Attributaire (entit\u00e9 traitante)","sample":"Barbara BAIN (P\u00f4le Jeunesse et Sport)","cssClasses":["align_leftData"],"icon":"fa-sitemap"},{"value":"getSenders","label":"Exp\u00e9diteur","sample":"Bernard PASMECHANT","cssClasses":["align_leftData"],"icon":"fa-book"},{"value":"getCreationAndProcessLimitDates","label":"Date de cr\u00e9ation - Date limite de traitement","sample":"1er janv. - <i class=''fa fa-stopwatch''><\/i>&nbsp;<b style=''color:#8e3e52''>3 jour(s)<\/b>","cssClasses":["align_leftData"],"icon":"fa-calendar"},{"value":"getFolders","label":"Dossiers (emplacement fixe)","sample":"Litiges","cssClasses":["align_leftData"],"icon":"fa-folder"}]}', 'processDocument', '{"defaultTab": "info", "canUpdateData": true, "canUpdateModel": true}'),
                                                                                                               (55, 'WEBSERVICE', 'RECBASKET', '{"templateColumns":7,"subInfos":[{"value":"getPriority","label":"Priorit\u00e9","sample":"Urgent","cssClasses":["align_leftData"],"icon":"fa-traffic-light"},{"value":"getCategory","label":"Cat\u00e9gorie","sample":"Courrier arriv\u00e9e","cssClasses":["align_leftData"],"icon":"fa-exchange-alt"},{"value":"getDoctype","label":"Type de courrier","sample":"R\u00e9clamation","cssClasses":["align_leftData"],"icon":"fa-suitcase"},{"value":"getAssignee","label":"Attributaire (entit\u00e9 traitante)","sample":"Barbara BAIN (P\u00f4le Jeunesse et Sport)","cssClasses":["align_leftData"],"icon":"fa-sitemap"},{"value":"getRecipients","label":"Destinataire","sample":"Patricia PETIT","cssClasses":["align_leftData"],"icon":"fa-user"},{"value":"getSenders","label":"Exp\u00e9diteur","sample":"Bernard PASMECHANT","cssClasses":["align_leftData"],"icon":"fa-book"},{"value":"getCreationAndProcessLimitDates","label":"Date de cr\u00e9ation - Date limite de traitement","sample":"1er janv. - <i class=''fa fa-stopwatch''><\/i>&nbsp;<b style=''color:#8e3e52''>3 jour(s)<\/b>","cssClasses":["align_leftData"],"icon":"fa-calendar"}]}', 'viewDoc', NULL),
                                                                                                               (58, 'RESP_COURRIER', 'ValAtrBasket', '{"templateColumns":7,"subInfos":[{"value":"getCategory","label":"Cat\u00e9gorie","sample":"Courrier arriv\u00e9e","cssClasses":["align_leftData"],"icon":"fa-exchange-alt"},{"value":"getDoctype","label":"Type de courrier","sample":"R\u00e9clamation","cssClasses":["align_leftData"],"icon":"fa-suitcase"},{"value":"getAssignee","label":"Attributaire (entit\u00e9 traitante)","sample":"Barbara BAIN (P\u00f4le Jeunesse et Sport)","cssClasses":["align_leftData"],"icon":"fa-sitemap"},{"value":"getRecipients","label":"Destinataire","sample":"Patricia PETIT","cssClasses":["align_leftData"],"icon":"fa-user"},{"value":"getSenders","label":"Exp\u00e9diteur","sample":"Bernard PASMECHANT","cssClasses":["align_leftData"],"icon":"fa-book"},{"value":"getProcessLimitDate","label":"Date limite de traitement","sample":"<b style=''color:#8e3e52''>3 jour(s)<\/b>","cssClasses":["align_leftData"],"icon":"fa-stopwatch"},{"value":"getCreationDate","label":"Date de cr\u00e9ation","sample":"1er janv.","cssClasses":["align_leftData"],"icon":"fa-calendar"},{"value":"getFolders","label":"Dossiers (emplacement fixe)","sample":"Litiges","cssClasses":["align_leftData"],"icon":"fa-folder"}]}', 'processDocument', '{"defaultTab": "info", "canUpdateData": true, "canUpdateModel": true}'),
                                                                                                               (63, 'DGS', 'ValAtrBasket', '{"templateColumns":7,"subInfos":[{"value":"getCategory","label":"Cat\u00e9gorie","sample":"Courrier arriv\u00e9e","cssClasses":["align_leftData"],"icon":"fa-exchange-alt"},{"value":"getDoctype","label":"Type de courrier","sample":"R\u00e9clamation","cssClasses":["align_leftData"],"icon":"fa-suitcase"},{"value":"getAssignee","label":"Attributaire (entit\u00e9 traitante)","sample":"Barbara BAIN (P\u00f4le Jeunesse et Sport)","cssClasses":["align_leftData"],"icon":"fa-sitemap"},{"value":"getRecipients","label":"Destinataire","sample":"Patricia PETIT","cssClasses":["align_leftData"],"icon":"fa-user"},{"value":"getSenders","label":"Exp\u00e9diteur","sample":"Bernard PASMECHANT","cssClasses":["align_leftData"],"icon":"fa-book"},{"value":"getProcessLimitDate","label":"Date limite de traitement","sample":"<b style=''color:#8e3e52''>3 jour(s)<\/b>","cssClasses":["align_leftData"],"icon":"fa-stopwatch"},{"value":"getCreationDate","label":"Date de cr\u00e9ation","sample":"1er janv.","cssClasses":["align_leftData"],"icon":"fa-calendar"},{"value":"getFolders","label":"Dossiers (emplacement fixe)","sample":"Litiges","cssClasses":["align_leftData"],"icon":"fa-folder"}]}', 'processDocument', '{"defaultTab": "diffusionList", "canUpdateData": true, "canUpdateModel": false}'),
                                                                                                               (72, 'DGS', 'CopyMailBasket', '{"templateColumns":7,"subInfos":[{"value":"getPriority","label":"Priorit\u00e9","sample":"Urgent","cssClasses":[],"icon":"fa-traffic-light"},{"value":"getCategory","label":"Cat\u00e9gorie","sample":"Courrier arriv\u00e9e","cssClasses":[],"icon":"fa-exchange-alt"},{"value":"getDoctype","label":"Type de courrier","sample":"R\u00e9clamation","cssClasses":[],"icon":"fa-suitcase"},{"value":"getAssignee","label":"Attributaire (entit\u00e9 traitante)","sample":"Barbara BAIN (P\u00f4le Jeunesse et Sport)","cssClasses":[],"icon":"fa-sitemap"},{"value":"getRecipients","label":"Destinataire","sample":"Patricia PETIT","cssClasses":[],"icon":"fa-user"},{"value":"getSenders","label":"Exp\u00e9diteur","sample":"Bernard PASMECHANT","cssClasses":[],"icon":"fa-book"},{"value":"getCreationAndProcessLimitDates","label":"Date de cr\u00e9ation - Date limite de traitement","sample":"1er janv. - <i class=''fa fa-stopwatch''><\/i>&nbsp;<b style=''color:#8e3e52''>3 jour(s)<\/b>","cssClasses":["align_rightData"],"icon":"fa-calendar"},{"value":"getFolders","label":"Dossiers (emplacement fixe)","sample":"Litiges","cssClasses":["align_leftData"],"icon":"fa-folder"}]}', 'documentDetails', NULL),
                                                                                                               (73, 'DGS', 'FindCopyMail', '{"subInfos":[],"templateColumns":0}', 'documentDetails', NULL),
                                                                                                               (75, 'RESPONSABLE', 'CopyMailBasket', '{"templateColumns":7,"subInfos":[{"value":"getPriority","label":"Priorit\u00e9","sample":"Urgent","cssClasses":[],"icon":"fa-traffic-light"},{"value":"getCategory","label":"Cat\u00e9gorie","sample":"Courrier arriv\u00e9e","cssClasses":[],"icon":"fa-exchange-alt"},{"value":"getDoctype","label":"Type de courrier","sample":"R\u00e9clamation","cssClasses":[],"icon":"fa-suitcase"},{"value":"getAssignee","label":"Attributaire (entit\u00e9 traitante)","sample":"Barbara BAIN (P\u00f4le Jeunesse et Sport)","cssClasses":[],"icon":"fa-sitemap"},{"value":"getRecipients","label":"Destinataire","sample":"Patricia PETIT","cssClasses":[],"icon":"fa-user"},{"value":"getSenders","label":"Exp\u00e9diteur","sample":"Bernard PASMECHANT","cssClasses":[],"icon":"fa-book"},{"value":"getCreationAndProcessLimitDates","label":"Date de cr\u00e9ation - Date limite de traitement","sample":"1er janv. - <i class=''fa fa-stopwatch''><\/i>&nbsp;<b style=''color:#8e3e52''>3 jour(s)<\/b>","cssClasses":["align_rightData"],"icon":"fa-calendar"},{"value":"getFolders","label":"Dossiers (emplacement fixe)","sample":"Litiges","cssClasses":["align_leftData"],"icon":"fa-folder"}]}', 'documentDetails', NULL),
                                                                                                               (76, 'RESPONSABLE', 'EenvBasket', '{"templateColumns":7,"subInfos":[{"value":"getPriority","label":"Priorit\u00e9","sample":"Urgent","cssClasses":[],"icon":"fa-traffic-light"},{"value":"getCategory","label":"Cat\u00e9gorie","sample":"Courrier arriv\u00e9e","cssClasses":[],"icon":"fa-exchange-alt"},{"value":"getDoctype","label":"Type de courrier","sample":"R\u00e9clamation","cssClasses":[],"icon":"fa-suitcase"},{"value":"getAssignee","label":"Attributaire (entit\u00e9 traitante)","sample":"Barbara BAIN (P\u00f4le Jeunesse et Sport)","cssClasses":[],"icon":"fa-sitemap"},{"value":"getRecipients","label":"Destinataire","sample":"Patricia PETIT","cssClasses":[],"icon":"fa-user"},{"value":"getSenders","label":"Exp\u00e9diteur","sample":"Bernard PASMECHANT","cssClasses":[],"icon":"fa-book"},{"value":"getCreationAndProcessLimitDates","label":"Date de cr\u00e9ation - Date limite de traitement","sample":"1er janv. - <i class=''fa fa-stopwatch''><\/i>&nbsp;<b style=''color:#8e3e52''>3 jour(s)<\/b>","cssClasses":["align_rightData"],"icon":"fa-calendar"},{"value":"getFolders","label":"Dossiers (emplacement fixe)","sample":"Litiges","cssClasses":["align_leftData"],"icon":"fa-folder"}]}', 'processDocument', '{"defaultTab": "emails", "canUpdateData": false, "canUpdateModel": false}'),
                                                                                                               (77, 'RESPONSABLE', 'FindCopyMail', '{"subInfos":[],"templateColumns":0}', 'documentDetails', NULL),
                                                                                                               (79, 'RESPONSABLE', 'RetAvisBasket', '{"templateColumns":5,"subInfos":[{"value":"getPriority","cssClasses":[],"icon":"fa-traffic-light"},{"value":"getCategory","cssClasses":[],"icon":"fa-exchange-alt"},{"value":"getDoctype","cssClasses":[],"icon":"fa-suitcase"},{"value":"getParallelOpinionsNumber","cssClasses":["align_rightData"],"icon":"fa-comment-alt"},{"value":"getOpinionLimitDate","cssClasses":["align_rightData"],"icon":"fa-stopwatch"}]}', 'processDocument', '{"defaultTab": "notes", "canUpdateData": false, "canUpdateModel": false}'),
                                                                                                               (81, 'RESPONSABLE', 'SupAvisBasket', '{"templateColumns":5,"subInfos":[{"value":"getPriority","label":"Priorit\u00e9","sample":"Urgent","cssClasses":[],"icon":"fa-traffic-light"},{"value":"getCategory","label":"Cat\u00e9gorie","sample":"Courrier arriv\u00e9e","cssClasses":[],"icon":"fa-exchange-alt"},{"value":"getDoctype","label":"Type de courrier","sample":"R\u00e9clamation","cssClasses":[],"icon":"fa-suitcase"},{"value":"getParallelOpinionsNumber","label":"Nombre d''avis donn\u00e9s","sample":"<b>3<\/b> avis donn\u00e9(s)","cssClasses":["align_rightData"],"icon":"fa-comment-alt"},{"value":"getOpinionLimitDate","label":"Date limite d''envoi des avis","sample":"01-01-2019","cssClasses":["align_rightData"],"icon":"fa-stopwatch"}]}', 'processDocument', '{"defaultTab": "dashboard", "canUpdateData": true, "canUpdateModel": false}'),
                                                                                                               (91, 'COURRIER', 'RetourCourrier', '{"templateColumns":7,"subInfos":[{"value":"getPriority","label":"Priorit\u00e9","sample":"Urgent","cssClasses":["align_leftData"],"icon":"fa-traffic-light"},{"value":"getCategory","label":"Cat\u00e9gorie","sample":"Courrier arriv\u00e9e","cssClasses":["align_leftData"],"icon":"fa-exchange-alt"},{"value":"getDoctype","label":"Type de courrier","sample":"R\u00e9clamation","cssClasses":["align_leftData"],"icon":"fa-suitcase"},{"value":"getAssignee","label":"Attributaire (entit\u00e9 traitante)","sample":"Barbara BAIN (P\u00f4le Jeunesse et Sport)","cssClasses":["align_leftData"],"icon":"fa-sitemap"},{"value":"getRecipients","label":"Destinataire","sample":"Patricia PETIT","cssClasses":["align_leftData"],"icon":"fa-user"},{"value":"getSenders","label":"Exp\u00e9diteur","sample":"Bernard PASMECHANT","cssClasses":["align_leftData"],"icon":"fa-book"},{"value":"getCreationAndProcessLimitDates","label":"Date de cr\u00e9ation - Date limite de traitement","sample":"1er janv. - <i class=''fa fa-stopwatch''><\/i>&nbsp;<b style=''color:#8e3e52''>3 jour(s)<\/b>","cssClasses":["align_leftData"],"icon":"fa-calendar"},{"value":"getFolders","label":"Dossiers (emplacement fixe)","sample":"Litiges","cssClasses":["align_leftData"],"icon":"fa-folder"}]}', 'processDocument', '{"defaultTab": "info", "canUpdateData": true, "canUpdateModel": true}'),
                                                                                                               (80, 'RESPONSABLE', 'SuiviParafBasket', '{"templateColumns":6,"subInfos":[{"value":"getPriority","label":"Priorit\u00e9","sample":"Urgent","cssClasses":[],"icon":"fa-traffic-light"},{"value":"getDoctype","label":"Type de courrier","sample":"R\u00e9clamation","cssClasses":[],"icon":"fa-suitcase"},{"value":"getAssignee","label":"Attributaire (entit\u00e9 traitante)","sample":"Barbara BAIN (P\u00f4le Jeunesse et Sport)","cssClasses":[],"icon":"fa-sitemap"},{"value":"getRecipients","label":"Destinataire","sample":"Patricia PETIT","cssClasses":[],"icon":"fa-user"},{"value":"getSenders","label":"Exp\u00e9diteur","sample":"Bernard PASMECHANT","cssClasses":[],"icon":"fa-book"},{"value":"getFolders","label":"Dossiers (emplacement fixe)","sample":"Litiges","cssClasses":["align_leftData"],"icon":"fa-folder"},{"value":"getVisaWorkflow","label":"Circuit de visa","sample":"<i style=''color:#006841'' class=''fa fa-check''><\/i> Barbara BAIN -> <i class=''fa fa-hourglass-half''><\/i> <b>Bruno BOULE<\/b> -> <i class=''fa fa-hourglass-half''><\/i> Patricia PETIT","cssClasses":["align_leftData"],"icon":"fa-list-ol"}]}', 'documentDetails', NULL),
                                                                                                               (87, 'DGS', 'ParafBasket', '{"templateColumns":6,"subInfos":[{"value":"getPriority","label":"Priorit\u00e9","sample":"Urgent","cssClasses":[],"icon":"fa-traffic-light"},{"value":"getDoctype","label":"Type de courrier","sample":"R\u00e9clamation","cssClasses":[],"icon":"fa-suitcase"},{"value":"getAssignee","label":"Attributaire (entit\u00e9 traitante)","sample":"Barbara BAIN (P\u00f4le Jeunesse et Sport)","cssClasses":[],"icon":"fa-sitemap"},{"value":"getRecipients","label":"Destinataire","sample":"Patricia PETIT","cssClasses":[],"icon":"fa-user"},{"value":"getSenders","label":"Exp\u00e9diteur","sample":"Bernard PASMECHANT","cssClasses":[],"icon":"fa-book"},{"value":"getFolders","label":"Dossiers (emplacement fixe)","sample":"Litiges","cssClasses":["align_leftData"],"icon":"fa-folder"},{"value":"getVisaWorkflow","label":"Circuit de visa","sample":"<i style=''color:#006841'' class=''fa fa-check''><\/i> Barbara BAIN -> <i class=''fa fa-hourglass-half''><\/i> <b>Bruno BOULE<\/b> -> <i class=''fa fa-hourglass-half''><\/i> Patricia PETIT","cssClasses":["align_leftData"],"icon":"fa-list-ol"}]}', 'signatureBookAction', '{"canUpdateDocuments": true}'),
                                                                                                               (92, 'DIRECTEUR', 'ValAtrBasket', '{"templateColumns":7,"subInfos":[{"value":"getCategory","label":"Cat\u00e9gorie","sample":"Courrier arriv\u00e9e","cssClasses":["align_leftData"],"icon":"fa-exchange-alt"},{"value":"getDoctype","label":"Type de courrier","sample":"R\u00e9clamation","cssClasses":["align_leftData"],"icon":"fa-suitcase"},{"value":"getAssignee","label":"Attributaire (entit\u00e9 traitante)","sample":"Barbara BAIN (P\u00f4le Jeunesse et Sport)","cssClasses":["align_leftData"],"icon":"fa-sitemap"},{"value":"getRecipients","label":"Destinataire","sample":"Patricia PETIT","cssClasses":["align_leftData"],"icon":"fa-user"},{"value":"getSenders","label":"Exp\u00e9diteur","sample":"Bernard PASMECHANT","cssClasses":["align_leftData"],"icon":"fa-book"},{"value":"getProcessLimitDate","label":"Date limite de traitement","sample":"<b style=''color:#8e3e52''>3 jour(s)<\/b>","cssClasses":["align_leftData"],"icon":"fa-stopwatch"},{"value":"getCreationDate","label":"Date de cr\u00e9ation","sample":"1er janv.","cssClasses":["align_leftData"],"icon":"fa-calendar"},{"value":"getFolders","label":"Dossiers (emplacement fixe)","sample":"Litiges","cssClasses":["align_leftData"],"icon":"fa-folder"}]}', 'processDocument', '{"defaultTab": "diffusionList", "canUpdateData": true, "canUpdateModel": false}'),
                                                                                                               (1, 'COURRIER', 'QualificationBasket', '{"templateColumns":6,"subInfos":[{"value":"getPriority","label":"Priorit\u00e9","sample":"Urgent","cssClasses":[],"icon":"fa-traffic-light"},{"value":"getCategory","label":"Cat\u00e9gorie","sample":"Courrier arriv\u00e9e","cssClasses":[],"icon":"fa-exchange-alt"},{"value":"getDoctype","label":"Type de courrier","sample":"R\u00e9clamation","cssClasses":[],"icon":"fa-suitcase"},{"value":"getAssignee","label":"Attributaire (entit\u00e9 traitante)","sample":"Barbara BAIN (P\u00f4le Jeunesse et Sport)","cssClasses":[],"icon":"fa-sitemap"},{"value":"getSenders","label":"Exp\u00e9diteur","sample":"Bernard PASMECHANT","cssClasses":[],"icon":"fa-book"},{"value":"getCreationAndProcessLimitDates","label":"Date de cr\u00e9ation - Date limite de traitement","sample":"1er janv. - <i class=''fa fa-stopwatch''><\/i>&nbsp;<b style=''color:#8e3e52''>3 jour(s)<\/b>","cssClasses":["align_rightData"],"icon":"fa-calendar"},{"value":"getFolders","label":"Dossiers (emplacement fixe)","sample":"Litiges","cssClasses":["align_leftData"],"icon":"fa-folder"}]}', 'processDocument', '{"defaultTab": "info", "canUpdateData": true, "canUpdateModel": false}'),
                                                                                                               (108, 'RESPONSABLE', 'WaitXPBasket', '{"templateColumns":6,"subInfos":[{"value":"getPriority","label":"Priorit\u00e9","sample":"Urgent","cssClasses":["align_leftData"],"icon":"fa-traffic-light"},{"value":"getDoctype","label":"Type de courrier","sample":"R\u00e9clamation","cssClasses":["align_leftData"],"icon":"fa-suitcase"},{"value":"getAssignee","label":"Attributaire (entit\u00e9 traitante)","sample":"Barbara BAIN (P\u00f4le Jeunesse et Sport)","cssClasses":["align_leftData"],"icon":"fa-sitemap"},{"value":"getRecipients","label":"Destinataire","sample":"Patricia PETIT","cssClasses":["align_leftData"],"icon":"fa-user"},{"value":"getSenders","label":"Exp\u00e9diteur","sample":"Bernard PASMECHANT","cssClasses":["align_leftData"],"icon":"fa-book"},{"value":"getFolders","label":"Dossiers (emplacement fixe)","sample":"Litiges","cssClasses":["align_leftData"],"icon":"fa-folder"},{"value":"getVisaWorkflow","label":"Circuit de visa","sample":"<i style=''color:#006841'' class=''fa fa-check''><\/i> Barbara BAIN -> <i class=''fa fa-hourglass-half''><\/i> <b>Bruno BOULE<\/b> -> <i class=''fa fa-hourglass-half''><\/i> Patricia PETIT","cssClasses":["align_leftData"],"icon":"fa-list-ol"}]}', 'documentDetails', NULL),
                                                                                                               (117, 'ASSISTDGS', 'ValAtrDGSBasket', '{"templateColumns":7,"subInfos":[{"value":"getPriority","label":"Priorit\u00e9","sample":"Urgent","cssClasses":["align_leftData"],"icon":"fa-traffic-light"},{"value":"getCategory","label":"Cat\u00e9gorie","sample":"Courrier arriv\u00e9e","cssClasses":["align_leftData"],"icon":"fa-exchange-alt"},{"value":"getDoctype","label":"Type de courrier","sample":"R\u00e9clamation","cssClasses":["align_leftData"],"icon":"fa-suitcase"},{"value":"getAssignee","label":"Attributaire (entit\u00e9 traitante)","sample":"Barbara BAIN (P\u00f4le Jeunesse et Sport)","cssClasses":["align_leftData"],"icon":"fa-sitemap"},{"value":"getRecipients","label":"Destinataire","sample":"Patricia PETIT","cssClasses":["align_leftData"],"icon":"fa-user"},{"value":"getSenders","label":"Exp\u00e9diteur","sample":"Bernard PASMECHANT","cssClasses":["align_leftData"],"icon":"fa-book"},{"value":"getCreationAndProcessLimitDates","label":"Date de cr\u00e9ation - Date limite de traitement","sample":"1er janv. - <i class=''fa fa-stopwatch''><\/i>&nbsp;<b style=''color:#8e3e52''>3 jour(s)<\/b>","cssClasses":["align_leftData"],"icon":"fa-calendar"},{"value":"getFolders","label":"Dossiers (emplacement fixe)","sample":"Litiges","cssClasses":["align_leftData"],"icon":"fa-folder"}]}', 'processDocument', '{"defaultTab": "diffusionList", "canUpdateData": true, "canUpdateModel": false}'),
                                                                                                               (121, 'DGS', 'DepartmentBasket', '{"templateColumns":7,"subInfos":[{"value":"getPriority","label":"Priorit\u00e9","sample":"Urgent","cssClasses":["align_leftData"],"icon":"fa-traffic-light"},{"value":"getCategory","label":"Cat\u00e9gorie","sample":"Courrier arriv\u00e9e","cssClasses":["align_leftData"],"icon":"fa-exchange-alt"},{"value":"getDoctype","label":"Type de courrier","sample":"R\u00e9clamation","cssClasses":["align_leftData"],"icon":"fa-suitcase"},{"value":"getAssignee","label":"Attributaire (entit\u00e9 traitante)","sample":"Barbara BAIN (P\u00f4le Jeunesse et Sport)","cssClasses":["align_leftData"],"icon":"fa-sitemap"},{"value":"getRecipients","label":"Destinataire","sample":"Patricia PETIT","cssClasses":["align_leftData"],"icon":"fa-user"},{"value":"getSenders","label":"Exp\u00e9diteur","sample":"Bernard PASMECHANT","cssClasses":["align_leftData"],"icon":"fa-book"},{"value":"getCreationAndProcessLimitDates","label":"Date de cr\u00e9ation - Date limite de traitement","sample":"1er janv. - <i class=''fa fa-stopwatch''><\/i>&nbsp;<b style=''color:#8e3e52''>3 jour(s)<\/b>","cssClasses":["align_leftData"],"icon":"fa-calendar"},{"value":"getFolders","label":"Dossiers (emplacement fixe)","sample":"Litiges","cssClasses":["align_leftData"],"icon":"fa-folder"}]}', 'documentDetails', NULL),
                                                                                                               (122, 'RESPONSABLE', 'DepartmentBasket', '{"templateColumns":7,"subInfos":[{"value":"getPriority","label":"Priorit\u00e9","sample":"Urgent","cssClasses":["align_leftData"],"icon":"fa-traffic-light"},{"value":"getCategory","label":"Cat\u00e9gorie","sample":"Courrier arriv\u00e9e","cssClasses":["align_leftData"],"icon":"fa-exchange-alt"},{"value":"getDoctype","label":"Type de courrier","sample":"R\u00e9clamation","cssClasses":["align_leftData"],"icon":"fa-suitcase"},{"value":"getAssignee","label":"Attributaire (entit\u00e9 traitante)","sample":"Barbara BAIN (P\u00f4le Jeunesse et Sport)","cssClasses":["align_leftData"],"icon":"fa-sitemap"},{"value":"getRecipients","label":"Destinataire","sample":"Patricia PETIT","cssClasses":["align_leftData"],"icon":"fa-user"},{"value":"getSenders","label":"Exp\u00e9diteur","sample":"Bernard PASMECHANT","cssClasses":["align_leftData"],"icon":"fa-book"},{"value":"getCreationAndProcessLimitDates","label":"Date de cr\u00e9ation - Date limite de traitement","sample":"1er janv. - <i class=''fa fa-stopwatch''><\/i>&nbsp;<b style=''color:#8e3e52''>3 jour(s)<\/b>","cssClasses":["align_leftData"],"icon":"fa-calendar"},{"value":"getFolders","label":"Dossiers (emplacement fixe)","sample":"Litiges","cssClasses":["align_leftData"],"icon":"fa-folder"}]}', 'documentDetails', NULL),
                                                                                                               (124, 'COURRIER', 'RECBASKET', '{"templateColumns":7,"subInfos":[{"value":"getPriority","label":"Priorit\u00e9","sample":"Urgent","cssClasses":["align_leftData"],"icon":"fa-traffic-light"},{"value":"getCategory","label":"Cat\u00e9gorie","sample":"Courrier arriv\u00e9e","cssClasses":["align_leftData"],"icon":"fa-exchange-alt"},{"value":"getDoctype","label":"Type de courrier","sample":"R\u00e9clamation","cssClasses":["align_leftData"],"icon":"fa-suitcase"},{"value":"getAssignee","label":"Attributaire (entit\u00e9 traitante)","sample":"Barbara BAIN (P\u00f4le Jeunesse et Sport)","cssClasses":["align_leftData"],"icon":"fa-sitemap"},{"value":"getRecipients","label":"Destinataire","sample":"Patricia PETIT","cssClasses":["align_leftData"],"icon":"fa-user"},{"value":"getSenders","label":"Exp\u00e9diteur","sample":"Bernard PASMECHANT","cssClasses":["align_leftData"],"icon":"fa-book"},{"value":"getCreationAndProcessLimitDates","label":"Date de cr\u00e9ation - Date limite de traitement","sample":"1er janv. - <i class=''fa fa-stopwatch''><\/i>&nbsp;<b style=''color:#8e3e52''>3 jour(s)<\/b>","cssClasses":["align_leftData"],"icon":"fa-calendar"}]}', 'viewDoc', NULL),
                                                                                                               (125, 'AGENT', 'LetterToPrint', '{"templateColumns":7,"subInfos":[{"value":"getPriority","label":"Priorit\u00e9","sample":"Urgent","cssClasses":["align_leftData"],"icon":"fa-traffic-light"},{"value":"getCategory","label":"Cat\u00e9gorie","sample":"Courrier arriv\u00e9e","cssClasses":["align_leftData"],"icon":"fa-exchange-alt"},{"value":"getDoctype","label":"Type de courrier","sample":"R\u00e9clamation","cssClasses":["align_leftData"],"icon":"fa-suitcase"},{"value":"getAssignee","label":"Attributaire (entit\u00e9 traitante)","sample":"Barbara BAIN (P\u00f4le Jeunesse et Sport)","cssClasses":["align_leftData"],"icon":"fa-sitemap"},{"value":"getRecipients","label":"Destinataire","sample":"Patricia PETIT","cssClasses":["align_leftData"],"icon":"fa-user"},{"value":"getSenders","label":"Exp\u00e9diteur","sample":"Bernard PASMECHANT","cssClasses":["align_leftData"],"icon":"fa-book"},{"value":"getCreationAndProcessLimitDates","label":"Date de cr\u00e9ation - Date limite de traitement","sample":"1er janv. - <i class=''fa fa-stopwatch''><\/i>&nbsp;<b style=''color:#8e3e52''>3 jour(s)<\/b>","cssClasses":["align_leftData"],"icon":"fa-calendar"},{"value":"getFolders","label":"Dossiers (emplacement fixe)","sample":"Litiges","cssClasses":["align_leftData"],"icon":"fa-folder"}]}', 'processDocument', '{"defaultTab": "dashboard", "canUpdateData": false, "canUpdateModel": false}'),
                                                                                                               (126, 'RESPONSABLE', 'LetterToPrint', '{"templateColumns":7,"subInfos":[{"value":"getPriority","label":"Priorit\u00e9","sample":"Urgent","cssClasses":["align_leftData"],"icon":"fa-traffic-light"},{"value":"getCategory","label":"Cat\u00e9gorie","sample":"Courrier arriv\u00e9e","cssClasses":["align_leftData"],"icon":"fa-exchange-alt"},{"value":"getDoctype","label":"Type de courrier","sample":"R\u00e9clamation","cssClasses":["align_leftData"],"icon":"fa-suitcase"},{"value":"getAssignee","label":"Attributaire (entit\u00e9 traitante)","sample":"Barbara BAIN (P\u00f4le Jeunesse et Sport)","cssClasses":["align_leftData"],"icon":"fa-sitemap"},{"value":"getRecipients","label":"Destinataire","sample":"Patricia PETIT","cssClasses":["align_leftData"],"icon":"fa-user"},{"value":"getSenders","label":"Exp\u00e9diteur","sample":"Bernard PASMECHANT","cssClasses":["align_leftData"],"icon":"fa-book"},{"value":"getCreationAndProcessLimitDates","label":"Date de cr\u00e9ation - Date limite de traitement","sample":"1er janv. - <i class=''fa fa-stopwatch''><\/i>&nbsp;<b style=''color:#8e3e52''>3 jour(s)<\/b>","cssClasses":["align_leftData"],"icon":"fa-calendar"},{"value":"getFolders","label":"Dossiers (emplacement fixe)","sample":"Litiges","cssClasses":["align_leftData"],"icon":"fa-folder"}]}', 'processDocument', '{"defaultTab": "dashboard", "canUpdateData": false, "canUpdateModel": false}'),
                                                                                                               (127, 'AGENT', 'WaitBasket', '{"templateColumns":7,"subInfos":[{"value":"getPriority","label":"Priorit\u00e9","sample":"Urgent","cssClasses":["align_leftData"],"icon":"fa-traffic-light"},{"value":"getCategory","label":"Cat\u00e9gorie","sample":"Courrier arriv\u00e9e","cssClasses":["align_leftData"],"icon":"fa-exchange-alt"},{"value":"getDoctype","label":"Type de courrier","sample":"R\u00e9clamation","cssClasses":["align_leftData"],"icon":"fa-suitcase"},{"value":"getAssignee","label":"Attributaire (entit\u00e9 traitante)","sample":"Barbara BAIN (P\u00f4le Jeunesse et Sport)","cssClasses":["align_leftData"],"icon":"fa-sitemap"},{"value":"getRecipients","label":"Destinataire","sample":"Patricia PETIT","cssClasses":["align_leftData"],"icon":"fa-user"},{"value":"getSenders","label":"Exp\u00e9diteur","sample":"Bernard PASMECHANT","cssClasses":["align_leftData"],"icon":"fa-book"},{"value":"getCreationAndProcessLimitDates","label":"Date de cr\u00e9ation - Date limite de traitement","sample":"1er janv. - <i class=''fa fa-stopwatch''><\/i>&nbsp;<b style=''color:#8e3e52''>3 jour(s)<\/b>","cssClasses":["align_leftData"],"icon":"fa-calendar"},{"value":"getFolders","label":"Dossiers (emplacement fixe)","sample":"Litiges","cssClasses":["align_leftData"],"icon":"fa-folder"}]}', 'processDocument', '{"defaultTab": "dashboard", "canUpdateData": false, "canUpdateModel": false}'),
                                                                                                               (128, 'RESPONSABLE', 'WaitBasket', '{"templateColumns":7,"subInfos":[{"value":"getPriority","label":"Priorit\u00e9","sample":"Urgent","cssClasses":["align_leftData"],"icon":"fa-traffic-light"},{"value":"getCategory","label":"Cat\u00e9gorie","sample":"Courrier arriv\u00e9e","cssClasses":["align_leftData"],"icon":"fa-exchange-alt"},{"value":"getDoctype","label":"Type de courrier","sample":"R\u00e9clamation","cssClasses":["align_leftData"],"icon":"fa-suitcase"},{"value":"getAssignee","label":"Attributaire (entit\u00e9 traitante)","sample":"Barbara BAIN (P\u00f4le Jeunesse et Sport)","cssClasses":["align_leftData"],"icon":"fa-sitemap"},{"value":"getRecipients","label":"Destinataire","sample":"Patricia PETIT","cssClasses":["align_leftData"],"icon":"fa-user"},{"value":"getSenders","label":"Exp\u00e9diteur","sample":"Bernard PASMECHANT","cssClasses":["align_leftData"],"icon":"fa-book"},{"value":"getCreationAndProcessLimitDates","label":"Date de cr\u00e9ation - Date limite de traitement","sample":"1er janv. - <i class=''fa fa-stopwatch''><\/i>&nbsp;<b style=''color:#8e3e52''>3 jour(s)<\/b>","cssClasses":["align_leftData"],"icon":"fa-calendar"},{"value":"getFolders","label":"Dossiers (emplacement fixe)","sample":"Litiges","cssClasses":["align_leftData"],"icon":"fa-folder"}]}', 'processDocument', '{"defaultTab": "dashboard", "canUpdateData": false, "canUpdateModel": false}'),
                                                                                                               (129, 'COURRIER', 'ManualReconBasket', '{"templateColumns":7,"subInfos":[{"value":"getPriority","label":"Priorit\u00e9","sample":"Urgent","cssClasses":["align_leftData"],"icon":"fa-traffic-light"},{"value":"getCategory","label":"Cat\u00e9gorie","sample":"Courrier arriv\u00e9e","cssClasses":["align_leftData"],"icon":"fa-exchange-alt"},{"value":"getDoctype","label":"Type de courrier","sample":"R\u00e9clamation","cssClasses":["align_leftData"],"icon":"fa-suitcase"},{"value":"getAssignee","label":"Attributaire (entit\u00e9 traitante)","sample":"Barbara BAIN (P\u00f4le Jeunesse et Sport)","cssClasses":["align_leftData"],"icon":"fa-sitemap"},{"value":"getRecipients","label":"Destinataire","sample":"Patricia PETIT","cssClasses":["align_leftData"],"icon":"fa-user"},{"value":"getSenders","label":"Exp\u00e9diteur","sample":"Bernard PASMECHANT","cssClasses":["align_leftData"],"icon":"fa-book"},{"value":"getCreationAndProcessLimitDates","label":"Date de cr\u00e9ation - Date limite de traitement","sample":"1er janv. - <i class=''fa fa-stopwatch''><\/i>&nbsp;<b style=''color:#8e3e52''>3 jour(s)<\/b>","cssClasses":["align_leftData"],"icon":"fa-calendar"},{"value":"getFolders","label":"Dossiers (emplacement fixe)","sample":"Litiges","cssClasses":["align_leftData"],"icon":"fa-folder"}]}', 'documentDetails', NULL),
                                                                                                               (109, 'AGENT', 'WaitXPBasket', '{"templateColumns":6,"subInfos":[{"value":"getPriority","label":"Priorit\u00e9","sample":"Urgent","cssClasses":["align_leftData"],"icon":"fa-traffic-light"},{"value":"getDoctype","label":"Type de courrier","sample":"R\u00e9clamation","cssClasses":["align_leftData"],"icon":"fa-suitcase"},{"value":"getAssignee","label":"Attributaire (entit\u00e9 traitante)","sample":"Barbara BAIN (P\u00f4le Jeunesse et Sport)","cssClasses":["align_leftData"],"icon":"fa-sitemap"},{"value":"getRecipients","label":"Destinataire","sample":"Patricia PETIT","cssClasses":["align_leftData"],"icon":"fa-user"},{"value":"getSenders","label":"Exp\u00e9diteur","sample":"Bernard PASMECHANT","cssClasses":["align_leftData"],"icon":"fa-book"},{"value":"getFolders","label":"Dossiers (emplacement fixe)","sample":"Litiges","cssClasses":["align_leftData"],"icon":"fa-folder"},{"value":"getVisaWorkflow","label":"Circuit de visa","sample":"<i style=''color:#006841'' class=''fa fa-check''><\/i> Barbara BAIN -> <i class=''fa fa-hourglass-half''><\/i> <b>Bruno BOULE<\/b> -> <i class=''fa fa-hourglass-half''><\/i> Patricia PETIT","cssClasses":["align_leftData"],"icon":"fa-list-ol"}]}', 'documentDetails', NULL),
                                                                                                               (138, 'RESPONSABLE', 'MyBasket', '{"templateColumns":7,"subInfos":[{"value":"getPriority","label":"Priorit\u00e9","sample":"Urgent","cssClasses":[],"icon":"fa-traffic-light"},{"value":"getCategory","label":"Cat\u00e9gorie","sample":"Courrier arriv\u00e9e","cssClasses":[],"icon":"fa-exchange-alt"},{"value":"getDoctype","label":"Type de courrier","sample":"R\u00e9clamation","cssClasses":[],"icon":"fa-suitcase"},{"value":"getAssignee","label":"Attributaire (entit\u00e9 traitante)","sample":"Barbara BAIN (P\u00f4le Jeunesse et Sport)","cssClasses":[],"icon":"fa-sitemap"},{"value":"getRecipients","label":"Destinataire","sample":"Patricia PETIT","cssClasses":[],"icon":"fa-user"},{"value":"getSenders","label":"Exp\u00e9diteur","sample":"Bernard PASMECHANT","cssClasses":[],"icon":"fa-book"},{"value":"getCreationAndProcessLimitDates","label":"Date de cr\u00e9ation - Date limite de traitement","sample":"1er janv. - <i class=''fa fa-stopwatch''><\/i>&nbsp;<b style=''color:#8e3e52''>3 jour(s)<\/b>","cssClasses":["align_rightData"],"icon":"fa-calendar"},{"value":"getFolders","label":"Dossiers (emplacement fixe)","sample":"Litiges","cssClasses":["align_leftData"],"icon":"fa-folder"}]}', 'processDocument', '{"defaultTab": "dashboard", "canUpdateData": false, "canGoToNextRes": false, "canUpdateModel": false}'),
                                                                                                               (175, 'DGS', 'SignBasket', '{"templateColumns":7,"subInfos":[{"value":"getPriority","label":"Priorit\u00e9","sample":"Urgent","cssClasses":["align_leftData"],"icon":"fa-traffic-light"},{"value":"getCategory","label":"Cat\u00e9gorie","sample":"Courrier arriv\u00e9e","cssClasses":["align_leftData"],"icon":"fa-exchange-alt"},{"value":"getDoctype","label":"Type de courrier","sample":"R\u00e9clamation","cssClasses":["align_leftData"],"icon":"fa-suitcase"},{"value":"getAssignee","label":"Attributaire (entit\u00e9 traitante)","sample":"Barbara BAIN (P\u00f4le Jeunesse et Sport)","cssClasses":["align_leftData"],"icon":"fa-sitemap"},{"value":"getRecipients","label":"Destinataire","sample":"Patricia PETIT","cssClasses":["align_leftData"],"icon":"fa-user"},{"value":"getSenders","label":"Exp\u00e9diteur","sample":"Bernard PASMECHANT","cssClasses":["align_leftData"],"icon":"fa-book"},{"value":"getCreationAndProcessLimitDates","label":"Date de cr\u00e9ation - Date limite de traitement","sample":"1er janv. - <i class=''fa fa-stopwatch''><\/i>&nbsp;<b style=''color:#8e3e52''>3 jour(s)<\/b>","cssClasses":["align_leftData"],"icon":"fa-calendar"},{"value":"getFolders","label":"Dossiers (emplacement fixe)","sample":"Litiges","cssClasses":["align_leftData"],"icon":"fa-folder"}]}', 'signatureBookAction', '{"canUpdateDocuments": true}');
-- Déploiement des paramétrages de redirection selon les bannettes et les groupes
DELETE FROM "groupbasket_redirect";
INSERT INTO "groupbasket_redirect" ("system_id", "group_id", "basket_id", "action_id", "entity_id", "keyword", "redirect_mode") VALUES
                                                                                                                                    (1818, 'AGENT', 'MyBasket', 592, '', 'MY_ENTITIES', 'USERS'),
                                                                                                                                    (1819, 'AGENT', 'MyBasket', 593, '', 'ENTITIES_BELOW', 'ENTITY'),
                                                                                                                                    (1820, 'AGENT', 'MyBasket', 593, '', 'MY_ENTITIES', 'ENTITY'),
                                                                                                                                    (1821, 'AGENT', 'MyBasket', 593, '', 'ENTITIES_JUST_UP', 'ENTITY'),
                                                                                                                                    (1604, 'ASSISTDGS', 'ValAtrDGSBasket', 552, '', 'ALL_ENTITIES', 'ENTITY'),
                                                                                                                                    (1605, 'ASSISTDGS', 'ValAtrDGSBasket', 554, '', 'ALL_ENTITIES', 'ENTITY'),
                                                                                                                                    (1609, 'DGS', 'ValAtrBasket', 552, '', 'ALL_ENTITIES', 'ENTITY'),
                                                                                                                                    (1610, 'DGS', 'ValAtrBasket', 554, '', 'ALL_ENTITIES', 'ENTITY'),
                                                                                                                                    (1822, 'RESPONSABLE', 'MyBasket', 592, '', 'MY_ENTITIES', 'USERS'),
                                                                                                                                    (1823, 'RESPONSABLE', 'MyBasket', 593, '', 'ENTITIES_BELOW', 'ENTITY'),
                                                                                                                                    (1824, 'RESPONSABLE', 'MyBasket', 593, '', 'MY_ENTITIES', 'ENTITY'),
                                                                                                                                    (1825, 'RESPONSABLE', 'MyBasket', 593, '', 'ENTITIES_JUST_UP', 'ENTITY'),
                                                                                                                                    (1283, 'DIRECTEUR', 'ValAtrBasket', 554, '', 'ALL_ENTITIES', 'ENTITY'),
                                                                                                                                    (1470, 'RESP_COURRIER', 'ValAtrBasket', 554, '', 'ALL_ENTITIES', 'ENTITY'),
                                                                                                                                    (1754, 'SERVICE', 'ServiceBasket', 589, '', 'AUTO_REDIRECT_TO_USER', 'USERS'),
                                                                                                                                    (1755, 'SERVICE', 'ServiceBasket', 592, '', 'MY_ENTITIES', 'USERS'),
                                                                                                                                    (1756, 'SERVICE', 'ServiceBasket', 593, '', 'ENTITIES_BELOW', 'ENTITY'),
                                                                                                                                    (1757, 'SERVICE', 'ServiceBasket', 593, '', 'MY_ENTITIES', 'ENTITY'),
                                                                                                                                    (1758, 'SERVICE', 'ServiceBasket', 593, '', 'ENTITIES_JUST_UP', 'ENTITY'),
                                                                                                                                    (1471, 'RESP_COURRIER', 'ValAtrBasket', 552, '', 'ALL_ENTITIES', 'ENTITY'),
                                                                                                                                    (1472, 'RESP_COURRIER', 'ValAtrBasket', 553, '', 'ALL_ENTITIES', 'ENTITY'),
                                                                                                                                    (1595, 'COURRIER', 'SVEToQualify', 551, '', 'ALL_ENTITIES', 'ENTITY'),
                                                                                                                                    (1596, 'COURRIER', 'SVEToQualify', 18, '', 'ALL_ENTITIES', 'ENTITY'),
                                                                                                                                    (1598, 'COURRIER', 'RetourCourrier', 551, '', 'ALL_ENTITIES', 'ENTITY'),
                                                                                                                                    (1599, 'COURRIER', 'RetourCourrier', 18, '', 'ALL_ENTITIES', 'ENTITY'),
                                                                                                                                    (1832, 'COURRIER', 'QualificationBasket', 551, '', 'ALL_ENTITIES', 'ENTITY'),
                                                                                                                                    (1833, 'COURRIER', 'QualificationBasket', 551, '', 'ALL_ENTITIES', 'ENTITY'),
                                                                                                                                    (1834, 'COURRIER', 'QualificationBasket', 18, '', 'ALL_ENTITIES', 'ENTITY'),
                                                                                                                                    (1839, 'COURRIER', 'EmailToQualify', 551, '', 'ALL_ENTITIES', 'ENTITY'),
                                                                                                                                    (1840, 'COURRIER', 'EmailToQualify', 18, '', 'ALL_ENTITIES', 'ENTITY');

DELETE FROM indexing_models;
INSERT INTO indexing_models (id, label, category, "default", owner, private, master, enabled, mandatory_file,
                             lad_processing)
VALUES (3, 'Note Interne', 'internal', false, 23, false, NULL, true, false, false);
INSERT INTO indexing_models (id, label, category, "default", owner, private, master, enabled, mandatory_file,
                             lad_processing)
VALUES (1, 'Courrier Arrivée', 'incoming', false, 23, false, NULL, true, true, false);
INSERT INTO indexing_models (id, label, category, "default", owner, private, master, enabled, mandatory_file,
                             lad_processing)
VALUES (8, 'Courriels importés', 'incoming', false, 23, false, NULL, true, false, false);
INSERT INTO indexing_models (id, label, category, "default", owner, private, master, enabled, mandatory_file,
                             lad_processing)
VALUES (4, 'Document GED', 'ged_doc', false, 23, false, NULL, false, false, false);
INSERT INTO indexing_models (id, label, category, "default", owner, private, master, enabled, mandatory_file,
                             lad_processing)
VALUES (2, 'Courrier Départ', 'outgoing', true, 23, false, NULL, true, false, false);
INSERT INTO indexing_models (id, label, category, "default", owner, private, master, enabled, mandatory_file,
                             lad_processing)
VALUES (7, 'Demande de documents', 'outgoing', false, 16, true, 2, true, false, false);
INSERT INTO indexing_models (id, label, category, "default", owner, private, master, enabled, mandatory_file,
                             lad_processing)
VALUES (12, 'Demandes d''interventions', 'incoming', false, 21, true, 1, true, true, false);
INSERT INTO indexing_models (id, label, category, "default", owner, private, master, enabled, mandatory_file,
                             lad_processing)
VALUES (9, 'Réconciliation', 'outgoing', false, 23, false, NULL, true, false, false);
INSERT INTO indexing_models (id, label, category, "default", owner, private, master, enabled, mandatory_file,
                             lad_processing)
VALUES (10, 'Saisines par voie électronique', 'incoming', false, 23, false, NULL, true, false, false);


DELETE FROM "indexing_models_fields";
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (764, 1, 'arrivalDate', true, '"_TODAY"', 'mail', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (769, 1, 'destination', true, NULL, 'process', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (762, 1, 'doctype', true, NULL, 'mail', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (763, 1, 'documentDate', true, NULL, 'mail', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (773, 1, 'folders', false, NULL, 'classifying', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (770, 1, 'indexingCustomField_10', true, '"Ordinaire"', 'process', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (765, 1, 'indexingCustomField_3', true, NULL, 'mail', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (766, 1, 'indexingCustomField_5', false, NULL, 'mail', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (771, 1, 'priority', true, NULL, 'process', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (772, 1, 'processLimitDate', true, NULL, 'process', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (768, 1, 'senders', true, NULL, 'contact', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (767, 1, 'subject', true, NULL, 'mail', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (776, 2, 'departureDate', false, NULL, 'mail', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (782, 2, 'destination', true, '"#myPrimaryEntity"', 'process', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (774, 2, 'doctype', true, NULL, 'mail', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (775, 2, 'documentDate', true, '"_TODAY"', 'mail', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (785, 2, 'folders', false, NULL, 'classifying', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (783, 2, 'indexingCustomField_10', true, '"Ordinaire"', 'process', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (777, 2, 'indexingCustomField_3', true, NULL, 'mail', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (778, 2, 'indexingCustomField_5', false, NULL, 'mail', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (781, 2, 'initiator', true, NULL, 'process', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (784, 2, 'priority', true, '"poiuytre1357nbvc"', 'process', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (780, 2, 'recipients', true, NULL, 'contact', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (779, 2, 'subject', true, NULL, 'mail', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (680, 8, 'arrivalDate', true, '"_TODAY"', 'mail', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (688, 8, 'destination', true, NULL, 'process', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (678, 8, 'doctype', true, NULL, 'mail', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (679, 8, 'documentDate', true, NULL, 'mail', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (692, 8, 'folders', false, NULL, 'classifying', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (689, 8, 'indexingCustomField_10', true, NULL, 'process', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (681, 8, 'indexingCustomField_3', true, '"Courriel"', 'mail', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (685, 8, 'indexingCustomField_6', false, NULL, 'contact', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (684, 8, 'indexingCustomField_7', false, NULL, 'contact', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (687, 8, 'indexingCustomField_8', false, NULL, 'contact', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (686, 8, 'indexingCustomField_9', false, NULL, 'contact', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (690, 8, 'priority', true, NULL, 'process', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (691, 8, 'processLimitDate', true, NULL, 'process', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (683, 8, 'senders', false, NULL, 'contact', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (682, 8, 'subject', true, NULL, 'mail', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (156, 9, 'departureDate', false, NULL, 'mail', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (154, 9, 'doctype', true, NULL, 'mail', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (155, 9, 'documentDate', false, NULL, 'mail', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (162, 9, 'folders', false, NULL, 'classifying', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (159, 9, 'initiator', false, NULL, 'process', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (160, 9, 'priority', false, NULL, 'process', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (161, 9, 'processLimitDate', false, NULL, 'process', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (158, 9, 'recipients', false, NULL, 'contact', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (157, 9, 'subject', true, NULL, 'mail', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (717, 10, 'arrivalDate', true, '"_TODAY"', 'mail', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (721, 10, 'destination', true, NULL, 'process', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (715, 10, 'doctype', true, NULL, 'mail', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (716, 10, 'documentDate', true, NULL, 'mail', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (725, 10, 'folders', false, NULL, 'classifying', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (722, 10, 'indexingCustomField_10', true, NULL, 'process', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (718, 10, 'indexingCustomField_3', true, '"Saisine du formulaire en ligne"', 'mail', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (723, 10, 'priority', true, NULL, 'process', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (724, 10, 'processLimitDate', true, NULL, 'process', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (720, 10, 'senders', true, NULL, 'contact', true, NULL);
INSERT INTO indexing_models_fields (id, model_id, identifier, mandatory, default_value, unit, enabled, allowed_values)
VALUES (719, 10, 'subject', true, NULL, 'mail', true, NULL);


INSERT INTO notifications (notification_sid, notification_id, description, is_enabled, event_id, notification_mode,
                           template_id, diffusion_type, diffusion_properties, attachfor_type, attachfor_properties,
                           send_as_recap)
VALUES (1, 'USERS', '[administration] Actions sur les utilisateurs de l''application', 'Y', 'users%', 'EMAIL', 2,
        'user', 'superadmin', '', '', false);
INSERT INTO notifications (notification_sid, notification_id, description, is_enabled, event_id, notification_mode,
                           template_id, diffusion_type, diffusion_properties, attachfor_type, attachfor_properties,
                           send_as_recap)
VALUES (2, 'RET2', 'Courriers en retard de traitement', 'Y', 'alert2', 'EMAIL', 5, 'dest_user', '', '', '', false);
INSERT INTO notifications (notification_sid, notification_id, description, is_enabled, event_id, notification_mode,
                           template_id, diffusion_type, diffusion_properties, attachfor_type, attachfor_properties,
                           send_as_recap)
VALUES (3, 'RET1', 'Courriers arrivant à échéance', 'Y', 'alert1', 'EMAIL', 6, 'dest_user', '', '', '', false);
INSERT INTO notifications (notification_sid, notification_id, description, is_enabled, event_id, notification_mode,
                           template_id, diffusion_type, diffusion_properties, attachfor_type, attachfor_properties,
                           send_as_recap)
VALUES (4, 'BASKETS', 'Notification de bannettes', 'Y', 'baskets', 'EMAIL', 7, 'dest_user', '', '', '', false);
INSERT INTO notifications (notification_sid, notification_id, description, is_enabled, event_id, notification_mode,
                           template_id, diffusion_type, diffusion_properties, attachfor_type, attachfor_properties,
                           send_as_recap)
VALUES (5, 'ANC', 'Nouvelle annotation sur courrier en copie', 'Y', 'noteadd', 'EMAIL', 8, 'copy_list', '', '', '',
        false);
INSERT INTO notifications (notification_sid, notification_id, description, is_enabled, event_id, notification_mode,
                           template_id, diffusion_type, diffusion_properties, attachfor_type, attachfor_properties,
                           send_as_recap)
VALUES (6, 'AND', 'Nouvelle annotation sur courrier destinataire', 'Y', 'noteadd', 'EMAIL', 8, 'dest_user', '', '', '',
        false);
INSERT INTO notifications (notification_sid, notification_id, description, is_enabled, event_id, notification_mode,
                           template_id, diffusion_type, diffusion_properties, attachfor_type, attachfor_properties,
                           send_as_recap)
VALUES (7, 'RED', 'Redirection de courrier', 'Y', '1', 'EMAIL', 7, 'dest_user', '', '', '', false);
INSERT INTO notifications (notification_sid, notification_id, description, is_enabled, event_id, notification_mode,
                           template_id, diffusion_type, diffusion_properties, attachfor_type, attachfor_properties,
                           send_as_recap)
VALUES (100, 'QUOTA', 'Alerte lorsque le quota est dépassé', 'Y', 'user_quota', 'EMAIL', 1049, 'user', 'superadmin',
        NULL, NULL, false); -- EDISSYUM - NCH01 Fix notification USER QUOTA | Remplacer 110 par 1049


INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date)
VALUES ('work_batch_autoimport_id', NULL, NULL, 1, NULL);
INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date)
VALUES ('user_quota', NULL, '', 0, NULL);
INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date)
VALUES ('defaultDepartment', 'Département par défaut sélectionné dans les autocomplétions de la Base Adresse Nationale',
        '75', NULL, NULL);
INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date)
VALUES ('thumbnailsSize', 'Résolution des imagettes', '750x900', NULL, NULL);
INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date)
VALUES ('QrCodePrefix', 'Si activé (1), ajoute "MEM_" dans le contenu des QrCode générés', NULL, 1,
        NULL); -- EDISSYUM - AMO01 Paramètre QrCodePrefix à 1 par défaut
INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date)
VALUES ('workingDays',
        'Si activé (1), les délais de traitement sont calculés en jours ouvrés (Lundi à Vendredi). Sinon, en jours calendaire',
        NULL, 1, NULL);
INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date)
VALUES ('last_deposit_id', NULL, NULL, 0, NULL);
INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date)
VALUES ('registeredMailNotDistributedStatus', NULL, 'PND', NULL, NULL);
INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date)
VALUES ('registeredMailDistributedStatus', NULL, 'DSTRIBUTED', NULL, NULL);
INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date)
VALUES ('registeredMailImportedStatus', NULL, 'NEW', NULL, NULL);
INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date)
VALUES ('keepDiffusionRoleInOutgoingIndexation',
        'Si activé (1), prend en compte les roles du modèle de diffusion de l''entité.', NULL, 1, NULL);
INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date)
VALUES ('bindingDocumentFinalAction', NULL, 'copy', NULL, NULL);
INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date)
VALUES ('nonBindingDocumentFinalAction', NULL, 'delete', NULL, NULL);
INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date)
VALUES ('minimumVisaRole', NULL, NULL, 0, NULL);
INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date)
VALUES ('maximumSignRole', NULL, NULL, 0, NULL);
INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date)
VALUES ('workflowSignatoryRole', 'Rôle de signataire dans le circuit', 'mandatory', NULL, NULL);
INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date)
VALUES ('siret', 'Numéro SIRET de l''entreprise', '45239273100025', NULL, NULL);
INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date)
VALUES ('traffic_record_summary_sheet', '', '', NULL, NULL);
INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date)
VALUES ('chrono_outgoing_2021', '', NULL, 3, NULL);
INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date)
VALUES ('chrono_incoming_2021', '', NULL, 4, NULL);
INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date)
VALUES ('suggest_links_n_days_ago', 'Le nombre de jours sur lequel sont cherchés les courriers à lier', NULL, 0, NULL);
INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date)
VALUES ('noteVisibilityOffAction',
        'Visibilité par défaut des annotations hors actions (0 = toutes les entités, 1 = restreint)', NULL, 0, NULL);
INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date)
VALUES ('noteVisibilityOnAction',
        'Visibilité par défaut des annotations sur les actions (0 = toutes les entités, 1 = restreint)', NULL, 0, NULL);
INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date)
VALUES ('allowMultipleAvisAssignment', '', NULL, 1, NULL);
INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date)
VALUES ('homepage_message', '',
        '<p>Bienvenue sur <strong>MEM Courrier 2505.</strong><br/> Suivez le <a title="guide de visite en ligne" href="https://edissyum.gitbook.io/guide-de-visite-mem-courrier/" target="_blank"><span style="color:#FFFD94;"><strong>guide de visite en ligne</strong></span></a>.<br/> Visitez nos <a title="Tutoriels MEM Courrier" href="https://youtube.com/playlist?list=PLgJt_0-l_q8CiD_jd1-oTM96vnN2ccZbI&si=X-lzhdCLzWjXPpZ5" target="_blank"><span style="color:#FFFD94;"><strong>tutoriels MEM courrier</strong></span></a>.</p>',
        NULL, NULL); -- EDISSYUM - AMO01 Modification lien documentation
INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date)
VALUES ('loginpage_message', '',
        '<span style="color:#3A7C00"><strong>Découvrez votre application via</strong></span>&nbsp;<a title="le guide de visite" href="https://edissyum.gitbook.io/guide-de-visite-mem-courrier/" target="_blank"><span style="color:#C25712;"><strong>le guide de visite en ligne</strong></span></a>',
        NULL, NULL); -- EDISSYUM - AMO01 Modification lien documentation
INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date)
VALUES ('database_version', '', '2505.0.0', NULL, NULL);
INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date)
VALUES ('chrono_incoming_2024', '', NULL, 1, NULL);
INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date)
VALUES ('chrono_outgoing_2024', NULL, NULL, 1, NULL);
INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date)
VALUES ('ActionQualifID', 'Identifiants des actions d''envoi en qualification', 'ACTION#551,ACTION#18', NULL,
        NULL); -- EDISSYUM - NCH01 Ajout du typist dans la recherche
INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date)
VALUES ('ContactsDuplicateMaxItems', 'Nombre de résultats maximums pour le dédoublonnage des contacts', NULL, 500,
        NULL); -- EDISSYUM - NCH01 Ajout d'un paramètre pour gérer le nombre max de contacts afficher dans l'écran de dédoublonnage
INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date)
VALUES ('contactsConfidentiality', 'Gestion de la confidentialité des contacts',
        '{"basic": {"customId": "7", "entitiesAllowed": "", "hiddenFields": "email, phone, address"}, "advanced": {"customId": "8", "entitiesAllowed": "", "hiddenFields": "email, phone, address, annotations"}}',
        NULL,
        NULL); -- EDISSYUM - NCH01 Rajout de la confidentialité des contacts -- EDISSYUM - AMO01 Valeur par défaut du paramètre contactsConfidentiality | Définir "customId": "7" et "customId": "8"
INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date)
VALUES ('customPostalAddressSettings', 'Gestion du champ de fusion d''adresse personnalisé', '{
 "1" : {"count": 38, "case": "upper", "value": "civility;lastname;firstname"},
 "2" : {"count": 38, "case": "ucfirst", "value": "company"},
 "3" : {"count": 38, "case": "lower", "value": "department; function"},
 "4" : {"count": 38, "case": "upper", "value": "address_additional1"},
 "5" : {"count": 100, "case": "upper", "value": "address_number;address_street"},
 "6" : {"count": 100, "case": "upper", "value": "address_postcode;address_town"},
 "7" : {"count": 30, "case": "ucfirst", "value": "address_country"}
}', NULL, NULL); -- EDISSYUM - NCH01 Rajout d'une variable de fusion custom pour les adresses - customPostalAddress
INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date)
VALUES ('printedFolderName', 'Masque de nommage du dossier d''impression', 'Dossier d''impression#chrono#full_date',
        NULL, NULL); -- // EDISSYUM - NCH01 Création d'un masque pour le nom de fichier du dossier d'impression
INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date)
VALUES ('summarySheetQrCodeContent', 'Contenu du QR Code de la fiche de liaison', 'alt_identifier', NULL,
        NULL); -- EDISSYUM - NCH01 Rajout d'un paramètre pour choisir le contenu du QR Code de la fiche de liaison
INSERT INTO parameters (id, description, param_value_int)
VALUES ('C128Prefix', 'Si activé (1), ajoute "MEM_" dans le contenu des C128 générés.',
        0); -- EDISSYUM - NCH01 Rajout du prefix pour les C128
INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date)
VALUES ('defaultStatusSummarySheet', 'Statut par défaut des champs de la fiche de liaison',
        '{"primaryInformations":false,"senderRecipientInformations":false,"secondaryInformations":true,"systemTechnicalFields":true,"customTechnicalFields":true,"diffusionList":true,"opinionWorkflow":true,"visaWorkflow":true,"visaWorkflowMaarchParapheur":false,"globalNotes":true,"avisNotes":true,"visaNotes":true,"workflowHistory":true,"trafficRecords":true}',
        NULL,
        NULL); -- EDISSYUM - AMO01 Rajout d'un paramètre pour choisir le statut par défaut des champs de la fiche de liaison -- EDISSYUM - AMO01 Dissocier les annotations par type + Adapter le paramètre defaultStatusSummarySheet | Ajout de "globalNotes", "avisNotes" et "visaNotes"
INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date)
VALUES ('defaultParapheurSummarySheet',
        'Statut par défaut des champs de la fiche de liaison lors de l''intégration au parapheur',
        '{"primaryInformations":false,"senderRecipientInformations":false,"secondaryInformations":true,"systemTechnicalFields":true,"customTechnicalFields":true,"diffusionList":true,"opinionWorkflow":true,"visaWorkflow":true,"visaWorkflowMaarchParapheur":false,"globalNotes":true,"avisNotes":true,"visaNotes":true,"workflowHistory":true,"trafficRecords":true}',
        NULL, NULL); -- EDISSYUM - (AMI01 + AMO01) Intégration fiche de liaison au parapheur externe
INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date)
VALUES ('ai_action_destination',
        'Liste des actions utilisées pour spécifier la destination à utiliser pour l''apprentissage de SerenIA (exemple : 593,18)',
        '', NULL, NULL); -- EDISSYUM - NCH01 Amélioration de l'historique de la listinstance pour l'IA
INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date)
VALUES ('banMaxItems', 'Nombre de résultats maximums pour la BAN', NULL, 500,
        NULL); -- EDISSYUM - NCH01 Augmentation du nombre de résultats pour la BAN
INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date)
VALUES ('CorrespondantMaxItems', 'Nombre de résultats maximums pour le publipostage', NULL, 500,
        NULL); -- EDISSYUM - NCH01 Augmentation du nombre de résultats pour les destinataires / expéditeurs
INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date)
VALUES ('sendSummarySheet', 'Envoi de la fiche de liaison au parapheur externe', NULL, 1,
        NULL); -- EDISSYUM - (AMI01 + AMO01) Intégration fiche de liaison au parapheur externe
INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date)
VALUES ('summarySheetMandatory', 'Fiche de liaison obligatoire lors d''une impression en masse', NULL, 1,
        NULL); -- EDISSYUM - NCH01 Amélioration de l'écran d'impression en masse
INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date)
VALUES ('keepDestForRedirection',
        'Si activé (1), met le destinataire en copie de la liste de diffusion lors d''une action de redirection', NULL,
        0, NULL);
INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date)
VALUES ('showFoldersByDefault', 'Si activé (1), afficher les dossiers ouverts par defaut sinon (0)', NULL, 0, NULL);
INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date)
VALUES ('useSectorsForAddresses',
        'Utilisation de la table address_sectors pour autocomplétion des adresses ; la BAN est ignorée (valeur = 1)',
        NULL, 0, NULL);
INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date) VALUES ('notificationAttachmentsTypeAllowed', 'Liste des types de pièces jointe à envoyer dans les notifications si "Joindre un document" est activé', 'response_project, simple_attachment', NULL, NULL); -- EDISSYUM - NCH01 Rajout de la possibilité d'envoyer les PJ dans les notifications

INSERT INTO password_rules (id, label, value, enabled)
VALUES (1, 'minLength', 6, true);
INSERT INTO password_rules (id, label, value, enabled)
VALUES (2, 'complexityUpper', 0, false);
INSERT INTO password_rules (id, label, value, enabled)
VALUES (3, 'complexityNumber', 0, false);
INSERT INTO password_rules (id, label, value, enabled)
VALUES (4, 'complexitySpecial', 0, false);
INSERT INTO password_rules (id, label, value, enabled)
VALUES (5, 'lockAttempts', 3, false);
INSERT INTO password_rules (id, label, value, enabled)
VALUES (6, 'lockTime', 5, false);
INSERT INTO password_rules (id, label, value, enabled)
VALUES (7, 'historyLastUse', 2, false);
INSERT INTO password_rules (id, label, value, enabled)
VALUES (8, 'renewal', 90, false);


INSERT INTO priorities (id, label, color, delays, "order")
VALUES ('poiuytre1357nbvc', 'Normal', '#3A7C00', 30, 1);
INSERT INTO priorities (id, label, color, delays, "order")
VALUES ('poiuytre1379nbvc', 'Urgent', '#ffa500', 8, 2);
INSERT INTO priorities (id, label, color, delays, "order")
VALUES ('poiuytre1391nbvc', 'Très urgent', '#ff0000', 4, 3);


INSERT INTO registered_mail_issuing_sites (id, label, post_office_label, account_number, address_number, address_street,
                                           address_additional1, address_additional2, address_postcode, address_town,
                                           address_country)
VALUES (1, 'MEM - Nanterre', 'La poste Nanterre', 1234567, '10', 'AVENUE DE LA GRANDE ARMEE', '', '', '75017',
        'PARIS', 'FRANCE');


INSERT INTO registered_mail_issuing_sites_entities (id, site_id, entity_id)
VALUES (1, 1, 6);
INSERT INTO registered_mail_issuing_sites_entities (id, site_id, entity_id)
VALUES (2, 1, 13);


INSERT INTO registered_mail_number_range (id, type, tracking_account_number, range_start, range_end, creator,
                                          creation_date, status, current_number)
VALUES (1, '2C', 'SuiviNumber', 1, 10, 23, '2020-09-14 14:38:09.008644', 'OK', 1);
INSERT INTO registered_mail_number_range (id, type, tracking_account_number, range_start, range_end, creator,
                                          creation_date, status, current_number)
VALUES (2, 'RW', 'SuiviNumberInternational', 1, 10, 23, '2020-09-14 14:39:32.972626', 'OK', 1);
INSERT INTO registered_mail_number_range (id, type, tracking_account_number, range_start, range_end, creator,
                                          creation_date, status, current_number)
VALUES (3, '2D', 'suiviNumber', 1, 10, 23, '2020-09-14 14:39:16.779322', 'OK', 1);


DELETE FROM "security";
INSERT INTO security (security_id, group_id, coll_id, where_clause, mem_comment)
VALUES (604, 'ADMINISTRATEUR_N1', 'letterbox_coll', '1=1', 'Tous les courriers');
INSERT INTO security (security_id, group_id, coll_id, where_clause, mem_comment)
VALUES (605, 'ADMINISTRATEUR_N2', 'letterbox_coll', '1=1', 'Aucun courrier');
INSERT INTO security (security_id, group_id, coll_id, where_clause, mem_comment)
VALUES (601, 'AGENT', 'letterbox_coll',
        '(DESTINATION IN (@my_entities,@subentities[@my_entities])) AND (STATUS NOT IN (''MAQUAL'',''INIT'',''VALS'',''VALDIR'',''VALDGS'',''RET'') OR STATUS IS NULL)',
        'Les courriers de mes services et sous-services');
INSERT INTO security (security_id, group_id, coll_id, where_clause, mem_comment)
VALUES (624, 'ASSISTCAB', 'letterbox_coll',
        '(DESTINATION IN (@my_entities,@subentities[@my_entities])) AND (STATUS NOT IN (''MAQUAL'',''INIT'',''VALS'',''VALDGS'',''VALDIR'',''RET'') OR STATUS IS NULL)',
        'Assistant(e) du Cabinet');
INSERT INTO security (security_id, group_id, coll_id, where_clause, mem_comment)
VALUES (623, 'ASSISTDGS', 'letterbox_coll',
        '(DESTINATION IN (@my_entities,@subentities[@my_entities])) AND (STATUS NOT IN (''MAQUAL'',''INIT'',''VALS'') OR STATUS IS NULL)',
        'Courriers en attente de validation DGS');
INSERT INTO security (security_id, group_id, coll_id, where_clause, mem_comment)
VALUES (625, 'ASSISTDIR', 'letterbox_coll',
        '(DESTINATION IN (@my_entities,@subentities[@my_entities])) AND (STATUS NOT IN (''MAQUAL'',''INIT'',''VALS'',''VALDIR'',''VALDGS'',''RET'') OR STATUS IS NULL)',
        'Assistant(e) Direction');
INSERT INTO security (security_id, group_id, coll_id, where_clause, mem_comment)
VALUES (626, 'ASSISTSERV', 'letterbox_coll',
        '(DESTINATION IN (@my_entities,@subentities[@my_entities])) AND (STATUS NOT IN (''MAQUAL'',''INIT'',''VALS'',''VALDIR'',''VALDGS'',''RET'') OR STATUS IS NULL)',
        'Assistant(e) Chef de Service');
INSERT INTO security (security_id, group_id, coll_id, where_clause, mem_comment)
VALUES (627, 'CHEF', 'letterbox_coll',
        '(DESTINATION IN (@my_entities,@subentities[@my_entities])) AND (STATUS NOT IN (''MAQUAL'',''INIT'',''VALS'',''VALDIR'',''VALDGS'',''RET'') OR STATUS IS NULL)',
        'Chef de Service');
INSERT INTO security (security_id, group_id, coll_id, where_clause, mem_comment)
VALUES (600, 'COURRIER', 'letterbox_coll', '1=1', 'Tous les courriers');
INSERT INTO security (security_id, group_id, coll_id, where_clause, mem_comment)
VALUES (606, 'DGS', 'letterbox_coll',
        '(DESTINATION IN (@my_entities,@subentities[@my_entities])) AND (STATUS NOT IN (''MAQUAL'',''INIT'',''VALS'') OR STATUS IS NULL)',
        'Tous les courriers sauf ceux du Cabinet');
INSERT INTO security (security_id, group_id, coll_id, where_clause, mem_comment)
VALUES (622, 'DIRCAB', 'letterbox_coll',
        '(DESTINATION IN (@my_entities,@subentities[@my_entities])) AND (STATUS NOT IN (''MAQUAL'',''INIT'',''VALS'',''VALDGS'',''VALDIR'',''RET'') OR STATUS IS NULL)',
        'Direction du Cabinet');
INSERT INTO security (security_id, group_id, coll_id, where_clause, mem_comment)
VALUES (619, 'DIRECTEUR', 'letterbox_coll',
        '(DESTINATION IN (@my_entities,@subentities[@my_entities])) AND (STATUS NOT IN (''MAQUAL'',''INIT'',''VALS'',''VALDGS'',''RET'') OR STATUS IS NULL)',
        'Courriers de ma direction à valider');
INSERT INTO security (security_id, group_id, coll_id, where_clause, mem_comment)
VALUES (607, 'ELU', 'letterbox_coll', '1=0', 'Aucun courrier');
INSERT INTO security (security_id, group_id, coll_id, where_clause, mem_comment)
VALUES (610, 'MAARCHTOGEC', 'letterbox_coll', '1=0', 'Aucun courrier');
INSERT INTO security (security_id, group_id, coll_id, where_clause, mem_comment)
VALUES (613, 'MAIRE', 'letterbox_coll',
        '(DESTINATION IN (@my_entities,@subentities[@my_entities])) AND (STATUS NOT IN (''MAQUAL'',''INIT'',''VALS'',''VALDIR'',''VALDGS'',''RET'') OR STATUS IS NULL)',
        'Maire');
INSERT INTO security (security_id, group_id, coll_id, where_clause, mem_comment)
VALUES (618, 'REFERENT', 'letterbox_coll',
        '(DESTINATION IN (@my_entities,@subentities[@my_entities])) AND (STATUS NOT IN (''MAQUAL'',''INIT'',''VALS'',''VALDIR'',''VALDGS'',''RET'') OR STATUS IS NULL)',
        'Référent Courrier au sein d''une Direction');
INSERT INTO security (security_id, group_id, coll_id, where_clause, mem_comment)
VALUES (602, 'RESP_COURRIER', 'letterbox_coll', '1=1', 'Tous les courriers');
INSERT INTO security (security_id, group_id, coll_id, where_clause, mem_comment)
VALUES (603, 'RESPONSABLE', 'letterbox_coll',
        '(DESTINATION IN (@my_entities,@subentities[@my_entities])) AND (STATUS NOT IN (''MAQUAL'',''INIT'',''VALS'',''VALDIR'',''VALDGS'',''RET'') OR STATUS IS NULL)',
        'Les courriers de mes services et sous-services');
INSERT INTO security (security_id, group_id, coll_id, where_clause, mem_comment)
VALUES (611, 'SERVICE', 'letterbox_coll', '1=0', 'Aucun courrier');
INSERT INTO security (security_id, group_id, coll_id, where_clause, mem_comment)
VALUES (612, 'WEBSERVICE', 'letterbox_coll', '1=1', 'Tous les courriers');



INSERT INTO shipping_templates (id, label, description, options, fee, entities, account, subscriptions, token_min_iat)
VALUES (1, 'Modèle d''exemple d''envoi postal', 'Modèle d''exemple d''envoi postal',
        '{"shapingOptions":[],"sendMode":"fast"}', '{"firstPagePrice":0.4,"nextPagePrice":0.5,"postagePrice":0.9}',
        '["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "17", "18", "16", "19", "20"]',
        '{"id": "sandbox.562", "password": "cs0ezTbuEHSlluEyF6lYi2HfqoA7HA=="}', '[]', '2024-06-21 10:58:54.219238');

DELETE FROM "status";
INSERT INTO status (identifier, id, label_status, is_system, img_filename,  can_be_searched, can_be_modified)
VALUES (19, 'A_TRA', 'PJ à traiter', 'Y', 'fa-question', 'Y', 'Y');
INSERT INTO status (identifier, id, label_status, is_system, img_filename,  can_be_searched, can_be_modified)
VALUES (44, 'ATTREC', 'Courrier à rapprocher manuellement', 'N', 'fa-question', 'Y', 'Y');
INSERT INTO status (identifier, id, label_status, is_system, img_filename,  can_be_searched, can_be_modified)
VALUES (60, 'ATTSVE', 'Saisines par voie électronique', 'N', 'fm-letter-status-attr', 'Y', 'Y');
INSERT INTO status (identifier, id, label_status, is_system, img_filename,  can_be_searched, can_be_modified)
VALUES (2, 'COU', 'En cours de traitement', 'N', 'fm-letter-status-inprogress', 'Y', 'Y');
INSERT INTO status (identifier, id, label_status, is_system, img_filename,  can_be_searched, can_be_modified)
VALUES (3, 'DEL', 'Supprimé', 'Y', 'fm-letter-del', 'N', 'Y');
INSERT INTO status (identifier, id, label_status, is_system, img_filename,  can_be_searched, can_be_modified)
VALUES (11, 'EAVIS', 'Avis demandé', 'N', 'fa-lightbulb', 'Y', 'Y');
INSERT INTO status (identifier, id, label_status, is_system, img_filename,  can_be_searched, can_be_modified)
VALUES (12, 'EENV', 'Courrier à envoyer', 'N', 'fm-letter-status-aenv', 'Y', 'Y');
INSERT INTO status (identifier, id, label_status, is_system, img_filename,  can_be_searched, can_be_modified)
VALUES (4, 'END', 'Clos / fin du workflow', 'Y', 'fm-letter-status-end', 'Y', 'Y');
INSERT INTO status (identifier, id, label_status, is_system, img_filename,  can_be_searched, can_be_modified)
VALUES (38, 'ENVDONE', 'Courrier envoyé', 'Y', 'fm-letter-status-aenv', 'Y', 'Y');
INSERT INTO status (identifier, id, label_status, is_system, img_filename,  can_be_searched, can_be_modified)
VALUES (13, 'ESIG', 'Courrier en attente de signature', 'N', 'fm-file-fingerprint', 'Y', 'Y');
INSERT INTO status (identifier, id, label_status, is_system, img_filename,  can_be_searched, can_be_modified)
VALUES (14, 'EVIS', 'Courrier en attente de visa', 'N', 'fm-letter-status-aval', 'Y', 'Y');
INSERT INTO status (identifier, id, label_status, is_system, img_filename,  can_be_searched, can_be_modified)
VALUES (20, 'FRZ', 'PJ gelée', 'Y', 'fa-pause', 'Y', 'Y');
INSERT INTO status (identifier, id, label_status, is_system, img_filename,  can_be_searched, can_be_modified)
VALUES (45, 'IMP', 'Courrier à imprimer', 'N', 'fm-letter-status-aimp', 'Y', 'Y');
INSERT INTO status (identifier, id, label_status, is_system, img_filename,  can_be_searched, can_be_modified)
VALUES (8, 'INIT', 'Courrier à qualifier', 'N', 'fm-letter-status-attr', 'Y', 'Y');
INSERT INTO status (identifier, id, label_status, is_system, img_filename,  can_be_searched, can_be_modified)
VALUES (43, 'MAQUAL', '@mail à qualifier', 'N', 'fm-letter-status-attr', 'Y', 'Y');
INSERT INTO status (identifier, id, label_status, is_system, img_filename,  can_be_searched, can_be_modified)
VALUES (5, 'NEW', 'Nouveau courrier pour le service', 'Y', 'fm-letter-status-new', 'Y', 'Y');
INSERT INTO status (identifier, id, label_status, is_system, img_filename,  can_be_searched, can_be_modified)
VALUES (22, 'OBS', 'PJ obsolète', 'Y', 'fa-pause', 'Y', 'Y');
INSERT INTO status (identifier, id, label_status, is_system, img_filename,  can_be_searched, can_be_modified)
VALUES (59, 'PARAPHWAIT', 'En attente de retour parapheur électronique', 'N', 'fm-letter-status-wait', 'Y',
        'Y');
INSERT INTO status (identifier, id, label_status, is_system, img_filename,  can_be_searched, can_be_modified)
VALUES (33, 'PJQUAL', 'PJ à réconcilier', 'Y', 'fm-letter-status-attr', 'Y', 'Y');
INSERT INTO status (identifier, id, label_status, is_system, img_filename,  can_be_searched, can_be_modified)
VALUES (39, 'REJ_SIGN', 'Courrier rejeté par le signataire', 'N', 'fm-letter-status-rejected', 'Y', 'Y');
INSERT INTO status (identifier, id, label_status, is_system, img_filename,  can_be_searched, can_be_modified)
VALUES (46, 'REJ_VISA', 'Courrier rejeté dans le circuit de visa', 'N', 'fm-letter-status-rejected', 'Y', 'Y');
INSERT INTO status (identifier, id, label_status, is_system, img_filename,  can_be_searched, can_be_modified)
VALUES (51, 'RET', 'Courrier retourné au Service Courrier', 'N', 'fm-letter-status-rejected', 'Y', 'Y');
INSERT INTO status (identifier, id, label_status, is_system, img_filename,  can_be_searched, can_be_modified)
VALUES (35, 'SEND_MASS', 'Pour publipostage', 'Y', 'fa-mail-bulk', 'Y', 'Y');
INSERT INTO status (identifier, id, label_status, is_system, img_filename,  can_be_searched, can_be_modified)
VALUES (36, 'SIGN', 'PJ signée', 'Y', 'fa-check', 'Y', 'Y');
INSERT INTO status (identifier, id, label_status, is_system, img_filename,  can_be_searched, can_be_modified)
VALUES (18, 'SSUITE', 'Sans suite', 'Y', 'fm-letter-del', 'Y', 'Y');
INSERT INTO status (identifier, id, label_status, is_system, img_filename,  can_be_searched, can_be_modified)
VALUES (23, 'TMP', 'PJ brouillon', 'Y', 'fm-letter-status-inprogress', 'N', 'N');
INSERT INTO status (identifier, id, label_status, is_system, img_filename,  can_be_searched, can_be_modified)
VALUES (21, 'TRA', 'PJ traitée', 'Y', 'fa-check', 'Y', 'Y');
INSERT INTO status (identifier, id, label_status, is_system, img_filename,  can_be_searched, can_be_modified)
VALUES (48, 'VALDGS', 'En attente de validation DGS', 'N', 'fm-letter-search', 'Y', 'Y');
INSERT INTO status (identifier, id, label_status, is_system, img_filename,  can_be_searched, can_be_modified)
VALUES (54, 'VALDIR', 'En attente de validation DIRECTEUR', 'N', 'fm-letter-search', 'Y', 'Y');
INSERT INTO status (identifier, id, label_status, is_system, img_filename,  can_be_searched, can_be_modified)
VALUES (49, 'VALS', 'En attente de validation superviseur', 'N', 'fm-letter-search', 'Y', 'Y');
INSERT INTO status (identifier, id, label_status, is_system, img_filename,  can_be_searched, can_be_modified)
VALUES (52, 'WAIT', 'Courrier en attente de retour parapheur', 'N', 'fm-letter-status-imp', 'Y', 'Y');

DELETE FROM "status_images";
INSERT INTO status_images (id, image_name)
VALUES (1, 'fm-letter-status-new');
INSERT INTO status_images (id, image_name)
VALUES (2, 'fm-letter-status-inprogress');
INSERT INTO status_images (id, image_name)
VALUES (3, 'fm-letter-status-info');
INSERT INTO status_images (id, image_name)
VALUES (4, 'fm-letter-status-wait');
INSERT INTO status_images (id, image_name)
VALUES (5, 'fm-letter-status-validated');
INSERT INTO status_images (id, image_name)
VALUES (6, 'fm-letter-status-rejected');
INSERT INTO status_images (id, image_name)
VALUES (7, 'fm-letter-status-end');
INSERT INTO status_images (id, image_name)
VALUES (8, 'fm-letter-status-newmail');
INSERT INTO status_images (id, image_name)
VALUES (9, 'fm-letter-status-attr');
INSERT INTO status_images (id, image_name)
VALUES (10, 'fm-letter-status-arev');
INSERT INTO status_images (id, image_name)
VALUES (11, 'fm-letter-status-aval');
INSERT INTO status_images (id, image_name)
VALUES (12, 'fm-letter-status-aimp');
INSERT INTO status_images (id, image_name)
VALUES (13, 'fm-letter-status-imp');
INSERT INTO status_images (id, image_name)
VALUES (14, 'fm-letter-status-aenv');
INSERT INTO status_images (id, image_name)
VALUES (15, 'fm-letter-status-acla');
INSERT INTO status_images (id, image_name)
VALUES (16, 'fm-letter-status-aarch');
INSERT INTO status_images (id, image_name)
VALUES (17, 'fm-letter');
INSERT INTO status_images (id, image_name)
VALUES (18, 'fm-letter-add');
INSERT INTO status_images (id, image_name)
VALUES (19, 'fm-letter-search');
INSERT INTO status_images (id, image_name)
VALUES (20, 'fm-letter-del');
INSERT INTO status_images (id, image_name)
VALUES (21, 'fm-letter-incoming');
INSERT INTO status_images (id, image_name)
VALUES (22, 'fm-letter-outgoing');
INSERT INTO status_images (id, image_name)
VALUES (23, 'fm-letter-internal');
INSERT INTO status_images (id, image_name)
VALUES (24, 'fm-file-fingerprint');
INSERT INTO status_images (id, image_name)
VALUES (25, 'fm-classification-plan-l1');
INSERT INTO status_images (id, image_name)
VALUES (26, 'fa-question');
INSERT INTO status_images (id, image_name)
VALUES (27, 'fa-check');
INSERT INTO status_images (id, image_name)
VALUES (28, 'fa-pause');
INSERT INTO status_images (id, image_name)
VALUES (29, 'fa-mail-bulk');
INSERT INTO status_images (id, image_name)
VALUES (30, 'fa-lightbulb');

INSERT INTO tags (id, label, description, parent_id, creation_date, links, usage)
VALUES (1, 'SEMINAIRE', NULL, NULL, '2021-03-24 10:17:02.66594', '[]', NULL);
INSERT INTO tags (id, label, description, parent_id, creation_date, links, usage)
VALUES (2, 'INNOVATION', NULL, NULL, '2021-03-24 10:17:02.66594', '[]', NULL);
INSERT INTO tags (id, label, description, parent_id, creation_date, links, usage)
VALUES (3, 'MAARCH', NULL, NULL, '2021-03-24 10:17:02.66594', '[]', NULL);
INSERT INTO tags (id, label, description, parent_id, creation_date, links, usage)
VALUES (4, 'ENVIRONNEMENT', NULL, NULL, '2021-03-24 10:17:02.66594', '[]', NULL);
INSERT INTO tags (id, label, description, parent_id, creation_date, links, usage)
VALUES (5, 'PARTENARIAT', NULL, NULL, '2021-03-24 10:17:02.66594', '[]', NULL);
INSERT INTO tags (id, label, description, parent_id, creation_date, links, usage)
VALUES (6, 'JUMELAGE', NULL, NULL, '2021-03-24 10:17:02.66594', '[]', NULL);
INSERT INTO tags (id, label, description, parent_id, creation_date, links, usage)
VALUES (7, 'ECONOMIE', NULL, NULL, '2021-03-24 10:17:02.66594', '[]', NULL);
INSERT INTO tags (id, label, description, parent_id, creation_date, links, usage)
VALUES (8, 'ASSOCIATIONS', NULL, NULL, '2021-03-24 10:17:02.66594', '[]', NULL);
INSERT INTO tags (id, label, description, parent_id, creation_date, links, usage)
VALUES (9, 'RH', NULL, NULL, '2021-03-24 10:17:02.66594', '[]', NULL);
INSERT INTO tags (id, label, description, parent_id, creation_date, links, usage)
VALUES (10, 'BUDGET', NULL, NULL, '2021-03-24 10:17:02.66594', '[]', NULL);
INSERT INTO tags (id, label, description, parent_id, creation_date, links, usage)
VALUES (11, 'QUARTIERS', NULL, NULL, '2021-03-24 10:17:02.66594', '[]', NULL);
INSERT INTO tags (id, label, description, parent_id, creation_date, links, usage)
VALUES (12, 'LITTORAL', NULL, NULL, '2021-03-24 10:17:02.66594', '[]', NULL);
INSERT INTO tags (id, label, description, parent_id, creation_date, links, usage)
VALUES (13, 'SPORT', NULL, NULL, '2021-03-24 10:17:02.66594', '[]', NULL);

INSERT INTO templates (template_id, template_label, template_comment, template_content, template_type, template_path,
                       template_file_name, template_style, template_datasource, template_target,
                       template_attachment_type, subject, options)
VALUES (2, '[notification] Notifications événement', 'Notifications des événements système', '<p><span style="font-family: verdana,geneva; font-size: xx-small;">Bonjour [recipient.firstname] [recipient.lastname],</span></p>
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
</table>', 'HTML', NULL, NULL, '', 'notif_events', 'notifications', NULL, NULL,
        '{}'); -- EDISSYUM - AMO01 Modifier la structure des templates de notifications | Ajustements dans le 'template_content'
INSERT INTO templates (template_id, template_label, template_comment, template_content, template_type, template_path,
                       template_file_name, template_style, template_datasource, template_target,
                       template_attachment_type, subject, options)
VALUES (5, '[notification courrier] Alerte 2', '[notification] Alerte 2', '<p style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif;">Bonjour <strong>[recipient.firstname] [recipient.lastname]</strong>,</p>
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
<p style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; width: 100%; text-align: center; font-size: 9px; font-style: italic; opacity: 0.5;">Message g&eacute;n&eacute;r&eacute; via l''application MEMCourrier</p>',
        'HTML', NULL, NULL, 'ODP: open_office_presentation', 'letterbox_events', 'notifications', NULL, NULL,
        '{}'); -- EDISSYUM - AMO01 Modifier la structure des templates de notifications | Ajustements dans le 'template_content'
INSERT INTO templates (template_id, template_label, template_comment, template_content, template_type, template_path,
                       template_file_name, template_style, template_datasource, template_target,
                       template_attachment_type, subject, options)
VALUES (6, '[notification courrier] Alerte 1', '[notification] Alerte 1', '<p style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif;">Bonjour <strong>[recipient.firstname] [recipient.lastname]</strong>,</p>
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
<p style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; width: 100%; text-align: center; font-size: 9px; font-style: italic; opacity: 0.5;">Message g&eacute;n&eacute;r&eacute; via l''application MEMCourrier</p>',
        'HTML', NULL, NULL, 'ODP: open_office_presentation', 'letterbox_events', 'notifications', NULL, NULL,
        '{}'); -- EDISSYUM - AMO01 Modifier la structure des templates de notifications | Ajustements dans le 'template_content'
INSERT INTO templates (template_id, template_label, template_comment, template_content, template_type, template_path,
                       template_file_name, template_style, template_datasource, template_target,
                       template_attachment_type, subject, options)
VALUES (8, '[notification courrier] Nouvelle annotation', '[notification] Nouvelle annotation', '<p style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif;">Bonjour <strong>[recipient.firstname] [recipient.lastname]</strong>,</p>
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
<p style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; width: 100%; text-align: center; font-size: 9px; font-style: italic; opacity: 0.5;">Message g&eacute;n&eacute;r&eacute; via l''application MEMCourrier</p>',
        'HTML', NULL, NULL, 'ODP: open_office_presentation', 'notes', 'notifications', NULL, NULL,
        '{}'); -- EDISSYUM - AMO01 Modifier la structure des templates de notifications | Ajustements dans le 'template_content'
INSERT INTO templates (template_id, template_label, template_comment, template_content, template_type, template_path,
                       template_file_name, template_style, template_datasource, template_target,
                       template_attachment_type, subject, options)
VALUES (900, '[TRT] Passer me voir', 'Passer me voir', 'Passer me voir à mon bureau, merci.', 'TXT', NULL, NULL,
        'XLSX: demo_spreadsheet_msoffice', '', 'notes', 'all', NULL, '{}');
INSERT INTO templates (template_id, template_label, template_comment, template_content, template_type, template_path,
                       template_file_name, template_style, template_datasource, template_target,
                       template_attachment_type, subject, options)
VALUES (901, '[TRT] Compléter', 'Compléter', 'Le projet de réponse doit être complété/révisé sur les points suivants :

- ', 'TXT', NULL, NULL, 'XLSX: demo_spreadsheet_msoffice', '', 'notes', 'all', NULL, '{}');
INSERT INTO templates (template_id, template_label, template_comment, template_content, template_type, template_path,
                       template_file_name, template_style, template_datasource, template_target,
                       template_attachment_type, subject, options)
VALUES (902, '[AVIS] Demande avis', 'Demande avis',
        'Merci de me fournir les éléments de langage pour répondre à ce courrier.', 'TXT', NULL, NULL,
        'XLSX: demo_spreadsheet_msoffice', '', 'notes', 'all', NULL, '{}');
INSERT INTO templates (template_id, template_label, template_comment, template_content, template_type, template_path,
                       template_file_name, template_style, template_datasource, template_target,
                       template_attachment_type, subject, options)
VALUES (904, '[AVIS] Avis favorable', 'Avis favorable',
        'Merci de répondre favorablement à la demande inscrite dans ce courrier', 'TXT', NULL, NULL,
        'XLSX: demo_spreadsheet_msoffice', '', 'notes', 'all', NULL, '{}');
INSERT INTO templates (template_id, template_label, template_comment, template_content, template_type, template_path,
                       template_file_name, template_style, template_datasource, template_target,
                       template_attachment_type, subject, options)
VALUES (905, '[CLOTURE] Clôture pour REJET', 'Clôture pour REJET', 'Clôture pour REJET', 'TXT', NULL, NULL,
        'XLSX: demo_spreadsheet_msoffice', '', 'notes', 'all', NULL, '{}');
INSERT INTO templates (template_id, template_label, template_comment, template_content, template_type, template_path,
                       template_file_name, template_style, template_datasource, template_target,
                       template_attachment_type, subject, options)
VALUES (906, '[CLOTURE] Clôture pour ABANDON', 'Clôture pour ABANDON', 'Clôture pour ABANDON', 'TXT', NULL, NULL,
        'XLSX: demo_spreadsheet_msoffice', '', 'notes', 'all', NULL, '{}');
INSERT INTO templates (template_id, template_label, template_comment, template_content, template_type, template_path,
                       template_file_name, template_style, template_datasource, template_target,
                       template_attachment_type, subject, options)
VALUES (907, '[CLOTURE] Clôture RAS', 'Clôture RAS', 'Clôture NORMALE', 'TXT', NULL, NULL,
        'XLSX: demo_spreadsheet_msoffice', '', 'notes', 'all', NULL, '{}');
INSERT INTO templates (template_id, template_label, template_comment, template_content, template_type, template_path,
                       template_file_name, template_style, template_datasource, template_target,
                       template_attachment_type, subject, options)
VALUES (908, '[CLOTURE] Clôture AUTRE', 'Clôture AUTRE', 'Clôture pour ce motif : ', 'TXT', NULL, NULL,
        'XLSX: demo_spreadsheet_msoffice', '', 'notes', 'all', NULL, '{}');
INSERT INTO templates (template_id, template_label, template_comment, template_content, template_type, template_path,
                       template_file_name, template_style, template_datasource, template_target,
                       template_attachment_type, subject, options)
VALUES (909, '[REJET] Erreur affectation', 'Erreur affectation', 'Ce courrier ne semble pas concerner mon service',
        'TXT', NULL, NULL, 'XLSX: demo_spreadsheet_msoffice', '', 'notes', 'all', NULL, '{}');
INSERT INTO templates (template_id, template_label, template_comment, template_content, template_type, template_path,
                       template_file_name, template_style, template_datasource, template_target,
                       template_attachment_type, subject, options)
VALUES (910, '[REJET] Anomalie de numérisation', 'Anomalie de numérisation',
        'Le courrier présente des anomalies de numérisation', 'TXT', NULL, NULL, 'XLSX: demo_spreadsheet_msoffice', '',
        'notes', 'all', NULL, '{}');
INSERT INTO templates (template_id, template_label, template_comment, template_content, template_type, template_path,
                       template_file_name, template_style, template_datasource, template_target,
                       template_attachment_type, subject, options)
VALUES (1033, 'AR EN MASSE TYPE SIMPLE', 'Cas d’une demande n’impliquant pas de décision implicite de l’administration', '<div class="is-node"><br><hr><span style="color: #2dc26b;">H&ocirc;tel de ville</span><br><span style="color: #2dc26b;">Place de la Fraternit&eacute;</span><br><span style="color: #2dc26b;">99000 MEM-en-Provence</span>
<p>&nbsp;</p>
<p><span style="color: #2dc26b;"><strong>Accus&eacute; de r&eacute;ception</strong></span></p>
<p>Service instructeur : <strong>[userPrimaryEntity.entity_label]</strong> <br>Courriel : [userPrimaryEntity.email]</p>
<p>[userPrimaryEntity.address_town], le [datetime.date;frm=dddd dd mmmm yyyy(locale)]</p>
<hr>
<p>Bonjour,</p>
<p>Votre demande concernant :</p>
<p><strong>[res_letterbox.subject]</strong></p>
<p>&agrave; bien &eacute;t&eacute; r&eacute;ceptionn&eacute;e par nos <span style="color: #2dc26b;">services</span> le [res_letterbox.admission_date;frm=dd/mm/yyyy].</p>
<p><br>La r&eacute;f&eacute;rence de votre dossier est : <strong>[res_letterbox.alt_identifier]</strong></p>
<p>Le pr&eacute;sent accus&eacute; de r&eacute;ception atteste de la r&eacute;ception de votre demande. Il ne pr&eacute;juge pas de la conformit&eacute; de son contenu qui d&eacute;pend entre autres de l''&eacute;tude des pi&egrave;ces fournies.</p>
<p>Si l''instruction de votre demande n&eacute;cessite des informations ou des pi&egrave;ces compl&eacute;mentaires, nos services vous en ferons la demande</p>
<p>&nbsp;</p>
<p>Nous vous conseillons de conserver ce message jusqu''&agrave; la fin du traitement de votre dossier.</p>
<p>&nbsp;</p>
<p>[userPrimaryEntity.entity_label]</p>
<p><span style="color: #2dc26b;">Ville de MEM-en-Provence</span></p>
</div>', 'OFFICE_HTML', '2021/03/0001/', '0011_1443263267.docx', '', 'letterbox_attachment', 'acknowledgementReceipt',
        'simple', NULL,
        '{"acknowledgementReceiptFrom": "destination"}'); -- EDISSYUM - AMO01 Modification du format des dates dans les templates de notification
INSERT INTO templates (template_id, template_label, template_comment, template_content, template_type, template_path,
                       template_file_name, template_style, template_datasource, template_target,
                       template_attachment_type, subject, options)
VALUES (1034, 'AR EN MASSE TYPE SVA',
        'Cas d’une demande impliquant une décision implicite d''acceptation de l’administration', '<div class="is-node"><br><hr><span style="color: #2dc26b;">H&ocirc;tel de ville</span><br><span style="color: #2dc26b;">Place de la Fraternit&eacute;</span><br><span style="color: #2dc26b;">99000 MEM-en-Provence</span>
<p>&nbsp;</p>
<p><span style="color: #236fa1;"><strong><span style="color: #2dc26b;">Accus&eacute; de r&eacute;ception de votre demande intervenant</span><br><span style="color: #2dc26b;">dans le cadre d''une d&eacute;cision implicite d''acceptation</span><br></strong></span></p>
<p>Num&eacute;ro d''enregistrement :<strong> [res_letterbox.alt_identifier]</strong></p>
<p>Service instructeur : <strong>[userPrimaryEntity.entity_label]</strong> <br>Courriel : [userPrimaryEntity.email]</p>
<p>[userPrimaryEntity.address_town], le [datetime.date;frm=dddd dd mmmm yyyy(locale)]</p>
<hr>
<p>Bonjour,</p>
<p>Votre demande concernant :</p>
<p><strong>[res_letterbox.subject]</strong></p>
<p>&agrave; bien &eacute;t&eacute; r&eacute;ceptionn&eacute;e par nos services le [res_letterbox.admission_date;frm=dd/mm/yyyy].</p>
<p><br>La r&eacute;f&eacute;rence de votre dossier est : <strong>[res_letterbox.alt_identifier]</strong></p>
Le pr&eacute;sent accus&eacute; de r&eacute;ception atteste de la r&eacute;ception de votre demande. il ne pr&eacute;juge pas de la conformit&eacute; de son contenu qui d&eacute;pend entre autres de l''''&eacute;tude des pi&egrave;ces fournies.<br><br>Votre demande est susceptible de faire l''objet d''''une d&eacute;cision implicite d''''acceptation en l''absence de r&eacute;ponse dans les jours suivant sa r&eacute;ception, soit le <strong>[res_letterbox.process_limit_date;frm=dd/mm/yyyy]</strong>.<br><br>Si l''instruction de votre demande n&eacute;cessite des informations ou pi&egrave;ces compl&eacute;mentaires, la Ville vous contactera afin de les fournir, dans un d&eacute;lai de production qui sera fix&eacute;.<br><br>Le cas &eacute;ch&eacute;ant, le d&eacute;lai de d&eacute;cision implicite d''acceptation ne d&eacute;butera qu''''apr&egrave;s la production des pi&egrave;ces demand&eacute;es.<br><br>En cas de d&eacute;cision implicite d''''acceptation vous avez la possibilit&eacute; de demander au service charg&eacute; du dossier une attestation conform&eacute;ment aux dispositions de l''article 22 de la loi n&deg; 2000-321 du 12 avril 2000 relative aux droits des citoyens dans leurs relations avec les administrations modifi&eacute;e.
<p>Nous vous conseillons de conserver ce message jusqu''&agrave; la fin du traitement de votre dossier.</p>
<p>&nbsp;</p>
<p><span style="color: #2dc26b;">Ville de MEM-en-Provence</span><br>[userPrimaryEntity.entity_label]</p>
<p>Courriel : [userPrimaryEntity.email]<br>T&eacute;l&eacute;phone : [user.phone]</p>
</div>', 'OFFICE_HTML', NULL, NULL, 'DOCX: AR_Masse_SVA', 'letterbox_attachment', 'acknowledgementReceipt', 'sva', NULL,
        '{"acknowledgementReceiptFrom": "destination"}'); -- EDISSYUM - AMO01 Modification du format des dates dans les templates de notification
INSERT INTO templates (template_id, template_label, template_comment, template_content, template_type, template_path,
                       template_file_name, template_style, template_datasource, template_target,
                       template_attachment_type, subject, options)
VALUES (1045, 'AR TYPE SVR - Courriel Manuel', 'A utiliser avec l''action "Générer les AR"', '<div id="write" class="is-node"><br /><hr /><span style="color: #236fa1;">H&ocirc;tel de ville</span><br /><span style="color: #236fa1;">Place de la Libert&eacute;</span><br /><span style="color: #236fa1;">99000 Maarch-les-bains</span>
<p>&nbsp;</p>
<p><span style="color: #236fa1;"><strong>Accus&eacute; de r&eacute;ception de votre demande intervenant<br />dans le cadre d''une d&eacute;cision implicite de rejet<br /></strong></span></p>
<p>Num&eacute;ro d''enregistrement :<strong> [res_letterbox.alt_identifier]</strong></p>
<p>Service instructeur : <strong>[userPrimaryEntity.entity_label]</strong> <br />Courriel : [userPrimaryEntity.email]</p>
<p>[userPrimaryEntity.address_town], le [datetime.date;frm=dddd dd mmmm yyyy (locale)]</p>
<hr />
<p>Bonjour,</p>
<p>Votre demande concernant :</p>
<p><strong>[res_letterbox.subject]</strong></p>
<p>&agrave; bien &eacute;t&eacute; r&eacute;ceptionn&eacute;e par nos services le [res_letterbox.admission_date].</p>
<p><br />La r&eacute;f&eacute;rence de votre dossier est : <strong>[res_letterbox.alt_identifier]</strong></p>
Le pr&eacute;sent accus&eacute; de r&eacute;ception atteste de la r&eacute;ception de votre demande. il ne pr&eacute;juge pas de la conformit&eacute; de son contenu qui d&eacute;pend entre autres de l''''&eacute;tude des pi&egrave;ces fournies.<br /><br />Votre demande est susceptible de faire l''objet d''une d&eacute;cision implicite de rejet en l''absence de r&eacute;ponse dans les jours suivant sa r&eacute;ception, soit le <strong>[res_letterbox.process_limit_date]</strong>.<br /><br />Si l''instruction de votre demande n&eacute;cessite des informations ou pi&egrave;ces compl&eacute;mentaires, la Ville vous contactera afin de les fournir, dans un d&eacute;lai de production qui sera fix&eacute;.<br /><br />Dans ce cas, le d&eacute;lai de d&eacute;cision implicite de rejet serait alors suspendu le temps de produire les pi&egrave;ces demand&eacute;es.<br /><br />Si vous estimez que la d&eacute;cision qui sera prise par l''administration est contestable, vous pourrez formuler :<br /><br />- Soit un recours gracieux devant l''auteur de la d&eacute;cision<br />- Soit un recours hi&eacute;rarchique devant le Maire<br />- Soit un recours contentieux devant le Tribunal Administratif territorialement comp&eacute;tent.<br /><br />Le recours gracieux ou le recours hi&eacute;rarchique peuvent &ecirc;tre faits sans condition de d&eacute;lais.<br /><br />Le recours contentieux doit intervenir dans un d&eacute;lai de deux mois &agrave; compter de la notification de la d&eacute;cision.<br /><br />Toutefois, si vous souhaitez en cas de rejet du recours gracieux ou du recours hi&eacute;rarchique former un recours contentieux, ce recours gracieux ou hi&eacute;rarchique devra avoir &eacute;t&eacute; introduit dans le d&eacute;lai sus-indiqu&eacute; du recours contentieux.<br /><br />Vous conserverez ainsi la possibilit&eacute; de former un recours contentieux, dans un d&eacute;lai de deux mois &agrave; compter de la d&eacute;cision intervenue sur ledit recours gracieux ou hi&eacute;rarchique.<br />
<p>Nous vous conseillons de conserver ce message jusqu''&agrave; la fin du traitement de votre dossier.</p>
<p>&nbsp;</p>
<p><span style="color: #236fa1;">Ville de Maarch-les-Bains</span><br />[userPrimaryEntity.entity_label]</p>
<p>Courriel : [userPrimaryEntity.email]<br />T&eacute;l&eacute;phone : [user.phone]</p>
</div>', 'HTML', NULL, NULL, NULL, 'letterbox_attachment', 'sendmail', 'all', NULL, '{}');
INSERT INTO templates (template_id, template_label, template_comment, template_content, template_type, template_path,
                       template_file_name, template_style, template_datasource, template_target,
                       template_attachment_type, subject, options)
VALUES (1035, 'AR EN MASSE TYPE SVR',
        'Cas d’une demande impliquant une décision implicite de rejet de l’administration', '<div class="is-node"><br><hr><span style="color: #2dc26b;">H&ocirc;tel de ville</span><br><span style="color: #2dc26b;">Place de la Fraternit&eacute;</span><br><span style="color: #2dc26b;">99000 MEM-en-Provence</span>
<p>&nbsp;</p>
<p><span style="color: #236fa1;"><strong><span style="color: #2dc26b;">Accus&eacute; de r&eacute;ception de votre demande intervenant</span><br><span style="color: #2dc26b;">dans le cadre d''une d&eacute;cision implicite de rejet</span><br></strong></span></p>
<p>Num&eacute;ro d''enregistrement :<strong> [res_letterbox.alt_identifier]</strong></p>
<p>Service instructeur : <strong>[userPrimaryEntity.entity_label]</strong> <br>Courriel : [userPrimaryEntity.email]</p>
<p>[userPrimaryEntity.address_town], le [datetime.date;frm=dddd dd mmmm yyyy(locale)]</p>
<hr>
<p>Bonjour,</p>
<p>Votre demande concernant :</p>
<p><strong>[res_letterbox.subject]</strong></p>
<p>&agrave; bien &eacute;t&eacute; r&eacute;ceptionn&eacute;e par nos services le [res_letterbox.admission_date;frm=dd/mm/yyyy].</p>
<p><br>La r&eacute;f&eacute;rence de votre dossier est : <strong>[res_letterbox.alt_identifier]</strong></p>
Le pr&eacute;sent accus&eacute; de r&eacute;ception atteste de la r&eacute;ception de votre demande. il ne pr&eacute;juge pas de la conformit&eacute; de son contenu qui d&eacute;pend entre autres de l''''&eacute;tude des pi&egrave;ces fournies.<br><br>Votre demande est susceptible de faire l''objet d''une d&eacute;cision implicite de rejet en l''absence de r&eacute;ponse dans les jours suivant sa r&eacute;ception, soit le <strong>[res_letterbox.process_limit_date;frm=dd/mm/yyyy]</strong>.<br><br>Si l''instruction de votre demande n&eacute;cessite des informations ou pi&egrave;ces compl&eacute;mentaires, la Ville vous contactera afin de les fournir, dans un d&eacute;lai de production qui sera fix&eacute;.<br><br>Dans ce cas, le d&eacute;lai de d&eacute;cision implicite de rejet serait alors suspendu le temps de produire les pi&egrave;ces demand&eacute;es.<br><br>Si vous estimez que la d&eacute;cision qui sera prise par l''administration est contestable, vous pourrez formuler :<br><br>- Soit un recours gracieux devant l''auteur de la d&eacute;cision<br>- Soit un recours hi&eacute;rarchique devant le Maire<br>- Soit un recours contentieux devant le Tribunal Administratif territorialement comp&eacute;tent.<br><br>Le recours gracieux ou le recours hi&eacute;rarchique peuvent &ecirc;tre faits sans condition de d&eacute;lais.<br><br>Le recours contentieux doit intervenir dans un d&eacute;lai de deux mois &agrave; compter de la notification de la d&eacute;cision.<br><br>Toutefois, si vous souhaitez en cas de rejet du recours gracieux ou du recours hi&eacute;rarchique former un recours contentieux, ce recours gracieux ou hi&eacute;rarchique devra avoir &eacute;t&eacute; introduit dans le d&eacute;lai sus-indiqu&eacute; du recours contentieux.<br><br>Vous conserverez ainsi la possibilit&eacute; de former un recours contentieux, dans un d&eacute;lai de deux mois &agrave; compter de la d&eacute;cision intervenue sur ledit recours gracieux ou hi&eacute;rarchique.<br>
<p>Nous vous conseillons de conserver ce message jusqu''&agrave; la fin du traitement de votre dossier.</p>
<p>&nbsp;</p>
<p><span style="color: #2dc26b;">Ville de MEM-en-Provence</span><br>[userPrimaryEntity.entity_label]</p>
<p>Courriel : [userPrimaryEntity.email]<br>T&eacute;l&eacute;phone : [user.phone]</p>
</div>', 'OFFICE_HTML', NULL, NULL, 'DOCX: AR_Masse_SVR', 'letterbox_attachment', 'acknowledgementReceipt', 'svr', NULL,
        '{"acknowledgementReceiptFrom": "destination"}'); -- EDISSYUM - AMO01 Modification du format des dates dans les templates de notification
INSERT INTO templates (template_id, template_label, template_comment, template_content, template_type, template_path,
                       template_file_name, template_style, template_datasource, template_target,
                       template_attachment_type, subject, options)
VALUES (1036, 'SVE - Courriel de réorientation', 'Modèle de courriel de réorientation d''une saisine SVE', '<div id="write" class="is-node"><br /><hr /><span style="color: #236fa1;">H&ocirc;tel de ville</span><br /><span style="color: #236fa1;">Place de la Libert&eacute;</span><br /><span style="color: #236fa1;">99000 Maarch-les-bains</span>
<p>[destination.entity_label]<br /><br />T&eacute;l&eacute;phone : &nbsp;&nbsp; &nbsp;[user.phone]<br />Courriel : &nbsp;&nbsp;&nbsp; [destination.email]</p>
<p>[destination.address_town], le [datetime.date;frm=dddd dd mmmm yyyy (locale)]</p>
<hr />
<p>Bonjour,</p>
Le [res_letterbox.doc_date], vous avez transmis par voie &eacute;lectronique &agrave; la Ville une demande qui ne rel&egrave;ve pas de sa comp&eacute;tence.<br /><br />Votre demande cit&eacute;e en objet de ce courriel a &eacute;t&eacute; transmise &agrave;</div>
<div class="is-node">&nbsp;</div>
<div class="is-node">(veuillez renseigner le nom de l''AUTORITE COMPETENTE).<br />
<p><br /><br /></p>
<p>&nbsp;</p>
<p>&nbsp;</p>
</div>', 'HTML', NULL, NULL, 'DOCX: AR_Masse_SVA', 'letterbox_attachment', 'sendmail', 'all', NULL, '{}');
INSERT INTO templates (template_id, template_label, template_comment, template_content, template_type, template_path,
                       template_file_name, template_style, template_datasource, template_target,
                       template_attachment_type, subject, options)
VALUES (1043, 'AR TYPE SIMPLE- Courriel Manuel', 'A utiliser avec l''action "Générer les AR"', '<div id="write" class="is-node"><br /><hr /><span style="color: #236fa1;">H&ocirc;tel de ville</span><br /><span style="color: #236fa1;">Place de la Libert&eacute;</span><br /><span style="color: #236fa1;">99000 Maarch-les-bains</span>
<p>&nbsp;</p>
<p><span style="color: #236fa1;"><strong>Accus&eacute; de r&eacute;ception</strong></span></p>
<p>Service instructeur : <strong>[userPrimaryEntity.entity_label]</strong> <br />Courriel : [userPrimaryEntity.email]</p>
<p>[userPrimaryEntity.address_town], le [datetime.date;frm=dddd dd mmmm yyyy (locale)]</p>
<hr />
<p>Bonjour,</p>
<p>Votre demande concernant :</p>
<p><strong>[res_letterbox.subject]</strong></p>
<p>&agrave; bien &eacute;t&eacute; r&eacute;ceptionn&eacute;e par nos services le [res_letterbox.admission_date].</p>
<p><br />La r&eacute;f&eacute;rence de votre dossier est : <strong>[res_letterbox.alt_identifier]</strong></p>
<p>Le pr&eacute;sent accus&eacute; de r&eacute;ception atteste de la r&eacute;ception de votre demande. Il ne pr&eacute;juge pas de la conformit&eacute; de son contenu qui d&eacute;pend entre autres de l''&eacute;tude des pi&egrave;ces fournies.</p>
<p>Si l''instruction de votre demande n&eacute;cessite des informations ou des pi&egrave;ces compl&eacute;mentaires, nos services vous en ferons la demande</p>
<p>&nbsp;</p>
<p>Nous vous conseillons de conserver ce message jusqu''&agrave; la fin du traitement de votre dossier.</p>
<p>&nbsp;</p>
<p>[userPrimaryEntity.entity_label]</p>
<p>Ville de Maarch-les-Bains</p>
<p>&nbsp;</p>
</div>', 'HTML', NULL, NULL, NULL, 'letterbox_attachment', 'sendmail', 'all', NULL, '{}');
INSERT INTO templates (template_id, template_label, template_comment, template_content, template_type, template_path,
                       template_file_name, template_style, template_datasource, template_target,
                       template_attachment_type, subject, options)
VALUES (1044, 'AR TYPE SVA - Courriel Manuel', 'A utiliser avec l''action "Générer les AR"', '<div id="write" class="is-node"><br /><hr /><span style="color: #236fa1;">H&ocirc;tel de ville</span><br /><span style="color: #236fa1;">Place de la Libert&eacute;</span><br /><span style="color: #236fa1;">99000 Maarch-les-bains</span>
<p>&nbsp;</p>
<p><span style="color: #236fa1;"><strong>Accus&eacute; de r&eacute;ception de votre demande intervenant<br />dans le cadre d''une d&eacute;cision implicite d''acceptation<br /></strong></span></p>
<p>Num&eacute;ro d''enregistrement :<strong> [res_letterbox.alt_identifier]</strong></p>
<p>Service instructeur : <strong>[userPrimaryEntity.entity_label]</strong> <br />Courriel : [userPrimaryEntity.email]</p>
<p>[userPrimaryEntity.address_town], le [datetime.date;frm=dddd dd mmmm yyyy (locale)]</p>
<hr />
<p>Bonjour,</p>
<p>Votre demande concernant :</p>
<p><strong>[res_letterbox.subject]</strong></p>
<p>&agrave; bien &eacute;t&eacute; r&eacute;ceptionn&eacute;e par nos services le [res_letterbox.admission_date].</p>
<p><br />La r&eacute;f&eacute;rence de votre dossier est : <strong>[res_letterbox.alt_identifier]</strong></p>
Le pr&eacute;sent accus&eacute; de r&eacute;ception atteste de la r&eacute;ception de votre demande. il ne pr&eacute;juge pas de la conformit&eacute; de son contenu qui d&eacute;pend entre autres de l''''&eacute;tude des pi&egrave;ces fournies.<br /><br />Votre demande est susceptible de faire l''objet d''''une d&eacute;cision implicite d''''acceptation en l''absence de r&eacute;ponse dans les jours suivant sa r&eacute;ception, soit le <strong>[res_letterbox.process_limit_date]</strong>.<br /><br />Si l''instruction de votre demande n&eacute;cessite des informations ou pi&egrave;ces compl&eacute;mentaires, la Ville vous contactera afin de les fournir, dans un d&eacute;lai de production qui sera fix&eacute;.<br /><br />Le cas &eacute;ch&eacute;ant, le d&eacute;lai de d&eacute;cision implicite d''acceptation ne d&eacute;butera qu''''apr&egrave;s la production des pi&egrave;ces demand&eacute;es.<br /><br />En cas de d&eacute;cision implicite d''''acceptation vous avez la possibilit&eacute; de demander au service charg&eacute; du dossier une attestation conform&eacute;ment aux dispositions de l''article 22 de la loi n&deg; 2000-321 du 12 avril 2000 relative aux droits des citoyens dans leurs relations avec les administrations modifi&eacute;e.
<p>Nous vous conseillons de conserver ce message jusqu''&agrave; la fin du traitement de votre dossier.</p>
<p>&nbsp;</p>
<p><span style="color: #236fa1;">Ville de Maarch-les-Bains</span><br />[userPrimaryEntity.entity_label]</p>
<p>Courriel : [userPrimaryEntity.email]<br />T&eacute;l&eacute;phone : [user.phone]</p>
</div>', 'HTML', NULL, NULL, NULL, 'letterbox_attachment', 'sendmail', 'all', NULL, '{}');
INSERT INTO templates (template_id, template_label, template_comment, template_content, template_type, template_path,
                       template_file_name, template_style, template_datasource, template_target,
                       template_attachment_type, subject, options)
VALUES (1041, 'PR - Invitation (Visa interne)', 'Projet de réponse invitation pour visa interne', NULL, 'OFFICE',
        '2021/03/0001/', '0001_742130848.docx', 'DOCX: PR02_INVITATION', 'letterbox_attachment', 'attachments',
        'response_project', NULL, '{}');
INSERT INTO templates (template_id, template_label, template_comment, template_content, template_type, template_path,
                       template_file_name, template_style, template_datasource, template_target,
                       template_attachment_type, subject, options)
VALUES (1047, 'EC - Générique (Visa externe)', 'Enregistrement de courrier générique', NULL, 'OFFICE', '2021/03/0001/',
        '0005_1707546937.docx', 'DOCX: EC01_GENERIC', 'letterbox_attachment', 'indexingFile', 'all', NULL, '{}');
INSERT INTO templates (template_id, template_label, template_comment, template_content, template_type, template_path,
                       template_file_name, template_style, template_datasource, template_target,
                       template_attachment_type, subject, options)
VALUES (1048, 'PR - Générique (Visa externe)', 'Projet de réponse générique', NULL, 'OFFICE', '2021/03/0001/',
        '0008_1397704541.docx', 'DOCX: PR01_GENERIC', 'letterbox_attachment', 'attachments', 'response_project', NULL,
        '{}');
INSERT INTO templates (template_id, template_label, template_comment, template_content, template_type, template_path,
                       template_file_name, template_style, template_datasource, template_target,
                       template_attachment_type, subject, options)
VALUES (1038, 'EC - Générique (Visa interne)', 'Enregistrement de courrier générique', NULL, 'OFFICE', '2021/03/0001/',
        '0003_320653448.docx', 'DOCX: EC01_GENERIC', 'letterbox_attachment', 'indexingFile', 'all', NULL, '{}');
INSERT INTO templates (template_id, template_label, template_comment, template_content, template_type, template_path,
                       template_file_name, template_style, template_datasource, template_target,
                       template_attachment_type, subject, options)
VALUES (1040, 'PR - Générique (Visa interne)', 'Projet de réponse générique', NULL, 'OFFICE', '2021/03/0001/',
        '0006_1786637551.docx', 'DOCX: PR01_GENERIC', 'letterbox_attachment', 'attachments', 'response_project', NULL,
        '{}');
INSERT INTO templates (template_id, template_label, template_comment, template_content, template_type, template_path,
                       template_file_name, template_style, template_datasource, template_target,
                       template_attachment_type, subject, options)
VALUES (1046, 'PR - Invitation (Visa externe)', 'Modèle invitation pour visa externe', NULL, 'OFFICE', '2021/03/0001/',
        '0002_705367294.docx', NULL, 'letterbox_attachment', 'attachments', 'response_project', NULL, '{}');
INSERT INTO templates (template_id, template_label, template_comment, template_content, template_type, template_path,
                       template_file_name, template_style, template_datasource, template_target,
                       template_attachment_type, subject, options)
VALUES (20, 'Courriel d''accompagnement', 'Modèle de courriel d''accompagnement', '<div id="write" class="is-node"><br /><hr /><span style="color: #236fa1;">H&ocirc;tel de ville</span><br /><span style="color: #236fa1;">Place de la Libert&eacute;</span><br /><span style="color: #236fa1;">99000 Maarch-les-bains</span>
<p>[user.firstname] [user.lastname]<br />[userPrimaryEntity.role]<br />[userPrimaryEntity.entity_label]<br /><br />T&eacute;l&eacute;phone : &nbsp;&nbsp; &nbsp;[user.phone]<br />Courriel : &nbsp;&nbsp; &nbsp;[user.mail]</p>
<p>[userPrimaryEntity.address_town], le [datetime.date;frm=dddd dd mmmm yyyy (locale)]</p>
<hr />
<p>Bonjour,</p>
<p>Veuillez trouver en pi&egrave;ce jointe &agrave; ce courriel notre r&eacute;ponse &agrave; votre demande du [res_letterbox.admission_date].</p>
<p>Bien cordialement.</p>
<p>[user.firstname] [user.lastname]<br />[userPrimaryEntity.role]<br />[userPrimaryEntity.entity_label]<br /><br /></p>
<p>&nbsp;</p>
<p>&nbsp;</p>
</div>', 'HTML', NULL, NULL, 'DOCX: standard_nosign', 'letterbox_attachment', 'sendmail', 'all', NULL, '{}');
INSERT INTO templates (template_id, template_label, template_comment, template_content, template_type, template_path,
                       template_file_name, template_style, template_datasource, template_target,
                       template_attachment_type, subject, options)
VALUES (7, '[notification courrier] Diffusion de courrier', 'Alerte de courriers présents dans les bannettes', '<p style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif;">Bonjour <strong>[recipient.firstname] [recipient.lastname]</strong>,</p>
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
<p style="font-family: Trebuchet MS, Arial, Helvetica, sans-serif; width: 100%; text-align: center; font-size: 9px; font-style: italic; opacity: 0.5;">Message g&eacute;n&eacute;r&eacute; via l''application MEMCourrier</p>''',
        'HTML', NULL, NULL, 'ODP: open_office_presentation', 'letterbox_events', 'notifications', NULL, NULL,
        '{}'); -- EDISSYUM - AMO01 Modifier la structure des templates de notifications | Ajustements dans le template_content
INSERT INTO templates (template_id, template_label, template_comment, template_content, template_type, template_style, template_target, template_attachment_type, template_datasource) VALUES (1049, 'Quota d''utilisateur', 'Modèle de notification pour le quota utilisateur', '<p>Quota utilisateur atteint</p>', 'HTML', 'ODT: rep_standard', 'notifications', 'all', 'notif_events'); -- EDISSYUM - NCH01 Fix notification USER QUOTA

INSERT INTO templates_association (id, template_id, value_field)
VALUES (1, 900, 'VILLE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (2, 901, 'VILLE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (3, 902, 'VILLE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (4, 904, 'VILLE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (5, 905, 'VILLE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (6, 906, 'VILLE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (7, 907, 'VILLE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (8, 908, 'VILLE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (9, 909, 'VILLE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (10, 910, 'VILLE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (11, 1033, 'VILLE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (12, 1034, 'VILLE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (572, 1046, 'CAB');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (573, 1046, 'COR');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (15, 1035, 'VILLE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (574, 1046, 'FIN');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (575, 1046, 'DRH');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (576, 1046, 'DSI');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (577, 1046, 'DGA');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (20, 900, 'CAB');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (21, 901, 'CAB');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (22, 902, 'CAB');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (23, 904, 'CAB');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (24, 905, 'CAB');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (25, 906, 'CAB');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (26, 907, 'CAB');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (27, 908, 'CAB');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (28, 909, 'CAB');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (29, 910, 'CAB');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (30, 1033, 'CAB');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (31, 1034, 'CAB');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (578, 1046, 'DGS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (579, 1046, 'PE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (34, 1035, 'CAB');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (580, 1046, 'PCU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (581, 1046, 'PSF');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (582, 1046, 'PJS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (583, 1046, 'PJU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (39, 900, 'DGS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (40, 901, 'DGS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (41, 902, 'DGS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (42, 904, 'DGS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (43, 905, 'DGS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (44, 906, 'DGS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (45, 907, 'DGS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (46, 908, 'DGS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (47, 909, 'DGS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (48, 910, 'DGS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (49, 1033, 'DGS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (50, 1034, 'DGS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (584, 1046, 'PSO');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (585, 1046, 'PTE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (53, 1035, 'DGS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (586, 1046, 'DSG');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (587, 1046, 'COU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (588, 1046, 'SP');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (589, 1046, 'VILLE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (58, 900, 'DGA');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (59, 901, 'DGA');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (60, 902, 'DGA');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (61, 904, 'DGA');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (62, 905, 'DGA');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (63, 906, 'DGA');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (64, 907, 'DGA');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (65, 908, 'DGA');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (66, 909, 'DGA');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (67, 910, 'DGA');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (68, 1033, 'DGA');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (69, 1034, 'DGA');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (72, 1035, 'DGA');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (77, 900, 'PCU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (78, 901, 'PCU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (79, 902, 'PCU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (80, 904, 'PCU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (81, 905, 'PCU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (82, 906, 'PCU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (83, 907, 'PCU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (84, 908, 'PCU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (85, 909, 'PCU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (86, 910, 'PCU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (87, 1033, 'PCU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (88, 1034, 'PCU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (91, 1035, 'PCU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (96, 900, 'PJS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (97, 901, 'PJS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (98, 902, 'PJS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (99, 904, 'PJS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (100, 905, 'PJS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (101, 906, 'PJS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (102, 907, 'PJS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (103, 908, 'PJS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (104, 909, 'PJS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (105, 910, 'PJS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (106, 1033, 'PJS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (107, 1034, 'PJS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (110, 1035, 'PJS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (115, 900, 'PE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (116, 901, 'PE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (117, 902, 'PE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (118, 904, 'PE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (119, 905, 'PE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (120, 906, 'PE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (121, 907, 'PE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (122, 908, 'PE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (123, 909, 'PE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (124, 910, 'PE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (125, 1033, 'PE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (126, 1034, 'PE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (129, 1035, 'PE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (134, 900, 'SP');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (135, 901, 'SP');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (136, 902, 'SP');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (137, 904, 'SP');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (138, 905, 'SP');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (139, 906, 'SP');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (140, 907, 'SP');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (141, 908, 'SP');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (142, 909, 'SP');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (143, 910, 'SP');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (144, 1033, 'SP');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (145, 1034, 'SP');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (148, 1035, 'SP');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (153, 900, 'PSO');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (154, 901, 'PSO');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (155, 902, 'PSO');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (156, 904, 'PSO');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (157, 905, 'PSO');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (158, 906, 'PSO');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (159, 907, 'PSO');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (160, 908, 'PSO');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (161, 909, 'PSO');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (162, 910, 'PSO');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (163, 1033, 'PSO');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (164, 1034, 'PSO');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (590, 1041, 'CAB');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (591, 1041, 'COR');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (167, 1035, 'PSO');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (592, 1041, 'FIN');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (593, 1041, 'DRH');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (594, 1041, 'DSI');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (595, 1041, 'DGA');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (172, 900, 'PTE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (173, 901, 'PTE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (174, 902, 'PTE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (175, 904, 'PTE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (176, 905, 'PTE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (177, 906, 'PTE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (178, 907, 'PTE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (179, 908, 'PTE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (180, 909, 'PTE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (181, 910, 'PTE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (182, 1033, 'PTE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (183, 1034, 'PTE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (596, 1041, 'DGS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (597, 1041, 'PE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (186, 1035, 'PTE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (598, 1041, 'PCU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (599, 1041, 'PSF');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (600, 1041, 'PJS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (601, 1041, 'PJU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (191, 900, 'DRH');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (192, 901, 'DRH');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (193, 902, 'DRH');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (194, 904, 'DRH');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (195, 905, 'DRH');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (196, 906, 'DRH');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (197, 907, 'DRH');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (198, 908, 'DRH');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (199, 909, 'DRH');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (200, 910, 'DRH');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (201, 1033, 'DRH');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (202, 1034, 'DRH');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (602, 1041, 'PSO');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (603, 1041, 'PTE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (205, 1035, 'DRH');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (604, 1041, 'DSG');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (605, 1041, 'COU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (606, 1041, 'SP');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (607, 1041, 'VILLE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (210, 900, 'DSG');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (211, 901, 'DSG');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (212, 902, 'DSG');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (213, 904, 'DSG');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (214, 905, 'DSG');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (215, 906, 'DSG');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (216, 907, 'DSG');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (217, 908, 'DSG');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (218, 909, 'DSG');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (219, 910, 'DSG');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (220, 1033, 'DSG');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (221, 1034, 'DSG');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (224, 1035, 'DSG');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (229, 900, 'COU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (230, 901, 'COU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (231, 902, 'COU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (232, 904, 'COU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (233, 905, 'COU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (234, 906, 'COU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (235, 907, 'COU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (236, 908, 'COU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (237, 909, 'COU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (238, 910, 'COU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (239, 1033, 'COU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (240, 1034, 'COU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (243, 1035, 'COU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (248, 900, 'COR');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (249, 901, 'COR');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (250, 902, 'COR');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (251, 904, 'COR');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (252, 905, 'COR');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (253, 906, 'COR');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (254, 907, 'COR');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (255, 908, 'COR');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (256, 909, 'COR');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (257, 910, 'COR');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (258, 1033, 'COR');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (259, 1034, 'COR');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (262, 1035, 'COR');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (267, 900, 'PSF');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (268, 901, 'PSF');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (269, 902, 'PSF');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (270, 904, 'PSF');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (271, 905, 'PSF');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (272, 906, 'PSF');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (273, 907, 'PSF');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (274, 908, 'PSF');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (275, 909, 'PSF');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (276, 910, 'PSF');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (277, 1033, 'PSF');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (278, 1034, 'PSF');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (281, 1035, 'PSF');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (286, 900, 'DSI');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (287, 901, 'DSI');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (288, 902, 'DSI');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (289, 904, 'DSI');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (290, 905, 'DSI');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (291, 906, 'DSI');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (292, 907, 'DSI');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (293, 908, 'DSI');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (294, 909, 'DSI');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (295, 910, 'DSI');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (296, 1033, 'DSI');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (297, 1034, 'DSI');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (300, 1035, 'DSI');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (305, 900, 'FIN');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (306, 901, 'FIN');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (307, 902, 'FIN');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (308, 904, 'FIN');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (309, 905, 'FIN');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (310, 906, 'FIN');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (311, 907, 'FIN');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (312, 908, 'FIN');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (313, 909, 'FIN');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (314, 910, 'FIN');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (315, 1033, 'FIN');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (316, 1034, 'FIN');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (319, 1035, 'FIN');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (324, 900, 'PJU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (325, 901, 'PJU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (326, 902, 'PJU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (327, 904, 'PJU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (328, 905, 'PJU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (329, 906, 'PJU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (330, 907, 'PJU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (331, 908, 'PJU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (332, 909, 'PJU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (333, 910, 'PJU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (334, 1033, 'PJU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (335, 1034, 'PJU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (338, 1035, 'PJU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (343, 900, 'ELUS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (344, 901, 'ELUS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (345, 902, 'ELUS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (346, 904, 'ELUS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (347, 905, 'ELUS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (348, 906, 'ELUS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (349, 907, 'ELUS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (350, 908, 'ELUS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (351, 909, 'ELUS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (352, 910, 'ELUS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (353, 1033, 'ELUS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (354, 1034, 'ELUS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (357, 1035, 'ELUS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (362, 900, 'CCAS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (363, 901, 'CCAS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (364, 902, 'CCAS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (365, 904, 'CCAS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (366, 905, 'CCAS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (367, 906, 'CCAS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (368, 907, 'CCAS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (369, 908, 'CCAS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (370, 909, 'CCAS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (371, 910, 'CCAS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (372, 1033, 'CCAS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (373, 1034, 'CCAS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (376, 1035, 'CCAS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (499, 1048, 'CAB');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (500, 1048, 'COR');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (501, 1048, 'FIN');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (502, 1048, 'DRH');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (503, 1048, 'DSI');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (504, 1048, 'DGA');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (505, 1048, 'DGS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (506, 1048, 'ELUS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (507, 1048, 'PE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (508, 1048, 'PCU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (509, 1048, 'PSF');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (510, 1048, 'PJS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (511, 1048, 'PJU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (512, 1048, 'PSO');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (513, 1048, 'PTE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (514, 1048, 'DSG');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (515, 1048, 'COU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (516, 1048, 'SP');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (517, 1048, 'VILLE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (518, 1038, 'CAB');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (519, 1038, 'COR');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (520, 1038, 'FIN');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (521, 1038, 'DRH');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (522, 1038, 'DSI');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (523, 1038, 'DGA');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (524, 1038, 'DGS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (525, 1038, 'PE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (526, 1038, 'PCU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (527, 1038, 'PSF');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (528, 1038, 'PJS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (529, 1038, 'PJU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (530, 1038, 'PSO');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (531, 1038, 'PTE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (532, 1038, 'DSG');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (533, 1038, 'COU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (534, 1038, 'SP');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (535, 1038, 'VILLE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (536, 1047, 'CAB');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (537, 1047, 'COR');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (538, 1047, 'FIN');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (539, 1047, 'DRH');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (540, 1047, 'DSI');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (541, 1047, 'DGA');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (542, 1047, 'DGS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (543, 1047, 'PE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (544, 1047, 'PCU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (545, 1047, 'PSF');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (546, 1047, 'PJS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (547, 1047, 'PJU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (548, 1047, 'PSO');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (549, 1047, 'PTE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (550, 1047, 'DSG');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (551, 1047, 'COU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (552, 1047, 'SP');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (553, 1047, 'VILLE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (554, 1040, 'CAB');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (555, 1040, 'COR');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (556, 1040, 'FIN');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (557, 1040, 'DRH');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (558, 1040, 'DSI');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (559, 1040, 'DGA');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (560, 1040, 'DGS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (561, 1040, 'PE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (562, 1040, 'PCU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (563, 1040, 'PSF');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (564, 1040, 'PJS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (565, 1040, 'PJU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (566, 1040, 'PSO');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (567, 1040, 'PTE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (568, 1040, 'DSG');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (569, 1040, 'COU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (570, 1040, 'SP');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (571, 1040, 'VILLE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (627, 20, 'CAB');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (628, 20, 'CCAS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (629, 20, 'COR');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (630, 20, 'FIN');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (631, 20, 'DRH');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (632, 20, 'DSI');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (633, 20, 'DGA');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (634, 20, 'DGS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (635, 20, 'ELUS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (636, 20, 'PE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (637, 20, 'PCU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (638, 20, 'PSF');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (639, 20, 'PJS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (640, 20, 'PJU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (641, 20, 'PSO');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (642, 20, 'PTE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (643, 20, 'DSG');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (644, 20, 'COU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (645, 20, 'SP');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (646, 20, 'VILLE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (667, 7, 'CAB');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (668, 7, 'CCAS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (669, 7, 'COR');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (670, 7, 'FIN');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (671, 7, 'DRH');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (672, 7, 'DSI');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (673, 7, 'DGA');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (674, 7, 'DGS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (675, 7, 'ELUS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (676, 7, 'PE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (677, 7, 'PCU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (678, 7, 'PSF');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (679, 7, 'PJS');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (680, 7, 'PJU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (681, 7, 'PSO');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (682, 7, 'PTE');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (683, 7, 'DSG');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (684, 7, 'COU');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (685, 7, 'SP');
INSERT INTO templates_association (id, template_id, value_field)
VALUES (686, 7, 'VILLE');

DELETE FROM "usergroups";
INSERT INTO usergroups (id, group_id, group_desc, can_index, indexation_parameters, external_id) VALUES (5, 'ADMINISTRATEUR_N1', 'Admin. Fonctionnel N1', false, '{"actions": [],"entities": [],"keywords": []}','{}');
INSERT INTO usergroups (id, group_id, group_desc, can_index, indexation_parameters, external_id) VALUES (6, 'ADMINISTRATEUR_N2', 'Admin. Fonctionnel N2', false, '{"actions": [],"entities": [],"keywords": []}','{}');
INSERT INTO usergroups (id, group_id, group_desc, can_index, indexation_parameters, external_id) VALUES (2, 'AGENT', 'Utilisateur', true,'{"actions": ["572"],"entities": [], "keywords": ["MY_ENTITIES","ENTITIES_BELOW"]}','{}');
INSERT INTO usergroups (id, group_id, group_desc, can_index, indexation_parameters, external_id) VALUES (26, 'ASSISTCAB', 'Assistant(e) du Cabinet', false,'{"actions": [],"entities": [],"keywords": []}','{}');
INSERT INTO usergroups (id, group_id, group_desc, can_index, indexation_parameters, external_id) VALUES (25, 'ASSISTDGS', 'Assistant(e) DGS', false,'{"actions": [],"entities": [],"keywords": []}','{}');
INSERT INTO usergroups (id, group_id, group_desc, can_index, indexation_parameters, external_id) VALUES (27, 'ASSISTDIR', 'Assistant(e) Direction', false,'{"actions": [],"entities": [],"keywords": []}','{}');
INSERT INTO usergroups (id, group_id, group_desc, can_index, indexation_parameters, external_id) VALUES (28, 'ASSISTSERV', 'Assistant(e) Chef de Service', false,'{"actions": [],"entities": [],"keywords": []}','{}');
INSERT INTO usergroups (id, group_id, group_desc, can_index, indexation_parameters, external_id) VALUES (29, 'CHEF', 'Chef de Service', false,'{"actions": [],"entities": [],"keywords": []}','{}');
INSERT INTO usergroups (id, group_id, group_desc, can_index, indexation_parameters, external_id) VALUES (1, 'COURRIER', 'Opérateur courrier', true,'{"actions": ["584","588"],"entities": [],"keywords": ["ALL_ENTITIES"]}','{}');
INSERT INTO usergroups (id, group_id, group_desc, can_index, indexation_parameters, external_id) VALUES (7, 'DGS', 'Directeur Général des Services', false,'{"actions": ["572"],"entities": [], "keywords": ["MY_ENTITIES","ENTITIES_BELOW"]}','{}');
INSERT INTO usergroups (id, group_id, group_desc, can_index, indexation_parameters, external_id) VALUES (24, 'DIRCAB', 'Direction du Cabinet', false,'{"actions": [],"entities": [],"keywords": []}','{}');
INSERT INTO usergroups (id, group_id, group_desc, can_index, indexation_parameters, external_id) VALUES (21, 'DIRECTEUR', 'Directeur', false,'{"actions": [],"entities": [],"keywords": []}','{}');
INSERT INTO usergroups (id, group_id, group_desc, can_index, indexation_parameters, external_id) VALUES (8, 'ELU', 'Elu', false,'{"actions": [],"entities": [],"keywords": []}','{}');
INSERT INTO usergroups (id, group_id, group_desc, can_index, indexation_parameters, external_id) VALUES (11, 'MAARCHTOGEC', 'Envoi dématérialisé', false,'{"actions": [],"entities": [],"keywords": []}','{}');
INSERT INTO usergroups (id, group_id, group_desc, can_index, indexation_parameters, external_id) VALUES (14, 'MAIRE', 'Maire', false,'{"actions": [],"entities": [],"keywords": []}','{}');
INSERT INTO usergroups (id, group_id, group_desc, can_index, indexation_parameters, external_id) VALUES (20, 'REFERENT', 'Référent Courrier', false,'{"actions": [],"entities": [],"keywords": []}','{}');
INSERT INTO usergroups (id, group_id, group_desc, can_index, indexation_parameters, external_id) VALUES (3, 'RESP_COURRIER', 'Superviseur Courrier', false,'{"actions": [],"entities": [],"keywords": ["ALL_ENTITIES"]}','{}');
INSERT INTO usergroups (id, group_id, group_desc, can_index, indexation_parameters, external_id) VALUES (4, 'RESPONSABLE', 'Manager', true,'{"actions": ["572"],"entities": [], "keywords": ["MY_ENTITIES","ENTITIES_BELOW"]}','{}');
INSERT INTO usergroups (id, group_id, group_desc, can_index, indexation_parameters, external_id) VALUES (12, 'SERVICE', 'Bannette de Service', false,'{"actions": [],"entities": [],"keywords": []}','{}');
INSERT INTO usergroups (id, group_id, group_desc, can_index, indexation_parameters, external_id) VALUES (13, 'WEBSERVICE', 'Utilisateurs de WebService', true,'{"actions": ["20"],"entities": [],"keywords": ["ALL_ENTITIES"]}','{}');


DELETE FROM "usergroups_services";
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'admin', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ASSISTSERV', 'update_diffusion_except_recipient_details', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESP_COURRIER', 'admin_users', '{"groups": [6, 12, 21, 7, 24, 8, 14, 4, 1, 20, 3, 2, 28, 25, 27, 26, 29]}');
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('DIRECTEUR', 'update_diffusion_process', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('DIRECTEUR', 'update_diffusion_details', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('COURRIER', 'view_confidential_contact_advanced', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ASSISTSERV', 'update_diffusion_indexing', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ASSISTSERV', 'update_diffusion_except_recipient_process', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'view_personal_data', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'manage_personal_data', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESP_COURRIER', 'update_status_mail', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESP_COURRIER', 'view_personal_data', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESP_COURRIER', 'manage_personal_data', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESP_COURRIER', 'view_history', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ASSISTDGS', 'view_doc_history', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ASSISTDGS', 'view_full_history', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ASSISTDGS', 'use_mail_services', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ASSISTDGS', 'sendmail', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ASSISTDGS', 'update_diffusion_indexing', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ASSISTDGS', 'update_diffusion_process', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ASSISTDGS', 'update_diffusion_details', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESPONSABLE', 'create_public_indexing_models', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESP_COURRIER', 'admin_templates', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESP_COURRIER', 'admin_architecture', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESP_COURRIER', 'manage_entities', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESP_COURRIER', 'entities_print_sep_mlb', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ASSISTDGS', 'visa_documents', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ASSISTDGS', 'sign_document', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('COURRIER', 'admin', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('COURRIER', 'adv_search_mlb', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('COURRIER', 'create_contacts', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('COURRIER', 'update_contacts', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('COURRIER', 'update_status_mail', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('COURRIER', 'view_technical_infos', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('COURRIER', 'view_doc_history', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('COURRIER', 'view_full_history', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('COURRIER', 'add_links', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('COURRIER', 'update_diffusion_indexing', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('COURRIER', 'update_diffusion_details', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('COURRIER', 'entities_print_sep_mlb', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('COURRIER', 'sendmail', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('COURRIER', 'use_mail_services', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('COURRIER', 'include_folders_and_followed_resources_perimeter', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('COURRIER', 'view_documents_with_notes', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('COURRIER', 'add_new_version', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('COURRIER', 'view_version_letterbox', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('COURRIER', 'print_folder_doc', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('COURRIER', 'manage_tags_application', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('COURRIER', 'private_tag', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('COURRIER', '_print_sep', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('COURRIER', 'physical_archive_print_sep_mlb', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('AGENT', 'adv_search_mlb', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('AGENT', 'view_doc_history', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('AGENT', 'add_links', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('AGENT', 'update_diffusion_indexing', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('AGENT', 'sendmail', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('AGENT', 'use_mail_services', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('AGENT', 'include_folders_and_followed_resources_perimeter', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('AGENT', 'view_documents_with_notes', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('AGENT', 'add_new_version', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('AGENT', 'view_version_letterbox', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('AGENT', 'print_folder_doc', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('AGENT', 'config_avis_workflow', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('AGENT', 'config_avis_workflow_in_detail', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('AGENT', 'private_tag', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('AGENT', 'add_correspondent_in_shared_groups_on_profile', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESP_COURRIER', 'adv_search_mlb', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESP_COURRIER', 'create_contacts', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESP_COURRIER', 'update_contacts', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESP_COURRIER', 'view_doc_history', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESP_COURRIER', 'view_full_history', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESP_COURRIER', 'add_links', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESP_COURRIER', 'update_diffusion_indexing', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESP_COURRIER', 'update_diffusion_details', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESP_COURRIER', 'update_diffusion_process', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESP_COURRIER', 'sendmail', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESP_COURRIER', 'use_mail_services', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESP_COURRIER', 'include_folders_and_followed_resources_perimeter', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESP_COURRIER', 'view_documents_with_notes', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESP_COURRIER', 'add_new_version', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESP_COURRIER', 'view_version_letterbox', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESP_COURRIER', 'sign_document', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESP_COURRIER', 'visa_documents', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESP_COURRIER', 'print_folder_doc', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESP_COURRIER', 'private_tag', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESPONSABLE', 'adv_search_mlb', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESPONSABLE', 'view_doc_history', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESPONSABLE', 'add_links', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'registered_mail_receive_ar', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'entities_print_sep_mlb', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'registered_mail_mass_import', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'manage_numeric_package', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'adv_search_mlb', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'add_correspondent_in_shared_groups_on_profile', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'add_links', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'create_public_indexing_models', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'create_contacts', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'manage_tags_application', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'update_contacts', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'print_folder_doc', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'view_technical_infos', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'view_documents_with_notes', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('DIRECTEUR', 'config_visa_workflow_in_detail', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('DIRECTEUR', 'config_visa_workflow', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('CHEF', 'add_links', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('CHEF', 'include_folders_and_followed_resources_perimeter', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('CHEF', 'print_folder_doc', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('CHEF', 'view_documents_with_notes', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('CHEF', 'config_visa_workflow', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('CHEF', 'config_visa_workflow_in_detail', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('CHEF', 'visa_documents', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('CHEF', 'sendmail', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('CHEF', 'use_mail_services', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('CHEF', 'view_doc_history', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'update_resources', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('CHEF', 'update_diffusion_except_recipient_indexing', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('AGENT', 'update_resources', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('CHEF', 'update_diffusion_process', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('CHEF', 'update_diffusion_details', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESPONSABLE', 'update_diffusion_indexing', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESPONSABLE', 'sendmail', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESPONSABLE', 'use_mail_services', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('AGENT', 'create_public_indexing_models', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'view_contacts', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N1', 'view_contacts', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('COURRIER', 'view_contacts', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('COURRIER', 'adv_search_contacts_advanced', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESPONSABLE', 'view_contacts', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESP_COURRIER', 'view_contacts', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('REFERENT', 'view_contacts', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESPONSABLE', 'include_folders_and_followed_resources_perimeter', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESPONSABLE', 'view_documents_with_notes', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESPONSABLE', 'add_new_version', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESPONSABLE', 'view_version_letterbox', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESPONSABLE', 'sign_document', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESPONSABLE', 'visa_documents', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESPONSABLE', 'print_folder_doc', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESPONSABLE', 'config_avis_workflow', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESPONSABLE', 'config_avis_workflow_in_detail', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESPONSABLE', 'avis_documents', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESPONSABLE', 'private_tag', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESPONSABLE', 'add_correspondent_in_shared_groups_on_profile', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N1', 'admin', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N1', 'adv_search_mlb', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N1', 'admin_architecture', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N1', 'view_history', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N1', 'admin_contacts', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N1', 'create_contacts', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N1', 'update_contacts', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N1', 'update_status_mail', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N1', 'view_technical_infos', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N1', 'view_doc_history', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N1', 'view_full_history', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N1', 'add_links', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N1', 'manage_entities', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N1', 'admin_difflist_types', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N1', 'admin_listmodels', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N1', 'update_diffusion_indexing', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N1', 'update_diffusion_details', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N1', 'update_diffusion_process', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N1', 'entities_print_sep_mlb', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N1', 'sendmail', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N1', 'use_mail_services', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N1', 'include_folders_and_followed_resources_perimeter', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N1', 'view_documents_with_notes', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N1', 'add_new_version', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N1', 'view_version_letterbox', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N1', 'config_visa_workflow', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N1', 'config_visa_workflow_in_detail', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N1', 'print_folder_doc', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N1', 'config_avis_workflow', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N1', 'admin_templates', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N1', 'manage_tags_application', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N1', 'private_tag', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N1', 'admin_notif', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N1', '_print_sep', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N1', 'physical_archive_print_sep_mlb', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N1', 'physical_archive_batch_manage', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N1', 'admin_life_cycle', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N1', 'add_correspondent_in_shared_groups_on_profile', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'admin', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'view_doc_history', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'view_full_history', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'include_folders_and_followed_resources_perimeter', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'admin_templates', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ELU', 'include_folders_and_followed_resources_perimeter', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ELU', 'sign_document', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ELU', 'visa_documents', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ELU', 'avis_documents', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'admin_actions', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'admin_connections', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'admin_registered_mail', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'admin_architecture', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'view_history', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'admin_tag', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'admin_password_rules', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'view_confidential_contact', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'view_confidential_contact_advanced', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'config_visa_workflow', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'config_visa_workflow_in_detail', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'modify_visa_in_signatureBook', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'sign_document', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'visa_documents', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'freeze_retention_rule', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'set_binding_document', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'sendmail', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'use_mail_services', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'view_doc_history', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'view_full_history', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'update_diffusion_indexing', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'update_diffusion_process', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'update_diffusion_details', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'view_personal_data', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'manage_personal_data', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('DIRECTEUR', 'view_documents_with_notes', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('DIRECTEUR', 'print_folder_doc', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('DIRECTEUR', 'include_folders_and_followed_resources_perimeter', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('DIRECTEUR', 'add_links', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESPONSABLE', 'update_delete_attachments', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N1', 'update_delete_attachments', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('DIRECTEUR', 'update_delete_attachments', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('COURRIER', 'update_resources', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESP_COURRIER', 'update_resources', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N1', 'update_resources', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N1', 'config_avis_workflow_in_detail', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ASSISTSERV', 'add_links', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ASSISTDIR', 'use_mail_services', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ASSISTDIR', 'sendmail', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ASSISTDIR', 'view_doc_history', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ASSISTDIR', 'view_full_history', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ASSISTDIR', 'update_diffusion_indexing', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ASSISTDIR', 'update_diffusion_process', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESPONSABLE', 'update_contacts', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ASSISTDIR', 'update_diffusion_details', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'admin_alfresco', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'admin_email_server', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'view_history_batch', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'admin_notif', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'admin_search', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'admin_templates', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'admin_listmodels', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'admin_attachments', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'admin_custom_fields', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'manage_entities', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'admin_indexing_models', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'admin_parameters', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'admin_baskets', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'admin_docservers', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'admin_groups', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'admin_shippings', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'admin_priorities', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'admin_status', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'update_status_mail', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESP_COURRIER', 'view_confidential_contact_advanced', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ASSISTSERV', 'sendmail', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ASSISTSERV', 'use_mail_services', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ASSISTSERV', 'view_doc_history', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ASSISTDIR', 'view_documents_with_notes', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ASSISTDIR', 'config_visa_workflow', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ASSISTDIR', 'config_visa_workflow_in_detail', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ASSISTDIR', 'visa_documents', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ASSISTDGS', 'print_folder_doc', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('COURRIER', 'admin_architecture', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ASSISTSERV', 'include_folders_and_followed_resources_perimeter', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ASSISTDGS', 'view_technical_infos', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ASSISTDGS', 'view_documents_with_notes', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'admin_users', '{"groups": [5, 6, 12, 7, 8, 11, 14, 4, 1, 3, 2, 13, 28, 25, 27, 26, 29, 21, 24, 20]}');
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'avis_documents', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'config_avis_workflow', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'config_avis_workflow_in_detail', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('MAARCHTOGEC', 'include_folders_and_followed_resources_perimeter', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('MAARCHTOGEC', 'manage_numeric_package', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'include_folders_and_followed_resources_perimeter', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N1', 'manage_personal_data', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'entities_print_sep_mlb', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'adv_search_mlb', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('MAIRE', 'adv_search_mlb', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('MAIRE', 'include_folders_and_followed_resources_perimeter', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('MAIRE', 'avis_documents', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('MAIRE', 'sign_document', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('MAIRE', 'visa_documents', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('MAIRE', 'update_diffusion_indexing', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('MAIRE', 'update_diffusion_process', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('MAIRE', 'update_diffusion_details', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('MAIRE', 'view_doc_history', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('MAIRE', 'view_full_history', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('MAIRE', 'use_mail_services', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('MAIRE', 'sendmail', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('MAIRE', 'update_contacts', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('MAIRE', 'create_contacts', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('MAIRE', 'add_links', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('AGENT', 'avis_documents', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('COURRIER', 'admin_contacts', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('COURRIER', 'view_confidential_contact', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('COURRIER', 'update_diffusion_process', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'admin_contacts', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'admin_architecture', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'manage_entities', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'view_history', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'admin_notif', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'update_status_mail', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'add_correspondent_in_shared_groups_on_profile', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'add_links', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'create_public_indexing_models', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'create_contacts', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'manage_tags_application', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'update_contacts', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'print_folder_doc', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'view_documents_with_notes', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'view_technical_infos', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'config_visa_workflow', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'config_visa_workflow_in_detail', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'modify_visa_in_signatureBook', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'sendmail', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'use_mail_services', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'update_diffusion_indexing', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'update_diffusion_process', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'update_diffusion_details', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'admin_contacts', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('DGS', 'add_links', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('DGS', 'include_folders_and_followed_resources_perimeter', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('DGS', 'print_folder_doc', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('DGS', 'view_documents_with_notes', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('DGS', 'avis_documents', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('DGS', 'visa_documents', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('DGS', 'sign_document', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('DGS', 'modify_visa_in_signatureBook', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('DGS', 'config_visa_workflow_in_detail', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('DGS', 'config_visa_workflow', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('DGS', 'sendmail', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('DGS', 'use_mail_services', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('DGS', 'view_doc_history', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('DGS', 'view_full_history', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('DGS', 'update_diffusion_indexing', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('DGS', 'update_diffusion_process', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('DGS', 'update_diffusion_details', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESP_COURRIER', 'config_visa_workflow', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESP_COURRIER', 'config_visa_workflow_in_detail', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ASSISTDGS', 'update_delete_attachments', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ASSISTSERV', 'update_delete_attachments', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'update_delete_attachments', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('DGS', 'update_delete_attachments', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N1', 'admin_users', '{"groups": [5, 28, 25, 27, 26, 12, 29, 21, 7, 24, 8, 14, 4, 1, 20, 3, 2]}');
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESP_COURRIER', 'update_delete_attachments', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('MAIRE', 'update_resources', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('DGS', 'update_resources', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('AGENT', 'update_contacts', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N1', 'admin_groups', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESP_COURRIER', 'modify_visa_in_signatureBook', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('DGS', 'adv_search_mlb', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESP_COURRIER', 'admin', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N1', 'admin_custom_fields', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESP_COURRIER', 'admin_contacts', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('REFERENT', 'admin', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('REFERENT', 'adv_search_mlb', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('REFERENT', 'admin_templates', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('AGENT', 'config_visa_workflow', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('REFERENT', 'add_correspondent_in_shared_groups_on_profile', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N1', 'admin_indexing_models', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('REFERENT', 'add_links', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('REFERENT', 'create_public_indexing_models', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('REFERENT', 'include_folders_and_followed_resources_perimeter', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('REFERENT', 'print_folder_doc', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('REFERENT', 'view_technical_infos', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('REFERENT', 'view_documents_with_notes', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('REFERENT', 'avis_documents', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('REFERENT', 'config_avis_workflow', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('REFERENT', 'config_avis_workflow_in_detail', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('REFERENT', 'config_visa_workflow', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('REFERENT', 'config_visa_workflow_in_detail', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('REFERENT', 'modify_visa_in_signatureBook', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('REFERENT', 'visa_documents', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('REFERENT', 'sign_document', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('REFERENT', 'use_mail_services', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('REFERENT', 'sendmail', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('REFERENT', 'view_full_history', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('REFERENT', 'view_doc_history', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('REFERENT', 'update_diffusion_indexing', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('REFERENT', 'update_diffusion_process', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('REFERENT', 'update_diffusion_details', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESPONSABLE', 'config_visa_workflow', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('AGENT', 'update_diffusion_except_recipient_details', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('AGENT', 'update_diffusion_except_recipient_process', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N1', 'admin_search_folders', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESPONSABLE', 'update_diffusion_except_recipient_process', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESPONSABLE', 'update_diffusion_except_recipient_details', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESP_COURRIER', 'add_correspondent_in_shared_groups_on_profile', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESP_COURRIER', 'create_public_indexing_models', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESP_COURRIER', 'view_technical_infos', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('RESP_COURRIER', 'view_confidential_contact', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N1', 'admin_organization_email_signatures', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N1', 'admin_search', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N1', 'create_public_indexing_models', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N1', 'modify_visa_in_signatureBook', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'admin_actions', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'admin_groups', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ASSISTDGS', 'modify_visa_in_signatureBook', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'admin_users', '{"groups": [6, 28, 25, 27, 26, 12, 29, 21, 7, 24, 8, 14, 4, 1, 20, 3, 2, 5]}');
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ASSISTDGS', 'config_visa_workflow_in_detail', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'admin_shippings', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'admin_email_server', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'admin_search_folders', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'admin_organization_email_signatures', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'admin_search', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'admin_listmodels', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'admin_baskets', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'admin_custom_fields', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'view_history_batch', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'admin_registered_mail', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'admin_priorities', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'admin_status', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'admin_indexing_models', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'config_avis_workflow', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'config_avis_workflow_in_detail', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'admin_search_contacts', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'view_contacts', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'admin_search_folders', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'admin_organization_email_signatures', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('DGS', 'admin_search_contacts', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('DGS', 'update_contacts', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('COURRIER', 'admin_search_contacts', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ASSISTDGS', 'config_visa_workflow', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ASSISTDIR', 'add_links', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ASSISTDIR', 'include_folders_and_followed_resources_perimeter', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('DIRECTEUR', 'visa_documents', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('DIRECTEUR', 'sign_document', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('DIRECTEUR', 'sendmail', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('DIRECTEUR', 'use_mail_services', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('DIRECTEUR', 'view_doc_history', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('DIRECTEUR', 'update_diffusion_indexing', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('COURRIER', 'view_history', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ASSISTDIR', 'print_folder_doc', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ASSISTDGS', 'add_links', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ASSISTSERV', 'print_folder_doc', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ASSISTSERV', 'view_documents_with_notes', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ASSISTSERV', 'config_visa_workflow', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ASSISTSERV', 'config_visa_workflow_in_detail', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ASSISTSERV', 'visa_documents', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('AGENT', 'view_contacts', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('COURRIER', 'view_personal_data', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('COURRIER', 'manage_personal_data', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('COURRIER', 'update_delete_attachments', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('AGENT', 'update_delete_attachments', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('WEBSERVICE', 'update_delete_attachments', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('CHEF', 'update_delete_attachments', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('REFERENT', 'update_delete_attachments', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ASSISTDIR', 'update_delete_attachments', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('ADMINISTRATEUR_N2', 'update_resources', NULL);
INSERT INTO usergroups_services (group_id, service_id, parameters) VALUES ('REFERENT', 'update_resources', NULL);

-- Déploiement MEM
TRUNCATE TABLE users;
TRUNCATE TABLE users_entities;
TRUNCATE TABLE usergroup_content;
ALTER SEQUENCE users_id_seq RESTART WITH 1;
DELETE FROM users WHERE "user_id"='ws_opencapture';
INSERT INTO users ("id", "user_id", "password", "firstname", "lastname", "phone", "mail", "initials", "preferences", "status", "password_modification_date", "mode", "refresh_token", "reset_token", "failed_authentication", "locked_until", "authorized_api", "external_id", "feature_tour") VALUES (2, 'ws_opencapture', '$2y$10$VMNYgfze7obcdBV1CgLGnuSojGHnDWKwuAAy8DGAXxIyTj4nvUIke', 'Open Capture', 'Compte de web services ', NULL, 'ws_opencapture@edissyum.com', NULL, '{"documentEdition": "onlyoffice"}', 'OK', '2021-12-21 17:05:42.735467', 'rest', '[]', NULL, 0, NULL, '[]', '{}', '[]'); -- EDISSYUM - AMO01 Changer le mot de passe par défaut
DELETE FROM users WHERE "user_id"='superadmin';
INSERT INTO users ("id", "user_id", "password", "firstname", "lastname", "phone", "mail", "initials", "preferences", "status", "password_modification_date", "mode", "refresh_token", "reset_token", "failed_authentication", "locked_until", "authorized_api", "external_id", "feature_tour") VALUES (1, 'superadmin', '$2y$10$toRMXMZVU9o.k.YTC4Pu5ehckioTrZvE7fzYaZpnbkjLefYlIiSQ.', 'Admin', 'SUPER', '0147245159', 'contact@edissyum.com', NULL, '{"documentEdition": "onlyoffice"}', 'OK', '2021-03-24 10:17:02.66594', 'root_invisible', '[]', NULL, 0, NULL, '[]', '{}', '["welcome", "email", "notification"]');
DELETE FROM users_entities WHERE "user_id"=2 AND "entity_id"='VILLE';
INSERT INTO users_entities ("user_id", "entity_id", "user_role", "primary_entity") VALUES (2, 'VILLE', '', 'Y');
DELETE FROM users_entities WHERE "user_id"=1 AND "entity_id"='VILLE';
INSERT INTO users_entities ("user_id", "entity_id", "user_role", "primary_entity") VALUES (1, 'VILLE', '', 'Y');
DELETE FROM usergroup_content WHERE "user_id"=2;
INSERT INTO usergroup_content ("user_id", "group_id", "role") VALUES (2, 13, NULL);

DELETE FROM users WHERE user_id = 'jsparrow';
DELETE FROM users_entities WHERE user_id =3;
INSERT INTO users (id, user_id, password, firstname, lastname, mail, status, mode, preferences) VALUES (3, 'jsparrow', '$2y$10$VMNYgfze7obcdBV1CgLGnuSojGHnDWKwuAAy8DGAXxIyTj4nvUIke', 'Jack', 'Sparrow', 'jsparrow@mem-en-provence.fr', 'OK', 'standard', '{"documentEdition" : "onlyoffice"}'); -- EDISSYUM - AMO01 Changer le mot de passe par défaut
INSERT INTO users_entities (user_id, entity_id, user_role, primary_entity) VALUES ('3', 'VILLE', '', 'Y');
DELETE FROM usergroup_content WHERE user_id =3;
INSERT INTO usergroup_content (user_id, group_id, role) VALUES
                                                            (3, 8, ''),
                                                            (3, 14, '')
;
DELETE FROM users WHERE user_id = 'tsparrow';
DELETE FROM users_entities WHERE user_id =4;
INSERT INTO users (id, user_id, password, firstname, lastname, mail, status, mode, preferences) VALUES (4, 'tsparrow', '$2y$10$VMNYgfze7obcdBV1CgLGnuSojGHnDWKwuAAy8DGAXxIyTj4nvUIke', 'Trinité', 'Sparrow', 'tsparrow@mem-en-provence.fr', 'OK', 'standard', '{"documentEdition" : "onlyoffice"}'); -- EDISSYUM - AMO01 Changer le mot de passe par défaut
INSERT INTO users_entities (user_id, entity_id, user_role, primary_entity) VALUES ('4', 'CAB', '', 'Y');
DELETE FROM usergroup_content WHERE user_id =4;
INSERT INTO usergroup_content (user_id, group_id, role) VALUES (4, 4, '');
DELETE FROM users WHERE user_id = 'fbelhami';
DELETE FROM users_entities WHERE user_id =5;
INSERT INTO users (id, user_id, password, firstname, lastname, mail, status, mode, preferences) VALUES (5, 'fbelhami', '$2y$10$VMNYgfze7obcdBV1CgLGnuSojGHnDWKwuAAy8DGAXxIyTj4nvUIke', 'Ferdinand', 'Belhami', 'fbelami@mem-en-provence.fr', 'OK', 'standard', '{"documentEdition" : "onlyoffice"}'); -- EDISSYUM - AMO01 Changer le mot de passe par défaut
INSERT INTO users_entities (user_id, entity_id, user_role, primary_entity) VALUES ('5', 'DGS', '', 'Y');
DELETE FROM usergroup_content WHERE user_id =5;
INSERT INTO usergroup_content (user_id, group_id, role) VALUES (5, 4, '');
DELETE FROM users WHERE user_id = 'hsolo';
DELETE FROM users_entities WHERE user_id =6;
INSERT INTO users (id, user_id, password, firstname, lastname, mail, status, mode, preferences) VALUES (6, 'hsolo', '$2y$10$VMNYgfze7obcdBV1CgLGnuSojGHnDWKwuAAy8DGAXxIyTj4nvUIke', 'Han', 'Solo', 'hsolo@mem-en-provence.fr', 'OK', 'standard', '{"documentEdition" : "onlyoffice"}'); -- EDISSYUM - AMO01 Changer le mot de passe par défaut
INSERT INTO users_entities (user_id, entity_id, user_role, primary_entity) VALUES ('6', 'ELU', '', 'Y');
DELETE FROM usergroup_content WHERE user_id =6;
INSERT INTO usergroup_content (user_id, group_id, role) VALUES (6, 4, '');
DELETE FROM users WHERE user_id = 'maddams';
DELETE FROM users_entities WHERE user_id =7;
INSERT INTO users (id, user_id, password, firstname, lastname, mail, status, mode, preferences) VALUES (7, 'maddams', '$2y$10$VMNYgfze7obcdBV1CgLGnuSojGHnDWKwuAAy8DGAXxIyTj4nvUIke', 'Mercredi', 'Addams', 'maddams@mem-en-provence.fr', 'OK', 'standard', '{"documentEdition" : "onlyoffice"}'); -- EDISSYUM - AMO01 Changer le mot de passe par défaut
INSERT INTO users_entities (user_id, entity_id, user_role, primary_entity) VALUES ('7', 'DCOM', '', 'Y');
DELETE FROM usergroup_content WHERE user_id =7;
INSERT INTO usergroup_content (user_id, group_id, role) VALUES (7, 4, '');
DELETE FROM users WHERE user_id = 'pmortez';
DELETE FROM users_entities WHERE user_id =8;
INSERT INTO users (id, user_id, password, firstname, lastname, mail, status, mode, preferences) VALUES (8, 'pmortez', '$2y$10$VMNYgfze7obcdBV1CgLGnuSojGHnDWKwuAAy8DGAXxIyTj4nvUIke', 'Pierre', 'Mortez', 'pmortez@mem-en-provence.fr', 'OK', 'standard', '{"documentEdition" : "onlyoffice"}'); -- EDISSYUM - AMO01 Changer le mot de passe par défaut
INSERT INTO users_entities (user_id, entity_id, user_role, primary_entity) VALUES ('8', 'CCAS', '', 'Y');
DELETE FROM usergroup_content WHERE user_id =8;
INSERT INTO usergroup_content (user_id, group_id, role) VALUES (8, 4, '');
DELETE FROM users WHERE user_id = 'docean';
DELETE FROM users_entities WHERE user_id =9;
INSERT INTO users (id, user_id, password, firstname, lastname, mail, status, mode, preferences) VALUES (9, 'docean', '$2y$10$VMNYgfze7obcdBV1CgLGnuSojGHnDWKwuAAy8DGAXxIyTj4nvUIke', 'Danny', 'Ocean', 'docean@mem-en-provence.fr', 'OK', 'standard', '{"documentEdition" : "onlyoffice"}'); -- EDISSYUM - AMO01 Changer le mot de passe par défaut
INSERT INTO users_entities (user_id, entity_id, user_role, primary_entity) VALUES ('9', 'PRI', '', 'Y');
DELETE FROM usergroup_content WHERE user_id =9;
INSERT INTO usergroup_content (user_id, group_id, role) VALUES (9, 4, '');
DELETE FROM users WHERE user_id = 'jdalton';
DELETE FROM users_entities WHERE user_id =10;
INSERT INTO users (id, user_id, password, firstname, lastname, mail, status, mode, preferences) VALUES (10, 'jdalton', '$2y$10$VMNYgfze7obcdBV1CgLGnuSojGHnDWKwuAAy8DGAXxIyTj4nvUIke', 'Joe', 'Dalton', 'jdalton@mem-en-provence.fr', 'OK', 'standard', '{"documentEdition" : "onlyoffice"}'); -- EDISSYUM - AMO01 Changer le mot de passe par défaut
INSERT INTO users_entities (user_id, entity_id, user_role, primary_entity) VALUES ('10', 'DAFJ', '', 'Y');
DELETE FROM usergroup_content WHERE user_id =10;
INSERT INTO usergroup_content (user_id, group_id, role) VALUES (10, 4, '');
DELETE FROM users WHERE user_id = 'ebrockovich';
DELETE FROM users_entities WHERE user_id =11;
INSERT INTO users (id, user_id, password, firstname, lastname, mail, status, mode, preferences) VALUES (11, 'ebrockovich', '$2y$10$VMNYgfze7obcdBV1CgLGnuSojGHnDWKwuAAy8DGAXxIyTj4nvUIke', 'Erin', 'Brockovich', 'ebrockovich@mem-en-provence.fr', 'OK', 'standard', '{"documentEdition" : "onlyoffice"}'); -- EDISSYUM - AMO01 Changer le mot de passe par défaut
INSERT INTO users_entities (user_id, entity_id, user_role, primary_entity) VALUES ('11', 'DAFJ', '', 'Y');
DELETE FROM usergroup_content WHERE user_id =11;
INSERT INTO usergroup_content (user_id, group_id, role) VALUES (11, 2, '');
DELETE FROM users WHERE user_id = 'bgates';
DELETE FROM users_entities WHERE user_id =12;
INSERT INTO users (id, user_id, password, firstname, lastname, mail, status, mode, preferences) VALUES (12, 'bgates', '$2y$10$VMNYgfze7obcdBV1CgLGnuSojGHnDWKwuAAy8DGAXxIyTj4nvUIke', 'Benjamin', 'Gates', 'bgates@mem-en-provence.fr', 'OK', 'standard', '{"documentEdition" : "onlyoffice"}'); -- EDISSYUM - AMO01 Changer le mot de passe par défaut
INSERT INTO users_entities (user_id, entity_id, user_role, primary_entity) VALUES ('12', 'ARC', '', 'Y');
DELETE FROM usergroup_content WHERE user_id =12;
INSERT INTO usergroup_content (user_id, group_id, role) VALUES (12, 4, '');
DELETE FROM users WHERE user_id = 'abailleul';
DELETE FROM users_entities WHERE user_id =13;
INSERT INTO users (id, user_id, password, firstname, lastname, mail, status, mode, preferences) VALUES (13, 'abailleul', '$2y$10$VMNYgfze7obcdBV1CgLGnuSojGHnDWKwuAAy8DGAXxIyTj4nvUIke', 'Antoire', 'Bailleul', 'abailleul@mem-en-provence.fr', 'OK', 'standard', '{"documentEdition" : "onlyoffice"}'); -- EDISSYUM - AMO01 Changer le mot de passe par défaut
INSERT INTO users_entities (user_id, entity_id, user_role, primary_entity) VALUES ('13', 'SGC', '', 'Y');
DELETE FROM usergroup_content WHERE user_id =13;
INSERT INTO usergroup_content (user_id, group_id, role) VALUES (13, 4, '');
DELETE FROM users WHERE user_id = 'fmartin';
DELETE FROM users_entities WHERE user_id =14;
INSERT INTO users (id, user_id, password, firstname, lastname, mail, status, mode, preferences) VALUES (14, 'fmartin', '$2y$10$VMNYgfze7obcdBV1CgLGnuSojGHnDWKwuAAy8DGAXxIyTj4nvUIke', 'Franck', 'Martin', 'fmartin@mem-en-provence.fr', 'OK', 'standard', '{"documentEdition" : "onlyoffice"}'); -- EDISSYUM - AMO01 Changer le mot de passe par défaut
INSERT INTO users_entities (user_id, entity_id, user_role, primary_entity) VALUES ('14', 'SGC', '', 'Y');
DELETE FROM usergroup_content WHERE user_id =14;
INSERT INTO usergroup_content (user_id, group_id, role) VALUES (14, 2, '');
INSERT INTO usergroup_content (user_id, group_id, role) VALUES (14, 1, '');
DELETE FROM users WHERE user_id = 'mpriestly';
DELETE FROM users_entities WHERE user_id =15;
INSERT INTO users (id, user_id, password, firstname, lastname, mail, status, mode, preferences) VALUES (15, 'mpriestly', '$2y$10$VMNYgfze7obcdBV1CgLGnuSojGHnDWKwuAAy8DGAXxIyTj4nvUIke', 'Miranda', 'Priestly', 'mpriestly@mem-en-provence.fr', 'OK', 'standard', '{"documentEdition" : "onlyoffice"}'); -- EDISSYUM - AMO01 Changer le mot de passe par défaut
INSERT INTO users_entities (user_id, entity_id, user_role, primary_entity) VALUES ('15', 'DRH', '', 'Y');
DELETE FROM usergroup_content WHERE user_id =15;
INSERT INTO usergroup_content (user_id, group_id, role) VALUES (15, 4, '');
DELETE FROM users WHERE user_id = 'mlando';
DELETE FROM users_entities WHERE user_id =16;
INSERT INTO users (id, user_id, password, firstname, lastname, mail, status, mode, preferences) VALUES (16, 'mlando', '$2y$10$VMNYgfze7obcdBV1CgLGnuSojGHnDWKwuAAy8DGAXxIyTj4nvUIke', 'Mathilda', 'Lando', 'mlando@mem-en-provence.fr', 'OK', 'standard', '{"documentEdition" : "onlyoffice"}'); -- EDISSYUM - AMO01 Changer le mot de passe par défaut
INSERT INTO users_entities (user_id, entity_id, user_role, primary_entity) VALUES ('16', 'DRH', '', 'Y');
DELETE FROM usergroup_content WHERE user_id =16;
INSERT INTO usergroup_content (user_id, group_id, role) VALUES (16, 2, '');
DELETE FROM users WHERE user_id = 'pbrochant';
DELETE FROM users_entities WHERE user_id =17;
INSERT INTO users (id, user_id, password, firstname, lastname, mail, status, mode, preferences) VALUES (17, 'pbrochant', '$2y$10$VMNYgfze7obcdBV1CgLGnuSojGHnDWKwuAAy8DGAXxIyTj4nvUIke', 'Pierre', 'Brochant', 'pbrochant@mem-en-provence.fr', 'OK', 'standard', '{"documentEdition" : "onlyoffice"}'); -- EDISSYUM - AMO01 Changer le mot de passe par défaut
INSERT INTO users_entities (user_id, entity_id, user_role, primary_entity) VALUES ('17', 'PAGP', '', 'Y');
DELETE FROM usergroup_content WHERE user_id =17;
INSERT INTO usergroup_content (user_id, group_id, role) VALUES (17, 4, '');
DELETE FROM users WHERE user_id = 'fabagnale';
DELETE FROM users_entities WHERE user_id =18;
INSERT INTO users (id, user_id, password, firstname, lastname, mail, status, mode, preferences) VALUES (18, 'fabagnale', '$2y$10$VMNYgfze7obcdBV1CgLGnuSojGHnDWKwuAAy8DGAXxIyTj4nvUIke', 'Franck', 'Abagnale', 'fabagnale@mem-en-provence.fr', 'OK', 'standard', '{"documentEdition" : "onlyoffice"}'); -- EDISSYUM - AMO01 Changer le mot de passe par défaut
INSERT INTO users_entities (user_id, entity_id, user_role, primary_entity) VALUES ('18', 'EC', '', 'Y');
DELETE FROM usergroup_content WHERE user_id =18;
INSERT INTO usergroup_content (user_id, group_id, role) VALUES (18, 4, '');
DELETE FROM users WHERE user_id = 'ldaley';
DELETE FROM users_entities WHERE user_id =19;
INSERT INTO users (id, user_id, password, firstname, lastname, mail, status, mode, preferences) VALUES (19, 'ldaley', '$2y$10$VMNYgfze7obcdBV1CgLGnuSojGHnDWKwuAAy8DGAXxIyTj4nvUIke', 'Larry', 'Daley', 'ldaley@mem-en-provence.fr', 'OK', 'standard', '{"documentEdition" : "onlyoffice"}'); -- EDISSYUM - AMO01 Changer le mot de passe par défaut
INSERT INTO users_entities (user_id, entity_id, user_role, primary_entity) VALUES ('19', 'SCUL', '', 'Y');
DELETE FROM usergroup_content WHERE user_id =19;
INSERT INTO usergroup_content (user_id, group_id, role) VALUES (19, 4, '');
DELETE FROM users WHERE user_id = 'vward';
DELETE FROM users_entities WHERE user_id =20;
INSERT INTO users (id, user_id, password, firstname, lastname, mail, status, mode, preferences) VALUES (20, 'vward', '$2y$10$VMNYgfze7obcdBV1CgLGnuSojGHnDWKwuAAy8DGAXxIyTj4nvUIke', 'Vivian', 'Ward', 'vward@mem-en-provence.fr', 'OK', 'standard', '{"documentEdition" : "onlyoffice"}'); -- EDISSYUM - AMO01 Changer le mot de passe par défaut
INSERT INTO users_entities (user_id, entity_id, user_role, primary_entity) VALUES ('20', 'SARU', '', 'Y');
DELETE FROM usergroup_content WHERE user_id =20;
INSERT INTO usergroup_content (user_id, group_id, role) VALUES (20, 4, '');
DELETE FROM users WHERE user_id = 'glatouche';
DELETE FROM users_entities WHERE user_id =21;
INSERT INTO users (id, user_id, password, firstname, lastname, mail, status, mode, preferences) VALUES (21, 'glatouche', '$2y$10$VMNYgfze7obcdBV1CgLGnuSojGHnDWKwuAAy8DGAXxIyTj4nvUIke', 'Gustave', 'Latouche', 'glatouche@mem-en-provence.fr', 'OK', 'standard', '{"documentEdition" : "onlyoffice"}'); -- EDISSYUM - AMO01 Changer le mot de passe par défaut
INSERT INTO users_entities (user_id, entity_id, user_role, primary_entity) VALUES ('21', 'SSEJ', '', 'Y');
DELETE FROM usergroup_content WHERE user_id =21;
INSERT INTO usergroup_content (user_id, group_id, role) VALUES (21, 4, '');
DELETE FROM users WHERE user_id = 'emolinari';
DELETE FROM users_entities WHERE user_id =22;
INSERT INTO users (id, user_id, password, firstname, lastname, mail, status, mode, preferences) VALUES (22, 'emolinari', '$2y$10$VMNYgfze7obcdBV1CgLGnuSojGHnDWKwuAAy8DGAXxIyTj4nvUIke', 'Enzo', 'Molinari', 'emolinari@mem-en-provence.fr', 'OK', 'standard', '{"documentEdition" : "onlyoffice"}'); -- EDISSYUM - AMO01 Changer le mot de passe par défaut
INSERT INTO users_entities (user_id, entity_id, user_role, primary_entity) VALUES ('22', 'SSPO', '', 'Y');
DELETE FROM usergroup_content WHERE user_id =22;
INSERT INTO usergroup_content (user_id, group_id, role) VALUES (22, 4, '');
DELETE FROM users WHERE user_id = 'pchirac';
DELETE FROM users_entities WHERE user_id =23;
INSERT INTO users (id, user_id, password, firstname, lastname, mail, status, mode, preferences) VALUES (23, 'pchirac', '$2y$10$VMNYgfze7obcdBV1CgLGnuSojGHnDWKwuAAy8DGAXxIyTj4nvUIke', 'Patrick', 'Chirac', 'pchirac@mem-en-provence.fr', 'OK', 'standard', '{"documentEdition" : "onlyoffice"}'); -- EDISSYUM - AMO01 Changer le mot de passe par défaut
INSERT INTO users_entities (user_id, entity_id, user_role, primary_entity) VALUES ('23', 'SVA', '', 'Y');
DELETE FROM usergroup_content WHERE user_id =23;
INSERT INTO usergroup_content (user_id, group_id, role) VALUES (23, 4, '');
DELETE FROM users WHERE user_id = 'abennett';
DELETE FROM users_entities WHERE user_id =24;
INSERT INTO users (id, user_id, password, firstname, lastname, mail, status, mode, preferences) VALUES (24, 'abennett', '$2y$10$VMNYgfze7obcdBV1CgLGnuSojGHnDWKwuAAy8DGAXxIyTj4nvUIke', 'Angela', 'Bennett', 'abennett@mem-en-provence.fr', 'OK', 'standard', '{"documentEdition" : "onlyoffice"}'); -- EDISSYUM - AMO01 Changer le mot de passe par défaut
INSERT INTO users_entities (user_id, entity_id, user_role, primary_entity) VALUES ('24', 'DSIT', '', 'Y');
DELETE FROM usergroup_content WHERE user_id =24;
INSERT INTO usergroup_content (user_id, group_id, role) VALUES (24, 4, '');
DELETE FROM users WHERE user_id = 'tanderson';
DELETE FROM users_entities WHERE user_id =25;
INSERT INTO users (id, user_id, password, firstname, lastname, mail, status, mode, preferences) VALUES (25, 'tanderson', '$2y$10$VMNYgfze7obcdBV1CgLGnuSojGHnDWKwuAAy8DGAXxIyTj4nvUIke', 'Thomas', 'Anderson', 'tanderson@mem-en-provence.fr', 'OK', 'standard', '{"documentEdition" : "onlyoffice"}'); -- EDISSYUM - AMO01 Changer le mot de passe par défaut
INSERT INTO users_entities (user_id, entity_id, user_role, primary_entity) VALUES ('25', 'DSIT', '', 'Y');
DELETE FROM usergroup_content WHERE user_id =25;
INSERT INTO usergroup_content (user_id, group_id, role) VALUES (25, 2, '');
DELETE FROM users WHERE user_id = 'ggilbert';
DELETE FROM users_entities WHERE user_id =26;
INSERT INTO users (id, user_id, password, firstname, lastname, mail, status, mode, preferences) VALUES (26, 'ggilbert', '$2y$10$VMNYgfze7obcdBV1CgLGnuSojGHnDWKwuAAy8DGAXxIyTj4nvUIke', 'Gerard', 'Gilbert', 'gglibert@mem-en-provence.fr', 'OK', 'standard', '{"documentEdition" : "onlyoffice"}'); -- EDISSYUM - AMO01 Changer le mot de passe par défaut
INSERT INTO users_entities (user_id, entity_id, user_role, primary_entity) VALUES ('26', 'DPM', '', 'Y');
DELETE FROM usergroup_content WHERE user_id =26;
INSERT INTO usergroup_content (user_id, group_id, role) VALUES (26, 4, '');
DELETE FROM users WHERE user_id = 'fpignon';
DELETE FROM users_entities WHERE user_id =27;
INSERT INTO users (id, user_id, password, firstname, lastname, mail, status, mode, preferences) VALUES (27, 'fpignon', '$2y$10$VMNYgfze7obcdBV1CgLGnuSojGHnDWKwuAAy8DGAXxIyTj4nvUIke', 'Francois', 'Pignon', 'fpignon@mem-en-provence.fr', 'OK', 'standard', '{"documentEdition" : "onlyoffice"}'); -- EDISSYUM - AMO01 Changer le mot de passe par défaut
INSERT INTO users_entities (user_id, entity_id, user_role, primary_entity) VALUES ('27', 'PST', '', 'Y');
DELETE FROM usergroup_content WHERE user_id =27;
INSERT INTO usergroup_content (user_id, group_id, role) VALUES (27, 4, '');
DELETE FROM users WHERE user_id = 'nobis';
DELETE FROM users_entities WHERE user_id =28;
INSERT INTO users (id, user_id, password, firstname, lastname, mail, status, mode, preferences) VALUES (28, 'nobis', '$2y$10$VMNYgfze7obcdBV1CgLGnuSojGHnDWKwuAAy8DGAXxIyTj4nvUIke', 'Numer', 'Obis', 'nobis@mem-en-provence.fr', 'OK', 'standard', '{"documentEdition" : "onlyoffice"}'); -- EDISSYUM - AMO01 Changer le mot de passe par défaut
INSERT INTO users_entities (user_id, entity_id, user_role, primary_entity) VALUES ('28', 'URBA', '', 'Y');
DELETE FROM usergroup_content WHERE user_id =28;
INSERT INTO usergroup_content (user_id, group_id, role) VALUES (28, 4, '');
DELETE FROM users WHERE user_id = 'cgarcia';
DELETE FROM users_entities WHERE user_id =29;
INSERT INTO users (id, user_id, password, firstname, lastname, mail, status, mode, preferences) VALUES (29, 'cgarcia', '$2y$10$VMNYgfze7obcdBV1CgLGnuSojGHnDWKwuAAy8DGAXxIyTj4nvUIke', 'Christian', 'Garcia', 'cgarcia@mem-en-provence.fr', 'OK', 'standard', '{"documentEdition" : "onlyoffice"}'); -- EDISSYUM - AMO01 Changer le mot de passe par défaut
INSERT INTO users_entities (user_id, entity_id, user_role, primary_entity) VALUES ('29', 'ST', '', 'Y');
DELETE FROM usergroup_content WHERE user_id =29;
INSERT INTO usergroup_content (user_id, group_id, role) VALUES (29, 4, '');
DELETE FROM users WHERE user_id = 'glavergne';
DELETE FROM users_entities WHERE user_id =30;
INSERT INTO users (id, user_id, password, firstname, lastname, mail, status, mode, preferences) VALUES (30, 'glavergne', '$2y$10$VMNYgfze7obcdBV1CgLGnuSojGHnDWKwuAAy8DGAXxIyTj4nvUIke', 'Gilbert', 'Lavergne', 'glavergne@mem-en-provence.fr', 'OK', 'standard', '{"documentEdition" : "onlyoffice"}'); -- EDISSYUM - AMO01 Changer le mot de passe par défaut
INSERT INTO users_entities (user_id, entity_id, user_role, primary_entity) VALUES ('30', 'ST', '', 'Y');
DELETE FROM usergroup_content WHERE user_id =30;
INSERT INTO usergroup_content (user_id, group_id, role) VALUES (30, 2, '');


TRUNCATE TABLE entities;
ALTER SEQUENCE entities_id_seq RESTART WITH 1;
TRUNCATE TABLE list_templates;
TRUNCATE TABLE list_templates_items;
INSERT INTO entities (entity_id, entity_label, short_label, enabled, address_street, address_additional1, address_additional2, address_postcode, address_town, address_country, email, business_id, parent_entity_id, entity_type) VALUES ('VILLE', 'Ville de Mem en Provence', 'Ville de Mem en Provence', 'Y', '', '', '', '', '', '', '', '', '', 'Direction');
INSERT INTO list_templates (id, title, description, type, entity_id) VALUES (1, 'Ville de Mem en Provence', 'Ville de Mem en Provence', 'diffusionList', 1);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (1, 3, 'user', 'dest', 0);
INSERT INTO list_templates (id, title, description, type, entity_id) VALUES (2001, 'visa Ville de Mem en Provence', 'visa Ville de Mem en Provence', 'visaCircuit', 1);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2001, 3, 'user', 'sign', 0);
INSERT INTO entities (entity_id, entity_label, short_label, enabled, address_street, address_additional1, address_additional2, address_postcode, address_town, address_country, email, business_id, parent_entity_id, entity_type) VALUES ('CAB', 'Cabinet du maire', 'Cabinet du maire', 'Y', '', '', '', '', '', '', '', '', 'VILLE', 'Direction');
INSERT INTO list_templates (id, title, description, type, entity_id) VALUES (2, 'Cabinet du maire', 'Cabinet du maire', 'diffusionList', 2);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2, 4, 'user', 'dest', 0);
INSERT INTO list_templates (id, title, description, type, entity_id) VALUES (2002, 'visa Cabinet du maire', 'visa Cabinet du maire', 'visaCircuit', 2);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2002, 3, 'user', 'sign', 0);
INSERT INTO entities (entity_id, entity_label, short_label, enabled, address_street, address_additional1, address_additional2, address_postcode, address_town, address_country, email, business_id, parent_entity_id, entity_type) VALUES ('ELU', 'Bureau des Elus', 'Bureau des Elus', 'Y', '', '', '', '', '', '', '', '', 'CAB', 'Direction');
INSERT INTO list_templates (id, title, description, type, entity_id) VALUES (3, 'Bureau des Elus', 'Bureau des Elus', 'diffusionList', 3);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (3, 6, 'user', 'dest', 0);
INSERT INTO list_templates (id, title, description, type, entity_id) VALUES (2003, 'visa Bureau des Elus', 'visa Bureau des Elus', 'visaCircuit', 3);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2003, 4, 'user', 'visa', 0);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2003, 3, 'user', 'sign', 1);
INSERT INTO entities (entity_id, entity_label, short_label, enabled, address_street, address_additional1, address_additional2, address_postcode, address_town, address_country, email, business_id, parent_entity_id, entity_type) VALUES ('DCOM', 'Direction de la Communication', 'Direction de la Communication', 'Y', '', '', '', '', '', '', '', '', 'CAB', 'Direction');
INSERT INTO list_templates (id, title, description, type, entity_id) VALUES (4, 'Direction de la Communication', 'Direction de la Communication', 'diffusionList', 4);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (4, 7, 'user', 'dest', 0);
INSERT INTO list_templates (id, title, description, type, entity_id) VALUES (2004, 'visa Direction de la Communication', 'visa Direction de la Communication', 'visaCircuit', 4);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2004, 4, 'user', 'visa', 0);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2004, 3, 'user', 'sign', 1);
INSERT INTO entities (entity_id, entity_label, short_label, enabled, address_street, address_additional1, address_additional2, address_postcode, address_town, address_country, email, business_id, parent_entity_id, entity_type) VALUES ('DGS', 'Direction Générale des Services', 'Direction Générale des Services', 'Y', '', '', '', '', '', '', '', '', 'VILLE', 'Direction');
INSERT INTO list_templates (id, title, description, type, entity_id) VALUES (5, 'Direction Générale des Services', 'Direction Générale des Services', 'diffusionList', 5);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (5, 5, 'user', 'dest', 0);
INSERT INTO list_templates (id, title, description, type, entity_id) VALUES (2005, 'visa Direction Générale des Services', 'visa Direction Générale des Services', 'visaCircuit', 5);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2005, 5, 'user', 'visa', 0);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2005, 3, 'user', 'sign', 1);
INSERT INTO entities (entity_id, entity_label, short_label, enabled, address_street, address_additional1, address_additional2, address_postcode, address_town, address_country, email, business_id, parent_entity_id, entity_type) VALUES ('CCAS', 'CCAS', 'CCAS', 'Y', '', '', '', '', '', '', '', '', 'DGS', 'Direction');
INSERT INTO list_templates (id, title, description, type, entity_id) VALUES (6, 'CCAS', 'CCAS', 'diffusionList', 6);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (6, 8, 'user', 'dest', 0);
INSERT INTO list_templates (id, title, description, type, entity_id) VALUES (2006, 'visa CCAS', 'visa CCAS', 'visaCircuit', 6);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2006, 8, 'user', 'visa', 0);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2006, 3, 'user', 'sign', 1);
INSERT INTO entities (entity_id, entity_label, short_label, enabled, address_street, address_additional1, address_additional2, address_postcode, address_town, address_country, email, business_id, parent_entity_id, entity_type) VALUES ('PRI', 'Pôle Ressources Internes', 'Pôle Ressources Internes', 'Y', '', '', '', '', '', '', '', '', 'DGS', 'Direction');
INSERT INTO list_templates (id, title, description, type, entity_id) VALUES (7, 'Pôle Ressources Internes', 'Pôle Ressources Internes', 'diffusionList', 7);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (7, 9, 'user', 'dest', 0);
INSERT INTO list_templates (id, title, description, type, entity_id) VALUES (2007, 'visa Pôle Ressources Internes', 'visa Pôle Ressources Internes', 'visaCircuit', 7);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2007, 5, 'user', 'visa', 0);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2007, 3, 'user', 'sign', 1);
INSERT INTO entities (entity_id, entity_label, short_label, enabled, address_street, address_additional1, address_additional2, address_postcode, address_town, address_country, email, business_id, parent_entity_id, entity_type) VALUES ('DAFJ', 'Direction des Affaires Financières et Juridiques', 'Direction des Affaires Financières et Juridiques', 'Y', '', '', '', '', '', '', '', '', 'PRI', 'Direction');
INSERT INTO list_templates (id, title, description, type, entity_id) VALUES (8, 'Direction des Affaires Financières et Juridiques', 'Direction des Affaires Financières et Juridiques', 'diffusionList', 8);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (8, 10, 'user', 'dest', 0);
INSERT INTO list_templates (id, title, description, type, entity_id) VALUES (2008, 'visa Direction des Affaires Financières et Juridiques', 'visa Direction des Affaires Financières et Juridiques', 'visaCircuit', 8);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2008, 10, 'user', 'visa', 0);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2008, 9, 'user', 'visa', 1);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2008, 5, 'user', 'visa', 2);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2008, 3, 'user', 'sign', 3);
INSERT INTO entities (entity_id, entity_label, short_label, enabled, address_street, address_additional1, address_additional2, address_postcode, address_town, address_country, email, business_id, parent_entity_id, entity_type) VALUES ('ARC', 'Services des archives', 'Services des archives', 'Y', '', '', '', '', '', '', '', '', 'PRI', 'Direction');
INSERT INTO list_templates (id, title, description, type, entity_id) VALUES (9, 'Services des archives', 'Services des archives', 'diffusionList', 9);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (9, 12, 'user', 'dest', 0);
INSERT INTO list_templates (id, title, description, type, entity_id) VALUES (2009, 'visa Services des archives', 'visa Services des archives', 'visaCircuit', 9);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2009, 9, 'user', 'visa', 0);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2009, 5, 'user', 'visa', 1);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2009, 3, 'user', 'sign', 2);
INSERT INTO entities (entity_id, entity_label, short_label, enabled, address_street, address_additional1, address_additional2, address_postcode, address_town, address_country, email, business_id, parent_entity_id, entity_type) VALUES ('DSIT', 'Direction des systèmes d''Information et des Télécommunications', 'Direction des systèmes d''Information et des Téléc', 'Y', '', '', '', '', '', '', '', '', 'PRI', 'Direction');
INSERT INTO list_templates (id, title, description, type, entity_id) VALUES (10, 'Direction des systèmes d''Information et des Téléc', 'Direction des systèmes d''Information et des Télécommunications', 'diffusionList', 10);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (10, 24, 'user', 'dest', 0);
INSERT INTO list_templates (id, title, description, type, entity_id) VALUES (2010, 'visa Direction des systèmes d''Information et des Téléc', 'visa Direction des systèmes d''Information et des Télécommunications', 'visaCircuit', 10);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2010, 24, 'user', 'visa', 0);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2010, 9, 'user', 'visa', 1);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2010, 5, 'user', 'visa', 2);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2010, 3, 'user', 'sign', 3);
INSERT INTO entities (entity_id, entity_label, short_label, enabled, address_street, address_additional1, address_additional2, address_postcode, address_town, address_country, email, business_id, parent_entity_id, entity_type) VALUES ('DRH', 'Direction des Richesses Humaines', 'Direction des Richesses Humaines', 'Y', '', '', '', '', '', '', '', '', 'PRI', 'Direction');
INSERT INTO list_templates (id, title, description, type, entity_id) VALUES (11, 'Direction des Richesses Humaines', 'Direction des Richesses Humaines', 'diffusionList', 11);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (11, 15, 'user', 'dest', 0);
INSERT INTO list_templates (id, title, description, type, entity_id) VALUES (2011, 'visa Direction des Richesses Humaines', 'visa Direction des Richesses Humaines', 'visaCircuit', 11);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2011, 15, 'user', 'visa', 0);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2011, 9, 'user', 'visa', 1);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2011, 5, 'user', 'visa', 2);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2011, 3, 'user', 'sign', 3);
INSERT INTO entities (entity_id, entity_label, short_label, enabled, address_street, address_additional1, address_additional2, address_postcode, address_town, address_country, email, business_id, parent_entity_id, entity_type) VALUES ('PAGP', 'Pôle Administration Générale et Service à la Population', 'Pôle Administration Générale et Service à la Popu', 'Y', '', '', '', '', '', '', '', '', 'DGS', 'Direction');
INSERT INTO list_templates (id, title, description, type, entity_id) VALUES (12, 'Pôle Administration Générale et Service à la Popu', 'Pôle Administration Générale et Service à la Population', 'diffusionList', 12);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (12, 17, 'user', 'dest', 0);
INSERT INTO list_templates (id, title, description, type, entity_id) VALUES (2012, 'visa Pôle Administration Générale et Service à la Popu', 'visa Pôle Administration Générale et Service à la Population', 'visaCircuit', 12);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2012, 5, 'user', 'visa', 0);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2012, 3, 'user', 'sign', 1);
INSERT INTO entities (entity_id, entity_label, short_label, enabled, address_street, address_additional1, address_additional2, address_postcode, address_town, address_country, email, business_id, parent_entity_id, entity_type) VALUES ('EC', 'Etat Civil - Démarches Administratives', 'Etat Civil - Démarches Administratives', 'Y', '', '', '', '', '', '', '', '', 'PAGP', 'Direction');
INSERT INTO list_templates (id, title, description, type, entity_id) VALUES (13, 'Etat Civil - Démarches Administratives', 'Etat Civil - Démarches Administratives', 'diffusionList', 13);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (13, 18, 'user', 'dest', 0);
INSERT INTO list_templates (id, title, description, type, entity_id) VALUES (2013, 'visa Etat Civil - Démarches Administratives', 'visa Etat Civil - Démarches Administratives', 'visaCircuit', 13);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2013, 17, 'user', 'visa', 0);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2013, 5, 'user', 'visa', 1);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2013, 3, 'user', 'sign', 2);
INSERT INTO entities (entity_id, entity_label, short_label, enabled, address_street, address_additional1, address_additional2, address_postcode, address_town, address_country, email, business_id, parent_entity_id, entity_type) VALUES ('SCUL', 'Service Culture', 'Service Culture', 'Y', '', '', '', '', '', '', '', '', 'PAGP', 'Direction');
INSERT INTO list_templates (id, title, description, type, entity_id) VALUES (14, 'Service Culture', 'Service Culture', 'diffusionList', 14);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (14, 19, 'user', 'dest', 0);
INSERT INTO list_templates (id, title, description, type, entity_id) VALUES (2014, 'visa Service Culture', 'visa Service Culture', 'visaCircuit', 14);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2014, 17, 'user', 'visa', 0);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2014, 5, 'user', 'visa', 1);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2014, 3, 'user', 'sign', 2);
INSERT INTO entities (entity_id, entity_label, short_label, enabled, address_street, address_additional1, address_additional2, address_postcode, address_town, address_country, email, business_id, parent_entity_id, entity_type) VALUES ('SARU', 'Secteur Accueil et Relations aux Usagers', 'Secteur Accueil et Relations aux Usagers', 'Y', '', '', '', '', '', '', '', '', 'PAGP', 'Direction');
INSERT INTO list_templates (id, title, description, type, entity_id) VALUES (15, 'Secteur Accueil et Relations aux Usagers', 'Secteur Accueil et Relations aux Usagers', 'diffusionList', 15);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (15, 20, 'user', 'dest', 0);
INSERT INTO list_templates (id, title, description, type, entity_id) VALUES (2015, 'visa Secteur Accueil et Relations aux Usagers', 'visa Secteur Accueil et Relations aux Usagers', 'visaCircuit', 15);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2015, 17, 'user', 'visa', 0);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2015, 5, 'user', 'visa', 1);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2015, 3, 'user', 'sign', 2);
INSERT INTO entities (entity_id, entity_label, short_label, enabled, address_street, address_additional1, address_additional2, address_postcode, address_town, address_country, email, business_id, parent_entity_id, entity_type) VALUES ('SSEJ', 'Service des Affaires scolaires, Enfance, Jeunesse', 'Service des Affaires scolaires, Enfance, Jeunesse', 'Y', '', '', '', '', '', '', '', '', 'PAGP', 'Direction');
INSERT INTO list_templates (id, title, description, type, entity_id) VALUES (16, 'Service des Affaires scolaires, Enfance, Jeunesse', 'Service des Affaires scolaires, Enfance, Jeunesse', 'diffusionList', 16);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (16, 21, 'user', 'dest', 0);
INSERT INTO list_templates (id, title, description, type, entity_id) VALUES (2016, 'visa Service des Affaires scolaires, Enfance, Jeunesse', 'visa Service des Affaires scolaires, Enfance, Jeunesse', 'visaCircuit', 16);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2016, 17, 'user', 'visa', 0);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2016, 5, 'user', 'visa', 1);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2016, 3, 'user', 'sign', 2);
INSERT INTO entities (entity_id, entity_label, short_label, enabled, address_street, address_additional1, address_additional2, address_postcode, address_town, address_country, email, business_id, parent_entity_id, entity_type) VALUES ('SSPO', 'Secteur des Sports', 'Secteur des Sports', 'Y', '', '', '', '', '', '', '', '', 'PAGP', 'Direction');
INSERT INTO list_templates (id, title, description, type, entity_id) VALUES (17, 'Secteur des Sports', 'Secteur des Sports', 'diffusionList', 17);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (17, 22, 'user', 'dest', 0);
INSERT INTO list_templates (id, title, description, type, entity_id) VALUES (2017, 'visa Secteur des Sports', 'visa Secteur des Sports', 'visaCircuit', 17);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2017, 17, 'user', 'visa', 0);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2017, 5, 'user', 'visa', 1);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2017, 3, 'user', 'sign', 2);
INSERT INTO entities (entity_id, entity_label, short_label, enabled, address_street, address_additional1, address_additional2, address_postcode, address_town, address_country, email, business_id, parent_entity_id, entity_type) VALUES ('SVA', 'Secteur Vie Associative', 'Secteur Vie Associative', 'Y', '', '', '', '', '', '', '', '', 'PAGP', 'Direction');
INSERT INTO list_templates (id, title, description, type, entity_id) VALUES (18, 'Secteur Vie Associative', 'Secteur Vie Associative', 'diffusionList', 18);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (18, 23, 'user', 'dest', 0);
INSERT INTO list_templates (id, title, description, type, entity_id) VALUES (2018, 'visa Secteur Vie Associative', 'visa Secteur Vie Associative', 'visaCircuit', 18);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2018, 17, 'user', 'visa', 0);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2018, 5, 'user', 'visa', 1);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2018, 3, 'user', 'sign', 2);
INSERT INTO entities (entity_id, entity_label, short_label, enabled, address_street, address_additional1, address_additional2, address_postcode, address_town, address_country, email, business_id, parent_entity_id, entity_type) VALUES ('SGC', 'Service Gestion des Correspondances', 'Service Gestion des Correspondances', 'Y', '', '', '', '', '', '', '', '', 'PAGP', 'Direction');
INSERT INTO list_templates (id, title, description, type, entity_id) VALUES (19, 'Service Gestion des Correspondances', 'Service Gestion des Correspondances', 'diffusionList', 19);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (19, 13, 'user', 'dest', 0);
INSERT INTO list_templates (id, title, description, type, entity_id) VALUES (2019, 'visa Service Gestion des Correspondances', 'visa Service Gestion des Correspondances', 'visaCircuit', 19);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2019, 13, 'user', 'visa', 0);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2019, 17, 'user', 'visa', 1);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2019, 5, 'user', 'visa', 2);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2019, 3, 'user', 'sign', 3);
INSERT INTO entities (entity_id, entity_label, short_label, enabled, address_street, address_additional1, address_additional2, address_postcode, address_town, address_country, email, business_id, parent_entity_id, entity_type) VALUES ('DPM', 'Direction de la Police Municipale', 'Direction de la Police Municipale', 'Y', '', '', '', '', '', '', '', '', 'DGS', 'Direction');
INSERT INTO list_templates (id, title, description, type, entity_id) VALUES (20, 'Direction de la Police Municipale', 'Direction de la Police Municipale', 'diffusionList', 20);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (20, 26, 'user', 'dest', 0);
INSERT INTO list_templates (id, title, description, type, entity_id) VALUES (2020, 'visa Direction de la Police Municipale', 'visa Direction de la Police Municipale', 'visaCircuit', 20);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2020, 5, 'user', 'visa', 0);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2020, 3, 'user', 'sign', 1);
INSERT INTO entities (entity_id, entity_label, short_label, enabled, address_street, address_additional1, address_additional2, address_postcode, address_town, address_country, email, business_id, parent_entity_id, entity_type) VALUES ('PST', 'Pôle des Services Techniques', 'Pôle des Services Techniques', 'Y', '', '', '', '', '', '', '', '', 'DGS', 'Direction');
INSERT INTO list_templates (id, title, description, type, entity_id) VALUES (21, 'Pôle des Services Techniques', 'Pôle des Services Techniques', 'diffusionList', 21);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (21, 27, 'user', 'dest', 0);
INSERT INTO list_templates (id, title, description, type, entity_id) VALUES (2021, 'visa Pôle des Services Techniques', 'visa Pôle des Services Techniques', 'visaCircuit', 21);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2021, 5, 'user', 'visa', 0);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2021, 3, 'user', 'sign', 1);
INSERT INTO entities (entity_id, entity_label, short_label, enabled, address_street, address_additional1, address_additional2, address_postcode, address_town, address_country, email, business_id, parent_entity_id, entity_type) VALUES ('URBA', 'Serivce de l''urbanisme', 'Serivce de l''urbanisme', 'Y', '', '', '', '', '', '', '', '', 'PST', 'Direction');
INSERT INTO list_templates (id, title, description, type, entity_id) VALUES (22, 'Serivce de l''urbanisme', 'Serivce de l''urbanisme', 'diffusionList', 22);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (22, 28, 'user', 'dest', 0);
INSERT INTO list_templates (id, title, description, type, entity_id) VALUES (2022, 'visa Serivce de l''urbanisme', 'visa Serivce de l''urbanisme', 'visaCircuit', 22);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2022, 27, 'user', 'visa', 0);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2022, 5, 'user', 'visa', 1);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2022, 3, 'user', 'sign', 2);
INSERT INTO entities (entity_id, entity_label, short_label, enabled, address_street, address_additional1, address_additional2, address_postcode, address_town, address_country, email, business_id, parent_entity_id, entity_type) VALUES ('ST', 'Services techniques', 'Services techniques', 'Y', '', '', '', '', '', '', '', '', 'PST', 'Direction');
INSERT INTO list_templates (id, title, description, type, entity_id) VALUES (23, 'Services techniques', 'Services techniques', 'diffusionList', 23);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (23, 29, 'user', 'dest', 0);
INSERT INTO list_templates (id, title, description, type, entity_id) VALUES (2023, 'visa Services techniques', 'visa Services techniques', 'visaCircuit', 23);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2023, 27, 'user', 'visa', 0);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2023, 5, 'user', 'visa', 1);
INSERT INTO list_templates_items (list_template_id, item_id, item_type, item_mode, sequence) VALUES (2023, 3, 'user', 'sign', 2);

-- A AMELIORER : paramétrer des valeurs par défaut d'export pour l'ensemble des utilisateurs
-- INSERT INTO exports_templates (id, user_id, delimiter, format, data) VALUES (2, 4, ';', 'csv', '[{"value":"doc_date","label":"Date du courrier","isFunction":false},{"value":"getAssignee","label":"Attributaire","isFunction":true},{"value":"getDestinationEntity","label":"Libellé de l''entité traitante","isFunction":true},{"value":"subject","label":"Objet","isFunction":false},{"value":"process_limit_date","label":"Date limite de traitement","isFunction":false}]');
-- INSERT INTO exports_templates (id, user_id, delimiter, format, data) VALUES (1, 4, ';', 'pdf', '[{"value":"doc_date","label":"Date du courrier","isFunction":false},{"value":"type_label","label":"Type de courrier","isFunction":false},{"value":"getAssignee","label":"Attributaire","isFunction":true},{"value":"subject","label":"Objet","isFunction":false},{"value":"process_limit_date","label":"Date limite de traitement","isFunction":false}]');
-- A AMELIORER : paramétrer des modèles de recherche par défaut pour l'ensemble des utilisateurs
-- INSERT INTO search_templates (id, user_id, label, creation_date, query) VALUES (1, 23, 'Tous les courriers', '2021-03-25 11:54:30.273871', '[{"identifier":"category","values":""},{"identifier":"meta"}]');
-- INSERT INTO search_templates (id, user_id, label, creation_date, query) VALUES (2, 18, 'Courriers arrivés', '2021-03-25 11:59:29.500487', '[{"identifier":"category","values":[{"id":"incoming","label":"Courrier Arrivée"}]},{"identifier":"meta"}]');
-- A AMELIORER : paramétrer un modèle de recherche de contact pour l'ensemble des utilisateurs
-- INSERT INTO contacts_search_templates (id, user_id, label, creation_date, query) VALUES (1, 23, 'Tous les contacts', '2021-03-25 11:54:30.273871', '[]'); -- EDISSYUM - NCH01 Fenetre de recherche de contacts

-- Déploiement de la tuile "mes derniers courriers consultés"
TRUNCATE TABLE tiles;
ALTER SEQUENCE tiles_id_seq restart WITH 1;
INSERT INTO tiles (user_id, type, view, position, color, parameters) SELECT id, 'myLastResources', 'list', 0,'#a5d6a7','{"chartType": "line"}' FROM users WHERE status='OK' AND MODE='standard';
------------
-- INDEXING_MODELS_ENTITIES
------------
-- Set 'ALL_ENTITIES' keyword for every indexing model in indexing_models_entities
INSERT INTO indexing_models_entities (model_id, keyword) (SELECT models.id as model_id, 'ALL_ENTITIES' as keyword FROM indexing_models as models WHERE models.private = false);
------------
-- ENTITIES_FOLDERS
------------
TRUNCATE TABLE entities_folders;
INSERT INTO entities_folders (folder_id, entity_id, edition)
SELECT folders.id, entities.id, false
FROM folders,
     entities
WHERE 1 = 1;
-- réattribuer les bannettes à tous les utilisateurs --
TRUNCATE TABLE users_baskets_preferences;
INSERT INTO users_baskets_preferences (user_serial_id, group_serial_id, basket_id, display)
    (SELECT ugc.user_id,ug.id ,gb.basket_id,TRUE
     FROM groupbasket gb
              LEFT JOIN usergroups ug ON ug.group_id = gb.group_id
              INNER JOIN usergroup_content  ugc ON ug.id = ugc.group_id
     ORDER BY ugc.user_id );
-- réinitialisation des séquences --
SELECT setval('acknowledgement_receipts_id_seq', (SELECT max(id)+1 FROM acknowledgement_receipts), false);
SELECT setval('actions_id_seq', (SELECT max(id)+1 FROM actions), false);
SELECT setval('address_sectors_id_seq', (SELECT max(id)+1 FROM address_sectors), false);
SELECT setval('adr_attachments_id_seq', (SELECT max(id)+1 FROM adr_attachments), false);
SELECT setval('adr_letterbox_id_seq', (SELECT max(id)+1 FROM adr_letterbox), false);
SELECT setval('attachment_types_id_seq', (SELECT max(id)+1 FROM attachment_types), false);
SELECT setval('baskets_id_seq', (SELECT max(id)+1 FROM baskets), false);
SELECT setval('blacklist_id_seq', (SELECT max(id)+1 FROM blacklist), false);
SELECT setval('configurations_id_seq', (SELECT max(id)+1 FROM configurations), false);
SELECT setval('contacts_civilities_id_seq', (SELECT max(id)+1 FROM contacts_civilities), false);
SELECT setval('contacts_custom_fields_list_id_seq', (SELECT max(id)+1 FROM contacts_custom_fields_list), false);
SELECT setval('contacts_filling_id_seq', (SELECT max(id)+1 FROM contacts_filling), false);
SELECT setval('contacts_groups_id_seq', (SELECT max(id)+1 FROM contacts_groups), false);
SELECT setval('contacts_groups_lists_id_seq', (SELECT max(id)+1 FROM contacts_groups_lists), false);
SELECT setval('contacts_id_seq', (SELECT max(id)+1 FROM contacts), false);
SELECT setval('contacts_parameters_id_seq', (SELECT max(id)+1 FROM contacts_parameters), false);
SELECT setval('custom_fields_id_seq', (SELECT max(id)+1 FROM custom_fields), false);
SELECT setval('docservers_id_seq', (SELECT max(id)+1 FROM docservers), false);
SELECT setval('doctypes_first_level_id_seq', (SELECT max(doctypes_first_level_id)+1 FROM doctypes_first_level), false);
SELECT setval('doctypes_second_level_id_seq', (SELECT max(doctypes_second_level_id)+1 FROM doctypes_second_level), false);
SELECT setval('doctypes_type_id_seq', (SELECT max(type_id)+1 FROM doctypes), false);
SELECT setval('emails_id_seq', (SELECT max(id)+1 FROM emails), false);
SELECT setval('entities_folders_id_seq', (SELECT max(id)+1 FROM entities_folders), false);
SELECT setval('entities_id_seq', (SELECT max(id)+1 FROM entities), false);
SELECT setval('exports_templates_id_seq', (SELECT max(id)+1 FROM exports_templates), false);
SELECT setval('folders_id_seq', (SELECT max(id)+1 FROM folders), false);
SELECT setval('groupbasket_id_seq', (SELECT max(id)+1 FROM groupbasket), false);
SELECT setval('groupbasket_redirect_system_id_seq', (SELECT max(system_id)+1 FROM groupbasket_redirect), false);
SELECT setval('history_batch_id_seq', (SELECT max(batch_id)+1 FROM history_batch), false);
SELECT setval('history_id_seq', (SELECT max(id)+1 FROM history), false);
SELECT setval('indexing_models_fields_id_seq', (SELECT max(id)+1 FROM indexing_models_fields), false);
SELECT setval('indexing_models_id_seq', (SELECT max(id)+1 FROM indexing_models), false);
SELECT setval('indexing_models_entities_id_seq', (SELECT max(id)+1 FROM indexing_models_entities), false);
SELECT setval('list_templates_id_seq', (SELECT max(id)+1 FROM list_templates), false);
SELECT setval('list_templates_items_id_seq', (SELECT max(id)+1 FROM list_templates_items), false);
SELECT setval('listinstance_history_details_id_seq', (SELECT max(listinstance_history_details_id)+1 FROM listinstance_history_details), false);
SELECT setval('listinstance_history_id_seq', (SELECT max(listinstance_history_id)+1 FROM listinstance_history), false);
SELECT setval('listinstance_id_seq', (SELECT max(listinstance_id)+1 FROM listinstance), false);
SELECT setval('notes_entities_id_seq', (SELECT max(id)+1 FROM note_entities), false);
SELECT setval('notes_id_seq', (SELECT max(id)+1 FROM notes), false);
SELECT setval('notif_email_stack_seq', (SELECT max(email_stack_sid)+1 FROM notif_email_stack), false);
SELECT setval('notif_event_stack_seq', (SELECT max(event_stack_sid)+1 FROM notif_event_stack), false);
SELECT setval('notifications_seq', (SELECT max(notification_sid)+1 FROM notifications), false);
SELECT setval('password_history_id_seq', (SELECT max(id)+1 FROM password_history), false);
SELECT setval('password_rules_id_seq', (SELECT max(id)+1 FROM password_rules), false);
SELECT setval('redirected_baskets_id_seq', (SELECT max(id)+1 FROM redirected_baskets), false);
SELECT setval('registered_mail_issuing_sites_entities_id_seq', (SELECT max(id)+1 FROM registered_mail_issuing_sites_entities), false);
SELECT setval('registered_mail_issuing_sites_id_seq', (SELECT max(id)+1 FROM registered_mail_issuing_sites), false);
SELECT setval('registered_mail_number_range_id_seq', (SELECT max(id)+1 FROM registered_mail_number_range), false);
SELECT setval('registered_mail_resources_id_seq', (SELECT max(id)+1 FROM registered_mail_resources), false);
SELECT setval('res_attachment_res_id_seq', (SELECT max(res_id)+1 FROM res_attachments), false);
SELECT setval('res_id_mlb_seq', (SELECT max(res_id)+1 FROM res_letterbox), false);
SELECT setval('resource_contacts_id_seq', (SELECT max(id)+1 FROM resource_contacts), false);
SELECT setval('resources_folders_id_seq', (SELECT max(id)+1 FROM resources_folders), false);
SELECT setval('resources_tags_id_seq', (SELECT max(id)+1 FROM resources_tags), false);
SELECT setval('search_templates_id_seq', (SELECT max(id)+1 FROM search_templates), false);
SELECT setval('security_security_id_seq', (SELECT max(security_id)+1 FROM security), false);
SELECT setval('shipping_templates_id_seq', (SELECT max(id)+1 FROM shipping_templates), false);
SELECT setval('shippings_id_seq', (SELECT max(id)+1 FROM shippings), false);
SELECT setval('status_identifier_seq', (SELECT max(identifier)+1 FROM status), false);
SELECT setval('status_images_id_seq', (SELECT max(id)+1 FROM status_images), false);
SELECT setval('tags_id_seq', (SELECT max(id)+1 FROM tags), false);
SELECT setval('templates_association_id_seq', (SELECT max(id)+1 FROM templates_association), false);
SELECT setval('templates_seq', (SELECT max(template_id)+1 FROM templates), false);
SELECT setval('tiles_id_seq', (SELECT max(id)+1 FROM tiles), false);
SELECT setval('user_signatures_id_seq', (SELECT max(id)+1 FROM user_signatures), false);
SELECT setval('usergroups_id_seq', (SELECT max(id)+1 FROM usergroups), false);
SELECT setval('users_baskets_preferences_id_seq', (SELECT max(id)+1 FROM users_baskets_preferences), false);
SELECT setval('users_email_signatures_id_seq', (SELECT max(id)+1 FROM users_email_signatures), false);
SELECT setval('users_followed_resources_id_seq', (SELECT max(id)+1 FROM users_followed_resources), false);
SELECT setval('users_id_seq', (SELECT max(id)+1 FROM users), false);
SELECT setval('users_pinned_folders_id_seq', (SELECT max(id)+1 FROM users_pinned_folders), false);
