CREATE MATERIALIZED VIEW cht.mv_treatment_follow_up_new
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
     
      doc #>> '{fields,inputs,source}'::text[]                       AS source,
      doc #>> '{fields,inputs,source_id}'::text[]                    AS source_id,

      doc #>> '{fields,inputs,contact,_id}'::text[]                  AS contact_id,
      doc #>> '{fields,inputs,contact,name}'::text[]                 AS contact_name,
      doc #>> '{fields,inputs,contact,date_of_birth}'::text[]        AS contact_date_of_birth,
      doc #>> '{fields,inputs,contact,sex}'::text[]                  AS contact_sex,

      doc #>> '{fields,inputs,contact,parent,_id}'::text[]           AS coparent_id,
      doc #>> '{fields,inputs,contact,parent,name}'::text[]          AS contact_parent_name,

      doc #>> '{fields,patient_age_in_years}'::text[]                AS patient_age_in_years,
      doc #>> '{fields,patient_age_in_months}'::text[]               AS patient_age_in_months,
      doc #>> '{fields,patient_age_in_days}'::text[]                 AS patient_age_in_days,
      doc #>> '{fields,patient_age_display}'::text[]                 AS patient_age_display,
      doc #>> '{fields,patient_id}'::text[]                           AS patient_id,
      doc #>> '{fields,patient_name}'::text[]                         AS patient_name,
      doc #>> '{fields,patient_gender}'::text[]                       AS patient_gender,
      doc #>> '{fields,referral_follow_up}'::text[]                   AS referral_follow_up,
      doc #>> '{fields,trigger_referral_follow_up}'::text[]           AS trigger_referral_follow_up,
      doc #>> '{fields,group_danger_signs,follow_up_date}'::text[]                  AS follow_up_date,
      doc #>> '{fields,group_danger_signs,follow_up_method}'::text[]                AS follow_up_method,
      doc #>> '{fields,group_danger_signs,note_look_for_danger_signs_in_person}'::text[] AS note_look_for_danger_signs_in_person,
      doc #>> '{fields,group_danger_signs,note_ask_for_danger_signs_on_phone}'::text[] AS note_ask_for_danger_signs_on_phone,
      doc #>> '{fields,group_danger_signs,any_danger_signs}'::text[]                 AS any_danger_signs,
      doc #>> '{fields,group_danger_signs,note_refer_urgently}'::text[]             AS note_refer_urgently,
      doc #>> '{fields,group_follow_up,how_is_child}'::text[]                AS how_is_child,
      doc #>> '{fields,group_follow_up,note_if_better}'::text[]             AS note_if_better,
      doc #>> '{fields,group_follow_up,child_referred}'::text[]             AS child_referred,
      doc #>> '{fields,group_follow_up,note_refer_to_health_facility}'::text[] AS note_refer_to_health_facility,
      doc #>> '{fields,group_follow_up,note_cured}'::text[]                 AS note_cured,

      doc #>> '{fields,group_key_health_messages,feeding_advice}'::text[]   AS feeding_advice,
      doc #>> '{fields,group_patient_summary,s_note_patient_assessment}'::text[]     AS s_note_patient_assessment,
      doc #>> '{fields,group_patient_summary,s_note_before_submit}'::text[]          AS s_note_before_submit,
      doc #>> '{fields,group_patient_summary,s_note_patient_details}'::text[]        AS s_note_patient_details,
      doc #>> '{fields,group_patient_summary,s_note_patient_details_values}'::text[] AS s_note_patient_details_values,
      doc #>> '{fields,group_patient_summary,s_condition_of_child}'::text[]           AS s_condition_of_child,
      doc #>> '{fields,group_patient_summary,s_note_has_danger_signs}'::text[]       AS s_note_has_danger_signs,
      doc #>> '{fields,group_patient_summary,s_note_danger_sign0}'::text[]           AS s_note_danger_sign0,
      doc #>> '{fields,group_patient_summary,s_note_danger_sign1}'::text[]           AS s_note_danger_sign1,
      doc #>> '{fields,group_patient_summary,s_note_danger_sign2}'::text[]           AS s_note_danger_sign2,
      doc #>> '{fields,group_patient_summary,s_note_danger_sign3}'::text[]           AS s_note_danger_sign3,
      doc #>> '{fields,group_patient_summary,s_note_danger_sign4}'::text[]           AS s_note_danger_sign4,
      doc #>> '{fields,group_patient_summary,s_note_danger_sign5}'::text[]           AS s_note_danger_sign5,
      doc #>> '{fields,group_patient_summary,s_note_danger_sign7}'::text[]           AS s_note_danger_sign7,
      doc #>> '{fields,group_patient_summary,s_note_danger_sign8}'::text[]           AS s_note_danger_sign8,
      doc #>> '{fields,group_patient_summary,s_note_danger_sign9}'::text[]           AS s_note_danger_sign9,
      doc #>> '{fields,group_patient_summary,s_note_danger_sign10}'::text[]          AS s_note_danger_sign10,
      doc #>> '{fields,group_patient_summary,s_note_danger_sign11}'::text[]          AS s_note_danger_sign11,
      doc #>> '{fields,group_patient_summary,s_note_how_is_child0}'::text[]          AS s_note_how_is_child0,
      doc #>> '{fields,group_patient_summary,s_note_how_is_child1}'::text[]          AS s_note_how_is_child1,
      doc #>> '{fields,group_patient_summary,s_note_how_is_child2}'::text[]          AS s_note_how_is_child2,
      doc #>> '{fields,group_patient_summary,s_note_referral}'::text[]               AS s_note_referral,
      doc #>> '{fields,group_patient_summary,s_note_followup}'::text[]               AS s_note_followup,
      doc #>> '{fields,group_patient_summary,s_note_followup_task}'::text[]          AS s_note_followup_task,

     --- reporting hierarchy
      doc #>> '{contact,_id}'                         AS chw_id,                   
      doc #>> '{contact,parent,_id}'                  AS chw_area_id,  
      doc #>> '{contact,parent,parent,_id}'           AS facility_id,                                    
      doc #>> '{contact,parent,parent,parent,_id}'    AS parish_id,              
      doc #>> '{contact,parent,parent,parent,parent,_id}'           AS district, 
      doc #>> '{contact,parent,parent,parent,parent,parent,_id}'           AS region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date                 


FROM dwh.cht_data
WHERE (doc ->> 'form') = 'treatment_follow_up'
  AND is_current
WITH DATA;


CREATE INDEX treatment_follow_up_reported_idx_new
    ON cht.mv_treatment_follow_up_new USING btree (reported);
