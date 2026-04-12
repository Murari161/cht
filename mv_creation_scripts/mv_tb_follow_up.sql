CREATE MATERIALIZED VIEW cht.mv_tb_follow_up
TABLESPACE ts_report
AS
SELECT
    doc ->> '_id'                                                AS doc_id,
    doc ->> '_rev'                                               AS rev,
    to_timestamp(NULLIF(doc ->> 'reported_date','')::bigint / 1000.0) AS reported,
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
    doc ->> 'from'                                          AS from,                             -- [NEW FIELD]

  doc #>> '{fields,inputs,source}'                                    AS source,
     doc #>> '{fields,inputs,source_id}'                                 AS source_id,
     doc #>> '{fields,inputs,treatmentStartDate}'                        AS treatmentstartdate,
     doc #>> '{fields,inputs,user,contact_id}'                           AS contact_id,
     doc #>> '{fields,inputs,user,facility_id}'                          AS facility_id,
     doc #>> '{fields,inputs,contact,_id}'                               AS _id,
     doc #>> '{fields,inputs,contact,name}'                              AS name,
     doc #>> '{fields,inputs,contact,date_of_birth}'                     AS date_of_birth,
     doc #>> '{fields,inputs,contact,sex}'                               AS sex,
     doc #>> '{fields,inputs,contact,phone}'                             AS phone,
     doc #>> '{fields,inputs,contact,phone2}'                            AS phone2,
     doc #>> '{fields,inputs,contact,client_category}'                   AS client_category,
     doc #>> '{fields,inputs,contact,parent,_id}'                        AS parent__id,
     doc #>> '{fields,inputs,contact,parent,name}'                       AS parent_name,
     doc #>> '{fields,inputs,contact,parent,parent,_id}'                 AS parent_parent__id,
     doc #>> '{fields,inputs,contact,parent,parent,name}'                AS parent_parent_name,
     doc #>> '{fields,inputs,contact,parent,parent,supervisor}'          AS supervisor,
     doc #>> '{fields,inputs,contact,parent,parent,phone}'               AS parent_phone,
     doc #>> '{fields,inputs,contact,parent,parent,contact,_id}'         AS contact__id,
     doc #>> '{fields,inputs,contact,parent,parent,contact,phone}'       AS contact_phone,
     doc #>> '{fields,inputs,contact,parent,parent,contact,name}'        AS contact_name,
     doc #>> '{fields,inputs,contact,parent,parent,parent,_id}'          AS parent_parent_parent__id,
     doc #>> '{fields,patient_age_in_years}'                             AS patient_age_in_years,
     doc #>> '{fields,patient_age_in_months}'                            AS patient_age_in_months,
     doc #>> '{fields,patient_age_in_days}'                              AS patient_age_in_days,
     doc #>> '{fields,patient_age_display}'                              AS patient_age_display,
     doc #>> '{fields,patient_id}'                                       AS patient_id,
     doc #>> '{fields,patient_name}'                                     AS patient_name,
     doc #>> '{fields,patient_gender}'                                   AS patient_gender,
     doc #>> '{fields,patient_pronoun}'                                  AS patient_pronoun,
     doc #>> '{fields,patient_phone}'                                    AS patient_phone,
     doc #>> '{fields,tb_treatment_start_date}'                          AS tb_treatment_start_date,
     doc #>> '{fields,start_date}'                                       AS start_date,
     doc #>> '{fields,tb_adherence,taking_tb_drugs}'                     AS taking_tb_drugs,
     doc #>> '{fields,tb_adherence,attending_scheduled_clinic_visits}'   AS attending_scheduled_clinic_visits,
     doc #>> '{fields,tb_test_reminder,has_exited_tb_program}'           AS has_exited_tb_program,
    CURRENT_TIMESTAMP AS last_refresh_date
FROM dwh.cht_data
WHERE (doc ->> 'form') = 'tb_follow_up'
  AND is_current
WITH DATA;


CREATE INDEX tb_follow_up_reported_idx
    ON cht.mv_tb_follow_up USING btree (reported);
