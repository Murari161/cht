-- cht.mv_afp_notification source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_afp_notification;
CREATE MATERIALIZED VIEW cht.mv_afp_notification
TABLESPACE ts_report
AS SELECT doc ->> '_id'::text AS uuid,
    doc ->> 'form'::text AS form,
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
    ((doc -> 'fields'::text) -> 'inputs'::text) ->> 'source'::text AS source,
    ((doc -> 'fields'::text) -> 'inputs'::text) ->> 'source_id'::text AS source_id,
    ((doc -> 'fields'::text) -> 'inputs'::text) ->> 't_patient_condition'::text AS t_patient_condition,
    ((doc -> 'fields'::text) -> 'inputs'::text) ->> 't_place_name'::text AS t_place_name,
    ((doc -> 'fields'::text) -> 'inputs'::text) ->> 't_vht_name'::text AS t_vht_name,
    ((doc -> 'fields'::text) -> 'inputs'::text) ->> 't_vht_phone'::text AS t_vht_phone,
    ((doc -> 'fields'::text) -> 'inputs'::text) ->> 't_patient_name'::text AS t_patient_name,
    ((doc -> 'fields'::text) -> 'inputs'::text) ->> 't_patient_gender'::text AS t_patient_gender,
    ((doc -> 'fields'::text) -> 'inputs'::text) ->> 't_patient_date_of_birth'::text AS t_patient_date_of_birth,
    ((doc -> 'fields'::text) -> 'inputs'::text) ->> 't_patient_id'::text AS t_patient_id,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'user'::text) ->> 'contact_id'::text AS user_contact_id,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'user'::text) ->> 'facility_id'::text AS user_facility_id,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> '_id'::text AS contact_id,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> 'name'::text AS contact_name,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> 'date_of_birth'::text AS contact_date_of_birth,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> 'sex'::text AS contact_sex,
    (doc -> 'fields'::text) ->> 'dob'::text AS dob,
    (doc -> 'fields'::text) ->> 'patient_age_in_years'::text AS patient_age_in_years,
    (doc -> 'fields'::text) ->> 'patient_age_in_months'::text AS patient_age_in_months,
    (doc -> 'fields'::text) ->> 'patient_age_in_days'::text AS patient_age_in_days,
    (doc -> 'fields'::text) ->> 'patient_age_display'::text AS patient_age_display,
    (doc -> 'fields'::text) ->> 'patient_id'::text AS patient_id,
    (doc -> 'fields'::text) ->> 'patient_name'::text AS patient_name,
    (doc -> 'fields'::text) ->> 'patient_gender'::text AS patient_gender,
    (doc -> 'fields'::text) ->> 'vht_name'::text AS vht_name,
    (doc -> 'fields'::text) ->> 'vht_phone'::text AS vht_phone,
    (doc -> 'fields'::text) ->> 'needs_signoff'::text AS needs_signoff,
    ((doc -> 'fields'::text) -> 'afp_confirmation'::text) ->> 'n_confirmation_note'::text AS n_confirmation_note,
    ((doc -> 'fields'::text) -> 'afp_confirmation'::text) ->> 'n_follow_up'::text AS n_follow_up,
    ((doc -> 'fields'::text) -> 'afp_confirmation'::text) ->> 'has_sudden_weakness_in_legs_and_arms'::text AS has_sudden_weakness_in_legs_and_arms,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
    CURRENT_TIMESTAMP AS last_refresh_date
   FROM dwh.cht_data d
   LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id 
  WHERE (d.doc ->> 'form'::text) = 'afp_notification'::text AND d.is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX mv_afp_notification_reported ON cht.mv_afp_notification USING btree (reported);
CREATE INDEX mv_afp_notification_chw_id ON cht.mv_afp_notification USING btree (chw_id);
create index mv_afp_notification_facility_id on cht.mv_afp_notification using btree (facility);
CREATE INDEX mv_afp_notification_district ON cht.mv_afp_notification USING btree (district);
CREATE INDEX mv_afp_notification_region ON cht.mv_afp_notification USING btree (region);
CREATE INDEX mv_afp_notification_date ON cht.mv_afp_notification USING btree (date);
CREATE INDEX mv_afp_notification_year_month_district ON cht.mv_afp_notification USING btree (year, month, district) TABLESPACE ts_indexes;
