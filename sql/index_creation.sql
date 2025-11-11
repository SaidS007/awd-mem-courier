-- res_letterbox
CREATE INDEX IF NOT EXISTS type_id_idx ON res_letterbox (type_id);
CREATE INDEX IF NOT EXISTS typist_idx ON res_letterbox (typist);
CREATE INDEX IF NOT EXISTS doc_date_idx ON res_letterbox (doc_date);
CREATE INDEX IF NOT EXISTS status_idx ON res_letterbox (status);
CREATE INDEX IF NOT EXISTS destination_idx ON res_letterbox (destination);
CREATE INDEX IF NOT EXISTS initiator_idx ON res_letterbox (initiator);
CREATE INDEX IF NOT EXISTS dest_user_idx ON res_letterbox (dest_user);
CREATE INDEX IF NOT EXISTS res_letterbox_docserver_id_idx ON res_letterbox (docserver_id);
CREATE INDEX IF NOT EXISTS res_letterbox_filename_idx ON res_letterbox (filename);
CREATE INDEX IF NOT EXISTS res_departure_date_idx ON res_letterbox (departure_date);
CREATE INDEX IF NOT EXISTS res_barcode_idx ON res_letterbox (barcode);
CREATE INDEX IF NOT EXISTS category_id_idx ON res_letterbox (category_id);
CREATE INDEX IF NOT EXISTS alt_identifier_idx ON res_letterbox (alt_identifier);

-- res_attachments
CREATE INDEX IF NOT EXISTS res_id_idx ON res_attachments (res_id);
CREATE INDEX IF NOT EXISTS res_id_master_idx ON res_attachments (res_id_master);
CREATE INDEX IF NOT EXISTS res_att_external_id_idx ON res_attachments (external_id);
CREATE INDEX IF NOT EXISTS identifier_attachments_idx ON res_attachments (identifier);
CREATE INDEX IF NOT EXISTS docserver_id_idx ON res_attachments (docserver_id);
CREATE INDEX IF NOT EXISTS status_attachments_idx ON res_attachments (status);
CREATE INDEX IF NOT EXISTS attachment_type_idx ON res_attachments (attachment_type);

-- listinstance
CREATE INDEX IF NOT EXISTS res_id_listinstance_idx ON listinstance (res_id);
CREATE INDEX IF NOT EXISTS sequence_idx ON listinstance (sequence);
CREATE INDEX IF NOT EXISTS item_id_idx ON listinstance (item_id);
CREATE INDEX IF NOT EXISTS item_type_idx ON listinstance (item_type);
CREATE INDEX IF NOT EXISTS item_mode_idx ON listinstance (item_mode);
CREATE INDEX IF NOT EXISTS listinstance_difflist_type_idx ON listinstance (difflist_type);

-- contacts
CREATE INDEX IF NOT EXISTS firstname_idx ON contacts (firstname);
CREATE INDEX IF NOT EXISTS lastname_idx ON contacts (lastname);
CREATE INDEX IF NOT EXISTS company_idx ON contacts (company);

-- doctypes_first_level
CREATE INDEX IF NOT EXISTS doctypes_first_level_label_idx ON doctypes_first_level (doctypes_first_level_label);

-- doctypes_second_level
CREATE INDEX IF NOT EXISTS doctypes_second_level_label_idx ON doctypes_second_level (doctypes_second_level_label);

-- doctypes
CREATE INDEX IF NOT EXISTS description_idx ON doctypes (description);

-- entities
CREATE INDEX IF NOT EXISTS entity_label_idx ON entities (entity_label);
CREATE INDEX IF NOT EXISTS entity_id_idx ON entities (entity_id);
CREATE INDEX IF NOT EXISTS entity_folder_import_idx ON entities (folder_import);

-- folders
CREATE INDEX IF NOT EXISTS user_id_folders_idx ON folders (user_id);
CREATE INDEX IF NOT EXISTS parent_id_idx ON folders (parent_id);
-- resources_folders
CREATE INDEX IF NOT EXISTS folder_id_idx ON resources_folders (folder_id);
CREATE INDEX IF NOT EXISTS res_id_folders_idx ON resources_folders (res_id);

-- groupbasket_redirect
CREATE INDEX IF NOT EXISTS groupbasket_redirect_group_id_idx ON groupbasket_redirect (group_id);
CREATE INDEX IF NOT EXISTS groupbasket_redirect_basket_id_idx ON groupbasket_redirect (basket_id);

-- history
CREATE INDEX IF NOT EXISTS table_name_idx ON history (table_name);
CREATE INDEX IF NOT EXISTS record_id_idx ON history (record_id);
CREATE INDEX IF NOT EXISTS event_type_idx ON history (event_type);
CREATE INDEX IF NOT EXISTS user_id_idx ON history (user_id);

-- notes
CREATE INDEX IF NOT EXISTS identifier_idx ON notes (identifier);
CREATE INDEX IF NOT EXISTS notes_user_id_idx ON notes (user_id);

-- users
CREATE INDEX IF NOT EXISTS lastname_users_idx ON users (lastname);

-- listinstance_history_details
CREATE INDEX IF NOT EXISTS listinstance_history_id_idx ON listinstance_history_details (listinstance_history_id);

-- res_mark_as_read
CREATE INDEX IF NOT EXISTS user_id_res_mark_as_read_idx ON res_mark_as_read (user_id);

-- resource_contacts
CREATE INDEX IF NOT EXISTS resource_contacts_res_id_idx ON resource_contacts (res_id);
