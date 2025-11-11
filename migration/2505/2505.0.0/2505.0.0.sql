ALTER TABLE usergroups ADD COLUMN IF NOT EXISTS external_id jsonb DEFAULT '{}';

UPDATE parameters SET param_value_string = '2505.0.0' WHERE id = 'database_version';
