-- cht.mv_anc_referral_follow_up_new source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_anc_referral_follow_up_new;
CREATE MATERIALIZED VIEW cht.mv_anc_referral_follow_up_new
TABLESPACE ts_report
AS SELECT doc ->> '_id'::text AS uuid,
    doc ->> '_rev'::text AS rev,
    to_timestamp((NULLIF(doc ->> 'reported_date'::text, ''::text)::bigint / 1000)::double precision) AS reported,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY-MM-DD'))::date AS date,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY'))::INT AS year,
    to_char(to_timestamp((((doc ->>'reported_date'::text)::bigint) / 1000)::double precision), 'MM'::text)::integer AS month,
    TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'FMMonth') AS monthname,
    ((doc -> 'fields'::text) -> 'meta'::text) ->> 'instanceID'::text AS instanceid,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) ->> 'deprecatedID'::text AS deprecatedid,
    ((((doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) -> 'location'::text) ->> 'lat'::text AS location_lat,
    ((((doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) -> 'location'::text) ->> 'long'::text AS location_long,
    ((((doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) -> 'location'::text) ->> 'error'::text AS location_error,
    ((((doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) -> 'location'::text) ->> 'message'::text AS location_message,
    (doc -> 'geolocation'::text) ->> 'code'::text AS geolocation_code,
    (doc -> 'geolocation'::text) ->> 'message'::text AS geolocation_message,
    doc ->> 'from'::text AS "from",
    doc #>> '{fields,inputs,source}'::text[] AS source,
    doc #>> '{fields,inputs,source_id}'::text[] AS source_id,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    doc #>> '{fields,inputs,contact,date_of_birth}'::text[] AS contact_date_of_birth,
    doc #>> '{fields,inputs,contact,name}'::text[] AS contact_name,
    doc #>> '{fields,inputs,contact,sex}'::text[] AS contact_sex,
    doc #>> '{fields,is_of_child_bearing_age}'::text[] AS is_of_child_bearing_age,
    doc #>> '{fields,patient_age_display}'::text[] AS patient_age_display,
    doc #>> '{fields,patient_age_in_days}'::text[] AS patient_age_in_days,
    doc #>> '{fields,patient_age_in_months}'::text[] AS patient_age_in_months,
    doc #>> '{fields,patient_age_in_years}'::text[] AS patient_age_in_years,
    doc #>> '{fields,patient_gender}'::text[] AS patient_gender,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,patient_name}'::text[] AS patient_name,
    doc #>> '{fields,patient_name_with_s}'::text[] AS patient_name_with_s,
    doc #>> '{fields,group_anc_defaulter,went_to_hospital}'::text[] AS went_to_hospital,
    doc #>> '{fields,group_missed_referral_details,actions_taken}'::text[] AS actions_taken,
    doc #>> '{fields,group_missed_referral_details,missed_referral_reason}'::text[] AS missed_referral_reason,
    doc #>> '{fields,group_missed_referral_details,missed_referral_reason_other}'::text[] AS missed_referral_reason_other,
    doc #>> '{fields,group_reminder,note_reminder_to_attend_anc}'::text[] AS note_reminder_to_attend_anc,
    doc #>> '{fields,group_referral_details,went_to_hospital}'::text[] AS group_referral_details_went_to_hospital,
    doc #>> '{fields,group_referral_details,pregnancy_test_outcome}'::text[] AS pregnancy_test_outcome,
    doc #>> '{fields,group_referral_details,note_enroll_into_care}'::text[] AS note_enroll_into_care,
    doc #>> '{fields,group_referral_details,note_fp_counsel}'::text[] AS note_fp_counsel,
    doc #>> '{fields,group_referral_details,reason_not_attended_referral}'::text[] AS reason_not_attended_referral,
    doc #>> '{fields,group_referral_details,reason_not_attended_referral_other}'::text[] AS reason_not_attended_referral_other,
    doc #>> '{fields,group_referral_details,note_counsel_on_early_anc_importance}'::text[] AS note_counsel_on_early_anc_importance,
    doc #>> '{fields,group_referral_details,agreed_to_go_to_facility}'::text[] AS agreed_to_go_to_facility,
    doc #>> '{fields,group_referral_details,facility_visit_date}'::text[] AS facility_visit_date,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility_name,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date 
   FROM dwh.cht_data couchdb
    LEFT JOIN cht.mv_chw_hierarchy h ON (couchdb.doc #>> '{contact,_id}') = h.chw_id
  WHERE (doc ->> 'form'::text) = 'anc_referral_follow_up'::text AND is_current
WITH DATA;

-- View indexes:
CREATE INDEX mv_anc_referral_follow_up_uuid ON cht.mv_anc_referral_follow_up_new USING btree (reported);
CREATE INDEX mv_anc_referral_follow_up_chw_id ON cht.mv_anc_referral_follow_up_new USING btree (chw_id);
CREATE INDEX mv_anc_referral_follow_up_year_month ON cht.mv_anc_referral_follow_up_new USING btree (year, month);
CREATE INDEX mv_anc_referral_follow_up_date ON cht.mv_anc_referral_follow_up_new USING btree (date);
CREATE INDEX mv_anc_referral_follow_up_facility ON cht.mv_anc_referral_follow_up_new USING btree (facility_name);
CREATE INDEX mv_anc_referral_follow_up_dhis2_facility_id ON cht.mv_anc_referral_follow_up_new USING btree (dhis2_facility_id);
CREATE INDEX mv_anc_referral_follow_up_district ON cht.mv_anc_referral_follow_up_new USING btree (district);
CREATE INDEX mv_anc_referral_follow_up_region ON cht.mv_anc_referral_follow_up_new USING btree (region);  
