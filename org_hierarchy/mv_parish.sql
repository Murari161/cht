-- cht.mv_parish source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_parish;
CREATE MATERIALIZED VIEW cht.mv_parish
TABLESPACE ts_report
AS SELECT doc ->> '_id'::text AS uuid,
    doc ->> 'name'::text AS parish_name,
    doc ->> 'contact_type'::text AS contact_type,
    doc ->> 'type'::text AS type,
    doc ->> 'notes'::text AS notes,
    to_timestamp((NULLIF(doc ->> 'reported_date'::text, ''::text)::bigint / 1000)::double precision) AS reported,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY-MM-DD'))::date AS date,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY'))::INT AS year,
    to_char(to_timestamp((((doc ->>'reported_date'::text)::bigint) / 1000)::double precision), 'MM'::text)::integer AS month,
    TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'FMMonth') AS monthname,
    NULLIF(doc ->> 'imported_date'::text, ''::text)::timestamptz AS imported_date,
    doc #>> '{parent,_id}'::text[] AS facility_id,
    doc #>> '{parent,parent,_id}'::text[] AS district_id,
    doc #>> '{parent,parent,parent,_id}'::text[] AS region_id,
    (doc -> 'meta'::text) ->> 'created_by'::text AS meta_created_by,
    (doc -> 'meta'::text) ->> 'created_by_place_uuid'::text AS meta_created_by_place_uuid,
    (doc -> 'meta'::text) ->> 'created_by_person_uuid'::text AS meta_created_by_person_uuid,
    (doc -> 'form_version'::text) ->> 'time'::text AS form_version_time,
    (doc -> 'form_version'::text) ->> 'sha256'::text AS form_version_sha256,
    CURRENT_TIMESTAMP AS last_refresh_date
   FROM dwh.cht_data
  WHERE (doc ->> 'contact_type'::text) = 'c40-parish'::text AND is_current
WITH DATA;

-- View indexes:
CREATE INDEX idx_mv_parish_uuid ON cht.mv_parish USING btree (uuid) tablespace ts_indexes;
CREATE INDEX idx_mv_parish_name ON cht.mv_parish USING btree (parish_name) tablespace ts_indexes;
CREATE INDEX idx_mv_parish_facility_id ON cht.mv_parish USING btree (facility_id) tablespace ts_indexes;
CREATE INDEX idx_mv_parish_district_id ON cht.mv_parish USING btree (district_id) tablespace ts_indexes;
CREATE INDEX idx_mv_parish_region_id ON cht.mv_parish USING btree (region_id) tablespace ts_indexes;
CREATE INDEX idx_mv_parish_reported ON cht.mv_parish USING btree (reported) tablespace ts_indexes;
CREATE INDEX idx_mv_parish_year_month ON cht.mv_parish USING btree (year, month) tablespace ts_indexes;
