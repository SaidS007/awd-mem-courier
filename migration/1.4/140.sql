-- ************************************************************************* --
--                                                                           --
--                  RECORDS MANAGEMENT V1.0 DATABASE SCHEMA                  --
--                                                                           --
-- ************************************************************************* --

-- ************************************************************************* --
--                               DATA TABLES                                 --
-- ************************************************************************* --

-- ************************************************************************* --
--                             MESSAGES - IOS                                --
-- ************************************************************************* --
-- Records Management Messages
DROP TABLE IF EXISTS rm_ios CASCADE;
CREATE TABLE rm_ios
(
    io_id SERIAL NOT NULL,
    io_type character varying(100) NOT NULL,
    io_status character varying(10) NOT NULL,
    docserver_id character varying(32) NOT NULL DEFAULT 'IOS',
    io_path character varying(512),
    io_filename character varying(255),

    date timestamp without time zone NOT NULL,
    reply_code character varying(50),
    operation_date timestamp without time zone default null,
    related_identifier character varying(100),
    identifier character varying(100) NOT NULL,
    reference_identifier character varying(100),

    CONSTRAINT "rm_ios_pkey" PRIMARY KEY (io_id)
)
    WITH (
        OIDS=FALSE
        );

-- Message comments
DROP TABLE IF EXISTS rm_comments CASCADE;
CREATE TABLE rm_comments
(
    comment_id SERIAL,
    io_id bigint NOT NULL,

    comment text NOT NULL,
    date timestamp without time zone,
    author character varying(255),

    CONSTRAINT "rm_comments_pkey" PRIMARY KEY (comment_id)
)
    WITH (
        OIDS=FALSE
        );

-- ************************************************************************* --
--                           ARCHIVES AND OBJECTS                            --
-- ************************************************************************* --
-- Archives and ArchiveObjects
DROP TABLE IF EXISTS rm_items CASCADE;
CREATE TABLE rm_items
(
    item_id SERIAL,
    item_type character varying(50),
    parent_item_id bigint,
    schedule_id bigint,

    archival_agency_item_identifier character varying(100),
    archival_agreement character varying(100),
    archival_profile character varying(100),
    description_language text NOT NULL default 'fra',
    name text NOT NULL,
    originating_agency_item_identifier character varying(100),
    service_level text,
    transferring_agency_item_identifier character varying(100),

    CONSTRAINT "rm_items_pkey" PRIMARY KEY (item_id)
)
    WITH (
        OIDS=FALSE
        );

-- Archives and ArchiveObjects ContentDescription
DROP TABLE IF EXISTS rm_content_descriptions CASCADE;
CREATE TABLE rm_content_descriptions
(
    item_id bigint NOT NULL,

    description text,
    description_level character varying(50) NOT NULL DEFAULT 'recordgrp',
    file_plan_position text,
    language text NOT NULL DEFAULT 'fra',
    latest_date date,
    oldest_date date,
    other_descriptive_data text,

    CONSTRAINT "rm_content_descriptions_pkey" PRIMARY KEY (item_id)
)
    WITH (
        OIDS=FALSE
        );

-- ContentDescription CustodialHistory
DROP TABLE IF EXISTS rm_custodial_history CASCADE;
CREATE TABLE rm_custodial_history
(
    item_id bigint NOT NULL,
    "when" date,
    custodial_history_item text NOT NULL,

    CONSTRAINT "rm_custodial_history_pkey" PRIMARY KEY (item_id)
)
    WITH (
        OIDS=FALSE
        );


-- Archives and ArchiveObjects Appraisal Rules
DROP TABLE IF EXISTS rm_appraisal_rules CASCADE;
CREATE TABLE rm_appraisal_rules
(
    appraisal_rule_id SERIAL,
    parent_id bigint NOT NULL,
    parent_type character varying(50) NOT NULL,

    code character varying(50),
    duration integer,
    start_date date,

    CONSTRAINT "rm_appraisal_rules_pkey" PRIMARY KEY (appraisal_rule_id)
)
    WITH (
        OIDS=FALSE
        );

-- Archives and ArchiveObjects Access Restriction Rules
DROP TABLE IF EXISTS rm_access_restriction_rules CASCADE;
CREATE TABLE rm_access_restriction_rules
(
    access_restriction_rule_id SERIAL,
    parent_id bigint NOT NULL,
    parent_type character varying(50) NOT NULL,

    code character varying(50),
    start_date date,

    CONSTRAINT "rm_access_restriction_rules_pkey" PRIMARY KEY (access_restriction_rule_id)
)
    WITH (
        OIDS=FALSE
        );

-- Documents
DROP TABLE IF EXISTS rm_documents CASCADE;
CREATE TABLE rm_documents
(
    res_id SERIAL,
    coll_id character varying(32),
    docserver_id character varying(32) NOT NULL,
    path character varying(255) DEFAULT NULL,
    filename character varying(255) DEFAULT NULL,
    type_id bigint NOT NULL,
    item_id bigint,
    format character varying(50) NOT NULL,
    typist character varying(128) NOT NULL,
    offset_doc character varying(255) DEFAULT NULL,
    logical_adr character varying(255) DEFAULT NULL,
    policy_id character varying(32) DEFAULT NULL,
    cycle_id character varying(32) DEFAULT NULL,
    cycle_date timestamp without time zone,
    is_multi_docservers character(1) NOT NULL DEFAULT 'N'::bpchar,
    is_frozen character(1) NOT NULL DEFAULT 'N'::bpchar,
    publisher character varying(255) DEFAULT NULL::character varying,
    contributor character varying(255) DEFAULT NULL::character varying,
    author character varying(255) DEFAULT NULL::character varying,
    author_name text,
    identifier character varying(255) DEFAULT NULL::character varying,
    source character varying(255) DEFAULT NULL::character varying,
    coverage character varying(255) DEFAULT NULL::character varying,
    destination character varying(50) DEFAULT NULL::character varying,
    approver character varying(50) DEFAULT NULL::character varying,

    archival_agency_document_identifier character varying(100),
    copy character varying(1),
    creation_date timestamp without time zone,
    doc_date timestamp without time zone,
    description text,
    fingerprint character varying(64),
    issue timestamp without time zone,
    doc_language text not null default 'fra'::bpchar,
    originating_agency_document_identifier character varying(100),
    subject text,
    receipt timestamp without time zone,
    response timestamp without time zone,
    filesize bigint default 0,
    unit_code character varying(10) default 'A99',
    status character varying(50),
    submission timestamp without time zone,
    transferring_agency_document_identifier character varying(100),
    content_type character varying(10) DEFAULT 'CDO',

    CONSTRAINT "rm_documents_pkey" PRIMARY KEY (res_id)
)
    WITH (
        OIDS=FALSE
        );

DROP TABLE IF EXISTS adr_rm CASCADE;
CREATE TABLE adr_rm
(
    res_id bigint NOT NULL,
    docserver_id character varying(32) NOT NULL,
    path character varying(255) DEFAULT NULL::character varying,
    filename character varying(255) DEFAULT NULL::character varying,
    offset_doc character varying(255) DEFAULT NULL::character varying,
    fingerprint character varying(255) DEFAULT NULL::character varying,
    adr_priority integer NOT NULL,
    CONSTRAINT adr_rm_pkey PRIMARY KEY (res_id, docserver_id)
)
    WITH (OIDS=FALSE);

-- Archives and ArchiveObjects Keywords
DROP TABLE IF EXISTS rm_keywords CASCADE;
CREATE TABLE rm_keywords
(
    keyword_id SERIAL,
    item_id bigint,

    keyword_content text NOT NULL,
    role character varying(50),
    keyword_reference character varying(50),
    keyword_type character varying(50),

    CONSTRAINT "rm_keywords_pkey" PRIMARY KEY (keyword_id)
)
    WITH (
        OIDS=FALSE
        );

-- ************************************************************************* --
--                            ORGANIZATIONS                                  --
-- ************************************************************************* --
-- Organizations
DROP TABLE IF EXISTS rm_organizations CASCADE;
CREATE TABLE rm_organizations
(
    organization_id SERIAL,
    parent_id bigint NOT NULL, -- Id of parent
    parent_type character varying(50) NOT NULL, -- ArchiveTransfer, Archive, ArchiveObject, ArchiveTransferReply
    role character varying(50) NOT NULL,  -- TransferringAgency, ArchivalAgency, OriginatingAgency, Repository, ControlAuthority
    entity_id character varying(32), -- Entity_id if related to maarch entity

    business_type character varying(50),
    description character varying(255),
    identification character varying(100) NOT NULL,
    legal_classification character varying(50),
    name text,
    CONSTRAINT "rm_organizations_pkey" PRIMARY KEY (organization_id)
)
    WITH (
        OIDS=FALSE
        );

