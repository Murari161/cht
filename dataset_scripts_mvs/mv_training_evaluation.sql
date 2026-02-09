CREATE MATERIALIZED VIEW cht.mv_training_evaluation
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
      
      doc #>> '{fields,inputs,source}'::text[]                                  AS source,
      doc #>> '{fields,inputs,source_id}'::text[]                               AS source_id,
      doc #>> '{fields,inputs,contact,_id}'::text[]                             AS contact_id,
      doc #>> '{fields,inputs,contact,name}'::text[]                            AS contact_name,
      doc #>> '{fields,form_for_child_in_household_score}'::text[]              AS form_for_child_in_household_score,
      doc #>> '{fields,option_for_reminder_score}'::text[]                       AS option_for_reminder_score,
      doc #>> '{fields,form_available_to_all_score}'::text[]                     AS form_available_to_all_score,
      doc #>> '{fields,who_is_responsible_for_hh_registration_score}'::text[]    AS responsible_for_hh_registration_score,
      doc #>> '{fields,true_false_score}'::text[]                                 AS true_false_score,
      doc #>> '{fields,tab_for_graphical_representation_score}'::text[]          AS tab_for_graphical_representation_score,
      doc #>> '{fields,menu_for_reporting_issues_score}'::text[]                 AS menu_for_reporting_issues_score,
      doc #>> '{fields,option_facilitates_data_upload_score}'::text[]            AS option_facilitates_data_upload_score,
      doc #>> '{fields,form_for_collecting_symptoms_score}'::text[]              AS form_for_collecting_symptoms_score,
      doc #>> '{fields,option_for_completing_form_score}'::text[]                AS option_for_completing_form_score,
      doc #>> '{fields,your_score}'::text[]                                       AS your_score,
      doc #>> '{fields,group_test_questions,trainee_name}'::text[]                          AS trainee_name,
      doc #>> '{fields,group_test_questions,phone_number}'::text[]                          AS trainee_phone_number,
      doc #>> '{fields,group_test_questions,note_instructions}'::text[]                      AS note_instructions,
      doc #>> '{fields,group_test_questions,form_for_child_in_household}'::text[]            AS form_for_child_in_household,
      doc #>> '{fields,group_test_questions,option_for_reminder}'::text[]                    AS option_for_reminder,
      doc #>> '{fields,group_test_questions,form_available_to_all}'::text[]                  AS form_available_to_all,
      doc #>> '{fields,group_test_questions,who_is_responsible_for_hh_registration}'::text[] AS responsible_for_hh_registration,
      doc #>> '{fields,group_test_questions,true_false}'::text[]                               AS true_false,
      doc #>> '{fields,group_test_questions,tab_for_graphical_representation}'::text[]        AS tab_for_graphical_representation,
      doc #>> '{fields,group_test_questions,menu_for_reporting_issues}'::text[]               AS menu_for_reporting_issues,
      doc #>> '{fields,group_test_questions,option_facilitates_data_upload}'::text[]          AS option_facilitates_data_upload,
      doc #>> '{fields,group_test_questions,form_for_collecting_symptoms}'::text[]            AS form_for_collecting_symptoms,
      doc #>> '{fields,group_test_questions,option_for_completing_form}'::text[]              AS option_for_completing_form,
      doc #>> '{fields,group_patient_summary,s_note_before_submit}'::text[]  AS s_note_before_submit,
      doc #>> '{fields,group_patient_summary,s_note_score_red}'::text[]      AS s_note_score_red,
      doc #>> '{fields,group_patient_summary,s_note_score_green}'::text[]    AS s_note_score_green,
      doc #>> '{fields,group_patient_summary,s_your_score}'::text[]          AS s_your_score,
   
      --- reporting hierarchy
      doc #>> '{contact,_id}'                         AS chw_id,                   
      doc #>> '{contact,parent,_id}'                  AS chw_area_id,  
      doc #>> '{contact,parent,parent,_id}'           AS facility_id,                                    
      doc #>> '{contact,parent,parent,parent,_id}'    AS parish_id,              
      doc #>> '{contact,parent,parent,parent,parent,_id}'           AS disrict, 
      doc #>> '{contact,parent,parent,parent,parent,parent,_id}'           AS region,
      CURRENT_TIMESTAMP as last_refresh_date;              


FROM dwh.cht_data
WHERE (doc ->> 'form') = 'training_evaluation'
  AND is_current
WITH DATA;

CREATE INDEX training_evaluation_reported_idx
    ON cht.mv_training_evaluation USING btree (reported);
