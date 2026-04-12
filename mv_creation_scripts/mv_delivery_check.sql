CREATE MATERIALIZED VIEW cht.mv_delivery_check
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

    doc #>> '{fields,inputs,source}'::text[]                 AS source,
    doc #>> '{fields,inputs,source_id}'::text[]              AS source_id,
    doc #>> '{fields,inputs,contact,_id}'::text[]            AS contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[]           AS contact_name,
    doc #>> '{fields,inputs,contact,date_of_birth}'::text[]  AS contact_date_of_birth,
    doc #>> '{fields,inputs,contact,sex}'::text[]            AS contact_sex,
    doc #>> '{fields,inputs,contact,parent,_id}'::text[]     AS parent_id,
    doc #>> '{fields,is_of_child_bearing_age}'::text[]       AS is_of_child_bearing_age,
    doc #>> '{fields,patient_age_in_years}'::text[]          AS patient_age_in_years,
    doc #>> '{fields,patient_age_in_months}'::text[]         AS patient_age_in_months,
    doc #>> '{fields,patient_age_in_days}'::text[]           AS patient_age_in_days,
    doc #>> '{fields,patient_age_display}'::text[]           AS patient_age_display,
    doc #>> '{fields,patient_id}'::text[]                    AS patient_id,
    doc #>> '{fields,patient_name}'::text[]                  AS patient_name,
    doc #>> '{fields,patient_gender}'::text[]                AS patient_gender,

    doc #>> '{fields,group_pregnancy_status,has_delivered}'::text[]        AS has_delivered,
    doc #>> '{fields,group_pregnancy_status,note_complete_delivery_form}'::text[]        AS note_complete_delivery_form,

    --- reporting hierarchy
    doc #>> '{contact,_id}'                         AS chw_id,                   
    doc #>> '{contact,parent,_id}'                  AS chw_area_id,  
    doc #>> '{contact,parent,parent,_id}'           AS facility_id,                                    
    doc #>> '{contact,parent,parent,parent,_id}'    AS parish_id,              
    doc #>> '{contact,parent,parent,parent,parent,_id}'           AS district,                 
    doc #>> '{contact,parent,parent,parent,parent,parent,_id}'    AS region,
    CURRENT_TIMESTAMP as last_refresh_date


FROM dwh.cht_data
WHERE (doc ->> 'form') = 'delivery_check'
  AND is_current
WITH DATA;

CREATE INDEX delivery_reported_idx
    ON cht.mv_delivery_check USING btree (reported);
