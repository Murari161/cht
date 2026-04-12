CREATE MATERIALIZED VIEW report.mv_drowning
TABLESPACE ts_report
AS
SELECT
    doc ->> '_id'::text                              AS doc_id,
    doc ->> '_rev'::text                             AS rev,                                 -- [NEW FIELD]
    to_timestamp((NULLIF(doc ->> 'reported_date'::text, ''::text)::bigint / 1000)::double precision) AS reported,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY-MM-DD'))::date AS date,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY'))::INT AS year,
    TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'FMMonth') AS month,
    doc ->'fields'->'meta'->>'instanceID' AS instanceID,
    doc ->'fields'->'inputs'->'meta'->>'deprecatedID' AS deprecatedID,
    doc ->'fields'->'inputs'->'meta'->'location'->>'lat' AS location_lat,
    doc ->'fields'->'inputs'->'meta'->'location'->>'long' AS location_long,
    doc ->'fields'->'inputs'->'meta'->'location'->>'error' AS location_error,
    doc ->'fields'->'inputs'->'meta'->'location'->>'message' AS location_message,
    doc ->'geolocation'->>'code' AS geolocation_code,
    doc ->'geolocation'->>'message' AS geolocation_message,
    doc ->> 'from'::text                             AS  from,
  
    doc #>> '{fields,inputs,source}'::text[]          AS source,
    doc #>> '{fields,inputs,source_id}'::text[]       AS source_id,
    doc #>> '{fields,inputs,contact,_id}'::text[]     AS contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[]    AS contact_name,
    doc #>> '{fields,inputs,patient_id}'::text[]      AS patient_id,
    doc #>> '{fields,inputs,contact_name}'::text[]    AS contact_name_input

    doc #>> '{fields,incident,date}'::text[]        AS date,
    doc #>> '{fields,incident,time}'::text[]        AS time,
    doc #>> '{fields,incident,waterbody}'::text[]   AS waterbody,
    doc #>> '{fields,incident,type}'::text[]        AS type,

    doc #>> '{fields,risk,activity}'::text[]        AS activity,
    doc #>> '{fields,risk,cause}'::text[]           AS cause,
    doc #>> '{fields,risk,supervision}'::text[]     AS supervision,
    doc #>> '{fields,risk,victim}'::text[]          AS victim,
    doc #>> '{fields,risk,intoxicated}'::text[]     AS intoxicated,

    doc #>> '{fields,rescue,attempts}'::text[]       AS attempts,
    doc #>> '{fields,rescue,firstaid}'::text[]       AS firstaid,
    doc #>> '{fields,drowning,outcome}'::text[]       AS outcome,


    --- reporting hierarchy
    doc #>> '{contact,_id}'                         AS chw_id,                   
    doc #>> '{contact,parent,_id}'                  AS chw_area_id,  
    doc #>> '{contact,parent,parent,_id}'           AS facility_id,                                    
    doc #>> '{contact,parent,parent,parent,_id}'    AS parish_id,              
    doc #>> '{contact,parent,parent,parent,parent,_id}'           AS district,                 
    doc #>> '{contact,parent,parent,parent,parent,parent,_id}'    AS region    


FROM dwh.cht_data AS couchdb
WHERE (doc ->> 'form') = 'drowning_workflow'
  AND is_current
WITH DATA;

CREATE UNIQUE INDEX screening_uuid_idx
    ON report.mv_drowning USING btree (uuid);

CREATE INDEX screening_reported_idx
    ON report.mv_drowning USING btree (reported);
