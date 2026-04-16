-- cht.mv_sdx_trigger source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_sdx_trigger;
CREATE MATERIALIZED VIEW cht.mv_sdx_trigger
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
    doc #>> '{fields,inputs,contact,vht_id}'::text[] AS inputs_contact_vht_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,patient_name}'::text[] AS patient_name,
    doc #>> '{fields,child_name}'::text[] AS child_name,
    doc #>> '{fields,hoh_name}'::text[] AS hoh_name,
    doc #>> '{fields,hoh_phone}'::text[] AS hoh_phone,
    doc #>> '{fields,child_age}'::text[] AS child_age,
    doc #>> '{fields,child_dob}'::text[] AS child_dob,
    doc #>> '{fields,child_sex}'::text[] AS child_sex,
    doc #>> '{fields,location}'::text[] AS location,
    doc #>> '{fields,risk_cat}'::text[] AS risk_cat,
    doc #>> '{fields,num_followups}'::text[] AS num_followups,
    doc #>> '{fields,discharge_facility}'::text[] AS discharge_facility,
    doc #>> '{fields,discharge_ts}'::text[] AS discharge_ts,
    doc #>> '{fields,fu_date_1}'::text[] AS fu_date_1,
    doc #>> '{fields,fu_date_2}'::text[] AS fu_date_2,
    doc #>> '{fields,fu_date_3}'::text[] AS fu_date_3,
    doc #>> '{fields,diagnosis}'::text[] AS diagnosis,
    doc #>> '{fields,sdx_id}'::text[] AS sdx_id,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility_name,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
FROM dwh.cht_data d
LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id 
  WHERE (doc ->> 'form'::text) = 'sdx_trigger'::text AND is_current
WITH DATA;

-- View indexes:
CREATE INDEX mv_sdx_trigger_chw_id ON cht.mv_sdx_trigger USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX mv_sdx_trigger_reported ON cht.mv_sdx_trigger USING btree (reported) tablespace ts_indexes;
CREATE INDEX mv_sdx_trigger_date ON cht.mv_sdx_trigger USING btree (date) tablespace ts_indexes;
CREATE INDEX mv_sdx_trigger_year ON cht.mv_sdx_trigger USING btree (year) tablespace ts_indexes;
CREATE INDEX mv_sdx_trigger_month ON cht.mv_sdx_trigger USING btree (month) tablespace ts_indexes;
CREATE INDEX mv_sdx_trigger_monthname ON cht.mv_sdx_trigger USING btree (monthname) tablespace ts_indexes;
CREATE INDEX mv_sdx_trigger_district ON cht.mv_sdx_trigger USING btree (district) tablespace ts_indexes;
CREATE INDEX mv_sdx_trigger_region ON cht.mv_sdx_trigger USING btree (region) tablespace ts_indexes;
CREATE INDEX mv_sdx_trigger_village ON cht.mv_sdx_trigger USING btree (village) tablespace ts_indexes;
CREATE INDEX mv_sdx_trigger_facility_name ON cht.mv_sdx_trigger USING btree (facility_name) tablespace ts_indexes;
CREATE INDEX mv_sdx_trigger_dhis2_facility_id ON cht.mv_sdx_trigger USING btree (dhis2_facility_id) tablespace ts_indexes;