-- Addresses
DROP TABLE IF EXISTS rm_addresses CASCADE;
CREATE TABLE rm_addresses
(
    address_id SERIAL,
    parent_id bigint NOT NULL,
    parent_type character varying(50), -- TransferringAgency, Contact...
    entity_id character varying(32), -- Used if refAddress
    user_id character varying(128), -- Used if refAddress

    block_name character varying(255),
    building_name character varying(255),
    building_number character varying(255),
    city_name character varying(255),
    city_sub_division_name character varying(255),
    country character varying(50),
    floor_identification character varying(255),
    postcode character varying(50),
    post_office_box character varying(255),
    room_identification character varying(255),
    street_name character varying(255),

    CONSTRAINT "rm_addresses_pkey" PRIMARY KEY (address_id)
)
    WITH (
        OIDS=FALSE
        );

-- Contacts
DROP TABLE IF EXISTS rm_contacts CASCADE;
CREATE TABLE rm_contacts
(
    contact_id SERIAL,
    organization_id bigint NOT NULL,
    user_id character varying(128), -- User_id of related to Maarch user

    department_name character varying(255),
    identification character varying(100),
    person_name character varying(255),
    responsibility character varying(255),

    CONSTRAINT "rm_contacts_pkey" PRIMARY KEY (contact_id)
)
    WITH (
        OIDS=FALSE
        );

-- ************************************************************************* --
--                                RELATIONS                                  --
-- ************************************************************************* --
-- Relation between ios and archives
DROP TABLE IF EXISTS rm_io_archives_relations CASCADE;
CREATE TABLE rm_io_archives_relations
(
    io_id bigint NOT NULL,
    item_id bigint NOT NULL,

    CONSTRAINT "rm_io_archives_relations_pkey" PRIMARY KEY (io_id, item_id)
)
    WITH (
        OIDS=FALSE
        );


-- ************************************************************************* --
--                                ENTITIES                                   --
-- ************************************************************************* --
DROP TABLE IF EXISTS rm_entities CASCADE;
CREATE TABLE rm_entities
(
    entity_id character varying(32) NOT NULL,
    is_archival_agency character varying(1) NOT NULL DEFAULT 'N'::bpchar,
    is_originating_agency character varying(1) NOT NULL DEFAULT 'N'::bpchar,
    is_transferring_agency character varying(1) NOT NULL DEFAULT 'N'::bpchar,
    is_repository character varying(1) NOT NULL DEFAULT 'N'::bpchar,
    is_control_authority character varying(1) NOT NULL DEFAULT 'N'::bpchar,
    rm_entity_type character varying(50) NOT NULL DEFAULT 'CollectivitÃ©'::bpchar,
    parallel_forms_of_names text,
    other_normalized_names text,
    other_names text,
    oldest_date date,
    latest_date date,
    history text,
    places text,
    legal_status text,
    activities text,
    mandates text,
    structure text,
    context text,
    record_id character varying(100),
    institution_id character varying(255),
    rules text,
    status character varying(255),
    detail_level character varying(255),
    maintenance_dates text,
    description_language character varying(100),
    sources text,
    maintenance_notes text,
    CONSTRAINT "rm_entities_pkey" PRIMARY KEY (entity_id)
)
    WITH (
        OIDS=FALSE
        );

-- ************************************************************************* --
--                             AGREEMENTS                                    --
-- ************************************************************************* --
DROP TABLE IF EXISTS rm_agreements CASCADE;
CREATE TABLE rm_agreements
(
    agreement_id SERIAL,
    identifier character varying(100) NOT NULL,
    description character varying(255) NOT NULL,
    comment TEXT,
    archival_profile character varying(50) NOT NULL,
    archival_entity_id character varying(100) NOT NULL,
    transferring_entity_id character varying(100) NOT NULL,
    begin_date date NOT NULL,
    end_date date NOT NULL,
    coll_id character varying(50) NOT NULL,
    allowed_file_types TEXT NOT NULL,
    transfer_max_size bigint NOT NULL DEFAULT 100000,
    transfer_max_item integer NOT NULL DEFAULT 300,
    transfer_count integer,
    transfer_count_period character varying(20) DEFAULT 'MONTH'::bpchar,
    transfer_total_size bigint NOT NULL DEFAULT 100000000,
    is_enabled character(1) NOT NULL DEFAULT 'Y'::bpchar,
    CONSTRAINT "rm_agreements_pkey" PRIMARY KEY (agreement_id)
)
    WITH (
        OIDS=FALSE
        );

-- ************************************************************************* --
--                             SCHEDULE                                    --
-- ************************************************************************* --
DROP TABLE IF EXISTS rm_schedule CASCADE;
CREATE TABLE rm_schedule
(
    type_id bigint not null,
    appraisal_code character varying(50) NOT NULL,
    appraisal_duration integer NOT NULL,
    access_restriction_code character varying(50) NOT NULL,
    service_level character varying(50),
    notes text,
    CONSTRAINT "rm_schedule_pkey" PRIMARY KEY (type_id)
)
    WITH (
        OIDS=FALSE
        );

-- ************************************************************************* --
--                                  VUES                                     --
-- ************************************************************************* --

-- Entities to organizations
DROP VIEW IF EXISTS rm_ref_organizations CASCADE;
CREATE OR REPLACE VIEW rm_ref_organizations AS
SELECT
    entities.entity_id,
    null as business_type,
    null as description,
    business_id as identification,
    null as legal_classification,
    entity_label as name,
    null as organization_id,
    null as parent_id,
    null as parent_type,
    'TransferringAgency' as role
FROM entities
         JOIN rm_entities ON entities.entity_id = rm_entities.entity_id
WHERE business_id != '' AND is_transferring_agency = 'Y'
UNION
SELECT
    entities.entity_id,
    null as business_type,
    null as description,
    business_id as identification,
    null as legal_classification,
    entity_label as name,
    null as organization_id,
    null as parent_id,
    null as parent_type,
    'ArchivalAgency' as role
FROM entities
         JOIN rm_entities ON entities.entity_id = rm_entities.entity_id
WHERE business_id != '' AND is_archival_agency = 'Y'
UNION
SELECT
    entities.entity_id,
    null as business_type,
    null as description,
    business_id as identification,
    null as legal_classification,
    entity_label as name,
    null as organization_id,
    null as parent_id,
    null as parent_type,
    'OriginatingAgency' as role
FROM entities
         JOIN rm_entities ON entities.entity_id = rm_entities.entity_id
WHERE business_id != '' AND business_id != '' AND is_originating_agency = 'Y'
UNION
SELECT
    entities.entity_id,
    null as business_type,
    null as description,
    business_id as identification,
    null as legal_classification,
    entity_label as name,
    null as organization_id,
    null as parent_id,
    null as parent_type,
    'Repository' as role
FROM entities
         JOIN rm_entities ON entities.entity_id = rm_entities.entity_id
WHERE business_id != '' AND is_repository = 'Y'
UNION
SELECT
    entities.entity_id,
    null as business_type,
    null as description,
    business_id as identification,
    null as legal_classification,
    entity_label as name,
    null as organization_id,
    null as parent_id,
    null as parent_type,
    'ControlAuthority' as role
FROM entities
         JOIN rm_entities ON entities.entity_id = rm_entities.entity_id
WHERE business_id != '' AND is_control_authority = 'Y';

-- Entities/contacts to addresses
DROP VIEW IF EXISTS rm_ref_addresses CASCADE;
CREATE OR REPLACE VIEW rm_ref_addresses AS
SELECT
    null as address_id,
    null as parent_id,
    null as parent_type,
    entity_id,
    '*' as user_id,
    adrs_1 as street_name,
    adrs_2 as block_name,
    adrs_3 as post_office_box,
    zipcode as postcode,
    city as city_name,

    null as building_name,
    null as building_number,
    null as city_sub_division_name,
    null as country,
    null as floor_identification,
    null as room_identification
FROM entities
WHERE adrs_1 != '' OR adrs_1 != '' OR adrs_2 != '' OR adrs_3 != '' OR city != ''
UNION
SELECT
    null as address_id,
    null as parent_id,
    null as parent_type,
    entities.entity_id,
    users.user_id,
    adrs_1 as street_name,
    adrs_2 as block_name,
    adrs_3 as post_office_box,
    zipcode as postcode,
    city as city_name,
    entity_label as room_identification,

    null as building_name,
    null as building_number,
    null as city_sub_division_name,
    null as country,
    null as floor_identification
