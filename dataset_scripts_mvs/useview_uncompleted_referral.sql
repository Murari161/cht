CREATE MATERIALIZED VIEW report.useview_uncompleted_referral
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
    , doc #>> '{fields,inputs,t_place_name}'                              AS t_place_name,
    , doc #>> '{fields,inputs,t_vht_name}'                                AS t_vht_name,
    , doc #>> '{fields,inputs,t_vht_phone}'                               AS t_vht_phone,
    , doc #>> '{fields,inputs,t_no_anc_danger_sign_follow_up}'            AS t_no_anc_danger_sign_follow_up,
    , doc #>> '{fields,inputs,t_no_newborn_danger_sign_follow_up}'        AS t_no_newborn_danger_sign_follow_up,
    , doc #>> '{fields,inputs,t_no_referral_follow_up}'                   AS t_no_referral_follow_up,
    , doc #>> '{fields,inputs,t_patient_name}'                            AS t_patient_name,
    , doc #>> '{fields,inputs,t_patient_gender}'                          AS t_patient_gender,
    , doc #>> '{fields,inputs,t_patient_date_of_birth}'                   AS t_patient_date_of_birth,
    , doc #>> '{fields,inputs,t_patient_id}'                              AS t_patient_id,
    , doc #>> '{fields,inputs,user,contact_id}'                           AS contact_id,
    , doc #>> '{fields,inputs,user,facility_id}'                          AS facility_id,
    , doc #>> '{fields,inputs,contact,_id}'                               AS chw_id,
    , doc #>> '{fields,inputs,contact,name}'                              AS chw_name,
    , doc #>> '{fields,inputs,contact,date_of_birth}'                     AS date_of_birth,
    , doc #>> '{fields,inputs,contact,sex}'                               AS sex,
    , doc #>> '{fields,dob}'                                              AS dob,
    , doc #>> '{fields,patient_age_in_years}'                             AS patient_age_in_years,
    , doc #>> '{fields,patient_age_in_months}'                            AS patient_age_in_months,
    , doc #>> '{fields,patient_age_in_days}'                              AS patient_age_in_days,
    , doc #>> '{fields,patient_age_display}'                              AS patient_age_display,
    , doc #>> '{fields,patient_id}'                                       AS patient_id,
    , doc #>> '{fields,patient_name}'                                     AS patient_name,
    , doc #>> '{fields,patient_gender}'                                   AS patient_gender,
    , doc #>> '{fields,needs_signoff}'                                    AS needs_signoff,
    , doc #>> '{fields,referral_details,refer_to_health_facility}'        AS refer_to_health_facility
FROM dwh.cht_data AS couchdb
WHERE (doc ->> 'form') = 'uncompleted_referral'
  AND is_current
WITH DATA;

CREATE UNIQUE INDEX uncompleted_referral_uuid_idx
    ON report.useview_uncompleted_referral USING btree (uuid);

CREATE INDEX uncompleted_referral_reported_idx
    ON report.useview_uncompleted_referral USING btree (reported);
