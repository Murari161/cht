CREATE MATERIALIZED VIEW cht.mv_drowning_workflow
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
    doc ->'fields'->'inputs'->'meta'->'location'->>'lat' AS location_lat,
    doc ->'fields'->'inputs'->'meta'->'location'->>'long' AS location_long,
    doc ->'fields'->'inputs'->'meta'->'location'->>'error' AS location_error,
    doc ->'fields'->'inputs'->'meta'->'location'->>'message' AS location_message,
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
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,contact_name}'::text[] AS contact_name,
    doc #>> '{fields,incident,date}'::text[] AS incident_date,
    doc #>> '{fields,incident,time}'::text[] AS incident_time,
    doc #>> '{fields,incident,waterbody}'::text[] AS incident_waterbody,
    doc #>> '{fields,incident,type}'::text[] AS incident_type,
    doc #>> '{fields,risk,activity}'::text[] AS risk_activity,
    doc #>> '{fields,risk,cause}'::text[] AS risk_cause,
    doc #>> '{fields,risk,supervision}'::text[] AS risk_supervision,
    doc #>> '{fields,risk,victim}'::text[] AS risk_victim,
    doc #>> '{fields,risk,intoxicated}'::text[] AS risk_intoxicated,
    doc #>> '{fields,rescue,attempts}'::text[] AS rescue_attempts,
    doc #>> '{fields,rescue,firstaid}'::text[] AS rescue_firstaid,
    doc #>> '{fields,drowning,outcome}'::text[] AS drowning_outcome,    
    users.fullname AS chew_full_names,
    users.role AS chw_role,

    -- Last column for tracking refresh
    CURRENT_TIMESTAMP AS last_refresh_date

FROM dwh.cht_data couchdb
JOIN cht.mv_cht_users users ON (couchdb.doc #>> '{fields,inputs,contact,_id}'::text[]) = users.contact_id
WHERE (doc ->> 'form'::text) = 'drowning_workflow'::text
  AND is_current
WITH DATA;

-- Indexes
CREATE INDEX mv_drowning_workflow_reported
    ON cht.mv_drowning_workflow USING btree (reported);

CREATE INDEX mv_drowning_workflow_chw_id
    ON cht.mv_drowning_workflow USING btree (chw_id);