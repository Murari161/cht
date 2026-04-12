CREATE MATERIALIZED VIEW cht.mv_anc_danger_sign_escalation
TABLESPACE ts_report
AS
SELECT
   --- Identifiers 
    doc ->> '_id'                                           AS uuid,
    doc ->> '_rev'                                          AS rev,                             
    doc ->> 'form'                                          AS form,
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

    doc ->> 'from'                                          AS submitter,

   ---Top-level metadata 
    doc ->> 'content_type'                                  AS top_content_type,                  
    to_timestamp(NULLIF(doc #>> '{form_version,time}','')::bigint / 1000.0) AS form_version_time,      

  --- patient at escalation details
    doc #>> '{fields,inputs,user,contact_id}'               AS user_contact_id,
    doc #>> '{fields,inputs,user,facility_id}'              AS user_facility_id,
    doc #>> '{fields,inputs,contact,_id}'                   AS contact_id,
    doc #>> '{fields,inputs,contact,name}'                   AS contact_name,
    doc #>> '{fields,inputs,contact,sex}'                   AS contact_sex,
    doc #>> '{fields,inputs,contact,date_of_birth}'         AS contact_date_of_birth,  
    doc #>> '{fields,dob}'                                  AS dob,
    doc #>> '{fields,patient_id}'                           AS patient_id,
    doc #>> '{fields,patient_name}'                        AS patient_name,
    doc #>> '{fields,patient_gender}'                       AS patient_gender,  
    doc #>> '{fields,needs_signoff}'                       AS needs_signoff,
    doc #>> '{fields,patient_age_display}'                  AS patient_age,
    doc #>> '{fields,patient_age_in_days}'                  AS patient_age_in_days,
    doc #>> '{fields,patient_age_in_months}'                AS patient_age_in_months,
    doc #>> '{fields,patient_age_in_years}'                 AS patient_age_in_years,
    doc #>> '{fields,inputs,t_place_name}'                  AS tvh_place_name,
    doc #>> '{fields,inputs,t_vht_name}'                    AS vht_name,
    doc #>> '{fields,inputs,t_vht_phone}'                   AS vht_vht_phone,
    doc #>> '{fields,inputs,t_pregnancy_danger_signs}'      AS t_pregnancy_danger_signs,
    doc #>> '{fields,inputs,t_reduced_or_no_feotal_movements}' AS t_reduced_or_no_feotal_movements,
    doc #>> '{fields,inputs,t_fever}'                       AS t_fever,
    doc #>> '{fields,inputs,t_swelling}'                    AS t_swelling,
    doc #>> '{fields,inputs,t_very_pale}'                   AS t_very_pale,
    doc #>> '{fields,inputs,t_blurred_vision}'              AS t_blurred_vision,
    doc #>> '{fields,inputs,t_breathlessness}'              AS t_breathlessness,
    doc #>> '{fields,inputs,t_severe_headache}'             AS t_severe_headache,
    doc #>> '{fields,inputs,t_vaginal_bleeding}'            AS t_vaginal_bleeding,
    doc #>> '{fields,inputs,t_lower_abdomen_pain}'          AS t_lower_abdomen_pain,
    doc #>> '{fields,inputs,t_patient_id}'                  AS t_patient_id,
    doc #>> '{fields,inputs,t_patient_name}'                AS t_patient_name,
    doc #>> '{fields,inputs,t_patient_gender}'              AS t_patient_gender,
    doc #>> '{fields,inputs,t_patient_date_of_birth}'       AS t_patient_date_of_birth,

    /* ===== Action taken ===== */
    doc #>> '{fields,action_taken,explain_vht_not_submit_referral}' AS explain_vht_not_submit_referral,
    doc #>> '{fields,action_taken,reason_vht_did_not_follow_up}'    AS reason_vht_did_not_follow_up,
    doc #>> '{fields,action_taken,specify}'                         AS other_reson_specify,
    doc #>> '{fields,action_taken,vht_completed_referral_follow_up}' AS vht_completed_referral_follow_up,
    doc #>> '{fields,action_taken,call_chw}'                        AS action_call_chw,               
    doc #>> '{fields,action_taken,call_button}'                     AS action_call_button,          

    /* ===== Danger signs group ===== */
    doc #>> '{fields,danger_signs,referral_signs}'::text[]                  AS danger_signs_referral_signs,
    doc #>> '{fields,danger_signs,vaginal_bleeding}'::text[]                AS danger_signs_vaginal_bleeding,
    doc #>> '{fields,danger_signs,lower_abdomen_pain}'::text[]              AS danger_signs_lower_abdomen_pain,
    doc #>> '{fields,danger_signs,severe_headache}'::text[]                 AS danger_signs_severe_headache,
    doc #>> '{fields,danger_signs,very_pale}'::text[]                       AS danger_signs_very_pale,
    doc #>> '{fields,danger_signs,fever}'::text[]                           AS danger_signs_fever,
    doc #>> '{fields,danger_signs,reduced_or_no_feotal_movements}'::text[]  AS danger_signs_reduced_or_no_feotal_movements,
    doc #>> '{fields,danger_signs,blurred_vision}'::text[]                  AS danger_signs_blurred_vision,
    doc #>> '{fields,danger_signs,swelling}'::text[]                        AS danger_signs_swelling,
    doc #>> '{fields,danger_signs,breathlessness}'::text[]                  AS danger_signs_breathlessness,

    doc #>> '{fields,group_patient_summary,instruction}'::text[]                      AS summary_instruction,
    doc #>> '{fields,group_patient_summary,please_submit_this_form}'::text[]          AS summary_please_submit,
    doc #>> '{fields,group_patient_summary,s_note_patient_details}'::text[]           AS summary_note_patient_details,
    doc #>> '{fields,group_patient_summary,s_note_patient_details_values}'::text[]    AS summary_note_patient_details_values,
    doc #>> '{fields,group_patient_summary,s_note_reason_not_following_up}'::text[]   AS summary_reason_not_following_up,
    doc #>> '{fields,group_patient_summary,s_note_follow_up_completed}'::text[]       AS summary_note_follow_up_completed,
    doc #>> '{fields,group_patient_summary,s_note_woman_not_available}'::text[]       AS summary_note_woman_not_available,
    doc #>> '{fields,group_patient_summary,s_note_vht_not_available}'::text[]         AS summary_note_vht_not_available,
    doc #>> '{fields,group_patient_summary,s_note_specify}'::text[]                   AS summary_note_specify,

  --- reporting hierarchy
    doc #>> '{contact,_id}'                         AS chw_id,                   
    doc #>> '{contact,parent,_id}'                  AS chw_area_id,  
    doc #>> '{contact,parent,parent,_id}'           AS facility_id,                                    
    doc #>> '{contact,parent,parent,parent,_id}'    AS district,              
    doc #>> '{contact,parent,parent,parent,parent,_id}'           AS region,
    CURRENT_TIMESTAMP AS last_refresh_date

FROM dwh.cht_data AS couchdb
WHERE (doc ->> 'form') = 'anc_danger_sign_escalation'
  AND is_current
WITH DATA;

-- Indexes
CREATE INDEX useview_anc_danger_sign_escalation_reported
    ON cht.mv_anc_danger_sign_escalation USING btree (reported);

