CREATE MATERIALIZED VIEW cht.mv_child_nutrition_follow_up_new
TABLESPACE ts_report
AS
SELECT
 --Identifiers 
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
    doc ->> 'from'::text                             AS  from

   -- patient
    , doc ->> 'content_type'::text                     AS top_content_type                      -- [NEW FIELD]
    , to_timestamp(NULLIF(doc #>> '{form_version,time}', '')::bigint / 1000.0) AS form_version_time -- [NEW FIELD]
    , doc #>> '{fields,inputs,source}'::text[]                        AS source
    , doc #>> '{fields,inputs,source_id}'::text[]                        AS source_id
    , doc #>> '{fields,inputs,t_patient_date_of_birth}'::text[]          AS t_patient_date_of_birth
    , doc #>> '{fields,inputs,t_patient_gender}'::text[]                 AS t_patient_gender
    , doc #>> '{fields,inputs,t_patient_id}'::text[]                     AS t_patient_id
    , doc #>> '{fields,inputs,t_patient_name}'::text[]                   AS t_patient_name
    , doc #>> '{fields,inputs,user,contact_id}'::text[]                  AS user_contact_id
    , doc #>> '{fields,inputs,user,facility_id}'::text[]                 AS inputs_facility_id
    , doc #>> '{fields,inputs,user,contact,_id}'::text[]                 AS contact_id
    , doc #>> '{fields,inputs,user,contact,name}'::text[]                AS contact_name
    , doc #>> '{fields,inputs,user,contact,date_of_birth}'::text[]       AS contact_date_of_birth
    , doc #>> '{fields,inputs,user,contact,sex}'::text[]                  AS contact_sex
    , doc #>> '{fields,malnutrition_follow_up,facility_visit_date}'::text[] AS facility_visit_date
    , doc #>> '{fields,malnutrition_follow_up,next_nutrition_visit_date}'::text[] AS next_nutrition_visit_date
    , doc #>> '{fields,malnutrition_follow_up,offer_and_select_nutrition_practices}'::text[] AS offer_and_select_nutrition_practices
    , doc #>> '{fields,malnutrition_follow_up,outcome_of_follow_up_visit}'::text[] AS outcome_of_follow_up_visit
    , doc #>> '{fields,malnutrition_follow_up,remind_care_giver}'::text[] AS remind_care_giver
    , doc #>> '{fields,malnutrition_follow_up,educate_caregiver}'::text[] AS educate_caregiver
    , doc #>> '{fields,malnutrition_follow_up,taken_to_facility}'::text[] AS taken_to_facility
    , doc #>> '{fields,needs_signoff}'::text[]                           AS needs_signoff
    , doc #>> '{fields,patient_age_display}'::text[]                     AS patient_age_display
    , doc #>> '{fields,patient_age_in_days}'::text[]                     AS patient_age_in_days
    , doc #>> '{fields,patient_age_in_months}'::text[]                   AS patient_age_in_months
    , doc #>> '{fields,patient_age_in_years}'::text[]                    AS patient_age_in_years
    , doc #>> '{fields,patient_id}'::text[]                              AS patient_id
    , doc #>> '{fields,patient_name}'::text[]                            AS patient_name
    , doc #>> '{fields,patient_gender}'::text[]                          AS patient_gender
    , doc #>> '{fields,dob}'::text[]                                     AS dob
 --- group_patient_summary 
    , doc #>> '{fields,group_patient_summary,patient_health}'            AS patient_health         
    , doc #>> '{fields,group_patient_summary,patient_malnourished}'      AS patient_malnourished   
    , doc #>> '{fields,group_patient_summary,s_note_followup}'           AS note_follow_up        
    , doc #>> '{fields,group_patient_summary,s_note_next_nutrition_date}' AS note_next_nutrition_date 
    , doc #>> '{fields,group_patient_summary,s_note_followup_instructions2}' AS note_followup_instruction
    , doc #>> '{fields,group_patient_summary,s_note_patient_details}'    AS note_patient_details 
    , doc #>> '{fields,group_patient_summary,s_note_patient_details_values}' AS note_patient_details_values 
    , doc #>> '{fields,group_patient_summary,s_note_hiv_exposure_title}' AS note_hiv_exposure_title
    , doc #>> '{fields,group_patient_summary,patient_not_attend_referral}' AS patient_not_attend_referral
    , doc #>> '{fields,group_patient_summary,s_note_follow_up_task}' AS note_follow_up_task,

    --- reporting hierarchy
    doc #>> '{contact,_id}'                         AS chw_id,                   
    doc #>> '{contact,parent,_id}'                  AS chw_area_id,  
    doc #>> '{contact,parent,parent,_id}'           AS facility_id,                                    
    doc #>> '{contact,parent,parent,parent,_id}'    AS parish_id,              
    doc #>> '{contact,parent,parent,parent,parent,_id}'           AS district,                 
    doc #>> '{contact,parent,parent,parent,parent,parent,_id}'    AS region,
    CURRENT_TIMESTAMP AS last_refresh_date    


FROM dwh.cht_data couchdb
WHERE (doc ->> 'form'::text) = 'child_nutrition_follow_up'::text
  AND is_current
WITH DATA;


-- Helpful additional indexes
CREATE INDEX useview_child_nutrition_follow_up_reported
    ON cht.mv_child_nutrition_follow_up_new USING btree (reported);