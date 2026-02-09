CREATE MATERIALIZED VIEW cht.mv_tb_uncompleted_referral
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
     doc #>> '{fields,inputs,t_tb_result}'                               AS t_tb_result,
     doc #>> '{fields,inputs,t_place_name}'                              AS t_place_name,
     doc #>> '{fields,inputs,t_patient_name}'                            AS t_patient_name,
     doc #>> '{fields,inputs,user,contact_id}'                           AS user_contact_id,
     doc #>> '{fields,inputs,user,facility_id}'                          AS user_facility_id,
     doc #>> '{fields,inputs,contact,_id}'                               AS contact_id,
     doc #>> '{fields,inputs,contact,name}'                              AS contact_name,
     doc #>> '{fields,inputs,contact,date_of_birth}'                     AS contact_date_of_birth,
     doc #>> '{fields,inputs,contact,sex}'                               AS contact_sex,
     doc #>> '{fields,patient_id}'                                       AS patient_id,
     doc #>> '{fields,patient_name}'                                     AS patient_name,
     doc #>> '{fields,tb_result}'                                        AS tb_result,
     doc #>> '{fields,place_name}'                                       AS place_name,
     doc #>> '{fields,needs_signoff}'                                    AS needs_signoff,
    
    doc #>> '{fields,referral_notification,generated_note_name_25}'  AS generated_note_name_25,
    doc #>> '{fields,referral_notification,referred_to_health_facility}'  AS referred_to_health_facility,

        --- reporting hierarchy
    doc #>> '{contact,_id}'                         AS chw_id,                   
    doc #>> '{contact,parent,_id}'                  AS chw_area_id,  
    doc #>> '{contact,parent,parent,_id}'           AS facility_id,                                    
    doc #>> '{contact,parent,parent,parent,_id}'    AS parish_id,              
    doc #>> '{contact,parent,parent,parent,parent,_id}'           AS district,                 
    doc #>> '{contact,parent,parent,parent,parent,parent,_id}'    AS region,
    CURRENT_TIMESTAMP                                 AS last_refresh_date  

FROM dwh.cht_data
WHERE (doc ->> 'form') = 'tb_uncompleted_referral'
  AND is_current
WITH DATA;

CREATE INDEX uncompleted_referral_reported_idx
    ON cht.mv_uncompleted_referral USING btree (reported);
