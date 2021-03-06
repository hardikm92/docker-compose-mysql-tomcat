--
-- This script is a SAMPLE and can be modified as appropriate by the
-- customer as long as the equivalent tables and indexes are created.
-- The database name, user, and password must match those defined in
-- iiq.properties in the IdentityIQ installation.
--

-- Note that we do not specify a COLLATE - this will default to utf8_general_ci,
-- which causes queries to be case-insensitive.
CREATE DATABASE IF NOT EXISTS identityiq CHARACTER SET utf8;

GRANT ALL PRIVILEGES ON identityiq.*
    TO 'identityiq' IDENTIFIED BY 'identityiq';
GRANT ALL PRIVILEGES ON identityiq.*
    TO 'identityiq'@'%' IDENTIFIED BY 'identityiq';
GRANT ALL PRIVILEGES ON identityiq.*
    TO 'identityiq'@'localhost' IDENTIFIED BY 'identityiq';

USE identityiq;


-- Note that we do not specify a COLLATE - this will default to utf8_general_ci,
-- which causes queries to be case-insensitive.
CREATE DATABASE IF NOT EXISTS identityiqPlugin CHARACTER SET utf8;

GRANT ALL PRIVILEGES ON identityiqPlugin.*
    TO 'identityiqPlugin' IDENTIFIED BY 'identityiqPlugin';
GRANT ALL PRIVILEGES ON identityiqPlugin.*
    TO 'identityiqPlugin'@'%' IDENTIFIED BY 'identityiqPlugin';
GRANT ALL PRIVILEGES ON identityiqPlugin.*
    TO 'identityiqPlugin'@'localhost' IDENTIFIED BY 'identityiqPlugin';
-- From the Quartz 1.5.2 Distribution
--
-- IdentityIQ NOTES:
--
-- Since things like Application names can make their way into TaskSchedule
-- object names, we are forced to modify the Quartz schema in places where
-- the original column size is insufficient. Thus JOB_NAME and TRIGGER_NAME
-- have been increased from VARCHAR(80) to VARCHAR(200).
--
-- Future upgrades to Quartz will have to carry forward these changes.
-- 
-- 12/17/2013 Updated for Quartz 2.2.1
--

#
# Quartz seems to work best with the driver mm.mysql-2.0.7-bin.jar
#
# In your Quartz properties file, you'll need to set
# org.quartz.jobStore.driverDelegateClass = org.quartz.impl.jdbcjobstore.StdJDBCDelegate
#
CREATE TABLE QRTZ221_JOB_DETAILS
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    JOB_NAME  VARCHAR(200) NOT NULL,
    JOB_GROUP VARCHAR(200) NOT NULL,
    DESCRIPTION VARCHAR(250) NULL,
    JOB_CLASS_NAME   VARCHAR(250) NOT NULL,
    IS_DURABLE VARCHAR(1) NOT NULL,
    IS_NONCONCURRENT VARCHAR(1) NOT NULL,
    IS_UPDATE_DATA VARCHAR(1) NOT NULL,
    REQUESTS_RECOVERY VARCHAR(1) NOT NULL,
    JOB_DATA BLOB NULL,
    PRIMARY KEY (SCHED_NAME,JOB_NAME,JOB_GROUP)
) ENGINE=InnoDB;

CREATE TABLE QRTZ221_TRIGGERS
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    TRIGGER_NAME VARCHAR(200) NOT NULL,
    TRIGGER_GROUP VARCHAR(200) NOT NULL,
    JOB_NAME  VARCHAR(200) NOT NULL,
    JOB_GROUP VARCHAR(200) NOT NULL,
    DESCRIPTION VARCHAR(250) NULL,
    NEXT_FIRE_TIME BIGINT(13) NULL,
    PREV_FIRE_TIME BIGINT(13) NULL,
    PRIORITY INTEGER NULL,
    TRIGGER_STATE VARCHAR(16) NOT NULL,
    TRIGGER_TYPE VARCHAR(8) NOT NULL,
    START_TIME BIGINT(13) NOT NULL,
    END_TIME BIGINT(13) NULL,
    CALENDAR_NAME VARCHAR(200) NULL,
    MISFIRE_INSTR SMALLINT(2) NULL,
    JOB_DATA BLOB NULL,
    PRIMARY KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP),
    FOREIGN KEY (SCHED_NAME,JOB_NAME,JOB_GROUP)
        REFERENCES QRTZ221_JOB_DETAILS(SCHED_NAME,JOB_NAME,JOB_GROUP)
) ENGINE=InnoDB;

CREATE TABLE QRTZ221_SIMPLE_TRIGGERS
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    TRIGGER_NAME VARCHAR(200) NOT NULL,
    TRIGGER_GROUP VARCHAR(200) NOT NULL,
    REPEAT_COUNT BIGINT(7) NOT NULL,
    REPEAT_INTERVAL BIGINT(12) NOT NULL,
    TIMES_TRIGGERED BIGINT(10) NOT NULL,
    PRIMARY KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP),
    FOREIGN KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
        REFERENCES QRTZ221_TRIGGERS(SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
) ENGINE=InnoDB;

CREATE TABLE QRTZ221_CRON_TRIGGERS
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    TRIGGER_NAME VARCHAR(200) NOT NULL,
    TRIGGER_GROUP VARCHAR(200) NOT NULL,
    CRON_EXPRESSION VARCHAR(200) NOT NULL,
    TIME_ZONE_ID VARCHAR(80),
    PRIMARY KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP),
    FOREIGN KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
        REFERENCES QRTZ221_TRIGGERS(SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
) ENGINE=InnoDB;

CREATE TABLE QRTZ221_SIMPROP_TRIGGERS
  (          
    SCHED_NAME VARCHAR(120) NOT NULL,
    TRIGGER_NAME VARCHAR(200) NOT NULL,
    TRIGGER_GROUP VARCHAR(200) NOT NULL,
    STR_PROP_1 VARCHAR(512) NULL,
    STR_PROP_2 VARCHAR(512) NULL,
    STR_PROP_3 VARCHAR(512) NULL,
    INT_PROP_1 INT NULL,
    INT_PROP_2 INT NULL,
    LONG_PROP_1 BIGINT NULL,
    LONG_PROP_2 BIGINT NULL,
    DEC_PROP_1 NUMERIC(13,4) NULL,
    DEC_PROP_2 NUMERIC(13,4) NULL,
    BOOL_PROP_1 VARCHAR(1) NULL,
    BOOL_PROP_2 VARCHAR(1) NULL,
    PRIMARY KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP),
    FOREIGN KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP) 
    REFERENCES QRTZ221_TRIGGERS(SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
) ENGINE=InnoDB;

CREATE TABLE QRTZ221_BLOB_TRIGGERS
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    TRIGGER_NAME VARCHAR(200) NOT NULL,
    TRIGGER_GROUP VARCHAR(200) NOT NULL,
    BLOB_DATA BLOB NULL,
    PRIMARY KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP),
    FOREIGN KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
        REFERENCES QRTZ221_TRIGGERS(SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
) ENGINE=InnoDB;

CREATE TABLE QRTZ221_CALENDARS
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    CALENDAR_NAME  VARCHAR(200) NOT NULL,
    CALENDAR BLOB NOT NULL,
    PRIMARY KEY (SCHED_NAME,CALENDAR_NAME)
) ENGINE=InnoDB;

CREATE TABLE QRTZ221_PAUSED_TRIGGER_GRPS
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    TRIGGER_GROUP  VARCHAR(200) NOT NULL, 
    PRIMARY KEY (SCHED_NAME,TRIGGER_GROUP)
) ENGINE=InnoDB;

CREATE TABLE QRTZ221_FIRED_TRIGGERS
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    ENTRY_ID VARCHAR(95) NOT NULL,
    TRIGGER_NAME VARCHAR(200) NOT NULL,
    TRIGGER_GROUP VARCHAR(200) NOT NULL,
    INSTANCE_NAME VARCHAR(200) NOT NULL,
    FIRED_TIME BIGINT(13) NOT NULL,
    SCHED_TIME BIGINT(13) NOT NULL,
    PRIORITY INTEGER NOT NULL,
    STATE VARCHAR(16) NOT NULL,
    JOB_NAME VARCHAR(200) NULL,
    JOB_GROUP VARCHAR(200) NULL,
    IS_NONCONCURRENT VARCHAR(1) NULL,
    REQUESTS_RECOVERY VARCHAR(1) NULL,
    PRIMARY KEY (SCHED_NAME,ENTRY_ID)
) ENGINE=InnoDB;

CREATE TABLE QRTZ221_SCHEDULER_STATE
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    INSTANCE_NAME VARCHAR(200) NOT NULL,
    LAST_CHECKIN_TIME BIGINT(13) NOT NULL,
    CHECKIN_INTERVAL BIGINT(13) NOT NULL,
    PRIMARY KEY (SCHED_NAME,INSTANCE_NAME)
) ENGINE=InnoDB;

CREATE TABLE QRTZ221_LOCKS
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    LOCK_NAME  VARCHAR(40) NOT NULL, 
    PRIMARY KEY (SCHED_NAME,LOCK_NAME)
) ENGINE=InnoDB;

INSERT INTO QRTZ221_LOCKS VALUES('QuartzScheduler', "TRIGGER_ACCESS");
INSERT INTO QRTZ221_LOCKS VALUES('QuartzScheduler', "JOB_ACCESS");
INSERT INTO QRTZ221_LOCKS VALUES('QuartzScheduler', "CALENDAR_ACCESS");
INSERT INTO QRTZ221_LOCKS VALUES('QuartzScheduler', "STATE_ACCESS");
INSERT INTO QRTZ221_LOCKS VALUES('QuartzScheduler', "MISFIRE_ACCESS");