FROM users
         LEFT JOIN users_entities ON users.user_id = users_entities.user_id
         LEFT JOIN entities ON users_entities.entity_id = entities.entity_id
WHERE adrs_1 != '' OR adrs_1 != '' OR adrs_2 != '' OR adrs_3 != '' OR city != '';

-- Users to Contacts
DROP VIEW IF EXISTS rm_ref_contacts;
CREATE OR REPLACE VIEW rm_ref_contacts AS
SELECT
    users.user_id,
    NULL::bpchar AS contact_id,
        NULL::bpchar AS organization_id,
        NULL::bpchar AS identification,
        entities.entity_label AS department_name,
    users_entities.user_role AS responsibility,
    (users.firstname::text || ' '::text) || users.lastname::text AS person_name
FROM users
         JOIN users_entities ON users.user_id::text = users_entities.user_id::text
    JOIN entities ON users_entities.entity_id::text = entities.entity_id::text;

-- RM_IOS
DROP VIEW IF EXISTS rm_ios_view;
CREATE OR REPLACE VIEW rm_ios_view AS
SELECT
    rm_ios.*,
    ArchivalAgency.entity_id AS archival_agency_entity_id,
    ArchivalContact.user_id AS archival_user_id,
    RequestingAgency.entity_id AS requesting_agency_entity_id,
    RequestingContact.user_id AS requesting_user_id,
    rm_comments.comment AS comment,
    Archives.name as archive_name,
    count(ArchiveObjects) as nb_archive_objects
FROM rm_ios
         LEFT JOIN rm_organizations AS ArchivalAgency ON ArchivalAgency.parent_id = rm_ios.io_id AND ArchivalAgency.role = 'ArchivalAgency'
         LEFT JOIN rm_contacts AS ArchivalContact ON ArchivalContact.organization_id =
                                                     (
                                                         SELECT organization_id
                                                         FROM rm_contacts
                                                         WHERE rm_contacts.organization_id = ArchivalAgency.organization_id
                                                         ORDER BY contact_id
    LIMIT 1
    )
    LEFT JOIN rm_organizations AS RequestingAgency ON RequestingAgency.parent_id = rm_ios.io_id AND RequestingAgency.role IN ('TransferringAgency', 'RequestingAgency')
    LEFT JOIN rm_contacts AS RequestingContact ON RequestingContact.organization_id =
    (
    SELECT organization_id
    FROM rm_contacts
    WHERE rm_contacts.organization_id = RequestingAgency.organization_id
    ORDER BY contact_id
    LIMIT 1
    )

    LEFT JOIN rm_io_archives_relations IOArchives ON IOArchives.io_id = rm_ios.io_id
    LEFT JOIN rm_items AS Archives ON Archives.item_id = IOArchives.item_id
    LEFT JOIN rm_items AS ArchiveObjects ON ArchiveObjects.parent_item_id = Archives.item_id
    LEFT JOIN rm_comments ON rm_comments.io_id =
    (
    SELECT io_id
    FROM rm_comments
    WHERE rm_comments.io_id = rm_ios.io_id
    ORDER BY comment_id
    LIMIT 1
    )
GROUP BY
    rm_ios.io_id,
    rm_ios.io_type,
    rm_ios.io_status,
    rm_ios.docserver_id,
    rm_ios.io_path,
    rm_ios.io_filename,
    rm_ios.date,
    rm_ios.reply_code,
    rm_ios.operation_date,
    rm_ios.related_identifier,
    rm_ios.identifier,
    rm_ios.reference_identifier,
    ArchivalAgency.entity_id,
    RequestingAgency.entity_id,
    ArchivalContact.user_id,
    RequestingContact.user_id,
    Archives.Name,
    rm_comments.comment;


-- RES_VIEW_RM
DROP VIEW IF EXISTS rm_documents_view;
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

--DATA
update groupbasket set result_page = 'list_with_attachments' where result_page = 'auth_dep';

-- log collection
-- res_log
DROP TABLE IF EXISTS res_log CASCADE;
CREATE TABLE res_log
(
    res_id SERIAL,
    title character varying(255) DEFAULT NULL::character varying,
    subject text,
    description text,
    publisher character varying(255) DEFAULT NULL::character varying,
    contributor character varying(255) DEFAULT NULL::character varying,
    type_id bigint NOT NULL,
    format character varying(50) NOT NULL,
    typist character varying(128) NOT NULL,
    creation_date timestamp without time zone NOT NULL,
    fulltext_result character varying(10) DEFAULT NULL,
    ocr_result character varying(10) DEFAULT NULL,
    converter_result character varying(10) DEFAULT NULL,
    author character varying(255) DEFAULT NULL::character varying,
    author_name text,
    identifier character varying(255) DEFAULT NULL::character varying,
    source character varying(255) DEFAULT NULL::character varying,
    doc_language character varying(50) DEFAULT NULL::character varying,
    relation bigint,
    coverage character varying(255) DEFAULT NULL::character varying,
    doc_date timestamp without time zone,
    docserver_id character varying(32) NOT NULL,
    folders_system_id bigint,
    arbox_id character varying(32) DEFAULT NULL::character varying,
    path character varying(255) DEFAULT NULL::character varying,
    filename character varying(255) DEFAULT NULL::character varying,
    offset_doc character varying(255) DEFAULT NULL::character varying,
    logical_adr character varying(255) DEFAULT NULL::character varying,
    fingerprint character varying(255) DEFAULT NULL::character varying,
    filesize bigint,
    is_paper character(1) DEFAULT NULL::bpchar,
    page_count integer,
    scan_date timestamp without time zone,
    scan_user character varying(50) DEFAULT NULL::character varying,
    scan_location character varying(255) DEFAULT NULL::character varying,
    scan_wkstation character varying(255) DEFAULT NULL::character varying,
    scan_batch character varying(50) DEFAULT NULL::character varying,
    burn_batch character varying(50) DEFAULT NULL::character varying,
    scan_postmark character varying(50) DEFAULT NULL::character varying,
    envelop_id bigint,
    status character varying(10) NOT NULL,
    destination character varying(50) DEFAULT NULL::character varying,
    approver character varying(50) DEFAULT NULL::character varying,
    validation_date timestamp without time zone,
    work_batch bigint,
    origin character varying(50) DEFAULT NULL::character varying,
    is_ingoing character(1) DEFAULT NULL::bpchar,
    priority smallint,
    arbatch_id bigint DEFAULT NULL,
    policy_id character varying(32) DEFAULT NULL::character varying,
    cycle_id character varying(32) DEFAULT NULL::character varying,
    cycle_date timestamp without time zone,
    is_multi_docservers character(1) NOT NULL DEFAULT 'N'::bpchar,
    is_frozen character(1) NOT NULL DEFAULT 'N'::bpchar,
    custom_t1 text,
    custom_n1 bigint,
    custom_f1 numeric,
    custom_d1 timestamp without time zone,
    custom_t2 character varying(255) DEFAULT NULL::character varying,
    custom_n2 bigint,
    custom_f2 numeric,
    custom_d2 timestamp without time zone,
    custom_t3 character varying(255) DEFAULT NULL::character varying,
    custom_n3 bigint,
    custom_f3 numeric,
    custom_d3 timestamp without time zone,
    custom_t4 character varying(255) DEFAULT NULL::character varying,
    custom_n4 bigint,
    custom_f4 numeric,
    custom_d4 timestamp without time zone,
    custom_t5 character varying(255) DEFAULT NULL::character varying,
    custom_n5 bigint,
    custom_f5 numeric,
    custom_d5 timestamp without time zone,
    custom_t6 character varying(255) DEFAULT NULL::character varying,
    custom_d6 timestamp without time zone,
    custom_t7 character varying(255) DEFAULT NULL::character varying,
    custom_d7 timestamp without time zone,
    custom_t8 character varying(255) DEFAULT NULL::character varying,
    custom_d8 timestamp without time zone,
    custom_t9 character varying(255) DEFAULT NULL::character varying,
    custom_d9 timestamp without time zone,
    custom_t10 character varying(255) DEFAULT NULL::character varying,
    custom_d10 timestamp without time zone,
    custom_t11 character varying(255) DEFAULT NULL::character varying,
    custom_t12 character varying(255) DEFAULT NULL::character varying,
    custom_t13 character varying(255) DEFAULT NULL::character varying,
    custom_t14 character varying(255) DEFAULT NULL::character varying,
    custom_t15 character varying(255) DEFAULT NULL::character varying,
    tablename character varying(32) DEFAULT 'res_log'::character varying,
    initiator character varying(50) DEFAULT NULL::character varying,
    dest_user character varying(128) DEFAULT NULL::character varying,
    video_batch integer DEFAULT NULL,
    video_time integer DEFAULT NULL,
    video_user character varying(128)  DEFAULT NULL,
    video_date timestamp without time zone,
    esign_proof_id character varying(255),
    esign_proof_content text,
    esign_content text,
    esign_date timestamp without time zone,
    CONSTRAINT res_log_pkey PRIMARY KEY  (res_id)
)
    WITH (OIDS=FALSE);

