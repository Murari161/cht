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
    cht.doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    cht.doc #>> '{contact,_id}'::text[] AS contact_id,
    cht.doc #>> '{contact,parent,_id}'::text[] AS reported_by_parent,   -- ADDED for 097b (CHW area UUID)
    COALESCE(cht.doc ->> 'created_by_doc'::text, cht.doc #>> '{fields,created_by_doc}'::text[]) AS created_by_doc,
    h.chw_id, h.username, h.chw_name, h.phone, h.email, h.role,
    h.vht_area_name, h.village, h.parish, h.facility, h.dhis2_facility_id, h.district, h.region,
    CURRENT_TIMESTAMP AS last_refresh_date
   FROM dwh.cht_data cht
     LEFT JOIN cht.mv_chw_hierarchy h ON (cht.doc #>> '{contact,_id}'::text[]) = h.chw_id
  WHERE cht.is_current = true
    AND (cht.doc ->> 'type'::text) = 'data_record'::text
    AND cht.doc ? 'form'::text
    AND (cht.doc #>> '{contact,_id}'::text[]) IS NOT NULL
WITH DATA;

CREATE INDEX idx_form_meta_vht_district_time ON cht.mv_form_meta USING btree (role, year, month, district);
CREATE INDEX idx_form_meta_vht_full ON cht.mv_form_meta USING btree (role, year, month, district, facility);
CREATE INDEX idx_form_meta_vht_join ON cht.mv_form_meta USING btree (contact_id, role, year, month);
CREATE INDEX idx_form_meta_vht_time ON cht.mv_form_meta USING btree (role, year, month);
CREATE INDEX mv_form_meta_year_month_idx ON cht.mv_form_meta USING btree (year, month);
CREATE INDEX mv_form_meta_patient_id ON cht.mv_form_meta USING btree (patient_id) TABLESPACE ts_indexes;
CREATE INDEX mv_form_meta_reported ON cht.mv_form_meta USING btree (reported) TABLESPACE ts_indexes;
CREATE INDEX mv_form_meta_reported_by_parent ON cht.mv_form_meta USING btree (reported_by_parent) TABLESPACE ts_indexes;