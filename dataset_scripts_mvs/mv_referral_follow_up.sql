CREATE MATERIALIZED VIEW cht.mv_referral_follow_up
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
     doc ->> 'form'::text                             AS  form,
     doc ->> 'from'::text                             AS  from,
      doc #>> '{fields,inputs,source}'::text[]                            AS source,
      doc #>> '{fields,inputs,source_id}'::text[]                         AS source_id,
      doc #>> '{fields,inputs,follow_up_type}'::text[]                    AS follow_up_type,
      doc #>> '{fields,inputs,t_place_name}'::text[]                      AS t_place_name,
      doc #>> '{fields,inputs,t_vht_name}'::text[]                        AS t_vht_name,
      doc #>> '{fields,inputs,t_vht_phone}'::text[]                       AS t_vht_phone,
      doc #>> '{fields,inputs,contact,_id}'::text[]                       AS contact_id,
      doc #>> '{fields,inputs,contact,name}'::text[]                      AS contact_name,
      doc #>> '{fields,inputs,contact,date_of_birth}'::text[]             AS contact_date_of_birth,
      doc #>> '{fields,inputs,contact,sex}'::text[]                       AS contact_sex,

      doc #>> '{fields,inputs,contact,parent,_id}'::text[]                AS parent_id,
      doc #>> '{fields,inputs,contact,parent,parent,name}'::text[]        AS parent_name,
      doc #>> '{fields,inputs,contact,parent,parent,supervisor}'::text[]  AS supervisor,
      doc #>> '{fields,inputs,contact,parent,parent,phone}'::text[]       AS phone,
     
      doc #>> '{fields,patient_age_in_years}'::text[]                     AS patient_age_in_years,
      doc #>> '{fields,patient_age_in_months}'::text[]                    AS patient_age_in_months,
      doc #>> '{fields,patient_age_in_days}'::text[]                      AS patient_age_in_days,
      doc #>> '{fields,patient_age_display}'::text[]                      AS patient_age_display,
      doc #>> '{fields,patient_id}'::text[]                               AS patient_id,
      doc #>> '{fields,patient_name}'::text[]                             AS patient_name,
      doc #>> '{fields,patient_gender}'::text[]                           AS patient_gender,
      doc #>> '{fields,referral_follow_up_again}'::text[]                 AS referral_follow_up_again,
      doc #>> '{fields,chw_name}'::text[]                                 AS chw_name,
      doc #>> '{fields,chw_phone}'::text[]                                AS chw_phone,
      doc #>> '{fields,chw_village}'::text[]                              AS chw_village,
      doc #>> '{fields,needs_signoff}'::text[]                            AS needs_signoff,
      
      doc #>> '{fields,group_follow_up,follow_up_date}'::text[]  AS follow_up_date,
      doc #>> '{fields,group_follow_up,follow_up_method}'::text[]  AS follow_up_method,

      doc #>> '{fields,group_person_condition,patient_condition}'::text[]  AS patient_condition,
      doc #>> '{fields,group_referral_information,went_to_health_facility}'::text[]             AS went_to_health_facility,
      doc #>> '{fields,group_referral_information,interact_with_healthcare}'::text[]            AS interact_with_healthcare,
      doc #>> '{fields,group_referral_information,note_encourage_to_visit_health_facility}'::text[] AS note_encourage_to_visit_health_facility,
      doc #>> '{fields,group_referral_information,hc_visit_date}'::text[]                      AS hc_visit_date,
      doc #>> '{fields,group_referral_information,hc_attendant}'::text[]                       AS hc_attendant,
      doc #>> '{fields,group_referral_information,hc_attendant_other}'::text[]                 AS hc_attendant_other,
      doc #>> '{fields,group_referral_information,hc_name}'::text[]                            AS hc_name,
      doc #>> '{fields,group_referral_information,action_taken}'::text[]                       AS action_taken,
      doc #>> '{fields,group_referral_information,instructions_for_vht}'::text[]               AS instructions_for_vht,

 
      doc #>> '{fields,group_patient_summary,s_note_referral_follow_up_report}'::text[]       AS s_note_referral_follow_up_report,
      doc #>> '{fields,group_patient_summary,s_note_before_submit}'::text[]                  AS s_note_before_submit,
      doc #>> '{fields,group_patient_summary,s_note_patient_details}'::text[]                AS s_note_patient_details,
      doc #>> '{fields,group_patient_summary,s_note_patient_Details_values}'::text[]         AS s_note_patient_Details_values,
      doc #>> '{fields,group_patient_summary,s_note_referral_follow_up_info}'::text[]        AS s_note_referral_follow_up_info,
      doc #>> '{fields,group_patient_summary,s_note_referral_completed}'::text[]             AS s_note_referral_completed,
      doc #>> '{fields,group_patient_summary,s_note_referral_not_completed}'::text[]         AS s_note_referral_not_completed,
      doc #>> '{fields,group_patient_summary,s_note_comments_treatment_given}'::text[]       AS s_note_comments_treatment_given,
      doc #>> '{fields,group_patient_summary,s_note_referral_not_improved}'::text[]          AS s_note_referral_not_improved,
      doc #>> '{fields,group_patient_summary,s_note_key_instruction}'::text[]                AS s_note_key_instruction,
      doc #>> '{fields,group_patient_summary,s_note_key_instruction_accompany_client}'::text[] AS s_note_key_instruction_accompany_client,
      doc #>> '{fields,group_patient_summary,s_note_followup}'::text[]                       AS s_note_followup,
      doc #>> '{fields,group_patient_summary,s_note_followup_instructions1}'::text[]         AS s_note_followup_instructions1,

 --- reporting hierarchy
      doc #>> '{contact,_id}'                         AS chw_id,                   
      doc #>> '{contact,parent,_id}'                  AS chw_area_id,  
      doc #>> '{contact,parent,parent,_id}'           AS facility_id,                                    
      doc #>> '{contact,parent,parent,parent,_id}'    AS parish_id,              
      doc #>> '{contact,parent,parent,parent,parent,_id}'           AS district,                 
      doc #>> '{contact,parent,parent,parent,parent,parent,_id}'           AS region                 

FROM dwh.cht_data
WHERE (doc ->> 'form') = 'referral_follow_up'
  AND is_current
WITH DATA;

CREATE INDEX referral_follow_up_reported_idx
    ON cht.mv_referral_follow_up USING btree (reported);
