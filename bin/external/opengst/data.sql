INSERT INTO public.custom_fields (label, type, "values") VALUES ('[OpenGST] Adresse d''intervention', 'banAutocomplete', '[]');
INSERT INTO public.custom_fields (label, type, "values") VALUES ('[OpenGST] Informations complémentaires', 'string', '[]');
INSERT INTO public.custom_fields (label, type, "values") VALUES ('[OpenGST] Domaine', 'select', '{"key": "entity_label", "label": [{"column": "entity_label", "delimiterEnd": "", "delimiterStart": ""}], "table": "entities", "clause": "parent_entity_id = ''DOMAINES''"}');
INSERT INTO public.custom_fields (label, type, "values") VALUES ('[OpenGST] Priorité', 'radio', '["Normal", "Urgent"]');
INSERT INTO public.custom_fields (label, type, "values") VALUES ('[OpenGST] Domaine', 'select', '{"key": "entity_label", "label": [{"column": "entity_label", "delimiterEnd": "", "delimiterStart": ""}], "table": "entities", "clause": "parent_entity_id = ''DOMAINES''"}');
INSERT INTO public.custom_fields (label, type, "values") VALUES ('[OpenGST] Statut intervention', 'string', '[]');
INSERT INTO public.custom_fields (label, type, "values") VALUES ('[OpenGST] Motif refus', 'string', '[]');
INSERT INTO public.custom_fields (label, type, "values") VALUES ('[OpenGST] Statut demande intervention', 'string', '[]');
INSERT INTO public.custom_fields (label, type, "values") VALUES ('[OpenGST] Quartier', 'select', '{"key": "entity_label", "label": [{"column": "entity_label", "delimiterEnd": "", "delimiterStart": ""}], "table": "entities", "clause": "parent_entity_id = ''QUARTIER''"}');
INSERT INTO public.custom_fields (label, type, "values") VALUES ('[OpenGST] Objet de la demande', 'string', '[]');
INSERT INTO public.custom_fields (label, type, "values") VALUES ('[OpenGST] Type de demande', 'select', '{"key": "opengst_service", "label": [{"column": "maarch_label", "delimiterEnd": "", "delimiterStart": ""}], "table": "opengst_services", "clause": "true order by maarch_label"}');
INSERT INTO public.custom_fields (label, type, "values") VALUES ('[OpenGST] Canal', 'radio', '["TELEPHONE", "EMAIL", "ELUS", "GUICHET", "COURRIER", "WEB", "APP. MOBILE"]');

INSERT INTO public.status (id, label_status, is_system, img_filename, maarch_module, can_be_searched, can_be_modified)  VALUES ('O_DRAFT', 'Traitement en cours dans OpenGST (DRAFT)', 'N', 'fa-pause', 'apps', 'Y', 'Y');
INSERT INTO public.status (id, label_status, is_system, img_filename, maarch_module, can_be_searched, can_be_modified)  VALUES ('O_WAIT', 'Traitement en cours dans OpenGST (WAIT)', 'N', 'fa-pause', 'apps', 'Y', 'Y');
INSERT INTO public.status (id, label_status, is_system, img_filename, maarch_module, can_be_searched, can_be_modified)  VALUES ('O_REFUSED', 'Traitement en cours dans OpenGST (REFUSED)', 'N', 'fa-pause', 'apps', 'Y', 'Y');
INSERT INTO public.status (id, label_status, is_system, img_filename, maarch_module, can_be_searched, can_be_modified)  VALUES ('O_VALID', 'Traitement en cours dans OpenGST (VALID)', 'N', 'fa-pause', 'apps', 'Y', 'Y');
INSERT INTO public.status (id, label_status, is_system, img_filename, maarch_module, can_be_searched, can_be_modified)  VALUES ('O_FINISHED', 'Traitement en cours dans OpenGST (FINISHED)', 'N', 'fa-pause', 'apps', 'Y', 'Y');
INSERT INTO public.status (id, label_status, is_system, img_filename, maarch_module, can_be_searched, can_be_modified)  VALUES ('O_TO_CONF', 'Traitement en cours dans OpenGST (TO_CONFIRM)', 'N', 'fa-pause', 'apps', 'Y', 'Y');
INSERT INTO public.status (id, label_status, is_system, img_filename, maarch_module, can_be_searched, can_be_modified)  VALUES ('O_CONFIRMD', 'Traitement en cours dans OpenGST (CONFIRMED)', 'N', 'fa-pause', 'apps', 'Y', 'Y');
INSERT INTO public.status (id, label_status, is_system, img_filename, maarch_module, can_be_searched, can_be_modified)  VALUES ('O_MERGED', 'Traitement en cours dans OpenGST (MERGED)', 'N', 'fa-pause', 'apps', 'Y', 'Y');
INSERT INTO public.status (id, label_status, is_system, img_filename, maarch_module, can_be_searched, can_be_modified)  VALUES ('O_OPEN', 'Traitement en cours dans OpenGST (OPEN)', 'N', 'fa-pause', 'apps', 'Y', 'Y');
INSERT INTO public.status (id, label_status, is_system, img_filename, maarch_module, can_be_searched, can_be_modified)  VALUES ('O_SCHEDULD', 'Traitement en cours dans OpenGST (SCHEDULED)', 'N', 'fa-pause', 'apps', 'Y', 'Y');
INSERT INTO public.status (id, label_status, is_system, img_filename, maarch_module, can_be_searched, can_be_modified)  VALUES ('O_PENDING', 'Traitement en cours dans OpenGST (PENDING)', 'N', 'fa-pause', 'apps', 'Y', 'Y');
INSERT INTO public.status (id, label_status, is_system, img_filename, maarch_module, can_be_searched, can_be_modified)  VALUES ('O_CANCELLD', 'Traitement en cours dans OpenGST (CANCELLED)', 'N', 'fa-pause', 'apps', 'Y', 'Y');
INSERT INTO public.status (id, label_status, is_system, img_filename, maarch_module, can_be_searched, can_be_modified)  VALUES ('O_RDG', 'Réponse à rédiger', 'N', 'fm-letter-incoming', 'apps', 'Y', 'Y');
INSERT INTO public.status (id, label_status, is_system, img_filename, maarch_module, can_be_searched, can_be_modified)  VALUES ('O_COU', 'Traitement en cours dans OpenGST', 'N', 'fm-letter-status-arev', 'apps', 'Y', 'Y');

UPDATE custom_fields SET values='{"key": "opengst_service", "label": [{"column": "maarch_label", "delimiterEnd": "", "delimiterStart": ""}], "table": "opengst_services", "clause": "true"}' WHERE label ILIKE 'type%';

DROP TABLE opengst_services;
CREATE TABLE opengst_services (
    opengst_model character varying(255) NOT NULL,
    opengst_service character varying(255) NOT NULL,
    maarch_label character varying(255) NOT NULL,
    CONSTRAINT opengst_services_pkey PRIMARY KEY (opengst_service, maarch_label)
);

CREATE TABLE IF NOT EXISTS opengst_contributions (
    res_id bigint NOT NULL,
    opengst_id bigint,
    note_id bigint,
    contrib_id bigint,
    note_creation_date timestamp without time zone,
    contrib_creation_date timestamp without time zone,
    source VARCHAR
);


