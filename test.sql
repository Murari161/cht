CREATE MATERIALIZED VIEW cht.mv_assessment_new
TABLESPACE ts_report
AS
SELECT
    -- Standard fields (appear in all forms)
    doc ->> '_id'::text AS uuid,
    doc ->> 'form'::text AS form,
    doc ->> 'from'::text AS submitter,
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
    doc #>> '{contact,_id}'::text[] AS chw_id,
    doc #>> '{contact,parent,_id}'::text[] AS contact_chw_area_id,
    doc #>> '{contact,parent,parent,_id}'::text[] AS contact_facility_id,
    doc #>> '{contact,parent,parent,parent,_id}'::text[] AS parish_id,
    doc #>> '{contact,parent,parent,parent,parent,_id}'::text[] AS district_id,
    doc #>> '{contact,parent,parent,parent,parent,parent,_id}'::text[] AS region_id,

    -- Form-specific fields (from the XML)
    doc #>> '{fields,inputs,source}'::text[] AS inputs_source,
    doc #>> '{fields,inputs,source_id}'::text[] AS inputs_source_id,
    doc #>> '{fields,inputs,user,contact_id}'::text[] AS inputs_user_contact_id,
    doc #>> '{fields,inputs,user,facility_id}'::text[] AS inputs_user_facility_id,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    doc #>> '{fields,inputs,contact,date_of_birth}'::text[] AS inputs_contact_date_of_birth,
    doc #>> '{fields,inputs,contact,sex}'::text[] AS inputs_contact_sex,
    doc #>> '{fields,inputs,contact,parent,_id}'::text[] AS inputs_contact_parent_id,
    doc #>> '{fields,inputs,contact,parent,name}'::text[] AS inputs_contact_parent_name,
    doc #>> '{fields,inputs,contact,parent,parent,_id}'::text[] AS inputs_contact_parent_parent_id,
    doc #>> '{fields,inputs,contact,parent,parent,name}'::text[] AS inputs_contact_parent_parent_name,
    doc #>> '{fields,inputs,contact,parent,parent,supervisor}'::text[] AS inputs_contact_parent_parent_supervisor,
    doc #>> '{fields,inputs,contact,parent,parent,phone}'::text[] AS inputs_contact_parent_parent_phone,
    doc #>> '{fields,inputs,contact,parent,parent,village}'::text[] AS inputs_contact_parent_parent_village,
    doc #>> '{fields,inputs,contact,parent,parent,contact,_id}'::text[] AS inputs_contact_parent_parent_contact_id,
    doc #>> '{fields,inputs,contact,parent,parent,contact,phone}'::text[] AS inputs_contact_parent_parent_contact_phone,
    doc #>> '{fields,inputs,contact,parent,parent,contact,name}'::text[] AS inputs_contact_parent_parent_contact_name,
    doc #>> '{fields,inputs,contact,parent,parent,parent,_id}'::text[] AS inputs_contact_parent_parent_parent_id,
    doc #>> '{fields,vaccines_received}'::text[] AS vaccines_received,
    doc #>> '{fields,vaccination_expected}'::text[] AS vaccination_expected, --(yes/no)
    doc #>> '{fields,date_of_birth_local}'::text[] AS date_of_birth_local,
    doc #>> '{fields,visited_contact_uuid}'::text[] AS visited_contact_uuid,
    doc #>> '{fields,patient_age_in_years}'::text[] AS patient_age_in_years,
    doc #>> '{fields,patient_age_in_months}'::text[] AS patient_age_in_months,
    doc #>> '{fields,patient_age_in_days}'::text[] AS patient_age_in_days,
    doc #>> '{fields,patient_age_display}'::text[] AS patient_age_display,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,patient_name}'::text[] AS patient_name,
    doc #>> '{fields,patient_gender}'::text[] AS patient_gender,
    doc #>> '{fields,recently_assessed}'::text[] AS recently_assessed, --(true/false)
    doc #>> '{fields,is_hiv_positive}'::text[] AS is_hiv_positive, --(true/false)
    doc #>> '{fields,lastDoseOfVitaminADate}'::text[] AS lastDoseOfVitaminADate,
    doc #>> '{fields,symptom_cough}'::text[] AS symptom_cough,
    doc #>> '{fields,symptom_indrawn_chest}'::text[] AS symptom_indrawn_chest,
    doc #>> '{fields,symptom_fast_breathing}'::text[] AS symptom_fast_breathing,
    doc #>> '{fields,symptom_diarrhoea}'::text[] AS symptom_diarrhoea,
    doc #>> '{fields,symptom_fever}'::text[] AS symptom_fever,
    doc #>> '{fields,num_of_mrdt_tests}'::text[] AS num_of_mrdt_tests, --(2/1)
    doc #>> '{fields,symptom_malaria_test}'::text[] AS symptom_malaria_test, /*Malaria: Positive/
