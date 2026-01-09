CREATE MATERIALIZED VIEW report.mv_sdx_trigger
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

    doc #>> '{fields,inputs,source}'                                    AS source,
    doc #>> '{fields,inputs,source_id}'                                 AS source_id,
    doc #>> '{fields,inputs,contact,_id}'                               AS contact_id,
    doc #>> '{fields,inputs,contact,vht_id}'                            AS vht_id,
    doc #>> '{fields,inputs,contact,name}'                              AS contact_name,
    doc #>> '{fields,patient_id}'               AS patient_id,
    doc #>> '{fields,patient_name}'             AS patient_name,
    doc #>> '{fields,child_name}'               AS child_name,
    doc #>> '{fields,hoh_name}'                 AS hoh_name,
    doc #>> '{fields,hoh_phone}'                AS hoh_phone,
    doc #>> '{fields,child_age}'                AS child_age,
    doc #>> '{fields,child_dob}'                AS child_dob,
    doc #>> '{fields,child_sex}'                AS child_sex,
    doc #>> '{fields,location}'                 AS location,
    doc #>> '{fields,risk_cat}'                 AS risk_cat,
    doc #>> '{fields,num_followups}'            AS num_followups,
    doc #>> '{fields,discharge_facility}'       AS discharge_facility,
    doc #>> '{fields,discharge_ts}'             AS discharge_ts,
    doc #>> '{fields,fu_date_1}'                AS fu_date_1,
    doc #>> '{fields,fu_date_2}'                AS fu_date_2,
    doc #>> '{fields,fu_date_3}'                AS fu_date_3,
    doc #>> '{fields,diagnosis}'                AS diagnosis,
    doc #>> '{fields,sdx_id}'                   AS sdx_id,
    
    doc #>> '{contact,_id}'                         AS chw_id,                   
    doc #>> '{contact,parent,_id}'                  AS chw_area_id,  
    doc #>> '{contact,parent,parent,_id}'           AS facility_id,                                    
    doc #>> '{contact,parent,parent,parent,_id}'    AS parish_id,              
    doc #>> '{contact,parent,parent,parent,parent,_id}'           AS district,                 
    doc #>> '{contact,parent,parent,parent,parent,parent,_id}'    AS region    

FROM dwh.cht_data AS couchdb
WHERE (doc ->> 'form') = 'sdx_trigger'
  AND is_current
WITH DATA;

CREATE UNIQUE INDEX sdx_trigger_uuid_idx
    ON report.mv_sdx_trigger USING btree (uuid);

CREATE INDEX sdx_trigger_reported_idx
    ON report.mv_sdx_trigger USING btree (reported);
