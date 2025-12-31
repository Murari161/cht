CREATE MATERIALIZED VIEW cht.mv_child_health_escalation
TABLESPACE ts_report
AS
SELECT
  --- indentifiers
    doc ->> '_id'                                           AS doc_id,
    doc ->> '_rev'                                          AS rev,                                  -- [NEW FIELD]
    doc ->> 'form'                                          AS form,
    to_timestamp(NULLIF(doc ->> 'reported_date','')::bigint / 1000.0) AS reported,
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
     doc ->> 'from'                                          AS submitter,                             -- [NEW FIELD]

    /* ===== Top-level metadata ===== */
    doc ->> 'content_type'                                  AS top_content_type,                      -- [NEW FIELD]
    to_timestamp(NULLIF(doc #>> '{form_version,time}','')::bigint / 1000.0) AS form_version_time,     -- [NEW FIELD]

    /* ===== Inputs: source & ids ===== */
    doc #>> '{fields,inputs,source}'                        AS inputs_source,                         
    doc #>> '{fields,inputs,source_id}'                     AS source_id,
    doc #>> '{fields,inputs,user,contact_id}'               AS inputs_chw_id,  

    --- Inputs: triage / detail fields 
    doc #>> '{fields,inputs,t_place_name}'                  AS village_name,
    doc #>> '{fields,inputs,t_vht_name}'                    AS t_vht_name,
    doc #>> '{fields,inputs,t_vht_phone}'                   AS t_vht_phone,
    doc #>> '{fields,inputs,t_danger_signs}'                AS t_danger_signs,
    doc #>> '{fields,inputs,t_blood_in_stool}'              AS t_blood_in_stool,
    doc #>> '{fields,inputs,t_cough_duration}'              AS t_cough_duration,
    doc #>> '{fields,inputs,t_fast_breathing}'              AS t_fast_breathing,
    doc #>> '{fields,inputs,t_fever_duration}'              AS t_fever_duration,
    doc #>> '{fields,inputs,t_chest_indrawing}'             AS t_chest_indrawing,
    doc #>> '{fields,inputs,t_diarrhoea_duration}'          AS t_diarrhoea_duration,
    doc #>> '{fields,inputs,t_immunization_referral}'       AS t_immunization_referral,

    /* ===== Root fields.* patient basics ===== */
    doc #>> '{fields,dob}'                                  AS dob,
    doc #>> '{fields,patient_id}'                           AS patient_id,
    doc #>> '{fields,patient_name}'                         AS patient_name,
    doc #>> '{fields,patient_gender}'                       AS patient_gender,
    doc #>> '{fields,patient_age_display}'                  AS patient_age_display,
    doc #>> '{fields,patient_age_in_days}'                  AS patient_age_in_days,
    doc #>> '{fields,patient_age_in_months}'                AS patient_age_in_months,
    doc #>> '{fields,patient_age_in_years}'                 AS patient_age_in_years,
    doc #>> '{fields,needs_signoff}'                        AS needs_signoff,

    /* ===== Action taken ===== */
    doc #>> '{fields,action_taken,completed_referral_follow_up}'     AS completed_referral_follow_up, --(yes/no)
    doc #>> '{fields,action_taken,reason_vht_did_not_follow_up}'     AS reason_vht_did_not_follow_up, --()
    doc #>> '{fields,action_taken,specify}'                          AS reason_specify,
    doc #>> '{fields,action_taken,text_explain_vht_did_not_submit_form}' AS text_explain_vht_did_not_submit_form,
    doc #>> '{fields,action_taken,call_chw}'                         AS action_call_chw,              
    doc #>> '{fields,action_taken,call_button}'                      AS action_call_button,           
    doc #>> '{fields,action_taken,note_health_educate}'              AS note_health_educate,           

    /* ===== Danger signs object ===== */
    doc #>> '{fields,danger_signs,referral_signs}'          AS danger_signs_referral_signs,
    doc #>> '{fields,danger_signs,vomits_everything}'       AS danger_signs_vomits_everything,
    doc #>> '{fields,danger_signs,convulsions}'             AS danger_signs_convulsions,
    doc #>> '{fields,danger_signs,very_sleepy}'             AS danger_signs_very_sleepy,
    doc #>> '{fields,danger_signs,smaller_than_usual}'      AS danger_signs_smaller_than_usual,
    doc #>> '{fields,danger_signs,infected_umblical_cord}'  AS danger_signs_infected_umblical_cord,
    doc #>> '{fields,danger_signs,chest_in_drawing}'        AS danger_signs_chest_in_drawing,
    doc #>> '{fields,danger_signs,not_able_to_breastfeed}'  AS danger_signs_not_able_to_breastfeed,
    doc #>> '{fields,danger_signs,many_pustules}'           AS danger_signs_many_pustules,
    doc #>> '{fields,danger_signs,fever_or_low_temperature}' AS danger_signs_fever_or_low_temperature,
    doc #>> '{fields,danger_signs,yellow_eyes}'             AS danger_signs_yellow_eyes,
    doc #>> '{fields,danger_signs,cough}'                   AS danger_signs_cough,
    doc #>> '{fields,danger_signs,diarrhoea}'               AS danger_signs_diarrhoea,
    doc #>> '{fields,danger_signs,blood_in_stool}'          AS danger_signs_blood_in_stool,
    doc #>> '{fields,danger_signs,fever_duration}'          AS danger_signs_fever_duration,
    doc #>> '{fields,danger_signs,immunization_missed}'     AS danger_signs_immunization_missed,

     --- reporting hierarchy
    doc #>> '{contact,_id}'                         AS chw_id,                   
    doc #>> '{contact,parent,_id}'                  AS chw_area_id,  
    doc #>> '{contact,parent,parent,_id}'           AS facility_id,                                    
    doc #>> '{contact,parent,parent,parent,_id}'    AS district,              
    doc #>> '{contact,parent,parent,parent,parent,_id}'           AS region,
    CURRENT_TIMESTAMP AS last_refresh_date                

FROM dwh.cht_data
WHERE (doc ->> 'form') = 'child_health_escalation'
  AND is_current
WITH DATA;

-- Indexes
CREATE INDEX mv_child_health_escalation_reported
    ON cht.mv_child_health_escalation USING btree (reported);
CREATE INDEX mv_child_health_escalation_patient
    ON cht.mv_child_health_escalation USING btree (patient_id);