Malaria: Negative/Malaria: Not done/Malaria: Invalid*/
    doc #>> '{fields,referral_follow_up}'::text[] AS referral_follow_up, --(yes/no)
    doc #>> '{fields,give_prereferral_treatment}'::text[] AS give_prereferral_treatment, --(yes/no)
    doc #>> '{fields,given_prereferral_treatment}'::text[] AS given_prereferral_treatment, --(yes/no)
    doc #>> '{fields,diagnosis_cough}'::text[] AS diagnosis_cough, --(yes/no)
    doc #>> '{fields,chw_area_id}'::text[] AS chw_area_id,
    doc #>> '{fields,chw_area_name}'::text[] AS chw_area_name,
    doc #>> '{fields,chw_name}'::text[] AS chw_name,
    doc #>> '{fields,chw_phone}'::text[] AS chw_phone,
    doc #>> '{fields,chw_village}'::text[] AS chw_village,
    doc #>> '{fields,supervisor_id}'::text[] AS supervisor_id,
    doc #>> '{fields,branch_id}'::text[] AS branch_id,
    doc #>> '{fields,fever_treatment}'::text[] AS fever_treatment, --(yes/no)
    doc #>> '{fields,cough_treatment}'::text[] AS cough_treatment, --(yes/no)
    doc #>> '{fields,diarrhoea_treatment}'::text[] AS diarrhoea_treatment, --(yes/no)
    doc #>> '{fields,act_prereferral_treatment_quantity}'::text[] AS act_prereferral_treatment_quantity, --(0/0.1/0.2)
    doc #>> '{fields,act_treatment_quantity}'::text[] AS act_treatment_quantity, --(0/1/2)
    doc #>> '{fields,act_given}'::text[] AS act_given, --(0/0.1/0.2/1/2)
    doc #>> '{fields,zinc_given}'::text[] AS zinc_given, --(1/0)
    doc #>> '{fields,amoxicillin_prereferral_treatment_quantity}'::text[] AS amoxicillin_prereferral_treatment_quantity, --(0/0.1/0.2)
    doc #>> '{fields,amoxicillin_treatment_quantity}'::text[] AS amoxicillin_treatment_quantity, --(0/1/2)
    doc #>> '{fields,amoxicillin_given}'::text[] AS amoxicillin_given, --(0/0.1/0.2/1/2)
    doc #>> '{fields,mrdt_given}'::text[] AS mrdt_given, --(0/1)
    doc #>> '{fields,rectal_given}'::text[] AS rectal_given, --(0/1/2)
    doc #>> '{fields,gloves_given}'::text[] AS gloves_given, --(int)
    doc #>> '{fields,diagnosis_diarrhoea}'::text[] AS diagnosis_diarrhoea,--(yes/no)
    doc #>> '{fields,diagnosis_fever}'::text[] AS diagnosis_fever,--(yes/no)
    doc #>> '{fields,treat_child_for_diagnosis}'::text[] AS treat_child_for_diagnosis,--(yes/no)
    doc #>> '{fields,needs_signoff}'::text[] AS needs_signoff, --(yes)
    doc #>> '{fields,should_escalate_nutrtion_referral_follow_up}'::text[] AS should_escalate_nutrtion_referral_follow_up, --(true/false)
    doc #>> '{fields,should_escalate_to_chew}'::text[] AS should_escalate_to_chew, --(true/false)
    doc #>> '{fields,group_vht_assessment_date,is_date_of_birth_correct}'::text[] AS vht_is_date_of_birth_correct, --(yes/no)
    doc #>> '{fields,group_danger_sign_screening,any_danger_signs}'::text[] AS gany_danger_signs,/*child_vomits_everything/
