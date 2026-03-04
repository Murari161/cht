-- cht.mv_cebs_signal_report_chew source
DROP materialized view cht.mv_cebs_signal_report_chew;
CREATE MATERIALIZED VIEW cht.mv_cebs_signal_report_chew
TABLESPACE ts_report
AS SELECT doc ->> '_id'::text AS uuid,
    doc ->> 'form'::text AS form,
    to_timestamp((NULLIF(d.doc ->> 'reported_date'::text, ''::text)::bigint / 1000)::double precision) AS reported,
    to_char(to_timestamp((((d.doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'YYYY-MM-DD'::text)::date AS date,
    to_char(to_timestamp((((d.doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'YYYY'::text)::integer AS year,
    to_char(to_timestamp((((d.doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'MM'::text)::integer AS month,
    to_char(to_timestamp((((d.doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'FMMonth'::text) AS monthname,
    ((doc -> 'fields'::text) -> 'meta'::text) ->> 'instanceID'::text AS instanceid,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) ->> 'deprecatedID'::text AS deprecatedid,
    ((((doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) -> 'location'::text) ->> 'lat'::text AS location_lat,
    ((((doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) -> 'location'::text) ->> 'long'::text AS location_long,
    ((((doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) -> 'location'::text) ->> 'error'::text AS location_error,
    ((((doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) -> 'location'::text) ->> 'message'::text AS location_message,
    (doc -> 'geolocation'::text) ->> 'code'::text AS geolocation_code,
    (doc -> 'geolocation'::text) ->> 'message'::text AS geolocation_message,
    ((doc -> 'fields'::text) -> 'inputs'::text) ->> 'source'::text AS source,
    ((doc -> 'fields'::text) -> 'inputs'::text) ->> 'source_id'::text AS source_id,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'user'::text) ->> 'contact_id'::text AS user_contact_id,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'user'::text) ->> 'facility_id'::text AS user_facility_id,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> '_id'::text AS contact_id,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> 'name'::text AS contact_name,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> 'village'::text AS contact_village,
    ((((doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) -> 'contact'::text) ->> '_id'::text AS cont_contact_id,
    ((((doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) -> 'contact'::text) ->> 'name'::text AS cont_contact_name,
    ((((doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) -> 'contact'::text) ->> 'date_of_birth'::text AS cont_contact_date_of_birth,
    ((((doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) -> 'contact'::text) ->> 'phone'::text AS cont_contact_phone,
    (doc -> 'fields'::text) ->> 'needs_signoff'::text AS needs_signoff,
    ((doc -> 'fields'::text) -> 'inputs'::text) ->> 'chw_name'::text AS chw_name,
    ((doc -> 'fields'::text) -> 'inputs'::text) ->> 'chw_phone'::text AS chw_phone,
    ((doc -> 'fields'::text) -> 'inputs'::text) ->> 'place_id'::text AS place_id,
    ((doc -> 'fields'::text) -> 'inputs'::text) ->> 'place_name'::text AS place_name,
    ((doc -> 'fields'::text) -> 'inputs'::text) ->> 'chw_village'::text AS chw_village,
    ((doc -> 'fields'::text) -> 'unusual_health_event'::text) ->> 'experienced_unusual_health_event'::text AS experienced_unusual_health_event,
    ((doc -> 'fields'::text) -> 'signal_type'::text) ->> 'signal_reported'::text AS signal_reported,
    ((doc -> 'fields'::text) -> 'signal_type'::text) ->> 'additional_information'::text AS additional_information,
    ((doc -> 'fields'::text) -> 'signal_type'::text) ->> 'person_under_vht_area'::text AS person_under_vht_area,
    ((doc -> 'fields'::text) -> 'signal_type'::text) ->> 'brief_description'::text AS brief_description,  
    --- reporting hierarchy
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
  WHERE (doc ->> 'form'::text) = 'cebs_signal_report_chew'::text AND is_current
WITH DATA;

-- View indexes:
CREATE INDEX mv_cebs_signal_report_chew_eported ON cht.mv_cebs_signal_report_chew USING btree (reported) tablespace ts_indexes;
CREATE INDEX mv_cebs_signal_report_chewchw_is ON cht.mv_cebs_signal_report_chew USING btree (chw_id) tablespace ts_indexes;
--permisions
GRANT UPDATE, TRUNCATE, TRIGGER, REFERENCES, INSERT, DELETE, SELECT ON TABLE cht.mv_cebs_signal_report_chew TO albert_fellow;
GRANT UPDATE, TRUNCATE, TRIGGER, REFERENCES, INSERT, DELETE, SELECT ON TABLE cht.mv_cebs_signal_report_chew TO tom_fellow;
GRANT UPDATE, TRUNCATE, TRIGGER, REFERENCES, INSERT, DELETE, SELECT ON TABLE cht.mv_cebs_signal_report_chew TO baker;
GRANT UPDATE, TRUNCATE, TRIGGER, REFERENCES, INSERT, DELETE, SELECT ON TABLE cht.mv_cebs_signal_report_chew TO mkizito;
GRANT UPDATE, TRUNCATE, TRIGGER, REFERENCES, INSERT, DELETE, SELECT ON TABLE cht.mv_cebs_signal_report_chew TO mpaul;
GRANT UPDATE, TRUNCATE, TRIGGER, REFERENCES, INSERT, DELETE, SELECT ON TABLE cht.mv_cebs_signal_report_chew TO nmadrine;
GRANT UPDATE, TRUNCATE, TRIGGER, REFERENCES, INSERT, DELETE, SELECT ON TABLE cht.mv_cebs_signal_report_chew TO rutayisire;