-- *************************************************************************--
--                                                                          --
--                                                                          --
-- Model migration script - 2301.2.x to 2301.3.0                            --
--                                                                          --
--                                                                          --
-- *************************************************************************--
--DATABASE_BACKUP|docservers

-- Docserver encryption
-- Checks if the "is_encrypted" column exists in the "docservers" table, if it doesn't exist, add the column.
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'docservers' AND column_name = 'is_encrypted') THEN
        ALTER TABLE docservers ADD COLUMN is_encrypted BOOL NOT NULL DEFAULT FALSE;
    END IF;
END $$;

INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date) VALUES ('noteVisibilityOffAction', 'Visibilité par défaut des annotations hors actions (0 = toutes les entités, 1 = restreint)', NULL, 0, NULL);
INSERT INTO parameters (id, description, param_value_string, param_value_int, param_value_date) VALUES ('noteVisibilityOnAction', 'Visibilité par défaut des annotations sur les actions (0 = toutes les entités, 1 = restreint)', NULL, 0, NULL);

-- EDISSYUM - AMO01 Modifier les clauses de banettes pour remplacer les id (INT) en basket_id (STR)
UPDATE baskets
SET basket_clause = REGEXP_REPLACE(
        basket_clause,
        'basket_id\s*=\s*''(\d+)''',
        'basket_id = ''' || (
            SELECT basket_id
            FROM baskets AS b2
            WHERE b2.id::text = REGEXP_REPLACE(baskets.basket_clause, '.*basket_id\s*=\s*''(\d+)''.*', '\1')
            LIMIT 1
    ) || ''''
)
WHERE basket_clause ~ 'basket_id\s*=\s*''\d+''';
-- END EDISSYUM - AMO01

ALTER TABLE contacts ADD COLUMN status CHARACTER VARYING(256); -- EDISSYUM - NCH01 Module OCForMEM NextGen
UPDATE contacts SET status = 'OK'; -- EDISSYUM - NCH01 Module OCForMEM NextGen

ALTER TABLE users ADD COLUMN absence jsonb;

ALTER TABLE res_attachments ADD COLUMN external_state jsonb DEFAULT '{}'::jsonb;

ALTER TABLE attachment_types ADD COLUMN signed_by_default boolean;
UPDATE attachment_types SET signed_by_default=false WHERE type_id!='outgoing_mail_signed' AND signed_by_default IS NULL;
UPDATE attachment_types SET signed_by_default=true WHERE type_id='outgoing_mail_signed' AND signed_by_default IS NULL;
ALTER TABLE attachment_types ALTER COLUMN signed_by_default SET DEFAULT NOT NULL;

ALTER TABLE contacts ALTER COLUMN custom_fields SET DEFAULT '{}'::jsonb;

ALTER TABLE contacts_parameters ALTER COLUMN filtrable SET DEFAULT false;
ALTER TABLE contacts_parameters ALTER COLUMN filtrable SET NOT NULL;

ALTER TABLE doctypes ADD COLUMN coll_id character varying(32) DEFAULT ''::character varying NOT NULL;

ALTER TABLE emails ALTER COLUMN document TYPE json;

ALTER TABLE indexing_models_fields ADD COLUMN allowed_values jsonb;

ALTER TABLE res_attachments ALTER COLUMN title TYPE text;

ALTER TABLE res_letterbox ADD COLUMN external_state jsonb DEFAULT '{}'::jsonb;

ALTER TABLE shippings ADD COLUMN history jsonb DEFAULT '[]'::jsonb;
ALTER TABLE shippings ADD COLUMN attachments jsonb DEFAULT '[]'::jsonb;
ALTER TABLE shippings ADD COLUMN sending_id character varying(64);
ALTER TABLE shippings ADD COLUMN action_id integer;

INSERT INTO configurations (privilege, value) VALUES ('admin_attachments_hosts', '{"nextcloud": {"byDefault": "", "username": "", "password": "", "url": "", "urlExpirationDate": "", "textAddedAboveURLS": ""}}');

UPDATE actions SET parameters = '{"keepCopyForRedirection": true, "keepDestForRedirection:": false, "keepOtherRoleForRedirection": true}' WHERE action_page ='redirect';

UPDATE parameters SET param_value_string = '2301.3.0' WHERE id = 'database_version';