create index idx_qrtz_j_req_recovery on QRTZ221_JOB_DETAILS(SCHED_NAME,REQUESTS_RECOVERY);
create index idx_qrtz_j_grp on QRTZ221_JOB_DETAILS(SCHED_NAME,JOB_GROUP);
create index idx_qrtz_t_j on QRTZ221_TRIGGERS(SCHED_NAME,JOB_NAME,JOB_GROUP);
create index idx_qrtz_t_jg on QRTZ221_TRIGGERS(SCHED_NAME,JOB_GROUP);
create index idx_qrtz_t_c on QRTZ221_TRIGGERS(SCHED_NAME,CALENDAR_NAME);
create index idx_qrtz_t_g on QRTZ221_TRIGGERS(SCHED_NAME,TRIGGER_GROUP);
create index idx_qrtz_t_state on QRTZ221_TRIGGERS(SCHED_NAME,TRIGGER_STATE);
create index idx_qrtz_t_n_state on QRTZ221_TRIGGERS(SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP,TRIGGER_STATE);
create index idx_qrtz_t_n_g_state on QRTZ221_TRIGGERS(SCHED_NAME,TRIGGER_GROUP,TRIGGER_STATE);
create index idx_qrtz_t_next_fire_time on QRTZ221_TRIGGERS(SCHED_NAME,NEXT_FIRE_TIME);
create index idx_qrtz_t_nft_st on QRTZ221_TRIGGERS(SCHED_NAME,TRIGGER_STATE,NEXT_FIRE_TIME);
create index idx_qrtz_t_nft_misfire on QRTZ221_TRIGGERS(SCHED_NAME,MISFIRE_INSTR,NEXT_FIRE_TIME);
create index idx_qrtz_t_nft_st_misfire on QRTZ221_TRIGGERS(SCHED_NAME,MISFIRE_INSTR,NEXT_FIRE_TIME,TRIGGER_STATE);
create index idx_qrtz_t_nft_st_misfire_grp on QRTZ221_TRIGGERS(SCHED_NAME,MISFIRE_INSTR,NEXT_FIRE_TIME,TRIGGER_GROUP,TRIGGER_STATE);
create index idx_qrtz_ft_trig_inst_name on QRTZ221_FIRED_TRIGGERS(SCHED_NAME,INSTANCE_NAME);
create index idx_qrtz_ft_inst_job_req_rcvry on QRTZ221_FIRED_TRIGGERS(SCHED_NAME,INSTANCE_NAME,REQUESTS_RECOVERY);
create index idx_qrtz_ft_j_g on QRTZ221_FIRED_TRIGGERS(SCHED_NAME,JOB_NAME,JOB_GROUP);
create index idx_qrtz_ft_jg on QRTZ221_FIRED_TRIGGERS(SCHED_NAME,JOB_GROUP);
create index idx_qrtz_ft_t_g on QRTZ221_FIRED_TRIGGERS(SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP);
create index idx_qrtz_ft_tg on QRTZ221_FIRED_TRIGGERS(SCHED_NAME,TRIGGER_GROUP);
-- End Quartz configuration

    create table identityiq.spt_account_group (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128),
        description varchar(1024),
        native_identity varchar(322),
        reference_attribute varchar(128),
        member_attribute varchar(128),
        last_refresh bigint,
        last_target_aggregation bigint,
        uncorrelated bit,
        application varchar(32),
        attributes longtext,
        key1 varchar(128),
        key2 varchar(128),
        key3 varchar(128),
        key4 varchar(128),
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_account_group_inheritance (
        account_group varchar(32) not null,
        inherits_from varchar(32) not null,
        idx integer not null,
        primary key (account_group, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_account_group_perms (
        accountgroup varchar(32) not null,
        target varchar(255),
        rights varchar(4000),
        annotation varchar(255),
        idx integer not null,
        primary key (accountgroup, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_account_group_target_perms (
        accountgroup varchar(32) not null,
        target varchar(255),
        rights varchar(4000),
        annotation varchar(255),
        idx integer not null,
        primary key (accountgroup, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_activity_constraint (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(2000),
        description varchar(4000),
        policy varchar(32),
        violation_owner_type varchar(255),
        violation_owner varchar(32),
        violation_owner_rule varchar(32),
        compensating_control longtext,
        disabled bit,
        weight integer,
        remediation_advice longtext,
        violation_summary longtext,
        identity_filters longtext,
        activity_filters longtext,
        time_periods longtext,
        idx integer,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_activity_data_source (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null,
        description varchar(1024),
        collector varchar(255),
        type varchar(255),
        configuration longtext,
        last_refresh bigint,
        targets longtext,
        correlation_rule varchar(32),
        transformation_rule varchar(32),
        application varchar(32),
        idx integer,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_activity_time_periods (
        application_activity varchar(32) not null,
        time_period varchar(32) not null,
        idx integer not null,
        primary key (application_activity, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_alert (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        extended1 varchar(255),
        attributes longtext,
        source varchar(32),
        alert_date bigint,
        native_id varchar(255),
        target_id varchar(255),
        target_type varchar(255),
        target_display_name varchar(255),
        last_processed bigint,
        display_name varchar(128),
        name varchar(255),
        type varchar(255),
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_alert_action (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        alert_def longtext,
        action_type varchar(255),
        result_id varchar(255),
        result longtext,
        alert varchar(32),
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_alert_definition (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        match_config longtext,
        disabled bit,
        name varchar(128) not null unique,
        description varchar(1024),
        display_name varchar(128),
        action_config longtext,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_app_dependencies (
        application varchar(32) not null,
        dependency varchar(32) not null,
        idx integer not null,
        primary key (application, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_app_secondary_owners (
        application varchar(32) not null,
        elt varchar(32) not null,
        idx integer not null,
        primary key (application, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_application (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        extended1 varchar(450),
        extended2 varchar(450),
        extended3 varchar(450),
        extended4 varchar(450),
        name varchar(128) not null unique,
        proxied_name varchar(128),
        app_cluster varchar(255),
        icon varchar(255),
        connector varchar(255),
        type varchar(255),
        features_string varchar(512),
        aggregation_types varchar(128),
        profile_class varchar(255),
        authentication_resource bit,
        case_insensitive bit,
        authoritative bit,
        logical bit,
        supports_provisioning bit,
        supports_authenticate bit,
        supports_account_only bit,
        supports_additional_accounts bit,
        no_aggregation bit,
        sync_provisioning bit,
        attributes longtext,
        templates longtext,
        provisioning_forms longtext,
        provisioning_config longtext,
        manages_other_apps bit not null,
        proxy varchar(32),
        correlation_rule varchar(32),
        creation_rule varchar(32),
        manager_correlation_rule varchar(32),
        customization_rule varchar(32),
        managed_attr_customize_rule varchar(32),
        account_correlation_config varchar(32),
        scorecard varchar(32),
        target_source varchar(32),
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_application_activity (
        id varchar(32) not null,
        time_stamp bigint,
        source_application varchar(128),
        action varchar(255),
        result varchar(255),
        data_source varchar(128),
        instance varchar(128),
        username varchar(128),
        target varchar(128),
        info varchar(512),
        identity_id varchar(128),
        identity_name varchar(128),
        assigned_scope varchar(32),
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_application_remediators (
        application varchar(32) not null,
        elt varchar(32) not null,
        idx integer not null,
        primary key (application, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_application_schema (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128),
        object_type varchar(255),
        aggregation_type varchar(128),
        native_object_type varchar(255),
        identity_attribute varchar(255),
        display_attribute varchar(255),
        instance_attribute varchar(255),
        group_attribute varchar(255),
        hierarchy_attribute varchar(255),
        reference_attribute varchar(255),
        include_permissions bit,
        index_permissions bit,
        child_hierarchy bit,
        perm_remed_mod_type varchar(255),
        config longtext,
        features_string varchar(512),
        creation_rule varchar(32),
        customization_rule varchar(32),
        correlation_rule varchar(32),
        application varchar(32),
        idx integer,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_application_scorecard (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        incomplete bit,
        composite_score integer,
        attributes longtext,
        items longtext,
        application_id varchar(32),
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_arch_cert_item_apps (
        arch_cert_item_id varchar(32) not null,
        application_name varchar(255),
        idx integer not null,
        primary key (arch_cert_item_id, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_archived_cert_entity (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        entity longtext,
        reason varchar(255),
        explanation longtext,
        certification_id varchar(32),
        target_name varchar(255),
        identity_name varchar(450),
        account_group varchar(450),
        application varchar(255),
        native_identity varchar(322),
        reference_attribute varchar(255),
        schema_object_type varchar(255),
        target_id varchar(255),
        target_display_name varchar(255),
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_archived_cert_item (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        type varchar(255),
        sub_type varchar(255),
        item_id varchar(128),
        exception_application varchar(128),
        exception_attribute_name varchar(255),
        exception_attribute_value varchar(2048),
        exception_permission_target varchar(255),
        exception_permission_right varchar(255),
        exception_native_identity varchar(322),
        constraint_name varchar(2000),
        policy varchar(256),
        bundle varchar(255),
        violation_summary varchar(256),
        entitlements longtext,
        parent_id varchar(32),
        target_display_name varchar(255),
        target_name varchar(255),
        target_id varchar(255),
        idx integer,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_audit_config (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null unique,
        disabled bit,
        classes longtext,
        resources longtext,
        attributes longtext,
        actions longtext,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_audit_event (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        interface varchar(128),
        source varchar(128),
        action varchar(128),
        target varchar(255),
        application varchar(128),
        account_name varchar(256),
        instance varchar(128),
        attribute_name varchar(128),
        attribute_value varchar(450),
        tracking_id varchar(128),
        attributes longtext,
        string1 varchar(450),
        string2 varchar(450),
        string3 varchar(450),
        string4 varchar(450),
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_authentication_answer (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        identity_id varchar(32),
        question_id varchar(32),
        answer varchar(512),
        idx integer,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_authentication_question (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        question varchar(1024),
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_batch_request (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        file_name varchar(255),
        header varchar(4000),
        run_date bigint,
        completed_date bigint,
        record_count integer,
        completed_count integer,
        error_count integer,
        invalid_count integer,
        message varchar(4000),
        error_message longtext,
        file_contents longtext,
        status varchar(255),
        run_config longtext,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_batch_request_item (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        request_data varchar(4000),
        status varchar(255),
        message varchar(4000),
        error_message longtext,
        result varchar(255),
        identity_request_id varchar(255),
        target_identity_id varchar(255),
        batch_request_id varchar(32),
        idx integer,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_bundle (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        extended1 varchar(450),
        extended2 varchar(450),
        extended3 varchar(450),
        extended4 varchar(450),
        name varchar(128) not null unique,
        display_name varchar(128),
        displayable_name varchar(128),
        disabled bit,
        risk_score_weight integer,
        activity_config longtext,
        mining_statistics longtext,
        attributes longtext,
        type varchar(128),
        join_rule varchar(32),
        pending_workflow varchar(32),
        role_index varchar(32),
        selector longtext,
        provisioning_plan longtext,
        templates longtext,
        provisioning_forms longtext,
        or_profiles bit,
        activation_date bigint,
        deactivation_date bigint,
        scorecard varchar(32),
        pending_delete bit,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_bundle_archive (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128),
        source_id varchar(128),
        version integer,
        creator varchar(128),
        archive longtext,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_bundle_children (
        bundle varchar(32) not null,
        child varchar(32) not null,
        idx integer not null,
        primary key (bundle, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_bundle_permits (
        bundle varchar(32) not null,
        child varchar(32) not null,
        idx integer not null,
        primary key (bundle, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_bundle_requirements (
        bundle varchar(32) not null,
        child varchar(32) not null,
        idx integer not null,
        primary key (bundle, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_capability (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null unique,
        description varchar(1024),
        display_name varchar(128),
        applies_to_analyzer bit,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_capability_children (
        capability_id varchar(32) not null,
        child_id varchar(32) not null,
        idx integer not null,
        primary key (capability_id, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_capability_rights (
        capability_id varchar(32) not null,
        right_id varchar(32) not null,
        idx integer not null,
        primary key (capability_id, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_category (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null unique,
        targets longtext,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_cert_action_assoc (
        parent_id varchar(32) not null,
        child_id varchar(32) not null,
        idx integer not null,
        primary key (parent_id, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_cert_item_applications (
        certification_item_id varchar(32) not null,
        application_name varchar(255),
        idx integer not null,
        primary key (certification_item_id, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_certification (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        attributes longtext,
        iiqlock varchar(128),
        name varchar(256),
        short_name varchar(255),
        description varchar(1024),
        creator varchar(255),
        complete bit,
        complete_hierarchy bit,
        signed bigint,
        approver_rule varchar(512),
        finished bigint,
        expiration bigint,
        automatic_closing_date bigint,
        application_id varchar(255),
        manager varchar(255),
        group_definition varchar(512),
        group_definition_id varchar(128),
        group_definition_name varchar(255),
        comments longtext,
        error longtext,
        entities_to_refresh longtext,
        commands longtext,
        activated bigint,
        total_entities integer,
        excluded_entities integer,
        completed_entities integer,
        delegated_entities integer,
        percent_complete integer,
        certified_entities integer,
        cert_req_entities integer,
        overdue_entities integer,
        total_items integer,
        excluded_items integer,
        completed_items integer,
        delegated_items integer,
        item_percent_complete integer,
        certified_items integer,
        cert_req_items integer,
        overdue_items integer,
        remediations_kicked_off integer,
        remediations_completed integer,
        total_violations integer not null,
        violations_allowed integer not null,
        violations_remediated integer not null,
        violations_acknowledged integer not null,
        total_roles integer not null,
        roles_approved integer not null,
        roles_allowed integer not null,
        roles_remediated integer not null,
        total_exceptions integer not null,
        exceptions_approved integer not null,
        exceptions_allowed integer not null,
        exceptions_remediated integer not null,
        total_grp_perms integer not null,
        grp_perms_approved integer not null,
        grp_perms_remediated integer not null,
        total_grp_memberships integer not null,
        grp_memberships_approved integer not null,
        grp_memberships_remediated integer not null,
        total_accounts integer not null,
        accounts_approved integer not null,
        accounts_allowed integer not null,
        accounts_remediated integer not null,
        total_profiles integer not null,
        profiles_approved integer not null,
        profiles_remediated integer not null,
        total_scopes integer not null,
        scopes_approved integer not null,
        scopes_remediated integer not null,
        total_capabilities integer not null,
        capabilities_approved integer not null,
        capabilities_remediated integer not null,
        total_permits integer not null,
        permits_approved integer not null,
        permits_remediated integer not null,
        total_requirements integer not null,
        requirements_approved integer not null,
        requirements_remediated integer not null,
        total_hierarchies integer not null,
        hierarchies_approved integer not null,
        hierarchies_remediated integer not null,
        type varchar(255),
        task_schedule_id varchar(255),
        trigger_id varchar(128),
        certification_definition_id varchar(128),
        phase varchar(255),
        next_phase_transition bigint,
        phase_config longtext,
        process_revokes_immediately bit,
        next_remediation_scan bigint,
        entitlement_granularity varchar(255),
        bulk_reassignment bit,
        continuous bit,
        continuous_config longtext,
        next_cert_required_scan bigint,
        next_overdue_scan bigint,
        exclude_inactive bit,
        parent varchar(32),
        immutable bit,
        electronically_signed bit,
        idx integer,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_certification_action (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        owner_name varchar(255),
        email_template varchar(255),
        comments longtext,
        expiration datetime,
        work_item varchar(255),
        completion_state varchar(255),
        completion_comments longtext,
        completion_user varchar(128),
        actor_name varchar(128),
        actor_display_name varchar(128),
        acting_work_item varchar(255),
        description varchar(1024),
        status varchar(255),
        decision_date bigint,
        decision_certification_id varchar(128),
        reviewed bit,
        bulk_certified bit,
        mitigation_expiration bigint,
        remediation_action varchar(255),
        remediation_details longtext,
        additional_actions longtext,
        revoke_account bit,
        ready_for_remediation bit,
        remediation_kicked_off bit,
        remediation_completed bit,
        source_action varchar(32),
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_certification_archive (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(256),
        certification_id varchar(255),
        certification_group_id varchar(255),
        signed bigint,
        expiration bigint,
        creator varchar(128),
        comments longtext,
        archive longtext,
        immutable bit,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_certification_challenge (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        owner_name varchar(255),
        email_template varchar(255),
        comments longtext,
        expiration datetime,
        work_item varchar(255),
        completion_state varchar(255),
        completion_comments longtext,
        completion_user varchar(128),
        actor_name varchar(128),
        actor_display_name varchar(128),
        acting_work_item varchar(255),
        description varchar(1024),
        challenged bit,
        decision varchar(255),
        decision_comments longtext,
        decider_name varchar(255),
        challenge_decision_expired bit,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_certification_def_tags (
        cert_def_id varchar(32) not null,
        elt varchar(32) not null,
        idx integer not null,
        primary key (cert_def_id, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_certification_definition (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(255) not null unique,
        description varchar(1024),
        attributes longtext,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_certification_delegation (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        owner_name varchar(255),
        email_template varchar(255),
        comments longtext,
        expiration datetime,
        work_item varchar(255),
        completion_state varchar(255),
        completion_comments longtext,
        completion_user varchar(128),
        actor_name varchar(128),
        actor_display_name varchar(128),
        acting_work_item varchar(255),
        description varchar(1024),
        review_required bit,
        revoked bit,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_certification_entity (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        action varchar(32),
        delegation varchar(32),
        completed bigint,
        summary_status varchar(255),
        continuous_state varchar(255),
        last_decision bigint,
        next_continuous_state_change bigint,
        overdue_date bigint,
        has_differences bit,
        action_required bit,
        target_display_name varchar(255),
        target_name varchar(255),
        target_id varchar(255),
        custom1 varchar(450),
        custom2 varchar(450),
        custom_map longtext,
        type varchar(255),
        bulk_certified bit,
        attributes longtext,
        identity_id varchar(450),
        firstname varchar(255),
        lastname varchar(255),
        composite_score integer,
        snapshot_id varchar(255),
        differences longtext,
        new_user bit,
        account_group varchar(450),
        application varchar(255),
        native_identity varchar(322),
        reference_attribute varchar(255),
        schema_object_type varchar(255),
        certification_id varchar(32),
        idx integer,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_certification_group (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(256),
        type varchar(255),
        status varchar(255),
        attributes longtext,
        total_certifications integer,
        percent_complete integer,
        completed_certifications integer,
        certification_definition varchar(32),
        messages longtext,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_certification_groups (
        certification_id varchar(32) not null,
        group_id varchar(32) not null,
        idx integer not null,
        primary key (certification_id, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_certification_item (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        action varchar(32),
        delegation varchar(32),
        completed bigint,
        summary_status varchar(255),
        continuous_state varchar(255),
        last_decision bigint,
        next_continuous_state_change bigint,
        overdue_date bigint,
        has_differences bit,
        action_required bit,
        target_display_name varchar(255),
        target_name varchar(255),
        target_id varchar(255),
        custom1 varchar(450),
        custom2 varchar(450),
        custom_map longtext,
        bundle varchar(255),
        type varchar(255),
        sub_type varchar(255),
        bundle_assignment_id varchar(128),
        certification_entity_id varchar(32),
        exception_entitlements varchar(32),
        needs_refresh bit,
        exception_application varchar(128),
        exception_attribute_name varchar(255),
        exception_attribute_value varchar(2048),
        exception_permission_target varchar(255),
        exception_permission_right varchar(255),
        policy_violation longtext,
        violation_summary varchar(256),
        challenge varchar(32),
        wake_up_date bigint,
        reminders_sent integer,
        needs_continuous_flush bit,
        phase varchar(255),
        next_phase_transition bigint,
        finished_date bigint,
        attributes longtext,
        extended1 varchar(450),
        extended2 varchar(450),
        extended3 varchar(450),
        extended4 varchar(450),
        extended5 varchar(450),
        idx integer,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_certification_tags (
        certification_id varchar(32) not null,
        elt varchar(32) not null,
        idx integer not null,
        primary key (certification_id, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_certifiers (
        certification_id varchar(32) not null,
        certifier varchar(255),
        idx integer not null,
        primary key (certification_id, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_child_certification_ids (
        certification_archive_id varchar(32) not null,
        child_id varchar(255),
        idx integer not null,
        primary key (certification_archive_id, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_configuration (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null unique,
        description varchar(1024),
        attributes longtext,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_correlation_config (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null unique,
        description varchar(256),
        attribute_assignments longtext,
        direct_assignments longtext,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_custom (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128),
        description varchar(1024),
        attributes longtext,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_dashboard_content (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null unique,
        description varchar(1024),
        title varchar(255),
        source varchar(255),
        required bit,
        region_size varchar(255),
        source_task_id varchar(128),
        type varchar(255),
        parent varchar(32),
        arguments longtext,
        enabling_attributes longtext,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_dashboard_content_rights (
        dashboard_content_id varchar(32) not null,
        right_id varchar(32) not null,
        idx integer not null,
        primary key (dashboard_content_id, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_dashboard_layout (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null unique,
        type varchar(255),
        regions longtext,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_dashboard_reference (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        identity_dashboard_id varchar(32),
        content_id varchar(32),
        region varchar(128),
        order_id integer,
        minimized bit,
        arguments longtext,
        idx integer,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_database_version (
        name varchar(255) not null,
        system_version varchar(128),
        schema_version varchar(128),
        primary key (name)
    ) ENGINE=InnoDB;

    create table identityiq.spt_deleted_object (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        uuid varchar(128),
        name varchar(128),
        native_identity varchar(322) not null,
        last_refresh bigint,
        object_type varchar(128),
        application varchar(32),
        attributes longtext,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_dictionary (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128),
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_dictionary_term (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        value varchar(128) not null unique,
        dictionary_id varchar(32),
        idx integer,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_dynamic_scope (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null unique,
        description varchar(1024),
        selector longtext,
        allow_all bit,
        population_request_authority longtext,
        role_request_control varchar(32),
        application_request_control varchar(32),
        managed_attr_request_control varchar(32),
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_dynamic_scope_exclusions (
        dynamic_scope_id varchar(32) not null,
        identity_id varchar(32) not null,
        idx integer not null,
        primary key (dynamic_scope_id, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_dynamic_scope_inclusions (
        dynamic_scope_id varchar(32) not null,
        identity_id varchar(32) not null,
        idx integer not null,
        primary key (dynamic_scope_id, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_email_template (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null unique,
        description varchar(1024),
        from_address varchar(255),
        to_address varchar(255),
        cc_address varchar(255),
        bcc_address varchar(255),
        subject varchar(255),
        body longtext,
        signature longtext,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_email_template_properties (
        id varchar(32) not null,
        value varchar(255),
        name varchar(78) not null,
        primary key (id, name)
    ) ENGINE=InnoDB;

    create table identityiq.spt_entitlement_group (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128),
        application varchar(32),
        instance varchar(128),
        native_identity varchar(322),
        display_name varchar(128),
        account_only bit not null,
        attributes longtext,
        identity_id varchar(32),
        idx integer,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_entitlement_snapshot (
        id varchar(32) not null,
        application varchar(255),
        instance varchar(128),
        native_identity varchar(322),
        display_name varchar(450),
        account_only bit not null,
        attributes longtext,
        certification_item_id varchar(32),
        idx integer,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_file_bucket (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        file_index integer,
        parent_id varchar(32),
        data longblob,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_form (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null unique,
        description varchar(4000),
        hidden bit,
        type varchar(255),
        application varchar(32),
        sections longtext,
        buttons longtext,
        attributes longtext,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_full_text_index (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        name varchar(128) not null unique,
        description varchar(1024),
        iiqlock varchar(128),
        last_refresh bigint,
        attributes longtext,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_generic_constraint (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(2000),
        description varchar(4000),
        policy varchar(32),
        violation_owner_type varchar(255),
        violation_owner varchar(32),
        violation_owner_rule varchar(32),
        compensating_control longtext,
        disabled bit,
        weight integer,
        remediation_advice longtext,
        violation_summary longtext,
        arguments longtext,
        selectors longtext,
        idx integer,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_group_definition (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(255),
        description varchar(1024),
        filter longtext,
        last_refresh bigint,
        null_group bit,
        indexed bit,
        private bit,
        factory varchar(32),
        group_index varchar(32),
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_group_factory (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(255),
        description varchar(1024),
        factory_attribute varchar(255),
        enabled bit,
        last_refresh bigint,
        group_owner_rule varchar(32),
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_group_index (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        incomplete bit,
        composite_score integer,
        attributes longtext,
        items longtext,
        business_role_score integer,
        raw_business_role_score integer,
        entitlement_score integer,
        raw_entitlement_score integer,
        policy_score integer,
        raw_policy_score integer,
        certification_score integer,
        total_violations integer,
        total_remediations integer,
        total_delegations integer,
        total_mitigations integer,
        total_approvals integer,
        definition varchar(32),
        name varchar(255),
        member_count integer,
        band_count integer,
        band1 integer,
        band2 integer,
        band3 integer,
        band4 integer,
        band5 integer,
        band6 integer,
        band7 integer,
        band8 integer,
        band9 integer,
        band10 integer,
        certifications_due integer,
        certifications_on_time integer,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_group_permissions (
        entitlement_group_id varchar(32) not null,
        target varchar(255),
        annotation varchar(255),
        rights varchar(4000),
        attributes longtext,
        idx integer not null,
        primary key (entitlement_group_id, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_identity (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        extended1 varchar(450),
        extended2 varchar(450),
        extended3 varchar(450),
        extended4 varchar(450),
        extended5 varchar(450),
        extended6 varchar(450),
        extended7 varchar(450),
        extended8 varchar(450),
        extended9 varchar(450),
        extended10 varchar(450),
        extended_identity1 varchar(32),
        extended_identity2 varchar(32),
        extended_identity3 varchar(32),
        extended_identity4 varchar(32),
        extended_identity5 varchar(32),
        name varchar(128) not null unique,
        description varchar(1024),
        protected bit,
        needs_refresh bit,
        iiqlock varchar(128),
        attributes longtext,
        manager varchar(32),
        display_name varchar(128),
        firstname varchar(128),
        lastname varchar(128),
        email varchar(128),
        manager_status bit,
        inactive bit,
        last_login bigint,
        last_refresh bigint,
        password varchar(450),
        password_expiration bigint,
        password_history varchar(2000),
        bundle_summary varchar(2000),
        assigned_role_summary varchar(2000),
        correlated bit,
        correlated_overridden bit,
        auth_lock_start bigint,
        failed_auth_question_attempts integer,
        failed_login_attempts integer,
        controls_assigned_scope bit,
        certifications longtext,
        activity_config longtext,
        preferences longtext,
        scorecard varchar(32),
        uipreferences varchar(32),
        attribute_meta_data longtext,
        workgroup bit,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_identity_archive (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128),
        source_id varchar(128),
        version integer,
        creator varchar(128),
        archive longtext,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_identity_assigned_roles (
        identity_id varchar(32) not null,
        bundle varchar(32) not null,
        idx integer not null,
        primary key (identity_id, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_identity_bundles (
        identity_id varchar(32) not null,
        bundle varchar(32) not null,
        idx integer not null,
        primary key (identity_id, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_identity_capabilities (
        identity_id varchar(32) not null,
        capability_id varchar(32) not null,
        idx integer not null,
        primary key (identity_id, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_identity_controlled_scopes (
        identity_id varchar(32) not null,
        scope_id varchar(32) not null,
        idx integer not null,
        primary key (identity_id, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_identity_dashboard (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128),
        description varchar(1024),
        identity_id varchar(32),
        type varchar(255),
        layout varchar(32),
        arguments longtext,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_identity_entitlement (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        start_date bigint,
        end_date bigint,
        attributes longtext,
        name varchar(255),
        value varchar(450),
        annotation varchar(450),
        display_name varchar(255),
        native_identity varchar(450),
        instance varchar(128),
        application varchar(32),
        identity_id varchar(32) not null,
        aggregation_state varchar(255),
        source varchar(64),
        assigned bit,
        allowed bit,
        granted_by_role bit,
        assigner varchar(128),
        assignment_id varchar(64),
        assignment_note varchar(1024),
        type varchar(255),
        request_item varchar(32),
        pending_request_item varchar(32),
        certification_item varchar(32),
        pending_certification_item varchar(32),
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_identity_external_attr (
        id varchar(32) not null,
        object_id varchar(64),
        attribute_name varchar(64),
        value varchar(322),
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_identity_history_item (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        identity_id varchar(32),
        type varchar(255),
        certifiable_descriptor longtext,
        action longtext,
        certification_link longtext,
        comments longtext,
        certification_type varchar(255),
        status varchar(255),
        actor varchar(128),
        entry_date bigint,
        application varchar(128),
        instance varchar(128),
        account varchar(128),
        native_identity varchar(322),
        attribute varchar(450),
        value varchar(450),
        policy varchar(255),
        constraint_name varchar(2000),
        role varchar(255),
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_identity_request (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(255),
        state varchar(255),
        type varchar(255),
        source varchar(255),
        target_id varchar(128),
        target_display_name varchar(255),
        target_class varchar(255),
        requester_display_name varchar(255),
        requester_id varchar(128),
        end_date bigint,
        verified bigint,
        priority varchar(128),
        completion_status varchar(128),
        execution_status varchar(128),
        has_messages bit not null,
        external_ticket_id varchar(128),
        attributes longtext,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_identity_request_item (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        start_date bigint,
        end_date bigint,
        attributes longtext,
        name varchar(255),
        value varchar(450),
        annotation varchar(450),
        display_name varchar(255),
        native_identity varchar(450),
        instance varchar(128),
        application varchar(255),
        owner_name varchar(128),
        approver_name varchar(128),
        operation varchar(128),
        retries integer,
        provisioning_engine varchar(255),
        approval_state varchar(128),
        provisioning_state varchar(128),
        compilation_status varchar(128),
        expansion_cause varchar(128),
        identity_request_id varchar(32),
        idx integer,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_identity_role_metadata (
        identity_id varchar(32) not null,
        role_metadata_id varchar(32) not null,
        idx integer not null,
        primary key (identity_id, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_identity_snapshot (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128),
        identity_id varchar(255),
        identity_name varchar(255),
        summary varchar(2000),
        differences varchar(2000),
        applications varchar(2000),
        scorecard longtext,
        attributes longtext,
        bundles longtext,
        exceptions longtext,
        links longtext,
        violations longtext,
        assigned_roles longtext,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_identity_trigger (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(256),
        description varchar(1024),
        disabled bit,
        type varchar(255),
        rule_id varchar(32),
        attribute_name varchar(256),
        old_value_filter varchar(256),
        new_value_filter varchar(256),
        selector longtext,
        handler varchar(256),
        parameters longtext,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_identity_workgroups (
        identity_id varchar(32) not null,
        workgroup varchar(32) not null,
        idx integer not null,
        primary key (identity_id, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_integration_config (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null unique,
        description varchar(4000),
        executor varchar(255),
        exec_style varchar(255),
        role_sync_style varchar(255),
        template bit,
        signature longtext,
        attributes longtext,
        plan_initializer varchar(32),
        resources longtext,
        application_id varchar(32),
        role_sync_filter longtext,
        container_id varchar(32),
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_jasper_files (
        result varchar(32) not null,
        elt varchar(32) not null,
        idx integer not null,
        primary key (result, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_jasper_page_bucket (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        bucket_number integer,
        handler_id varchar(128),
        xml longtext,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_jasper_result (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        handler_id varchar(128),
        print_xml longtext,
        page_count integer,
        pages_per_bucket integer,
        handler_page_count integer,
        attributes longtext,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_jasper_template (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null unique,
        design_xml longtext,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_link (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        key1 varchar(450),
        key2 varchar(255),
        key3 varchar(255),
        key4 varchar(255),
        extended1 varchar(450),
        extended2 varchar(450),
        extended3 varchar(450),
        extended4 varchar(450),
        extended5 varchar(450),
        uuid varchar(128),
        display_name varchar(128),
        instance varchar(128),
        native_identity varchar(322) not null,
        last_refresh bigint,
        last_target_aggregation bigint,
        manually_correlated bit,
        entitlements bit not null,
        identity_id varchar(32),
        application varchar(32),
        attributes longtext,
        password_history varchar(2000),
        component_ids varchar(256),
        attribute_meta_data longtext,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_link_external_attr (
        id varchar(32) not null,
        object_id varchar(64),
        attribute_name varchar(64),
        value varchar(322),
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_localized_attribute (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        name varchar(255),
        locale varchar(128),
        attribute varchar(128),
        value varchar(1024),
        target_class varchar(255),
        target_name varchar(255),
        target_id varchar(255),
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_managed_attr_inheritance (
        managedattribute varchar(32) not null,
        inherits_from varchar(32) not null,
        idx integer not null,
        primary key (managedattribute, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_managed_attr_perms (
        managedattribute varchar(32) not null,
        target varchar(255),
        rights varchar(4000),
        annotation varchar(255),
        attributes longtext,
        idx integer not null,
        primary key (managedattribute, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_managed_attr_target_perms (
        managedattribute varchar(32) not null,
        target varchar(255),
        rights varchar(4000),
        annotation varchar(255),
        attributes longtext,
        idx integer not null,
        primary key (managedattribute, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_managed_attribute (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        extended1 varchar(450),
        extended2 varchar(450),
        extended3 varchar(450),
        purview varchar(128),
        application varchar(32),
        type varchar(255),
        aggregated bit,
        attribute varchar(322),
        value varchar(450),
        display_name varchar(450),
        displayable_name varchar(450),
        uuid varchar(128),
        attributes longtext,
        requestable bit,
        uncorrelated bit,
        last_refresh bigint,
        last_target_aggregation bigint,
        key1 varchar(128),
        key2 varchar(128),
        key3 varchar(128),
        key4 varchar(128),
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_message_template (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null unique,
        description varchar(1024),
        text longtext,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_mining_config (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null unique,
        description varchar(1024),
        arguments longtext,
        app_constraints longtext,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_mitigation_expiration (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        expiration bigint not null,
        mitigator varchar(32) not null,
        comments longtext,
        identity_id varchar(32),
        certification_link longtext,
        certifiable_descriptor longtext,
        action varchar(255),
        action_parameters longtext,
        last_action_date bigint,
        role_name varchar(128),
        policy varchar(128),
        constraint_name varchar(2000),
        application varchar(128),
        instance varchar(128),
        native_identity varchar(322),
        account_display_name varchar(128),
        attribute_name varchar(450),
        attribute_value varchar(450),
        permission bit,
        idx integer,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_object_config (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null unique,
        object_attributes longtext,
        config_attributes longtext,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_partition_result (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        stack longtext,
        attributes longtext,
        launcher varchar(255),
        host varchar(255),
        launched bigint,
        progress varchar(255),
        percent_complete integer,
        type varchar(255),
        messages longtext,
        completed bigint,
        task_result varchar(32),
        name varchar(255) not null unique,
        task_terminated bit,
        completion_status varchar(255),
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_password_policy (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        name varchar(128) not null unique,
        description varchar(512),
        password_constraints longtext,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_password_policy_holder (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        policy varchar(32),
        selector longtext,
        application varchar(32),
        idx integer,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_persisted_file (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(256),
        description varchar(1024),
        content_type varchar(128),
        content_length bigint,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_plugin (
        id varchar(32) not null,
        name varchar(255),
        created bigint,
        modified bigint,
        install_date bigint,
        display_name varchar(255),
        version varchar(255),
        disabled bit,
        right_required varchar(255),
        min_system_version varchar(255),
        max_system_version varchar(255),
        attributes longtext,
        position integer,
        certification_level varchar(255),
        file_id varchar(32) unique,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_policy (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null unique,
        template bit,
        type varchar(255),
        type_key varchar(255),
        executor varchar(255),
        config_page varchar(255),
        certification_actions varchar(255),
        violation_owner_type varchar(255),
        violation_owner varchar(32),
        violation_owner_rule varchar(32),
        state varchar(255),
        arguments longtext,
        signature longtext,
        alert longtext,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_policy_violation (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(2000),
        description varchar(4000),
        identity_id varchar(32),
        pending_workflow varchar(32),
        renderer varchar(255),
        active bit,
        policy_id varchar(255),
        policy_name varchar(255),
        constraint_id varchar(255),
        status varchar(255),
        constraint_name varchar(2000),
        left_bundles longtext,
        right_bundles longtext,
        activity_id varchar(255),
        bundles_marked_for_remediation longtext,
        entitlements_marked_for_remed longtext,
        mitigator varchar(255),
        arguments longtext,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_process (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null unique,
        description varchar(1024),
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_process_application (
        process varchar(32) not null,
        application varchar(32) not null,
        idx integer not null,
        primary key (process, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_process_bundles (
        process varchar(32) not null,
        elt varchar(32) not null,
        idx integer not null,
        primary key (process, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_process_log (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        process_name varchar(128),
        case_id varchar(128),
        workflow_case_name varchar(450),
        launcher varchar(128),
        case_status varchar(128),
        step_name varchar(128),
        approval_name varchar(128),
        owner_name varchar(128),
        start_time bigint,
        end_time bigint,
        step_duration integer,
        escalations integer,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_profile (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128),
        description varchar(1024),
        bundle_id varchar(32),
        disabled bit,
        account_type varchar(128),
        application varchar(32),
        attributes longtext,
        idx integer,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_profile_constraints (
        profile varchar(32) not null,
        elt longtext,
        idx integer not null,
        primary key (profile, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_profile_permissions (
        profile varchar(32) not null,
        target varchar(255),
        rights varchar(4000),
        attributes longtext,
        idx integer not null,
        primary key (profile, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_provisioning_request (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        identity_id varchar(32),
        target varchar(128),
        requester varchar(128),
        expiration bigint,
        provisioning_plan longtext,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_provisioning_transaction (
        id varchar(32) not null,
        name varchar(255),
        created bigint,
        modified bigint,
        operation varchar(255),
        source varchar(255),
        application_name varchar(255),
        identity_name varchar(255),
        identity_display_name varchar(255),
        native_identity varchar(322),
        account_display_name varchar(322),
        attributes longtext,
        integration varchar(255),
        certification_id varchar(32),
        forced bit,
        type varchar(255),
        status varchar(255),
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_quick_link (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null unique,
        message_key varchar(128),
        description varchar(1024),
        action varchar(128),
        css_class varchar(128),
        hidden bit,
        category varchar(128),
        ordering integer,
        arguments longtext,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_quick_link_options (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        allow_bulk bit,
        allow_other bit,
        allow_self bit,
        options longtext,
        dynamic_scope varchar(32) not null,
        quick_link varchar(32),
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_remediation_item (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        description varchar(1024),
        remediation_entity_type varchar(255),
        work_item_id varchar(32),
        certification_item varchar(255),
        assignee varchar(32),
        remediation_identity varchar(255),
        remediation_details longtext,
        completion_comments longtext,
        completion_date bigint,
        assimilated bit,
        comments longtext,
        idx integer,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_remote_login_token (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null,
        creator varchar(128) not null,
        remote_host varchar(128),
        expiration bigint,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_request (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        stack longtext,
        attributes longtext,
        launcher varchar(255),
        host varchar(255),
        launched bigint,
        progress varchar(255),
        percent_complete integer,
        type varchar(255),
        messages longtext,
        completed bigint,
        expiration bigint,
        name varchar(450),
        definition varchar(32),
        task_result varchar(32),
        phase integer,
        dependent_phase integer,
        next_launch bigint,
        retry_count integer,
        retry_interval integer,
        string1 varchar(2048),
        completion_status varchar(255),
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_request_arguments (
        signature varchar(32) not null,
        name varchar(255),
        type varchar(255),
        filter_string varchar(255),
        description longtext,
        prompt longtext,
        multi bit,
        required bit,
        idx integer not null,
        primary key (signature, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_request_definition (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null unique,
        description varchar(4000),
        executor varchar(255),
        form_path varchar(128),
        template bit,
        hidden bit,
        result_expiration integer,
        progress_interval integer,
        sub_type varchar(128),
        type varchar(255),
        progress_mode varchar(255),
        arguments longtext,
        parent varchar(32),
        retry_max integer,
        retry_interval integer,
        sig_description longtext,
        return_type varchar(255),
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_request_definition_rights (
        request_definition_id varchar(32) not null,
        right_id varchar(32) not null,
        idx integer not null,
        primary key (request_definition_id, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_request_returns (
        signature varchar(32) not null,
        name varchar(255),
        type varchar(255),
        filter_string varchar(255),
        description longtext,
        prompt longtext,
        multi bit,
        idx integer not null,
        primary key (signature, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_resource_event (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        application varchar(32),
        provisioning_plan longtext,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_right (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null unique,
        description varchar(1024),
        display_name varchar(128),
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_right_config (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null unique,
        rights longtext,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_role_change_event (
        id varchar(32) not null,
        created bigint,
        bundle_id varchar(128),
        bundle_name varchar(128),
        provisioning_plan longtext,
        bundle_deleted bit,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_role_index (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        incomplete bit,
        composite_score integer,
        attributes longtext,
        items longtext,
        bundle varchar(32),
        assigned_count integer,
        detected_count integer,
        associated_to_role bit,
        last_certified_membership bigint,
        last_certified_composition bigint,
        last_assigned bigint,
        entitlement_count integer,
        entitlement_count_inheritance integer,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_role_metadata (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        role varchar(32),
        name varchar(255),
        additional_entitlements bit,
        missing_required bit,
        assigned bit,
        detected bit,
        detected_exception bit,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_role_mining_result (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128),
        pending bit,
        config longtext,
        roles longtext,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_role_scorecard (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        role_id varchar(32),
        members integer,
        members_extra_ent integer,
        members_missing_req integer,
        detected integer,
        detected_exc integer,
        provisioned_ent integer,
        permitted_ent integer,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_rule (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null unique,
        description varchar(1024),
        language varchar(255),
        source longtext,
        type varchar(255),
        attributes longtext,
        sig_description longtext,
        return_type varchar(255),
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_rule_dependencies (
        rule_id varchar(32) not null,
        dependency varchar(32) not null,
        idx integer not null,
        primary key (rule_id, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_rule_registry (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null unique,
        templates longtext,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_rule_registry_callouts (
        rule_registry_id varchar(32) not null,
        rule_id varchar(32) not null,
        callout varchar(78) not null,
        primary key (rule_registry_id, callout)
    ) ENGINE=InnoDB;

    create table identityiq.spt_rule_signature_arguments (
        signature varchar(32) not null,
        name varchar(255),
        type varchar(255),
        filter_string varchar(255),
        description longtext,
        prompt longtext,
        multi bit,
        idx integer not null,
        primary key (signature, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_rule_signature_returns (
        signature varchar(32) not null,
        name varchar(255),
        type varchar(255),
        filter_string varchar(255),
        description longtext,
        prompt longtext,
        multi bit,
        idx integer not null,
        primary key (signature, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_schema_attributes (
        applicationschema varchar(32) not null,
        name varchar(255),
        type varchar(255),
        description longtext,
        required bit,
        entitlement bit,
        is_group bit,
        managed bit,
        multi_valued bit,
        minable bit,
        indexed bit,
        correlation_key integer,
        source varchar(255),
        internal_name varchar(255),
        default_value varchar(255),
        remed_mod_type varchar(255),
        schema_object_type varchar(255),
        idx integer not null,
        primary key (applicationschema, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_scope (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null,
        display_name varchar(128),
        parent_id varchar(32),
        manually_created bit,
        dormant bit,
        path varchar(450),
        dirty bit,
        idx integer,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_score_config (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null unique,
        maximum_score integer,
        maximum_number_of_bands integer,
        application_configs longtext,
        identity_scores longtext,
        application_scores longtext,
        bands longtext,
        right_config varchar(32),
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_scorecard (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        incomplete bit,
        composite_score integer,
        attributes longtext,
        items longtext,
        business_role_score integer,
        raw_business_role_score integer,
        entitlement_score integer,
        raw_entitlement_score integer,
        policy_score integer,
        raw_policy_score integer,
        certification_score integer,
        total_violations integer,
        total_remediations integer,
        total_delegations integer,
        total_mitigations integer,
        total_approvals integer,
        identity_id varchar(32),
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_server (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        name varchar(128) not null unique,
        heartbeat bigint,
        inactive bit,
        attributes longtext,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_service_definition (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        name varchar(128) not null unique,
        description varchar(1024),
        executor varchar(255),
        exec_interval integer,
        hosts varchar(1024),
        attributes longtext,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_service_status (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        name varchar(128) not null unique,
        description varchar(1024),
        definition varchar(32),
        host varchar(255),
        last_start bigint,
        last_end bigint,
        attributes longtext,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_sign_off_history (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        sign_date bigint,
        signer_id varchar(128),
        signer_name varchar(128),
        signer_display_name varchar(128),
        application varchar(128),
        account varchar(128),
        text longtext,
        electronic_sign bit,
        certification_id varchar(32),
        idx integer,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_snapshot_permissions (
        snapshot varchar(32) not null,
        target varchar(255),
        rights varchar(4000),
        attributes longtext,
        idx integer not null,
        primary key (snapshot, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_sodconstraint (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(2000),
        description varchar(4000),
        policy varchar(32),
        violation_owner_type varchar(255),
        violation_owner varchar(32),
        violation_owner_rule varchar(32),
        compensating_control longtext,
        disabled bit,
        weight integer,
        remediation_advice longtext,
        violation_summary longtext,
        arguments longtext,
        idx integer,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_sodconstraint_left (
        sodconstraint varchar(32) not null,
        businessrole varchar(32) not null,
        idx integer not null,
        primary key (sodconstraint, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_sodconstraint_right (
        sodconstraint varchar(32) not null,
        businessrole varchar(32) not null,
        idx integer not null,
        primary key (sodconstraint, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_sync_roles (
        config varchar(32) not null,
        bundle varchar(32) not null,
        idx integer not null,
        primary key (config, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_syslog_event (
        id varchar(32) not null,
        created bigint,
        quick_key varchar(12),
        event_level varchar(6),
        classname varchar(128),
        line_number varchar(6),
        message varchar(450),
        thread varchar(128),
        server varchar(128),
        username varchar(128),
        stacktrace longtext,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_tag (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null unique,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_target (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        extended1 varchar(255),
        name varchar(512),
        native_owner_id varchar(128),
        target_source varchar(32),
        target_host varchar(1024),
        display_name varchar(400),
        full_path longtext,
        full_path_hash varchar(128),
        attributes longtext,
        native_object_id varchar(322),
        parent varchar(32),
        target_size bigint,
        last_aggregation bigint,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_target_association (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        object_id varchar(32),
        type varchar(8),
        hierarchy varchar(512),
        flattened bit,
        application_name varchar(128),
        target_type varchar(128),
        target_name varchar(255),
        target_id varchar(32),
        rights varchar(512),
        inherited bit,
        effective integer,
        deny_permission bit,
        last_aggregation bigint,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_target_source (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128),
        description varchar(1024),
        collector varchar(255),
        last_refresh bigint,
        configuration longtext,
        correlation_rule varchar(32),
        creation_rule varchar(32),
        refresh_rule varchar(32),
        transformation_rule varchar(32),
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_target_sources (
        application varchar(32) not null,
        elt varchar(32) not null,
        idx integer not null,
        primary key (application, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_task_definition (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null unique,
        description varchar(4000),
        executor varchar(255),
        form_path varchar(128),
        template bit,
        hidden bit,
        result_expiration integer,
        progress_interval integer,
        sub_type varchar(128),
        type varchar(255),
        progress_mode varchar(255),
        arguments longtext,
        parent varchar(32),
        result_renderer varchar(255),
        concurrent bit,
        deprecated bit not null,
        result_action varchar(255),
        signoff_config varchar(32),
        sig_description longtext,
        return_type varchar(255),
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_task_definition_rights (
        task_definition_id varchar(32) not null,
        right_id varchar(32) not null,
        idx integer not null,
        primary key (task_definition_id, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_task_event (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        phase varchar(128),
        task_result varchar(32),
        rule_id varchar(32),
        attributes longtext,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_task_result (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        stack longtext,
        attributes longtext,
        launcher varchar(255),
        host varchar(255),
        launched bigint,
        progress varchar(255),
        percent_complete integer,
        type varchar(255),
        messages longtext,
        completed bigint,
        expiration bigint,
        verified bigint,
        name varchar(255) not null unique,
        definition varchar(32),
        schedule varchar(255),
        pending_signoffs integer,
        signoff longtext,
        report varchar(32),
        target_class varchar(255),
        target_id varchar(255),
        target_name varchar(255),
        task_terminated bit,
        partitioned bit,
        completion_status varchar(255),
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_task_signature_arguments (
        signature varchar(32) not null,
        name varchar(255),
        type varchar(255),
        filter_string varchar(255),
        help_key varchar(255),
        input_template varchar(255),
        description longtext,
        prompt longtext,
        multi bit,
        required bit,
        default_value varchar(255),
        idx integer not null,
        primary key (signature, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_task_signature_returns (
        signature varchar(32) not null,
        name varchar(255),
        type varchar(255),
        filter_string varchar(255),
        description longtext,
        prompt longtext,
        multi bit,
        idx integer not null,
        primary key (signature, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_time_period (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128),
        classifier varchar(255),
        init_parameters longtext,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_uiconfig (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null unique,
        attributes longtext,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_uipreferences (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        preferences longtext,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_widget (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null unique,
        title varchar(128),
        selector longtext,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_work_item (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(255),
        description varchar(1024),
        handler varchar(255),
        renderer varchar(255),
        target_class varchar(255),
        target_id varchar(255),
        target_name varchar(255),
        type varchar(255),
        state varchar(255),
        severity varchar(255),
        requester varchar(32),
        completion_comments longtext,
        notification bigint,
        expiration bigint,
        wake_up_date bigint,
        reminders integer,
        escalation_count integer,
        notification_config longtext,
        workflow_case varchar(32),
        attributes longtext,
        owner_history longtext,
        certification varchar(255),
        certification_entity varchar(255),
        certification_item varchar(255),
        identity_request_id varchar(128),
        assignee varchar(32),
        iiqlock varchar(128),
        certification_ref_id varchar(32),
        idx integer,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_work_item_archive (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        work_item_id varchar(128),
        name varchar(255),
        owner_name varchar(255),
        identity_request_id varchar(128),
        assignee varchar(255),
        requester varchar(255),
        description varchar(1024),
        handler varchar(255),
        renderer varchar(255),
        target_class varchar(255),
        target_id varchar(255),
        target_name varchar(255),
        archived bigint,
        type varchar(255),
        state varchar(255),
        severity varchar(255),
        attributes longtext,
        system_attributes longtext,
        immutable bit,
        signed bit,
        completer varchar(255),
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_work_item_comments (
        work_item varchar(32) not null,
        author varchar(255),
        comments longtext,
        comment_date bigint,
        idx integer not null,
        primary key (work_item, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_work_item_config (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128),
        description_template varchar(1024),
        disabled bit,
        no_work_item bit,
        parent varchar(32),
        owner_rule varchar(32),
        hours_till_escalation integer,
        hours_between_reminders integer,
        max_reminders integer,
        notification_email varchar(32),
        reminder_email varchar(32),
        escalation_email varchar(32),
        escalation_rule varchar(32),
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_work_item_owners (
        config varchar(32) not null,
        elt varchar(32) not null,
        idx integer not null,
        primary key (config, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_workflow (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null unique,
        description varchar(4000),
        type varchar(128),
        task_type varchar(255),
        template bit,
        explicit_transitions bit,
        monitored bit,
        result_expiration integer,
        complete bit,
        handler varchar(128),
        work_item_renderer varchar(128),
        variable_definitions longtext,
        config_form varchar(128),
        steps longtext,
        work_item_config longtext,
        variables longtext,
        libraries varchar(128),
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_workflow_case (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        stack longtext,
        attributes longtext,
        launcher varchar(255),
        host varchar(255),
        launched bigint,
        progress varchar(255),
        percent_complete integer,
        type varchar(255),
        messages longtext,
        completed bigint,
        name varchar(450),
        description varchar(1024),
        complete bit,
        target_class varchar(255),
        target_id varchar(255),
        target_name varchar(255),
        workflow longtext,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_workflow_registry (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128) not null unique,
        types longtext,
        templates longtext,
        callables longtext,
        attributes longtext,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_workflow_rule_libraries (
        rule_id varchar(32) not null,
        dependency varchar(32) not null,
        idx integer not null,
        primary key (rule_id, idx)
    ) ENGINE=InnoDB;

    create table identityiq.spt_workflow_target (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        owner varchar(32),
        assigned_scope varchar(32),
        assigned_scope_path varchar(450),
        name varchar(128),
        description varchar(1024),
        class_name varchar(255),
        object_id varchar(255),
        object_name varchar(255),
        workflow_case_id varchar(32) not null,
        idx integer,
        primary key (id)
    ) ENGINE=InnoDB;

    create table identityiq.spt_workflow_test_suite (
        id varchar(32) not null,
        created bigint,
        modified bigint,
        name varchar(128) not null unique,
        description varchar(4000),
        replicated bit,
        case_name varchar(255),
        tests longtext,
        responses longtext,
        attributes longtext,
        primary key (id)
    ) ENGINE=InnoDB;

    create index spt_actgroup_attr on identityiq.spt_account_group (reference_attribute);

    create index spt_actgroup_key4_ci on identityiq.spt_account_group (key4);

    create index spt_actgroup_name_csi on identityiq.spt_account_group (name);

    create index spt_actgroup_key2_ci on identityiq.spt_account_group (key2);

    create index spt_actgroup_key3_ci on identityiq.spt_account_group (key3);

    create index spt_actgroup_key1_ci on identityiq.spt_account_group (key1);

    create index spt_actgroup_lastAggregation on identityiq.spt_account_group (last_target_aggregation);

    create index spt_actgroup_native_ci on identityiq.spt_account_group (native_identity(255));

    alter table identityiq.spt_account_group 
        add index FK54D3916539D71460 (application), 
        add constraint FK54D3916539D71460 
        foreign key (application) 
        references identityiq.spt_application (id);

    alter table identityiq.spt_account_group 
        add index FK54D39165486634B7 (assigned_scope), 
        add constraint FK54D39165486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_account_group 
        add index FK54D39165A5FB1B1 (owner), 
        add constraint FK54D39165A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_account_group_inheritance 
        add index FK64E35CF0B106CC7F (account_group), 
        add constraint FK64E35CF0B106CC7F 
        foreign key (account_group) 
        references identityiq.spt_account_group (id);

    alter table identityiq.spt_account_group_inheritance 
        add index FK64E35CF034D1C743 (inherits_from), 
        add constraint FK64E35CF034D1C743 
        foreign key (inherits_from) 
        references identityiq.spt_account_group (id);

    alter table identityiq.spt_account_group_perms 
        add index FK196E8029128ABF04 (accountgroup), 
        add constraint FK196E8029128ABF04 
        foreign key (accountgroup) 
        references identityiq.spt_account_group (id);

    alter table identityiq.spt_account_group_target_perms 
        add index FK8C6393EF128ABF04 (accountgroup), 
        add constraint FK8C6393EF128ABF04 
        foreign key (accountgroup) 
        references identityiq.spt_account_group (id);

    alter table identityiq.spt_activity_constraint 
        add index FKD7E392852E02D59E (violation_owner_rule), 
        add constraint FKD7E392852E02D59E 
        foreign key (violation_owner_rule) 
        references identityiq.spt_rule (id);

    alter table identityiq.spt_activity_constraint 
        add index FKD7E3928557FD28A4 (policy), 
        add constraint FKD7E3928557FD28A4 
        foreign key (policy) 
        references identityiq.spt_policy (id);

    alter table identityiq.spt_activity_constraint 
        add index FKD7E39285486634B7 (assigned_scope), 
        add constraint FKD7E39285486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_activity_constraint 
        add index FKD7E39285A5FB1B1 (owner), 
        add constraint FKD7E39285A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_activity_constraint 
        add index FKD7E3928516E8C617 (violation_owner), 
        add constraint FKD7E3928516E8C617 
        foreign key (violation_owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_activity_data_source 
        add index FK34D17AA839D71460 (application), 
        add constraint FK34D17AA839D71460 
        foreign key (application) 
        references identityiq.spt_application (id);

    alter table identityiq.spt_activity_data_source 
        add index FK34D17AA8B854BFAE (transformation_rule), 
        add constraint FK34D17AA8B854BFAE 
        foreign key (transformation_rule) 
        references identityiq.spt_rule (id);

    alter table identityiq.spt_activity_data_source 
        add index FK34D17AA8BE1EE0D5 (correlation_rule), 
        add constraint FK34D17AA8BE1EE0D5 
        foreign key (correlation_rule) 
        references identityiq.spt_rule (id);

    alter table identityiq.spt_activity_data_source 
        add index FK34D17AA8486634B7 (assigned_scope), 
        add constraint FK34D17AA8486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_activity_data_source 
        add index FK34D17AA8A5FB1B1 (owner), 
        add constraint FK34D17AA8A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_activity_time_periods 
        add index FK7ABC1208E6D76F5D (application_activity), 
        add constraint FK7ABC1208E6D76F5D 
        foreign key (application_activity) 
        references identityiq.spt_application_activity (id);

    alter table identityiq.spt_activity_time_periods 
        add index FK7ABC1208E6ED34A1 (time_period), 
        add constraint FK7ABC1208E6ED34A1 
        foreign key (time_period) 
        references identityiq.spt_time_period (id);

    create index spt_alert_name on identityiq.spt_alert (name);

    create index spt_alert_last_processed on identityiq.spt_alert (last_processed);

    create index spt_alert_extended1_ci on identityiq.spt_alert (extended1);

    alter table identityiq.spt_alert 
        add index FKAD3A44D4A7C3772B (source), 
        add constraint FKAD3A44D4A7C3772B 
        foreign key (source) 
        references identityiq.spt_application (id);

    alter table identityiq.spt_alert_action 
        add index FK89E001BF1C6C78 (alert), 
        add constraint FK89E001BF1C6C78 
        foreign key (alert) 
        references identityiq.spt_alert (id);

    alter table identityiq.spt_alert_definition 
        add index FK3DF7B99E486634B7 (assigned_scope), 
        add constraint FK3DF7B99E486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_alert_definition 
        add index FK3DF7B99EA5FB1B1 (owner), 
        add constraint FK3DF7B99EA5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_app_dependencies 
        add index FK4354140F39D71460 (application), 
        add constraint FK4354140F39D71460 
        foreign key (application) 
        references identityiq.spt_application (id);

    alter table identityiq.spt_app_dependencies 
        add index FK4354140FDBA1E25B (dependency), 
        add constraint FK4354140FDBA1E25B 
        foreign key (dependency) 
        references identityiq.spt_application (id);

    alter table identityiq.spt_app_secondary_owners 
        add index FK1228593139D71460 (application), 
        add constraint FK1228593139D71460 
        foreign key (application) 
        references identityiq.spt_application (id);

    alter table identityiq.spt_app_secondary_owners 
        add index FK1228593140D47AB (elt), 
        add constraint FK1228593140D47AB 
        foreign key (elt) 
        references identityiq.spt_identity (id);

    create index spt_application_authoritative on identityiq.spt_application (authoritative);

    create index spt_app_proxied_name on identityiq.spt_application (proxied_name);

    create index spt_application_provisioning on identityiq.spt_application (supports_provisioning);

    create index spt_app_sync_provisioning on identityiq.spt_application (sync_provisioning);

    create index spt_application_cluster on identityiq.spt_application (app_cluster);

    create index spt_application_addt_acct on identityiq.spt_application (supports_additional_accounts);

    create index spt_application_acct_only on identityiq.spt_application (supports_account_only);

    create index spt_app_extended1_ci on identityiq.spt_application (extended1(255));

    create index spt_application_no_agg on identityiq.spt_application (no_aggregation);

    create index spt_application_mgd_apps on identityiq.spt_application (manages_other_apps);

    create index spt_application_logical on identityiq.spt_application (logical);

    create index spt_application_authenticate on identityiq.spt_application (supports_authenticate);

    alter table identityiq.spt_application 
        add index FK798846C84FE65998 (creation_rule), 
        add constraint FK798846C84FE65998 
        foreign key (creation_rule) 
        references identityiq.spt_rule (id);

    alter table identityiq.spt_application 
        add index FK798846C86FB29924 (customization_rule), 
        add constraint FK798846C86FB29924 
        foreign key (customization_rule) 
        references identityiq.spt_rule (id);

    alter table identityiq.spt_application 
        add index FK798846C83D65E622 (managed_attr_customize_rule), 
        add constraint FK798846C83D65E622 
        foreign key (managed_attr_customize_rule) 
        references identityiq.spt_rule (id);

    alter table identityiq.spt_application 
        add index FK798846C853AF4414 (scorecard), 
        add constraint FK798846C853AF4414 
        foreign key (scorecard) 
        references identityiq.spt_application_scorecard (id);

    alter table identityiq.spt_application 
        add index FK798846C88954E327 (manager_correlation_rule), 
        add constraint FK798846C88954E327 
        foreign key (manager_correlation_rule) 
        references identityiq.spt_rule (id);

    alter table identityiq.spt_application 
        add index FK798846C82F001D5 (target_source), 
        add constraint FK798846C82F001D5 
        foreign key (target_source) 
        references identityiq.spt_target_source (id);

    alter table identityiq.spt_application 
        add index FK798846C8E392D97E (proxy), 
        add constraint FK798846C8E392D97E 
        foreign key (proxy) 
        references identityiq.spt_application (id);

    alter table identityiq.spt_application 
        add index FK798846C8BE1EE0D5 (correlation_rule), 
        add constraint FK798846C8BE1EE0D5 
        foreign key (correlation_rule) 
        references identityiq.spt_rule (id);

    alter table identityiq.spt_application 
        add index FK798846C8486634B7 (assigned_scope), 
        add constraint FK798846C8486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_application 
        add index FK798846C8198B5515 (account_correlation_config), 
        add constraint FK798846C8198B5515 
        foreign key (account_correlation_config) 
        references identityiq.spt_correlation_config (id);

    alter table identityiq.spt_application 
        add index FK798846C8A5FB1B1 (owner), 
        add constraint FK798846C8A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_application_activity 
        add index FK5077FEA6486634B7 (assigned_scope), 
        add constraint FK5077FEA6486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_application_remediators 
        add index FKA10D3C1639D71460 (application), 
        add constraint FKA10D3C1639D71460 
        foreign key (application) 
        references identityiq.spt_application (id);

    alter table identityiq.spt_application_remediators 
        add index FKA10D3C1640D47AB (elt), 
        add constraint FKA10D3C1640D47AB 
        foreign key (elt) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_application_schema 
        add index FK62F93AF839D71460 (application), 
        add constraint FK62F93AF839D71460 
        foreign key (application) 
        references identityiq.spt_application (id);

    alter table identityiq.spt_application_schema 
        add index FK62F93AF84FE65998 (creation_rule), 
        add constraint FK62F93AF84FE65998 
        foreign key (creation_rule) 
        references identityiq.spt_rule (id);

    alter table identityiq.spt_application_schema 
        add index FK62F93AF86FB29924 (customization_rule), 
        add constraint FK62F93AF86FB29924 
        foreign key (customization_rule) 
        references identityiq.spt_rule (id);

    alter table identityiq.spt_application_schema 
        add index FK62F93AF8BE1EE0D5 (correlation_rule), 
        add constraint FK62F93AF8BE1EE0D5 
        foreign key (correlation_rule) 
        references identityiq.spt_rule (id);

    alter table identityiq.spt_application_schema 
        add index FK62F93AF8486634B7 (assigned_scope), 
        add constraint FK62F93AF8486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_application_schema 
        add index FK62F93AF8A5FB1B1 (owner), 
        add constraint FK62F93AF8A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    create index app_scorecard_cscore on identityiq.spt_application_scorecard (composite_score);

    alter table identityiq.spt_application_scorecard 
        add index FK314187EB907AB97A (application_id), 
        add constraint FK314187EB907AB97A 
        foreign key (application_id) 
        references identityiq.spt_application (id);

    alter table identityiq.spt_application_scorecard 
        add index FK314187EB486634B7 (assigned_scope), 
        add constraint FK314187EB486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_application_scorecard 
        add index FK314187EBA5FB1B1 (owner), 
        add constraint FK314187EBA5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_arch_cert_item_apps 
        add index FKFBD89444D6D1B4E0 (arch_cert_item_id), 
        add constraint FKFBD89444D6D1B4E0 
        foreign key (arch_cert_item_id) 
        references identityiq.spt_archived_cert_item (id);

    create index spt_arch_entity_tgt_display on identityiq.spt_archived_cert_entity (target_display_name);

    create index spt_arch_entity_identity_csi on identityiq.spt_archived_cert_entity (identity_name(255));

    create index spt_arch_entity_tgt_name_csi on identityiq.spt_archived_cert_entity (target_name);

    create index spt_arch_entity_target_id on identityiq.spt_archived_cert_entity (target_id);

    create index spt_arch_entity_acct_grp_csi on identityiq.spt_archived_cert_entity (account_group(255));

    create index spt_arch_entity_app on identityiq.spt_archived_cert_entity (application);

    create index spt_arch_entity_ref_attr on identityiq.spt_archived_cert_entity (reference_attribute);

    create index spt_arch_entity_native_id on identityiq.spt_archived_cert_entity (native_identity(255));

    alter table identityiq.spt_archived_cert_entity 
        add index FKE3ED1F09DB59193A (certification_id), 
        add constraint FKE3ED1F09DB59193A 
        foreign key (certification_id) 
        references identityiq.spt_certification (id);

    alter table identityiq.spt_archived_cert_entity 
        add index FKE3ED1F09486634B7 (assigned_scope), 
        add constraint FKE3ED1F09486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_archived_cert_entity 
        add index FKE3ED1F09A5FB1B1 (owner), 
        add constraint FKE3ED1F09A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    create index spt_arch_cert_item_tdisplay on identityiq.spt_archived_cert_item (target_display_name);

    create index spt_arch_cert_item_tname on identityiq.spt_archived_cert_item (target_name);

    create index spt_arch_item_app on identityiq.spt_archived_cert_item (exception_application);

    create index spt_arch_item_policy on identityiq.spt_archived_cert_item (policy(255));

    create index spt_arch_cert_item_type on identityiq.spt_archived_cert_item (type);

    create index spt_arch_item_native_id on identityiq.spt_archived_cert_item (exception_native_identity(255));

    create index spt_arch_item_bundle on identityiq.spt_archived_cert_item (bundle);

    alter table identityiq.spt_archived_cert_item 
        add index FK764147B9486634B7 (assigned_scope), 
        add constraint FK764147B9486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_archived_cert_item 
        add index FK764147B9BAC8DC8B (parent_id), 
        add constraint FK764147B9BAC8DC8B 
        foreign key (parent_id) 
        references identityiq.spt_archived_cert_entity (id);

    alter table identityiq.spt_archived_cert_item 
        add index FK764147B9A5FB1B1 (owner), 
        add constraint FK764147B9A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_audit_config 
        add index FK15F2D5AE486634B7 (assigned_scope), 
        add constraint FK15F2D5AE486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_audit_config 
        add index FK15F2D5AEA5FB1B1 (owner), 
        add constraint FK15F2D5AEA5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    create index spt_audit_action_ci on identityiq.spt_audit_event (action);

    create index spt_audit_trackingid_ci on identityiq.spt_audit_event (tracking_id);

    create index spt_audit_accountname_ci on identityiq.spt_audit_event (account_name(255));

    create index spt_audit_attr_ci on identityiq.spt_audit_event (attribute_name);

    create index spt_audit_attrVal_ci on identityiq.spt_audit_event (attribute_value(255));

    create index spt_audit_target_ci on identityiq.spt_audit_event (target);

    create index spt_audit_source_ci on identityiq.spt_audit_event (source);

    create index spt_audit_application_ci on identityiq.spt_audit_event (application);

    create index spt_audit_instance_ci on identityiq.spt_audit_event (instance);

    create index spt_audit_interface_ci on identityiq.spt_audit_event (interface);

    alter table identityiq.spt_audit_event 
        add index FK536922AE486634B7 (assigned_scope), 
        add constraint FK536922AE486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_audit_event 
        add index FK536922AEA5FB1B1 (owner), 
        add constraint FK536922AEA5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_authentication_answer 
        add index FK157EEDD56651F3A (identity_id), 
        add constraint FK157EEDD56651F3A 
        foreign key (identity_id) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_authentication_answer 
        add index FK157EEDD48ADCCD2 (question_id), 
        add constraint FK157EEDD48ADCCD2 
        foreign key (question_id) 
        references identityiq.spt_authentication_question (id);

    alter table identityiq.spt_authentication_answer 
        add index FK157EEDDA5FB1B1 (owner), 
        add constraint FK157EEDDA5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_authentication_question 
        add index FKE3609F45486634B7 (assigned_scope), 
        add constraint FKE3609F45486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_authentication_question 
        add index FKE3609F45A5FB1B1 (owner), 
        add constraint FKE3609F45A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_batch_request 
        add index FKA7055A02486634B7 (assigned_scope), 
        add constraint FKA7055A02486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_batch_request 
        add index FKA7055A02A5FB1B1 (owner), 
        add constraint FKA7055A02A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_batch_request_item 
        add index FK9118CB302C200325 (batch_request_id), 
        add constraint FK9118CB302C200325 
        foreign key (batch_request_id) 
        references identityiq.spt_batch_request (id);

    alter table identityiq.spt_batch_request_item 
        add index FK9118CB30486634B7 (assigned_scope), 
        add constraint FK9118CB30486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_batch_request_item 
        add index FK9118CB30A5FB1B1 (owner), 
        add constraint FK9118CB30A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    create index spt_bundle_type on identityiq.spt_bundle (type);

    create index spt_bundle_dispname_ci on identityiq.spt_bundle (displayable_name);

    create index spt_bundle_extended1_ci on identityiq.spt_bundle (extended1(255));

    create index spt_bundle_disabled on identityiq.spt_bundle (disabled);

    alter table identityiq.spt_bundle 
        add index FKFC45E40ABF46222D (join_rule), 
        add constraint FKFC45E40ABF46222D 
        foreign key (join_rule) 
        references identityiq.spt_rule (id);

    alter table identityiq.spt_bundle 
        add index FKFC45E40ABD5A5736 (pending_workflow), 
        add constraint FKFC45E40ABD5A5736 
        foreign key (pending_workflow) 
        references identityiq.spt_workflow_case (id);

    alter table identityiq.spt_bundle 
        add index FKFC45E40ACC129F2E (scorecard), 
        add constraint FKFC45E40ACC129F2E 
        foreign key (scorecard) 
        references identityiq.spt_role_scorecard (id);

    alter table identityiq.spt_bundle 
        add index FKFC45E40AF7616785 (role_index), 
        add constraint FKFC45E40AF7616785 
        foreign key (role_index) 
        references identityiq.spt_role_index (id);

    alter table identityiq.spt_bundle 
        add index FKFC45E40A486634B7 (assigned_scope), 
        add constraint FKFC45E40A486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_bundle 
        add index FKFC45E40AA5FB1B1 (owner), 
        add constraint FKFC45E40AA5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    create index spt_bundle_archive_source on identityiq.spt_bundle_archive (source_id);

    alter table identityiq.spt_bundle_archive 
        add index FK4C6C18D486634B7 (assigned_scope), 
        add constraint FK4C6C18D486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_bundle_archive 
        add index FK4C6C18DA5FB1B1 (owner), 
        add constraint FK4C6C18DA5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_bundle_children 
        add index FK5D48969480A503DE (child), 
        add constraint FK5D48969480A503DE 
        foreign key (child) 
        references identityiq.spt_bundle (id);

    alter table identityiq.spt_bundle_children 
        add index FK5D48969428E03F44 (bundle), 
        add constraint FK5D48969428E03F44 
        foreign key (bundle) 
        references identityiq.spt_bundle (id);

    alter table identityiq.spt_bundle_permits 
        add index FK8EAE08380A503DE (child), 
        add constraint FK8EAE08380A503DE 
        foreign key (child) 
        references identityiq.spt_bundle (id);

    alter table identityiq.spt_bundle_permits 
        add index FK8EAE08328E03F44 (bundle), 
        add constraint FK8EAE08328E03F44 
        foreign key (bundle) 
        references identityiq.spt_bundle (id);

    alter table identityiq.spt_bundle_requirements 
        add index FK582892A580A503DE (child), 
        add constraint FK582892A580A503DE 
        foreign key (child) 
        references identityiq.spt_bundle (id);

    alter table identityiq.spt_bundle_requirements 
        add index FK582892A528E03F44 (bundle), 
        add constraint FK582892A528E03F44 
        foreign key (bundle) 
        references identityiq.spt_bundle (id);

    alter table identityiq.spt_capability 
        add index FK5E9BD4A0486634B7 (assigned_scope), 
        add constraint FK5E9BD4A0486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_capability 
        add index FK5E9BD4A0A5FB1B1 (owner), 
        add constraint FK5E9BD4A0A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_capability_children 
        add index FKC7A8EEBEA526F8FA (capability_id), 
        add constraint FKC7A8EEBEA526F8FA 
        foreign key (capability_id) 
        references identityiq.spt_capability (id);

    alter table identityiq.spt_capability_children 
        add index FKC7A8EEBEC4BCFA76 (child_id), 
        add constraint FKC7A8EEBEC4BCFA76 
        foreign key (child_id) 
        references identityiq.spt_capability (id);

    alter table identityiq.spt_capability_rights 
        add index FKDCDA3656A526F8FA (capability_id), 
        add constraint FKDCDA3656A526F8FA 
        foreign key (capability_id) 
        references identityiq.spt_capability (id);

    alter table identityiq.spt_capability_rights 
        add index FKDCDA3656D22635BD (right_id), 
        add constraint FKDCDA3656D22635BD 
        foreign key (right_id) 
        references identityiq.spt_right (id);

    alter table identityiq.spt_category 
        add index FK528AAE86486634B7 (assigned_scope), 
        add constraint FK528AAE86486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_category 
        add index FK528AAE86A5FB1B1 (owner), 
        add constraint FK528AAE86A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_cert_action_assoc 
        add index FK9F3F8E7F84D52C6E (child_id), 
        add constraint FK9F3F8E7F84D52C6E 
        foreign key (child_id) 
        references identityiq.spt_certification_action (id);

    alter table identityiq.spt_cert_action_assoc 
        add index FK9F3F8E7F9D51C620 (parent_id), 
        add constraint FK9F3F8E7F9D51C620 
        foreign key (parent_id) 
        references identityiq.spt_certification_action (id);

    alter table identityiq.spt_cert_item_applications 
        add index FK4F97C0FCBCA86BEF (certification_item_id), 
        add constraint FK4F97C0FCBCA86BEF 
        foreign key (certification_item_id) 
        references identityiq.spt_certification_item (id);

    create index spt_cert_nxt_phs_tran on identityiq.spt_certification (next_phase_transition);

    create index spt_cert_application on identityiq.spt_certification (application_id);

    create index spt_cert_electronic_signed on identityiq.spt_certification (electronically_signed);

    create index nxt_overdue_scan on identityiq.spt_certification (next_overdue_scan);

    create index spt_certification_phase on identityiq.spt_certification (phase);

    create index spt_cert_type on identityiq.spt_certification (type);

    create index spt_certification_finished on identityiq.spt_certification (finished);

    create index spt_cert_task_sched_id on identityiq.spt_certification (task_schedule_id);

    create index spt_cert_exclude_inactive on identityiq.spt_certification (exclude_inactive);

    create index spt_cert_auto_close_date on identityiq.spt_certification (automatic_closing_date);

    create index spt_cert_group_id on identityiq.spt_certification (group_definition_id);

    create index spt_cert_trigger_id on identityiq.spt_certification (trigger_id);

    create index spt_cert_percent_complete on identityiq.spt_certification (percent_complete);

    create index nxt_cert_req_scan on identityiq.spt_certification (next_cert_required_scan);

    create index spt_certification_name on identityiq.spt_certification (name(255));

    create index spt_cert_group_name on identityiq.spt_certification (group_definition_name);

    create index spt_certification_short_name on identityiq.spt_certification (short_name);

    create index spt_certification_signed on identityiq.spt_certification (signed);

    create index spt_cert_cert_def_id on identityiq.spt_certification (certification_definition_id);

    create index spt_cert_manager on identityiq.spt_certification (manager);

    create index spt_cert_nextRemediationScan on identityiq.spt_certification (next_remediation_scan);

    alter table identityiq.spt_certification 
        add index FK4E6F1832486634B7 (assigned_scope), 
        add constraint FK4E6F1832486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_certification 
        add index FK4E6F1832A5FB1B1 (owner), 
        add constraint FK4E6F1832A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_certification 
        add index FK4E6F18323733F724 (parent), 
        add constraint FK4E6F18323733F724 
        foreign key (parent) 
        references identityiq.spt_certification (id);

    create index spt_item_ready_for_remed on identityiq.spt_certification_action (ready_for_remediation);

    alter table identityiq.spt_certification_action 
        add index FK198026E3486634B7 (assigned_scope), 
        add constraint FK198026E3486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_certification_action 
        add index FK198026E310F4E42A (source_action), 
        add constraint FK198026E310F4E42A 
        foreign key (source_action) 
        references identityiq.spt_certification_action (id);

    alter table identityiq.spt_certification_action 
        add index FK198026E3A5FB1B1 (owner), 
        add constraint FK198026E3A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    create index spt_cert_archive_grp_id on identityiq.spt_certification_archive (certification_group_id);

    create index spt_cert_archive_creator on identityiq.spt_certification_archive (creator);

    create index spt_cert_archive_id on identityiq.spt_certification_archive (certification_id);

    alter table identityiq.spt_certification_archive 
        add index FK2F2D4DB5486634B7 (assigned_scope), 
        add constraint FK2F2D4DB5486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_certification_archive 
        add index FK2F2D4DB5A5FB1B1 (owner), 
        add constraint FK2F2D4DB5A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_certification_challenge 
        add index FKCFF77896486634B7 (assigned_scope), 
        add constraint FKCFF77896486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_certification_challenge 
        add index FKCFF77896A5FB1B1 (owner), 
        add constraint FKCFF77896A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_certification_def_tags 
        add index FK43135580E6181207 (elt), 
        add constraint FK43135580E6181207 
        foreign key (elt) 
        references identityiq.spt_tag (id);

    alter table identityiq.spt_certification_def_tags 
        add index FK4313558015CFE57D (cert_def_id), 
        add constraint FK4313558015CFE57D 
        foreign key (cert_def_id) 
        references identityiq.spt_certification_definition (id);

    alter table identityiq.spt_certification_definition 
        add index FKD2CBBF80486634B7 (assigned_scope), 
        add constraint FKD2CBBF80486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_certification_definition 
        add index FKD2CBBF80A5FB1B1 (owner), 
        add constraint FKD2CBBF80A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_certification_delegation 
        add index FK62173755486634B7 (assigned_scope), 
        add constraint FK62173755486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_certification_delegation 
        add index FK62173755A5FB1B1 (owner), 
        add constraint FK62173755A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    create index spt_certification_entity_state on identityiq.spt_certification_entity (continuous_state);

    create index spt_certification_entity_ld on identityiq.spt_certification_entity (last_decision);

    create index spt_certification_entity_tn on identityiq.spt_certification_entity (target_name);

    create index spt_certification_entity_stat on identityiq.spt_certification_entity (summary_status);

    create index spt_certification_entity_diffs on identityiq.spt_certification_entity (has_differences);

    create index spt_certification_entity_nsc on identityiq.spt_certification_entity (next_continuous_state_change);

    create index spt_certification_entity_due on identityiq.spt_certification_entity (overdue_date);

    create index spt_cert_entity_lastname_ci on identityiq.spt_certification_entity (lastname);

    create index spt_cert_entity_cscore on identityiq.spt_certification_entity (composite_score);

    create index spt_cert_entity_new_user on identityiq.spt_certification_entity (new_user);

    create index spt_cert_entity_firstname_ci on identityiq.spt_certification_entity (firstname);

    create index spt_cert_entity_identity on identityiq.spt_certification_entity (identity_id(255));

    alter table identityiq.spt_certification_entity 
        add index FK641BE42D982FD46A20ee8c90 (delegation), 
        add constraint FK641BE42D982FD46A20ee8c90 
        foreign key (delegation) 
        references identityiq.spt_certification_delegation (id);

    alter table identityiq.spt_certification_entity 
        add index FK20EE8C90DB59193A (certification_id), 
        add constraint FK20EE8C90DB59193A 
        foreign key (certification_id) 
        references identityiq.spt_certification (id);

    alter table identityiq.spt_certification_entity 
        add index FK641BE42D486634B720ee8c90 (assigned_scope), 
        add constraint FK641BE42D486634B720ee8c90 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_certification_entity 
        add index FK641BE42DA5FB1B120ee8c90 (owner), 
        add constraint FK641BE42DA5FB1B120ee8c90 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_certification_entity 
        add index FK641BE42DCD1A938620ee8c90 (action), 
        add constraint FK641BE42DCD1A938620ee8c90 
        foreign key (action) 
        references identityiq.spt_certification_action (id);

    create index spt_cert_grp_perc_comp on identityiq.spt_certification_group (percent_complete);

    create index spt_cert_group_status on identityiq.spt_certification_group (status);

    create index spt_cert_group_type on identityiq.spt_certification_group (type);

    alter table identityiq.spt_certification_group 
        add index FK11B2043263178D65 (certification_definition), 
        add constraint FK11B2043263178D65 
        foreign key (certification_definition) 
        references identityiq.spt_certification_definition (id);

    alter table identityiq.spt_certification_group 
        add index FK11B20432486634B7 (assigned_scope), 
        add constraint FK11B20432486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_certification_group 
        add index FK11B20432A5FB1B1 (owner), 
        add constraint FK11B20432A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_certification_groups 
        add index FK248E8281F6578B00 (group_id), 
        add constraint FK248E8281F6578B00 
        foreign key (group_id) 
        references identityiq.spt_certification_group (id);

    alter table identityiq.spt_certification_groups 
        add index FK248E8281DB59193A (certification_id), 
        add constraint FK248E8281DB59193A 
        foreign key (certification_id) 
        references identityiq.spt_certification (id);

    create index spt_certification_item_state on identityiq.spt_certification_item (continuous_state);

    create index spt_certification_item_ld on identityiq.spt_certification_item (last_decision);

    create index spt_certification_item_tn on identityiq.spt_certification_item (target_name);

    create index spt_certification_item_stat on identityiq.spt_certification_item (summary_status);

    create index spt_certification_item_diffs on identityiq.spt_certification_item (has_differences);

    create index spt_certification_item_nsc on identityiq.spt_certification_item (next_continuous_state_change);

    create index spt_certification_item_due on identityiq.spt_certification_item (overdue_date);

    create index spt_cert_item_nxt_phs_tran on identityiq.spt_certification_item (next_phase_transition);

    create index spt_cert_item_type on identityiq.spt_certification_item (type);

    create index spt_cert_item_phase on identityiq.spt_certification_item (phase);

    create index spt_cert_item_perm_target on identityiq.spt_certification_item (exception_permission_target);

    create index spt_cert_item_exception_app on identityiq.spt_certification_item (exception_application);

    create index spt_certitem_extended1_ci on identityiq.spt_certification_item (extended1(255));

    create index spt_cert_item_perm_right on identityiq.spt_certification_item (exception_permission_right);

    create index spt_cert_item_att_name on identityiq.spt_certification_item (exception_attribute_name);

    create index spt_needs_refresh on identityiq.spt_certification_item (needs_refresh);

    create index spt_cert_item_bundle on identityiq.spt_certification_item (bundle);

    alter table identityiq.spt_certification_item 
        add index FKADFE6B008C97EA7 (exception_entitlements), 
        add constraint FKADFE6B008C97EA7 
        foreign key (exception_entitlements) 
        references identityiq.spt_entitlement_snapshot (id);

    alter table identityiq.spt_certification_item 
        add index FKADFE6B00809C88AF (certification_entity_id), 
        add constraint FKADFE6B00809C88AF 
        foreign key (certification_entity_id) 
        references identityiq.spt_certification_entity (id);

    alter table identityiq.spt_certification_item 
        add index FK641BE42D982FD46Aadfe6b00 (delegation), 
        add constraint FK641BE42D982FD46Aadfe6b00 
        foreign key (delegation) 
        references identityiq.spt_certification_delegation (id);

    alter table identityiq.spt_certification_item 
        add index FK641BE42D486634B7adfe6b00 (assigned_scope), 
        add constraint FK641BE42D486634B7adfe6b00 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_certification_item 
        add index FKADFE6B00B749D36C (challenge), 
        add constraint FKADFE6B00B749D36C 
        foreign key (challenge) 
        references identityiq.spt_certification_challenge (id);

    alter table identityiq.spt_certification_item 
        add index FK641BE42DA5FB1B1adfe6b00 (owner), 
        add constraint FK641BE42DA5FB1B1adfe6b00 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_certification_item 
        add index FK641BE42DCD1A9386adfe6b00 (action), 
        add constraint FK641BE42DCD1A9386adfe6b00 
        foreign key (action) 
        references identityiq.spt_certification_action (id);

    alter table identityiq.spt_certification_tags 
        add index FKAE032406E6181207 (elt), 
        add constraint FKAE032406E6181207 
        foreign key (elt) 
        references identityiq.spt_tag (id);

    alter table identityiq.spt_certification_tags 
        add index FKAE032406DB59193A (certification_id), 
        add constraint FKAE032406DB59193A 
        foreign key (certification_id) 
        references identityiq.spt_certification (id);

    alter table identityiq.spt_certifiers 
        add index FK784C89A6DB59193A (certification_id), 
        add constraint FK784C89A6DB59193A 
        foreign key (certification_id) 
        references identityiq.spt_certification (id);

    alter table identityiq.spt_child_certification_ids 
        add index FK2D614AC817639745 (certification_archive_id), 
        add constraint FK2D614AC817639745 
        foreign key (certification_archive_id) 
        references identityiq.spt_certification_archive (id);

    alter table identityiq.spt_configuration 
        add index FKE80D386E486634B7 (assigned_scope), 
        add constraint FKE80D386E486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_configuration 
        add index FKE80D386EA5FB1B1 (owner), 
        add constraint FKE80D386EA5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_correlation_config 
        add index FK3A3DBC27486634B7 (assigned_scope), 
        add constraint FK3A3DBC27486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_correlation_config 
        add index FK3A3DBC27A5FB1B1 (owner), 
        add constraint FK3A3DBC27A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    create index spt_custom_name_csi on identityiq.spt_custom (name);

    alter table identityiq.spt_custom 
        add index FKFDFD3EF9486634B7 (assigned_scope), 
        add constraint FKFDFD3EF9486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_custom 
        add index FKFDFD3EF9A5FB1B1 (owner), 
        add constraint FKFDFD3EF9A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    create index spt_dashboard_content_task on identityiq.spt_dashboard_content (source_task_id);

    create index spt_dashboard_type on identityiq.spt_dashboard_content (type);

    alter table identityiq.spt_dashboard_content 
        add index FKC4B33946486634B7 (assigned_scope), 
        add constraint FKC4B33946486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_dashboard_content 
        add index FKC4B33946A5FB1B1 (owner), 
        add constraint FKC4B33946A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_dashboard_content 
        add index FKC4B33946B513AA2F (parent), 
        add constraint FKC4B33946B513AA2F 
        foreign key (parent) 
        references identityiq.spt_dashboard_content (id);

    alter table identityiq.spt_dashboard_content_rights 
        add index FK106D6AF0D91E26B1 (dashboard_content_id), 
        add constraint FK106D6AF0D91E26B1 
        foreign key (dashboard_content_id) 
        references identityiq.spt_dashboard_content (id);

    alter table identityiq.spt_dashboard_content_rights 
        add index FK106D6AF0D22635BD (right_id), 
        add constraint FK106D6AF0D22635BD 
        foreign key (right_id) 
        references identityiq.spt_right (id);

    alter table identityiq.spt_dashboard_layout 
        add index FK9914A8BD486634B7 (assigned_scope), 
        add constraint FK9914A8BD486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_dashboard_layout 
        add index FK9914A8BDA5FB1B1 (owner), 
        add constraint FK9914A8BDA5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_dashboard_reference 
        add index FK45E944D82D6026 (content_id), 
        add constraint FK45E944D82D6026 
        foreign key (content_id) 
        references identityiq.spt_dashboard_content (id);

    alter table identityiq.spt_dashboard_reference 
        add index FK45E944D8486634B7 (assigned_scope), 
        add constraint FK45E944D8486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_dashboard_reference 
        add index FK45E944D8A5FB1B1 (owner), 
        add constraint FK45E944D8A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_dashboard_reference 
        add index FK45E944D8878775BD (identity_dashboard_id), 
        add constraint FK45E944D8878775BD 
        foreign key (identity_dashboard_id) 
        references identityiq.spt_identity_dashboard (id);

    create index spt_delObj_lastRefresh on identityiq.spt_deleted_object (last_refresh);

    create index spt_delObj_nativeIdentity_ci on identityiq.spt_deleted_object (native_identity(255));

    create index spt_delObj_objectType_ci on identityiq.spt_deleted_object (object_type);

    create index spt_delObj_name_ci on identityiq.spt_deleted_object (name);

    alter table identityiq.spt_deleted_object 
        add index FKA08C7DAD39D71460 (application), 
        add constraint FKA08C7DAD39D71460 
        foreign key (application) 
        references identityiq.spt_application (id);

    alter table identityiq.spt_deleted_object 
        add index FKA08C7DAD486634B7 (assigned_scope), 
        add constraint FKA08C7DAD486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_deleted_object 
        add index FKA08C7DADA5FB1B1 (owner), 
        add constraint FKA08C7DADA5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_dictionary 
        add index FKA7F7201E486634B7 (assigned_scope), 
        add constraint FKA7F7201E486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_dictionary 
        add index FKA7F7201EA5FB1B1 (owner), 
        add constraint FKA7F7201EA5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_dictionary_term 
        add index FK8E1F3FED8598603A (dictionary_id), 
        add constraint FK8E1F3FED8598603A 
        foreign key (dictionary_id) 
        references identityiq.spt_dictionary (id);

    alter table identityiq.spt_dictionary_term 
        add index FK8E1F3FED486634B7 (assigned_scope), 
        add constraint FK8E1F3FED486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_dictionary_term 
        add index FK8E1F3FEDA5FB1B1 (owner), 
        add constraint FK8E1F3FEDA5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_dynamic_scope 
        add index FKA73F59CC11B2F20 (role_request_control), 
        add constraint FKA73F59CC11B2F20 
        foreign key (role_request_control) 
        references identityiq.spt_rule (id);

    alter table identityiq.spt_dynamic_scope 
        add index FKA73F59CCE677873B (managed_attr_request_control), 
        add constraint FKA73F59CCE677873B 
        foreign key (managed_attr_request_control) 
        references identityiq.spt_rule (id);

    alter table identityiq.spt_dynamic_scope 
        add index FKA73F59CC486634B7 (assigned_scope), 
        add constraint FKA73F59CC486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_dynamic_scope 
        add index FKA73F59CC8A8BFFA (application_request_control), 
        add constraint FKA73F59CC8A8BFFA 
        foreign key (application_request_control) 
        references identityiq.spt_rule (id);

    alter table identityiq.spt_dynamic_scope 
        add index FKA73F59CCA5FB1B1 (owner), 
        add constraint FKA73F59CCA5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_dynamic_scope_exclusions 
        add index FKFCBD20B856651F3A (identity_id), 
        add constraint FKFCBD20B856651F3A 
        foreign key (identity_id) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_dynamic_scope_exclusions 
        add index FKFCBD20B86F1CB67B (dynamic_scope_id), 
        add constraint FKFCBD20B86F1CB67B 
        foreign key (dynamic_scope_id) 
        references identityiq.spt_dynamic_scope (id);

    alter table identityiq.spt_dynamic_scope_inclusions 
        add index FK3368F2A56651F3A (identity_id), 
        add constraint FK3368F2A56651F3A 
        foreign key (identity_id) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_dynamic_scope_inclusions 
        add index FK3368F2A6F1CB67B (dynamic_scope_id), 
        add constraint FK3368F2A6F1CB67B 
        foreign key (dynamic_scope_id) 
        references identityiq.spt_dynamic_scope (id);

    alter table identityiq.spt_email_template 
        add index FK9261AD45486634B7 (assigned_scope), 
        add constraint FK9261AD45486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_email_template 
        add index FK9261AD45A5FB1B1 (owner), 
        add constraint FK9261AD45A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_email_template_properties 
        add index emailtemplateproperties (id), 
        add constraint emailtemplateproperties 
        foreign key (id) 
        references identityiq.spt_email_template (id);

    alter table identityiq.spt_entitlement_group 
        add index FK13D2B86556651F3A (identity_id), 
        add constraint FK13D2B86556651F3A 
        foreign key (identity_id) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_entitlement_group 
        add index FK13D2B86539D71460 (application), 
        add constraint FK13D2B86539D71460 
        foreign key (application) 
        references identityiq.spt_application (id);

    alter table identityiq.spt_entitlement_group 
        add index FK13D2B865486634B7 (assigned_scope), 
        add constraint FK13D2B865486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_entitlement_group 
        add index FK13D2B865A5FB1B1 (owner), 
        add constraint FK13D2B865A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    create index spt_ent_snap_displayName_ci on identityiq.spt_entitlement_snapshot (display_name(255));

    create index spt_ent_snap_application_ci on identityiq.spt_entitlement_snapshot (application);

    create index spt_ent_snap_nativeIdentity_ci on identityiq.spt_entitlement_snapshot (native_identity(255));

    alter table identityiq.spt_entitlement_snapshot 
        add index FKC98E021EBCA86BEF (certification_item_id), 
        add constraint FKC98E021EBCA86BEF 
        foreign key (certification_item_id) 
        references identityiq.spt_certification_item (id);

    create index file_bucketNumber on identityiq.spt_file_bucket (file_index);

    alter table identityiq.spt_file_bucket 
        add index FK7A22AF85486634B7 (assigned_scope), 
        add constraint FK7A22AF85486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_file_bucket 
        add index FK7A22AF85A620641F (parent_id), 
        add constraint FK7A22AF85A620641F 
        foreign key (parent_id) 
        references identityiq.spt_persisted_file (id);

    alter table identityiq.spt_file_bucket 
        add index FK7A22AF85A5FB1B1 (owner), 
        add constraint FK7A22AF85A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_form 
        add index FK9A3E024C39D71460 (application), 
        add constraint FK9A3E024C39D71460 
        foreign key (application) 
        references identityiq.spt_application (id);

    alter table identityiq.spt_form 
        add index FK9A3E024C486634B7 (assigned_scope), 
        add constraint FK9A3E024C486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_form 
        add index FK9A3E024CA5FB1B1 (owner), 
        add constraint FK9A3E024CA5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_generic_constraint 
        add index FK1A3C4CCD2E02D59E (violation_owner_rule), 
        add constraint FK1A3C4CCD2E02D59E 
        foreign key (violation_owner_rule) 
        references identityiq.spt_rule (id);

    alter table identityiq.spt_generic_constraint 
        add index FK1A3C4CCD57FD28A4 (policy), 
        add constraint FK1A3C4CCD57FD28A4 
        foreign key (policy) 
        references identityiq.spt_policy (id);

    alter table identityiq.spt_generic_constraint 
        add index FK1A3C4CCD486634B7 (assigned_scope), 
        add constraint FK1A3C4CCD486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_generic_constraint 
        add index FK1A3C4CCDA5FB1B1 (owner), 
        add constraint FK1A3C4CCDA5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_generic_constraint 
        add index FK1A3C4CCD16E8C617 (violation_owner), 
        add constraint FK1A3C4CCD16E8C617 
        foreign key (violation_owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_group_definition 
        add index FK21F3C89BFA54B4D5 (factory), 
        add constraint FK21F3C89BFA54B4D5 
        foreign key (factory) 
        references identityiq.spt_group_factory (id);

    alter table identityiq.spt_group_definition 
        add index FK21F3C89B486634B7 (assigned_scope), 
        add constraint FK21F3C89B486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_group_definition 
        add index FK21F3C89B1CE09EE5 (group_index), 
        add constraint FK21F3C89B1CE09EE5 
        foreign key (group_index) 
        references identityiq.spt_group_index (id);

    alter table identityiq.spt_group_definition 
        add index FK21F3C89BA5FB1B1 (owner), 
        add constraint FK21F3C89BA5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_group_factory 
        add index FK36D2A2C252F9C404 (group_owner_rule), 
        add constraint FK36D2A2C252F9C404 
        foreign key (group_owner_rule) 
        references identityiq.spt_rule (id);

    alter table identityiq.spt_group_factory 
        add index FK36D2A2C2486634B7 (assigned_scope), 
        add constraint FK36D2A2C2486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_group_factory 
        add index FK36D2A2C2A5FB1B1 (owner), 
        add constraint FK36D2A2C2A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    create index group_index_cscore on identityiq.spt_group_index (composite_score);

    alter table identityiq.spt_group_index 
        add index FK5E03A88AF7729445 (definition), 
        add constraint FK5E03A88AF7729445 
        foreign key (definition) 
        references identityiq.spt_group_definition (id);

    alter table identityiq.spt_group_index 
        add index FK5E03A88A486634B7 (assigned_scope), 
        add constraint FK5E03A88A486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_group_index 
        add index FK5E03A88AA5FB1B1 (owner), 
        add constraint FK5E03A88AA5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_group_permissions 
        add index FKB27ACA3CC60D993F (entitlement_group_id), 
        add constraint FKB27ACA3CC60D993F 
        foreign key (entitlement_group_id) 
        references identityiq.spt_entitlement_group (id);

    create index spt_identity_correlated on identityiq.spt_identity (correlated);

    create index spt_identity_isworkgroup on identityiq.spt_identity (workgroup);

    create index spt_identity_needs_refresh on identityiq.spt_identity (needs_refresh);

    create index spt_identity_extended5_ci on identityiq.spt_identity (extended5(255));

    create index spt_identity_lastRefresh on identityiq.spt_identity (last_refresh);

    create index spt_identity_extended3_ci on identityiq.spt_identity (extended3(255));

    create index spt_identity_extended4_ci on identityiq.spt_identity (extended4(255));

    create index spt_identity_displayName_ci on identityiq.spt_identity (display_name);

    create index spt_identity_inactive on identityiq.spt_identity (inactive);

    create index spt_identity_firstname_ci on identityiq.spt_identity (firstname);

    create index spt_identity_extended1_ci on identityiq.spt_identity (extended1(255));

    create index spt_identity_email_ci on identityiq.spt_identity (email);

    create index spt_identity_manager_status on identityiq.spt_identity (manager_status);

    create index spt_identity_extended2_ci on identityiq.spt_identity (extended2(255));

    create index spt_identity_lastname_ci on identityiq.spt_identity (lastname);

    alter table identityiq.spt_identity 
        add index FK4770624622315AAB (extended_identity1), 
        add constraint FK4770624622315AAB 
        foreign key (extended_identity1) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_identity 
        add index FK4770624622315AAC (extended_identity2), 
        add constraint FK4770624622315AAC 
        foreign key (extended_identity2) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_identity 
        add index FK47706246761EBB04 (scorecard), 
        add constraint FK47706246761EBB04 
        foreign key (scorecard) 
        references identityiq.spt_scorecard (id);

    alter table identityiq.spt_identity 
        add index FK4770624622315AAD (extended_identity3), 
        add constraint FK4770624622315AAD 
        foreign key (extended_identity3) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_identity 
        add index FK4770624646DBED88 (uipreferences), 
        add constraint FK4770624646DBED88 
        foreign key (uipreferences) 
        references identityiq.spt_uipreferences (id);

    alter table identityiq.spt_identity 
        add index FK4770624635D4CEAB (manager), 
        add constraint FK4770624635D4CEAB 
        foreign key (manager) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_identity 
        add index FK4770624622315AAF (extended_identity5), 
        add constraint FK4770624622315AAF 
        foreign key (extended_identity5) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_identity 
        add index FK47706246486634B7 (assigned_scope), 
        add constraint FK47706246486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_identity 
        add index FK4770624622315AAE (extended_identity4), 
        add constraint FK4770624622315AAE 
        foreign key (extended_identity4) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_identity 
        add index FK47706246A5FB1B1 (owner), 
        add constraint FK47706246A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    create index spt_identity_archive_source on identityiq.spt_identity_archive (source_id);

    alter table identityiq.spt_identity_archive 
        add index FKF49D43C9486634B7 (assigned_scope), 
        add constraint FKF49D43C9486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_identity_archive 
        add index FKF49D43C9A5FB1B1 (owner), 
        add constraint FKF49D43C9A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_identity_assigned_roles 
        add index FK559F642556651F3A (identity_id), 
        add constraint FK559F642556651F3A 
        foreign key (identity_id) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_identity_assigned_roles 
        add index FK559F642528E03F44 (bundle), 
        add constraint FK559F642528E03F44 
        foreign key (bundle) 
        references identityiq.spt_bundle (id);

    alter table identityiq.spt_identity_bundles 
        add index FK2F3B433856651F3A (identity_id), 
        add constraint FK2F3B433856651F3A 
        foreign key (identity_id) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_identity_bundles 
        add index FK2F3B433828E03F44 (bundle), 
        add constraint FK2F3B433828E03F44 
        foreign key (bundle) 
        references identityiq.spt_bundle (id);

    alter table identityiq.spt_identity_capabilities 
        add index FK2258790F56651F3A (identity_id), 
        add constraint FK2258790F56651F3A 
        foreign key (identity_id) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_identity_capabilities 
        add index FK2258790FA526F8FA (capability_id), 
        add constraint FK2258790FA526F8FA 
        foreign key (capability_id) 
        references identityiq.spt_capability (id);

    alter table identityiq.spt_identity_controlled_scopes 
        add index FK926D30B756651F3A (identity_id), 
        add constraint FK926D30B756651F3A 
        foreign key (identity_id) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_identity_controlled_scopes 
        add index FK926D30B79D803AFA (scope_id), 
        add constraint FK926D30B79D803AFA 
        foreign key (scope_id) 
        references identityiq.spt_scope (id);

    create index spt_identity_dashboard_type on identityiq.spt_identity_dashboard (type);

    alter table identityiq.spt_identity_dashboard 
        add index FK6732A7DB56651F3A (identity_id), 
        add constraint FK6732A7DB56651F3A 
        foreign key (identity_id) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_identity_dashboard 
        add index FK6732A7DB68DCB7C8 (layout), 
        add constraint FK6732A7DB68DCB7C8 
        foreign key (layout) 
        references identityiq.spt_dashboard_layout (id);

    alter table identityiq.spt_identity_dashboard 
        add index FK6732A7DB486634B7 (assigned_scope), 
        add constraint FK6732A7DB486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_identity_dashboard 
        add index FK6732A7DBA5FB1B1 (owner), 
        add constraint FK6732A7DBA5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    create index spt_identity_ent_assgnid on identityiq.spt_identity_entitlement (assignment_id);

    create index spt_identity_ent_source_ci on identityiq.spt_identity_entitlement (source);

    create index spt_identity_ent_ag_state on identityiq.spt_identity_entitlement (aggregation_state);

    create index spt_identity_ent_role_granted on identityiq.spt_identity_entitlement (granted_by_role);

    create index spt_identity_ent_assigned on identityiq.spt_identity_entitlement (assigned);

    create index spt_identity_ent_allowed on identityiq.spt_identity_entitlement (allowed);

    create index spt_identity_ent_value_ci on identityiq.spt_identity_entitlement (value(255));

    create index spt_identity_ent_nativeid_ci on identityiq.spt_identity_entitlement (native_identity(255));

    create index spt_identity_ent_name_ci on identityiq.spt_identity_entitlement (name);

    create index spt_identity_ent_instance_ci on identityiq.spt_identity_entitlement (instance);

    create index spt_identity_ent_type on identityiq.spt_identity_entitlement (type);

    alter table identityiq.spt_identity_entitlement 
        add index FK1134F4B456651F3A (identity_id), 
        add constraint FK1134F4B456651F3A 
        foreign key (identity_id) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_identity_entitlement 
        add index FK1134F4B439D71460 (application), 
        add constraint FK1134F4B439D71460 
        foreign key (application) 
        references identityiq.spt_application (id);

    alter table identityiq.spt_identity_entitlement 
        add index FK1134F4B47AEC327 (request_item), 
        add constraint FK1134F4B47AEC327 
        foreign key (request_item) 
        references identityiq.spt_identity_request_item (id);

    alter table identityiq.spt_identity_entitlement 
        add index FK1134F4B4D9C563CD (pending_certification_item), 
        add constraint FK1134F4B4D9C563CD 
        foreign key (pending_certification_item) 
        references identityiq.spt_certification_item (id);

    alter table identityiq.spt_identity_entitlement 
        add index FK1134F4B484ACD425 (certification_item), 
        add constraint FK1134F4B484ACD425 
        foreign key (certification_item) 
        references identityiq.spt_certification_item (id);

    alter table identityiq.spt_identity_entitlement 
        add index FK1134F4B4FFB630CF (pending_request_item), 
        add constraint FK1134F4B4FFB630CF 
        foreign key (pending_request_item) 
        references identityiq.spt_identity_request_item (id);

    alter table identityiq.spt_identity_entitlement 
        add index FK1134F4B4A5FB1B1 (owner), 
        add constraint FK1134F4B4A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    create index spt_id_hist_item_instance on identityiq.spt_identity_history_item (instance);

    create index spt_id_hist_item_policy on identityiq.spt_identity_history_item (policy);

    create index spt_id_hist_item_ntv_id_ci on identityiq.spt_identity_history_item (native_identity(255));

    create index spt_id_hist_item_application on identityiq.spt_identity_history_item (application);

    create index spt_id_hist_item_role on identityiq.spt_identity_history_item (role);

    create index spt_id_hist_item_value_ci on identityiq.spt_identity_history_item (value(255));

    create index spt_id_hist_item_actor on identityiq.spt_identity_history_item (actor);

    create index spt_id_hist_item_account_ci on identityiq.spt_identity_history_item (account);

    create index spt_id_hist_item_entry_date on identityiq.spt_identity_history_item (entry_date);

    create index spt_id_hist_item_status on identityiq.spt_identity_history_item (status);

    create index spt_id_hist_item_attribute_ci on identityiq.spt_identity_history_item (attribute(255));

    create index spt_id_hist_item_cert_type on identityiq.spt_identity_history_item (certification_type);

    alter table identityiq.spt_identity_history_item 
        add index FK60B753756651F3A (identity_id), 
        add constraint FK60B753756651F3A 
        foreign key (identity_id) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_identity_history_item 
        add index FK60B7537A5FB1B1 (owner), 
        add constraint FK60B7537A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    create index spt_idrequest_target_id on identityiq.spt_identity_request (target_id);

    create index spt_idrequest_ext_ticket_ci on identityiq.spt_identity_request (external_ticket_id);

    create index spt_idrequest_name on identityiq.spt_identity_request (name);

    create index spt_idrequest_exec_status on identityiq.spt_identity_request (execution_status);

    create index spt_idrequest_compl_status on identityiq.spt_identity_request (completion_status);

    create index spt_idrequest_priority on identityiq.spt_identity_request (priority);

    create index spt_idrequest_endDate on identityiq.spt_identity_request (end_date);

    create index spt_idrequest_has_messages on identityiq.spt_identity_request (has_messages);

    create index spt_idrequest_target on identityiq.spt_identity_request (target_display_name);

    create index spt_idrequest_state on identityiq.spt_identity_request (state);

    create index spt_idrequest_type on identityiq.spt_identity_request (type);

    create index spt_idrequest_requestor on identityiq.spt_identity_request (requester_display_name);

    create index spt_idrequest_verified on identityiq.spt_identity_request (verified);

    create index spt_idrequest_requestor_id on identityiq.spt_identity_request (requester_id);

    alter table identityiq.spt_identity_request 
        add index FK62835596486634B7 (assigned_scope), 
        add constraint FK62835596486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_identity_request 
        add index FK62835596A5FB1B1 (owner), 
        add constraint FK62835596A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    create index spt_reqitem_comp_status on identityiq.spt_identity_request_item (compilation_status);

    create index spt_reqitem_instance_ci on identityiq.spt_identity_request_item (instance);

    create index spt_reqitem_nativeid_ci on identityiq.spt_identity_request_item (native_identity(255));

    create index spt_reqitem_ownername on identityiq.spt_identity_request_item (owner_name);

    create index spt_reqitem_value_ci on identityiq.spt_identity_request_item (value(255));

    create index spt_reqitem_name_ci on identityiq.spt_identity_request_item (name);

    create index spt_reqitem_exp_cause on identityiq.spt_identity_request_item (expansion_cause);

    create index spt_reqitem_approval_state on identityiq.spt_identity_request_item (approval_state);

    create index spt_reqitem_provisioning_state on identityiq.spt_identity_request_item (provisioning_state);

    create index spt_reqitem_approvername on identityiq.spt_identity_request_item (approver_name);

    alter table identityiq.spt_identity_request_item 
        add index FKC8ACEC1C7733749D (identity_request_id), 
        add constraint FKC8ACEC1C7733749D 
        foreign key (identity_request_id) 
        references identityiq.spt_identity_request (id);

    alter table identityiq.spt_identity_request_item 
        add index FKC8ACEC1CA5FB1B1 (owner), 
        add constraint FKC8ACEC1CA5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_identity_role_metadata 
        add index FK8DD1129F56651F3A (identity_id), 
        add constraint FK8DD1129F56651F3A 
        foreign key (identity_id) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_identity_role_metadata 
        add index FK8DD1129F539509E7 (role_metadata_id), 
        add constraint FK8DD1129F539509E7 
        foreign key (role_metadata_id) 
        references identityiq.spt_role_metadata (id);

    create index spt_idsnap_id_name on identityiq.spt_identity_snapshot (identity_name);

    create index spt_identity_id on identityiq.spt_identity_snapshot (identity_id);

    alter table identityiq.spt_identity_snapshot 
        add index FK1652D39D486634B7 (assigned_scope), 
        add constraint FK1652D39D486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_identity_snapshot 
        add index FK1652D39DA5FB1B1 (owner), 
        add constraint FK1652D39DA5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_identity_trigger 
        add index FKE207B8BF3908AE7A (rule_id), 
        add constraint FKE207B8BF3908AE7A 
        foreign key (rule_id) 
        references identityiq.spt_rule (id);

    alter table identityiq.spt_identity_trigger 
        add index FKE207B8BF486634B7 (assigned_scope), 
        add constraint FKE207B8BF486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_identity_trigger 
        add index FKE207B8BFA5FB1B1 (owner), 
        add constraint FKE207B8BFA5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_identity_workgroups 
        add index FKFBDE3BBE56651F3A (identity_id), 
        add constraint FKFBDE3BBE56651F3A 
        foreign key (identity_id) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_identity_workgroups 
        add index FKFBDE3BBE457BB10C (workgroup), 
        add constraint FKFBDE3BBE457BB10C 
        foreign key (workgroup) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_integration_config 
        add index FK12CC3B95907AB97A (application_id), 
        add constraint FK12CC3B95907AB97A 
        foreign key (application_id) 
        references identityiq.spt_application (id);

    alter table identityiq.spt_integration_config 
        add index FK12CC3B95AAEC2008 (plan_initializer), 
        add constraint FK12CC3B95AAEC2008 
        foreign key (plan_initializer) 
        references identityiq.spt_rule (id);

    alter table identityiq.spt_integration_config 
        add index FK12CC3B95FAA8585B (container_id), 
        add constraint FK12CC3B95FAA8585B 
        foreign key (container_id) 
        references identityiq.spt_bundle (id);

    alter table identityiq.spt_integration_config 
        add index FK12CC3B95486634B7 (assigned_scope), 
        add constraint FK12CC3B95486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_integration_config 
        add index FK12CC3B95A5FB1B1 (owner), 
        add constraint FK12CC3B95A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_jasper_files 
        add index FKE710B7C1AAD4575B (result), 
        add constraint FKE710B7C1AAD4575B 
        foreign key (result) 
        references identityiq.spt_jasper_result (id);

    alter table identityiq.spt_jasper_files 
        add index FKE710B7C12ABB3BFC (elt), 
        add constraint FKE710B7C12ABB3BFC 
        foreign key (elt) 
        references identityiq.spt_persisted_file (id);

    create index handlerId on identityiq.spt_jasper_page_bucket (handler_id);

    create index bucketNumber on identityiq.spt_jasper_page_bucket (bucket_number);

    alter table identityiq.spt_jasper_page_bucket 
        add index FKA6291364486634B7 (assigned_scope), 
        add constraint FKA6291364486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_jasper_page_bucket 
        add index FKA6291364A5FB1B1 (owner), 
        add constraint FKA6291364A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_jasper_result 
        add index FKF4B7413486634B7 (assigned_scope), 
        add constraint FKF4B7413486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_jasper_result 
        add index FKF4B7413A5FB1B1 (owner), 
        add constraint FKF4B7413A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_jasper_template 
        add index FK2F7D52F0486634B7 (assigned_scope), 
        add constraint FK2F7D52F0486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_jasper_template 
        add index FK2F7D52F0A5FB1B1 (owner), 
        add constraint FK2F7D52F0A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    create index spt_link_dispname_ci on identityiq.spt_link (display_name);

    create index spt_link_extended1_ci on identityiq.spt_link (extended1(255));

    create index spt_link_lastAggregation on identityiq.spt_link (last_target_aggregation);

    create index spt_link_nativeIdentity_ci on identityiq.spt_link (native_identity(255));

    create index spt_link_lastRefresh on identityiq.spt_link (last_refresh);

    create index spt_link_key1_ci on identityiq.spt_link (key1(255));

    create index spt_link_entitlements on identityiq.spt_link (entitlements);

    alter table identityiq.spt_link 
        add index FK9A40A58239D71460 (application), 
        add constraint FK9A40A58239D71460 
        foreign key (application) 
        references identityiq.spt_application (id);

    alter table identityiq.spt_link 
        add index FK9A40A58256651F3A (identity_id), 
        add constraint FK9A40A58256651F3A 
        foreign key (identity_id) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_link 
        add index FK9A40A582486634B7 (assigned_scope), 
        add constraint FK9A40A582486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_link 
        add index FK9A40A582A5FB1B1 (owner), 
        add constraint FK9A40A582A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    create index spt_localized_attr_targetname on identityiq.spt_localized_attribute (target_name);

    create index spt_localized_attr_attr on identityiq.spt_localized_attribute (attribute);

    create index spt_localized_attr_name on identityiq.spt_localized_attribute (name);

    create index spt_localized_attr_locale on identityiq.spt_localized_attribute (locale);

    create index spt_localized_attr_targetid on identityiq.spt_localized_attribute (target_id);

    alter table identityiq.spt_localized_attribute 
        add index FK93ADD450A5FB1B1 (owner), 
        add constraint FK93ADD450A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_managed_attr_inheritance 
        add index FK53B8B9A42C3CA9DA (managedattribute), 
        add constraint FK53B8B9A42C3CA9DA 
        foreign key (managedattribute) 
        references identityiq.spt_managed_attribute (id);

    alter table identityiq.spt_managed_attr_inheritance 
        add index FK53B8B9A4C7A4B4AE (inherits_from), 
        add constraint FK53B8B9A4C7A4B4AE 
        foreign key (inherits_from) 
        references identityiq.spt_managed_attribute (id);

    alter table identityiq.spt_managed_attr_perms 
        add index FKB7E473DD2C3CA9DA (managedattribute), 
        add constraint FKB7E473DD2C3CA9DA 
        foreign key (managedattribute) 
        references identityiq.spt_managed_attribute (id);

    alter table identityiq.spt_managed_attr_target_perms 
        add index FK7839CDBB2C3CA9DA (managedattribute), 
        add constraint FK7839CDBB2C3CA9DA 
        foreign key (managedattribute) 
        references identityiq.spt_managed_attribute (id);

    create index spt_managed_attr_aggregated on identityiq.spt_managed_attribute (aggregated);

    create index spt_managed_attr_purview on identityiq.spt_managed_attribute (purview);

    create index spt_managed_attr_type on identityiq.spt_managed_attribute (type);

    create index spt_managed_attr_requestable on identityiq.spt_managed_attribute (requestable);

    create index spt_managed_attr_extended1_ci on identityiq.spt_managed_attribute (extended1(255));

    create index spt_managed_attr_dispname_ci on identityiq.spt_managed_attribute (displayable_name(255));

    create index spt_managed_attr_extended2_ci on identityiq.spt_managed_attribute (extended2(255));

    create index spt_managed_attr_value_ci on identityiq.spt_managed_attribute (value(255));

    create index spt_ma_key2_ci on identityiq.spt_managed_attribute (key2);

    create index spt_ma_key1_ci on identityiq.spt_managed_attribute (key1);

    create index spt_ma_key3_ci on identityiq.spt_managed_attribute (key3);

    create index spt_managed_attr_extended3_ci on identityiq.spt_managed_attribute (extended3(255));

    create index spt_managed_attr_uuid_ci on identityiq.spt_managed_attribute (uuid);

    create index spt_managed_attr_last_tgt_agg on identityiq.spt_managed_attribute (last_target_aggregation);

    create index spt_ma_key4_ci on identityiq.spt_managed_attribute (key4);

    create index spt_managed_attr_attr_ci on identityiq.spt_managed_attribute (attribute(255));

    alter table identityiq.spt_managed_attribute 
        add index FKF5F1417439D71460 (application), 
        add constraint FKF5F1417439D71460 
        foreign key (application) 
        references identityiq.spt_application (id);

    alter table identityiq.spt_managed_attribute 
        add index FKF5F14174486634B7 (assigned_scope), 
        add constraint FKF5F14174486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_managed_attribute 
        add index FKF5F14174A5FB1B1 (owner), 
        add constraint FKF5F14174A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_message_template 
        add index FKD78FF3A486634B7 (assigned_scope), 
        add constraint FKD78FF3A486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_message_template 
        add index FKD78FF3AA5FB1B1 (owner), 
        add constraint FKD78FF3AA5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_mining_config 
        add index FK2894D189486634B7 (assigned_scope), 
        add constraint FK2894D189486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_mining_config 
        add index FK2894D189A5FB1B1 (owner), 
        add constraint FK2894D189A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    create index spt_mitigation_policy on identityiq.spt_mitigation_expiration (policy);

    create index spt_mitigation_account_ci on identityiq.spt_mitigation_expiration (native_identity(255));

    create index spt_mitigation_attr_val_ci on identityiq.spt_mitigation_expiration (attribute_value(255));

    create index spt_mitigation_role on identityiq.spt_mitigation_expiration (role_name);

    create index spt_mitigation_permission on identityiq.spt_mitigation_expiration (permission);

    create index spt_mitigation_attr_name_ci on identityiq.spt_mitigation_expiration (attribute_name(255));

    create index spt_mitigation_app on identityiq.spt_mitigation_expiration (application);

    create index spt_mitigation_instance on identityiq.spt_mitigation_expiration (instance);

    alter table identityiq.spt_mitigation_expiration 
        add index FK6C20072756651F3A (identity_id), 
        add constraint FK6C20072756651F3A 
        foreign key (identity_id) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_mitigation_expiration 
        add index FK6C200727486634B7 (assigned_scope), 
        add constraint FK6C200727486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_mitigation_expiration 
        add index FK6C200727A5FB1B1 (owner), 
        add constraint FK6C200727A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_mitigation_expiration 
        add index FK6C20072771E36ACA (mitigator), 
        add constraint FK6C20072771E36ACA 
        foreign key (mitigator) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_object_config 
        add index FK92854BBA486634B7 (assigned_scope), 
        add constraint FK92854BBA486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_object_config 
        add index FK92854BBAA5FB1B1 (owner), 
        add constraint FK92854BBAA5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    create index spt_partition_status on identityiq.spt_partition_result (completion_status);

    alter table identityiq.spt_partition_result 
        add index FK9541609A3EE0F059 (task_result), 
        add constraint FK9541609A3EE0F059 
        foreign key (task_result) 
        references identityiq.spt_task_result (id);

    alter table identityiq.spt_partition_result 
        add index FK9541609A486634B7 (assigned_scope), 
        add constraint FK9541609A486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_partition_result 
        add index FK9541609AA5FB1B1 (owner), 
        add constraint FK9541609AA5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_password_policy 
        add index FK479B98CEA5FB1B1 (owner), 
        add constraint FK479B98CEA5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_password_policy_holder 
        add index FKA7124E3D39D71460 (application), 
        add constraint FKA7124E3D39D71460 
        foreign key (application) 
        references identityiq.spt_application (id);

    alter table identityiq.spt_password_policy_holder 
        add index FKA7124E3D25FBEF1F (policy), 
        add constraint FKA7124E3D25FBEF1F 
        foreign key (policy) 
        references identityiq.spt_password_policy (id);

    alter table identityiq.spt_password_policy_holder 
        add index FKA7124E3DA5FB1B1 (owner), 
        add constraint FKA7124E3DA5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_persisted_file 
        add index FKCEBAA850486634B7 (assigned_scope), 
        add constraint FKCEBAA850486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_persisted_file 
        add index FKCEBAA850A5FB1B1 (owner), 
        add constraint FKCEBAA850A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    create index spt_plugin_dn_ci on identityiq.spt_plugin (display_name);

    create index spt_plugin_name_ci on identityiq.spt_plugin (name);

    alter table identityiq.spt_plugin 
        add index FK13AE22BBF7C36E0D (file_id), 
        add constraint FK13AE22BBF7C36E0D 
        foreign key (file_id) 
        references identityiq.spt_persisted_file (id);

    alter table identityiq.spt_policy 
        add index FK13D458BA2E02D59E (violation_owner_rule), 
        add constraint FK13D458BA2E02D59E 
        foreign key (violation_owner_rule) 
        references identityiq.spt_rule (id);

    alter table identityiq.spt_policy 
        add index FK13D458BA486634B7 (assigned_scope), 
        add constraint FK13D458BA486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_policy 
        add index FK13D458BAA5FB1B1 (owner), 
        add constraint FK13D458BAA5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_policy 
        add index FK13D458BA16E8C617 (violation_owner), 
        add constraint FK13D458BA16E8C617 
        foreign key (violation_owner) 
        references identityiq.spt_identity (id);

    create index spt_policy_violation_active on identityiq.spt_policy_violation (active);

    alter table identityiq.spt_policy_violation 
        add index FK6E4413E056651F3A (identity_id), 
        add constraint FK6E4413E056651F3A 
        foreign key (identity_id) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_policy_violation 
        add index FK6E4413E0BD5A5736 (pending_workflow), 
        add constraint FK6E4413E0BD5A5736 
        foreign key (pending_workflow) 
        references identityiq.spt_workflow_case (id);

    alter table identityiq.spt_policy_violation 
        add index FK6E4413E0486634B7 (assigned_scope), 
        add constraint FK6E4413E0486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_policy_violation 
        add index FK6E4413E0A5FB1B1 (owner), 
        add constraint FK6E4413E0A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_process 
        add index FK6BFCDBE7486634B7 (assigned_scope), 
        add constraint FK6BFCDBE7486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_process 
        add index FK6BFCDBE7A5FB1B1 (owner), 
        add constraint FK6BFCDBE7A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_process_application 
        add index FKD8579CF839D71460 (application), 
        add constraint FKD8579CF839D71460 
        foreign key (application) 
        references identityiq.spt_application (id);

    alter table identityiq.spt_process_application 
        add index FKD8579CF8B234269E (process), 
        add constraint FKD8579CF8B234269E 
        foreign key (process) 
        references identityiq.spt_process (id);

    alter table identityiq.spt_process_bundles 
        add index FK9F488BD97B02976F (elt), 
        add constraint FK9F488BD97B02976F 
        foreign key (elt) 
        references identityiq.spt_bundle (id);

    alter table identityiq.spt_process_bundles 
        add index FK9F488BD9B234269E (process), 
        add constraint FK9F488BD9B234269E 
        foreign key (process) 
        references identityiq.spt_process (id);

    create index spt_process_log_approval_name on identityiq.spt_process_log (approval_name);

    create index spt_process_log_process_name on identityiq.spt_process_log (process_name);

    create index spt_process_log_owner_name on identityiq.spt_process_log (owner_name);

    create index spt_process_log_step_name on identityiq.spt_process_log (step_name);

    create index spt_process_log_case_id on identityiq.spt_process_log (case_id);

    create index spt_process_log_case_status on identityiq.spt_process_log (case_status);

    create index spt_process_log_wf_case_name on identityiq.spt_process_log (workflow_case_name(255));

    alter table identityiq.spt_process_log 
        add index FK28FB62EC486634B7 (assigned_scope), 
        add constraint FK28FB62EC486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_process_log 
        add index FK28FB62ECA5FB1B1 (owner), 
        add constraint FK28FB62ECA5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_profile 
        add index FK6BFE472139D71460 (application), 
        add constraint FK6BFE472139D71460 
        foreign key (application) 
        references identityiq.spt_application (id);

    alter table identityiq.spt_profile 
        add index FK6BFE472122D068BA (bundle_id), 
        add constraint FK6BFE472122D068BA 
        foreign key (bundle_id) 
        references identityiq.spt_bundle (id);

    alter table identityiq.spt_profile 
        add index FK6BFE4721486634B7 (assigned_scope), 
        add constraint FK6BFE4721486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_profile 
        add index FK6BFE4721A5FB1B1 (owner), 
        add constraint FK6BFE4721A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_profile_constraints 
        add index FKEFD7A218B236FD12 (profile), 
        add constraint FKEFD7A218B236FD12 
        foreign key (profile) 
        references identityiq.spt_profile (id);

    alter table identityiq.spt_profile_permissions 
        add index FK932EF066B236FD12 (profile), 
        add constraint FK932EF066B236FD12 
        foreign key (profile) 
        references identityiq.spt_profile (id);

    create index spt_provreq_expiration on identityiq.spt_provisioning_request (expiration);

    alter table identityiq.spt_provisioning_request 
        add index FK604114C556651F3A (identity_id), 
        add constraint FK604114C556651F3A 
        foreign key (identity_id) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_provisioning_request 
        add index FK604114C5486634B7 (assigned_scope), 
        add constraint FK604114C5486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_provisioning_request 
        add index FK604114C5A5FB1B1 (owner), 
        add constraint FK604114C5A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    create index spt_prvtrans_idn_ci on identityiq.spt_provisioning_transaction (identity_name);

    create index spt_prvtrans_name on identityiq.spt_provisioning_transaction (name);

    create index spt_prvtrans_iddn_ci on identityiq.spt_provisioning_transaction (identity_display_name);

    create index spt_prvtrans_forced on identityiq.spt_provisioning_transaction (forced);

    create index spt_prvtrans_type on identityiq.spt_provisioning_transaction (type);

    create index spt_prvtrans_status on identityiq.spt_provisioning_transaction (status);

    create index spt_prvtrans_op on identityiq.spt_provisioning_transaction (operation);

    create index spt_prvtrans_adn_ci on identityiq.spt_provisioning_transaction (account_display_name(255));

    create index spt_prvtrans_nid_ci on identityiq.spt_provisioning_transaction (native_identity(255));

    create index spt_prvtrans_src on identityiq.spt_provisioning_transaction (source);

    create index spt_prvtrans_integ_ci on identityiq.spt_provisioning_transaction (integration);

    create index spt_prvtrans_app_ci on identityiq.spt_provisioning_transaction (application_name);

    alter table identityiq.spt_quick_link 
        add index FKF16B9E94486634B7 (assigned_scope), 
        add constraint FKF16B9E94486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_quick_link 
        add index FKF16B9E94A5FB1B1 (owner), 
        add constraint FKF16B9E94A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_quick_link_options 
        add index FK8C93F7F329E4F453 (quick_link), 
        add constraint FK8C93F7F329E4F453 
        foreign key (quick_link) 
        references identityiq.spt_quick_link (id);

    alter table identityiq.spt_quick_link_options 
        add index FK8C93F7F3E5B001E9 (dynamic_scope), 
        add constraint FK8C93F7F3E5B001E9 
        foreign key (dynamic_scope) 
        references identityiq.spt_dynamic_scope (id);

    alter table identityiq.spt_quick_link_options 
        add index FK8C93F7F3A5FB1B1 (owner), 
        add constraint FK8C93F7F3A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_remediation_item 
        add index FK53608075FCF09A9D (work_item_id), 
        add constraint FK53608075FCF09A9D 
        foreign key (work_item_id) 
        references identityiq.spt_work_item (id);

    alter table identityiq.spt_remediation_item 
        add index FK53608075EDFFCCCD (assignee), 
        add constraint FK53608075EDFFCCCD 
        foreign key (assignee) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_remediation_item 
        add index FK53608075486634B7 (assigned_scope), 
        add constraint FK53608075486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_remediation_item 
        add index FK53608075A5FB1B1 (owner), 
        add constraint FK53608075A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    create index spt_remote_login_expiration on identityiq.spt_remote_login_token (expiration);

    alter table identityiq.spt_remote_login_token 
        add index FK45BCDEB2486634B7 (assigned_scope), 
        add constraint FK45BCDEB2486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_remote_login_token 
        add index FK45BCDEB2A5FB1B1 (owner), 
        add constraint FK45BCDEB2A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    create index spt_request_name on identityiq.spt_request (name(255));

    create index spt_request_expiration on identityiq.spt_request (expiration);

    create index spt_request_compl_status on identityiq.spt_request (completion_status);

    create index spt_request_phase on identityiq.spt_request (phase);

    create index spt_request_nextLaunch on identityiq.spt_request (next_launch);

    create index spt_request_depPhase on identityiq.spt_request (dependent_phase);

    alter table identityiq.spt_request 
        add index FKBFBEB0073EE0F059 (task_result), 
        add constraint FKBFBEB0073EE0F059 
        foreign key (task_result) 
        references identityiq.spt_task_result (id);

    alter table identityiq.spt_request 
        add index FKBFBEB007307D4C55 (definition), 
        add constraint FKBFBEB007307D4C55 
        foreign key (definition) 
        references identityiq.spt_request_definition (id);

    alter table identityiq.spt_request 
        add index FKBFBEB007486634B7 (assigned_scope), 
        add constraint FKBFBEB007486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_request 
        add index FKBFBEB007A5FB1B1 (owner), 
        add constraint FKBFBEB007A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_request_arguments 
        add index FK2551071EACF1AFBA (signature), 
        add constraint FK2551071EACF1AFBA 
        foreign key (signature) 
        references identityiq.spt_request_definition (id);

    alter table identityiq.spt_request_definition 
        add index FKF976608B486634B7 (assigned_scope), 
        add constraint FKF976608B486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_request_definition 
        add index FKF976608BA5FB1B1 (owner), 
        add constraint FKF976608BA5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_request_definition 
        add index FKF976608B319F1FAC (parent), 
        add constraint FKF976608B319F1FAC 
        foreign key (parent) 
        references identityiq.spt_request_definition (id);

    alter table identityiq.spt_request_definition_rights 
        add index FKD7D17C0B77278CD9 (request_definition_id), 
        add constraint FKD7D17C0B77278CD9 
        foreign key (request_definition_id) 
        references identityiq.spt_request_definition (id);

    alter table identityiq.spt_request_definition_rights 
        add index FKD7D17C0BD22635BD (right_id), 
        add constraint FKD7D17C0BD22635BD 
        foreign key (right_id) 
        references identityiq.spt_right (id);

    alter table identityiq.spt_request_returns 
        add index FK9F6C90BACF1AFBA (signature), 
        add constraint FK9F6C90BACF1AFBA 
        foreign key (signature) 
        references identityiq.spt_request_definition (id);

    alter table identityiq.spt_resource_event 
        add index FK37A182B139D71460 (application), 
        add constraint FK37A182B139D71460 
        foreign key (application) 
        references identityiq.spt_application (id);

    alter table identityiq.spt_right 
        add index FKAE287D94486634B7 (assigned_scope), 
        add constraint FKAE287D94486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_right 
        add index FKAE287D94A5FB1B1 (owner), 
        add constraint FKAE287D94A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_right_config 
        add index FKE69E544D486634B7 (assigned_scope), 
        add constraint FKE69E544D486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_right_config 
        add index FKE69E544DA5FB1B1 (owner), 
        add constraint FKE69E544DA5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    create index role_index_cscore on identityiq.spt_role_index (composite_score);

    alter table identityiq.spt_role_index 
        add index FKF99E0B5128E03F44 (bundle), 
        add constraint FKF99E0B5128E03F44 
        foreign key (bundle) 
        references identityiq.spt_bundle (id);

    alter table identityiq.spt_role_index 
        add index FKF99E0B51486634B7 (assigned_scope), 
        add constraint FKF99E0B51486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_role_index 
        add index FKF99E0B51A5FB1B1 (owner), 
        add constraint FKF99E0B51A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_role_metadata 
        add index FK1D4114507B368F38 (role), 
        add constraint FK1D4114507B368F38 
        foreign key (role) 
        references identityiq.spt_bundle (id);

    alter table identityiq.spt_role_metadata 
        add index FK1D411450486634B7 (assigned_scope), 
        add constraint FK1D411450486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_role_metadata 
        add index FK1D411450A5FB1B1 (owner), 
        add constraint FK1D411450A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_role_mining_result 
        add index FKF65D466B486634B7 (assigned_scope), 
        add constraint FKF65D466B486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_role_mining_result 
        add index FKF65D466BA5FB1B1 (owner), 
        add constraint FKF65D466BA5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_role_scorecard 
        add index FK494BABA1CD12A446 (role_id), 
        add constraint FK494BABA1CD12A446 
        foreign key (role_id) 
        references identityiq.spt_bundle (id);

    alter table identityiq.spt_role_scorecard 
        add index FK494BABA1486634B7 (assigned_scope), 
        add constraint FK494BABA1486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_role_scorecard 
        add index FK494BABA1A5FB1B1 (owner), 
        add constraint FK494BABA1A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_rule 
        add index FK9A438C84486634B7 (assigned_scope), 
        add constraint FK9A438C84486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_rule 
        add index FK9A438C84A5FB1B1 (owner), 
        add constraint FK9A438C84A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_rule_dependencies 
        add index FKCBE25104DB28D887 (dependency), 
        add constraint FKCBE25104DB28D887 
        foreign key (dependency) 
        references identityiq.spt_rule (id);

    alter table identityiq.spt_rule_dependencies 
        add index FKCBE251043908AE7A (rule_id), 
        add constraint FKCBE251043908AE7A 
        foreign key (rule_id) 
        references identityiq.spt_rule (id);

    alter table identityiq.spt_rule_registry 
        add index FK3D19A998486634B7 (assigned_scope), 
        add constraint FK3D19A998486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_rule_registry 
        add index FK3D19A998A5FB1B1 (owner), 
        add constraint FK3D19A998A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_rule_registry_callouts 
        add index FKF177290A3908AE7A (rule_id), 
        add constraint FKF177290A3908AE7A 
        foreign key (rule_id) 
        references identityiq.spt_rule (id);

    alter table identityiq.spt_rule_registry_callouts 
        add index FKF177290AB7A3F533 (rule_registry_id), 
        add constraint FKF177290AB7A3F533 
        foreign key (rule_registry_id) 
        references identityiq.spt_rule_registry (id);

    alter table identityiq.spt_rule_signature_arguments 
        add index FK192036541CB79DF4 (signature), 
        add constraint FK192036541CB79DF4 
        foreign key (signature) 
        references identityiq.spt_rule (id);

    alter table identityiq.spt_rule_signature_returns 
        add index FKCF144DC11CB79DF4 (signature), 
        add constraint FKCF144DC11CB79DF4 
        foreign key (signature) 
        references identityiq.spt_rule (id);

    create index spt_app_attr_mod on identityiq.spt_schema_attributes (remed_mod_type);

    alter table identityiq.spt_schema_attributes 
        add index FK95BF22DB9A312D2 (applicationschema), 
        add constraint FK95BF22DB9A312D2 
        foreign key (applicationschema) 
        references identityiq.spt_application_schema (id);

    create index scope_disp_name_ci on identityiq.spt_scope (display_name);

    create index scope_dirty on identityiq.spt_scope (dirty);

    create index scope_name_ci on identityiq.spt_scope (name);

    create index scope_path on identityiq.spt_scope (path(255));

    alter table identityiq.spt_scope 
        add index FKAE33F9CC486634B7 (assigned_scope), 
        add constraint FKAE33F9CC486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_scope 
        add index FKAE33F9CC35F348E4 (parent_id), 
        add constraint FKAE33F9CC35F348E4 
        foreign key (parent_id) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_scope 
        add index FKAE33F9CCA5FB1B1 (owner), 
        add constraint FKAE33F9CCA5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_score_config 
        add index FKC7BA0717B37A9D03 (right_config), 
        add constraint FKC7BA0717B37A9D03 
        foreign key (right_config) 
        references identityiq.spt_right_config (id);

    alter table identityiq.spt_score_config 
        add index FKC7BA0717486634B7 (assigned_scope), 
        add constraint FKC7BA0717486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_score_config 
        add index FKC7BA0717A5FB1B1 (owner), 
        add constraint FKC7BA0717A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    create index identity_scorecard_cscore on identityiq.spt_scorecard (composite_score);

    alter table identityiq.spt_scorecard 
        add index FK2062601A56651F3A (identity_id), 
        add constraint FK2062601A56651F3A 
        foreign key (identity_id) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_scorecard 
        add index FK2062601A486634B7 (assigned_scope), 
        add constraint FK2062601A486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_scorecard 
        add index FK2062601AA5FB1B1 (owner), 
        add constraint FK2062601AA5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_service_status 
        add index FKB5E2AC44426BA8FB (definition), 
        add constraint FKB5E2AC44426BA8FB 
        foreign key (definition) 
        references identityiq.spt_service_definition (id);

    create index sign_off_history_signer_id on identityiq.spt_sign_off_history (signer_id);

    create index spt_sign_off_history_esig on identityiq.spt_sign_off_history (electronic_sign);

    alter table identityiq.spt_sign_off_history 
        add index FK2BDCCBCADB59193A (certification_id), 
        add constraint FK2BDCCBCADB59193A 
        foreign key (certification_id) 
        references identityiq.spt_certification (id);

    alter table identityiq.spt_sign_off_history 
        add index FK2BDCCBCA486634B7 (assigned_scope), 
        add constraint FK2BDCCBCA486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_sign_off_history 
        add index FK2BDCCBCAA5FB1B1 (owner), 
        add constraint FK2BDCCBCAA5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_snapshot_permissions 
        add index FK74F58811356B4995 (snapshot), 
        add constraint FK74F58811356B4995 
        foreign key (snapshot) 
        references identityiq.spt_entitlement_snapshot (id);

    alter table identityiq.spt_sodconstraint 
        add index FKDB94CDD2E02D59E (violation_owner_rule), 
        add constraint FKDB94CDD2E02D59E 
        foreign key (violation_owner_rule) 
        references identityiq.spt_rule (id);

    alter table identityiq.spt_sodconstraint 
        add index FKDB94CDD57FD28A4 (policy), 
        add constraint FKDB94CDD57FD28A4 
        foreign key (policy) 
        references identityiq.spt_policy (id);

    alter table identityiq.spt_sodconstraint 
        add index FKDB94CDD486634B7 (assigned_scope), 
        add constraint FKDB94CDD486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_sodconstraint 
        add index FKDB94CDDA5FB1B1 (owner), 
        add constraint FKDB94CDDA5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_sodconstraint 
        add index FKDB94CDD16E8C617 (violation_owner), 
        add constraint FKDB94CDD16E8C617 
        foreign key (violation_owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_sodconstraint_left 
        add index FKCCC28E29AEB984AA (sodconstraint), 
        add constraint FKCCC28E29AEB984AA 
        foreign key (sodconstraint) 
        references identityiq.spt_sodconstraint (id);

    alter table identityiq.spt_sodconstraint_left 
        add index FKCCC28E2952F56EF8 (businessrole), 
        add constraint FKCCC28E2952F56EF8 
        foreign key (businessrole) 
        references identityiq.spt_bundle (id);

    alter table identityiq.spt_sodconstraint_right 
        add index FKCBE5983AAEB984AA (sodconstraint), 
        add constraint FKCBE5983AAEB984AA 
        foreign key (sodconstraint) 
        references identityiq.spt_sodconstraint (id);

    alter table identityiq.spt_sodconstraint_right 
        add index FKCBE5983A52F56EF8 (businessrole), 
        add constraint FKCBE5983A52F56EF8 
        foreign key (businessrole) 
        references identityiq.spt_bundle (id);

    alter table identityiq.spt_sync_roles 
        add index FK1F091BA1719E7338 (config), 
        add constraint FK1F091BA1719E7338 
        foreign key (config) 
        references identityiq.spt_integration_config (id);

    alter table identityiq.spt_sync_roles 
        add index FK1F091BA128E03F44 (bundle), 
        add constraint FK1F091BA128E03F44 
        foreign key (bundle) 
        references identityiq.spt_bundle (id);

    create index spt_syslog_event_level on identityiq.spt_syslog_event (event_level);

    create index spt_syslog_classname on identityiq.spt_syslog_event (classname);

    create index spt_syslog_quickKey on identityiq.spt_syslog_event (quick_key);

    create index spt_syslog_message on identityiq.spt_syslog_event (message(255));

    create index spt_syslog_created on identityiq.spt_syslog_event (created);

    create index spt_syslog_username on identityiq.spt_syslog_event (username);

    create index spt_syslog_server on identityiq.spt_syslog_event (server);

    alter table identityiq.spt_tag 
        add index FK891AF912486634B7 (assigned_scope), 
        add constraint FK891AF912486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_tag 
        add index FK891AF912A5FB1B1 (owner), 
        add constraint FK891AF912A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    create index spt_target_native_obj_id on identityiq.spt_target(native_object_id(255));

    create index spt_target_last_agg on identityiq.spt_target (last_aggregation);

    create index spt_target_extended1_ci on identityiq.spt_target (extended1);

    alter table identityiq.spt_target 
        add index FK19E525192F001D5 (target_source), 
        add constraint FK19E525192F001D5 
        foreign key (target_source) 
        references identityiq.spt_target_source (id);

    alter table identityiq.spt_target 
        add index FK19E52519486634B7 (assigned_scope), 
        add constraint FK19E52519486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_target 
        add index FK19E52519A5FB1B1 (owner), 
        add constraint FK19E52519A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_target 
        add index FK19E525195D4B587B (parent), 
        add constraint FK19E525195D4B587B 
        foreign key (parent) 
        references identityiq.spt_target (id);

    create index spt_target_assoc_id on identityiq.spt_target_association (object_id);

    create index spt_target_assoc_targ_name_ci on identityiq.spt_target_association (target_name);

    create index spt_target_assoc_last_agg on identityiq.spt_target_association (last_aggregation);

    alter table identityiq.spt_target_association 
        add index FK7AD6825B486634B7 (assigned_scope), 
        add constraint FK7AD6825B486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_target_association 
        add index FK7AD6825B68039A5A (target_id), 
        add constraint FK7AD6825B68039A5A 
        foreign key (target_id) 
        references identityiq.spt_target (id);

    alter table identityiq.spt_target_association 
        add index FK7AD6825BA5FB1B1 (owner), 
        add constraint FK7AD6825BA5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_target_source 
        add index FK6F50201D9F8531C (refresh_rule), 
        add constraint FK6F50201D9F8531C 
        foreign key (refresh_rule) 
        references identityiq.spt_rule (id);

    alter table identityiq.spt_target_source 
        add index FK6F502014FE65998 (creation_rule), 
        add constraint FK6F502014FE65998 
        foreign key (creation_rule) 
        references identityiq.spt_rule (id);

    alter table identityiq.spt_target_source 
        add index FK6F50201B854BFAE (transformation_rule), 
        add constraint FK6F50201B854BFAE 
        foreign key (transformation_rule) 
        references identityiq.spt_rule (id);

    alter table identityiq.spt_target_source 
        add index FK6F50201BE1EE0D5 (correlation_rule), 
        add constraint FK6F50201BE1EE0D5 
        foreign key (correlation_rule) 
        references identityiq.spt_rule (id);

    alter table identityiq.spt_target_source 
        add index FK6F50201486634B7 (assigned_scope), 
        add constraint FK6F50201486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_target_source 
        add index FK6F50201A5FB1B1 (owner), 
        add constraint FK6F50201A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_target_sources 
        add index FKD7AB3E9239D71460 (application), 
        add constraint FKD7AB3E9239D71460 
        foreign key (application) 
        references identityiq.spt_application (id);

    alter table identityiq.spt_target_sources 
        add index FKD7AB3E9270D64BF9 (elt), 
        add constraint FKD7AB3E9270D64BF9 
        foreign key (elt) 
        references identityiq.spt_target_source (id);

    create index spt_task_deprecated on identityiq.spt_task_definition (deprecated);

    alter table identityiq.spt_task_definition 
        add index FK526FE5C57A31ADF5 (signoff_config), 
        add constraint FK526FE5C57A31ADF5 
        foreign key (signoff_config) 
        references identityiq.spt_work_item_config (id);

    alter table identityiq.spt_task_definition 
        add index FK526FE5C5486634B7 (assigned_scope), 
        add constraint FK526FE5C5486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_task_definition 
        add index FK526FE5C5A5FB1B1 (owner), 
        add constraint FK526FE5C5A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_task_definition 
        add index FK526FE5C5ED0E8BA2 (parent), 
        add constraint FK526FE5C5ED0E8BA2 
        foreign key (parent) 
        references identityiq.spt_task_definition (id);

    alter table identityiq.spt_task_definition_rights 
        add index FKAA0C8191D22635BD (right_id), 
        add constraint FKAA0C8191D22635BD 
        foreign key (right_id) 
        references identityiq.spt_right (id);

    alter table identityiq.spt_task_definition_rights 
        add index FKAA0C81913B7AD545 (task_definition_id), 
        add constraint FKAA0C81913B7AD545 
        foreign key (task_definition_id) 
        references identityiq.spt_task_definition (id);

    create index spt_task_event_phase on identityiq.spt_task_event (phase);

    alter table identityiq.spt_task_event 
        add index FKDACBC2E83EE0F059 (task_result), 
        add constraint FKDACBC2E83EE0F059 
        foreign key (task_result) 
        references identityiq.spt_task_result (id);

    alter table identityiq.spt_task_event 
        add index FKDACBC2E83908AE7A (rule_id), 
        add constraint FKDACBC2E83908AE7A 
        foreign key (rule_id) 
        references identityiq.spt_rule (id);

    alter table identityiq.spt_task_event 
        add index FKDACBC2E8486634B7 (assigned_scope), 
        add constraint FKDACBC2E8486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_task_event 
        add index FKDACBC2E8A5FB1B1 (owner), 
        add constraint FKDACBC2E8A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    create index spt_taskresult_schedule on identityiq.spt_task_result (schedule);

    create index spt_task_compl_status on identityiq.spt_task_result (completion_status);

    create index spt_taskresult_target on identityiq.spt_task_result (target_id);

    create index spt_taskres_verified on identityiq.spt_task_result (verified);

    create index spt_taskres_completed on identityiq.spt_task_result (completed);

    create index spt_taskres_expiration on identityiq.spt_task_result (expiration);

    create index spt_taskresult_targetname_ci on identityiq.spt_task_result (target_name);

    alter table identityiq.spt_task_result 
        add index FK93F2818FEBECB84B (definition), 
        add constraint FK93F2818FEBECB84B 
        foreign key (definition) 
        references identityiq.spt_task_definition (id);

    alter table identityiq.spt_task_result 
        add index FK93F2818F486634B7 (assigned_scope), 
        add constraint FK93F2818F486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_task_result 
        add index FK93F2818FAAD2E472 (report), 
        add constraint FK93F2818FAAD2E472 
        foreign key (report) 
        references identityiq.spt_jasper_result (id);

    alter table identityiq.spt_task_result 
        add index FK93F2818FA5FB1B1 (owner), 
        add constraint FK93F2818FA5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_task_signature_arguments 
        add index FK3E81365D68611BB0 (signature), 
        add constraint FK3E81365D68611BB0 
        foreign key (signature) 
        references identityiq.spt_task_definition (id);

    alter table identityiq.spt_task_signature_returns 
        add index FK797BC0A68611BB0 (signature), 
        add constraint FK797BC0A68611BB0 
        foreign key (signature) 
        references identityiq.spt_task_definition (id);

    alter table identityiq.spt_time_period 
        add index FK49F210EB486634B7 (assigned_scope), 
        add constraint FK49F210EB486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_time_period 
        add index FK49F210EBA5FB1B1 (owner), 
        add constraint FK49F210EBA5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_uiconfig 
        add index FK2B1F445E486634B7 (assigned_scope), 
        add constraint FK2B1F445E486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_uiconfig 
        add index FK2B1F445EA5FB1B1 (owner), 
        add constraint FK2B1F445EA5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_uipreferences 
        add index FK15336F5CA5FB1B1 (owner), 
        add constraint FK15336F5CA5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_widget 
        add index FK1F6E0DCC486634B7 (assigned_scope), 
        add constraint FK1F6E0DCC486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_widget 
        add index FK1F6E0DCCA5FB1B1 (owner), 
        add constraint FK1F6E0DCCA5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    create index spt_work_item_type on identityiq.spt_work_item (type);

    create index spt_work_item_target on identityiq.spt_work_item (target_id);

    create index spt_work_item_name on identityiq.spt_work_item (name);

    create index spt_work_item_ident_req_id on identityiq.spt_work_item (identity_request_id);

    alter table identityiq.spt_work_item 
        add index FKE2716EF95D5F3DE6 (certification_ref_id), 
        add constraint FKE2716EF95D5F3DE6 
        foreign key (certification_ref_id) 
        references identityiq.spt_certification (id);

    alter table identityiq.spt_work_item 
        add index FKE2716EF9EDFFCCCD (assignee), 
        add constraint FKE2716EF9EDFFCCCD 
        foreign key (assignee) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_work_item 
        add index FKE2716EF93257597F (workflow_case), 
        add constraint FKE2716EF93257597F 
        foreign key (workflow_case) 
        references identityiq.spt_workflow_case (id);

    alter table identityiq.spt_work_item 
        add index FKE2716EF9486634B7 (assigned_scope), 
        add constraint FKE2716EF9486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_work_item 
        add index FKE2716EF92D68567A (requester), 
        add constraint FKE2716EF92D68567A 
        foreign key (requester) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_work_item 
        add index FKE2716EF9A5FB1B1 (owner), 
        add constraint FKE2716EF9A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    create index spt_item_archive_severity on identityiq.spt_work_item_archive (severity);

    create index spt_item_archive_name on identityiq.spt_work_item_archive (name);

    create index spt_item_archive_assignee_ci on identityiq.spt_work_item_archive (assignee);

    create index spt_item_archive_type on identityiq.spt_work_item_archive (type);

    create index spt_item_archive_completer on identityiq.spt_work_item_archive (completer);

    create index spt_item_archive_requester_ci on identityiq.spt_work_item_archive (requester);

    create index spt_item_archive_workItemId on identityiq.spt_work_item_archive (work_item_id);

    create index spt_item_archive_owner_ci on identityiq.spt_work_item_archive (owner_name);

    create index spt_item_archive_target on identityiq.spt_work_item_archive (target_id);

    create index spt_item_archive_ident_req on identityiq.spt_work_item_archive (identity_request_id);

    alter table identityiq.spt_work_item_archive 
        add index FKDFABED7C486634B7 (assigned_scope), 
        add constraint FKDFABED7C486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_work_item_archive 
        add index FKDFABED7CA5FB1B1 (owner), 
        add constraint FKDFABED7CA5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_work_item_comments 
        add index FK5836687A4F2D4385 (work_item), 
        add constraint FK5836687A4F2D4385 
        foreign key (work_item) 
        references identityiq.spt_work_item (id);

    alter table identityiq.spt_work_item_config 
        add index FKC86AF748F36F8B85 (reminder_email), 
        add constraint FKC86AF748F36F8B85 
        foreign key (reminder_email) 
        references identityiq.spt_email_template (id);

    alter table identityiq.spt_work_item_config 
        add index FKC86AF748C98DBFA2 (escalation_rule), 
        add constraint FKC86AF748C98DBFA2 
        foreign key (escalation_rule) 
        references identityiq.spt_rule (id);

    alter table identityiq.spt_work_item_config 
        add index FKC86AF748FDF11A44 (owner_rule), 
        add constraint FKC86AF748FDF11A44 
        foreign key (owner_rule) 
        references identityiq.spt_rule (id);

    alter table identityiq.spt_work_item_config 
        add index FKC86AF7487EAF553E (notification_email), 
        add constraint FKC86AF7487EAF553E 
        foreign key (notification_email) 
        references identityiq.spt_email_template (id);

    alter table identityiq.spt_work_item_config 
        add index FKC86AF74884EC4F68 (escalation_email), 
        add constraint FKC86AF74884EC4F68 
        foreign key (escalation_email) 
        references identityiq.spt_email_template (id);

    alter table identityiq.spt_work_item_config 
        add index FKC86AF748486634B7 (assigned_scope), 
        add constraint FKC86AF748486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_work_item_config 
        add index FKC86AF748A5FB1B1 (owner), 
        add constraint FKC86AF748A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_work_item_config 
        add index FKC86AF7482E3B7910 (parent), 
        add constraint FKC86AF7482E3B7910 
        foreign key (parent) 
        references identityiq.spt_work_item_config (id);

    alter table identityiq.spt_work_item_owners 
        add index FKDD55D82640D47AB (elt), 
        add constraint FKDD55D82640D47AB 
        foreign key (elt) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_work_item_owners 
        add index FKDD55D82618CFF3A8 (config), 
        add constraint FKDD55D82618CFF3A8 
        foreign key (config) 
        references identityiq.spt_work_item_config (id);

    alter table identityiq.spt_workflow 
        add index FK51A3C947486634B7 (assigned_scope), 
        add constraint FK51A3C947486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_workflow 
        add index FK51A3C947A5FB1B1 (owner), 
        add constraint FK51A3C947A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    create index spt_workflowcase_target on identityiq.spt_workflow_case (target_id);

    alter table identityiq.spt_workflow_case 
        add index FKB8E31F28486634B7 (assigned_scope), 
        add constraint FKB8E31F28486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_workflow_case 
        add index FKB8E31F28A5FB1B1 (owner), 
        add constraint FKB8E31F28A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_workflow_registry 
        add index FK1C2E1835486634B7 (assigned_scope), 
        add constraint FK1C2E1835486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_workflow_registry 
        add index FK1C2E1835A5FB1B1 (owner), 
        add constraint FK1C2E1835A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_workflow_rule_libraries 
        add index FKAE96C70EDB28D887 (dependency), 
        add constraint FKAE96C70EDB28D887 
        foreign key (dependency) 
        references identityiq.spt_rule (id);

    alter table identityiq.spt_workflow_rule_libraries 
        add index FKAE96C70E6A8DCF3D (rule_id), 
        add constraint FKAE96C70E6A8DCF3D 
        foreign key (rule_id) 
        references identityiq.spt_workflow (id);

    alter table identityiq.spt_workflow_target 
        add index FK2999F789486634B7 (assigned_scope), 
        add constraint FK2999F789486634B7 
        foreign key (assigned_scope) 
        references identityiq.spt_scope (id);

    alter table identityiq.spt_workflow_target 
        add index FK2999F789A5FB1B1 (owner), 
        add constraint FK2999F789A5FB1B1 
        foreign key (owner) 
        references identityiq.spt_identity (id);

    alter table identityiq.spt_workflow_target 
        add index FK2999F7896B5435D9 (workflow_case_id), 
        add constraint FK2999F7896B5435D9 
        foreign key (workflow_case_id) 
        references identityiq.spt_workflow_case (id);

    create index spt_identity_modified on identityiq.spt_identity (modified);

    create index spt_identity_created on identityiq.spt_identity (created);

    create index spt_identity_entitlement_comp on identityiq.spt_identity_entitlement (identity_id(32), application(32), native_identity(175), instance(16));

    create index spt_ident_entit_comp_name on identityiq.spt_identity_entitlement (identity_id(32), name(223));

    create index spt_idrequest_created on identityiq.spt_identity_request (created);

    create index spt_uuidcompositedelobj on identityiq.spt_deleted_object (application, uuid);

    create index spt_appidcompositedelobj on identityiq.spt_deleted_object (application(32), native_identity(223));

    create index spt_certification_certifiers on identityiq.spt_certifiers (certifier);

    create index spt_request_completed on identityiq.spt_request (completed);

    create index spt_request_id_composite on identityiq.spt_request (id, completed, next_launch, launched);

    create index spt_request_launched on identityiq.spt_request (launched);

    create index spt_application_modified on identityiq.spt_application (modified);

    create index spt_application_created on identityiq.spt_application (created);

    create index spt_workitem_owner_type on identityiq.spt_work_item (owner, type);

    create index spt_cert_item_apps_name on identityiq.spt_cert_item_applications (application_name);

    create index spt_certification_item_tdn on identityiq.spt_certification_item (target_display_name);

    create index spt_bundle_modified on identityiq.spt_bundle (modified);

    create index spt_bundle_created on identityiq.spt_bundle (created);

    create index spt_task_result_created on identityiq.spt_task_result (created);

    create index spt_task_result_launcher on identityiq.spt_task_result (launcher);

    create index spt_managed_created on identityiq.spt_managed_attribute (created);

    create index spt_managed_comp on identityiq.spt_managed_attribute (application(32), type(32), attribute(50), value(141));

    create index spt_managed_modified on identityiq.spt_managed_attribute (modified);

    create index SPT_IDXE5D0EE5E14FE3C13 on identityiq.spt_certification_archive (created);

    create index spt_uuidcomposite on identityiq.spt_link (application, uuid);

    create index spt_appidcomposite on identityiq.spt_link (application(32), native_identity(223));

    create index spt_arch_cert_item_apps_name on identityiq.spt_arch_cert_item_apps (application_name);

    create index spt_integration_conf_created on identityiq.spt_integration_config (created);

    create index spt_integration_conf_modified on identityiq.spt_integration_config (modified);

    create index spt_audit_event_created on identityiq.spt_audit_event (created);

    create index spt_identity_snapshot_created on identityiq.spt_identity_snapshot (created);

    create index spt_role_change_event_created on identityiq.spt_role_change_event (created);

    create index spt_cert_entity_tdn_ci on identityiq.spt_certification_entity (target_display_name);

    create index spt_externaloidnamecomposite on identityiq.spt_link_external_attr (object_id, attribute_name);

    create index SPT_IDX5B44307D406AC829 on identityiq.spt_identity_external_attr (object_id, attribute_name);

    create index spt_externalnamevalcomposite on identityiq.spt_link_external_attr (attribute_name(55), value(200));

    create index SPT_IDX6810487C4D36E028 on identityiq.spt_identity_external_attr (attribute_name(55), value(200));

    create index spt_externalobjectid on identityiq.spt_link_external_attr (object_id);

    create index SPT_IDX1CE9A5A52103D51 on identityiq.spt_identity_external_attr (object_id);

    create index spt_target_assignedscopepath on identityiq.spt_target (assigned_scope_path(255));

    create index spt_workflow_assignedscopepath on identityiq.spt_workflow (assigned_scope_path(255));

    create index spt_uiconfig_assignedscopepath on identityiq.spt_uiconfig (assigned_scope_path(255));

    create index SPT_IDX719553AD788A55AE on identityiq.spt_target_source (assigned_scope_path(255));

    create index SPT_IDX7590C4E191BEDD16 on identityiq.spt_workflow_registry (assigned_scope_path(255));

    create index SPT_IDXE2B6FD83726D2C4 on identityiq.spt_process_log (assigned_scope_path(255));

    create index SPT_IDXECB4C9F64AB87280 on identityiq.spt_group_index (assigned_scope_path(255));

    create index spt_identity_assignedscopepath on identityiq.spt_identity (assigned_scope_path(255));

    create index SPT_IDX7F55103C9C96248C on identityiq.spt_role_metadata (assigned_scope_path(255));

    create index SPT_IDX377FCC029A032198 on identityiq.spt_identity_request (assigned_scope_path(255));

    create index SPT_IDXAEACA8FDA84AB44E on identityiq.spt_role_index (assigned_scope_path(255));

    create index SPT_IDXECBE5C8C4B5A312C on identityiq.spt_capability (assigned_scope_path(255));

    create index SPT_IDX133BD716174D236 on identityiq.spt_provisioning_request (assigned_scope_path(255));

    create index SPT_IDX8CEA0D6E33EF6770 on identityiq.spt_batch_request (assigned_scope_path(255));

    create index SPT_IDX7EDDBC591F6A3A06 on identityiq.spt_deleted_object (assigned_scope_path(255));

    create index SPT_IDX2AE3D4A6385CD3E0 on identityiq.spt_message_template (assigned_scope_path(255));

    create index SPT_IDX99FA48D474C60BBC on identityiq.spt_task_event (assigned_scope_path(255));

    create index SPT_IDXCA5C5C012C739356 on identityiq.spt_certification_delegation (assigned_scope_path(255));

    create index spt_form_assignedscopepath on identityiq.spt_form (assigned_scope_path(255));

    create index SPT_IDX1DB04E7170203436 on identityiq.spt_task_definition (assigned_scope_path(255));

    create index SPT_IDX321B16EB1422CFAA on identityiq.spt_identity_trigger (assigned_scope_path(255));

    create index SPT_IDX59D4F6CD8690EEC on identityiq.spt_certification_definition (assigned_scope_path(255));

    create index SPT_IDX5DA4B31DDBDDDB6 on identityiq.spt_activity_constraint (assigned_scope_path(255));

    create index SPT_IDXBAF33EB59EE05DBE on identityiq.spt_archived_cert_entity (assigned_scope_path(255));

    create index SPT_IDX352BB37529C8F73E on identityiq.spt_identity_archive (assigned_scope_path(255));

    create index SPT_IDX90929F9EDF01B7D0 on identityiq.spt_certification (assigned_scope_path(255));

    create index spt_request_assignedscopepath on identityiq.spt_request (assigned_scope_path(255));

    create index SPT_IDXA6D194B42059DB7C on identityiq.spt_application (assigned_scope_path(255));

    create index SPT_IDXBB0D4BCC29515FAC on identityiq.spt_policy_violation (assigned_scope_path(255));

    create index SPT_IDXFF9A9E0694DBFEA0 on identityiq.spt_partition_result (assigned_scope_path(255));

    create index SPT_IDX45D72A5E6CEE19E on identityiq.spt_work_item (assigned_scope_path(255));

    create index SPT_IDX6BA77F433361865A on identityiq.spt_score_config (assigned_scope_path(255));

    create index SPT_IDXDE774369778BEC26 on identityiq.spt_dashboard_layout (assigned_scope_path(255));

    create index SPT_IDXD6F31180C85EB014 on identityiq.spt_quick_link (assigned_scope_path(255));

    create index SPT_IDXBED7A8DAA6E4E148 on identityiq.spt_configuration (assigned_scope_path(255));

    create index SPT_IDX8DFD31878D3B3E2 on identityiq.spt_target_association (assigned_scope_path(255));

    create index SPT_IDXEA8F35F17CF0E336 on identityiq.spt_email_template (assigned_scope_path(255));

    create index SPT_IDXDCCC1AEC8ACA85EC on identityiq.spt_certification_item (assigned_scope_path(255));

    create index SPT_IDX54AF7352EE4EEBE on identityiq.spt_workflow_target (assigned_scope_path(255));

    create index SPT_IDX608761A1BFB4BC8 on identityiq.spt_audit_config (assigned_scope_path(255));

    create index spt_process_assignedscopepath on identityiq.spt_process (assigned_scope_path(255));

    create index SPT_IDXA6919D21F9F21D96 on identityiq.spt_remediation_item (assigned_scope_path(255));

    create index spt_widget_assignedscopepath on identityiq.spt_widget (assigned_scope_path(255));

    create index SPT_IDX11035135399822BE on identityiq.spt_mining_config (assigned_scope_path(255));

    create index SPT_IDX9D89C40FB709EAF2 on identityiq.spt_certification_action (assigned_scope_path(255));

    create index SPT_IDXDD339B534953A27A on identityiq.spt_mitigation_expiration (assigned_scope_path(255));

    create index SPT_IDX6F2601261AB4CE0 on identityiq.spt_object_config (assigned_scope_path(255));

    create index spt_bundle_assignedscopepath on identityiq.spt_bundle (assigned_scope_path(255));

    create index SPT_IDX34534BBBC845CD4A on identityiq.spt_task_result (assigned_scope_path(255));

    create index SPT_IDX6200CF1CF3199A4C on identityiq.spt_batch_request_item (assigned_scope_path(255));

    create index spt_profile_assignedscopepath on identityiq.spt_profile (assigned_scope_path(255));

    create index SPT_IDX1E683C17685A4D02 on identityiq.spt_time_period (assigned_scope_path(255));

    create index SPT_IDX8F4ABD86AFAD1DA0 on identityiq.spt_scorecard (assigned_scope_path(255));

    create index SPT_IDX6B29BC60611AFDD4 on identityiq.spt_managed_attribute (assigned_scope_path(255));

    create index SPT_IDXC8BAE6DCF83839CC on identityiq.spt_jasper_template (assigned_scope_path(255));

    create index SPT_IDXCB6BC61E1128A4D0 on identityiq.spt_remote_login_token (assigned_scope_path(255));

    create index SPT_IDX593FB9116D127176 on identityiq.spt_entitlement_group (assigned_scope_path(255));

    create index SPT_IDX660B15141EEE343C on identityiq.spt_workflow_case (assigned_scope_path(255));

    create index SPT_IDX823D9A61B16AE816 on identityiq.spt_certification_archive (assigned_scope_path(255));

    create index SPT_IDX892D67C7AB213062 on identityiq.spt_group_definition (assigned_scope_path(255));

    create index SPT_IDXFB512F02CB48A798 on identityiq.spt_certification_challenge (assigned_scope_path(255));

    create index SPT_IDXBAE32AF9A1817F46 on identityiq.spt_right_config (assigned_scope_path(255));

    create index SPT_IDXCE071F89DBC06C66 on identityiq.spt_sodconstraint (assigned_scope_path(255));

    create index SPT_IDXD9728B9EEB248FD0 on identityiq.spt_certification_group (assigned_scope_path(255));

    create index spt_scope_assignedscopepath on identityiq.spt_scope (assigned_scope_path(255));

    create index SPT_IDX5BFDE38499178D1C on identityiq.spt_rule_registry (assigned_scope_path(255));

    create index spt_link_assignedscopepath on identityiq.spt_link (assigned_scope_path(255));

    create index SPT_IDX836C2831FD8ED7B6 on identityiq.spt_file_bucket (assigned_scope_path(255));

    create index SPT_IDXA5EE253FB5399952 on identityiq.spt_jasper_result (assigned_scope_path(255));

    create index SPT_IDX2D52EC448BE739C on identityiq.spt_dashboard_reference (assigned_scope_path(255));

    create index SPT_IDXC71C52111BEFE376 on identityiq.spt_account_group (assigned_scope_path(255));

    create index SPT_IDX686990949D3B0B3C on identityiq.spt_activity_data_source (assigned_scope_path(255));

    create index SPT_IDXD9D9048A81D024A8 on identityiq.spt_dictionary (assigned_scope_path(255));

    create index spt_category_assignedscopepath on identityiq.spt_category (assigned_scope_path(255));

    create index SPT_IDX99763E0AD76DF7A8 on identityiq.spt_alert_definition (assigned_scope_path(255));

    create index SPT_IDX52403791F605046 on identityiq.spt_generic_constraint (assigned_scope_path(255));

    create index SPT_IDXC439D3638206900 on identityiq.spt_sign_off_history (assigned_scope_path(255));

    create index spt_policy_assignedscopepath on identityiq.spt_policy (assigned_scope_path(255));

    create index spt_right_assignedscopepath on identityiq.spt_right (assigned_scope_path(255));

    create index SPT_IDXE4B09B655AF1E31E on identityiq.spt_archived_cert_item (assigned_scope_path(255));

    create index SPT_IDXABF0D041BEBD0BD6 on identityiq.spt_integration_config (assigned_scope_path(255));

    create index SPT_IDX5165831AA4CEA5C8 on identityiq.spt_audit_event (assigned_scope_path(255));

    create index SPT_IDXB999253482041C7C on identityiq.spt_work_item_config (assigned_scope_path(255));

    create index SPT_IDX85C023B24A735CF8 on identityiq.spt_dashboard_content (assigned_scope_path(255));

    create index SPT_IDX9393E3B78D0A4442 on identityiq.spt_request_definition (assigned_scope_path(255));

    create index SPT_IDXB1547649C7A749E6 on identityiq.spt_identity_snapshot (assigned_scope_path(255));

    create index SPT_IDX95FDCE46C5917DC on identityiq.spt_application_schema (assigned_scope_path(255));

    create index spt_rule_assignedscopepath on identityiq.spt_rule (assigned_scope_path(255));

    create index SPT_IDXB52E1053EF6BCC7A on identityiq.spt_correlation_config (assigned_scope_path(255));

    create index SPT_IDXCEBEA62E59148F0 on identityiq.spt_group_factory (assigned_scope_path(255));

    create index spt_custom_assignedscopepath on identityiq.spt_custom (assigned_scope_path(255));

    create index SPT_IDXA367F317D4A97B02 on identityiq.spt_application_scorecard (assigned_scope_path(255));

    create index SPT_IDXF70D54D58BC80EE on identityiq.spt_role_scorecard (assigned_scope_path(255));

    create index SPT_IDX749C6E992BBAE86 on identityiq.spt_dictionary_term (assigned_scope_path(255));

    create index SPT_IDXA511A43C73CC4C8C on identityiq.spt_persisted_file (assigned_scope_path(255));

    create index SPT_IDX50B36EB8F7F2C884 on identityiq.spt_dynamic_scope (assigned_scope_path(255));

    create index SPT_IDX52AF250AB5405B4 on identityiq.spt_jasper_page_bucket (assigned_scope_path(255));

    create index SPT_IDX4875A7F12BD64736 on identityiq.spt_authentication_question (assigned_scope_path(255));

    create index SPT_IDX9542C8399A0989C6 on identityiq.spt_bundle_archive (assigned_scope_path(255));

    create index SPT_IDX1647668E11063E4 on identityiq.spt_work_item_archive (assigned_scope_path(255));

    create index spt_tag_assignedscopepath on identityiq.spt_tag (assigned_scope_path(255));

    create index SPT_IDX10AAF70777DD9EE2 on identityiq.spt_identity_dashboard (assigned_scope_path(255));

    create index SPT_IDX1A2CF87C3B1B850C on identityiq.spt_certification_entity (assigned_scope_path(255));

    create index SPT_IDXC1811197B7DE5802 on identityiq.spt_role_mining_result (assigned_scope_path(255));

    create table identityiq.spt_alert_sequence ( next_val bigint );

    insert into identityiq.spt_alert_sequence values ( 1 );

    create table identityiq.spt_work_item_sequence ( next_val bigint );

    insert into identityiq.spt_work_item_sequence values ( 1 );

    create table identityiq.spt_identity_request_sequence ( next_val bigint );

    insert into identityiq.spt_identity_request_sequence values ( 1 );

    create table identityiq.spt_syslog_event_sequence ( next_val bigint );

    insert into identityiq.spt_syslog_event_sequence values ( 1 );

    create table identityiq.spt_prv_trans_sequence ( next_val bigint );

    insert into identityiq.spt_prv_trans_sequence values ( 1 );
