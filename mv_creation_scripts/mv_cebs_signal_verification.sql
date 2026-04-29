-- cht.mv_cebs_signal_verification source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_cebs_signal_verification;
CREATE MATERIALIZED VIEW cht.mv_cebs_signal_verification
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
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 't_patient_condition'::text AS t_patient_condition,
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 'source'::text AS source,
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 'source_id'::text AS source_id,
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 'vht_or_chew_name'::text AS vht_or_chew_name,
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 'vht_or_chew_phone'::text AS vht_or_chew_phone,
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 'vht_or_chew_area'::text AS vht_or_chew_area,
    (((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> '_id'::text AS contact_id,
    (((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> 'name'::text AS contact_name,
    ((((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) -> 'contact'::text) ->> '_id'::text AS inputs_contact_id,
    ((((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) -> 'contact'::text) ->> 'name'::text AS inputs_contact_name,
    ((((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) -> 'contact'::text) ->> 'date_of_birth'::text AS date_of_birth,
    (((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'user'::text) ->> 'name'::text AS user_name,
    (((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'user'::text) ->> 'contact_id'::text AS user_contact_id,
    (d.doc -> 'fields'::text) ->> 'place_id'::text AS place_id,
    (d.doc -> 'fields'::text) ->> 'place_name'::text AS place_name,
    (d.doc -> 'fields'::text) ->> 'supervisor_name'::text AS supervisor_name,
    (d.doc -> 'fields'::text) ->> 'supervisor_phone'::text AS supervisor_phone,
    (d.doc -> 'fields'::text) ->> 'signal_name'::text AS signal_name,
    (d.doc -> 'fields'::text) ->> 'needs_signoff'::text AS needs_signoff,
    (((d.doc -> 'fields'::text) -> 'signal_overview'::text) -> 'current_user'::text) ->> '_id'::text AS current_user_id,
    (((d.doc -> 'fields'::text) -> 'signal_overview'::text) -> 'current_user'::text) ->> 'name'::text AS current_user_name,
    (((d.doc -> 'fields'::text) -> 'signal_overview'::text) -> 'current_user'::text) ->> 'phone'::text AS current_user_phone,
    ((d.doc -> 'fields'::text) -> 'signal_overview'::text) ->> 'vht_or_chew_info'::text AS vht_or_chew_info,
    ((d.doc -> 'fields'::text) -> 'signal_overview'::text) ->> 'mode_of_verification'::text AS mode_of_verification,
    ((d.doc -> 'fields'::text) -> 'signal_overview'::text) ->> 'description_of_signal'::text AS description_of_signal,
    ((d.doc -> 'fields'::text) -> 'signal_verification'::text) ->> 'information_match_signal_type'::text AS information_match_signal_type,
    ((d.doc -> 'fields'::text) -> 'signal_verification'::text) ->> 'matching_signal'::text AS matching_signal,
    ((d.doc -> 'fields'::text) -> 'verification'::text) ->> 'signal_reported_before'::text AS signal_reported_before,
    ((d.doc -> 'fields'::text) -> 'verification'::text) ->> 'not_new_signal'::text AS not_new_signal,
    ((d.doc -> 'fields'::text) -> 'verification'::text) ->> 'health_threat_start'::text AS health_threat_start,
    ((d.doc -> 'fields'::text) -> 'verification'::text) ->> 'approximate_number_ill'::text AS approximate_number_ill,
    ((d.doc -> 'fields'::text) -> 'verification'::text) ->> 'approximate_number_dead'::text AS approximate_number_dead,
    ((d.doc -> 'fields'::text) -> 'verification'::text) ->> 'signal_involve_animals'::text AS signal_involve_animals,
    ((d.doc -> 'fields'::text) -> 'verification'::text) ->> 'animals_involved'::text AS animals_involved,
    ((d.doc -> 'fields'::text) -> 'verification'::text) ->> 'specify_animal_involved'::text AS specify_animal_involved,
    ((d.doc -> 'fields'::text) -> 'verification'::text) ->> 'approximate_animals_affected'::text AS approximate_animals_affected,
    ((d.doc -> 'fields'::text) -> 'verification'::text) ->> 'approximate_animals_dead'::text AS approximate_animals_dead,
    ((d.doc -> 'fields'::text) -> 'verification'::text) ->> 'source_of_information'::text AS source_of_information,
    ((d.doc -> 'fields'::text) -> 'verification'::text) ->> 'additional_information'::text AS additional_information,
    ((d.doc -> 'fields'::text) -> 'verification'::text) ->> 'date_health_threat_verified'::text AS date_health_threat_verified,
    ((d.doc -> 'fields'::text) -> 'verification'::text) ->> 'reported_threat_exists'::text AS reported_threat_exists,
    ((d.doc -> 'fields'::text) -> 'verification'::text) ->> 'note_reported_threat_does_not_exist'::text AS note_reported_threat_does_not_exist,
    ((d.doc -> 'fields'::text) -> 'verification'::text) ->> 'date_facility_informed'::text AS date_facility_informed,
    ((d.doc -> 'fields'::text) -> 'verification'::text) ->> 'signal_been_referred'::text AS signal_been_referred,
    d.doc #>> '{contact,_id}'::text[] AS chw_id,
    h.facility,
    h.village,
    h.district,
    h.region,
    CURRENT_TIMESTAMP AS last_refresh_date
   FROM dwh.cht_data d
     LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}'::text[]) = h.chw_id
  WHERE (d.doc ->> 'form'::text) = 'cebs_signal_verification'::text AND d.is_current
WITH DATA;

-- View indexes:
CREATE INDEX mv_cebs_signal_verification_eported ON cht.mv_cebs_signal_verification USING btree (reported) TABLESPACE ts_indexes;
CREATE INDEX mv_cebs_signal_verificationchw_is ON cht.mv_cebs_signal_verification USING btree (chw_id) TABLESPACE ts_indexes;
CREATE INDEX mv_cebs_signal_verification_year_month ON cht.mv_cebs_signal_verification USING btree (year, month) TABLESPACE ts_indexes;
CREATE INDEX mv_cebs_signal_verification_region_district_facility ON cht.mv_cebs_signal_verification (region, district, facility) TABLESPACE ts_indexes;
CREATE INDEX mv_cebs_signal_verification_district ON cht.mv_cebs_signal_verification (district) TABLESPACE ts_indexes;
CREATE INDEX mv_cebs_signal_verification_district_facility ON cht.mv_cebs_signal_verification (district, facility) TABLESPACE ts_indexes; 