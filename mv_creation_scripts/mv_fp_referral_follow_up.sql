-- cht.mv_fp_referral_follow_up source
Drop materialized view cht.mv_fp_referral_follow_up cascade;
CREATE MATERIALIZED VIEW cht.mv_fp_referral_follow_up
TABLESPACE ts_report
AS SELECT doc ->> '_id'::text AS uuid,
    doc ->> 'form'::text AS form,
    doc ->> 'from'::text AS submitter,
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
    doc #>> '{fields,inputs,source}'::text[] AS inputs_source,
    doc #>> '{fields,inputs,source_id}'::text[] AS inputs_source_id,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    doc #>> '{fields,inputs,contact,patient_id}'::text[] AS inputs_contact_patient_id,
    doc #>> '{fields,inputs,contact,date_of_birth}'::text[] AS inputs_contact_date_of_birth,
    doc #>> '{fields,inputs,contact,sex}'::text[] AS inputs_contact_sex,
    doc #>> '{fields,inputs,contact,parent,parent,contact,name}'::text[] AS inputs_parent_contact_name,
    doc #>> '{fields,inputs,contact,parent,parent,contact,phone}'::text[] AS inputs_parent_contact_phone,
    doc #>> '{fields,source_input}'::text[] AS source_input,
    doc #>> '{fields,source_id_input}'::text[] AS source_id_input,
    doc #>> '{fields,patient_uuid}'::text[] AS patient_uuid,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,patient_name}'::text[] AS patient_name,
    doc #>> '{fields,patient_date_of_birth}'::text[] AS patient_date_of_birth,
    doc #>> '{fields,patient_age_in_years}'::text[] AS patient_age_in_years,
    doc #>> '{fields,age}'::text[] AS age,
    doc #>> '{fields,date_of_birth}'::text[] AS date_of_birth,
    doc #>> '{fields,chw_name}'::text[] AS chw_name,
    doc #>> '{fields,chw_phone}'::text[] AS chw_phone,
    doc #>> '{fields,fp_ref_follow_up,visited_facility}'::text[] AS visited_facility,
    doc #>> '{fields,fp_ref_follow_up,enrolled_fp}'::text[] AS enrolled_fp,
    doc #>> '{fields,fp_ref_follow_up,n_fp_registration}'::text[] AS n_fp_registration,
    doc #>> '{fields,fp_ref_follow_up,reason_not_enrolled_fp}'::text[] AS reason_not_enrolled_fp,
    doc #>> '{fields,fp_ref_follow_up,n_pregnancy_registration}'::text[] AS n_pregnancy_registration,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date 
   FROM dwh.cht_data couchdb
LEFT JOIN cht.mv_chw_hierarchy h ON (couchdb.doc #>> '{contact,_id}') = h.chw_id
  WHERE (doc ->> 'form'::text) = 'fp_referral_follow_up'::text AND is_current
WITH DATA;

CREATE INDEX idx_mv_fp_referral_follow_up_uuid ON cht.mv_fp_referral_follow_up (uuid) tablespace ts_indexes;
CREATE INDEX idx_mv_fp_referral_follow_up_chw_id ON cht.mv_fp_referral_follow_up (chw_id) tablespace ts_indexes;
CREATE INDEX idx_mv_fp_referral_follow_up_year_month ON cht.mv_fp_referral_follow_up (year, month) tablespace ts_indexes;
CREATE INDEX idx_mv_fp_referral_follow_up_date ON cht.mv_fp_referral_follow_up (date) tablespace ts_indexes;
CREATE INDEX idx_mv_fp_referral_follow_up_reported ON cht.mv_fp_referral_follow_up (reported) tablespace ts_indexes;
CREATE INDEX idx_mv_fp_referral_follow_up_facility ON cht.mv_fp_referral_follow_up (facility) tablespace ts_indexes;
CREATE INDEX idx_mv_fp_referral_follow_up_dhis2_facility_id ON cht.mv_fp_referral_follow_up (dhis2_facility_id) tablespace ts_indexes;
CREATE INDEX idx_mv_fp_referral_follow_up_district ON cht.mv_fp_referral_follow_up (district) tablespace ts_indexes;
CREATE INDEX idx_mv_fp_referral_follow_up_region ON cht.mv_fp_referral_follow_up (region) tablespace ts_indexes; 