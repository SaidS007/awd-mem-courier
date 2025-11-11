-- *************************************************************************--
--                                                                          --
--                                                                          --
-- Model migration script - 21.03.25 to 21.03.27                            --
--                                                                          --
--                                                                          --
-- *************************************************************************--

INSERT INTO configurations (privilege, value) VALUES ('admin_search_contacts', '{"listDisplay": {"subInfos": [{"icon": "fa-user", "label": "Civilité", "value": "getCivility", "cssClasses": ["align_leftData"]}, {"icon": "fa-calendar", "label": "Date de création", "value": "getCreationDate", "cssClasses": ["align_leftData"]}, {"icon": "fa-user", "label": "Courriel", "value": "getEmail", "cssClasses": ["align_leftData"]}, {"icon": "fa-user", "label": "Téléphone", "value": "getPhone", "cssClasses": ["align_leftData"]}, {"icon": "fa-map-marker-alt", "label": "Numéro de rue", "value": "getAddressNumber", "cssClasses": ["align_leftData"]}, {"icon": "fa-map-marker-alt", "label": "Voie", "value": "getAddressStreet", "cssClasses": ["align_leftData"]}], "templateColumns": 6}}');

ALTER TABLE contacts_parameters ADD COLUMN filtrable boolean DEFAULT false;

INSERT INTO configurations (privilege, value) VALUES ('admin_search_folders', '{"listEvent": {"defaultTab": "dashboard"}, "listDisplay": {"subInfos": [{"icon": "fa-traffic-light", "value": "getPriority", "cssClasses": ["align_leftData"]}, {"icon": "fa-calendar", "value": "getCreationAndProcessLimitDates", "cssClasses": ["align_leftData"]}, {"icon": "fa-sitemap", "value": "getAssignee", "cssClasses": ["align_leftData"]}, {"icon": "fa-suitcase", "value": "getDoctype", "cssClasses": ["align_leftData"]}, {"icon": "fa-user", "value": "getRecipients", "cssClasses": ["align_leftData"]}, {"icon": "fa-book", "value": "getSenders", "cssClasses": ["align_leftData"]}], "templateColumns": 6}}');

INSERT INTO configurations (privilege, value) VALUES  ('admin_send_secure_email', '{"pastell": {"byDefault": "", "url": "", "login": "", "password": "", "entite": 0, "enabled": false}}');

INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date) VALUES ('showFoldersByDefault', 'Si activé (1), afficher les dossiers ouverts par defaut sinon (0)', NULL, 0, NULL);

INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date) VALUES ('summarySheetMandatory', 'Fiche de liaison obligatoire lors d''une impression en masse', NULL, 1, NULL); -- EDISSYUM - NCH01 Amélioration de l'écran d'impression en masse

INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date) VALUES ('ContactsDuplicateMaxItems', 'Nombre de résultats maximums pour le dédoublonnage des contacts', NULL, 500, NULL);

INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date) VALUES ('contactsConfidentiality', 'Gestion de la confidentialité des contacts','{"basic": {"customId": "", "entitiesAllowed": "", "hiddenFields": "email, phone, address"}, "advanced": {"customId": "", "entitiesAllowed": "", "hiddenFields": "email, phone, address, annotations"}}', NULL, NULL);

INSERT INTO notifications (notification_sid, notification_id, description, is_enabled, event_id, notification_mode, template_id, diffusion_type, diffusion_properties, attachfor_type, attachfor_properties) VALUES (100, 'QUOTA', 'Alerte lorsque le quota est dépassé', 'Y', 'user_quota', 'EMAIL', 1049, 'user', 'superadmin', NULL, NULL);

INSERT INTO templates (template_label, template_comment, template_content, template_type, template_style, template_target, template_attachment_type, template_datasource) VALUES ('Quota d''utilisateur', 'Modèle de notification pour le quota utilisateur', '<p>Quota utilisateur atteint</p>', 'HTML', 'ODT: rep_standard', 'notifications', 'all', 'notif_events');

CREATE TABLE IF NOT EXISTS contacts_search_templates (
                                                         id serial,
                                                         user_id integer NOT NULL,
                                                         label character varying(255) NOT NULL,
                                                         creation_date timestamp without time zone NOT NULL,
                                                         query json NOT NULL,
                                                         CONSTRAINT contacts_search_templates_pkey PRIMARY KEY (id)
)
    WITH (OIDS=FALSE);

INSERT INTO contacts_search_templates (id, user_id, label, creation_date, query) VALUES (1, 23, 'Tous les contacts', '2021-03-25 11:54:30.273871', '[]');

INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date) VALUES ('workflowSignatoryRole', 'Rôle de signataire dans le circuit', 'mandatory', NULL, NULL);
INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date) VALUES ('customPostalAddressSettings', 'Gestion du champ de fusion d''adresse personnalisé', '{
    "1" : {"count": 38, "case": "upper", "value": "civility;lastname;firstname"},
    "2" : {"count": 38, "case": "ucfirst", "value": "company"},
    "3" : {"count": 38, "case": "lower", "value": "department; function"},
    "4" : {"count": 38, "case": "upper", "value": "address_additional1"},
    "5" : {"count": 100, "case": "upper", "value": "address_number;address_street"},
    "6" : {"count": 100, "case": "upper", "value": "address_postcode;address_town"},
    "7" : {"count": 30, "case": "ucfirst", "value": "address_country"}
}', NULL, NULL);
INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date) VALUES ('printedFolderName', 'Masque de nommage du dossier d''impression', 'Dossier d''impression#chrono#full_date', NULL, NULL);

INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date) VALUES ('summarySheetQrCodeContent', 'Contenu du QR Code de la fiche de liaison', 'alt_identifier', NULL, NULL);

INSERT INTO parameters (id, description, param_value_int) VALUES ('C128Prefix', 'Si activé (1), ajoute "MEM_" dans le contenu des C128 générés.', 0); -- EDISSYUM - NCH01 Rajout du prefix pour les C128

UPDATE parameters SET param_value_string = '21.03.27' WHERE id = 'database_version';
