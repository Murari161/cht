-- cht.mv_region source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_region;
CREATE MATERIALIZED VIEW cht.mv_region
TABLESPACE ts_report
AS SELECT doc ->> '_id'::text AS uuid,
    doc ->> 'name'::text AS region_name,
    doc ->> 'contact_type'::text AS contact_type,
    doc ->> 'type'::text AS type,
    to_timestamp((NULLIF(doc ->> 'reported_date'::text, ''::text)::bigint / 1000)::double precision) AS reported,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY-MM-DD'))::date AS date,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY'))::INT AS year,
    to_char(to_timestamp((((doc ->>'reported_date'::text)::bigint) / 1000)::double precision), 'MM'::text)::integer AS month,
    TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'FMMonth') AS monthname,
    NULLIF(doc ->> 'imported_date'::text, ''::text)::timestamptz AS imported_date,
    (doc -> 'meta'::text) ->> 'created_by'::text AS meta_created_by,
    (doc -> 'meta'::text) ->> 'created_by_place_uuid'::text AS meta_created_by_place_uuid,
    (doc -> 'meta'::text) ->> 'created_by_person_uuid'::text AS meta_created_by_person_uuid,
    CURRENT_TIMESTAMP AS last_refresh_date
   FROM dwh.cht_data
  WHERE (doc ->> 'contact_type'::text) = 'c10-region'::text AND is_current
WITH DATA;

-- View indexes:
CREATE INDEX idx_mv_region_uuid ON cht.mv_region USING btree (uuid) tablespace ts_indexes;
CREATE INDEX idx_mv_region_name ON cht.mv_region USING btree (region_name) tablespace ts_indexes;
CREATE INDEX idx_mv_region_reported ON cht.mv_region USING btree (reported) tablespace ts_indexes;
CREATE INDEX idx_mv_region_year_month ON cht.mv_region USING btree (year, month) tablespace ts_indexes;