DROP TABLE IF EXISTS adr_log;
CREATE TABLE adr_log
(
    res_id bigint NOT NULL,
    docserver_id character varying(32) NOT NULL,
    path character varying(255) DEFAULT NULL::character varying,
    filename character varying(255) DEFAULT NULL::character varying,
    offset_doc character varying(255) DEFAULT NULL::character varying,
    fingerprint character varying(255) DEFAULT NULL::character varying,
    adr_priority integer NOT NULL,
    CONSTRAINT adr_log_pkey PRIMARY KEY (res_id, docserver_id)
)
    WITH (OIDS=FALSE);

DROP VIEW IF EXISTS res_view_log;
CREATE OR REPLACE VIEW res_view_log AS
select * from res_log;


-- ************************************************************************* --
--                                                                           --
--               ENTITIES - LISTINSTANCE ROLES                                 --
--                                                                           --
-- ************************************************************************* --

DROP TABLE IF EXISTS difflist_types;
CREATE TABLE difflist_types
(
    difflist_type_id character varying(50) NOT NULL,
    difflist_type_label character varying(100) NOT NULL,
    difflist_type_roles TEXT,
    allow_entities character varying(1) NOT NULL DEFAULT 'N'::bpchar,
    is_system character varying(1) NOT NULL DEFAULT 'N'::bpchar,
    CONSTRAINT "difflist_types_pkey" PRIMARY KEY (difflist_type_id)
)
    WITH (
        OIDS=FALSE
        );

--DATA
INSERT INTO difflist_types (difflist_type_id, difflist_type_label, difflist_type_roles, allow_entities, is_system) VALUES ('entity_id', 'Diffusion aux services', 'dest copy', 'Y', 'Y');
INSERT INTO difflist_types (difflist_type_id, difflist_type_label, difflist_type_roles, allow_entities, is_system) VALUES ('type_id', 'Diffusion selon le type de document', 'dest copy', 'Y', 'Y');
INSERT INTO difflist_types (difflist_type_id, difflist_type_label, difflist_type_roles, allow_entities, is_system) VALUES ('foldertype_id', 'Diffusion selon le type de dossiers', 'dest copy', 'Y', 'Y');

ALTER TABLE listinstance DROP COLUMN IF EXISTS visible;
alter table listinstance add column visible character varying(1) NOT NULL DEFAULT 'Y'::bpchar;
ALTER TABLE listinstance DROP COLUMN IF EXISTS difflist_type;
alter table listinstance add column difflist_type character varying(50);

ALTER TABLE listmodels DROP COLUMN IF EXISTS description;
alter table listmodels add column description character varying(255);
ALTER TABLE listmodels DROP COLUMN IF EXISTS visible;
alter table listmodels add column visible character varying(1) NOT NULL DEFAULT 'Y'::bpchar;

--DATA
-- Add mandatory description to listmodels (entity_id)
UPDATE listmodels SET description = entity_label FROM entities WHERE listmodels.object_id = entities.entity_id AND object_type = 'entity_id';

DROP TABLE IF EXISTS groupbasket_difflist_types;
CREATE TABLE groupbasket_difflist_types
(
    system_id serial NOT NULL,
    group_id character varying(32) NOT NULL,
    basket_id character varying(32) NOT NULL,
    action_id integer NOT NULL,
    difflist_type_id character varying(50) NOT NULL,
    CONSTRAINT groupbasket_difflist_types_pkey PRIMARY KEY (system_id )
)
    WITH (
        OIDS=FALSE
        );

DROP TABLE IF EXISTS groupbasket_difflist_roles;
CREATE TABLE groupbasket_difflist_roles
(
    system_id serial NOT NULL,
    group_id character varying(32) NOT NULL,
    basket_id character varying(32) NOT NULL,
    action_id integer NOT NULL,
    difflist_role_id character varying(50) NOT NULL,
    CONSTRAINT groupbasket_difflist_roles_pkey PRIMARY KEY (system_id)
)
    WITH (
        OIDS=FALSE
        );

-- ************************************************************************* --
--                                                                           --
--                               FOLDER'S WORKFLOW                           --
--                                                                           --
-- ************************************************************************* --
DROP VIEW IF EXISTS view_postindexing;
DROP VIEW IF EXISTS res_view_letterbox CASCADE;
DROP VIEW IF EXISTS view_folders;

-- actions
ALTER TABLE actions DROP COLUMN IF EXISTS is_folder_action;
ALTER TABLE actions ADD COLUMN is_folder_action character(1) NOT NULL default 'N'::bpchar;

-- baskets
ALTER TABLE baskets DROP COLUMN IF EXISTS is_folder_basket;
ALTER TABLE baskets ADD COLUMN is_folder_basket character(1) NOT NULL default 'N'::bpchar;

-- groupbasket
ALTER TABLE groupbasket DROP COLUMN IF EXISTS list_lock_clause;
ALTER TABLE groupbasket ADD COLUMN list_lock_clause text;
ALTER TABLE groupbasket DROP COLUMN IF EXISTS sublist_lock_clause;
ALTER TABLE groupbasket ADD COLUMN sublist_lock_clause text;

-- folder
ALTER TABLE folders DROP COLUMN IF EXISTS destination;
ALTER TABLE folders ADD COLUMN destination character varying(50) DEFAULT NULL;
ALTER TABLE folders DROP COLUMN IF EXISTS dest_user;
ALTER TABLE folders ADD COLUMN dest_user character varying(128) DEFAULT NULL;
ALTER TABLE folders ALTER COLUMN status SET DEFAULT 'FOLDNEW'::character varying;

-- status
ALTER TABLE status DROP COLUMN IF EXISTS is_folder_status;
ALTER TABLE status ADD COLUMN is_folder_status character(1) NOT NULL default 'N'::bpchar;

-- View folders
DROP VIEW IF EXISTS view_folders;
CREATE OR REPLACE VIEW view_folders AS
SELECT folders.folders_system_id, folders.folder_id, folders.foldertype_id, foldertypes.foldertype_label, (folders.folder_id::text || ':'::text) || folders.folder_name::text AS folder_full_label, folders.parent_id, folders.folder_name, folders.subject, folders.description, folders.author, folders.typist, folders.status, folders.folder_level, folders.creation_date, folders.destination, folders.dest_user, folders.folder_out_id, folders.custom_t1, folders.custom_n1, folders.custom_f1, folders.custom_d1, folders.custom_t2, folders.custom_n2, folders.custom_f2, folders.custom_d2, folders.custom_t3, folders.custom_n3, folders.custom_f3, folders.custom_d3, folders.custom_t4, folders.custom_n4, folders.custom_f4, folders.custom_d4, folders.custom_t5, folders.custom_n5, folders.custom_f5, folders.custom_d5, folders.custom_t6, folders.custom_d6, folders.custom_t7, folders.custom_d7, folders.custom_t8, folders.custom_d8, folders.custom_t9, folders.custom_d9, folders.custom_t10, folders.custom_d10, folders.custom_t11, folders.custom_d11, folders.custom_t12, folders.custom_d12, folders.custom_t13, folders.custom_d13, folders.custom_t14, folders.custom_d14, folders.custom_t15, folders.is_complete, folders.is_folder_out, folders.last_modified_date, folders.video_status
FROM foldertypes, folders
WHERE folders.foldertype_id = foldertypes.foldertype_id;

-- ************************************************************************* --
--                                                                           --
--                               BUSINESS COLLECTION                          --
--                                                                           --
-- ************************************************************************* --

