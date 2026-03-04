drop MATERIALIZED VIEW cht.mv_cebs_signal_verification;
CREATE MATERIALIZED VIEW cht.mv_cebs_signal_verification
TABLESPACE ts_report
AS
SELECT
        doc ->> '_id'::text AS uuid,
        doc ->> 'form'::text AS form,
        to_timestamp((NULLIF(d.doc ->> 'reported_date'::text, ''::text)::bigint / 1000)::double precision) AS reported,
        to_char(to_timestamp((((d.doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'YYYY-MM-DD'::text)::date AS date,
        to_char(to_timestamp((((d.doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'YYYY'::text)::integer AS year,
        to_char(to_timestamp((((d.doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'MM'::text)::integer AS month,
        to_char(to_timestamp((((d.doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'FMMonth'::text) AS monthname,
        doc ->'fields'->'meta'->>'instanceID' AS instanceID,
        doc ->'fields'->'inputs'->'meta'->>'deprecatedID' AS deprecatedID,
        doc ->'fields'->'inputs'->'meta'->'location'->>'lat' AS location_lat,
        doc ->'fields'->'inputs'->'meta'->'location'->>'long' AS location_long,
        doc ->'fields'->'inputs'->'meta'->'location'->>'error' AS location_error,
        doc ->'fields'->'inputs'->'meta'->'location'->>'message' AS location_message,
        doc ->'geolocation'->>'code' AS geolocation_code,
        doc ->'geolocation'->>'message' AS geolocation_message,
        doc -> 'fields' -> 'inputs' ->> 't_patient_condition'        AS t_patient_condition,
        doc -> 'fields' -> 'inputs' ->> 'source'                             AS source,
        doc -> 'fields' -> 'inputs' ->> 'source_id' AS source_id,
        doc -> 'fields' -> 'inputs' ->> 'vht_or_chew_name'  AS vht_or_chew_name,
        doc -> 'fields' -> 'inputs' ->> 'vht_or_chew_phone' AS vht_or_chew_phone,
        doc -> 'fields' -> 'inputs' ->> 'vht_or_chew_area'  AS vht_or_chew_area,
        doc -> 'fields' -> 'inputs' -> 'contact' ->> '_id'  AS contact_id,
        doc -> 'fields' -> 'inputs' -> 'contact' ->> 'name' AS contact_name,
        doc -> 'fields' -> 'inputs' -> 'contact' -> 'contact' ->> '_id'           AS cont_contact_id,
        doc -> 'fields' -> 'inputs' -> 'contact' -> 'contact' ->> 'name'          AS cont_contact_name,
        doc -> 'fields' -> 'inputs' -> 'contact' -> 'contact' ->> 'date_of_birth' AS date_of_birth,
        doc -> 'fields' -> 'inputs' -> 'user' ->> 'name'        AS user_name,
        doc -> 'fields' -> 'inputs' -> 'user' ->> 'contact_id' AS user_contact_id,
        doc -> 'fields' ->> 'place_id' AS place_id,
        doc -> 'fields' ->> 'place_name'        AS place_name,
        doc -> 'fields' ->> 'supervisor_name'   AS supervisor_name,
        doc -> 'fields' ->> 'supervisor_phone'  AS supervisor_phone,
        doc -> 'fields' ->> 'signal_name'       AS signal_name,
        doc -> 'fields' ->> 'needs_signoff'     AS needs_signoff,
        doc -> 'fields' -> 'signal_overview' -> 'current_user' ->> '_id'   AS current_user_id,
        doc -> 'fields' -> 'signal_overview' -> 'current_user' ->> 'name'  AS current_user_name,
        doc -> 'fields' -> 'signal_overview' -> 'current_user' ->> 'phone' AS current_user_phone,

        doc -> 'fields' -> 'signal_overview' ->> 'vht_or_chew_info'        AS vht_or_chew_info,
        doc -> 'fields' -> 'signal_overview' ->> 'mode_of_verification'   AS mode_of_verification,
        doc -> 'fields' -> 'signal_overview' ->> 'description_of_signal'  AS description_of_signal,
        doc -> 'fields' -> 'signal_verification' ->> 'information_match_signal_type' AS information_match_signal_type,
        doc -> 'fields' -> 'signal_verification' ->> 'matching_signal'  AS matching_signal,
        doc -> 'fields' -> 'verification' ->> 'signal_reported_before'      AS signal_reported_before,
        doc -> 'fields' -> 'verification' ->> 'not_new_signal'     AS not_new_signal,
        doc -> 'fields' -> 'verification' ->> 'health_threat_start'    AS health_threat_start,
        doc -> 'fields' -> 'verification' ->> 'approximate_number_ill'    AS approximate_number_ill,
        doc -> 'fields' -> 'verification' ->> 'approximate_number_dead'    AS approximate_number_dead,
        doc -> 'fields' -> 'verification' ->> 'signal_involve_animals'    AS signal_involve_animals,
        doc -> 'fields' -> 'verification' ->> 'animals_involved'    AS animals_involved,
        doc -> 'fields' -> 'verification' ->> 'specify_animal_involved'    AS specify_animal_involved,
        doc -> 'fields' -> 'verification' ->> 'approximate_animals_affected'    AS approximate_animals_affected,
        doc -> 'fields' -> 'verification' ->> 'approximate_animals_dead'    AS approximate_animals_dead,
        doc -> 'fields' -> 'verification' ->> 'source_of_information'    AS source_of_information,
        doc -> 'fields' -> 'verification' ->> 'additional_information'    AS additional_information,
        doc -> 'fields' -> 'verification' ->> 'date_health_threat_verified'    AS date_health_threat_verified,
        doc -> 'fields' -> 'verification' ->> 'reported_threat_exists'    AS reported_threat_exists,
        doc -> 'fields' -> 'verification' ->> 'note_reported_threat_does_not_exist'    AS note_reported_threat_does_not_exist,
        doc -> 'fields' -> 'verification' ->> 'date_facility_informed'    AS date_facility_informed,
        doc -> 'fields' -> 'verification' ->> 'signal_been_referred'    AS signal_been_referred,
        
        doc #>> '{contact,_id}'                         AS chw_id,
        h.facility_name,
        h.village,
        h.district,
        h.region,
    --delivery.is_current,


    CURRENT_TIMESTAMP AS last_refresh_date   

  FROM dwh.cht_data d
  LEFT JOIN cht.mv_chew_hierarchy_2 h
       ON (d.doc #>> '{contact,_id}') = h.chw_id
WHERE (doc ->> 'form'::text) = 'cebs_signal_verification'::text
  AND is_current
WITH DATA;
CREATE INDEX mv_cebs_signal_verificationchw_is ON cht.mv_cebs_signal_verification USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX mv_cebs_signal_verification_eported ON cht.mv_cebs_signal_verification USING btree (reported) tablespace ts_indexes;

--permissions
GRANT UPDATE, TRUNCATE, TRIGGER, REFERENCES, INSERT, DELETE, SELECT ON TABLE cht.mv_cebs_signal_report_vht TO albert_fellow;
GRANT UPDATE, TRUNCATE, TRIGGER, REFERENCES, INSERT, DELETE, SELECT ON TABLE cht.mv_cebs_signal_report_vht TO tom_fellow;
GRANT UPDATE, TRUNCATE, TRIGGER, REFERENCES, INSERT, DELETE, SELECT ON TABLE cht.mv_cebs_signal_report_vht TO baker;
GRANT UPDATE, TRUNCATE, TRIGGER, REFERENCES, INSERT, DELETE, SELECT ON TABLE cht.mv_cebs_signal_report_vht TO mkizito;
GRANT UPDATE, TRUNCATE, TRIGGER, REFERENCES, INSERT, DELETE, SELECT ON TABLE cht.mv_cebs_signal_report_vht TO mpaul;
GRANT UPDATE, TRUNCATE, TRIGGER, REFERENCES, INSERT, DELETE, SELECT ON TABLE cht.mv_cebs_signal_report_vht TO nmadrine;
GRANT UPDATE, TRUNCATE, TRIGGER, REFERENCES, INSERT, DELETE, SELECT ON TABLE cht.mv_cebs_signal_report_vht TO rutayisire;

