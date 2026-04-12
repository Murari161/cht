drop MATERIALIZED VIEW cht.mv_cebs_signal_verification_notification;
CREATE MATERIALIZED VIEW cht.mv_cebs_signal_verification_notification
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
        doc ->'fields'->'inputs'->'meta'->>'deprecatedID' AS deprecatedID,
        doc ->'fields'->'inputs'->'meta'->'location'->>'lat' AS location_lat,
        doc ->'fields'->'inputs'->'meta'->'location'->>'long' AS location_long,
        doc ->'fields'->'inputs'->'meta'->'location'->>'error' AS location_error,
        doc ->'fields'->'inputs'->'meta'->'location'->>'message' AS location_message,
        doc ->'geolocation'->>'code' AS geolocation_code,
        doc ->'geolocation'->>'message' AS geolocation_message,
        doc -> 'fields' -> 'inputs' ->> 'source'                             AS source,
        doc -> 'fields' -> 'inputs' ->> 'source_id'                          AS source_id,
        doc -> 'fields' -> 'inputs' ->> 't_place_name'              AS t_place_name,
        doc -> 'fields' -> 'inputs' ->> 't_place_id'                AS t_place_id,
        doc -> 'fields' -> 'inputs' ->> 't_vht_or_chew_name'        AS t_vht_or_chew_name,
        doc -> 'fields' -> 'inputs' ->> 't_vht_or_chew_phone'       AS t_vht_or_chew_phone,
        doc -> 'fields' -> 'inputs' ->> 't_signal_name'             AS t_signal_name,
        doc -> 'fields' -> 'inputs' ->> 't_does_not_match_signal'   AS t_does_not_match_signal,
        doc -> 'fields' -> 'inputs' ->> 't_duplicate_signal'        AS t_duplicate_signal,
        doc -> 'fields' -> 'inputs' ->> 't_threat_exists'           AS t_threat_exists,
        doc -> 'fields' -> 'inputs' ->> 't_supervisor_name'         AS t_supervisor_name,
        doc -> 'fields' -> 'inputs' ->> 't_supervisor_phone'        AS t_supervisor_phone,
        doc -> 'fields' -> 'inputs' -> 'user' ->> 'contact_id'      AS user_contact_id,
        doc -> 'fields' -> 'inputs' -> 'user' ->> 'facility_id'     AS user_facility_id,
        doc -> 'fields' -> 'inputs' -> 'contact' ->> '_id'          AS contact_id,
        doc -> 'fields' -> 'inputs' -> 'contact' ->> 'name'         AS contact_name,
        doc -> 'fields' -> 'inputs' -> 'contact' ->> 'date_of_birth' AS date_of_birth,
        doc -> 'fields' -> 'inputs' -> 'contact' ->> 'sex'          AS sex,
        doc -> 'fields' ->> 'supervisor'              AS supervisor,
        doc -> 'fields' ->> 'supervisor_phone'        AS supervisor_phone,
        doc -> 'fields' ->> 'vht_or_chew_name'        AS vht_or_chew_name,
        doc -> 'fields' ->> 'vht_or_chew_phone'       AS vht_or_chew_phone,
        doc -> 'fields' ->> 'signal_name'             AS signal_name,
        doc -> 'fields' ->> 'does_not_match_signal'   AS does_not_match_signal,
        doc -> 'fields' ->> 'is_duplicate_signal'     AS is_duplicate_signal,
        doc -> 'fields' ->> 'threat_exists'           AS threat_exists,
        doc -> 'fields' ->> 'needs_signoff'           AS needs_signoff,

        doc -> 'fields' -> 'notification' ->> 'supervisor_verified_signal'    AS supervisor_verified_signal,
        doc -> 'fields' -> 'notification' ->> 'findings'    AS findings,
        doc -> 'fields' -> 'notification' ->> 'informatio_does_not_match_a_signal'    AS informatio_does_not_match_a_signal,
        doc -> 'fields' -> 'notification' ->> 'duplicate_signal'    AS notification_duplicate_signal,
        doc -> 'fields' -> 'notification' ->> 'threat_still_exists'    AS threat_still_exists,
        doc -> 'fields' -> 'notification' ->> 'threat_no_longer_exists'    AS threat_no_longer_exists,
        
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
WHERE (doc ->> 'form'::text) = 'cebs_signal_verification_notification'::text
  AND is_current
WITH DATA;
CREATE INDEX mv_cebs_signal_verification_notificationchw_is ON cht.mv_cebs_signal_verification_notification USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX mv_cebs_signal_verification_notification_eported ON cht.mv_cebs_signal_verification_notification USING btree (reported) tablespace ts_indexes;
--permissions
GRANT UPDATE, TRUNCATE, TRIGGER, REFERENCES, INSERT, DELETE, SELECT ON TABLE cht.mv_cebs_signal_report_vht TO albert_fellow;
GRANT UPDATE, TRUNCATE, TRIGGER, REFERENCES, INSERT, DELETE, SELECT ON TABLE cht.mv_cebs_signal_report_vht TO tom_fellow;
GRANT UPDATE, TRUNCATE, TRIGGER, REFERENCES, INSERT, DELETE, SELECT ON TABLE cht.mv_cebs_signal_report_vht TO baker;
GRANT UPDATE, TRUNCATE, TRIGGER, REFERENCES, INSERT, DELETE, SELECT ON TABLE cht.mv_cebs_signal_report_vht TO mkizito;
GRANT UPDATE, TRUNCATE, TRIGGER, REFERENCES, INSERT, DELETE, SELECT ON TABLE cht.mv_cebs_signal_report_vht TO mpaul;
GRANT UPDATE, TRUNCATE, TRIGGER, REFERENCES, INSERT, DELETE, SELECT ON TABLE cht.mv_cebs_signal_report_vht TO nmadrine;
GRANT UPDATE, TRUNCATE, TRIGGER, REFERENCES, INSERT, DELETE, SELECT ON TABLE cht.mv_cebs_signal_report_vht TO rutayisire;