child_has_chestin_drawing/child_has_convulsions/child_cannot_drink_breastfeed/child_unconscious/
child_has_many_pustules/child_smaller_than_usual_size/child_has_low_temp/child_has_yellow_eyes_or_palms/
child_has_infected_umbilical_cord/none*/
    doc #>> '{fields,group_danger_sign_screening,child_has_danger_signs}'::text[] AS gchild_has_danger_signs, --(yes/no)
    doc #>> '{fields,group_cough,has_cough}'::text[] AS g_has_cough,--(yes/no)
    doc #>> '{fields,group_cough,cough_duration}'::text[] AS g_cough_duration, --(1/3/4/8/14/21)[1 day/3 days or less/4 - 7 days/8 - 13 days/14 - 20 days/21 days or more]
    doc #>> '{fields,group_cough,has_chest_indrawing}'::text[] AS g_has_chest_indrawing,--(yes/no)
    doc #>> '{fields,group_cough,cough_danger_sign}'::text[] AS g_cough_danger_sign,--(yes/no)
    doc #>> '{fields,group_breathing,fast_breathing}'::text[] AS g_fast_breathing, --(true/false)
    doc #>> '{fields,group_diarrhoea,has_diarrhoea}'::text[] AS g_has_diarrhoea,--(yes/no)
    doc #>> '{fields,group_diarrhoea,diarrhoea_duration}'::text[] AS g_diarrhoea_duration, --(1/2/3/less_than_14/more_than_14)[1 day/2 days or less/3 - 6 days/7 days - 14 days/More than 14 days]
    doc #>> '{fields,group_diarrhoea,blood_in_stool}'::text[] AS g_blood_in_stool, --(yes/no)
    doc #>> '{fields,group_diarrhoea,diarrhoea_danger_sign}'::text[] AS g_diarrhoea_danger_sign,--(yes/no)
    doc #>> '{fields,group_fever,has_fever}'::text[] AS g_has_fever,--(yes/no)
    doc #>> '{fields,group_fever,has_thermometer}'::text[] AS g_has_thermometer,--(yes/no)
    doc #>> '{fields,group_fever,fever_duration}'::text[] AS g_fever_duration,--(1/2/3/7/14)[1 day/2 days or less/3 - 6 days/7 - 14 days/More than 14 days]
    doc #>> '{fields,group_fever,has_mrdt}'::text[] AS g_has_mrdt, --(yes/no)
    doc #>> '{fields,group_fever,mrdt_repeat,mrdt_used_repeat}'::text[] AS g_mrdt_repeat_mrdt_used_repeat, --(carestat/bioline)
    doc #>> '{fields,group_fever,mrdt_repeat,mrdt_result_repeat}'::text[] AS g_mrdt_repeat_mrdt_result_repeat,--(positive/negative/invalid/none/)
    doc #>> '{fields,group_fever,want_to_repeat_mrdt}'::text[] AS g_want_to_repeat_mrdt, --(yes/no)
    doc #>> '{fields,group_fever,fever_danger_sign}'::text[] AS g_fever_danger_sign, --(yes/no)
    doc #>> '{fields,group_hiv_tb,has_hiv_exposure}'::text[] AS g_has_hiv_exposure, --(yes/no/unknown)
    doc #>> '{fields,group_hiv_tb,has_tb_exposure}'::text[] AS g_has_tb_exposure, --(yes/no/unknown)
    doc #>> '{fields,group_malnutrition,acute_malnutrition_signs}'::text[] AS g_acute_malnutrition_signs,--(swelling_of_both_feet/hair_color_changes/too_thin/none)
    doc #>> '{fields,group_malnutrition,muac_colour}'::text[] AS g_muac_colour, --(red/yellow/green)
    doc #>> '{fields,group_malnutrition,referred_to_health_facility}'::text[] AS mal_referred_to_health_facility, --(yes)
    doc #>> '{fields,group_malnutrition,appears_too_small}'::text[] AS g_appears_too_small, --(yes/no)
    doc #>> '{fields,group_malnutrition,malnutrition_danger_sign}'::text[] AS g_malnutrition_danger_sign, --(yes/no)
    doc #>> '{fields,group_immunization,has_chc}'::text[] AS g_has_chc, --(yes/no)
    doc #>> '{fields,group_immunization,immunization_received}'::text[] AS g_immunization_received,/*dpt1/dpt3/mr1/mr2/none/dpt1 dpt3/dpt1 mr1 mr2/mr1 mr2/dpt3 mr1 mr2/dpt1 dpt3 mr1/dpt1 dpt3 mr2*/
    doc #>> '{fields,group_immunization,immunization_uptodate}'::text[] AS g_immunization_uptodate, --(yes/no)
    doc #>> '{fields,group_immunization,afp_vpd}'::text[] AS g_afp_vpd, --(yes/no)
    doc #>> '{fields,group_other_information,exclusive_breast_feeding}'::text[] AS g_exclusive_breast_feeding, --(yes/no)
    doc #>> '{fields,group_other_information,reason_child_not_breastfeeding}'::text[] AS g_reason_child_not_breastfeeding,--(baby_on_mixed_feeding/cultural_beliefs/mother_low_milk_production/mother_occupation/others)
    doc #>> '{fields,group_other_information,referred_to_health_facility}'::text[] AS other_referred_to_health_facility, --(yes)
    doc #>> '{fields,group_other_information,still_breastfeeding}'::text[] AS g_still_breastfeeding, --(yes/no)
    doc #>> '{fields,group_other_information,walking_or_crawling}'::text[] AS g_walking_or_crawling, --(yes/no)
    doc #>> '{fields,group_other_information,child_been_dewormed}'::text[] AS g_child_been_dewormed, --(yes/no)
    doc #>> '{fields,group_other_information,received_vitamin_a}'::text[] AS g_received_vitamin_a, --(yes/no)
    doc #>> '{fields,group_other_information,refer_to_health_facility_no_vitamin_a}'::text[] AS g_refer_to_health_facility_no_vitamin_a, --(yes)
    doc #>> '{fields,group_patient_summary,s_note_patient_assessment}'::text[] AS g_s_note_patient_assessment,
    doc #>> '{fields,group_patient_summary,s_note_before_submit}'::text[] AS g_s_note_before_submit,
    doc #>> '{fields,group_patient_summary,s_note_patient_details}'::text[] AS g_s_note_patient_details,
    doc #>> '{fields,group_patient_summary,s_note_patient_details_values}'::text[] AS g_s_note_patient_details_values,
    doc #>> '{fields,group_patient_summary,s_note_signs_symptoms}'::text[] AS g_s_note_signs_symptoms,
    doc #>> '{fields,group_patient_summary,s_note_symptom_cough}'::text[] AS g_s_note_symptom_cough,
    doc #>> '{fields,group_patient_summary,s_note_symptom_indrawn_chest}'::text[] AS g_s_note_symptom_indrawn_chest,
    doc #>> '{fields,group_patient_summary,s_note_symptom_fast_breathing}'::text[] AS g_s_note_symptom_fast_breathing,
    doc #>> '{fields,group_patient_summary,s_note_symptom_diarrhoea}'::text[] AS g_s_note_symptom_diarrhoea,
    doc #>> '{fields,group_patient_summary,s_note_symptom_fever}'::text[] AS g_s_note_symptom_fever,
    doc #>> '{fields,group_patient_summary,s_note_symptom_malaria_test}'::text[] AS g_s_note_symptom_malaria_test,
    doc #>> '{fields,group_patient_summary,s_note_swollen_feet}'::text[] AS g_s_note_swollen_feet,
    doc #>> '{fields,group_patient_summary,s_note_red_yellow_muac}'::text[] AS g_s_note_red_yellow_muac,
    doc #>> '{fields,group_patient_summary,s_note_symptom_note}'::text[] AS g_s_note_symptom_note,
    doc #>> '{fields,group_patient_summary,s_note_symptom_danger_signs}'::text[] AS g_s_note_symptom_danger_signs,
    doc #>> '{fields,group_patient_summary,s_note_child_vomits_everything}'::text[] AS g_s_note_child_vomits_everything,
    doc #>> '{fields,group_patient_summary,s_note_child_has_convulsions}'::text[] AS g_s_note_child_has_convulsions,
    doc #>> '{fields,group_patient_summary,s_note_child_cannot_drink_breastfeed}'::text[] AS g_s_note_child_cannot_drink_breastfeed,
    doc #>> '{fields,group_patient_summary,s_note_child_unconscious}'::text[] AS g_s_note_child_unconscious,
    doc #>> '{fields,group_patient_summary,s_note_child_has_low_temp}'::text[] AS g_s_note_child_has_low_temp,
    doc #>> '{fields,group_patient_summary,s_note_child_has_yellow_eyes_or_palms}'::text[] AS g_s_note_child_has_yellow_eyes_or_palms,
    doc #>> '{fields,group_patient_summary,s_note_child_has_infected_umbilical_cord}'::text[] AS g_s_note_child_has_infected_umbilical_cord,
    doc #>> '{fields,group_patient_summary,s_note_child_has_chest_in_drawing}'::text[] AS g_s_note_child_has_chest_in_drawing,
    doc #>> '{fields,group_patient_summary,s_note_child_has_many_pustules}'::text[] AS g_s_note_child_has_many_pustules,
    doc #>> '{fields,group_patient_summary,s_note_child_smaller_than_usual_size}'::text[] AS g_s_note_child_smaller_than_usual_size,
    doc #>> '{fields,group_patient_summary,s_note_hiv_exposure_title}'::text[] AS g_s_note_hiv_exposure_title,
    doc #>> '{fields,group_patient_summary,s_note_hiv_exposure_value}'::text[] AS g_s_note_hiv_exposure_value,
    doc #>> '{fields,group_patient_summary,s_note_tb_exposure_title}'::text[] AS g_s_note_tb_exposure_title,
    doc #>> '{fields,group_patient_summary,s_note_tb_exposure_value}'::text[] AS g_s_note_tb_exposure_value,
    doc #>> '{fields,group_patient_summary,s_note_prereferral_treatment}'::text[] AS g_s_note_prereferral_treatment,
    doc #>> '{fields,group_patient_summary,s-note_prerefferral_treatment_cough_main}'::text[] AS g_s_note_prerefferral_treatment_cough_main,
    doc #>> '{fields,group_patient_summary,s_note_prereferral_treatment_cough}'::text[] AS g_s_note_prereferral_treatment_cough,
    doc #>> '{fields,group_patient_summary,s_note_prereferral_treatment_cough2}'::text[] AS g_s_note_prereferral_treatment_cough2,
    doc #>> '{fields,group_patient_summary,s_note_prereferral_treatment_cough_instruction}'::text[] AS g_s_note_prereferral_treatment_cough_instruction,
    doc #>> '{fields,group_patient_summary,cough_prereferral_treatment_given}'::text[] AS g_cough_prereferral_treatment_given, --(yes/no)
    doc #>> '{fields,group_patient_summary,diarrhoea_prerefferal_treatment-header}'::text[] AS g_diarrhoea_prerefferal_treatment_header,
    doc #>> '{fields,group_patient_summary,s_note_prereferral_treatment_diarrhoea}'::text[] AS g_s_note_prereferral_treatment_diarrhoea,
    doc #>> '{fields,group_patient_summary,s_note_prereferral_treatment_diarrhoea2}'::text[] AS g_s_note_prereferral_treatment_diarrhoea2,
    doc #>> '{fields,group_patient_summary,s_note_prereferral_treatment_diarrhoea_instruction}'::text[] AS g_s_note_prereferral_treatment_diarrhoea_instruction,
    doc #>> '{fields,group_patient_summary,diarrhoea_prereferral_treatment_given}'::text[] AS g_diarrhoea_prereferral_treatment_given, --(yes/no)
    doc #>> '{fields,group_patient_summary,s_note_prerefferal_treatment_header_fever}'::text[] AS g_s_note_prerefferal_treatment_header_fever,
    doc #>> '{fields,group_patient_summary,s_note_prereferral_treatment_fever}'::text[] AS g_s_note_prereferral_treatment_fever,
    doc #>> '{fields,group_patient_summary,s_note_prereferral_treatment_fever2}'::text[] AS g_s_note_prereferral_treatment_fever2,
    doc #>> '{fields,group_patient_summary,s_note_prereferral_treatment_fever_instruction}'::text[] AS g_s_note_prereferral_treatment_fever_instruction,
    doc #>> '{fields,group_patient_summary,fever_prereferral_treatment_given}'::text[] AS g_fever_prereferral_treatment_given, --(yes/no)
    doc #>> '{fields,group_patient_summary,general_signs_header}'::text[] AS g_general_signs_header,
    doc #>> '{fields,group_patient_summary,s_note_prereferral_treatment_danger_sign}'::text[] AS g_s_note_prereferral_treatment_danger_sign,
    doc #>> '{fields,group_patient_summary,s_note_prereferral_treatment_danger_sign2}'::text[] AS g_s_note_prereferral_treatment_danger_sign2,
    doc #>> '{fields,group_patient_summary,s_note_prereferral_treatment_danger_sign_instruction}'::text[] AS g_s_note_prereferral_treatment_danger_sign_instruction,
    doc #>> '{fields,group_patient_summary,danger_sign_prereferral_treatment_given}'::text[] AS g_danger_sign_prereferral_treatment_given, --(yes/no)
    doc #>> '{fields,group_patient_summary,s_note_prereferral_treatment_newborn_danger_sign}'::text[] AS g_s_note_prereferral_treatment_newborn_danger_sign,
    doc #>> '{fields,group_patient_summary,s_note_diagnosis}'::text[] AS g_s_note_diagnosis,
    doc #>> '{fields,group_patient_summary,s_note_diagnosis_cough}'::text[] AS g_s_note_diagnosis_cough,
    doc #>> '{fields,group_patient_summary,s_note_cough_treatment}'::text[] AS g_s_note_cough_treatment,
    doc #>> '{fields,group_patient_summary,s_note_cough_treatment_dose1}'::text[] AS g_s_note_cough_treatment_dose1,
    doc #>> '{fields,group_patient_summary,s_note_cough_treatment_dose2}'::text[] AS g_s_note_cough_treatment_dose2,
    doc #>> '{fields,group_patient_summary,s_note_cough_special_instruction}'::text[] AS g_s_note_cough_special_instruction,
    doc #>> '{fields,group_patient_summary,s_note_cough_special_instruction1}'::text[] AS g_s_note_cough_special_instruction1,
    doc #>> '{fields,group_patient_summary,cough_treatment_given}'::text[] AS g_cough_treatment_given, --(yes/no)
    doc #>> '{fields,group_patient_summary,s_note_diagnosis_diarrhoea}'::text[] AS g_s_note_diagnosis_diarrhoea,
    doc #>> '{fields,group_patient_summary,s_note_diarrhoea_ors_dose1}'::text[] AS g_s_note_diarrhoea_ors_dose1,
    doc #>> '{fields,group_patient_summary,s_note_diarrhoea_ors_dose2}'::text[] AS g_s_note_diarrhoea_ors_dose2,
    doc #>> '{fields,group_patient_summary,s_note_diarrhoea_zinc_dose1}'::text[] AS g_s_note_diarrhoea_zinc_dose1,
    doc #>> '{fields,group_patient_summary,s_note_diarrhoea_zinc_dose2}'::text[] AS g_s_note_diarrhoea_zinc_dose2,
    doc #>> '{fields,group_patient_summary,s_note_diarrhoea_special_instruction}'::text[] AS g_s_note_diarrhoea_special_instruction,
    doc #>> '{fields,group_patient_summary,s_note_diarrhoea_special_instruction_ors1}'::text[] AS g_s_note_diarrhoea_special_instruction_ors1,
    doc #>> '{fields,group_patient_summary,diarrhoea_treatment_given}'::text[] AS g_diarrhoea_treatment_given, --(yes/no)
    doc #>> '{fields,group_patient_summary,s_note_diagnosis_fever}'::text[] AS g_s_note_diagnosis_fever,
    doc #>> '{fields,group_patient_summary,s_note_fever_treatment}'::text[] AS g_s_note_fever_treatment,
    doc #>> '{fields,group_patient_summary,s_note_fever_dose1}'::text[] AS g_s_note_fever_dose1,
    doc #>> '{fields,group_patient_summary,s_note_fever_dose2}'::text[] AS g_s_note_fever_dose2,
    doc #>> '{fields,group_patient_summary,s_note_fever_special_instruction}'::text[] AS g_s_note_fever_special_instruction,
    doc #>> '{fields,group_patient_summary,s_note_fever_special_instruction1}'::text[] AS g_s_note_fever_special_instruction1,
    doc #>> '{fields,group_patient_summary,s_note_fever_special_instruction2}'::text[] AS g_s_note_fever_special_instruction2,
    doc #>> '{fields,group_patient_summary,fever_treatment_given}'::text[] AS g_fever_treatment_given, --(yes/no)
    doc #>> '{fields,group_patient_summary,have_you_referred}'::text[] AS g_have_you_referred, --(yes)
    doc #>> '{fields,group_patient_summary,gloves_used_mrdt}'::text[] AS g_gloves_used_mrdt, --(0/1/2/3/4/5)
    doc #>> '{fields,group_patient_summary,test_kits_used_mrdt}'::text[] AS g_test_kits_used_mrdt, --(0/1/2/3/4/5)
    doc #>> '{fields,group_patient_summary,gloves_used_rectal}'::text[] AS g_gloves_used_rectal, --(0/1/2/3/4/5)

    -- Last column for tracking refresh
    CURRENT_TIMESTAMP AS last_refresh_date

FROM dwh.cht_data
WHERE (doc ->> 'form'::text) = 'assessment'::text
  AND is_current
WITH NO DATA;

-- Indexes
CREATE INDEX mv_assessment_new_reported
    ON cht.mv_assessment_new USING btree (reported);
CREATE INDEX mv_assessment_new_patient_id
    ON cht.mv_assessment_new USING btree (patient_id);
CREATE INDEX mv_assessment_new_chw_id
    ON cht.mv_assessment_new USING btree (chw_id);