DROP TABLE IF EXISTS res_business CASCADE;
CREATE TABLE res_business
(
    res_id SERIAL,
    title character varying(255) DEFAULT NULL::character varying,
    subject text,
    description text,
    publisher character varying(255) DEFAULT NULL::character varying,
    contributor character varying(255) DEFAULT NULL::character varying,
    type_id bigint NOT NULL,
    format character varying(50) NOT NULL,
    typist character varying(128) NOT NULL,
    creation_date timestamp without time zone NOT NULL,
    fulltext_result character varying(10) DEFAULT NULL,
    ocr_result character varying(10) DEFAULT NULL,
    converter_result character varying(10) DEFAULT NULL,
    author character varying(255) DEFAULT NULL::character varying,
    author_name text,
    identifier character varying(255) DEFAULT NULL::character varying,
    source character varying(255) DEFAULT NULL::character varying,
    doc_language character varying(50) DEFAULT NULL::character varying,
    relation bigint,
    coverage character varying(255) DEFAULT NULL::character varying,
    doc_date timestamp without time zone,
    docserver_id character varying(32) NOT NULL,
    folders_system_id bigint,
    arbox_id character varying(32) DEFAULT NULL::character varying,
    path character varying(255) DEFAULT NULL::character varying,
    filename character varying(255) DEFAULT NULL::character varying,
    offset_doc character varying(255) DEFAULT NULL::character varying,
    logical_adr character varying(255) DEFAULT NULL::character varying,
    fingerprint character varying(255) DEFAULT NULL::character varying,
    filesize bigint,
    is_paper character(1) DEFAULT NULL::bpchar,
    page_count integer,
    scan_date timestamp without time zone,
    scan_user character varying(50) DEFAULT NULL::character varying,
    scan_location character varying(255) DEFAULT NULL::character varying,
    scan_wkstation character varying(255) DEFAULT NULL::character varying,
    scan_batch character varying(50) DEFAULT NULL::character varying,
    burn_batch character varying(50) DEFAULT NULL::character varying,
    scan_postmark character varying(50) DEFAULT NULL::character varying,
    envelop_id bigint,
    status character varying(10) NOT NULL,
    destination character varying(50) DEFAULT NULL::character varying,
    approver character varying(50) DEFAULT NULL::character varying,
    validation_date timestamp without time zone,
    work_batch bigint,
    origin character varying(50) DEFAULT NULL::character varying,
    is_ingoing character(1) DEFAULT NULL::bpchar,
    priority smallint,
    arbatch_id bigint DEFAULT NULL,
    policy_id character varying(32) DEFAULT NULL::character varying,
    cycle_id character varying(32) DEFAULT NULL::character varying,
    cycle_date timestamp without time zone,
    is_multi_docservers character(1) NOT NULL DEFAULT 'N'::bpchar,
    is_frozen character(1) NOT NULL DEFAULT 'N'::bpchar,
    custom_t1 text,
    custom_n1 bigint,
    custom_f1 numeric,
    custom_d1 timestamp without time zone,
    custom_t2 character varying(255) DEFAULT NULL::character varying,
    custom_n2 bigint,
    custom_f2 numeric,
    custom_d2 timestamp without time zone,
    custom_t3 character varying(255) DEFAULT NULL::character varying,
    custom_n3 bigint,
    custom_f3 numeric,
    custom_d3 timestamp without time zone,
    custom_t4 character varying(255) DEFAULT NULL::character varying,
    custom_n4 bigint,
    custom_f4 numeric,
    custom_d4 timestamp without time zone,
    custom_t5 character varying(255) DEFAULT NULL::character varying,
    custom_n5 bigint,
    custom_f5 numeric,
    custom_d5 timestamp without time zone,
    custom_t6 character varying(255) DEFAULT NULL::character varying,
    custom_d6 timestamp without time zone,
    custom_t7 character varying(255) DEFAULT NULL::character varying,
    custom_d7 timestamp without time zone,
    custom_t8 character varying(255) DEFAULT NULL::character varying,
    custom_d8 timestamp without time zone,
    custom_t9 character varying(255) DEFAULT NULL::character varying,
    custom_d9 timestamp without time zone,
    custom_t10 character varying(255) DEFAULT NULL::character varying,
    custom_d10 timestamp without time zone,
    custom_t11 character varying(255) DEFAULT NULL::character varying,
    custom_t12 character varying(255) DEFAULT NULL::character varying,
    custom_t13 character varying(255) DEFAULT NULL::character varying,
    custom_t14 character varying(255) DEFAULT NULL::character varying,
    custom_t15 character varying(255) DEFAULT NULL::character varying,
    tablename character varying(32) DEFAULT 'res_business'::character varying,
    initiator character varying(50) DEFAULT NULL::character varying,
    dest_user character varying(128) DEFAULT NULL::character varying,
    video_batch integer DEFAULT NULL,
    video_time integer DEFAULT NULL,
    video_user character varying(128)  DEFAULT NULL,
    video_date timestamp without time zone,
    esign_proof_id character varying(255),
    esign_proof_content text,
    esign_content text,
    esign_date timestamp without time zone,
    CONSTRAINT res_business_pkey PRIMARY KEY  (res_id)
)
    WITH (OIDS=FALSE);

DROP TABLE IF EXISTS adr_business;
CREATE TABLE adr_business
(
    res_id bigint NOT NULL,
    docserver_id character varying(32) NOT NULL,
    path character varying(255) DEFAULT NULL::character varying,
    filename character varying(255) DEFAULT NULL::character varying,
    offset_doc character varying(255) DEFAULT NULL::character varying,
    fingerprint character varying(255) DEFAULT NULL::character varying,
    adr_priority integer NOT NULL,
    CONSTRAINT adr_business_pkey PRIMARY KEY (res_id, docserver_id)
)
    WITH (OIDS=FALSE);

DROP TABLE IF EXISTS res_version_business;
CREATE TABLE res_version_business
(
    res_id serial,
    title character varying(255) DEFAULT NULL::character varying,
    subject text,
    description text,
    publisher character varying(255) DEFAULT NULL::character varying,
    contributor character varying(255) DEFAULT NULL::character varying,
    type_id bigint NOT NULL,
    format character varying(50) NOT NULL,
    typist character varying(128) NOT NULL,
    creation_date timestamp without time zone NOT NULL,
    fulltext_result character varying(10) DEFAULT NULL::character varying,
    ocr_result character varying(10) DEFAULT NULL::character varying,
    converter_result character varying(10) DEFAULT NULL::character varying,
    author character varying(255) DEFAULT NULL::character varying,
    author_name text,
    identifier character varying(255) DEFAULT NULL::character varying,
    source character varying(255) DEFAULT NULL::character varying,
    doc_language character varying(50) DEFAULT NULL::character varying,
    relation bigint,
    coverage character varying(255) DEFAULT NULL::character varying,
    doc_date timestamp without time zone,
    docserver_id character varying(32) NOT NULL,
    folders_system_id bigint,
    arbox_id character varying(32) DEFAULT NULL::character varying,
    path character varying(255) DEFAULT NULL::character varying,
    filename character varying(255) DEFAULT NULL::character varying,
    offset_doc character varying(255) DEFAULT NULL::character varying,
    logical_adr character varying(255) DEFAULT NULL::character varying,
    fingerprint character varying(255) DEFAULT NULL::character varying,
    filesize bigint,
    is_paper character(1) DEFAULT NULL::bpchar,
    page_count integer,
    scan_date timestamp without time zone,
    scan_user character varying(50) DEFAULT NULL::character varying,
    scan_location character varying(255) DEFAULT NULL::character varying,
    scan_wkstation character varying(255) DEFAULT NULL::character varying,
    scan_batch character varying(50) DEFAULT NULL::character varying,
    burn_batch character varying(50) DEFAULT NULL::character varying,
    scan_postmark character varying(50) DEFAULT NULL::character varying,
    envelop_id bigint,
    status character varying(10) NOT NULL,
    destination character varying(50) DEFAULT NULL::character varying,
    approver character varying(50) DEFAULT NULL::character varying,
    validation_date timestamp without time zone,
    work_batch bigint,
    origin character varying(50) DEFAULT NULL::character varying,
    is_ingoing character(1) DEFAULT NULL::bpchar,
    priority smallint,
    arbatch_id bigint,
    policy_id character varying(32),
    cycle_id character varying(32),
    is_multi_docservers character(1) NOT NULL DEFAULT 'N'::bpchar,
    is_frozen character(1) NOT NULL DEFAULT 'N'::bpchar,
    custom_t1 text,
    custom_n1 bigint,
    custom_f1 numeric,
    custom_d1 timestamp without time zone,
    custom_t2 character varying(255) DEFAULT NULL::character varying,
    custom_n2 bigint,
    custom_f2 numeric,
    custom_d2 timestamp without time zone,
    custom_t3 character varying(255) DEFAULT NULL::character varying,
    custom_n3 bigint,
    custom_f3 numeric,
    custom_d3 timestamp without time zone,
    custom_t4 character varying(255) DEFAULT NULL::character varying,
    custom_n4 bigint,
    custom_f4 numeric,
    custom_d4 timestamp without time zone,
    custom_t5 character varying(255) DEFAULT NULL::character varying,
    custom_n5 bigint,
    custom_f5 numeric,
    custom_d5 timestamp without time zone,
    custom_t6 character varying(255) DEFAULT NULL::character varying,
    custom_d6 timestamp without time zone,
    custom_t7 character varying(255) DEFAULT NULL::character varying,
    custom_d7 timestamp without time zone,
    custom_t8 character varying(255) DEFAULT NULL::character varying,
    custom_d8 timestamp without time zone,
    custom_t9 character varying(255) DEFAULT NULL::character varying,
    custom_d9 timestamp without time zone,
    custom_t10 character varying(255) DEFAULT NULL::character varying,
    custom_d10 timestamp without time zone,
    custom_t11 character varying(255) DEFAULT NULL::character varying,
    custom_t12 character varying(255) DEFAULT NULL::character varying,
    custom_t13 character varying(255) DEFAULT NULL::character varying,
    custom_t14 character varying(255) DEFAULT NULL::character varying,
    custom_t15 character varying(255) DEFAULT NULL::character varying,
    tablename character varying(32) DEFAULT 'res_version_business'::character varying,
    initiator character varying(50) DEFAULT NULL::character varying,
    dest_user character varying(128) DEFAULT NULL::character varying,
    video_batch integer,
    video_time integer,
    video_user character varying(128) DEFAULT NULL::character varying,
    video_date timestamp without time zone,
    cycle_date timestamp without time zone,
    coll_id character varying(32) NOT NULL,
    res_id_master bigint,
    CONSTRAINT res_version_business_pkey PRIMARY KEY (res_id)
)
    WITH (
        OIDS=FALSE
        );

