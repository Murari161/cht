-- cht.mv_cebs_signal_report_vht source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_cebs_signal_report_vht;
CREATE MATERIALIZED VIEW cht.mv_cebs_signal_report_vht
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
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 'source'::text AS source,
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 'source_id'::text AS source_id,
    (((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'user'::text) ->> 'contact_id'::text AS user_contact_id,
    (((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'user'::text) ->> 'facility_id'::text AS user_facility_id,
    (((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> '_id'::text AS contact_id,
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
    ((d.doc -> 'fields'::text) -> 'group_summary'::text) ->> 's_note_signal_report_summary_page'::text AS s_note_signal_report_summary_page,
    ((d.doc -> 'fields'::text) -> 'group_summary'::text) ->> 's_note_be_sure_to_submit'::text AS s_note_be_sure_to_submit,
    ((d.doc -> 'fields'::text) -> 'group_summary'::text) ->> 's_note_signal_details'::text AS s_note_signal_details,
    ((d.doc -> 'fields'::text) -> 'group_summary'::text) ->> 'no_signal_reported'::text AS no_signal_reported,
    ((d.doc -> 'fields'::text) -> 'group_summary'::text) ->> 's_note_fever_and_bleeding'::text AS s_note_fever_and_bleeding,
    ((d.doc -> 'fields'::text) -> 'group_summary'::text) ->> 's_note_unexplained_rash'::text AS s_note_unexplained_rash,
    ((d.doc -> 'fields'::text) -> 'group_summary'::text) ->> 's_note_sudden_or_unexplained_death'::text AS s_note_sudden_or_unexplained_death,
    ((d.doc -> 'fields'::text) -> 'group_summary'::text) ->> 's_note_bitten_by_dog_or_animal'::text AS s_note_bitten_by_dog_or_animal,
    ((d.doc -> 'fields'::text) -> 'group_summary'::text) ->> 's_note_abnormal_change_in_drinking_water'::text AS s_note_abnormal_change_in_drinking_water,
    ((d.doc -> 'fields'::text) -> 'group_summary'::text) ->> 's_note_public_health_threat'::text AS s_note_public_health_threat,
    ((d.doc -> 'fields'::text) -> 'group_summary'::text) ->> 's_note_key_instruction'::text AS s_note_key_instruction,
    ((d.doc -> 'fields'::text) -> 'group_summary'::text) ->> 'switch_on_data'::text AS switch_on_data,
    d.doc #>> '{contact,_id}'::text[] AS chw_id,
    h.facility_name,
    h.village,
    h.district,
    h.region,
    CURRENT_TIMESTAMP AS last_refresh_date
   FROM dwh.cht_data d
     LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}'::text[]) = h.chw_id
  WHERE (d.doc ->> 'form'::text) = 'cebs_signal_report_vht'::text AND d.is_current
WITH DATA;

-- View indexes:
CREATE INDEX mv_cebs_signal_report_vht_eported ON cht.mv_cebs_signal_report_vht USING btree (reported) TABLESPACE ts_indexes;
CREATE INDEX mv_cebs_signal_report_vhtchw_is ON cht.mv_cebs_signal_report_vht USING btree (chw_id) TABLESPACE ts_indexes;
CREATE INDEX mv_cebs_signal_report_vht_year_month ON cht.mv_cebs_signal_report_vht USING btree (year, month) TABLESPACE ts_indexes;
CREATE INDEX mv_cebs_signal_report_vht_region_district_facility
ON cht.mv_cebs_signal_report_vht (region, district, facility_name) TABLESPACE ts_indexes;

CREATE INDEX mv_cebs_signal_report_vht_district
ON cht.mv_cebs_signal_report_vht (district) TABLESPACE ts_indexes;

CREATE INDEX mv_cebs_signal_report_vht_district_facility
ON cht.mv_cebs_signal_report_vht (district, facility_name) TABLESPACE ts_indexes;

-- High-impact (MOST IMPORTANT)
CREATE INDEX mv_cebs_signal_report_vht_year_month_district
ON cht.mv_cebs_signal_report_vht (year, month, district) TABLESPACE ts_indexes;