-- Drop the existing materialized view if it exists
DROP MATERIALIZED VIEW IF EXISTS cht.mv_form_meta;

-- Create the updated materialized view cht.mv_form_meta
-- Includes the four original columns (form_uuid, form_name, patient_id, reported)
-- Adds date-manipulated columns (date, year, month, monthname)
-- Adds contact_id for the join
-- Adds the specified columns from cht.mv_chw_hierarchy via LEFT JOIN on contact_id = chw_id

CREATE MATERIALIZED VIEW cht.mv_form_meta
TABLESPACE ts_report
AS
SELECT
    -- Original columns from form metadata
    cht.doc ->> '_id' AS form_uuid,
    cht.doc ->> 'form' AS form_name,
    COALESCE(cht.doc ->> 'patient_id', cht.doc #>> '{fields,patient_id}') AS patient_id,
    to_timestamp((NULLIF(cht.doc ->> 'reported_date'::text, ''::text)::bigint / 1000)::double precision) AS reported,
    to_char(to_timestamp((((cht.doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'YYYY-MM-DD'::text)::date AS date,
    to_char(to_timestamp((((cht.doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'YYYY'::text)::integer AS year,
    to_char(to_timestamp((((cht.doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'MM'::text)::integer AS month,
    to_char(to_timestamp((((cht.doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'FMMonth'::text) AS monthname,
    
    -- Contact ID for joining
    cht.doc #>> '{contact,_id}' AS contact_id,
    
    -- Columns from cht.mv_chw_hierarchy
    h.username,
    h.chw_name,
    h.phone,
    h.email,
    h.role,
    h.vht_area_name,
    h.village,
    h.parish,
    h.facility_name,
    h.dhis2_facility_id,
    h.district,
    h.region,
    
    -- Optional: Add a refresh timestamp for tracking
    CURRENT_TIMESTAMP AS last_refresh_date
FROM dwh.cht_data cht
LEFT JOIN cht.mv_chw_hierarchy h ON cht.doc #>> '{contact,_id}' = h.chw_id
WHERE cht.is_current = true 
  AND cht.doc ->> 'type' = 'data_record' 
  AND cht.doc ? 'form' 
  AND cht.doc #>> '{contact,_id}' IS NOT NULL
WITH DATA;

-- Create indexes on the updated MV for query performance
-- Prioritizing the most used columns: date, month, monthname, and district (alongside existing ones for completeness)

-- Index on date for date-based filtering/queries
CREATE INDEX idx_form_meta_date ON cht.mv_form_meta (date);

-- Index on month for monthly aggregations/filtering
CREATE INDEX idx_form_meta_month ON cht.mv_form_meta (month);

-- Index on monthname for month name-based queries (e.g., 'January')
CREATE INDEX idx_form_meta_monthname ON cht.mv_form_meta (monthname);

-- Index on district for hierarchical/district-based queries (already suggested, but included as requested)
CREATE INDEX idx_form_meta_district ON cht.mv_form_meta (district);

-- Additional indexes for completeness (from previous suggestions)
-- Index on form_name for filtering by form type
CREATE INDEX idx_form_meta_form_name ON cht.mv_form_meta (form_name);

-- Index on role for filtering by CHW role
CREATE INDEX idx_form_meta_role ON cht.mv_form_meta (role);

-- Index on reported for time-based queries
CREATE INDEX idx_form_meta_reported ON cht.mv_form_meta (reported);