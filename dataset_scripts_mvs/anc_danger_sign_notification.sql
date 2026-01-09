
CREATE MATERIALIZED VIEW cht.mv_anc_danger_sign_notification
TABLESPACE ts_report
AS SELECT doc ->> '_id'::text AS doc_id,
    doc ->> '_rev'::text                             AS rev,                                -- [NEW FIELD]
    doc ->> 'form'::text AS form,
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

    doc #>> '{fields,inputs,source}'::text[]    AS source,
    doc #>> '{fields,inputs,source_id}'::text[] AS source_id,
    doc #>> '{fields,inputs,t_place_name}'::text[]                        AS t_place_name,
    doc #>> '{fields,inputs,t_vht_name}'::text[]                          AS t_vht_name,
    doc #>> '{fields,inputs,t_vht_phone}'::text[]                         AS t_vht_phone,
    doc #>> '{fields,inputs,t_vaginal_bleeding}'::text[]                  AS t_vaginal_bleeding,
    doc #>> '{fields,inputs,t_lower_abdomen_pain}'::text[]                AS t_lower_abdomen_pain,
    doc #>> '{fields,inputs,t_severe_headache}'::text[]                   AS t_severe_headache,
    doc #>> '{fields,inputs,t_very_pale}'::text[]                         AS t_very_pale,
    doc #>> '{fields,inputs,t_fever}'::text[]                             AS t_fever,
    doc #>> '{fields,inputs,t_reduced_or_no_feotal_movements}'::text[]    AS t_reduced_or_no_feotal_movements,
    doc #>> '{fields,inputs,t_blurred_vision}'::text[]                    AS t_blurred_vision,
    doc #>> '{fields,inputs,t_swelling}'::text[]                          AS t_swelling,
    doc #>> '{fields,inputs,t_breathlessness}'::text[]                    AS t_breathlessness,
    doc #>> '{fields,inputs,current_edd_std}'::text[]                     AS current_edd_std,
    doc #>> '{fields,inputs,t_patient_name}'::text[]                      AS t_patient_name,
    doc #>> '{fields,inputs,t_patient_gender}'::text[]                    AS t_patient_gender,
    doc #>> '{fields,inputs,t_patient_date_of_birth}'::text[]             AS t_patient_date_of_birth,
    doc #>> '{fields,inputs,t_patient_id}'::text[]                        AS t_patient_id,
  
    doc #>> '{fields,inputs,user,contact_id}'::text[] AS user_contact_id,
    doc #>> '{fields,inputs,user,facility_id}'::text[] AS user_facility_id,
    doc #>> '{fields,inputs,contact,date_of_birth}'::text[] AS contact_date_of_birth,
    doc #>> '{fields,inputs,contact,sex}'::text[]  AS contact_sex,
    doc #>> '{fields,inputs,contact,_id}'::text[]  AS contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS contact_name,
   
    /* ===== Patient details and age group ===== */
    doc #>> '{fields,dob}'::text[]                                  AS dob,
    doc #>> '{fields,patient_age_in_years}'::text[]                 AS patient_age_in_years,
    doc #>> '{fields,patient_age_in_months}'::text[]                AS patient_age_in_months,
    doc #>> '{fields,patient_age_in_days}'::text[]                  AS patient_age_in_days,
    doc #>> '{fields,patient_age_display}'::text[]                  AS patient_age_display,
    doc #>> '{fields,patient_id}'::text[]                           AS patient_id,
    doc #>> '{fields,patient_name}'::text[]                         AS patient_name,
    doc #>> '{fields,patient_gender}'::text[]                       AS patient_gender,
    doc #>> '{fields,current_pregnancy_age_in_weeks}'::text[]       AS current_pregnancy_age_in_weeks,
    doc #>> '{fields,needs_signoff}'::text[]                        AS needs_signoff,
    /* ===== Referral details group ===== */
    doc #>> '{fields,referral_details,health_note}'::text[]                  AS referral_health_note,
    doc #>> '{fields,referral_details,vaginal_bleeding}'::text[]             AS referral_vaginal_bleeding,
    doc #>> '{fields,referral_details,lower_abdomen_pain}'::text[]           AS referral_lower_abdomen_pain,
    doc #>> '{fields,referral_details,severe_headache}'::text[]              AS referral_severe_headache,
    doc #>> '{fields,referral_details,very_pale}'::text[]                    AS referral_very_pale,
    doc #>> '{fields,referral_details,fever}'::text[]                        AS referral_fever,
    doc #>> '{fields,referral_details,reduced_or_no_feotal_movements}'::text[] AS referral_reduced_or_no_feotal_movements,
    doc #>> '{fields,referral_details,blurred_vision}'::text[]               AS referral_blurred_vision,
    doc #>> '{fields,referral_details,swelling}'::text[]                     AS referral_swelling,
    doc #>> '{fields,referral_details,breathlessness}'::text[]               AS referral_breathlessness,
    doc #>> '{fields,danger_sign_check,follow_up_child}'::text[]    AS follow_up_child,
    doc #>> '{fields,danger_sign_check,danger_signs}'::text[]       AS danger_signs,
    doc #>> '{fields,referral,refer_to_facility}'::text[]       AS refer_to_facility,
    doc #>> '{fields,referral,confirm_refer_to_facility}'::text[]       AS confirm_refer_to_facility,
    doc #>> '{fields,health_education,select_health_condition}'::text[]       AS select_health_condition,
    doc #>> '{fields,group_patient_summary,s_note_patient_details}'::text[]       AS s_note_patient_details,

      --- reporting hierarchy
    doc #>> '{contact,_id}'                         AS chw_id,                   
    doc #>> '{contact,parent,_id}'                  AS chw_area_id,  
    doc #>> '{contact,parent,parent,_id}'           AS facility_id,                                    
    doc #>> '{contact,parent,parent,parent,_id}'    AS district,              
    doc #>> '{contact,parent,parent,parent,parent,_id}'           AS region,
    CURRENT_TIMESTAMP AS last_refresh_date               

   FROM dwh.cht_data
  WHERE (doc ->> 'form'::text) = 'anc_danger_sign_notification'::text 
  AND is_current = true
WITH DATA;

-- View indexes:
CREATE INDEX mv_anc_danger_sign_notification_up_reported ON cht.mv_anc_danger_sign_notification USING btree (reported);
