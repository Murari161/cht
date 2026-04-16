-- cht.mv_training_evaluation source
DROP MATERIALIZED VIEW cht.mv_training_evaluation;
CREATE MATERIALIZED VIEW cht.mv_training_evaluation
TABLESPACE ts_report
AS SELECT doc ->> '_id'::text AS doc_id,
    doc ->> '_rev'::text AS rev,
    to_timestamp((NULLIF(doc ->> 'reported_date'::text, ''::text)::bigint / 1000)::double precision) AS reported,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY-MM-DD'))::date AS date,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY'))::INT AS year,
    to_char(to_timestamp((((doc ->>'reported_date'::text)::bigint) / 1000)::double precision), 'MM'::text)::integer AS month,
    TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'FMMonth') AS monthname,
    ((doc -> 'fields'::text) -> 'meta'::text) ->> 'instanceID'::text AS instanceid,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) ->> 'deprecatedID'::text AS deprecatedid,
    ((((doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) -> 'location'::text) ->> 'lat'::text AS location_lat,
    ((((doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) -> 'location'::text) ->> 'long'::text AS location_long,
    ((((doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) -> 'location'::text) ->> 'error'::text AS location_error,
    ((((doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) -> 'location'::text) ->> 'message'::text AS location_message,
    (doc -> 'geolocation'::text) ->> 'code'::text AS geolocation_code,
    (doc -> 'geolocation'::text) ->> 'message'::text AS geolocation_message,
    doc ->> 'form'::text AS form,
    doc ->> 'from'::text AS "from",
    doc #>> '{fields,inputs,source}'::text[] AS source,
    doc #>> '{fields,inputs,source_id}'::text[] AS source_id,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    doc #>> '{fields,form_for_child_in_household_score}'::text[] AS form_for_child_in_household_score,
    doc #>> '{fields,option_for_reminder_score}'::text[] AS option_for_reminder_score,
    doc #>> '{fields,form_available_to_all_score}'::text[] AS form_available_to_all_score,
    doc #>> '{fields,who_is_responsible_for_hh_registration_score}'::text[] AS responsible_for_hh_registration_score,
    doc #>> '{fields,true_false_score}'::text[] AS true_false_score,
    doc #>> '{fields,tab_for_graphical_representation_score}'::text[] AS tab_for_graphical_representation_score,
    doc #>> '{fields,menu_for_reporting_issues_score}'::text[] AS menu_for_reporting_issues_score,
    doc #>> '{fields,option_facilitates_data_upload_score}'::text[] AS option_facilitates_data_upload_score,
    doc #>> '{fields,form_for_collecting_symptoms_score}'::text[] AS form_for_collecting_symptoms_score,
    doc #>> '{fields,option_for_completing_form_score}'::text[] AS option_for_completing_form_score,
    doc #>> '{fields,your_score}'::text[] AS your_score,
    doc #>> '{fields,group_test_questions,trainee_name}'::text[] AS trainee_name,
    doc #>> '{fields,group_test_questions,phone_number}'::text[] AS trainee_phone_number,
    doc #>> '{fields,group_test_questions,note_instructions}'::text[] AS note_instructions,
    doc #>> '{fields,group_test_questions,form_for_child_in_household}'::text[] AS form_for_child_in_household,
    doc #>> '{fields,group_test_questions,option_for_reminder}'::text[] AS option_for_reminder,
    doc #>> '{fields,group_test_questions,form_available_to_all}'::text[] AS form_available_to_all,
    doc #>> '{fields,group_test_questions,who_is_responsible_for_hh_registration}'::text[] AS responsible_for_hh_registration,
    doc #>> '{fields,group_test_questions,true_false}'::text[] AS true_false,
    doc #>> '{fields,group_test_questions,tab_for_graphical_representation}'::text[] AS tab_for_graphical_representation,
    doc #>> '{fields,group_test_questions,menu_for_reporting_issues}'::text[] AS menu_for_reporting_issues,
    doc #>> '{fields,group_test_questions,option_facilitates_data_upload}'::text[] AS option_facilitates_data_upload,
    doc #>> '{fields,group_test_questions,form_for_collecting_symptoms}'::text[] AS form_for_collecting_symptoms,
    doc #>> '{fields,group_test_questions,option_for_completing_form}'::text[] AS option_for_completing_form,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility_name,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
FROM dwh.cht_data d LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id 
  WHERE (doc ->> 'form'::text) = 'training_evaluation'::text AND is_current
WITH DATA;

-- View indexes:
CREATE INDEX training_evaluation_reported_idx ON cht.mv_training_evaluation USING btree (reported) tablespace ts_indexes;
CREATE INDEX training_evaluation_date_idx ON cht.mv_training_evaluation USING btree (date) tablespace ts_indexes;
CREATE INDEX training_evaluation_year_idx ON cht.mv_training_evaluation USING btree (year) tablespace ts_indexes;
CREATE INDEX training_evaluation_month_idx ON cht.mv_training_evaluation USING btree (month) tablespace ts_indexes;
CREATE INDEX training_evaluation_monthname_idx ON cht.mv_training_evaluation USING btree (monthname) tablespace ts_indexes;
CREATE INDEX training_evaluation_district_idx ON cht.mv_training_evaluation USING btree (district) tablespace ts_indexes;
CREATE INDEX training_evaluation_region_idx ON cht.mv_training_evaluation USING btree (region) tablespace ts_indexes;
CREATE INDEX training_evaluation_chw_id_idx ON cht.mv_training_evaluation USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX training_evaluation_facility_name_idx ON cht.mv_training_evaluation USING btree (facility_name) tablespace ts_indexes;
CREATE INDEX training_evaluation_dhis2_facility_id_idx ON cht.mv_training_evaluation USING btree (dhis2_facility_id) tablespace ts_indexes;
CREATE INDEX training_evaluation_village_idx ON cht.mv_training_evaluation USING btree (village) tablespace ts_indexes;
CREATE INDEX training_evaluation_last_refresh_date_idx ON cht.mv_training_evaluation USING btree (last_refresh_date) tablespace ts_indexes;                                                     