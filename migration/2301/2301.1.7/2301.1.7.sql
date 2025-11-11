-- *************************************************************************--
--                                                                          --
--                                                                          --
-- Model migration script - 2301.1.5 to 2301.1.6                            --
--                                                                          --
--                                                                          --
-- *************************************************************************--


INSERT INTO parameters (id, description, param_value_string)
    SELECT 'contactsConfidentiality', 'Gestion de la confidentialité des contacts','{"basic": {"customId": "", "entitiesAllowed": "", "hiddenFields": "email, phone, address"}, "advanced": {"customId": "", "entitiesAllowed": "", "hiddenFields": "email, phone, address, annotations"}}'
    WHERE NOT EXISTS (SELECT 1 FROM parameters WHERE id = 'contactsConfidentiality'); -- EDISSYUM - NCH01 Rajout de la confidentialité des contacts

INSERT INTO parameters (id, description, param_value_int)
    SELECT 'showFoldersByDefault', 'Si activé (1), afficher les dossiers ouverts par defaut sinon (0)', 0
    WHERE NOT EXISTS (SELECT 1 FROM parameters WHERE id = 'showFoldersByDefault'); -- EDISSYUM - EME01 Ajout d'une fenêtre pour administrer la recherche des dossiers

INSERT INTO parameters (id, description, param_value_int)
    SELECT 'summarySheetMandatory', 'Fiche de liaison obligatoire lors d''une impression en masse', 1
    WHERE NOT EXISTS (SELECT 1 FROM parameters WHERE id = 'summarySheetMandatory'); -- EDISSYUM - NCH01 Amélioration de l'écran d'impression en masse

INSERT INTO parameters (id, description, param_value_string)
    SELECT 'ActionQualifID', 'Identifiants des actions d''envoi en qualification', 'ACTION#551,ACTION#18'
    WHERE NOT EXISTS (SELECT 1 FROM parameters WHERE id = 'ActionQualifID');

INSERT INTO parameters (id, description, param_value_int)
    SELECT 'ContactsDuplicateMaxItems', 'Nombre de résultats maximums pour le dédoublonnage des contacts', 500
    WHERE NOT EXISTS (SELECT 1 FROM parameters WHERE id = 'ContactsDuplicateMaxItems'); -- EDISSYUM - NCH01 Ajout d'un paramètre pour gérer le nombre max de contacts afficher dans l'écran de dédoublonnage

INSERT INTO parameters (id, description, param_value_int)
    SELECT 'suggest_links_n_days_ago', 'Le nombre de jours sur lequel sont cherchés les courriers à lier', 0
    WHERE NOT EXISTS (SELECT 1 FROM parameters WHERE id = 'suggest_links_n_days_ago');

INSERT INTO parameters (id, description, param_value_string)
    SELECT 'customPostalAddressSettings', 'Gestion du champ de fusion d''adresse personnalisé', '{
        "1" : {"count": 38, "case": "upper", "value": "civility;lastname;firstname"},
        "2" : {"count": 38, "case": "ucfirst", "value": "company"},
        "3" : {"count": 38, "case": "lower", "value": "department; function"},
        "4" : {"count": 38, "case": "upper", "value": "address_additional1"},
        "5" : {"count": 100, "case": "upper", "value": "address_number;address_street"},
        "6" : {"count": 100, "case": "upper", "value": "address_postcode;address_town"},
        "7" : {"count": 30, "case": "ucfirst", "value": "address_country"}
    }'
    WHERE NOT EXISTS (SELECT 1 FROM parameters WHERE id = 'customPostalAddressSettings');
        -- EDISSYUM - NCH01 Rajout d'une variable de fusion custom pour les adresses - customPostalAddress

INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date)
    SELECT 'printedFolderName', 'Masque de nommage du dossier d''impression', 'Dossier d''impression#chrono#full_date', NULL, NULL
    WHERE NOT EXISTS (SELECT 1 FROM parameters WHERE id = 'printedFolderName'); -- EDISSYUM - NCH01 Création d'un masque pour le nom de fichier du dossier d'impression

-- EDISSYUM - ASY01 Ajout de modèle d'exportation PDF/CSV
ALTER TABLE contacts_parameters ADD COLUMN IF NOT EXISTS exportable boolean NOT NULL DEFAULT FALSE;

CREATE TABLE IF NOT EXISTS export_templates (
      id serial,
      user_id integer NOT NULL,
      label character varying(255) NOT NULL,
      creation_date timestamp without time zone NOT NULL,
      entity_id jsonb  DEFAULT '[]',
      query json NOT NULL,
      CONSTRAINT export_templates_pkey PRIMARY KEY (id)
) WITH (OIDS=FALSE);
-- END EDISSYUM - ASY01

UPDATE difflist_roles SET label = 'Attributaire' WHERE role_id = 'dest'; -- EDISSYUM - NCH01 Modification du libellé destinataire
UPDATE difflist_roles SET role_id = 'copy' WHERE role_id = 'copy'; -- EDISSYUM - NCH01 Modification du libellé destinataire | Obligatoire pour éviter l'inversion Dest / Copie
UPDATE difflist_roles SET role_id = 'visa' WHERE role_id = 'visa'; -- EDISSYUM - NCH01 Modification du libellé destinataire | Obligatoire pour éviter l'inversion Dest / Copie
UPDATE difflist_roles SET role_id = 'sign' WHERE role_id = 'sign'; -- EDISSYUM - NCH01 Modification du libellé destinataire | Obligatoire pour éviter l'inversion Dest / Copie
UPDATE difflist_roles SET role_id = 'avis' WHERE role_id = 'avis'; -- EDISSYUM - NCH01 Modification du libellé destinataire | Obligatoire pour éviter l'inversion Dest / Copie
UPDATE difflist_roles SET role_id = 'avis_copy' WHERE role_id = 'avis_copy'; -- EDISSYUM - NCH01 Modification du libellé destinataire | Obligatoire pour éviter l'inversion Dest / Copie
UPDATE difflist_roles SET role_id = 'avis_info' WHERE role_id = 'avis_info'; -- EDISSYUM - NCH01 Modification du libellé destinataire | Obligatoire pour éviter l'inversion Dest / Copie

UPDATE parameters SET param_value_string = '2301.1.7' WHERE id = 'database_version';
