CREATE MATERIALIZED VIEW cht.mv_anc_visit_follow_up
TABLESPACE ts_report
AS 
select
--columns
	doc ->> '_id'::text AS doc_id,
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
     doc ->> 'from'::text                             AS  "from",
     doc #>> '{fields,inputs,source}'::text[] AS source,
     doc #>> '{fields,inputs,source_id}'::text[] AS source_id,
     doc #>> '{fields,inputs,current_edd_std}'::text[] AS current_edd_std,

    doc #>> '{fields,inputs,contact,date_of_birth}'::text[]  AS contact_date_of_birth,
    doc #>> '{fields,inputs,contact,sex}'::text[] AS contact_sex,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS contact_name,
    doc #>> '{fields,inputs,contact,parent,_id}'::text[] AS parent_id,

    doc #>> '{fields,is_of_child_bearing_age}'::text[]               AS is_of_child_bearing_age,
    doc #>> '{fields,visited_contact_uuid}'::text[]                  AS visited_contact_uuid,
    doc #>> '{fields,patient_age_in_years}'::text[]                  AS patient_age_in_years,
    doc #>> '{fields,patient_age_in_months}'::text[]                 AS patient_age_in_months,
    doc #>> '{fields,patient_age_in_days}'::text[]                   AS patient_age_in_days,
    doc #>> '{fields,patient_age_display}'::text[]                   AS patient_age_display,
    doc #>> '{fields,patient_id}'::text[]                            AS patient_id,
    doc #>> '{fields,patient_name}'::text[]                          AS patient_name,
    doc #>> '{fields,patient_name_with_s}'::text[]                   AS patient_name_with_s,
    doc #>> '{fields,patient_gender}'::text[]                        AS patient_gender,
    doc #>> '{fields,current_edd_local}'::text[]                     AS current_edd_local,
    doc #>> '{fields,current_pregnancy_age_in_weeks}'::text[]        AS current_pregnancy_age_in_weeks,
    doc #>> '{fields,edd_std}'::text[]                               AS edd_std,
    doc #>> '{fields,edd_local}'::text[]                             AS edd_local,
    doc #>> '{fields,pregnancy_ended}'::text[]                       AS pregnancy_ended, --(yes/no)
    doc #>> '{fields,referred_for_nutrition_follow_up}'::text[]      AS referred_for_nutrition_follow_up,--(yes/no)
    
    doc #>> '{fields,group_follow_up,assess_this_pregnancy}'::text[]     AS assess_this_pregnancy,--(yes/no)
    doc #>> '{fields,group_follow_up,start_this_pregnancy}'::text[]      AS start_this_pregnancy, --(delivered/miscarriage/abortion/refusing_care/migrated/died/follow_up_later)
    doc #>> '{fields,group_follow_up,is_available}'::text[]              AS is_available,--(yes/no)

    /* ===== Group: Update Pregnancy Details ===== */
    doc #>> '{fields,update_pregnancy,edd_upto_date}'::text[]                    AS edd_upto_date,--(yes/no)
    doc #>> '{fields,update_pregnancy,refused_care_action}'::text[]              AS refused_care_action, --(clear_this_task/no_more_tasks)
    doc #>> '{fields,update_pregnancy,migrated_action}'::text[]                  AS migrated_action,--(clear_this_task/no_more_tasks)

    /* ===== Group: Past ANC Visits ===== */
    doc #>> '{fields,group_past_anc_visits,completed_scheduled_anc_visit}'::text[]          AS completed_scheduled_anc_visit,--(yes/no)
    doc #>> '{fields,group_past_anc_visits,anc_visits}'::text[]                             AS anc_visits, --(anc_1/anc_1 anc_2/anc_1 anc_2 anc_3/anc_1 anc_2 anc_3 anc_4/anc_1 anc_2 anc_3 anc_4 anc_gt_4)
    doc #>> '{fields,group_past_anc_visits,date_anc_1}'::text[]                             AS date_anc_1,
    doc #>> '{fields,group_past_anc_visits,date_anc_2}'::text[]                             AS date_anc_2,
    doc #>> '{fields,group_past_anc_visits,date_anc_3}'::text[]                             AS date_anc_3,
    doc #>> '{fields,group_past_anc_visits,date_anc_4}'::text[]                             AS date_anc_4,
    doc #>> '{fields,group_past_anc_visits,person_who_accompanied_expectant_mother}'::text[] AS person_who_accompanied_expectant_mother, --(parent/chw/husband/other_relative/non_family_member)

    /* ===== Group: Missed ANC Visits ===== */
    doc #>> '{fields,group_missed_anc_visits,why_missed_anc_visit}'::text[]               AS why_missed_anc_visit, --(was_not_reminded/had_traveled/too_early_start_clinic)
    doc #>> '{fields,group_missed_anc_visits,missed_anc_actions_taken}'::text[]           AS missed_anc_actions_taken, --(referred/provided_key_health_message/accompanied_to_facility)
    doc #>> '{fields,group_missed_anc_visits,refer_to_health_facility}'::text[]           AS refer_to_health_facility, --(yes)

    /* ===== Group: Safe Pregnancy Practices ===== */
    doc #>> '{fields,group_safe_pregnancy_practices,client_on_art_treatment}'::text[]       AS client_on_art_treatment,--(yes/no)
    doc #>> '{fields,group_safe_pregnancy_practices,client_taking_medication}'::text[]    AS client_taking_medication,--(yes/no)
    doc #>> '{fields,group_safe_pregnancy_practices,current_hiv_test_result}'::text[]     AS current_hiv_test_result, --(positive/negative/unknown)
    doc #>> '{fields,group_safe_pregnancy_practices,hiv_test_result}'::text[]             AS hiv_test_result,--(positive/negative/unknown)
    doc #>> '{fields,group_safe_pregnancy_practices,is_client_taking_medication}'::text[] AS is_client_taking_medication,--(yes/no)
    doc #>> '{fields,group_safe_pregnancy_practices,on_art_treatment}'::text[]            AS on_art_treatment,--(yes/no)
    doc #>> '{fields,group_safe_pregnancy_practices,referred_to_health_facility_llin}'::text[] AS referred_to_health_facility_llin, --(yes)
    doc #>> '{fields,group_safe_pregnancy_practices,using_llin}'::text[]                  AS using_llin, --(yes/no)
    doc #>> '{fields,group_safe_pregnancy_practices,tested_for_hiv_past3months}'::text[]  AS tested_for_hiv_past3months,--(yes/no)
    doc #>> '{fields,group_safe_pregnancy_practices,received_tt_immunization}'::text[]    AS received_tt_immunization,--(yes/no)

    /* ===== Group: Nutrition Status ===== */
    doc #>> '{fields,group_nutrition_status,completed_last_nutrition_follow_up}'::text[]            AS completed_last_nutrition_follow_up, --(yes/no)
    doc #>> '{fields,group_nutrition_status,micro_nutrient_supplementation_received}'::text[]       AS micro_nutrient_supplementation_received,--(yes/no)
    doc #>> '{fields,group_nutrition_status,refer_to_health_facility_no_micro_nutrients}'::text[]   AS refer_to_health_facility_no_micro_nutrients, --(yes)
    doc #>> '{fields,group_nutrition_status,referred_to_health_facility_missed_nutrition_follow_up}'::text[] AS referred_to_health_facility_missed_nutrition_follow_up,--(yes)
    doc #>> '{fields,group_nutrition_status,taken_muac}'::text[]                                    AS taken_muac,--(yes/no)
    doc #>> '{fields,group_nutrition_status,muac_measurement}'::text[]                               AS muac_measurement, --(red/yellow/green)
    doc #>> '{fields,group_nutrition_status,referred_to_health_facility_nutrition}'::text[]        AS referred_to_health_facility_nutrition, --(yes)
    doc #>> '{fields,group_nutrition_status,on_nutrition_follow_up}'::text[]                        AS on_nutrition_follow_up, --(yes/no)
      --- reporting hierarchy
    doc #>> '{contact,_id}'                         AS chw_id,                   
    doc #>> '{contact,parent,_id}'                  AS chw_area_id,  
    doc #>> '{contact,parent,parent,_id}'           AS facility_id,                                    
    doc #>> '{contact,parent,parent,parent,_id}'    AS parish_id,              
    doc #>> '{contact,parent,parent,parent,parent,_id}'           AS district,                 
    doc #>> '{contact,parent,parent,parent,parent,parent,_id}'    AS region,
    CURRENT_TIMESTAMP as last_refresh_date

FROM dwh.cht_data couchdb
  WHERE (doc ->> 'form'::text) = 'anc_visit_follow_up'::text 
  AND is_current = true
WITH DATA;

-- View indexes:
CREATE INDEX mv_anc_visit_follow_up_contact_id ON report.useview_anc_visit_follow_up USING btree (contact_id);
CREATE INDEX mv_anc_visit_follow_up_reported ON report.useview_anc_visit_follow_up USING btree (reported);
CREATE INDEX mv_anc_visit_follow_up_reported_by ON report.useview_anc_visit_follow_up USING btree (reported_by);
CREATE UNIQUE INDEX mv_anc_visit_follow_up_uuid ON report.useview_anc_visit_follow_up USING btree (uuid);