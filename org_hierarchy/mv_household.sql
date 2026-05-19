-- cht.mv_household source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_household;
CREATE MATERIALIZED VIEW cht.mv_household
TABLESPACE ts_report
AS SELECT doc ->> '_id'::text AS uuid,
    doc ->> 'name'::text AS household_name,
    doc ->> 'contact_type'::text AS contact_type,
    doc ->> 'type'::text AS type,
    NULLIF(doc ->> 'muted'::text, ''::text)::timestamptz AS muted,
    NULLIF(doc ->> 'geolocation'::text, ''::text) AS geolocation,
    to_timestamp((NULLIF(doc ->> 'reported_date'::text, ''::text)::bigint / 1000)::double precision) AS reported,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY-MM-DD'))::date AS date,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY'))::INT AS year,
    to_char(to_timestamp((((doc ->>'reported_date'::text)::bigint) / 1000)::double precision), 'MM'::text)::integer AS month,
    TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'FMMonth') AS monthname,
    NULLIF(doc ->> 'imported_date'::text, ''::text)::timestamptz AS imported_date,
    (doc -> 'contact'::text) ->> '_id'::text AS contact_id,
    doc #>> '{parent,_id}'::text[] AS health_center_id,
    doc #>> '{parent,parent,_id}'::text[] AS parish_id,
    doc #>> '{parent,parent,parent,_id}'::text[] AS facility_id,
    doc #>> '{parent,parent,parent,parent,_id}'::text[] AS district_id,
    doc #>> '{parent,parent,parent,parent,parent,_id}'::text[] AS region_id,
    (doc -> 'meta'::text) ->> 'created_by'::text AS meta_created_by,
    (doc -> 'meta'::text) ->> 'created_by_place_uuid'::text AS meta_created_by_place_uuid,
    (doc -> 'meta'::text) ->> 'created_by_person_uuid'::text AS meta_created_by_person_uuid,
    CURRENT_TIMESTAMP AS last_refresh_date
   FROM dwh.cht_data
  WHERE (doc ->> 'contact_type'::text) = 'c60-clinic'::text AND is_current
WITH DATA;

-- View indexes:
CREATE INDEX idx_mv_household_uuid ON cht.mv_household USING btree (uuid) tablespace ts_indexes;
CREATE INDEX idx_mv_household_name ON cht.mv_household USING btree (household_name) tablespace ts_indexes;
CREATE INDEX idx_mv_household_contact_id ON cht.mv_household USING btree (contact_id) tablespace ts_indexes;
CREATE INDEX idx_mv_household_health_center_id ON cht.mv_household USING btree (health_center_id) tablespace ts_indexes;
CREATE INDEX idx_mv_household_parish_id ON cht.mv_household USING btree (parish_id) tablespace ts_indexes;
CREATE INDEX idx_mv_household_facility_id ON cht.mv_household USING btree (facility_id) tablespace ts_indexes;
CREATE INDEX idx_mv_household_district_id ON cht.mv_household USING btree (district_id) tablespace ts_indexes;
CREATE INDEX idx_mv_household_region_id ON cht.mv_household USING btree (region_id) tablespace ts_indexes;
CREATE INDEX idx_mv_household_reported ON cht.mv_household USING btree (reported) tablespace ts_indexes;
CREATE INDEX idx_mv_household_year_month ON cht.mv_household USING btree (year, month) tablespace ts_indexes;
