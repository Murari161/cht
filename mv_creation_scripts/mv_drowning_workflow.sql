drop materialized view if exists cht.mv_drowning_workflow;
CREATE MATERIALIZED VIEW cht.mv_drowning_workflow
TABLESPACE ts_report
AS
SELECT
    doc ->> '_id'::text                              AS doc_id,
    doc ->> '_rev'::text                             AS rev,                                 -- [NEW FIELD]
    to_timestamp((NULLIF(doc ->> 'reported_date'::text, ''::text)::bigint / 1000)::double precision) AS reported,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY-MM-DD'))::date AS date,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY'))::INT AS year,
    to_char(to_timestamp((((doc ->>'reported_date'::text)::bigint) / 1000)::double precision), 'MM'::text)::integer AS month,
    TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'FMMonth') AS monthname,
    doc ->'fields'->'meta'->>'instanceID' AS instanceID,
    doc ->'fields'->'inputs'->'meta'->>'deprecatedID' AS deprecatedID,
    doc ->'fields'->'inputs'->'meta'->'location'->>'lat' AS location_lat,
    doc ->'fields'->'inputs'->'meta'->'location'->>'long' AS location_long,
    doc ->'fields'->'inputs'->'meta'->'location'->>'error' AS location_error,
    doc ->'fields'->'inputs'->'meta'->'location'->>'message' AS location_message,
    doc ->'geolocation'->>'code' AS geolocation_code,
    doc ->'geolocation'->>'message' AS geolocation_message,
    (NULLIF((doc -> 'geolocation'::text) ->> 'latitude'::text, ''::text))::double precision AS geolocation_latitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'longitude'::text, ''::text))::double precision AS geolocation_longitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'accuracy'::text, ''::text))::double precision AS geolocation_accuracy,
    (NULLIF((doc -> 'geolocation'::text) ->> 'altitude'::text, ''::text))::double precision AS geolocation_altitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'altitudeAccuracy'::text, ''::text))::double precision AS geolocation_altitude_accuracy,
    (NULLIF((doc -> 'geolocation'::text) ->> 'speed'::text, ''::text))::double precision AS geolocation_speed,
    (NULLIF((doc -> 'geolocation'::text) ->> 'heading'::text, ''::text))::double precision AS geolocation_heading,
    doc ->> 'from'::text                             AS  from,
  
    doc #>> '{fields,inputs,source}'::text[]          AS source,
    doc #>> '{fields,inputs,source_id}'::text[]       AS source_id,
    doc #>> '{fields,inputs,contact,_id}'::text[]     AS inputs_contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[]    AS inputs_contact_name,
    doc #>> '{fields,inputs,patient_id}'::text[]      AS patient_id,
    doc #>> '{fields,inputs,contact_name}'::text[]    AS contact_name_input,

    doc #>> '{fields,incident,date}'::text[]        AS incident_date,
    doc #>> '{fields,incident,time}'::text[]        AS incident_time,
    doc #>> '{fields,incident,waterbody}'::text[]   AS incident_waterbody,
    doc #>> '{fields,incident,type}'::text[]        AS incident_type,

    doc #>> '{fields,risk,activity}'::text[]        AS risk_activity,
    doc #>> '{fields,risk,cause}'::text[]           AS risk_cause,
    doc #>> '{fields,risk,supervision}'::text[]     AS risk_supervision,
    doc #>> '{fields,risk,victim}'::text[]          AS risk_victim,
    doc #>> '{fields,risk,intoxicated}'::text[]     AS risk_intoxicated,

    doc #>> '{fields,rescue,attempts}'::text[]       AS rescue_attempts,
    doc #>> '{fields,rescue,firstaid}'::text[]       AS rescue_firstaid,
    doc #>> '{fields,drowning,outcome}'::text[]       AS outcome,


    --- reporting hierarchy
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date    


FROM dwh.cht_data AS couchdb
LEFT JOIN cht.mv_chw_hierarchy h ON (couchdb.doc #>> '{contact,_id}') = h.chw_id
WHERE (doc ->> 'form') = 'drowning_workflow'
  AND is_current
WITH NO DATA;

CREATE INDEX screening_reported_idx
    ON cht.mv_drowning_workflow USING btree (reported) tablespace ts_indexes;
CREATE INDEX mv_drowning_workflow_year_month_district
    ON cht.mv_drowning_workflow USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX screening_chw_id_idx
    ON cht.mv_drowning_workflow USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX screening_district_idx
    ON cht.mv_drowning_workflow USING btree (district) tablespace ts_indexes;
CREATE INDEX screening_region_idx
    ON cht.mv_drowning_workflow USING btree (region) tablespace ts_indexes;