DROP TABLE IF EXISTS business_coll_ext CASCADE;
CREATE TABLE business_coll_ext (
                                   res_id bigint NOT NULL,
                                   category_id character varying(50)  NOT NULL,
                                   contact_id integer default NULL,
                                   currency character varying(10) default NULL,
                                   net_sum float default NULL,
                                   tax_sum float default NULL,
                                   total_sum float default NULL,
                                   process_limit_date timestamp without time zone default NULL,
                                   closing_date timestamp without time zone default NULL,
                                   alarm1_date timestamp without time zone default NULL,
                                   alarm2_date timestamp without time zone default NULL,
                                   flag_notif char(1)  default 'N'::character varying ,
                                   flag_alarm1 char(1)  default 'N'::character varying ,
                                   flag_alarm2 char(1) default 'N'::character varying
)WITH (OIDS=FALSE);

DROP TABLE IF EXISTS invoice_types CASCADE;
CREATE TABLE invoice_types (
                               invoice_type_id character varying(50) NOT NULL,
                               invoice_type_name character varying(255) NOT NULL,
                               invoice_movement char(2) default 'DR'::character varying
)WITH (OIDS=FALSE);

--contacts
ALTER TABLE contacts DROP COLUMN IF EXISTS business_id;
ALTER TABLE contacts ADD COLUMN business_id character varying(255);
ALTER TABLE contacts DROP COLUMN IF EXISTS ref_identifier;
ALTER TABLE contacts ADD COLUMN ref_identifier character varying(255);
ALTER TABLE contacts DROP COLUMN IF EXISTS acc_number;
ALTER TABLE contacts ADD COLUMN acc_number character varying(50);
ALTER TABLE contacts DROP COLUMN IF EXISTS entity_id;
ALTER TABLE contacts ADD COLUMN entity_id character varying(32);
ALTER TABLE contacts DROP COLUMN IF EXISTS contact_type;
ALTER TABLE contacts ADD COLUMN contact_type character varying(255) NOT NULL DEFAULT 'letter'::character varying;
ALTER TABLE contacts DROP COLUMN IF EXISTS is_private;
ALTER TABLE contacts ADD COLUMN is_private character varying(1) NOT NULL DEFAULT 'N'::character varying;

DROP VIEW IF EXISTS res_view_business;
CREATE VIEW res_view_business AS
SELECT r.tablename, r.is_multi_docservers, r.res_id, r.type_id,
       d.description AS type_label, d.doctypes_first_level_id,
       d.doctypes_second_level_id, r.format, r.typist,
       r.creation_date, r.relation, r.docserver_id, r.folders_system_id,
       f.folder_id, f.is_frozen as folder_is_frozen, r.path, r.filename,
       r.fingerprint, r.offset_doc, r.filesize,
       r.status, r.work_batch, r.arbatch_id, r.arbox_id, r.page_count, r.is_paper,
       r.doc_date, r.scan_date, r.scan_user, r.scan_location, r.scan_wkstation,
       r.scan_batch, r.doc_language, r.description, r.source, r.author,
       r.custom_t1 AS doc_custom_t1, r.custom_t2 AS doc_custom_t2,
       r.custom_t3 AS doc_custom_t3, r.custom_t4 AS doc_custom_t4,
       r.custom_t5 AS doc_custom_t5, r.custom_t6 AS doc_custom_t6,
       r.custom_t7 AS doc_custom_t7, r.custom_t8 AS doc_custom_t8,
       r.custom_t9 AS doc_custom_t9, r.custom_t10 AS doc_custom_t10,
       r.custom_t11 AS doc_custom_t11, r.custom_t12 AS doc_custom_t12,
       r.custom_t13 AS doc_custom_t13, r.custom_t14 AS doc_custom_t14,
       r.custom_t15 AS doc_custom_t15, r.custom_d1 AS doc_custom_d1,
       r.custom_d2 AS doc_custom_d2, r.custom_d3 AS doc_custom_d3,
       r.custom_d4 AS doc_custom_d4, r.custom_d5 AS doc_custom_d5,
       r.custom_d6 AS doc_custom_d6, r.custom_d7 AS doc_custom_d7,
       r.custom_d8 AS doc_custom_d8, r.custom_d9 AS doc_custom_d9,
       r.custom_d10 AS doc_custom_d10, r.custom_n1 AS doc_custom_n1,
       r.custom_n2 AS doc_custom_n2, r.custom_n3 AS doc_custom_n3,
       r.custom_n4 AS doc_custom_n4, r.custom_n5 AS doc_custom_n5,
       r.custom_f1 AS doc_custom_f1, r.custom_f2 AS doc_custom_f2,
       r.custom_f3 AS doc_custom_f3, r.custom_f4 AS doc_custom_f4,
       r.custom_f5 AS doc_custom_f5, f.foldertype_id,
       f.custom_t1 AS fold_custom_t1, f.custom_t2 AS fold_custom_t2,
       f.custom_t3 AS fold_custom_t3, f.custom_t4 AS fold_custom_t4,
       f.custom_t5 AS fold_custom_t5, f.custom_t6 AS fold_custom_t6,
       f.custom_t7 AS fold_custom_t7, f.custom_t8 AS fold_custom_t8,
       f.custom_t9 AS fold_custom_t9, f.custom_t10 AS fold_custom_t10,
       f.custom_t11 AS fold_custom_t11, f.custom_t12 AS fold_custom_t12,
       f.custom_t13 AS fold_custom_t13, f.custom_t14 AS fold_custom_t14,
       f.custom_t15 AS fold_custom_t15, f.custom_d1 AS fold_custom_d1,
       f.custom_d2 AS fold_custom_d2, f.custom_d3 AS fold_custom_d3,
       f.custom_d4 AS fold_custom_d4, f.custom_d5 AS fold_custom_d5,
       f.custom_d6 AS fold_custom_d6, f.custom_d7 AS fold_custom_d7,
       f.custom_d8 AS fold_custom_d8, f.custom_d9 AS fold_custom_d9,
       f.custom_d10 AS fold_custom_d10, f.custom_n1 AS fold_custom_n1,
       f.custom_n2 AS fold_custom_n2, f.custom_n3 AS fold_custom_n3,
       f.custom_n4 AS fold_custom_n4, f.custom_n5 AS fold_custom_n5,
       f.custom_f1 AS fold_custom_f1, f.custom_f2 AS fold_custom_f2,
       f.custom_f3 AS fold_custom_f3, f.custom_f4 AS fold_custom_f4,
       f.custom_f5 AS fold_custom_f5, f.is_complete AS fold_complete,
       f.status AS fold_status, f.subject AS fold_subject,
       f.parent_id AS fold_parent_id, f.folder_level, f.folder_name,
       f.creation_date AS fold_creation_date, r.initiator, r.destination,
       r.dest_user, busi.category_id, busi.contact_id, busi.currency,
       busi.net_sum, busi.tax_sum, busi.total_sum,
       busi.process_limit_date, busi.closing_date, busi.alarm1_date, busi.alarm2_date,
       busi.flag_notif, busi.flag_alarm1, busi.flag_alarm2, r.video_user, r.video_time,
       r.video_batch, r.subject, r.identifier, r.title, r.priority,
       en.entity_label, cont.email AS contact_email,
       cont.firstname AS contact_firstname, cont.lastname AS contact_lastname,
       cont.society AS contact_society, list.item_id AS dest_user_from_listinstance,  list.viewed,
       r.is_frozen as res_is_frozen, COALESCE(att.count_attachment, 0::bigint) AS count_attachment
