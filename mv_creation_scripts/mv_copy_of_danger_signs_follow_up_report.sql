-- cht.mv_copy_of_danger_signs_follow_up_report source
DROP MATERIALIZED VIEW cht.mv_copy_of_danger_signs_follow_up_report;
CREATE MATERIALIZED VIEW cht.mv_copy_of_danger_signs_follow_up_report
TABLESPACE ts_report
AS SELECT doc ->> '_id'::text AS id,
    doc ->> '_rev'::text AS rev,
    doc ->> '_form'::text AS form,
    doc ->> 'type'::text AS type,
    to_timestamp((NULLIF(doc ->> 'reported_date'::text, ''::text)::bigint / 1000)::double precision) AS reported,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY-MM-DD'))::date AS date,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY'))::INT AS year,
    to_char(to_timestamp((((doc ->>'reported_date'::text)::bigint) / 1000)::double precision), 'MM'::text)::integer AS month,
    TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'FMMonth') AS monthname,
    (((doc -> 'field'::text) -> 'inputs'::text) -> 'contact'::text) -> '_id'::text AS inputs_contact_id,
    (((doc -> 'field'::text) -> 'inputs'::text) -> 'contact'::text) -> 'name'::text AS name,
    (doc -> 'field'::text) ->> 'source'::text AS source,
    (doc -> 'field'::text) ->> 'place_id'::text AS place_id,
    (doc -> 'field'::text) ->> 'vht_name'::text AS vht_name,
    (doc -> 'field'::text) ->> 'client_id'::text AS client_id,
    (doc -> 'field'::text) ->> 'source_id'::text AS source_id,
    (doc -> 'field'::text) ->> 'vht_phone'::text AS vht_phone,
    (doc -> 'field'::text) ->> 'place_name'::text AS place_name,
    (doc -> 'field'::text) ->> 'client_name'::text AS client_name,
    (doc -> 'field'::text) ->> 'created_by_doc'::text AS created_by_doc,
    (doc -> 'field'::text) ->> 'completed_referral'::text AS completed_referral,
    (doc -> 'field'::text) ->> 'still_has_danger_signs'::text AS still_has_danger_signs,
    (doc -> 'parent'::text) ->> '_id'::text AS parent_id,
    (doc -> 'contact'::text) ->> '_id'::text AS contact_id,
    ((doc -> 'geolocation'::text) ->> 'speed'::text)::numeric AS speed,
    (doc -> 'geolocation'::text) ->> 'heading'::text AS heading,
    ((doc -> 'geolocation'::text) ->> 'accuracy'::text)::numeric AS accuracy,
    ((doc -> 'geolocation'::text) ->> 'altitude'::text)::numeric AS altitude,
    ((doc -> 'geolocation'::text) ->> 'latitude'::text)::numeric AS latitude,
    ((doc -> 'geolocation'::text) ->> 'longitude'::text)::numeric AS longitude,
    ((doc -> 'geolocation'::text) ->> 'altitudeAccuracy'::text)::numeric AS altitudeaccuracy,
    doc ->> 'content_type'::text AS content_type,
    doc ->> 'reported_date'::text AS reported_date,
    (doc -> 'geolocation_log'::text) ->> 'timestamp'::text AS "timestamp",
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility_name,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date
   FROM dwh.cht_data
LEFT JOIN cht.mv_chw_hierarchy h ON (dwh.cht_data.doc #>> '{contact,_id}') = h.chw_id
  WHERE type = 'data_record'::text AND (doc ->> 'form'::text) = 'copy_of_danger_signs_follow_up_report'::text
WITH DATA;

-- View indexes:
CREATE INDEX idx_mv_danger_followup_contact_id ON cht.mv_copy_of_danger_signs_follow_up_report USING btree (contact_id) tablespace ts_indexes;
CREATE INDEX idx_mv_danger_followup_parent_id ON cht.mv_copy_of_danger_signs_follow_up_report USING btree (parent_id) tablespace ts_indexes;
CREATE INDEX idx_mv_danger_followup_reported_date ON cht.mv_copy_of_danger_signs_follow_up_report USING btree (reported_date) tablespace ts_indexes;
CREATE INDEX idx_mv_danger_followup_chw_id ON cht.mv_copy_of_danger_signs_follow_up_report USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX idx_mv_danger_followup_year_month ON cht.mv_copy_of_danger_signs_follow_up_report USING btree (year, month) tablespace ts_indexes;