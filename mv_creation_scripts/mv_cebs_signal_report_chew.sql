-- cht.mv_cebs_signal_report_chew source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_cebs_signal_report_chew;
CREATE MATERIALIZED VIEW cht.mv_cebs_signal_report_chew
TABLESPACE ts_report
AS SELECT d.doc ->> '_id'::text AS uuid,
    d.doc ->> 'form'::text AS form,
    to_timestamp((NULLIF(d.doc ->> 'reported_date'::text, ''::text)::bigint / 1000)::double precision) AS reported,
    to_char(to_timestamp((((d.doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'YYYY-MM-DD'::text)::date AS date,
    to_char(to_timestamp((((d.doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'YYYY'::text)::integer AS year,
    to_char(to_timestamp((((d.doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'MM'::text)::integer AS month,
    to_char(to_timestamp((((d.doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'FMMonth'::text) AS monthname,
    ((d.doc -> 'fields'::text) -> 'meta'::text) ->> 'instanceID'::text AS instanceid,
    (((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) ->> 'deprecatedID'::text AS deprecatedid,
    ((((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) -> 'location'::text) ->> 'lat'::text AS location_lat,
    ((((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) -> 'location'::text) ->> 'long'::text AS location_long,
    ((((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) -> 'location'::text) ->> 'error'::text AS location_error,
    ((((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) -> 'location'::text) ->> 'message'::text AS location_message,
    (d.doc -> 'geolocation'::text) ->> 'code'::text AS geolocation_code,
    (d.doc -> 'geolocation'::text) ->> 'message'::text AS geolocation_message,
    (NULLIF((d.doc -> 'geolocation'::text) ->> 'latitude'::text, ''::text))::double precision AS geolocation_latitude,
    (NULLIF((d.doc -> 'geolocation'::text) ->> 'longitude'::text, ''::text))::double precision AS geolocation_longitude,
    (NULLIF((d.doc -> 'geolocation'::text) ->> 'accuracy'::text, ''::text))::double precision AS geolocation_accuracy,
    (NULLIF((d.doc -> 'geolocation'::text) ->> 'altitude'::text, ''::text))::double precision AS geolocation_altitude,
    (NULLIF((d.doc -> 'geolocation'::text) ->> 'altitudeAccuracy'::text, ''::text))::double precision AS geolocation_altitude_accuracy,
    (NULLIF((d.doc -> 'geolocation'::text) ->> 'speed'::text, ''::text))::double precision AS geolocation_speed,
    (NULLIF((d.doc -> 'geolocation'::text) ->> 'heading'::text, ''::text))::double precision AS geolocation_heading,
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 'source'::text AS source,
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 'source_id'::text AS source_id,
    (((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'user'::text) ->> 'contact_id'::text AS user_contact_id,
    (((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'user'::text) ->> 'facility_id'::text AS user_facility_id,
    (((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> '_id'::text AS inputs_contact_id,
    (((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> 'name'::text AS contact_name,
    (((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> 'village'::text AS contact_village,
    ((((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) -> 'contact'::text) ->> '_id'::text AS cont_contact_id,
    ((((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) -> 'contact'::text) ->> 'name'::text AS cont_contact_name,
    ((((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) -> 'contact'::text) ->> 'date_of_birth'::text AS cont_contact_date_of_birth,
    ((((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) -> 'contact'::text) ->> 'phone'::text AS cont_contact_phone,
    (d.doc -> 'fields'::text) ->> 'needs_signoff'::text AS needs_signoff,
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 'chw_name'::text AS chw_name,
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 'chw_phone'::text AS chw_phone,
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 'place_id'::text AS place_id,
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 'place_name'::text AS place_name,
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 'chw_village'::text AS chw_village,
    ((d.doc -> 'fields'::text) -> 'unusual_health_event'::text) ->> 'experienced_unusual_health_event'::text AS experienced_unusual_health_event,
    ((d.doc -> 'fields'::text) -> 'signal_type'::text) ->> 'signal_reported'::text AS signal_reported,
    ((d.doc -> 'fields'::text) -> 'signal_type'::text) ->> 'additional_information'::text AS additional_information,
    ((d.doc -> 'fields'::text) -> 'signal_type'::text) ->> 'person_under_vht_area'::text AS person_under_vht_area,
    ((d.doc -> 'fields'::text) -> 'signal_type'::text) ->> 'brief_description'::text AS brief_description,
    d.doc #>> '{contact,_id}'::text[] AS chw_id,
    h.facility,
    h.village,
    h.parish,
    h.district,
    h.region,
    CURRENT_TIMESTAMP AS last_refresh_date
   FROM dwh.cht_data d
     LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}'::text[]) = h.chw_id
  WHERE (d.doc ->> 'form'::text) = 'cebs_signal_report_chew'::text AND d.is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX mv_cebs_signal_report_chew_eported ON cht.mv_cebs_signal_report_chew USING btree (reported) TABLESPACE ts_indexes;
CREATE INDEX mv_cebs_signal_report_chewchw_is ON cht.mv_cebs_signal_report_chew USING btree (chw_id) TABLESPACE ts_indexes;
CREATE INDEX mv_cebs_signal_report_chewchw_facility ON cht.mv_cebs_signal_report_chew USING btree (chw_id, facility) TABLESPACE ts_indexes;
CREATE INDEX mv_cebs_signal_report_chewchw_district ON cht.mv_cebs_signal_report_chew USING btree (chw_id, district) TABLESPACE ts_indexes;
CREATE INDEX mv_cebs_signal_report_chewchw_region ON cht.mv_cebs_signal_report_chew USING btree (chw_id, region) TABLESPACE ts_indexes;
CREATE INDEX mv_cebs_signal_report_chew_year_month_district ON cht.mv_cebs_signal_report_chew USING btree (year, month, district) TABLESPACE ts_indexes;
