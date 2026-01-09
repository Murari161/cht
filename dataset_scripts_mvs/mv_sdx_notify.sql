CREATE MATERIALIZED VIEW report.mv_sdx_notify
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

    doc #>> '{fields,inputs,source}'               AS source,
    doc #>> '{fields,inputs,source_id}'           AS source_id,
    doc #>> '{fields,inputs,vht_id}'              AS vht_id,
    doc #>> '{fields,inputs,vht_name}'            AS vht_name,
    doc #>> '{fields,inputs,child_name}'          AS child_name,
    doc #>> '{fields,inputs,hoh_name}'            AS hoh_name,
    doc #>> '{fields,inputs,hoh_phone}'           AS hoh_phone,
    doc #>> '{fields,inputs,child_dob}'           AS child_dob,
    doc #>> '{fields,inputs,child_age}'           AS child_age,
    doc #>> '{fields,inputs,child_sex}'           AS child_sex,
    doc #>> '{fields,inputs,location}'            AS location,
    doc #>> '{fields,inputs,risk_cat}'            AS risk_cat,
    doc #>> '{fields,inputs,num_followups}'       AS num_followups,
    doc #>> '{fields,inputs,discharge_facility}'  AS discharge_facility,
    doc #>> '{fields,inputs,discharge_ts}'        AS discharge_ts,
    doc #>> '{fields,inputs,fu_date_1}'           AS fu_date_1,
    doc #>> '{fields,inputs,fu_date_2}'           AS fu_date_2,
    doc #>> '{fields,inputs,fu_date_3}'           AS fu_date_3,
    doc #>> '{fields,inputs,diagnosis}'           AS diagnosis,
    doc #>> '{fields,inputs,sdx_id}'              AS sdx_id,
    doc #>> '{fields,inputs,contact,_id}'         AS contact_id,
    doc #>> '{fields,inputs,contact,patient_id}'  AS contact_patient_id,
    doc #>> '{fields,inputs,contact,name}'        AS contact_name,
   
    doc #>> '{fields,patient_id}'                                       AS fields_patient_id,
    doc #>> '{fields,patient_name}'                                     AS patient_name,

    doc #>> '{fields,notification,_id}'             AS notification__id,
    doc #>> '{fields,notification,header}'          AS notification_header,
    doc #>> '{fields,notification,intro}'           AS notification_intro,
    doc #>> '{fields,notification,name}'            AS notification_name,
    doc #>> '{fields,notification,info_header}'    AS notification_info_header,
    doc #>> '{fields,notification,info_name}'      AS notification_info_name,
    doc #>> '{fields,notification,info_dob}'       AS notification_info_dob,
    doc #>> '{fields,notification,info_location}'  AS notification_info_location,
    doc #>> '{fields,notification,info_hoh_name}'  AS notification_info_hoh_name,
    doc #>> '{fields,notification,info_hoh_phone}' AS notification_info_hoh_phone,
    doc #>> '{fields,notification,info_disch_fac}'  AS notification_info_disch_fac,
    doc #>> '{fields,notification,info_diagnosis}'  AS notification_info_diagnosis,
    doc #>> '{fields,notification,info_fu_date_1}'  AS notification_info_fu_date_1,
    doc #>> '{fields,notification,info_fu_date_2}'  AS notification_info_fu_date_2,
    doc #>> '{fields,notification,info_fu_date_3}'  AS notification_info_fu_date_3,
    doc #>> '{fields,notification,info_sdx_id}'     AS notification_info_sdx_id,

       --- reporting hierarchy
    doc #>> '{contact,_id}'                         AS chw_id,                   
    doc #>> '{contact,parent,_id}'                  AS chw_area_id,  
    doc #>> '{contact,parent,parent,_id}'           AS facility_id,                                    
    doc #>> '{contact,parent,parent,parent,_id}'    AS parish_id,              
    doc #>> '{contact,parent,parent,parent,parent,_id}'           AS district,                 
    doc #>> '{contact,parent,parent,parent,parent,parent,_id}'    AS region    

FROM dwh.cht_data AS couchdb
WHERE (doc ->> 'form') = 'sdx_notify'
  AND is_current
WITH DATA;

CREATE UNIQUE INDEX sdx_notify_uuid_idx
    ON report.mv_sdx_notify USING btree (uuid);

CREATE INDEX sdx_notify_reported_idx
    ON report.mv_sdx_notify USING btree (reported);
