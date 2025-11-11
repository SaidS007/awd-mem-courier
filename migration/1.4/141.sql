-------------------------------------------------
--      ADD COLUMN IN RM_DOCUMENTS TABLE       --
-------------------------------------------------

DROP VIEW IF EXISTS rm_documents_view;

ALTER TABLE rm_documents DROP COLUMN IF EXISTS arbox_id;
ALTER TABLE rm_documents ADD COLUMN arbox_id character varying(32) DEFAULT NULL::character varying;
ALTER TABLE rm_documents DROP COLUMN IF EXISTS arbatch_id;
ALTER TABLE rm_documents ADD COLUMN arbatch_id bigint;

-- RES_VIEW_RM

CREATE OR REPLACE VIEW rm_documents_view AS
SELECT
    rm_documents.*,

    rm_items.archival_agency_item_identifier,
    rm_items.description_language,
    rm_items.name,
    rm_items.item_type,
    rm_items.originating_agency_item_identifier,
    rm_items.service_level,
    rm_items.transferring_agency_item_identifier,
    rm_items.schedule_id,

    rm_content_descriptions.description as content_description,
    rm_content_descriptions.description_level,
    rm_content_descriptions.file_plan_position,
    rm_content_descriptions.language,
    rm_content_descriptions.latest_date,
    rm_content_descriptions.oldest_date,
    rm_content_descriptions.other_descriptive_data,

    rm_custodial_history.custodial_history_item,

    doctypes.description as type_label,

    doctypes_first_level.doctypes_first_level_id,
    doctypes_first_level.doctypes_first_level_label,
    doctypes_first_level.css_style as doctype_first_level_style,

    doctypes_second_level.doctypes_second_level_id,
    doctypes_second_level.doctypes_second_level_label,
    doctypes_second_level.css_style as doctype_second_level_style,

    file_plan_position.folders_system_id,

    schedule.folder_id as schedule_name,

    originating_agency.identification as originating_agency_identification,
    originating_agency.entity_id as originating_agency_entity_id,
    originating_agency.name as originating_agency_name,

    rm_contacts.department_name as dest_user,

    rm_appraisal_rules.code as appraisal_code,
    rm_appraisal_rules.duration as appraisal_duration,
    rm_appraisal_rules.start_date as appraisal_start_date,

    rm_access_restriction_rules.code as access_restriction_code,
    rm_access_restriction_rules.start_date as access_restriction_start_date

FROM rm_documents
         LEFT JOIN rm_items on rm_items.item_id = rm_documents.item_id
         LEFT JOIN rm_content_descriptions on rm_items.item_id = rm_content_descriptions.item_id
         LEFT JOIN rm_custodial_history on rm_items.item_id = rm_custodial_history.item_id
         LEFT JOIN doctypes on rm_documents.type_id = doctypes.type_id
         LEFT JOIN doctypes_first_level ON doctypes.doctypes_first_level_id = doctypes_first_level.doctypes_first_level_id
         LEFT JOIN doctypes_second_level ON doctypes.doctypes_second_level_id = doctypes_second_level.doctypes_second_level_id
         LEFT JOIN rm_organizations AS originating_agency ON originating_agency.organization_id =
                                                             (
                                                                 SELECT organization_id
                                                                 FROM rm_organizations
                                                                 WHERE rm_organizations.parent_id = rm_items.item_id AND rm_organizations.role = 'OriginatingAgency'
                                                                 ORDER BY organization_id
    LIMIT 1
    )
    LEFT JOIN rm_contacts on originating_agency.organization_id = rm_contacts.organization_id and contact_id =
    (
    SELECT contact_id
    FROM rm_contacts
    WHERE rm_contacts.organization_id = originating_agency.organization_id
    ORDER BY contact_id
    LIMIT 1
    )
    LEFT JOIN rm_appraisal_rules ON rm_appraisal_rules.parent_id = rm_items.item_id
    LEFT JOIN rm_access_restriction_rules ON rm_access_restriction_rules.parent_id = rm_items.item_id
    LEFT JOIN folders file_plan_position ON rm_content_descriptions.file_plan_position = file_plan_position.folder_id AND foldertype_id = '101'
    LEFT JOIN folders schedule ON rm_items.schedule_id = schedule.folders_system_id
WHERE item_type = 'ArchiveObject';