FROM doctypes d, res_business r
                     LEFT JOIN (SELECT res_attachments.res_id_master, coll_id, count(res_attachments.res_id_master) AS count_attachment
                                FROM res_attachments GROUP BY res_attachments.res_id_master, coll_id) att ON (r.res_id = att.res_id_master and att.coll_id = 'business_coll')
                     LEFT JOIN entities en ON ((r.destination)::text = (en.entity_id)::text)
        LEFT JOIN folders f ON ((r.folders_system_id = f.folders_system_id))
        LEFT JOIN business_coll_ext busi ON (busi.res_id = r.res_id)
        LEFT JOIN contacts cont ON (busi.contact_id = cont.contact_id)
        LEFT JOIN listinstance list ON ((r.res_id = list.res_id)
        AND ((list.item_mode)::text = 'dest'::text))
        WHERE r.type_id = d.type_id;

CREATE VIEW res_view_letterbox AS
SELECT r.tablename, r.is_multi_docservers, r.res_id, r.type_id, r.policy_id, r.cycle_id,
       d.description AS type_label, d.doctypes_first_level_id,
       dfl.doctypes_first_level_label, dfl.css_style as doctype_first_level_style,
       d.doctypes_second_level_id, dsl.doctypes_second_level_label,
       dsl.css_style as doctype_second_level_style, r.format, r.typist,
       r.creation_date, r.relation, r.docserver_id, r.folders_system_id,
       f.folder_id, f.is_frozen as folder_is_frozen, r.path, r.filename, r.fingerprint, r.offset_doc, r.filesize,
       r.status, r.work_batch, r.arbatch_id, r.arbox_id, r.page_count, r.is_paper,
       r.doc_date, r.scan_date, r.scan_user, r.scan_location, r.scan_wkstation,
       r.scan_batch, r.doc_language, r.description, r.source, r.author,
       r.custom_t1 AS doc_custom_t1, r.custom_t2 AS doc_custom_t2,
       r.custom_t3 AS doc_custom_t3, r.custom_t4 AS doc_custom_t4,
       r.custom_t5 AS doc_custom_t5, r.custom_t6 AS doc_custom_t6,
       r.custom_t7 AS doc_custom_t7, r.custom_t8 AS doc_custom_t8,
       r.custom_t9 AS doc_custom_t9, r.custom_t10 AS doc_custom_t10,
       r.custom_t11 AS doc_custom_t11, r.custom_t12 AS doc_custom_t12,
       r.custom_t13 AS doc_custom_t13, r.custom_t14 AS doc_custom_t14,
       r.custom_t15 AS doc_custom_t15, r.custom_d1 AS doc_custom_d1,
       r.custom_d2 AS doc_custom_d2, r.custom_d3 AS doc_custom_d3,
       r.custom_d4 AS doc_custom_d4, r.custom_d5 AS doc_custom_d5,
       r.custom_d6 AS doc_custom_d6, r.custom_d7 AS doc_custom_d7,
       r.custom_d8 AS doc_custom_d8, r.custom_d9 AS doc_custom_d9,
       r.custom_d10 AS doc_custom_d10, r.custom_n1 AS doc_custom_n1,
       r.custom_n2 AS doc_custom_n2, r.custom_n3 AS doc_custom_n3,
       r.custom_n4 AS doc_custom_n4, r.custom_n5 AS doc_custom_n5,
       r.custom_f1 AS doc_custom_f1, r.custom_f2 AS doc_custom_f2,
       r.custom_f3 AS doc_custom_f3, r.custom_f4 AS doc_custom_f4,
       r.custom_f5 AS doc_custom_f5, f.foldertype_id, ft.foldertype_label,
       f.custom_t1 AS fold_custom_t1, f.custom_t2 AS fold_custom_t2,
       f.custom_t3 AS fold_custom_t3, f.custom_t4 AS fold_custom_t4,
       f.custom_t5 AS fold_custom_t5, f.custom_t6 AS fold_custom_t6,
       f.custom_t7 AS fold_custom_t7, f.custom_t8 AS fold_custom_t8,
       f.custom_t9 AS fold_custom_t9, f.custom_t10 AS fold_custom_t10,
       f.custom_t11 AS fold_custom_t11, f.custom_t12 AS fold_custom_t12,
       f.custom_t13 AS fold_custom_t13, f.custom_t14 AS fold_custom_t14,
       f.custom_t15 AS fold_custom_t15, f.custom_d1 AS fold_custom_d1,
       f.custom_d2 AS fold_custom_d2, f.custom_d3 AS fold_custom_d3,
       f.custom_d4 AS fold_custom_d4, f.custom_d5 AS fold_custom_d5,
       f.custom_d6 AS fold_custom_d6, f.custom_d7 AS fold_custom_d7,
       f.custom_d8 AS fold_custom_d8, f.custom_d9 AS fold_custom_d9,
       f.custom_d10 AS fold_custom_d10, f.custom_n1 AS fold_custom_n1,
       f.custom_n2 AS fold_custom_n2, f.custom_n3 AS fold_custom_n3,
       f.custom_n4 AS fold_custom_n4, f.custom_n5 AS fold_custom_n5,
       f.custom_f1 AS fold_custom_f1, f.custom_f2 AS fold_custom_f2,
       f.custom_f3 AS fold_custom_f3, f.custom_f4 AS fold_custom_f4,
       f.custom_f5 AS fold_custom_f5, f.is_complete AS fold_complete,
       f.status AS fold_status, f.subject AS fold_subject,
       f.parent_id AS fold_parent_id, f.folder_level, f.folder_name,
       f.creation_date AS fold_creation_date, r.initiator, r.destination,
       r.dest_user, mlb.category_id, mlb.exp_contact_id, mlb.exp_user_id,
       mlb.dest_user_id, mlb.dest_contact_id, mlb.nature_id, mlb.alt_identifier,
       mlb.admission_date, mlb.answer_type_bitmask, mlb.other_answer_desc,
       mlb.process_limit_date, mlb.closing_date, mlb.alarm1_date, mlb.alarm2_date,
       mlb.flag_notif, mlb.flag_alarm1, mlb.flag_alarm2, r.video_user, r.video_time,
       r.video_batch, r.subject, r.identifier, r.title, r.priority, mlb.process_notes,
       ca.case_id, ca.case_label, ca.case_description, en.entity_label,
       cont.contact_id AS contact_id, cont.email AS contact_email,
       cont.firstname AS contact_firstname, cont.lastname AS contact_lastname,
       cont.society AS contact_society, u.lastname AS user_lastname,
       u.firstname AS user_firstname, list.item_id AS dest_user_from_listinstance, list.viewed,
       r.is_frozen as res_is_frozen, COALESCE(att.count_attachment, 0::bigint) AS count_attachment
