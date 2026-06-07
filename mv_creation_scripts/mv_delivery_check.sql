-- cht.mv_delivery_check source
DROP MATERIALIZED VIEW cht.mv_delivery_check;
CREATE MATERIALIZED VIEW cht.mv_delivery_check
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
    (NULLIF((doc -> 'geolocation'::text) ->> 'latitude'::text, ''::text))::double precision AS geolocation_latitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'longitude'::text, ''::text))::double precision AS geolocation_longitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'accuracy'::text, ''::text))::double precision AS geolocation_accuracy,
    (NULLIF((doc -> 'geolocation'::text) ->> 'altitude'::text, ''::text))::double precision AS geolocation_altitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'altitudeAccuracy'::text, ''::text))::double precision AS geolocation_altitude_accuracy,
    (NULLIF((doc -> 'geolocation'::text) ->> 'speed'::text, ''::text))::double precision AS geolocation_speed,
    (NULLIF((doc -> 'geolocation'::text) ->> 'heading'::text, ''::text))::double precision AS geolocation_heading,
    doc ->> 'from'::text AS "from",
    doc #>> '{fields,inputs,source}'::text[] AS source,
    doc #>> '{fields,inputs,source_id}'::text[] AS source_id,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS contact_name,
    doc #>> '{fields,inputs,contact,date_of_birth}'::text[] AS contact_date_of_birth,
    doc #>> '{fields,inputs,contact,sex}'::text[] AS contact_sex,
    doc #>> '{fields,inputs,contact,parent,_id}'::text[] AS parent_id,
    doc #>> '{fields,is_of_child_bearing_age}'::text[] AS is_of_child_bearing_age,
    doc #>> '{fields,patient_age_in_years}'::text[] AS patient_age_in_years,
    doc #>> '{fields,patient_age_in_months}'::text[] AS patient_age_in_months,
    doc #>> '{fields,patient_age_in_days}'::text[] AS patient_age_in_days,
    doc #>> '{fields,patient_age_display}'::text[] AS patient_age_display,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,patient_name}'::text[] AS patient_name,
    doc #>> '{fields,patient_gender}'::text[] AS patient_gender,
    doc #>> '{fields,group_pregnancy_status,has_delivered}'::text[] AS has_delivered,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date
   FROM dwh.cht_data
    LEFT JOIN cht.mv_chw_hierarchy h ON (dwh.cht_data.doc #>> '{contact,_id}') = h.chw_id
  WHERE (doc ->> 'form'::text) = 'delivery_check'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX delivery_reported_idx ON cht.mv_delivery_check USING btree (reported) tablespace ts_indexes;
CREATE INDEX delivery_date_idx ON cht.mv_delivery_check USING btree (date) tablespace ts_indexes;
CREATE INDEX mv_delivery_check_year_month_district ON cht.mv_delivery_check USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX delivery_chw_id_idx ON cht.mv_delivery_check USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX delivery_district_idx ON cht.mv_delivery_check USING btree (district) tablespace ts_indexes;
CREATE INDEX delivery_facility_idx ON cht.mv_delivery_check USING btree (facility) tablespace ts_indexes;