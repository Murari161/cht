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
    doc #>> '{fields,pregnancy_ended}'::text[]                       AS pregnancy_ended,
    doc #>> '{fields,pregnancy_ended_label}'::text[]                 AS pregnancy_ended_label,
    doc #>> '{fields,nutrition_follow_up_date}'::text[]              AS nutrition_follow_up_date,
    doc #>> '{fields,referred_for_nutrition_follow_up}'::text[]      AS referred_for_nutrition_follow_up,
    doc #>> '{fields,newest_anc_appointment_date}'::text[]           AS newest_anc_appointment_date,
    doc #>> '{fields,newest_anc_appointment_date_local}'::text[]     AS newest_anc_appointment_date_local,
    
    doc #>> '{fields,group_follow_up,assess_this_pregnancy}'::text[]     AS assess_this_pregnancy,
    doc #>> '{fields,group_follow_up,start_this_pregnancy}'::text[]      AS start_this_pregnancy,
    doc #>> '{fields,group_follow_up,possible_death_cause}'::text[]      AS possible_death_cause,
    doc #>> '{fields,group_follow_up,note_submit_death_report}'::text[]  AS note_submit_death_report,
    doc #>> '{fields,group_follow_up,new_follow_up_date}'::text[]        AS new_follow_up_date,
    doc #>> '{fields,group_follow_up,is_available}'::text[]              AS is_available,

    /* ===== Group: Update Pregnancy Details ===== */
    doc #>> '{fields,update_pregnancy,edd_upto_date}'::text[]                    AS edd_upto_date,
    doc #>> '{fields,update_pregnancy,correct_edd}'::text[]                      AS correct_edd,
    doc #>> '{fields,update_pregnancy,new_gestation_age_in_weeks}'::text[]       AS new_gestation_age_in_weeks,
    doc #>> '{fields,update_pregnancy,note_refer_for_miscarriage}'::text[]       AS note_refer_for_miscarriage,
    doc #>> '{fields,update_pregnancy,date_of_miscarriage}'::text[]              AS date_of_miscarriage,
    doc #>> '{fields,update_pregnancy,note_reported_abortion}'::text[]           AS note_reported_abortion,
    doc #>> '{fields,update_pregnancy,note_reported_refused_care}'::text[]       AS note_reported_refused_care,
    doc #>> '{fields,update_pregnancy,refused_care_action}'::text[]              AS refused_care_action,
    doc #>> '{fields,update_pregnancy,note_reported_migrated}'::text[]           AS note_reported_migrated,
    doc #>> '{fields,update_pregnancy,migrated_action}'::text[]                  AS migrated_action,
    doc #>> '{fields,update_pregnancy,note_submitting_will_end_pregnancy}'::text[] AS note_submitting_will_end_pregnancy,
    doc #>> '{fields,update_pregnancy,note_can_still_submit_pregnancy_visits}'::text[] AS note_can_still_submit_pregnancy_visits,
    doc #>> '{fields,update_pregnancy,note_submit_delivery_report}'::text[]      AS note_submit_delivery_report,

    /* ===== Group: Past ANC Visits ===== */
    doc #>> '{fields,group_past_anc_visits,completed_scheduled_anc_visit}'::text[]          AS completed_scheduled_anc_visit,
    doc #>> '{fields,group_past_anc_visits,anc_visits}'::text[]                             AS anc_visits,
    doc #>> '{fields,group_past_anc_visits,date_anc_1}'::text[]                             AS date_anc_1,
    doc #>> '{fields,group_past_anc_visits,date_anc_2}'::text[]                             AS date_anc_2,
    doc #>> '{fields,group_past_anc_visits,date_anc_3}'::text[]                             AS date_anc_3,
    doc #>> '{fields,group_past_anc_visits,date_anc_4}'::text[]                             AS date_anc_4,
    doc #>> '{fields,group_past_anc_visits,person_who_accompanied_expectant_mother}'::text[] AS person_who_accompanied_expectant_mother,
   
    doc #>> '{fields,group_upcoming_anc_visits,anc_appointment_date}'::text[] AS anc_appointment_date, 
    doc #>> '{fields,group_upcoming_anc_visits,anc_appointment_date_local}'::text[] AS anc_appointment_date_local, 

    /* ===== Group: Missed ANC Visits ===== */
    doc #>> '{fields,group_missed_anc_visits,why_missed_anc_visit}'::text[]               AS why_missed_anc_visit,
    doc #>> '{fields,group_missed_anc_visits,note_encourage_to_go_for_anc}'::text[]       AS note_encourage_to_go_for_anc,
    doc #>> '{fields,group_missed_anc_visits,missed_anc_actions_taken}'::text[]           AS missed_anc_actions_taken,
    doc #>> '{fields,group_missed_anc_visits,facility_visit_date_for_missed_anc}'::text[] AS facility_visit_date_for_missed_anc,
    doc #>> '{fields,group_missed_anc_visits,facility_visit_date_for_missed_anc_local}'::text[] AS facility_visit_date_for_missed_anc_local,
    doc #>> '{fields,group_missed_anc_visits,refer_to_health_facility}'::text[]           AS refer_to_health_facility,

    /* ===== Group: Safe Pregnancy Practices ===== */
    doc #>> '{fields,group_safe_pregnancy_practices,client_on_art_treatment}'::text[]       AS client_on_art_treatment,
    doc #>> '{fields,group_safe_pregnancy_practices,client_taking_medication}'::text[]    AS client_taking_medication,
    doc #>> '{fields,group_safe_pregnancy_practices,current_hiv_test_result}'::text[]     AS current_hiv_test_result,
    doc #>> '{fields,group_safe_pregnancy_practices,hiv_test_result}'::text[]             AS hiv_test_result,
    doc #>> '{fields,group_safe_pregnancy_practices,is_client_taking_medication}'::text[] AS is_client_taking_medication,
    doc #>> '{fields,group_safe_pregnancy_practices,on_art_treatment}'::text[]            AS on_art_treatment,
    doc #>> '{fields,group_safe_pregnancy_practices,referred_to_health_facility_llin}'::text[] AS referred_to_health_facility_llin,
    doc #>> '{fields,group_safe_pregnancy_practices,using_llin}'::text[]                  AS using_llin,
    doc #>> '{fields,group_safe_pregnancy_practices,note_llin_prevents_malaria}'::text[]  AS note_llin_prevents_malaria,
    doc #>> '{fields,group_safe_pregnancy_practices,tested_for_hiv_past3months}'::text[]  AS tested_for_hiv_past3months,
    doc #>> '{fields,group_safe_pregnancy_practices,note_encourage_client_attend_art_clinic}'::text[] AS note_encourage_client_attend_art_clinic,
    doc #>> '{fields,group_safe_pregnancy_practices,note_explain_importance_of_medication}'::text[] AS note_explain_importance_of_medication,
    doc #>> '{fields,group_safe_pregnancy_practices,note_encourage_client_to_take_medication}'::text[] AS note_encourage_client_to_take_medication,
    doc #>> '{fields,group_safe_pregnancy_practices,note_encourage_client_to_reduce_hiv_risk}'::text[] AS note_encourage_client_to_reduce_hiv_risk,
    doc #>> '{fields,group_safe_pregnancy_practices,note_advise_client_to_check_status}'::text[] AS note_advise_client_to_check_status,
    doc #>> '{fields,group_safe_pregnancy_practices,note_encourage_client_to_retest}'::text[] AS note_encourage_client_to_retest,
    doc #>> '{fields,group_safe_pregnancy_practices,note_encourage_and_refer_to_health_facility}'::text[] AS note_encourage_and_refer_to_health_facility,
    doc #>> '{fields,group_safe_pregnancy_practices,note_encourage_client_begin_treatment}'::text[] AS note_encourage_client_begin_treatment,
    doc #>> '{fields,group_safe_pregnancy_practices,note_explain_importance_of_taking_medication}'::text[] AS note_explain_importance_of_taking_medication,
    doc #>> '{fields,group_safe_pregnancy_practices,note_encourage_client_to_continue_taking_medication}'::text[] AS note_encourage_client_to_continue_taking_medication,
    doc #>> '{fields,group_safe_pregnancy_practices,received_tt_immunization}'::text[]    AS received_tt_immunization,
    doc #>> '{fields,group_safe_pregnancy_practices,note_tt_immunization_importance}'::text[] AS note_tt_immunization_importance,
    doc #>> '{fields,group_safe_pregnancy_practices,note_tt_vaccination_protocol}'::text[] AS note_tt_vaccination_protocol,

    /* ===== Group: Nutrition Status ===== */
    doc #>> '{fields,group_nutrition_status,completed_last_nutrition_follow_up}'::text[]            AS completed_last_nutrition_follow_up,
    doc #>> '{fields,group_nutrition_status,micro_nutrient_supplementation_received}'::text[]       AS micro_nutrient_supplementation_received,
    doc #>> '{fields,group_nutrition_status,next_nutrition_follow_up_date}'::text[]                 AS next_nutrition_follow_up_date,
    doc #>> '{fields,group_nutrition_status,refer_to_health_facility_no_micro_nutrients}'::text[]   AS refer_to_health_facility_no_micro_nutrients,
    doc #>> '{fields,group_nutrition_status,referred_to_health_facility_missed_nutrition_follow_up}'::text[] AS referred_to_health_facility_missed_nutrition_follow_up,
    doc #>> '{fields,group_nutrition_status,note_nutrition_status}'::text[]                         AS note_nutrition_status,
    doc #>> '{fields,group_nutrition_status,taken_muac}'::text[]                                    AS taken_muac,
    doc #>> '{fields,group_nutrition_status,muac_measurement}'::text[]                               AS muac_measurement,
    doc #>> '{fields,group_nutrition_status,encourage_client_to_consume_sufficient_diet}'::text[]  AS encourage_client_to_consume_sufficient_diet,
    doc #>> '{fields,group_nutrition_status,note_has_sam}'::text[]                                   AS note_has_sam,
    doc #>> '{fields,group_nutrition_status,note_has_mam}'::text[]                                   AS note_has_mam,
    doc #>> '{fields,group_nutrition_status,note_refer_to_health_facility}'::text[]                 AS note_refer_to_health_facility,
    doc #>> '{fields,group_nutrition_status,referred_to_health_facility_nutrition}'::text[]        AS referred_to_health_facility_nutrition,
    doc #>> '{fields,group_nutrition_status,note_encourage_micro-nutrients}'::text[]               AS note_encourage_micro_nutrients,
    doc #>> '{fields,group_nutrition_status,on_nutrition_follow_up}'::text[]                        AS on_nutrition_follow_up,
    doc #>> '{fields,group_nutrition_status,note_thank_you_nutrition_follow_up}'::text[]           AS note_thank_you_nutrition_follow_up,
    doc #>> '{fields,group_nutrition_status,note_refer_did_not_complete_follow_up}'::text[]        AS note_refer_did_not_complete_follow_up;

    /* ===== Group: Summary - ANC Follow-Up ===== */
    doc #>> '{fields,group_summary,s_note_anc_follow_up}'::text[]                 AS s_note_anc_follow_up,
    doc #>> '{fields,group_summary,s_note_be_sure_to_submit}'::text[]            AS s_note_be_sure_to_submit,
    doc #>> '{fields,group_summary,s_note_pregnancy_details}'::text[]            AS s_note_pregnancy_details,
    doc #>> '{fields,group_summary,s_note_patient_details}'::text[]              AS s_note_patient_details,
    doc #>> '{fields,group_summary,s_note_edd}'::text[]                          AS s_note_edd,
    doc #>> '{fields,group_summary,s_note_next_anc_visit_date}'::text[]          AS s_note_next_anc_visit_date,
    doc #>> '{fields,group_summary,s_note_pregnancy_ended}'::text[]              AS s_note_pregnancy_ended,
    doc #>> '{fields,group_summary,s_note_submit_delivery_report}'::text[]       AS s_note_submit_delivery_report,
    doc #>> '{fields,group_summary,s_note_death_notification}'::text[]           AS s_note_death_notification,
    doc #>> '{fields,group_summary,s_note_social_support_for_miscarriage}'::text[] AS s_note_social_support_for_miscarriage,
    doc #>> '{fields,group_summary,s_note_findings}'::text[]                     AS s_note_findings,
    doc #>> '{fields,group_summary,s_note_appreciate_for_attending_anc}'::text[] AS s_note_appreciate_for_attending_anc,
    doc #>> '{fields,group_summary,s_note_refer_for_facility_anc}'::text[]       AS s_note_refer_for_facility_anc,
    doc #>> '{fields,group_summary,s_note_not_available}'::text[]                AS s_note_not_available,
    doc #>> '{fields,group_summary,s_note_refused_care}'::text[]                 AS s_note_refused_care,
    doc #>> '{fields,group_summary,s_note_migrated}'::text[]                     AS s_note_migrated,
    doc #>> '{fields,group_summary,s_note_follow_up}'::text[]                    AS s_note_follow_up,
    doc #>> '{fields,group_summary,s_note_follow_up1}'::text[]                   AS s_note_follow_up1,
    doc #>> '{fields,group_summary,s_note_follow_up2}'::text[]                   AS s_note_follow_up2,
    doc #>> '{fields,group_summary,s_note_follow_up3}'::text[]                   AS s_note_follow_up3,
    doc #>> '{fields,group_summary,s_note_no_more_follow_ups}'::text[]           AS s_note_no_more_follow_ups,
    doc #>> '{fields,group_summary,s_note_follow_up_on_agreed_date}'::text[]    AS s_note_follow_up_on_agreed_date,
    doc #>> '{fields,group_summary,s_note_follow_up_as_per_schedule}'::text[]   AS s_note_follow_up_as_per_schedule,

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