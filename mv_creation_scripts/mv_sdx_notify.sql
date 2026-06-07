-- cht.mv_sdx_notify source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_sdx_notify;
CREATE MATERIALIZED VIEW cht.mv_sdx_notify
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
    (NULLIF((doc -> 'geolocation'::text) ->> 'latitude'::text, ''::text))::double precision AS geolocation_latitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'longitude'::text, ''::text))::double precision AS geolocation_longitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'accuracy'::text, ''::text))::double precision AS geolocation_accuracy,
    (NULLIF((doc -> 'geolocation'::text) ->> 'altitude'::text, ''::text))::double precision AS geolocation_altitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'altitudeAccuracy'::text, ''::text))::double precision AS geolocation_altitude_accuracy,
    (NULLIF((doc -> 'geolocation'::text) ->> 'speed'::text, ''::text))::double precision AS geolocation_speed,
    (NULLIF((doc -> 'geolocation'::text) ->> 'heading'::text, ''::text))::double precision AS geolocation_heading,
    doc #>> '{fields,inputs,source}'::text[] AS source,
    doc #>> '{fields,inputs,source_id}'::text[] AS source_id,
    doc #>> '{fields,inputs,vht_id}'::text[] AS vht_id,
    doc #>> '{fields,inputs,vht_name}'::text[] AS vht_name,
    doc #>> '{fields,inputs,child_name}'::text[] AS child_name,
    doc #>> '{fields,inputs,hoh_name}'::text[] AS hoh_name,
    doc #>> '{fields,inputs,hoh_phone}'::text[] AS hoh_phone,
    doc #>> '{fields,inputs,child_dob}'::text[] AS child_dob,
    doc #>> '{fields,inputs,child_age}'::text[] AS child_age,
    doc #>> '{fields,inputs,child_sex}'::text[] AS child_sex,
    doc #>> '{fields,inputs,location}'::text[] AS location,
    doc #>> '{fields,inputs,risk_cat}'::text[] AS risk_cat,
    doc #>> '{fields,inputs,num_followups}'::text[] AS num_followups,
    doc #>> '{fields,inputs,discharge_facility}'::text[] AS discharge_facility,
    doc #>> '{fields,inputs,discharge_ts}'::text[] AS discharge_ts,
    doc #>> '{fields,inputs,fu_date_1}'::text[] AS fu_date_1,
    doc #>> '{fields,inputs,fu_date_2}'::text[] AS fu_date_2,
    doc #>> '{fields,inputs,fu_date_3}'::text[] AS fu_date_3,
    doc #>> '{fields,inputs,diagnosis}'::text[] AS diagnosis,
    doc #>> '{fields,inputs,sdx_id}'::text[] AS sdx_id,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS contact_id,
    doc #>> '{fields,inputs,contact,patient_id}'::text[] AS contact_patient_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS contact_name,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,patient_name}'::text[] AS patient_name,
    doc #>> '{fields,notification,header}'::text[] AS n_header,
    doc #>> '{fields,notification,intro}'::text[] AS n_intro,
    doc #>> '{fields,notification,name}'::text[] AS n_name,
    doc #>> '{fields,notification,_id}'::text[] AS n_id,
    doc #>> '{fields,notification,info_header}'::text[] AS n_info_header,
    doc #>> '{fields,notification,info_name}'::text[] AS n_info_name,
    doc #>> '{fields,notification,info_dob}'::text[] AS n_info_dob,
    doc #>> '{fields,notification,info_location}'::text[] AS n_info_location,
    doc #>> '{fields,notification,info_hoh_name}'::text[] AS n_info_hoh_name,
    doc #>> '{fields,notification,info_hoh_phone}'::text[] AS n_info_hoh_phone,
    doc #>> '{fields,notification,info_disch_fac}'::text[] AS n_info_disch_fac,
    doc #>> '{fields,notification,info_diagnosis}'::text[] AS n_info_diagnosis,
    doc #>> '{fields,notification,info_fu_date_1}'::text[] AS n_info_fu_date_1,
    doc #>> '{fields,notification,info_fu_date_2}'::text[] AS n_info_fu_date_2,
    doc #>> '{fields,notification,info_fu_date_3}'::text[] AS n_info_fu_date_3,
    doc #>> '{fields,notification,info_sdx_id}'::text[] AS n_info_sdx_id,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
FROM dwh.cht_data d
LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id
  WHERE (doc ->> 'form'::text) = 'sdx_notify'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX mv_sdx_notify_chw_id ON cht.mv_sdx_notify USING btree (chw_id) TABLESPACE ts_indexes;
CREATE INDEX mv_sdx_notify_reported ON cht.mv_sdx_notify USING btree (reported) TABLESPACE ts_indexes;
CREATE INDEX mv_sdx_notify_date ON cht.mv_sdx_notify USING btree (date) TABLESPACE ts_indexes;
CREATE INDEX mv_sdx_notify_monthname ON cht.mv_sdx_notify USING btree (monthname) TABLESPACE ts_indexes;
CREATE INDEX mv_sdx_notify_year_month_district ON cht.mv_sdx_notify USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX mv_sdx_notify_district ON cht.mv_sdx_notify USING btree (district) TABLESPACE ts_indexes;
CREATE INDEX mv_sdx_notify_region ON cht.mv_sdx_notify USING btree (region) TABLESPACE ts_indexes;
CREATE INDEX mv_sdx_notify_village ON cht.mv_sdx_notify USING btree (village) TABLESPACE ts_indexes;
CREATE INDEX mv_sdx_notify_facility ON cht.mv_sdx_notify USING btree (facility) TABLESPACE ts_indexes;
CREATE INDEX mv_sdx_notify_dhis2_facility_id ON cht.mv_sdx_notify USING btree (dhis2_facility_id) TABLESPACE ts_indexes;