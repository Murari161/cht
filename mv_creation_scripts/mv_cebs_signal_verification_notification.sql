-- cht.mv_cebs_signal_verification_notification source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_cebs_signal_verification_notification;
CREATE MATERIALIZED VIEW cht.mv_cebs_signal_verification_notification
TABLESPACE ts_report
AS SELECT d.doc ->> '_id'::text AS uuid,
    d.doc ->> 'form'::text AS form,
    to_timestamp((NULLIF(d.doc ->> 'reported_date'::text, ''::text)::bigint / 1000)::double precision) AS reported,
    to_char(to_timestamp((((d.doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'YYYY-MM-DD'::text)::date AS date,
    to_char(to_timestamp((((d.doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'YYYY'::text)::integer AS year,
    to_char(to_timestamp((((d.doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'MM'::text)::integer AS month,
    to_char(to_timestamp((((d.doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'FMMonth'::text) AS monthname,
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
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 't_place_name'::text AS t_place_name,
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 't_place_id'::text AS t_place_id,
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 't_vht_or_chew_name'::text AS t_vht_or_chew_name,
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 't_vht_or_chew_phone'::text AS t_vht_or_chew_phone,
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 't_signal_name'::text AS t_signal_name,
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 't_does_not_match_signal'::text AS t_does_not_match_signal,
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 't_duplicate_signal'::text AS t_duplicate_signal,
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 't_threat_exists'::text AS t_threat_exists,
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 't_supervisor_name'::text AS t_supervisor_name,
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 't_supervisor_phone'::text AS t_supervisor_phone,
    (((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'user'::text) ->> 'contact_id'::text AS user_contact_id,
    (((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'user'::text) ->> 'facility_id'::text AS user_facility_id,
    (((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> '_id'::text AS contact_id,
    (((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> 'name'::text AS contact_name,
    (((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> 'date_of_birth'::text AS date_of_birth,
    (((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> 'sex'::text AS sex,
    (d.doc -> 'fields'::text) ->> 'supervisor'::text AS supervisor,
    (d.doc -> 'fields'::text) ->> 'supervisor_phone'::text AS supervisor_phone,
    (d.doc -> 'fields'::text) ->> 'vht_or_chew_name'::text AS vht_or_chew_name,
    (d.doc -> 'fields'::text) ->> 'vht_or_chew_phone'::text AS vht_or_chew_phone,
    (d.doc -> 'fields'::text) ->> 'signal_name'::text AS signal_name,
    (d.doc -> 'fields'::text) ->> 'does_not_match_signal'::text AS does_not_match_signal,
    (d.doc -> 'fields'::text) ->> 'is_duplicate_signal'::text AS is_duplicate_signal,
    (d.doc -> 'fields'::text) ->> 'threat_exists'::text AS threat_exists,
    (d.doc -> 'fields'::text) ->> 'needs_signoff'::text AS needs_signoff,
    ((d.doc -> 'fields'::text) -> 'notification'::text) ->> 'supervisor_verified_signal'::text AS supervisor_verified_signal,
    ((d.doc -> 'fields'::text) -> 'notification'::text) ->> 'findings'::text AS findings,
    ((d.doc -> 'fields'::text) -> 'notification'::text) ->> 'informatio_does_not_match_a_signal'::text AS informatio_does_not_match_a_signal,
    ((d.doc -> 'fields'::text) -> 'notification'::text) ->> 'duplicate_signal'::text AS notification_duplicate_signal,
    ((d.doc -> 'fields'::text) -> 'notification'::text) ->> 'threat_still_exists'::text AS threat_still_exists,
    ((d.doc -> 'fields'::text) -> 'notification'::text) ->> 'threat_no_longer_exists'::text AS threat_no_longer_exists,
    d.doc #>> '{contact,_id}'::text[] AS chw_id,
    h.facility,
    h.village,
    h.district,
    h.region,
    CURRENT_TIMESTAMP AS last_refresh_date
   FROM dwh.cht_data d
     LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}'::text[]) = h.chw_id
  WHERE (d.doc ->> 'form'::text) = 'cebs_signal_verification_notification'::text AND d.is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX mv_cebs_signal_verification_notification_eported ON cht.mv_cebs_signal_verification_notification USING btree (reported) TABLESPACE ts_indexes;
CREATE INDEX mv_cebs_signal_verification_notificationchw_is ON cht.mv_cebs_signal_verification_notification USING btree (chw_id) TABLESPACE ts_indexes;
CREATE INDEX mv_cebs_signal_verification_notificationdate ON cht.mv_cebs_signal_verification_notification USING btree (date) TABLESPACE ts_indexes;
CREATE INDEX mv_cebs_signal_verification_notification_year_month_district ON cht.mv_cebs_signal_verification_notification USING btree (year, month, district) TABLESPACE ts_indexes;