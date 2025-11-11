ALTER TABLE "security" RENAME COLUMN "maarch_comment" TO "mem_comment";
ALTER TABLE "status" DROP COLUMN IF EXISTS maarch_module;

INSERT INTO usergroups_services (group_id, service_id, parameters)
SELECT group_id, 'update_status_mail', '{"status": []}'::jsonb FROM usergroups
WHERE NOT EXISTS (
    SELECT 1 FROM usergroups_services WHERE group_id = usergroups.group_id AND service_id = 'update_status_mail'
);

UPDATE usergroups_services SET parameters = jsonb_set(
    parameters,
    '{status}',
    (SELECT jsonb_agg(id) FROM status),
    false
) WHERE service_id = 'update_status_mail';

UPDATE parameters SET param_value_string = '2505.0.1' WHERE id = 'database_version';
