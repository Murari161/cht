select cht.deps_save_and_drop_dependencies('cht', 'mv_form_meta');
DROP MATERIALIZED VIEW IF EXISTS cht.mv_form_meta;
CREATE MATERIALIZED VIEW cht.mv_form_meta
TABLESPACE ts_report
AS SELECT cht.doc ->> '_id'::text AS form_uuid,
    cht.doc ->> 'form'::text AS form_name,
    COALESCE(cht.doc ->> 'patient_id'::text, cht.doc #>> '{fields,patient_id}'::text[]) AS patient_id,
    to_timestamp((NULLIF(cht.doc ->> 'reported_date'::text, ''::text)::bigint / 1000)::double precision) AS reported,
    to_char(to_timestamp((((cht.doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'YYYY-MM-DD'::text)::date AS date,
    to_char(to_timestamp((((cht.doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'YYYY'::text)::integer AS year,
    to_char(to_timestamp((((cht.doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'MM'::text)::integer AS month,
    to_char(to_timestamp((((cht.doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'FMMonth'::text) AS monthname,
    cht.doc #>> '{fields,inputs,contact,_id}' AS inputs_contact_id,
    cht.doc #>> '{contact,_id}'::text[] AS contact_id,
    coalesce(doc ->> 'created_by_doc', doc #>> '{fields,created_by_doc}') AS created_by_doc,
    h.chw_id,
    h.username,
    h.chw_name,
    h.phone,
    h.email,
    h.role,
    h.vht_area_name,
    h.village,
    h.parish,
    h.facility,
    h.dhis2_facility_id,
    h.district,
    h.region,
    CURRENT_TIMESTAMP AS last_refresh_date
   FROM dwh.cht_data cht
     LEFT JOIN cht.mv_chw_hierarchy h ON (cht.doc #>> '{contact,_id}'::text[]) = h.chw_id
  WHERE cht.is_current = true AND (cht.doc ->> 'type'::text) = 'data_record'::text AND cht.doc ? 'form'::text AND (cht.doc #>> '{contact,_id}'::text[]) IS NOT NULL
WITH DATA;

select cht.deps_restore_dependencies('cht', 'mv_form_meta');

-- View indexes:
-- #1: 68% coverage - Most important
CREATE INDEX CONCURRENTLY idx_form_meta_vht_full 
ON cht.mv_form_meta (role, year, month, district, facility);

-- #2: 83% cumulative - Choropleth/district queries  
CREATE INDEX CONCURRENTLY idx_form_meta_vht_district_time 
ON cht.mv_form_meta (role, year, month, district);

-- #3: 93% cumulative - JOIN performance
CREATE INDEX CONCURRENTLY idx_form_meta_vht_join 
ON cht.mv_form_meta (contact_id, role, year, month);

-- #4: 95%+ coverage - Pure time fallback
CREATE INDEX CONCURRENTLY idx_form_meta_vht_time 
ON cht.mv_form_meta (role, year, month);