CREATE MATERIALIZED VIEW cht.mv_child_health_notification
TABLESPACE ts_report
AS
SELECT
 -- indentifiers
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
     doc ->> 'form'::text                             AS  form,
     doc ->> 'from'::text                             AS  from,
     
      doc #>> '{fields,dob}'::text[]                                     AS dob,
      doc #>> '{fields,inputs,contact,_id}'::text[]                      AS contact_id,
      doc #>> '{fields,inputs,contact,date_of_birth}'::text[]            AS contact_date_of_birth,
      doc #>> '{fields,inputs,contact,name}'::text[]                     AS contact_name,
      doc #>> '{fields,inputs,contact,sex}'::text[]                      AS contact_sex,
      doc #>> '{fields,inputs,source}'::text[]                           AS source,
      doc #>> '{fields,inputs,source_id}'::text[]                        AS source_id,
      doc #>> '{fields,inputs,t_patient_condition}'::text[]              AS t_patient_condition,
      doc #>> '{fields,inputs,t_patient_date_of_birth}'::text[]          AS t_patient_date_of_birth,
      doc #>> '{fields,inputs,t_patient_gender}'::text[]                 AS t_patient_gender,
      doc #>> '{fields,inputs,t_patient_id}'::text[]                     AS t_patient_id,
      doc #>> '{fields,inputs,t_patient_name}'::text[]                   AS t_patient_name,
      doc #>> '{fields,inputs,t_place_name}'::text[]                     AS t_place_name,
      doc #>> '{fields,inputs,t_vht_name}'::text[]                       AS t_vht_name,
      doc #>> '{fields,inputs,t_vht_phone}'::text[]                      AS t_vht_phone,
      doc #>> '{fields,inputs,user,contact_id}'::text[]                  AS user_contact_id,
      doc #>> '{fields,inputs,user,facility_id}'::text[]                 AS user_facility_id,
      doc #>> '{fields,needs_signoff}'::text[]                           AS needs_signoff,
      doc #>> '{fields,patient_age_display}'::text[]                     AS patient_age_display,
      doc #>> '{fields,patient_age_in_days}'::text[]                     AS patient_age_in_days,
      doc #>> '{fields,patient_age_in_months}'::text[]                   AS patient_age_in_months,
      doc #>> '{fields,patient_age_in_years}'::text[]                    AS patient_age_in_years,
      doc #>> '{fields,patient_gender}'::text[]                          AS patient_gender,
      doc #>> '{fields,patient_id}'::text[]                              AS patient_id,
      doc #>> '{fields,patient_name}'::text[]                            AS patient_name,
      doc #>> '{fields,referral_details_note}'::text[]                   AS referral_details_note,

      doc #>> '{fields,referral_details,health_note}'               AS health_note,           
      doc #>> '{fields,danger_sign_check,follow_up_child}'               AS follow_up_child,           
      doc #>> '{fields,danger_sign_check,client_condition}'               AS client_condition,            
      
      doc #>> '{fields,referral,taken_to_facility}'::text[]             AS taken_to_facility,
      doc #>> '{fields,referral,refer_to_facility}'::text[]            AS refer_to_facility,
      doc #>> '{fields,referral,confirm_refer_to_facility}'::text[]    AS confirm_refer_to_facility,
 
      doc #>> '{fields,health_education,select_health_condition}'::text[] AS select_health_condition,
      doc #>> '{fields,group_patient_summary,s_note_patient_details}'::text[]            AS s_note_patient_details,
      doc #>> '{fields,group_patient_summary,s_note_patient_details_values}'::text[]     AS s_note_patient_details_values,
      doc #>> '{fields,group_patient_summary,child_condition}'::text[]                   AS child_condition,
      doc #>> '{fields,group_patient_summary,patient_health_improving}'::text[]          AS patient_health_improving,
      doc #>> '{fields,group_patient_summary,patient_health_getting_worse}'::text[]      AS patient_health_getting_worse,
      doc #>> '{fields,group_patient_summary,patient_health_no_change}'::text[]          AS patient_health_no_change,
      doc #>> '{fields,group_patient_summary,referral}'::text[]                          AS referral,
      doc #>> '{fields,group_patient_summary,refer_for_danger_sign_management}'::text[]  AS refer_for_danger_sign_management,
      doc #>> '{fields,group_patient_summary,instruction}'::text[]                       AS instruction,
      doc #>> '{fields,group_patient_summary,please_submit_this_form}'::text[]           AS please_submit_this_form,

      --- reporting hierarchy
      doc #>> '{contact,_id}'                         AS chw_id,                   
      doc #>> '{contact,parent,_id}'                  AS chw_area_id,  
      doc #>> '{contact,parent,parent,_id}'           AS facility_id,                                    
      doc #>> '{contact,parent,parent,parent,_id}'    AS district,              
      doc #>> '{contact,parent,parent,parent,parent,_id}'           AS region                 

FROM dwh.cht_data couchdb
WHERE (doc ->> 'form'::text) = 'child_health_notification'::text
  AND is_current
WITH DATA;


-- additional indexes
CREATE INDEX useview_child_health_notification_reported
    ON cht.mv_child_health_notification USING btree (reported);

