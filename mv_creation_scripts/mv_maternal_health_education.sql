CREATE MATERIALIZED VIEW cht.mv_maternal_health_education_new
TABLESPACE ts_report
AS
SELECT
      doc ->> '_id'                              AS doc_id,
      doc ->> '_rev'                             AS rev,                                 -- [NEW FIELD]
      to_timestamp((NULLIF(doc ->> 'reported_date', '')::bigint / 1000)::double precision) AS reported,
      (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY-MM-DD'))::date AS date,
      (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY'))::INT AS year,
      TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'FMMonth') AS month,

      doc -> 'fields' -> 'meta' ->> 'instanceID'                         AS instanceID,
      doc -> 'fields' -> 'inputs' -> 'meta' ->> 'deprecatedID'           AS deprecatedID,
      doc -> 'fields' -> 'inputs' -> 'meta' -> 'location' ->> 'lat'      AS location_lat,
      doc -> 'fields' -> 'inputs' -> 'meta' -> 'location' ->> 'long'     AS location_long,
      doc -> 'fields' -> 'inputs' -> 'meta' -> 'location' ->> 'error'    AS location_error,
      doc -> 'fields' -> 'inputs' -> 'meta' -> 'location' ->> 'message'  AS location_message,
      doc -> 'geolocation' ->> 'code'                                   AS geolocation_code,
      doc -> 'geolocation' ->> 'message'                                AS geolocation_message,
      doc ->> 'form'                                                    AS form,
      doc ->> 'from'                                                    AS from,

      doc #>> '{fields,inputs,source}'                                  AS source,
      doc #>> '{fields,inputs,source_id}'                               AS source_id,
      doc #>> '{fields,inputs,current_edd_std}'                         AS current_edd_std,
      doc #>> '{fields,inputs,anc_visits}'                              AS anc_visits,
      doc #>> '{fields,inputs,t_vaginal_bleeding}'                      AS t_vaginal_bleeding,
      doc #>> '{fields,inputs,t_lower_abdomen_pain}'                    AS t_lower_abdomen_pain,
      doc #>> '{fields,inputs,t_severe_headache}'                       AS t_severe_headache,
      doc #>> '{fields,inputs,t_very_pale}'                             AS t_very_pale,
      doc #>> '{fields,inputs,t_fever}'                                 AS t_fever,
      doc #>> '{fields,inputs,t_reduced_or_no_feotal_movements}'        AS t_reduced_or_no_feotal_movements,
      doc #>> '{fields,inputs,t_blurred_vision}'                        AS t_blurred_vision,
      doc #>> '{fields,inputs,t_swelling}'                              AS t_swelling,
      doc #>> '{fields,inputs,t_breathlessness}'                        AS t_breathlessness,
      doc #>> '{fields,inputs,t_has_hypertension}'                      AS t_has_hypertension,
      doc #>> '{fields,inputs,t_hiv_test_result}'                       AS t_hiv_test_result,
      doc #>> '{fields,inputs,t_patient_name}'                          AS t_patient_name,
      doc #>> '{fields,inputs,t_patient_gender}'                        AS t_patient_gender,
      doc #>> '{fields,inputs,t_patient_date_of_birth}'                 AS t_patient_date_of_birth,
      doc #>> '{fields,inputs,t_patient_id}'                            AS t_patient_id,
      doc #>> '{fields,inputs,user,contact_id}'                         AS user_contact_id,
      doc #>> '{fields,inputs,user,facility_id}'                        AS user_facility_id,
      doc #>> '{fields,inputs,contact,_id}'                             AS contact_id,
      doc #>> '{fields,inputs,contact,name}'                            AS contact_name,
      doc #>> '{fields,inputs,contact,date_of_birth}'                   AS contact_date_of_birth,
      doc #>> '{fields,inputs,contact,sex}'                             AS contact_sex,
      doc #>> '{fields,inputs,contact,has_hypertension}'                AS contact_has_hypertension,
      doc #>> '{fields,inputs,contact,hiv_test_result}'                 AS contact_hiv_test_result,
      doc #>> '{fields,dob}'                                            AS dob,
      doc #>> '{fields,patient_age_in_years}'                           AS patient_age_in_years,
      doc #>> '{fields,patient_age_in_months}'                          AS patient_age_in_months,
      doc #>> '{fields,patient_age_in_days}'                            AS patient_age_in_days,
      doc #>> '{fields,patient_age_display}'                            AS patient_age_display,
      doc #>> '{fields,patient_id}'                                     AS patient_id,
      doc #>> '{fields,patient_name}'                                   AS patient_name,
      doc #>> '{fields,patient_gender}'                                 AS patient_gender,
      doc #>> '{fields,current_pregnancy_age_in_weeks}'                 AS current_pregnancy_age_in_weeks,
      doc #>> '{fields,no_pregnancy_danger_sign}'                       AS no_pregnancy_danger_sign,
      doc #>> '{fields,no_pregnancy_risk_factor}'                       AS no_pregnancy_risk_factor,
      doc #>> '{fields,needs_signoff}'                                  AS needs_signoff,

      doc #>> '{fields,pregnancy_details,is_pregnant}'                  AS is_pregnant,
      doc #>> '{fields,pregnancy_details,pregnancy_outcome}'            AS pregnancy_outcome,
      doc #>> '{fields,pregnancy_details,note_vht_delivery_report}'     AS note_vht_delivery_report,
      doc #>> '{fields,pregnancy_details,refer_to_health_facility}'     AS refer_to_health_facility,
      doc #>> '{fields,pregnancy_details,anc_visits_typo}'              AS anc_visits_typo,
      doc #>> '{fields,pregnancy_details,patient_pregnancy_details}'    AS patient_pregnancy_details,
      doc #>> '{fields,pregnancy_details,pregnancy_danger_signs}'       AS pregnancy_danger_signs,
      doc #>> '{fields,pregnancy_details,danger_sign_none}'             AS danger_sign_none,
      doc #>> '{fields,pregnancy_details,vaginal_bleeding}'             AS vaginal_bleeding,
      doc #>> '{fields,pregnancy_details,lower_abdomen_pain}'           AS lower_abdomen_pain,
      doc #>> '{fields,pregnancy_details,severe_headache}'              AS severe_headache,
      doc #>> '{fields,pregnancy_details,very_pale}'                    AS very_pale,
      doc #>> '{fields,pregnancy_details,fever}'                        AS fever,
      doc #>> '{fields,pregnancy_details,reduced_or_no_feotal_movements}' AS reduced_or_no_feotal_movements,
      doc #>> '{fields,pregnancy_details,blurred_vision}'               AS blurred_vision,
      doc #>> '{fields,pregnancy_details,swelling}'                     AS swelling,
      doc #>> '{fields,pregnancy_details,breathlessness}'               AS breathlessness,
      doc #>> '{fields,pregnancy_details,pregnancy_risk_factors}'       AS pregnancy_risk_factors,
      doc #>> '{fields,pregnancy_details,pregnancy_risk_none}'          AS pregnancy_risk_none,
      doc #>> '{fields,pregnancy_details,below_18}'                     AS below_18,
      doc #>> '{fields,pregnancy_details,above_35}'                     AS above_35,
      doc #>> '{fields,pregnancy_details,hypertension}'                 AS hypertension,
      doc #>> '{fields,pregnancy_details,hiv_positive}'                 AS hiv_positive,
      doc #>> '{fields,pregnancy_details,next_maternal_health_date}'    AS next_maternal_health_date,

      doc #>> '{fields,health_education,select_health_condition}'       AS select_health_condition,
      doc #>> '{fields,group_patient_summary,s_note_patient_details}'   AS s_note_patient_details,
      doc #>> '{fields,group_patient_summary,s_note_patient_details_values}' AS s_note_patient_details_values,
      doc #>> '{fields,group_patient_summary,findings}'                 AS findings,
      doc #>> '{fields,group_patient_summary,education_given}'          AS education_given,
      doc #>> '{fields,group_patient_summary,note_woman_delivered}'     AS note_woman_delivered,
      doc #>> '{fields,group_patient_summary,note_woman_miscarriage}'   AS note_woman_miscarriage,
      doc #>> '{fields,group_patient_summary,follow_up_tasks}'          AS follow_up_tasks,
      doc #>> '{fields,group_patient_summary,follow_up_task_date}'      AS follow_up_task_date,
      doc #>> '{fields,group_patient_summary,no_longer_receive_education}' AS no_longer_receive_education,

    --- reporting hierarchy
      doc #>> '{contact,_id}'                         AS chw_id,
      doc #>> '{contact,parent,_id}'                  AS chw_area_id,
      doc #>> '{contact,parent,parent,_id}'           AS facility_id,
      doc #>> '{contact,parent,parent,parent,_id}'    AS parish_id,
      doc #>> '{contact,parent,parent,parent,parent,_id}'  AS district,
      doc #>> '{contact,parent,parent,parent,parent,parent,_id}'  AS region,
      CURRENT_TIMESTAMP                           AS last_refresh_date

FROM dwh.cht_data
WHERE doc ->> 'form' = 'maternal_health_education'
  AND is_current
WITH DATA;


-- Helpful additional indexes
CREATE INDEX mv_maternal_health_education_reported_new
    ON cht.mv_maternal_health_education_new USING btree (reported);

