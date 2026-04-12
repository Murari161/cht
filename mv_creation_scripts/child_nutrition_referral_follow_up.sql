CREATE MATERIALIZED VIEW cht.mv_child_nutrition_referral_follow_up
TABLESPACE ts_report
AS
SELECT doc ->> '_id'::text AS uuid,
     doc ->> 'form'::text     AS form,
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
     doc ->> 'from'::text                             AS submitter,
     doc ->> '_rev'::text                             AS rev,                               

    /* ===== Top-level metadata ===== */
     doc ->> 'content_type'::text                     AS top_content_type  ,                
     to_timestamp(NULLIF(doc #>> '{form_version,time}', '')::bigint / 1000.0) AS form_version_time,

    /* ===== Inputs: source & ids ===== */
     doc #>> '{fields,inputs,source}'::text[]         AS source,
     doc #>> '{fields,inputs,source_id}'::text[]      AS source_id,

    /* ===== Inputs: triage / child nutrition snapshot (t_*) ===== */
     doc #>> '{fields,inputs,t_acute_malnutrition_signs}'::text[]  AS t_acute_malnutrition_signs,
     doc #>> '{fields,inputs,t_appears_too_small}'::text[]         AS t_appears_too_small,
     doc #>> '{fields,inputs,t_muac_color}'::text[]                AS t_muac_color,
     doc #>> '{fields,inputs,t_patient_date_of_birth}'::text[]     AS t_patient_date_of_birth,
     doc #>> '{fields,inputs,t_patient_gender}'::text[]            AS t_patient_gender,
     doc #>> '{fields,inputs,t_patient_id}'::text[]                AS t_patient_id,
     doc #>> '{fields,inputs,t_patient_name}'::text[]              AS t_patient_name,
     doc #>> '{fields,inputs,t_place_name}'::text[]                AS t_place_name,
     doc #>> '{fields,inputs,t_vht_name}'::text[]                  AS t_vht_name,
     doc #>> '{fields,inputs,t_vht_phone}'::text[]                 AS t_vht_phone,

    /* ===== Root fields.* patient basics ===== */
     doc #>> '{fields,needs_signoff}'::text[]          AS needs_signoff,
     doc #>> '{fields,patient_age_display}'::text[]    AS patient_age_display,
     doc #>> '{fields,patient_age_in_days}'::text[]    AS patient_age_in_days,
     doc #>> '{fields,patient_age_in_months}'::text[]  AS patient_age_in_months,
     doc #>> '{fields,patient_age_in_years}'::text[]   AS patient_age_in_years,
    /* ===== Referral notification object ===== */
     doc #>> '{fields,referral_notification,referral_signs}'                  AS referral_signs,    
     doc #>> '{fields,referral_notification,note_yellow_muac}'                AS note_yellow_muac,  
     doc #>> '{fields,referral_notification,note_hair_colour_change}'         AS note_hair_colour_change, 
     doc #>> '{fields,referral_notification,confirm_child_taken_to_facility}' AS confirm_child_taken_to_facility, 
     doc #>> '{fields,referral_notification,note_swelling_both_feet}'        AS note_swelling_both_feet, 
     doc #>> '{fields,referral_notification,note_too_thin}'                  AS note_too_thin, 
     doc #>> '{fields,referral_notification,note_red_muac}'                  AS note_red_muac, 
     doc #>> '{fields,referral_notification,note_too_small_for_age}'         AS note_too_small_for_age, 
     doc #>> '{fields,referral_completion,taken_to_facility}' AS taken_to_facility, 
     doc #>> '{fields,referral_completion,remind_care_giver}' AS remind_care_giver, 
     doc #>> '{fields,referral_completion,nutritional_status}' AS nutritional_status, 
     doc #>> '{fields,referral_completion,next_nutrition_visit_date}' AS next_nutrition_visit_date, 
     doc #>> '{fields,referral_completion,educate_caregiver}' AS educate_caregiver, 

    /* ===== Food & good nutrition ===== */
     doc #>> '{fields,food_and_good_nutrition,food_and_good_nutrition_choices}'::text[] AS food_and_good_nutrition_choices,

    /* ===== Patient summary (notes/flags) ===== */
     doc #>> '{fields,group_patient_summary,patient_health}'                  AS patient_health,      
     doc #>> '{fields,group_patient_summary,patient_malnourished}'            AS patient_malnourished,      
     doc #>> '{fields,group_patient_summary,s_note_followup}'                 AS note_followup,      
     doc #>> '{fields,group_patient_summary,s_note_followup_instructions2}'   AS note_followup_instruction,
     doc #>> '{fields,group_patient_summary,s_note_patient_details}'          AS note_patient_details,        
     doc #>> '{fields,group_patient_summary,s_note_patient_details_values}'   AS note_patient_details_values, 
     doc #>> '{fields,group_patient_summary,s_note_hiv_exposure_title}'       AS note_hiv_exposure_title,     
     doc #>> '{fields,group_patient_summary,s_note_next_nutrition_date}'      AS note_nutrition_date,  
     doc #>> '{fields,group_patient_summary,patient_not_attend_referral}'     AS patient_not_attend_referral,    
     doc #>> '{fields,group_patient_summary,s_note_follow_up_task}'           AS s_note_follow_up_task, 

   --- reporting hierarchy
    doc #>> '{contact,_id}'                         AS chw_id,                   
    doc #>> '{contact,parent,_id}'                  AS chw_area_id,  
    doc #>> '{contact,parent,parent,_id}'           AS facility_id,                                    
    doc #>> '{contact,parent,parent,parent,_id}'    AS district,              
    doc #>> '{contact,parent,parent,parent,parent,_id}'           AS region,
    CURRENT_TIMESTAMP AS last_refresh_date


FROM dwh.cht_data
WHERE (doc ->> 'form'::text) = 'child_nutrition_referral_follow_up'::text
  AND is_current
WITH DATA;

-- Helpful additional indexes
CREATE INDEX useview_child_nutrition_referral_follow_up_reported
    ON cht.mv_child_nutrition_referral_follow_up USING btree (reported);

