--SELECT deps_save_and_drop_dependencies('public', 'useview_ai_image_assessment');
DROP MATERIALIZED VIEW IF EXISTS cht.mv_useview_ai_image_assessment;
CREATE MATERIALIZED VIEW IF NOT EXISTS cht.mv_useview_ai_image_assessment TABLESPACE ts_report AS
SELECT
  doc ->> '_id'::TEXT AS uuid,
  doc #>> '{contact,_id}'::TEXT[] AS chw,
  to_timestamp((nullif(doc ->> 'reported_date'::TEXT, ''::TEXT)::BIGINT / 1000)::DOUBLE PRECISION) AS reported,
  (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY-MM-DD'))::date AS date,
  (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY'))::INT AS year,
  (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'MM'))::INT AS month,
    TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'FMMonth') AS monthname,
  doc #>> '{contact,_id}'::TEXT[] AS reported_by,
  doc #>> '{contact,parent,_id}'::TEXT[] AS reported_by_parent,
  doc #>> '{fields,inputs,meta,location,lat}' AS location_lat,
  doc #>> '{fields,inputs,meta,location,long}' AS location_long,
  doc #>> '{fields,inputs,meta,location,error}' AS location_error,
  doc #>> '{fields,inputs,meta,location,message}' AS location_message,
  doc #>> '{fields,inputs,source}' AS inputs_source,
  doc #>> '{fields,inputs,source_id}' AS inputs_source_id,
  doc #>> '{fields,inputs,contact,_id}' AS contact_id,
  doc #>> '{fields,inputs,contact,sex}' AS contact_sex,
  doc #>> '{fields,inputs,contact,name}' AS contact_name,
  nullif(doc #>> '{fields,inputs,contact,date_of_birth}', '')::DATE AS date_of_birth,
  --doc #>> '{fields,patient_id}' AS patient_id,
  doc #>> '{fields,inputs,contact,name}' AS inputs_patient_name,
  --doc #>> '{fields,patient_gender}' AS patient_gender,
  doc #>> '{fields,vaccines_received}'::text[] AS vaccines_received,
  doc #>> '{fields,vaccination_expected}'::text[] AS vaccination_expected,
  doc #>> '{fields,date_of_birth_local}'::text[] AS date_of_birth_local,
  doc #>> '{fields,visited_contact_uuid}'::text[] AS visited_contact_uuid,
  CASE
    WHEN (doc #>> '{fields,patient_age_in_days}'::text[]) = ''::text OR (doc #>> '{fields,patient_age_in_days}'::text[]) ~ 'NaN'::text 
      THEN 99
    ELSE (doc #>> '{fields,patient_age_in_days}'::text[])::integer
  END AS patient_age_in_days,
  CASE
    WHEN (doc #>> '{fields,patient_age_in_months}'::text[]) = ''::text OR (doc #>> '{fields,patient_age_in_months}'::text[]) ~ 'NaN'::text 
      THEN 99
    ELSE (doc #>> '{fields,patient_age_in_months}'::text[])::integer
  END AS patient_age_in_months,
  CASE
    WHEN (doc #>> '{fields,patient_age_in_years}'::text[]) = ''::text OR (doc #>> '{fields,patient_age_in_years}'::text[]) ~ 'NaN'::text 
      THEN 99
    ELSE (doc #>> '{fields,patient_age_in_years}'::text[])::integer
  END AS patient_age_in_years,
  doc #>> '{fields,patient_age_display}'::text[] AS patient_age_display,
  doc #>> '{fields,patient_id}'::text[] AS patient_id,
  doc #>> '{fields,patient_name}'::text[] AS patient_name,
  doc #>> '{fields,patient_gender}'::text[] AS patient_gender,
  doc #>> '{fields,launch_healthpulse}'::text[] AS launch_healthpulse,
  doc #>> '{fields,hide_healthpulse_section}'::text[] AS hide_healthpulse_section,
  doc #>> '{fields,show_mrdt_mismatch_note}'::text[] AS show_mrdt_mismatch_note,
  doc #>> '{fields,some_concern}'::text[] AS some_concern,
  doc #>> '{fields,should_escalate_to_chew}'::text[] AS should_escalate_to_chew,
  doc #>> '{fields,difference_in_results}'::text[] AS difference_in_results,
  doc #>> '{fields,show_malaria_screening_referral}'::text[] AS show_malaria_screening_referral,
  doc #>> '{fields,scanned_test_results}'::text[] AS scanned_test_results,
  doc #>> '{fields,captured_request_id}'::text[] AS captured_request_id,
  doc #>> '{fields,show_health_pulse_failed}'::text[] AS show_health_pulse_failed,
  doc #>> '{fields,is_mrdt_vht}'::text[] AS is_mrdt_vht,
  doc #>> '{fields,is_unblinded_mrdt_vht}'::text[] AS is_unblinded_mrdt_vht,
  doc #>> '{fields,group_vht_assessment_date,vht_assessment_date}' AS vht_assessment_date,
  doc #>> '{fields,group_fever,has_fever}'::text[] AS has_fever,
  doc #>> '{fields,group_fever,has_thermometer}'::text[] AS has_thermometer,
  doc #>> '{fields,group_fever,patient_temperature}'::text[] AS patient_temperature,
  doc #>> '{fields,group_fever,fever_duration}'::text[] AS fever_duration,
  doc #>> '{fields,group_fever,has_mrdt}'::text[] AS has_mrdt,
  doc #>> '{fields,group_fever,mrdt_usVSed_repeat}'::text[] AS mrdt_used_repeat,
  doc #>> '{fields,group_fever,mrdt_result_repeat}'::text[] AS mrdt_result_repeat,
  doc #>> '{fields,group_fever,why_mrdt_not_done_repeat}'::text[] AS why_mrdt_not_done_repeat,
  doc #>> '{fields,group_fever,want_to_repeat_mrdt}'::text[] AS want_to_repeat_mrdt,
  doc #>> '{fields,group_fever,has_mrdt_repeat_question}'::text[] AS has_mrdt_repeat_question,
  doc #>> '{fields,group_fever,mrdt_used_repeat_question}'::text[] AS mrdt_used_repeat_question,
  doc #>> '{fields,group_fever,mrdt_result_repeat_question}'::text[] AS mrdt_result_repeat_question,
  doc #>> '{fields,group_fever,why_mrdt_not_done_repeat_question}'::text[] AS why_mrdt_not_done_repeat_question,
  doc #>> '{fields,group_fever,refer_to_facililty_invalid_test}'::text[] AS refer_to_facililty_invalid_test,
  doc #>> '{fields,group_fever,photo_consent}'::text[] AS photo_consent,
  doc #>> '{fields,group_fever,mrdt_result}'::text[] AS mrdt_result,
  doc #>> '{fields,group_fever,mrdt_used}'::text[] AS mrdt_used,
  doc #>> '{fields,group_fever,why_mrdt_not_done}'::text[] AS why_mrdt_not_done,
  doc #>> '{fields,group_fever,note_mrdt_positive}'::text[] AS note_mrdt_positive,
  doc #>> '{fields,group_fever,fever_danger_sign}'::text[] AS fever_danger_sign,
  doc #>> '{fields,group_fever,mrdt_lock_state}'::text[] AS mrdt_lock_state,
  doc #>> '{fields,group_fever,locked_mrdt_result}'::text[] AS locked_mrdt_result,
  doc #>> '{fields,malaria_screening,concernsFlag}'::text[] AS concernsFlag,
  doc #>> '{fields,malaria_screening,storedConcernsFlag}'::text[] AS storedConcernsFlag,
  doc #>> '{fields,malaria_screening,storedClassification}'::text[] AS storedClassification,
  doc #>> '{fields,malaria_screening,storedImageUri}' AS storedImageUri,
  round(octet_length(doc #>> '{fields,malaria_screening,storedImageUri}')/1024.0/1024.0, 2) AS image_size_mb,
  doc #>> '{fields,malaria_screening,confirm_child_referral_mrdt_result}'::text[] AS confirm_child_referral_mrdt_result,
  doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.parish,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date 
FROM
  dwh.cht_data couchdb
  LEFT JOIN cht.mv_chw_hierarchy h ON (couchdb.doc #>> '{contact,_id}') = h.chw_id
WHERE
  doc ->> 'form' = 'assessment'
  AND is_current = true
  with data;


--SELECT deps_restore_dependencies('public', 'useview_ai_image_assessment');

/* adding indexes */
CREATE INDEX useview_ai_image_assessment_uuid ON cht.mv_useview_ai_image_assessment USING btree(uuid) TABLESPACE ts_indexes;

/* permissions */
--ALTER MATERIALIZED VIEW useview_ai_image_assessment OWNER TO vhtapp_access;
--GRANT SELECT ON useview_ai_image_assessment TO analytics;