FROM doctypes d, doctypes_first_level dfl, doctypes_second_level dsl,
     (((((((((((ar_batch a RIGHT JOIN res_letterbox r ON ((r.arbatch_id = a.arbatch_id)))
         LEFT JOIN (SELECT res_attachments.res_id_master, count(res_attachments.res_id_master) AS count_attachment
                    FROM res_attachments GROUP BY res_attachments.res_id_master) att ON (r.res_id = att.res_id_master))
         LEFT JOIN entities en ON (((r.destination)::text = (en.entity_id)::text)))
         LEFT JOIN folders f ON ((r.folders_system_id = f.folders_system_id)))
         LEFT JOIN cases_res cr ON ((r.res_id = cr.res_id)))
         LEFT JOIN mlb_coll_ext mlb ON ((mlb.res_id = r.res_id)))
         LEFT JOIN foldertypes ft ON (((f.foldertype_id = ft.foldertype_id)
         AND ((f.status)::text <> 'DEL'::text))))
    LEFT JOIN cases ca ON ((cr.case_id = ca.case_id)))
    LEFT JOIN contacts cont ON (((mlb.exp_contact_id = cont.contact_id)
        OR (mlb.dest_contact_id = cont.contact_id))))
    LEFT JOIN users u ON ((((mlb.exp_user_id)::text = (u.user_id)::text)
        OR ((mlb.dest_user_id)::text = (u.user_id)::text))))
    LEFT JOIN listinstance list ON (((r.res_id = list.res_id)
        AND ((list.item_mode)::text = 'dest'::text))))
    WHERE (((r.type_id = d.type_id) AND
    (d.doctypes_first_level_id = dfl.doctypes_first_level_id))
    AND (d.doctypes_second_level_id = dsl.doctypes_second_level_id));

-- View for postindexing
CREATE OR REPLACE VIEW view_postindexing AS
SELECT res_view_letterbox.video_user, (users.firstname::text || ' '::text) || users.lastname::text AS user_name, res_view_letterbox.video_batch, res_view_letterbox.video_time, count(res_view_letterbox.res_id) AS count_documents, res_view_letterbox.folders_system_id, (folders.folder_id::text || ' / '::text) || folders.folder_name::text AS folder_full_label, folders.video_status
FROM res_view_letterbox
         LEFT JOIN users ON res_view_letterbox.video_user::text = users.user_id::text
LEFT JOIN folders ON folders.folders_system_id = res_view_letterbox.folders_system_id
WHERE res_view_letterbox.video_batch IS NOT NULL
GROUP BY res_view_letterbox.video_user, (users.firstname::text || ' '::text) || users.lastname::text, res_view_letterbox.video_batch, res_view_letterbox.video_time, res_view_letterbox.folders_system_id, (folders.folder_id::text || ' / '::text) || folders.folder_name::text, folders.video_status;

-- Parameters description --
ALTER TABLE parameters DROP COLUMN IF EXISTS description;
ALTER TABLE parameters ADD COLUMN description TEXT;

-- Notifications --
CREATE SEQUENCE notif_rss_stack_seq
    INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;

CREATE TABLE notif_rss_stack
(
    rss_stack_sid bigint NOT NULL DEFAULT nextval('notif_rss_stack_seq'::regclass),
    rss_user_id character varying(128) NOT NULL,
    rss_event_stack_sid bigint NOT NULL,
    rss_event_url text,
    CONSTRAINT notif_rss_stack_pkey PRIMARY KEY (rss_stack_sid )
)
    WITH (
        OIDS=FALSE
        );

-----------------------
--FILEPLAN---
------------------------

-- fileplan module
DROP SEQUENCE IF EXISTS fp_fileplan_positions_position_id_seq;
CREATE SEQUENCE fp_fileplan_positions_position_id_seq
    INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 10
  CACHE 1;

DROP TABLE IF EXISTS fp_fileplan;
CREATE TABLE fp_fileplan
(
    fileplan_id serial NOT NULL,
    fileplan_label character varying(255),
    user_id character varying(128) DEFAULT NULL,
    entity_id character varying(32) DEFAULT NULL,
    is_serial_id character varying(1) NOT NULL DEFAULT 'Y',
    enabled character varying(1) NOT NULL DEFAULT 'Y',
    CONSTRAINT fp_fileplan_pkey PRIMARY KEY (fileplan_id)
);

DROP TABLE IF EXISTS fp_fileplan_positions;
CREATE TABLE fp_fileplan_positions
(
    position_id character varying(32) NOT NULL,
    position_label character varying(255),
    parent_id character varying(32) DEFAULT NULL,
    fileplan_id bigint NOT NULL,
    enabled character varying(1) NOT NULL DEFAULT 'Y',
    CONSTRAINT fp_fileplan_positions_pkey PRIMARY KEY (fileplan_id, position_id)
);

DROP TABLE IF EXISTS fp_res_fileplan_positions;
CREATE TABLE fp_res_fileplan_positions
(
    res_id bigint NOT NULL,
    coll_id character varying(32) NOT NULL,
    fileplan_id bigint NOT NULL,
    position_id character varying(32) NOT NULL,
    CONSTRAINT fp_res_fileplan_positions_pkey PRIMARY KEY (res_id, coll_id, fileplan_id, position_id)
);

-- View fileplan
CREATE OR REPLACE VIEW fp_view_fileplan AS
SELECT fp_fileplan.fileplan_id, fp_fileplan.fileplan_label,
       fp_fileplan.user_id, fp_fileplan.entity_id, fp_fileplan.enabled,
       fp_fileplan_positions.position_id, fp_fileplan_positions.position_label,
       fp_fileplan_positions.parent_id,
       fp_fileplan_positions.enabled AS position_enabled,
       COALESCE(r.count_document, 0::bigint) AS count_document
FROM fp_fileplan,
     fp_fileplan_positions
         LEFT JOIN ( SELECT fp_res_fileplan_positions.position_id,
                            count(fp_res_fileplan_positions.res_id) AS count_document
                     FROM fp_res_fileplan_positions
                     GROUP BY fp_res_fileplan_positions.position_id) r ON r.position_id::text = fp_fileplan_positions.position_id::text
WHERE fp_fileplan.fileplan_id = fp_fileplan_positions.fileplan_id;

-- sendmail module
DROP TABLE IF EXISTS sendmail;
CREATE TABLE sendmail
(
    email_id serial NOT NULL,
    coll_id character varying(32) NOT NULL,
    res_id bigint NOT NULL,
    user_id character varying(128) NOT NULL,
    to_list character varying(255) NOT NULL,
    cc_list character varying(255) DEFAULT NULL,
    cci_list character varying(255) DEFAULT NULL,
    email_object character varying(255) DEFAULT NULL,
    email_body text,
    is_res_master_attached character varying(1) NOT NULL DEFAULT 'Y',
    res_version_id_list character varying(255) DEFAULT NULL,
    res_attachment_id_list character varying(255) DEFAULT NULL,
    note_id_list character varying(255) DEFAULT NULL,
    is_html character varying(1) NOT NULL DEFAULT 'Y',
    email_status character varying(1) NOT NULL DEFAULT 'D',
    creation_date timestamp without time zone NOT NULL,
    send_date timestamp without time zone DEFAULT NULL,
    CONSTRAINT sendmail_pkey PRIMARY KEY (email_id )
);

-- Database version
UPDATE parameters SET param_value_int = 140 where id='database_version';

-- photo_capture
DROP TABLE IF EXISTS photo_capture;
CREATE TABLE photo_capture
(
    res_id serial NOT NULL,
    title character varying(255) DEFAULT NULL,
    format character varying(50) NOT NULL,
    typist character varying(128) NOT NULL,
    creation_date timestamp without time zone NOT NULL,
    docserver_id character varying(32) NOT NULL,
    path character varying(255) DEFAULT NULL,
    filename character varying(255) DEFAULT NULL,
    offset_doc character varying(255) DEFAULT NULL,
    logical_adr character varying(255) DEFAULT NULL,
    fingerprint character varying(255) DEFAULT NULL,
    filesize bigint,
    status character varying(10) DEFAULT NULL,
    coll_id character varying(32) NOT NULL,
    res_id_master bigint,
    folders_system_id bigint,
    CONSTRAINT photo_capture_pkey PRIMARY KEY (res_id)
);

update groupbasket set result_page = 'list_copies' where  result_page = 'count_list';
update groupbasket set result_page = 'list_with_attachments' where  result_page = 'documents_list';
update groupbasket set result_page = 'list_with_attachments' where  result_page = 'auth_dep';
update baskets set basket_clause = '((res_id in (select res_id from listinstance WHERE coll_id = ''letterbox_coll''
and item_type = ''user_id'' and item_id = @user and item_mode = ''cc'')
or res_id in (select res_id from listinstance WHERE coll_id = ''letterbox_coll''
and item_type = ''entity_id'' and item_mode = ''cc'' and item_id in (@my_entities)) and status <> ''END'')
OR res_id in (select res_id from basket_persistent_mode WHERE user_id = @user and is_persistent = ''Y'')) and status <> ''DEL'' '
where basket_id = 'CopyMailBasket';