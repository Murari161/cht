CREATE MATERIALIZED VIEW cht.mv_pnc_follow_up
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
     doc ->> 'form'::text                             AS  form,
     doc ->> 'from'::text                             AS  from,
    
      doc #>> '{fields,inputs,source}'                                    AS source,
      doc #>> '{fields,inputs,source_id}'                                 AS source_id,
      doc #>> '{fields,inputs,task_name}'                                 AS task_name,
      doc #>> '{fields,inputs,contact,_id}'                               AS contact_id,
      doc #>> '{fields,inputs,contact,name}'                              AS contact_name,
      doc #>> '{fields,inputs,contact,date_of_birth}'                     AS contact_date_of_birth,
      doc #>> '{fields,inputs,contact,sex}'                               AS contact_sex,
      doc #>> '{fields,inputs,contact,parent,_id}'                        AS parent__id,
      doc #>> '{fields,is_of_child_bearing_age}'                          AS is_of_child_bearing_age,
      doc #>> '{fields,patient_age_in_years}'                             AS patient_age_in_years,
      doc #>> '{fields,patient_age_in_months}'                            AS patient_age_in_months,
      doc #>> '{fields,patient_age_in_days}'                              AS patient_age_in_days,
      doc #>> '{fields,patient_age_display}'                              AS patient_age_display,
      doc #>> '{fields,patient_id}'                                       AS patient_id,
      doc #>> '{fields,patient_name}'                                     AS patient_name,
      doc #>> '{fields,patient_gender}'                                   AS patient_gender,
      doc #>> '{fields,patient_name_with_s}'                              AS patient_name_with_s,
      doc #>> '{fields,nutrition_follow_up_date}'                         AS nutrition_follow_up_date,
      doc #>> '{fields,referred_for_nutrition_follow_up}'                 AS referred_for_nutrition_follow_up,
      doc #>> '{fields,group_label}'                                      AS group_label,
    
      doc #>> '{fields,group_pnc_referral_follow_up,went_facility_as_referred}'  AS went_facility_as_referred,
     
      doc #>> '{fields,group_missed_referral_details,missed_referral_reason}'  AS missed_referral_reason,
      doc #>> '{fields,group_missed_referral_details,specify_other}'      AS specify_other,
      doc #>> '{fields,group_missed_referral_details,missed_referral_actions}'  AS missed_referral_actions,
      
      doc #>> '{fields,group_mother_condition,mother_condition}'          AS mother_condition,
      doc #>> '{fields,group_mother_condition,date_of_death}'             AS date_of_death,
    
      doc #>> '{fields,group_follow_up,is_available}'          AS is_available,
      doc #>> '{fields,group_follow_up,follow_up_again_date}'  AS follow_up_again_date,

      doc #>> '{fields,group_missed_pnc_visit,missed_visit_reason}'         AS missed_visit_reason,
      doc #>> '{fields,group_missed_pnc_visit,missed_visit_reason_other}'   AS missed_visit_reason_other,
      doc #>> '{fields,group_missed_pnc_visit,note_pnc_importance}'         AS note_pnc_importance,
      doc #>> '{fields,group_missed_pnc_visit,agreed_to_go_for_pnc_visit}'  AS agreed_to_go_for_pnc_visit,
      doc #>> '{fields,group_missed_pnc_visit,agreed_date_for_pnc_visit}'   AS agreed_date_for_pnc_visit,

      doc #>> '{fields,group_pnc_visit,has_attended_pnc_facility}'   AS has_attended_pnc_facility,
      doc #>> '{fields,group_pnc_visit,pnc_visit}'                   AS pnc_visit,
      doc #>> '{fields,group_pnc_visit,visit_date}'                  AS visit_date,


      doc #>> '{fields,group_woman_nutritional_status,note_nutrition_status}'                AS note_nutrition_status,
      doc #>> '{fields,group_woman_nutritional_status,on_nutrition_follow_up}'               AS on_nutrition_follow_up,
      doc #>> '{fields,group_woman_nutritional_status,note_use_muac_tape}'                   AS note_use_muac_tape,
      doc #>> '{fields,group_woman_nutritional_status,taken_muac}'                           AS taken_muac,
      doc #>> '{fields,group_woman_nutritional_status,muac_measurement}'                     AS muac_measurement,
      doc #>> '{fields,group_woman_nutritional_status,note_has_sam}'                         AS note_has_sam,
      doc #>> '{fields,group_woman_nutritional_status,note_has_mam}'                         AS note_has_mam,
      doc #>> '{fields,group_woman_nutritional_status,note_refer_to_health_facility}'        AS note_refer_to_health_facility,
      doc #>> '{fields,group_woman_nutritional_status,referred_to_health_facility_nutrition}' AS referred_to_health_facility_nutrition,
      doc #>> '{fields,group_woman_nutritional_status,completed_last_nutrition_follow_up}'   AS completed_last_nutrition_follow_up,
      doc #>> '{fields,group_woman_nutritional_status,next_nutrition_follow_up_date}'        AS next_nutrition_follow_up_date,
      doc #>> '{fields,group_woman_nutritional_status,note_thank_you_nutrition_follow_up}'   AS note_thank_you_nutrition_follow_up,
      doc #>> '{fields,group_woman_nutritional_status,note_refer_did_not_complete_follow_up}' AS note_refer_did_not_complete_follow_up,
      doc #>> '{fields,group_woman_nutritional_status,referred_to_health_facility_missed_nutrition_follow_up}' AS referred_to_health_facility_missed_nutrition_follow_up,

      doc #>> '{fields,group_safe_postnatal_practices,note_eat_well}'              AS note_eat_well,
      doc #>> '{fields,group_safe_postnatal_practices,note_exclusive_breast_feeding}' AS note_exclusive_breast_feeding,
      doc #>> '{fields,group_safe_postnatal_practices,note_keep_baby_warm}'        AS note_keep_baby_warm,
      doc #>> '{fields,group_safe_postnatal_practices,note_use_llin}'              AS note_use_llin,
      doc #>> '{fields,group_safe_postnatal_practices,note_clean_dry_umbilical_cord}' AS note_clean_dry_umbilical_cord,
      doc #>> '{fields,group_safe_postnatal_practices,note_fp}'                    AS note_fp,

      doc #>> '{fields,group_summary,woman_condition_choice}'             AS woman_condition_choice,
      doc #>> '{fields,group_summary,pnc_visit_choice}'                   AS pnc_visit_choice,
      doc #>> '{fields,group_summary,s_note_pnc_follow_up_report}'        AS s_note_pnc_follow_up_report,
      doc #>> '{fields,group_summary,s_note_pnc_referral_follow_up}'      AS s_note_pnc_referral_follow_up,
      doc #>> '{fields,group_summary,s_summary_submit}'                   AS s_summary_submit,
      doc #>> '{fields,group_summary,s_note_patient_details}'             AS s_note_patient_details,
      doc #>> '{fields,group_summary,s_note_patient_details_values}'      AS s_note_patient_details_values,
      doc #>> '{fields,group_summary,s_note_woman_condition}'             AS s_note_woman_condition,
      doc #>> '{fields,group_summary,s_note_woman_condition_value}'       AS s_note_woman_condition_value,
      doc #>> '{fields,group_summary,s_note_pnc_details}'                 AS s_note_pnc_details,
      doc #>> '{fields,group_summary,s_note_pnc_details_value}'           AS s_note_pnc_details_value,
      doc #>> '{fields,group_summary,s_note_complete_remaining_pnc_visits}' AS s_note_complete_remaining_pnc_visits,
      doc #>> '{fields,group_summary,s_note_follow_up}'                   AS s_note_follow_up,
      doc #>> '{fields,group_summary,s_note_follow_up_value}'             AS s_note_follow_up_value,
      doc #>> '{fields,group_summary,s_note_findings}'                    AS s_note_findings,
      doc #>> '{fields,group_summary,s_note_referral_completed}'          AS s_note_referral_completed,
      doc #>> '{fields,group_summary,s_note_referral_not_completed}'      AS s_note_referral_not_completed,

     --- reporting hierarchy
      doc #>> '{contact,_id}'                         AS chw_id,                   
      doc #>> '{contact,parent,_id}'                  AS chw_area_id,  
      doc #>> '{contact,parent,parent,_id}'           AS facility_id,                                    
      doc #>> '{contact,parent,parent,parent,_id}'    AS parish,              
      doc #>> '{contact,parent,parent,parent,parent,_id}'           AS district,   
      doc #>> '{contact,parent,parent,parent,parent,parent,_id}'           AS region                 


FROM dwh.cht_data
WHERE (doc ->> 'form') = 'pnc_follow_up'
  AND is_current
WITH DATA;

CREATE INDEX pnc_follow_up_reported_idx
    ON cht.mv_pnc_follow_up USING btree (reported);
