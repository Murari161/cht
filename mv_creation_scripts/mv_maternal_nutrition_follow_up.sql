CREATE MATERIALIZED VIEW cht.mv_maternal_nutrition_follow_up
TABLESPACE ts_report
AS
SELECT
    doc ->> '_id'::text                              AS doc_id,
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

    doc #>> '{fields,inputs,source}'::text[]                      AS source,
    doc #>> '{fields,inputs,source_id}'::text[]                   AS source_id,
    doc #>> '{fields,inputs,is_referral_follow_up}'::text[]       AS is_referral_follow_up,
    doc #>> '{fields,inputs,contact,_id}'::text[]                 AS contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[]                AS contact_name,
    doc #>> '{fields,inputs,contact,date_of_birth}'::text[]       AS contact_date_of_birth,
    doc #>> '{fields,inputs,contact,sex}'::text[]                 AS contact_sex,
    doc #>> '{fields,inputs,contact,parent,_id}'::text[]          AS parent_id,
    doc #>> '{fields,is_of_child_bearing_age}'::text[]            AS is_of_child_bearing_age,
    doc #>> '{fields,patient_age_in_years}'::text[]               AS patient_age_in_years,
    doc #>> '{fields,patient_age_in_months}'::text[]              AS patient_age_in_months,
    doc #>> '{fields,patient_age_in_days}'::text[]                AS patient_age_in_days,
    doc #>> '{fields,patient_age_display}'::text[]                AS patient_age_display,
    doc #>> '{fields,patient_id}'::text[]                          AS patient_id,
    doc #>> '{fields,patient_name}'::text[]                        AS patient_name,
    doc #>> '{fields,patient_gender}'::text[]                      AS patient_gender,
    doc #>> '{fields,findings_value}'::text[]                      AS findings_value,
    doc #>> '{fields,findings_referral_follow_up_value}'::text[]   AS findings_referral_follow_up_value,
    doc #>> '{fields,group_malnutrition_follow_up,went_to_facility}'::text[]                         AS went_to_facility,
    doc #>> '{fields,group_malnutrition_follow_up,note_nutritional_assessment_importance}'::text[]   AS note_nutritional_assessment_importance,
    doc #>> '{fields,group_malnutrition_follow_up,referred_to_health_facility}'::text[]              AS referred_to_health_facility,
    doc #>> '{fields,group_malnutrition_follow_up,nutrition_status}'::text[]                         AS nutrition_status,
    doc #>> '{fields,group_malnutrition_follow_up,agreed_facility_visit_date}'::text[]               AS agreed_facility_visit_date,
    doc #>> '{fields,group_malnutrition_follow_up,follow_up_outcome}'::text[]                         AS follow_up_outcome,
    doc #>> '{fields,group_malnutrition_follow_up,next_clinic_visit_date}'::text[]                   AS next_clinic_visit_date,
    doc #>> '{fields,group_malnutrition_follow_up,educate_woman}'::text[]                             AS educate_woman,
    doc #>> '{fields,group_malnutrition_follow_up,counsel_and_woman_to_join_support_group}'::text[]  AS counsel_and_woman_to_join_support_group,

    doc #>> '{fields,group_summary,s_summary_submit}'::text[]                            AS s_summary_submit,
    doc #>> '{fields,group_summary,s_note_woman_details}'::text[]                        AS s_note_woman_details,
    doc #>> '{fields,group_summary,s_note_woman_details_values}'::text[]                 AS s_note_woman_details_values,
    doc #>> '{fields,group_summary,s_note_findings}'::text[]                              AS s_note_findings,
    doc #>> '{fields,group_summary,s_note_findings_value}'::text[]                        AS s_note_findings_value,
    doc #>> '{fields,group_summary,s_note_findings_referral_follow_up_value}'::text[]    AS s_note_findings_referral_follow_up_value,
    doc #>> '{fields,group_summary,s_note_follow_up_tasks}'::text[]                       AS s_note_follow_up_tasks,
    doc #>> '{fields,group_summary,s_note_screen_during_next_visit}'::text[]             AS s_note_screen_during_next_visit,
    doc #>> '{fields,group_summary,s_note_screen_during_next_house_hold_visit}'::text[]  AS s_note_screen_during_next_house_hold_visit,
    doc #>> '{fields,group_summary,s_note_follow_up_task_appear_agreed_date}'::text[]    AS s_note_follow_up_task_appear_agreed_date,
    doc #>> '{fields,group_summary,s_note_follow_up_task_appear_in_3days}'::text[]       AS s_note_follow_up_task_appear_in_3days,

    --- reporting hierarchy
    doc #>> '{contact,_id}'                         AS chw_id,                   
    doc #>> '{contact,parent,_id}'                  AS chw_area_id,  
    doc #>> '{contact,parent,parent,_id}'           AS facility_id,                                    
    doc #>> '{contact,parent,parent,parent,_id}'    AS parish_id,              
    doc #>> '{contact,parent,parent,parent,parent,_id}'           AS district,                 
    doc #>> '{contact,parent,parent,parent,parent,parent,_id}'    AS region,
    CURRENT_TIMESTAMP                                 AS last_refresh_date   


FROM dwh.cht_data AS couchdb
WHERE (doc ->> 'form') = 'maternal_nutrition_follow_up'
  AND is_current
WITH DATA;

CREATE INDEX maternal_nutrition_follow_up_reported_idx
    ON cht.mv_maternal_nutrition_follow_up USING btree (reported);
