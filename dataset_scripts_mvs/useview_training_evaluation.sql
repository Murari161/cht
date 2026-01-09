CREATE MATERIALIZED VIEW report.useview_training_evaluation
TABLESPACE ts_report
AS
SELECT
      doc ->> '_id'                                                AS uuid,
      doc ->> '_rev'                                               AS rev,
      doc ->> 'form'                                               AS form,
      to_timestamp(NULLIF(doc ->> 'reported_date','')::bigint / 1000.0) AS reported,
      doc ->> 'from'                                               AS submitter,
      doc ->> 'content_type'                                       AS top_content_type,
      to_timestamp(NULLIF(doc #>> '{form_version,time}','')::bigint / 1000.0) AS form_version_time,
      doc #>> '{form_version,sha256}'                              AS form_version_sha256,
      (doc -> 'hidden_fields')::text                               AS hidden_fields_json,
    , doc #>> '{fields,inputs,source}'                                    AS source,
    , doc #>> '{fields,inputs,source_id}'                                 AS source_id,
    , doc #>> '{fields,inputs,contact,_id}'                               AS _id,
    , doc #>> '{fields,inputs,contact,name}'                              AS name,
    , doc #>> '{fields,form_for_child_in_household_score}'                AS form_for_child_in_household_score,
    , doc #>> '{fields,option_for_reminder_score}'                        AS option_for_reminder_score,
    , doc #>> '{fields,form_available_to_all_score}'                      AS form_available_to_all_score,
    , doc #>> '{fields,who_is_responsible_for_hh_registration_score}'     AS who_is_responsible_for_hh_registration_score,
    , doc #>> '{fields,true_false_score}'                                 AS true_false_score,
    , doc #>> '{fields,tab_for_graphical_representation_score}'           AS tab_for_graphical_representation_score,
    , doc #>> '{fields,menu_for_reporting_issues_score}'                  AS menu_for_reporting_issues_score,
    , doc #>> '{fields,option_facilitates_data_upload_score}'             AS option_facilitates_data_upload_score,
    , doc #>> '{fields,form_for_collecting_symptoms_score}'               AS form_for_collecting_symptoms_score,
    , doc #>> '{fields,option_for_completing_form_score}'                 AS option_for_completing_form_score,
    , doc #>> '{fields,your_score}'                                       AS your_score,
    , doc #>> '{fields,group_test_questions,trainee_name}'                AS trainee_name,
    , doc #>> '{fields,group_test_questions,phone_number}'                AS phone_number,
    , doc #>> '{fields,group_test_questions,form_for_child_in_household}'  AS form_for_child_in_household,
    , doc #>> '{fields,group_test_questions,option_for_reminder}'         AS option_for_reminder,
    , doc #>> '{fields,group_test_questions,form_available_to_all}'       AS form_available_to_all,
    , doc #>> '{fields,group_test_questions,who_is_responsible_for_hh_registration}'  AS who_is_responsible_for_hh_registration,
    , doc #>> '{fields,group_test_questions,true_false}'                  AS true_false,
    , doc #>> '{fields,group_test_questions,tab_for_graphical_representation}'  AS tab_for_graphical_representation,
    , doc #>> '{fields,group_test_questions,menu_for_reporting_issues}'   AS menu_for_reporting_issues,
    , doc #>> '{fields,group_test_questions,option_facilitates_data_upload}'  AS option_facilitates_data_upload,
    , doc #>> '{fields,group_test_questions,form_for_collecting_symptoms}'  AS form_for_collecting_symptoms,
    , doc #>> '{fields,group_test_questions,option_for_completing_form}'  AS option_for_completing_form
FROM dwh.cht_data AS couchdb
WHERE (doc ->> 'form') = 'training_evaluation'
  AND is_current
WITH DATA;

CREATE UNIQUE INDEX training_evaluation_uuid_idx
    ON report.useview_training_evaluation USING btree (uuid);

CREATE INDEX training_evaluation_reported_idx
    ON report.useview_training_evaluation USING btree (reported);
