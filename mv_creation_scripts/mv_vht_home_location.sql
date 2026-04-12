CREATE MATERIALIZED VIEW cht.mv_vht_home_location
TABLESPACE ts_report
AS
SELECT
    -- Standard fields (appear in all forms)
    doc ->> '_id'::text AS uuid,
    doc ->> 'form'::text AS form,
    doc ->> 'from'::text AS submitter,
    to_timestamp((NULLIF(doc ->> 'reported_date'::text, ''::text)::bigint / 1000)::double precision) AS reported,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY-MM-DD'))::date AS date,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY'))::INT AS year,
    TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'FMMonth') AS month,
    doc ->'fields'->'meta'->>'instanceID' AS instanceID,
    doc ->'fields'->'inputs'->'meta'->>'deprecatedID' AS deprecatedID,
    doc ->'geolocation'->>'code' AS geolocation_code,
    doc ->'geolocation'->>'message' AS geolocation_message,
    doc #>> '{contact,_id}'::text[] AS chw_id,
    doc #>> '{contact,parent,_id}'::text[] AS contact_chw_area_id,
    doc #>> '{contact,parent,parent,_id}'::text[] AS contact_facility_id,
    doc #>> '{contact,parent,parent,parent,_id}'::text[] AS parish_id,
    doc #>> '{contact,parent,parent,parent,parent,_id}'::text[] AS district_id,
    doc #>> '{contact,parent,parent,parent,parent,parent,_id}'::text[] AS region_id,

    -- Form-specific fields (from the XML)
    doc #>> '{fields,inputs,source}'::text[] AS inputs_source,
    doc #>> '{fields,inputs,source_id}'::text[] AS inputs_source_id,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    doc #>> '{fields,geolocation,latitude}'::text[] AS geolocation_latitude,
    doc #>> '{fields,geolocation,longitude}'::text[] AS geolocation_longitude,
    doc #>> '{fields,geolocation,altitude}'::text[] AS geolocation_altitude,
    doc #>> '{fields,geolocation,accuracy}'::text[] AS geolocation_accuracy,
    doc #>> '{fields,geolocation,want_to_capture_gps}'::text[] AS geolocation_want_to_capture_gps,
    doc #>> '{fields,geolocation,ensure_gps}'::text[] AS geolocation_ensure_gps,
    doc #>> '{fields,geolocation,gps}'::text[] AS geolocation_gps,
    doc #>> '{fields,geolocation,coordinates}'::text[] AS geolocation_coordinates,
    doc #>> '{fields,geolocation,additional_comments}'::text[] AS geolocation_additional_comments,
    doc #>> '{fields,geolocation,no_gps_reasons}'::text[] AS geolocation_no_gps_reasons,

    -- Last column for tracking refresh
    CURRENT_TIMESTAMP AS last_refresh_date

FROM dwh.cht_data couchdb
WHERE (doc ->> 'form'::text) = 'vht_home_location'::text
  AND is_current
WITH DATA;

-- Indexes
CREATE INDEX mv_vht_home_location_reported
    ON cht.mv_vht_home_location USING btree (reported);

CREATE INDEX mv_vht_home_location_chw_id
    ON cht.mv_vht_home_location USING btree (chw_id);