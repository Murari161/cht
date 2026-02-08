INSERT INTO cht.fact_cht_numeric_values (
    uuid,
    theme,
    dataset,
    data_element,
    value,
    date,
    chw_id,
    facility_id,
    district_id,
    region,
    patient_age_in_years,
    patient_age_in_months,
    patient_age_in_days,
    patient_sex,
    patient_dob,
    source_system,
    source_form
)
SELECT
    uuid AS uuid,
    'child_health' AS theme,
    'assessment' AS dataset,
    unpivot.data_element,
    unpivot.value,
    date,
    chw_id,
    contact_facility_id AS facility_id,
    district_id AS district_id,
    region_id AS region,
    patient_age_in_years,
    patient_age_in_months,
    patient_age_in_days,
    patient_gender AS patient_sex,
    inputs_contact_date_of_birth AS patient_dob,
    'cht' AS source_system,
    'assessment' AS source_form
FROM (
    SELECT
        uuid,
        date,
        chw_id,
        contact_facility_id,
        district_id,
        region_id,
        patient_age_in_years,
        patient_age_in_months,
        patient_age_in_days,
        patient_gender,
        inputs_contact_date_of_birth,

        -- indicator columns (categorical and numeric)
        LOWER(TRIM(vaccination_expected)) AS vaccination_expected,
        LOWER(TRIM(recently_assessed)) AS recently_assessed,
        LOWER(TRIM(is_hiv_positive)) AS is_hiv_positive,
        LOWER(TRIM(num_of_mrdt_tests)) AS num_of_mrdt_tests,
        LOWER(TRIM(symptom_malaria_test)) AS symptom_malaria_test,
        LOWER(TRIM(referral_follow_up)) AS referral_follow_up,
        LOWER(TRIM(give_prereferral_treatment)) AS give_prereferral_treatment,
        LOWER(TRIM(given_prereferral_treatment)) AS given_prereferral_treatment,
        LOWER(TRIM(diagnosis_cough)) AS diagnosis_cough,
        LOWER(TRIM(fever_treatment)) AS fever_treatment,
        LOWER(TRIM(cough_treatment)) AS cough_treatment,
        LOWER(TRIM(diarrhoea_treatment)) AS diarrhoea_treatment,
        LOWER(TRIM(act_prereferral_treatment_quantity)) AS act_prereferral_treatment_quantity,
        LOWER(TRIM(act_treatment_quantity)) AS act_treatment_quantity,
        LOWER(TRIM(act_given)) AS act_given,
        LOWER(TRIM(zinc_given)) AS zinc_given,
        LOWER(TRIM(amoxicillin_prereferral_treatment_quantity)) AS amoxicillin_prereferral_treatment_quantity,
        LOWER(TRIM(amoxicillin_treatment_quantity)) AS amoxicillin_treatment_quantity,
        LOWER(TRIM(amoxicillin_given)) AS amoxicillin_given,
        LOWER(TRIM(mrdt_given)) AS mrdt_given,
        LOWER(TRIM(rectal_given)) AS rectal_given,
        gloves_given,
        LOWER(TRIM(diagnosis_diarrhoea)) AS diagnosis_diarrhoea,
        LOWER(TRIM(diagnosis_fever)) AS diagnosis_fever,
        LOWER(TRIM(treat_child_for_diagnosis)) AS treat_child_for_diagnosis,
        LOWER(TRIM(needs_signoff)) AS needs_signoff,
        LOWER(TRIM(should_escalate_nutrtion_referral_follow_up)) AS should_escalate_nutrtion_referral_follow_up,
        LOWER(TRIM(should_escalate_to_chew)) AS should_escalate_to_chew,
        LOWER(TRIM(vht_is_date_of_birth_correct)) AS vht_is_date_of_birth_correct,
        LOWER(TRIM(gany_danger_signs)) AS gany_danger_signs,
        LOWER(TRIM(gchild_has_danger_signs)) AS gchild_has_danger_signs,
        LOWER(TRIM(g_has_cough)) AS g_has_cough,
        LOWER(TRIM(g_cough_duration)) AS g_cough_duration,
        LOWER(TRIM(g_has_chest_indrawing)) AS g_has_chest_indrawing,
        LOWER(TRIM(g_cough_danger_sign)) AS g_cough_danger_sign,
        LOWER(TRIM(g_fast_breathing)) AS g_fast_breathing,
        LOWER(TRIM(g_has_diarrhoea)) AS g_has_diarrhoea,
        LOWER(TRIM(g_diarrhoea_duration)) AS g_diarrhoea_duration,
        LOWER(TRIM(g_blood_in_stool)) AS g_blood_in_stool,
        LOWER(TRIM(g_diarrhoea_danger_sign)) AS g_diarrhoea_danger_sign,
        LOWER(TRIM(g_has_fever)) AS g_has_fever,
        LOWER(TRIM(g_has_thermometer)) AS g_has_thermometer,
        LOWER(TRIM(g_fever_duration)) AS g_fever_duration,
        LOWER(TRIM(g_has_mrdt)) AS g_has_mrdt,
        LOWER(TRIM(g_mrdt_repeat_mrdt_used_repeat)) AS g_mrdt_repeat_mrdt_used_repeat,
        LOWER(TRIM(g_mrdt_repeat_mrdt_result_repeat)) AS g_mrdt_repeat_mrdt_result_repeat,
        LOWER(TRIM(g_want_to_repeat_mrdt)) AS g_want_to_repeat_mrdt,
        LOWER(TRIM(g_fever_danger_sign)) AS g_fever_danger_sign,
        LOWER(TRIM(g_has_hiv_exposure)) AS g_has_hiv_exposure,
        LOWER(TRIM(g_has_tb_exposure)) AS g_has_tb_exposure,
        LOWER(TRIM(g_acute_malnutrition_signs)) AS g_acute_malnutrition_signs,
        LOWER(TRIM(g_muac_colour)) AS g_muac_colour,
        LOWER(TRIM(mal_referred_to_health_facility)) AS mal_referred_to_health_facility,
        LOWER(TRIM(g_appears_too_small)) AS g_appears_too_small,
        LOWER(TRIM(g_malnutrition_danger_sign)) AS g_malnutrition_danger_sign,
        LOWER(TRIM(g_has_chc)) AS g_has_chc,
        LOWER(TRIM(g_immunization_received)) AS g_immunization_received,
        LOWER(TRIM(g_immunization_uptodate)) AS g_immunization_uptodate,
        LOWER(TRIM(g_afp_vpd)) AS g_afp_vpd,
        LOWER(TRIM(g_exclusive_breast_feeding)) AS g_exclusive_breast_feeding,
        LOWER(TRIM(g_reason_child_not_breastfeeding)) AS g_reason_child_not_breastfeeding,
        LOWER(TRIM(other_referred_to_health_facility)) AS other_referred_to_health_facility,
        LOWER(TRIM(g_still_breastfeeding)) AS g_still_breastfeeding,
        LOWER(TRIM(g_walking_or_crawling)) AS g_walking_or_crawling,
        LOWER(TRIM(g_child_been_dewormed)) AS g_child_been_dewormed,
        LOWER(TRIM(g_received_vitamin_a)) AS g_received_vitamin_a,
        LOWER(TRIM(g_refer_to_health_facility_no_vitamin_a)) AS g_refer_to_health_facility_no_vitamin_a,
        LOWER(TRIM(g_cough_prereferral_treatment_given)) AS g_cough_prereferral_treatment_given,
        LOWER(TRIM(g_diarrhoea_prereferral_treatment_given)) AS g_diarrhoea_prereferral_treatment_given,
        LOWER(TRIM(g_fever_prereferral_treatment_given)) AS g_fever_prereferral_treatment_given,
        LOWER(TRIM(g_danger_sign_prereferral_treatment_given)) AS g_danger_sign_prereferral_treatment_given,
        LOWER(TRIM(g_cough_treatment_given)) AS g_cough_treatment_given,
        LOWER(TRIM(g_diarrhoea_treatment_given)) AS g_diarrhoea_treatment_given,
        LOWER(TRIM(g_fever_treatment_given)) AS g_fever_treatment_given,
        LOWER(TRIM(g_have_you_referred)) AS g_have_you_referred,
        LOWER(TRIM(g_gloves_used_mrdt)) AS g_gloves_used_mrdt,
        LOWER(TRIM(g_test_kits_used_mrdt)) AS g_test_kits_used_mrdt,
        LOWER(TRIM(g_gloves_used_rectal)) AS g_gloves_used_rectal
    FROM cht.mv_assessment_new
) src
CROSS JOIN LATERAL (
    VALUES
        -- vaccination_expected (yes/no) - binary
        ('vaccination_expected - Yes', CASE WHEN src.vaccination_expected = 'yes' THEN 1 ELSE 0 END),
        ('vaccination_expected - No', CASE WHEN src.vaccination_expected = 'no' THEN 1 ELSE 0 END),

        -- recently_assessed (true/false) - binary
        ('recently_assessed - True', CASE WHEN src.recently_assessed = 'true' THEN 1 ELSE 0 END),
        ('recently_assessed - False', CASE WHEN src.recently_assessed = 'false' THEN 1 ELSE 0 END),

        -- is_hiv_positive (true/false) - binary
        ('is_hiv_positive - True', CASE WHEN src.is_hiv_positive = 'true' THEN 1 ELSE 0 END),
        ('is_hiv_positive - False', CASE WHEN src.is_hiv_positive = 'false' THEN 1 ELSE 0 END),

        -- num_of_mrdt_tests (2/1) - binary
        ('num_of_mrdt_tests - 2', CASE WHEN src.num_of_mrdt_tests = '2' THEN 1 ELSE 0 END),
        ('num_of_mrdt_tests - 1', CASE WHEN src.num_of_mrdt_tests = '1' THEN 1 ELSE 0 END),

        -- symptom_malaria_test (Malaria: Positive/Malaria: Negative/Malaria: Not done/Malaria: Invalid) - binary
        ('symptom_malaria_test - Malaria: Positive', CASE WHEN src.symptom_malaria_test LIKE '%malaria: positive%' THEN 1 ELSE 0 END),
        ('symptom_malaria_test - Malaria: Negative', CASE WHEN src.symptom_malaria_test LIKE '%malaria: negative%' THEN 1 ELSE 0 END),
        ('symptom_malaria_test - Malaria: Not done', CASE WHEN src.symptom_malaria_test LIKE '%malaria: not done%' THEN 1 ELSE 0 END),
        ('symptom_malaria_test - Malaria: Invalid', CASE WHEN src.symptom_malaria_test LIKE '%malaria: invalid%' THEN 1 ELSE 0 END),

        -- referral_follow_up (yes/no) - binary
        ('referral_follow_up - Yes', CASE WHEN src.referral_follow_up = 'yes' THEN 1 ELSE 0 END),
        ('referral_follow_up - No', CASE WHEN src.referral_follow_up = 'no' THEN 1 ELSE 0 END),

        -- give_prereferral_treatment (yes/no) - binary
        ('give_prereferral_treatment - Yes', CASE WHEN src.give_prereferral_treatment = 'yes' THEN 1 ELSE 0 END),
        ('give_prereferral_treatment - No', CASE WHEN src.give_prereferral_treatment = 'no' THEN 1 ELSE 0 END),

        -- given_prereferral_treatment (yes/no) - binary
        ('given_prereferral_treatment - Yes', CASE WHEN src.given_prereferral_treatment = 'yes' THEN 1 ELSE 0 END),
        ('given_prereferral_treatment - No', CASE WHEN src.given_prereferral_treatment = 'no' THEN 1 ELSE 0 END),

        -- diagnosis_cough (yes/no) - binary
        ('diagnosis_cough - Yes', CASE WHEN src.diagnosis_cough = 'yes' THEN 1 ELSE 0 END),
        ('diagnosis_cough - No', CASE WHEN src.diagnosis_cough = 'no' THEN 1 ELSE 0 END),

        -- fever_treatment (yes/no) - binary
        ('fever_treatment - Yes', CASE WHEN src.fever_treatment = 'yes' THEN 1 ELSE 0 END),
        ('fever_treatment - No', CASE WHEN src.fever_treatment = 'no' THEN 1 ELSE 0 END),

        -- cough_treatment (yes/no) - binary
        ('cough_treatment - Yes', CASE WHEN src.cough_treatment = 'yes' THEN 1 ELSE 0 END),
        ('cough_treatment - No', CASE WHEN src.cough_treatment = 'no' THEN 1 ELSE 0 END),

        -- diarrhoea_treatment (yes/no) - binary
        ('diarrhoea_treatment - Yes', CASE WHEN src.diarrhoea_treatment = 'yes' THEN 1 ELSE 0 END),
        ('diarrhoea_treatment - No', CASE WHEN src.diarrhoea_treatment = 'no' THEN 1 ELSE 0 END),

        -- act_prereferral_treatment_quantity (0/0.1/0.2) - binary
        ('act_prereferral_treatment_quantity - 0', CASE WHEN src.act_prereferral_treatment_quantity = '0' THEN 1 ELSE 0 END),
        ('act_prereferral_treatment_quantity - 0.1', CASE WHEN src.act_prereferral_treatment_quantity = '0.1' THEN 1 ELSE 0 END),
        ('act_prereferral_treatment_quantity - 0.2', CASE WHEN src.act_prereferral_treatment_quantity = '0.2' THEN 1 ELSE 0 END),

        -- act_treatment_quantity (0/1/2) - binary
        ('act_treatment_quantity - 0', CASE WHEN src.act_treatment_quantity = '0' THEN 1 ELSE 0 END),
        ('act_treatment_quantity - 1', CASE WHEN src.act_treatment_quantity = '1' THEN 1 ELSE 0 END),
        ('act_treatment_quantity - 2', CASE WHEN src.act_treatment_quantity = '2' THEN 1 ELSE 0 END),

        -- act_given (0/0.1/0.2/1/2) - binary
        ('act_given - 0', CASE WHEN src.act_given = '0' THEN 1 ELSE 0 END),
        ('act_given - 0.1', CASE WHEN src.act_given = '0.1' THEN 1 ELSE 0 END),
        ('act_given - 0.2', CASE WHEN src.act_given = '0.2' THEN 1 ELSE 0 END),
        ('act_given - 1', CASE WHEN src.act_given = '1' THEN 1 ELSE 0 END),
        ('act_given - 2', CASE WHEN src.act_given = '2' THEN 1 ELSE 0 END),

        -- zinc_given (1/0) - binary
        ('zinc_given - 1', CASE WHEN src.zinc_given = '1' THEN 1 ELSE 0 END),
        ('zinc_given - 0', CASE WHEN src.zinc_given = '0' THEN 1 ELSE 0 END),

        -- amoxicillin_prereferral_treatment_quantity (0/0.1/0.2) - binary
        ('amoxicillin_prereferral_treatment_quantity - 0', CASE WHEN src.amoxicillin_prereferral_treatment_quantity = '0' THEN 1 ELSE 0 END),
        ('amoxicillin_prereferral_treatment_quantity - 0.1', CASE WHEN src.amoxicillin_prereferral_treatment_quantity = '0.1' THEN 1 ELSE 0 END),
        ('amoxicillin_prereferral_treatment_quantity - 0.2', CASE WHEN src.amoxicillin_prereferral_treatment_quantity = '0.2' THEN 1 ELSE 0 END),

        -- amoxicillin_treatment_quantity (0/1/2) - binary
        ('amoxicillin_treatment_quantity - 0', CASE WHEN src.amoxicillin_treatment_quantity = '0' THEN 1 ELSE 0 END),
        ('amoxicillin_treatment_quantity - 1', CASE WHEN src.amoxicillin_treatment_quantity = '1' THEN 1 ELSE 0 END),
        ('amoxicillin_treatment_quantity - 2', CASE WHEN src.amoxicillin_treatment_quantity = '2' THEN 1 ELSE 0 END),

        -- amoxicillin_given (0/0.1/0.2/1/2) - binary
        ('amoxicillin_given - 0', CASE WHEN src.amoxicillin_given = '0' THEN 1 ELSE 0 END),
        ('amoxicillin_given - 0.1', CASE WHEN src.amoxicillin_given = '0.1' THEN 1 ELSE 0 END),
        ('amoxicillin_given - 0.2', CASE WHEN src.amoxicillin_given = '0.2' THEN 1 ELSE 0 END),
        ('amoxicillin_given - 1', CASE WHEN src.amoxicillin_given = '1' THEN 1 ELSE 0 END),
        ('amoxicillin_given - 2', CASE WHEN src.amoxicillin_given = '2' THEN 1 ELSE 0 END),

        -- mrdt_given (0/1) - binary
        ('mrdt_given - 0', CASE WHEN src.mrdt_given = '0' THEN 1 ELSE 0 END),
               ('mrdt_given - 1', CASE WHEN src.mrdt_given = '1' THEN 1 ELSE 0 END),

        -- rectal_given (0/1/2/3/4/5) - binary
        ('rectal_given - 0', CASE WHEN src.rectal_given = '0' THEN 1 ELSE 0 END),
        ('rectal_given - 1', CASE WHEN src.rectal_given = '1' THEN 1 ELSE 0 END),
        ('rectal_given - 2', CASE WHEN src.rectal_given = '2' THEN 1 ELSE 0 END),
        ('rectal_given - 3', CASE WHEN src.rectal_given = '3' THEN 1 ELSE 0 END),
        ('rectal_given - 4', CASE WHEN src.rectal_given = '4' THEN 1 ELSE 0 END),
        ('rectal_given - 5', CASE WHEN src.rectal_given = '5' THEN 1 ELSE 0 END),

        -- gloves_given (int) - numeric, null to 0
        ('gloves_given', COALESCE(src.gloves_given, 0)),

        -- diagnosis_diarrhoea (yes/no) - binary
        ('diagnosis_diarrhoea - Yes', CASE WHEN src.diagnosis_diarrhoea = 'yes' THEN 1 ELSE 0 END),
        ('diagnosis_diarrhoea - No', CASE WHEN src.diagnosis_diarrhoea = 'no' THEN 1 ELSE 0 END),

        -- diagnosis_fever (yes/no) - binary
        ('diagnosis_fever - Yes', CASE WHEN src.diagnosis_fever = 'yes' THEN 1 ELSE 0 END),
        ('diagnosis_fever - No', CASE WHEN src.diagnosis_fever = 'no' THEN 1 ELSE 0 END),

        -- treat_child_for_diagnosis (yes/no) - binary
        ('treat_child_for_diagnosis - Yes', CASE WHEN src.treat_child_for_diagnosis = 'yes' THEN 1 ELSE 0 END),
        ('treat_child_for_diagnosis - No', CASE WHEN src.treat_child_for_diagnosis = 'no' THEN 1 ELSE 0 END),

        -- needs_signoff (yes) - binary
        ('needs_signoff - Yes', CASE WHEN src.needs_signoff = 'yes' THEN 1 ELSE 0 END),

        -- should_escalate_nutrtion_referral_follow_up (true/false) - binary
        ('should_escalate_nutrtion_referral_follow_up - True', CASE WHEN src.should_escalate_nutrtion_referral_follow_up = 'true' THEN 1 ELSE 0 END),
        ('should_escalate_nutrtion_referral_follow_up - False', CASE WHEN src.should_escalate_nutrtion_referral_follow_up = 'false' THEN 1 ELSE 0 END),

        -- should_escalate_to_chew (true/false) - binary
        ('should_escalate_to_chew - True', CASE WHEN src.should_escalate_to_chew = 'true' THEN 1 ELSE 0 END),
        ('should_escalate_to_chew - False', CASE WHEN src.should_escalate_to_chew = 'false' THEN 1 ELSE 0 END),

        -- vht_is_date_of_birth_correct (yes/no) - binary
        ('vht_is_date_of_birth_correct - Yes', CASE WHEN src.vht_is_date_of_birth_correct = 'yes' THEN 1 ELSE 0 END),
        ('vht_is_date_of_birth_correct - No', CASE WHEN src.vht_is_date_of_birth_correct = 'no' THEN 1 ELSE 0 END),

        -- gany_danger_signs (child_vomits_everything/child_has_chestin_drawing/child_has_convulsions/child_cannot_drink_breastfeed/child_unconscious/child_has_many_pustules/child_smaller_than_usual_size/child_has_low_temp/child_has_yellow_eyes_or_palms/child_has_infected_umbilical_cord/none) - binary
        ('any_danger_signs - Child_vomits_everything', CASE WHEN src.gany_danger_signs LIKE '%child_vomits_everything%' THEN 1 ELSE 0 END),
        ('any_danger_signs - Child_has_chestin_drawing', CASE WHEN src.gany_danger_signs LIKE '%child_has_chestin_drawing%' THEN 1 ELSE 0 END),
        ('any_danger_signs - Child_has_convulsions', CASE WHEN src.gany_danger_signs LIKE '%child_has_convulsions%' THEN 1 ELSE 0 END),
        ('any_danger_signs - Child_cannot_drink_breastfeed', CASE WHEN src.gany_danger_signs LIKE '%child_cannot_drink_breastfeed%' THEN 1 ELSE 0 END),
        ('any_danger_signs - Child_unconscious', CASE WHEN src.gany_danger_signs LIKE '%child_unconscious%' THEN 1 ELSE 0 END),
        ('any_danger_signs - Child_has_many_pustules', CASE WHEN src.gany_danger_signs LIKE '%child_has_many_pustules%' THEN 1 ELSE 0 END),
        ('any_danger_signs - Child_smaller_than_usual_size', CASE WHEN src.gany_danger_signs LIKE '%child_smaller_than_usual_size%' THEN 1 ELSE 0 END),
        ('any_danger_signs - Child_has_low_temp', CASE WHEN src.gany_danger_signs LIKE '%child_has_low_temp%' THEN 1 ELSE 0 END),
        ('any_danger_signs - Child_has_yellow_eyes_or_palms', CASE WHEN src.gany_danger_signs LIKE '%child_has_yellow_eyes_or_palms%' THEN 1 ELSE 0 END),
        ('any_danger_signs - Child_has_infected_umbilical_cord', CASE WHEN src.gany_danger_signs LIKE '%child_has_infected_umbilical_cord%' THEN 1 ELSE 0 END),
        ('any_danger_signs - None', CASE WHEN src.gany_danger_signs LIKE '%none%' THEN 1 ELSE 0 END),

        -- gchild_has_danger_signs (yes/no) - binary
        ('child_has_danger_signs - Yes', CASE WHEN src.gchild_has_danger_signs = 'yes' THEN 1 ELSE 0 END),
        ('child_has_danger_signs - No', CASE WHEN src.gchild_has_danger_signs = 'no' THEN 1 ELSE 0 END),

        -- g_has_cough (yes/no) - binary
        ('has_cough - Yes', CASE WHEN src.g_has_cough = 'yes' THEN 1 ELSE 0 END),
        ('has_cough - No', CASE WHEN src.g_has_cough = 'no' THEN 1 ELSE 0 END),

        -- g_cough_duration (1/3/4/8/14/21)[1 day/3 days or less/4 - 7 days/8 - 13 days/14 - 20 days/21 days or more] - binary
        ('cough_duration - 1 day', CASE WHEN src.g_cough_duration = '1' THEN 1 ELSE 0 END),
        ('cough_duration - 3 days or less', CASE WHEN src.g_cough_duration = '3' THEN 1 ELSE 0 END),
        ('cough_duration - 4 - 7 days', CASE WHEN src.g_cough_duration = '4' THEN 1 ELSE 0 END),
        ('cough_duration - 8 - 13 days', CASE WHEN src.g_cough_duration = '8' THEN 1 ELSE 0 END),
        ('cough_duration - 14 - 20 days', CASE WHEN src.g_cough_duration = '14' THEN 1 ELSE 0 END),
        ('cough_duration - 21 days or more', CASE WHEN src.g_cough_duration = '21' THEN 1 ELSE 0 END),

        -- g_has_chest_indrawing (yes/no) - binary
        ('has_chest_indrawing - Yes', CASE WHEN src.g_has_chest_indrawing = 'yes' THEN 1 ELSE 0 END),
        ('has_chest_indrawing - No', CASE WHEN src.g_has_chest_indrawing = 'no' THEN 1 ELSE 0 END),

        -- g_cough_danger_sign (yes/no) - binary
        ('cough_danger_sign - Yes', CASE WHEN src.g_cough_danger_sign = 'yes' THEN 1 ELSE 0 END),
        ('cough_danger_sign - No', CASE WHEN src.g_cough_danger_sign = 'no' THEN 1 ELSE 0 END),

        -- g_fast_breathing (true/false) - binary
        ('fast_breathing - True', CASE WHEN src.g_fast_breathing = 'true' THEN 1 ELSE 0 END),
        ('fast_breathing - False', CASE WHEN src.g_fast_breathing = 'false' THEN 1 ELSE 0 END),

        -- g_has_diarrhoea (yes/no) - binary
        ('has_diarrhoea - Yes', CASE WHEN src.g_has_diarrhoea = 'yes' THEN 1 ELSE 0 END),
        ('has_diarrhoea - No', CASE WHEN src.g_has_diarrhoea = 'no' THEN 1 ELSE 0 END),

        -- g_diarrhoea_duration (1/2/3/less_than_14/more_than_14)[1 day/2 days or less/3 - 6 days/7 days - 14 days/More than 14 days] - binary
        ('diarrhoea_duration - 1 day', CASE WHEN src.g_diarrhoea_duration = '1' THEN 1 ELSE 0 END),
        ('diarrhoea_duration - 2 days or less', CASE WHEN src.g_diarrhoea_duration = '2' THEN 1 ELSE 0 END),
        ('diarrhoea_duration - 3 - 6 days', CASE WHEN src.g_diarrhoea_duration = '3' THEN 1 ELSE 0 END),
        ('diarrhoea_duration - 7 days - 14 days', CASE WHEN src.g_diarrhoea_duration = 'less_than_14' THEN 1 ELSE 0 END),
        ('diarrhoea_duration - More than 14 days', CASE WHEN src.g_diarrhoea_duration = 'more_than_14' THEN 1 ELSE 0 END),

        -- g_blood_in_stool (yes/no) - binary
        ('blood_in_stool - Yes', CASE WHEN src.g_blood_in_stool = 'yes' THEN 1 ELSE 0 END),
        ('blood_in_stool - No', CASE WHEN src.g_blood_in_stool = 'no' THEN 1 ELSE 0 END),

        -- g_diarrhoea_danger_sign (yes/no) - binary
        ('diarrhoea_danger_sign - Yes', CASE WHEN src.g_diarrhoea_danger_sign = 'yes' THEN 1 ELSE 0 END),
        ('diarrhoea_danger_sign - No', CASE WHEN src.g_diarrhoea_danger_sign = 'no' THEN 1 ELSE 0 END),

        -- g_has_fever (yes/no) - binary
        ('has_fever - Yes', CASE WHEN src.g_has_fever = 'yes' THEN 1 ELSE 0 END),
        ('has_fever - No', CASE WHEN src.g_has_fever = 'no' THEN 1 ELSE 0 END),

        -- g_has_thermometer (yes/no) - binary
        ('has_thermometer - Yes', CASE WHEN src.g_has_thermometer = 'yes' THEN 1 ELSE 0 END),
        ('has_thermometer - No', CASE WHEN src.g_has_thermometer = 'no' THEN 1 ELSE 0 END),

        -- g_fever_duration (1/2/3/7/14)[1 day/2 days or less/3 - 6 days/7 - 14 days/More than 14 days] - binary
        ('fever_duration - 1 day', CASE WHEN src.g_fever_duration = '1' THEN 1 ELSE 0 END),
        ('fever_duration - 2 days or less', CASE WHEN src.g_fever_duration = '2' THEN 1 ELSE 0 END),
        ('fever_duration - 3 - 6 days', CASE WHEN src.g_fever_duration = '3' THEN 1 ELSE 0 END),
        ('fever_duration - 7 - 14 days', CASE WHEN src.g_fever_duration = '7' THEN 1 ELSE 0 END),
        ('fever_duration - More than 14 days', CASE WHEN src.g_fever_duration = '14' THEN 1 ELSE 0 END),

        -- g_has_mrdt (yes/no) - binary
        ('has_mrdt - Yes', CASE WHEN src.g_has_mrdt = 'yes' THEN 1 ELSE 0 END),
        ('has_mrdt - No', CASE WHEN src.g_has_mrdt = 'no' THEN 1 ELSE 0 END),

        -- g_mrdt_repeat_mrdt_used_repeat (carestat/bioline) - binary
        ('mrdt_repeat_mrdt_used_repeat - Carestat', CASE WHEN src.g_mrdt_repeat_mrdt_used_repeat LIKE '%carestat%' THEN 1 ELSE 0 END),
        ('mrdt_repeat_mrdt_used_repeat - Bioline', CASE WHEN src.g_mrdt_repeat_mrdt_used_repeat LIKE '%bioline%' THEN 1 ELSE 0 END),

        -- g_mrdt_repeat_mrdt_result_repeat (positive/negative/invalid/none/) - binary
        ('mrdt_repeat_mrdt_result_repeat - Positive', CASE WHEN src.g_mrdt_repeat_mrdt_result_repeat LIKE '%positive%' THEN 1 ELSE 0 END),
        ('mrdt_repeat_mrdt_result_repeat - Negative', CASE WHEN src.g_mrdt_repeat_mrdt_result_repeat LIKE '%negative%' THEN 1 ELSE 0 END),
        ('mrdt_repeat_mrdt_result_repeat - Invalid', CASE WHEN src.g_mrdt_repeat_mrdt_result_repeat LIKE '%invalid%' THEN 1 ELSE 0 END),
        ('mrdt_repeat_mrdt_result_repeat - None', CASE WHEN src.g_mrdt_repeat_mrdt_result_repeat LIKE '%none%' THEN 1 ELSE 0 END),

        -- g_want_to_repeat_mrdt (yes/no) - binary
        ('want_to_repeat_mrdt - Yes', CASE WHEN src.g_want_to_repeat_mrdt = 'yes' THEN 1 ELSE 0 END),
        ('want_to_repeat_mrdt - No', CASE WHEN src.g_want_to_repeat_mrdt = 'no' THEN 1 ELSE 0 END),

        -- g_fever_danger_sign (yes/no) - binary
        ('fever_danger_sign - Yes', CASE WHEN src.g_fever_danger_sign = 'yes' THEN 1 ELSE 0 END),
        ('fever_danger_sign - No', CASE WHEN src.g_fever_danger_sign = 'no' THEN 1 ELSE 0 END),

        -- g_has_hiv_exposure (yes/no/unknown) - binary
        ('has_hiv_exposure - Yes', CASE WHEN src.g_has_hiv_exposure = 'yes' THEN 1 ELSE 0 END),
        ('has_hiv_exposure - No', CASE WHEN src.g_has_hiv_exposure = 'no' THEN 1 ELSE 0 END),
        ('has_hiv_exposure - Unknown', CASE WHEN src.g_has_hiv_exposure LIKE '%unknown%' THEN 1 ELSE 0 END),

        -- g_has_tb_exposure (yes/no/unknown) - binary
        ('has_tb_exposure - Yes', CASE WHEN src.g_has_tb_exposure = 'yes' THEN 1 ELSE 0 END),
        ('has_tb_exposure - No', CASE WHEN src.g_has_tb_exposure = 'no' THEN 1 ELSE 0 END),
        ('has_tb_exposure - Unknown', CASE WHEN src.g_has_tb_exposure LIKE '%unknown%' THEN 1 ELSE 0 END),

        -- g_acute_malnutrition_signs (swelling_of_both_feet/hair_color_changes/too_thin/none) - binary
        ('acute_malnutrition_signs - Swelling_of_both_feet', CASE WHEN src.g_acute_malnutrition_signs LIKE '%swelling_of_both_feet%' THEN 1 ELSE 0 END),
        ('acute_malnutrition_signs - Hair_color_changes', CASE WHEN src.g_acute_malnutrition_signs LIKE '%hair_color_changes%' THEN 1 ELSE 0 END),
        ('acute_malnutrition_signs - Too_thin', CASE WHEN src.g_acute_malnutrition_signs LIKE '%too_thin%' THEN 1 ELSE 0 END),
        ('acute_malnutrition_signs - None', CASE WHEN src.g_acute_malnutrition_signs LIKE '%none%' THEN 1 ELSE 0 END),

        -- g_muac_colour (red/yellow/green) - binary
        ('muac_colour - Red', CASE WHEN src.g_muac_colour LIKE '%red%' THEN 1 ELSE 0 END),
        ('muac_colour - Yellow', CASE WHEN src.g_muac_colour LIKE '%yellow%' THEN 1 ELSE 0 END),
        ('muac_colour - Green', CASE WHEN src.g_muac_colour LIKE '%green%' THEN 1 ELSE 0 END),

        -- mal_referred_to_health_facility (yes) - binary
        ('mal_referred_to_health_facility - Yes', CASE WHEN src.mal_referred_to_health_facility = 'yes' THEN 1 ELSE 0 END),

        -- g_appears_too_small (yes/no) - binary
        ('appears_too_small - Yes', CASE WHEN src.g_appears_too_small = 'yes' THEN 1 ELSE 0 END),
        ('appears_too_small - No', CASE WHEN src.g_appears_too_small = 'no' THEN 1 ELSE 0 END),

        -- g_malnutrition_danger_sign (yes/no) - binary
        ('malnutrition_danger_sign - Yes', CASE WHEN src.g_malnutrition_danger_sign = 'yes' THEN 1 ELSE 0 END),
        ('malnutrition_danger_sign - No', CASE WHEN src.g_malnutrition_danger_sign = 'no' THEN 1 ELSE 0 END),

        -- g_has_chc (yes/no) - binary
        ('g_has_chc - Yes', CASE WHEN src.g_has_chc = 'yes' THEN 1 ELSE 0 END),
        ('g_has_chc - No', CASE WHEN src.g_has_chc = 'no' THEN 1 ELSE 0 END),

        -- g_immunization_received (dpt1/dpt3/mr1/mr2/none/dpt1 dpt3/dpt1 mr1 mr2/mr1 mr2/dpt3 mr1 mr2/dpt1 dpt3 mr1/dpt1 dpt3 mr2) - binary
        ('g_immunization_received - Dpt1', CASE WHEN src.g_immunization_received LIKE '%dpt1%' THEN 1 ELSE 0 END),
        ('g_immunization_received - Dpt3', CASE WHEN src.g_immunization_received LIKE '%dpt3%' THEN 1 ELSE 0 END),
        ('g_immunization_received - Mr1', CASE WHEN src.g_immunization_received LIKE '%mr1%' THEN 1 ELSE 0 END),
        ('g_immunization_received - Mr2', CASE WHEN src.g_immunization_received LIKE '%mr2%' THEN 1 ELSE 0 END),
        ('g_immunization_received - None', CASE WHEN src.g_immunization_received LIKE '%none%' THEN 1 ELSE 0 END),

        -- g_immunization_uptodate (yes/no) - binary
        ('g_immunization_uptodate - Yes', CASE WHEN src.g_immunization_uptodate = 'yes' THEN 1 ELSE 0 END),
        ('g_immunization_uptodate - No', CASE WHEN src.g_immunization_uptodate = 'no' THEN 1 ELSE 0 END),

        -- g_afp_vpd (yes/no) - binary
        ('g_afp_vpd - Yes', CASE WHEN src.g_afp_vpd = 'yes' THEN 1 ELSE 0 END),
        ('g_afp_vpd - No', CASE WHEN src.g_afp_vpd = 'no' THEN 1 ELSE 0 END),

        -- g_exclusive_breast_feeding (yes/no) - binary
        ('g_exclusive_breast_feeding - Yes', CASE WHEN src.g_exclusive_breast_feeding = 'yes' THEN 1 ELSE 0 END),
        ('g_exclusive_breast_feeding - No', CASE WHEN src.g_exclusive_breast_feeding = 'no' THEN 1 ELSE 0 END),

        -- g_reason_child_not_breastfeeding (baby_on_mixed_feeding/cultural_beliefs/mother_low_milk_production/mother_occupation/others) - binary
        ('g_reason_child_not_breastfeeding - Baby_on_mixed_feeding', CASE WHEN src.g_reason_child_not_breastfeeding LIKE '%baby_on_mixed_feeding%' THEN 1 ELSE 0 END),
        ('g_reason_child_not_breastfeeding - Cultural_beliefs', CASE WHEN src.g_reason_child_not_breastfeeding LIKE '%cultural_beliefs%' THEN 1 ELSE 0 END),
        ('g_reason_child_not_breastfeeding - Mother_low_milk_production', CASE WHEN src.g_reason_child_not_breastfeeding LIKE '%mother_low_milk_production%' THEN 1 ELSE 0 END),
        ('g_reason_child_not_breastfeeding - Mother_occupation', CASE WHEN src.g_reason_child_not_breastfeeding LIKE '%mother_occupation%' THEN 1 ELSE 0 END),
        ('g_reason_child_not_breastfeeding - Others', CASE WHEN src.g_reason_child_not_breastfeeding LIKE '%others%' THEN 1 ELSE 0 END),

        -- other_referred_to_health_facility (yes) - binary
        ('other_referred_to_health_facility - Yes', CASE WHEN src.other_referred_to_health_facility = 'yes' THEN 1 ELSE 0 END),

        -- g_still_breastfeeding (yes/no) - binary
        ('g_still_breastfeeding - Yes', CASE WHEN src.g_still_breastfeeding = 'yes' THEN 1 ELSE 0 END),
        ('g_still_breastfeeding - No', CASE WHEN src.g_still_breastfeeding = 'no' THEN 1 ELSE 0 END),

        -- g_walking_or_crawling (yes/no) - binary
        ('g_walking_or_crawling - Yes', CASE WHEN src.g_walking_or_crawling = 'yes' THEN 1 ELSE 0 END),
        ('g_walking_or_crawling - No', CASE WHEN src.g_walking_or_crawling = 'no' THEN 1 ELSE 0 END),

        -- g_child_been_dewormed (yes/no) - binary
        ('g_child_been_dewormed - Yes', CASE WHEN src.g_child_been_dewormed = 'yes' THEN 1 ELSE 0 END),
        ('g_child_been_dewormed - No', CASE WHEN src.g_child_been_dewormed = 'no' THEN 1 ELSE 0 END),

        -- g_received_vitamin_a (yes/no) - binary
        ('g_received_vitamin_a - Yes', CASE WHEN src.g_received_vitamin_a = 'yes' THEN 1 ELSE 0 END),
        ('g_received_vitamin_a - No', CASE WHEN src.g_received_vitamin_a = 'no' THEN 1 ELSE 0 END),

        -- g_refer_to_health_facility_no_vitamin_a (yes) - binary
        ('g_refer_to_health_facility_no_vitamin_a - Yes', CASE WHEN src.g_refer_to_health_facility_no_vitamin_a = 'yes' THEN 1 ELSE 0 END),

        -- g_cough_prereferral_treatment_given (yes/no) - binary
        ('g_cough_prereferral_treatment_given - Yes', CASE WHEN src.g_cough_prereferral_treatment_given = 'yes' THEN 1 ELSE 0 END),
        ('g_cough_prereferral_treatment_given - No', CASE WHEN src.g_cough_prereferral_treatment_given = 'no' THEN 1 ELSE 0 END),

        -- g_diarrhoea_prereferral_treatment_given (yes/no) - binary
        ('g_diarrhoea_prereferral_treatment_given - Yes', CASE WHEN src.g_diarrhoea_prereferral_treatment_given = 'yes' THEN 1 ELSE 0 END),
        ('g_diarrhoea_prereferral_treatment_given - No', CASE WHEN src.g_diarrhoea_prereferral_treatment_given = 'no' THEN 1 ELSE 0 END),

        -- g_fever_prereferral_treatment_given (yes/no) - binary
        ('g_fever_prereferral_treatment_given - Yes', CASE WHEN src.g_fever_prereferral_treatment_given = 'yes' THEN 1 ELSE 0 END),
        ('g_fever_prereferral_treatment_given - No', CASE WHEN src.g_fever_prereferral_treatment_given = 'no' THEN 1 ELSE 0 END),

        -- g_danger_sign_prereferral_treatment_given (yes/no) - binary
        ('g_danger_sign_prereferral_treatment_given - Yes', CASE WHEN src.g_danger_sign_prereferral_treatment_given = 'yes' THEN 1 ELSE 0 END),
        ('g_danger_sign_prereferral_treatment_given - No', CASE WHEN src.g_danger_sign_prereferral_treatment_given = 'no' THEN 1 ELSE 0 END),

        -- g_cough_treatment_given (yes/no) - binary
        ('g_cough_treatment_given - Yes', CASE WHEN src.g_cough_treatment_given = 'yes' THEN 1 ELSE 0 END),
        ('g_cough_treatment_given - No', CASE WHEN src.g_cough_treatment_given = 'no' THEN 1 ELSE 0 END),

        -- g_diarrhoea_treatment_given (yes/no) - binary
        ('g_diarrhoea_treatment_given - Yes', CASE WHEN src.g_diarrhoea_treatment_given = 'yes' THEN 1 ELSE 0 END),
        ('g_diarrhoea_treatment_given - No', CASE WHEN src.g_diarrhoea_treatment_given = 'no' THEN 1 ELSE 0 END),

        -- g_fever_treatment_given (yes/no) - binary
        ('g_fever_treatment_given - Yes', CASE WHEN src.g_fever_treatment_given = 'yes' THEN 1 ELSE 0 END),
        ('g_fever_treatment_given - No', CASE WHEN src.g_fever_treatment_given = 'no' THEN 1 ELSE 0 END),

        -- g_have_you_referred (yes) - binary
        ('g_have_you_referred - Yes', CASE WHEN src.g_have_you_referred = 'yes' THEN 1 ELSE 0 END),

        -- g_gloves_used_mrdt (0/1/2/3/4/5) - binary
        ('g_gloves_used_mrdt - 0', CASE WHEN src.g_gloves_used_mrdt = '0' THEN 1 ELSE 0 END),
        ('g_gloves_used_mrdt - 1', CASE WHEN src.g_gloves_used_mrdt = '1' THEN 1 ELSE 0 END),
        ('g_gloves_used_mrdt - 2', CASE WHEN src.g_gloves_used_mrdt = '2' THEN 1 ELSE 0 END),
        ('g_gloves_used_mrdt - 3', CASE WHEN src.g_gloves_used_mrdt = '3' THEN 1 ELSE 0 END),
        ('g_gloves_used_mrdt - 4', CASE WHEN src.g_gloves_used_mrdt = '4' THEN 1 ELSE 0 END),
        ('g_gloves_used_mrdt - 5', CASE WHEN src.g_gloves_used_mrdt = '5' THEN 1 ELSE 0 END),

        -- g_test_kits_used_mrdt (0/1/2/3/4/5) - binary
        ('g_test_kits_used_mrdt - 0', CASE WHEN src.g_test_kits_used_mrdt = '0' THEN 1 ELSE 0 END),
        ('g_test_kits_used_mrdt - 1', CASE WHEN src.g_test_kits_used_mrdt = '1' THEN 1 ELSE 0 END),
        ('g_test_kits_used_mrdt - 2', CASE WHEN src.g_test_kits_used_mrdt = '2' THEN 1 ELSE 0 END),
        ('g_test_kits_used_mrdt - 3', CASE WHEN src.g_test_kits_used_mrdt = '3' THEN 1 ELSE 0 END),
        ('g_test_kits_used_mrdt - 4', CASE WHEN src.g_test_kits_used_mrdt = '4' THEN 1 ELSE 0 END),
        ('g_test_kits_used_mrdt - 5', CASE WHEN src.g_test_kits_used_mrdt = '5' THEN 1 ELSE 0 END),

        -- g_gloves_used_rectal (0/1/2/3/4/5) - binary
        ('g_gloves_used_rectal - 0', CASE WHEN src.g_gloves_used_rectal = '0' THEN 1 ELSE 0 END),
        ('g_gloves_used_rectal - 1', CASE WHEN src.g_gloves_used_rectal = '1' THEN 1 ELSE 0 END),
        ('g_gloves_used_rectal - 2', CASE WHEN src.g_gloves_used_rectal = '2' THEN 1 ELSE 0 END),
        ('g_gloves_used_rectal - 3', CASE WHEN src.g_gloves_used_rectal = '3' THEN 1 ELSE 0 END),
        ('g_gloves_used_rectal - 4', CASE WHEN src.g_gloves_used_rectal = '4' THEN 1 ELSE 0 END),
        ('g_gloves_used_rectal - 5', CASE WHEN src.g_gloves_used_rectal = '5' THEN 1 ELSE 0 END)
) AS unpivot(data_element, value)
WHERE value IS NOT NULL;