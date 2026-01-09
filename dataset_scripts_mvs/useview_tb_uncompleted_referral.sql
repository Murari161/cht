CREATE MATERIALIZED VIEW report.useview_tb_uncompleted_referral
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
    , doc #>> '{fields,inputs,t_tb_result}'                               AS t_tb_result,
    , doc #>> '{fields,inputs,t_place_name}'                              AS t_place_name,
    , doc #>> '{fields,inputs,t_patient_name}'                            AS t_patient_name,
    , doc #>> '{fields,inputs,user,contact_id}'                           AS contact_id,
    , doc #>> '{fields,inputs,user,facility_id}'                          AS facility_id,
    , doc #>> '{fields,inputs,contact,_id}'                               AS _id,
    , doc #>> '{fields,inputs,contact,name}'                              AS name,
    , doc #>> '{fields,inputs,contact,date_of_birth}'                     AS date_of_birth,
    , doc #>> '{fields,inputs,contact,sex}'                               AS sex,
    , doc #>> '{fields,patient_id}'                                       AS patient_id,
    , doc #>> '{fields,patient_name}'                                     AS patient_name,
    , doc #>> '{fields,tb_result}'                                        AS tb_result,
    , doc #>> '{fields,place_name}'                                       AS place_name,
    , doc #>> '{fields,needs_signoff}'                                    AS needs_signoff,
    , doc #>> '{fields,referral_notification,referred_to_health_facility}'  AS referred_to_health_facility
FROM dwh.cht_data AS couchdb
WHERE (doc ->> 'form') = 'tb_uncompleted_referral'
  AND is_current
WITH DATA;

CREATE UNIQUE INDEX tb_uncompleted_referral_uuid_idx
    ON report.useview_tb_uncompleted_referral USING btree (uuid);

CREATE INDEX tb_uncompleted_referral_reported_idx
    ON report.useview_tb_uncompleted_referral USING btree (reported);
