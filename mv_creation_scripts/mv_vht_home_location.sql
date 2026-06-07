-- cht.mv_vht_home_location source
DROP MATERIALIZED VIEW cht.mv_vht_home_location;
CREATE MATERIALIZED VIEW cht.mv_vht_home_location
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
    (doc -> 'geolocation'::text) ->> 'code'::text AS geolocation_code,
    (doc -> 'geolocation'::text) ->> 'message'::text AS geolocation_message,
    (NULLIF((doc -> 'geolocation'::text) ->> 'latitude'::text, ''::text))::double precision AS geolocation_latitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'longitude'::text, ''::text))::double precision AS geolocation_longitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'accuracy'::text, ''::text))::double precision AS geolocation_accuracy,
    (NULLIF((doc -> 'geolocation'::text) ->> 'altitude'::text, ''::text))::double precision AS geolocation_altitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'altitudeAccuracy'::text, ''::text))::double precision AS geolocation_altitude_accuracy,
    (NULLIF((doc -> 'geolocation'::text) ->> 'speed'::text, ''::text))::double precision AS geolocation_speed,
    (NULLIF((doc -> 'geolocation'::text) ->> 'heading'::text, ''::text))::double precision AS geolocation_heading,
    doc #>> '{fields,inputs,source}'::text[] AS inputs_source,
    doc #>> '{fields,inputs,source_id}'::text[] AS inputs_source_id,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    doc #>> '{fields,geolocation,latitude}'::text[] AS fields_geolocation_latitude,
    doc #>> '{fields,geolocation,longitude}'::text[] AS fields_geolocation_longitude,
    doc #>> '{fields,geolocation,altitude}'::text[] AS fields_geolocation_altitude,
    doc #>> '{fields,geolocation,accuracy}'::text[] AS fields_geolocation_accuracy,
    doc #>> '{fields,geolocation,want_to_capture_gps}'::text[] AS fields_geolocation_want_to_capture_gps,
    doc #>> '{fields,geolocation,ensure_gps}'::text[] AS fields_geolocation_ensure_gps,
    doc #>> '{fields,geolocation,gps}'::text[] AS fields_geolocation_gps,
    doc #>> '{fields,geolocation,coordinates}'::text[] AS fields_geolocation_coordinates,
    doc #>> '{fields,geolocation,additional_comments}'::text[] AS fields_geolocation_additional_comments,
    doc #>> '{fields,geolocation,no_gps_reasons}'::text[] AS fields_geolocation_no_gps_reasons,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
FROM dwh.cht_data d LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id 
  WHERE (doc ->> 'form'::text) = 'vht_home_location'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX mv_vht_home_location_chw_id ON cht.mv_vht_home_location USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX mv_vht_home_location_reported ON cht.mv_vht_home_location USING btree (reported) tablespace ts_indexes;
CREATE INDEX mv_vht_home_location_monthname ON cht.mv_vht_home_location USING btree (monthname) tablespace ts_indexes;
CREATE INDEX mv_vht_home_location_year_month_district ON cht.mv_vht_home_location USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX mv_vht_home_location_region ON cht.mv_vht_home_location USING btree (region) tablespace ts_indexes;
CREATE INDEX mv_vht_home_location_district ON cht.mv_vht_home_location USING btree (district) tablespace ts_indexes;
CREATE INDEX mv_vht_home_location_village ON cht.mv_vht_home_location USING btree (village) tablespace ts_indexes;
CREATE INDEX mv_vht_home_location_facility ON cht.mv_vht_home_location USING btree (facility) tablespace ts_indexes;
CREATE INDEX mv_vht_home_location_dhis2_facility_id ON cht.mv_vht_home_location USING btree (dhis2_facility_id) tablespace ts_indexes;