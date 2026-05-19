-- cht.mv_health_center source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_health_center;
CREATE MATERIALIZED VIEW cht.mv_health_center
TABLESPACE ts_report
AS SELECT doc ->> '_id'::text AS uuid,
    doc ->> 'name'::text AS health_center_name,
    doc ->> 'contact_type'::text AS contact_type,
    doc ->> 'type'::text AS type,
    doc ->> 'county'::text AS county,
    doc ->> 'sub_county'::text AS sub_county,
    doc ->> 'village'::text AS village,
    doc ->> 'parish'::text AS parish,
    doc ->> 'district'::text AS district,
    to_timestamp((NULLIF(doc ->> 'reported_date'::text, ''::text)::bigint / 1000)::double precision) AS reported,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY-MM-DD'))::date AS date,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY'))::INT AS year,
    to_char(to_timestamp((((doc ->>'reported_date'::text)::bigint) / 1000)::double precision), 'MM'::text)::integer AS month,
    TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'FMMonth') AS monthname,
    NULLIF(doc ->> 'imported_date'::text, ''::text)::timestamptz AS imported_date,
    (doc -> 'contact'::text) ->> '_id'::text AS contact_id,
    doc #>> '{parent,_id}'::text[] AS parish_id,
    doc #>> '{parent,parent,_id}'::text[] AS facility_id,
    doc #>> '{parent,parent,parent,_id}'::text[] AS district_id,
    doc #>> '{parent,parent,parent,parent,_id}'::text[] AS region_id,
    (doc -> 'meta'::text) ->> 'created_by'::text AS meta_created_by,
    (doc -> 'meta'::text) ->> 'created_by_place_uuid'::text AS meta_created_by_place_uuid,
    (doc -> 'meta'::text) ->> 'created_by_person_uuid'::text AS meta_created_by_person_uuid,
    CURRENT_TIMESTAMP AS last_refresh_date
   FROM dwh.cht_data
  WHERE (doc ->> 'contact_type'::text) = 'c50-health_center'::text AND is_current
WITH DATA;

-- View indexes:
CREATE INDEX idx_mv_health_center_uuid ON cht.mv_health_center USING btree (uuid) tablespace ts_indexes;
CREATE INDEX idx_mv_health_center_name ON cht.mv_health_center USING btree (health_center_name) tablespace ts_indexes;
CREATE INDEX idx_mv_health_center_contact_id ON cht.mv_health_center USING btree (contact_id) tablespace ts_indexes;
CREATE INDEX idx_mv_health_center_parish_id ON cht.mv_health_center USING btree (parish_id) tablespace ts_indexes;
CREATE INDEX idx_mv_health_center_facility_id ON cht.mv_health_center USING btree (facility_id) tablespace ts_indexes;
CREATE INDEX idx_mv_health_center_district_id ON cht.mv_health_center USING btree (district_id) tablespace ts_indexes;
CREATE INDEX idx_mv_health_center_region_id ON cht.mv_health_center USING btree (region_id) tablespace ts_indexes;
CREATE INDEX idx_mv_health_center_reported ON cht.mv_health_center USING btree (reported) tablespace ts_indexes;
CREATE INDEX idx_mv_health_center_year_month ON cht.mv_health_center USING btree (year, month) tablespace ts_indexes;
