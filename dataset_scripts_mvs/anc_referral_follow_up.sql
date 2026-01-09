CREATE MATERIALIZED VIEW cht.mv_anc_referral_follow_up_new
TABLESPACE ts_report
AS
SELECT
    doc ->> '_id'::text AS uuid,
    doc ->> '_rev'::text                             AS rev,                                 -- [NEW FIELD]
      to_timestamp((NULLIF(doc ->> 'reported_date'::text, ''::text)::bigint / 1000)::double precision) AS reported,
     (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY-MM-DD'))::date AS date,
     (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY'))::INT AS year,
     TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'FMMonth') AS month,
     doc ->'fields'->'meta'->>'instanceID' AS instanceID,
     doc ->'fields'->'inputs'->'meta'->>'deprecatedID' AS deprecatedID,
     doc ->'fields'->'inputs'->'meta'->'location'->>'lat' AS location_lat,
     doc ->'fields'->'inputs'->'meta'->'location'->>'long' AS location_long,
     doc ->'fields'->'inputs'->'meta'->'location'->>'error' AS location_error,
     doc ->'fields'->'inputs'->'meta'->'location'->>'message' AS location_message,
     doc ->'geolocation'->>'code' AS geolocation_code,
     doc ->'geolocation'->>'message' AS geolocation_message,
     doc ->> 'from'::text                             AS  from,
     doc #>> '{fields,inputs,source}'::text[] AS source,
     doc #>> '{fields,inputs,source_id}'::text[] AS source_id,
     doc #>> '{fields,inputs,contact,_id}'::text[] AS contact_id,
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
    /* ===== Group: Referral Details ===== */
     doc #>> '{fields,group_referral_details,went_to_hospital}'::text[]                 AS group_referral_details_went_to_hospital,
     doc #>> '{fields,group_referral_details,pregnancy_test_outcome}'::text[]          AS pregnancy_test_outcome,
     doc #>> '{fields,group_referral_details,note_enroll_into_care}'::text[]           AS note_enroll_into_care,
     doc #>> '{fields,group_referral_details,note_fp_counsel}'::text[]                 AS note_fp_counsel,
     doc #>> '{fields,group_referral_details,reason_not_attended_referral}'::text[]    AS reason_not_attended_referral,
     doc #>> '{fields,group_referral_details,reason_not_attended_referral_other}'::text[] AS reason_not_attended_referral_other,
     doc #>> '{fields,group_referral_details,note_counsel_on_early_anc_importance}'::text[] AS note_counsel_on_early_anc_importance,
     doc #>> '{fields,group_referral_details,agreed_to_go_to_facility}'::text[]       AS agreed_to_go_to_facility,
     doc #>> '{fields,group_referral_details,facility_visit_date}'::text[]            AS facility_visit_date,
         /* ===== Group: Summary - ANC Referral Follow-Up ===== */
    doc #>> '{fields,group_summary,s_note_anc_referral_follow_up}'::text[]    AS s_note_anc_referral_follow_up,
    doc #>> '{fields,group_summary,s_summary_submit}'::text[]                 AS s_summary_submit,
    doc #>> '{fields,group_summary,s_note_person_details}'::text[]            AS s_note_person_details,
    doc #>> '{fields,group_summary,s_note_person_details_values}'::text[]     AS s_note_person_details_values,
    doc #>> '{fields,group_summary,s_note_findings}'::text[]                  AS s_note_findings,
    doc #>> '{fields,group_summary,s_note_findings_value}'::text[]            AS s_note_findings_value,
    doc #>> '{fields,group_summary,s_note_follow_up}'::text[]                  AS s_note_follow_up,
    doc #>> '{fields,group_summary,s_note_follow_up_value}'::text[]            AS s_note_follow_up_value,
      --- reporting hierarchy
    doc #>> '{contact,_id}'                         AS chw_id,                   
    doc #>> '{contact,parent,_id}'                  AS chw_area_id,  
    doc #>> '{contact,parent,parent,_id}'           AS facility_id,                                    
    doc #>> '{contact,parent,parent,parent,_id}'    AS parish_id,              
    doc #>> '{contact,parent,parent,parent,parent,_id}'           AS district,                 
    doc #>> '{contact,parent,parent,parent,parent,parent,_id}'    AS region,
    CURRENT_TIMESTAMP AS last_refresh_date 

FROM dwh.cht_data couchdb
WHERE (doc ->> 'form'::text) = 'anc_referral_follow_up'::text
  AND is_current
WITH DATA;

-- Unique index
CREATE INDEX mv_anc_referral_follow_up_uuid
    ON cht.mv_anc_referral_follow_up_new USING btree (reported);
