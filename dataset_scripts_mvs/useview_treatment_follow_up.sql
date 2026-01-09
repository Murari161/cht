CREATE MATERIALIZED VIEW report.useview_treatment_follow_up
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
    , doc #>> '{fields,inputs,latest_referral_status}'                    AS latest_referral_status,
    , doc #>> '{fields,inputs,contact,_id}'                               AS _id,
    , doc #>> '{fields,inputs,contact,name}'                              AS name,
    , doc #>> '{fields,inputs,contact,date_of_birth}'                     AS date_of_birth,
    , doc #>> '{fields,inputs,contact,sex}'                               AS sex,
    , doc #>> '{fields,inputs,contact,parent,_id}'                        AS parent__id,
    , doc #>> '{fields,inputs,contact,parent,name}'                       AS parent_name,
    , doc #>> '{fields,patient_age_in_years}'                             AS patient_age_in_years,
    , doc #>> '{fields,patient_age_in_months}'                            AS patient_age_in_months,
    , doc #>> '{fields,patient_age_in_days}'                              AS patient_age_in_days,
    , doc #>> '{fields,patient_age_display}'                              AS patient_age_display,
    , doc #>> '{fields,patient_id}'                                       AS patient_id,
    , doc #>> '{fields,patient_name}'                                     AS patient_name,
    , doc #>> '{fields,patient_gender}'                                   AS patient_gender,
    , doc #>> '{fields,referral_follow_up}'                               AS referral_follow_up,
    , doc #>> '{fields,trigger_referral_follow_up}'                       AS trigger_referral_follow_up,
    , doc #>> '{fields,group_danger_signs,follow_up_date}'                AS follow_up_date,
    , doc #>> '{fields,group_danger_signs,follow_up_method}'              AS follow_up_method,
    , doc #>> '{fields,group_danger_signs,any_danger_signs}'              AS any_danger_signs,
    , doc #>> '{fields,group_danger_signs,child_referred}'                AS child_referred,
    , doc #>> '{fields,group_follow_up,how_is_child}'                     AS how_is_child,
    , doc #>> '{fields,group_follow_up,child_referred}'                   AS group_follow_up_child_referred,
    , doc #>> '{fields,group_key_health_messages,feeding_advice}'         AS feeding_advice
FROM dwh.cht_data AS couchdb
WHERE (doc ->> 'form') = 'treatment_follow_up'
  AND is_current
WITH DATA;

CREATE UNIQUE INDEX treatment_follow_up_uuid_idx
    ON report.useview_treatment_follow_up USING btree (uuid);

CREATE INDEX treatment_follow_up_reported_idx
    ON report.useview_treatment_follow_up USING btree (reported);
