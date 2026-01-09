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
    doc_id AS uuid,
    'pregnancy' AS theme,
    'pregnancy' AS dataset,
    unpivot.data_element,
    unpivot.value,
    date,
    chw_id,
    facility_id,
    district AS district_id,
    region,
    patient_age_in_years,
    patient_age_in_months,
    patient_age_in_days,
    patient_gender AS patient_sex,
    contact_date_of_birth AS patient_dob,
    'cht' AS source_system,
    'pregnancy' AS source_form
FROM (
    SELECT
        doc_id,
        date,
        chw_id,
        facility_id,
        district,
        region,
        patient_age_in_years,
        patient_age_in_months,
        patient_age_in_days,
        patient_gender,
        contact_date_of_birth,

        -- indicator columns
        LOWER(TRIM(needs_signoff)) AS needs_signoff,
        LOWER(TRIM(using_llin)) AS using_llin,
        LOWER(TRIM(refer_client_to_health_facility)) AS refer_client_to_health_facility,
        LOWER(TRIM(has_tt_card)) AS has_tt_card,
        LOWER(TRIM(tt_immunizations)) AS tt_immunizations,
        LOWER(TRIM(tt_refer_ack)) AS tt_refer_ack,
        LOWER(TRIM(received_tt_immunizations)) AS received_tt_immunizations,
        LOWER(TRIM(taken_muac)) AS taken_muac,
        LOWER(TRIM(muac_measurement)) AS muac_measurement,
        LOWER(TRIM(referred_to_health_facility_nutrition)) AS referred_to_health_facility_nutrition,
        LOWER(TRIM(micro_nutrient_supplementation_received)) AS micro_nutrient_supplementation_received,
        LOWER(TRIM(refer_to_health_facility_no_micro_nutrients)) AS refer_to_health_facility_no_micro_nutrients,
        LOWER(TRIM(on_nutrition_follow_up)) AS on_nutrition_follow_up,
        LOWER(TRIM(completed_last_nutrition_follow_up)) AS completed_last_nutrition_follow_up,
        LOWER(TRIM(schedule_follow_up_visit)) AS schedule_follow_up_visit,
        LOWER(TRIM(referred_to_health_facility_missed_nutrition_follow_up)) AS referred_to_health_facility_missed_nutrition_follow_up,
        LOWER(TRIM(ds_vaginal_bleeding)) AS ds_vaginal_bleeding,
        LOWER(TRIM(ds_lower_abdomen_pain)) AS ds_lower_abdomen_pain,
        LOWER(TRIM(ds_severe_headache)) AS ds_severe_headache,
        LOWER(TRIM(ds_very_pale)) AS ds_very_pale,
        LOWER(TRIM(ds_fever)) AS ds_fever,
        LOWER(TRIM(ds_reduced_or_no_feotal_movements)) AS ds_reduced_or_no_feotal_movements,
        LOWER(TRIM(ds_blurred_vision)) AS ds_blurred_vision,
        LOWER(TRIM(ds_swelling)) AS ds_swelling,
        LOWER(TRIM(ds_breathlessness)) AS ds_breathlessness,
        LOWER(TRIM(ds_has_danger_signs)) AS ds_has_danger_signs,
        LOWER(TRIM(ds_has_no_danger_signs)) AS ds_has_no_danger_signs,
        LOWER(TRIM(ds_referred_to_health_facility_danger_signs)) AS ds_referred_to_health_facility_danger_signs,
        LOWER(TRIM(has_upcoming_anc_visits)) AS has_upcoming_anc_visits,
        LOWER(TRIM(number_of_anc_visits)) AS number_of_anc_visits,
        LOWER(TRIM(anc_visits)) AS anc_visits,
        LOWER(TRIM(hiv_test_done)) AS hiv_test_done,
        LOWER(TRIM(hiv_test_result)) AS hiv_test_result,
        LOWER(TRIM(on_art_treatment)) AS on_art_treatment,
        LOWER(TRIM(taking_medication)) AS taking_medication,
        LOWER(TRIM(pregnancy_report_method)) AS pregnancy_report_method
    FROM cht.mv_pregnancy_new
) src
CROSS JOIN LATERAL (
    VALUES
        -- needs_signoff (true)
        ('needs_signoff - True', CASE WHEN src.needs_signoff = 'true' THEN 1 ELSE 0 END),

        -- using_llin (yes/no)
        ('using_llin - Yes', CASE WHEN src.using_llin = 'yes' THEN 1 ELSE 0 END),
        ('using_llin - No', CASE WHEN src.using_llin = 'no' THEN 1 ELSE 0 END),

        -- refer_client_to_health_facility (yes)
        ('refer_client_to_health_facility - Yes', CASE WHEN src.refer_client_to_health_facility = 'yes' THEN 1 ELSE 0 END),

        -- has_tt_card (yes/no)
        ('has_tt_card - Yes', CASE WHEN src.has_tt_card = 'yes' THEN 1 ELSE 0 END),
        ('has_tt_card - No', CASE WHEN src.has_tt_card = 'no' THEN 1 ELSE 0 END),

        -- tt_immunizations (1 / 1 2 /1 2 3 /1 2 3 4 /1 2 3 4 5 / 1 2 3 4 5 6 / 1 2 3 4 5 6 7 / 1 2 3 4 5 6 7 8)
        ('tt_immunizations - 1 dose', CASE WHEN src.tt_immunizations = '1' THEN 1 ELSE 0 END),
        ('tt_immunizations - 2 doses', CASE WHEN src.tt_immunizations = '1 2' THEN 1 ELSE 0 END),
        ('tt_immunizations - 3 doses', CASE WHEN src.tt_immunizations = '1 2 3' THEN 1 ELSE 0 END),
        ('tt_immunizations - 4 doses', CASE WHEN src.tt_immunizations = '1 2 3 4' THEN 1 ELSE 0 END),
        ('tt_immunizations - 5 doses', CASE WHEN src.tt_immunizations = '1 2 3 4 5' THEN 1 ELSE 0 END),
        ('tt_immunizations - 6 doses', CASE WHEN src.tt_immunizations = '1 2 3 4 5 6' THEN 1 ELSE 0 END),
        ('tt_immunizations - 7 doses', CASE WHEN src.tt_immunizations = '1 2 3 4 5 6 7' THEN 1 ELSE 0 END),
        ('tt_immunizations - 8 doses', CASE WHEN src.tt_immunizations = '1 2 3 4 5 6 7 8' THEN 1 ELSE 0 END),

        -- tt_refer_ack (yes)
        ('tt_refer_ack - Yes', CASE WHEN src.tt_refer_ack = 'yes' THEN 1 ELSE 0 END),

        -- received_tt_immunizations (yes/no)
        ('received_tt_immunizations - Yes', CASE WHEN src.received_tt_immunizations = 'yes' THEN 1 ELSE 0 END),
        ('received_tt_immunizations - No', CASE WHEN src.received_tt_immunizations = 'no' THEN 1 ELSE 0 END),

        -- taken_muac (yes/no)
        ('taken_muac - Yes', CASE WHEN src.taken_muac = 'yes' THEN 1 ELSE 0 END),
        ('taken_muac - No', CASE WHEN src.taken_muac = 'no' THEN 1 ELSE 0 END),

        -- muac_measurement (red/yellow/green)
        ('muac_measurement - Red', CASE WHEN src.muac_measurement LIKE '%red%' THEN 1 ELSE 0 END),
        ('muac_measurement - Yellow', CASE WHEN src.muac_measurement LIKE '%yellow%' THEN 1 ELSE 0 END),
        ('muac_measurement - Green', CASE WHEN src.muac_measurement LIKE '%green%' THEN 1 ELSE 0 END),

        -- referred_to_health_facility_nutrition (yes)
        ('referred_to_health_facility_nutrition - Yes', CASE WHEN src.referred_to_health_facility_nutrition = 'yes' THEN 1 ELSE 0 END),

        -- micro_nutrient_supplementation_received (yes/no)
        ('micro_nutrient_supplementation_received - Yes', CASE WHEN src.micro_nutrient_supplementation_received = 'yes' THEN 1 ELSE 0 END),
        ('micro_nutrient_supplementation_received - No', CASE WHEN src.micro_nutrient_supplementation_received = 'no' THEN 1 ELSE 0 END),

        -- refer_to_health_facility_no_micro_nutrients (yes)
        ('refer_to_health_facility_no_micro_nutrients - Yes', CASE WHEN src.refer_to_health_facility_no_micro_nutrients = 'yes' THEN 1 ELSE 0 END),

        -- on_nutrition_follow_up (yes/no)
        ('on_nutrition_follow_up - Yes', CASE WHEN src.on_nutrition_follow_up = 'yes' THEN 1 ELSE 0 END),
        ('on_nutrition_follow_up - No', CASE WHEN src.on_nutrition_follow_up = 'no' THEN 1 ELSE 0 END),

        -- completed_last_nutrition_follow_up (yes/no)
        ('completed_last_nutrition_follow_up - Yes', CASE WHEN src.completed_last_nutrition_follow_up = 'yes' THEN 1 ELSE 0 END),
        ('completed_last_nutrition_follow_up - No', CASE WHEN src.completed_last_nutrition_follow_up = 'no' THEN 1 ELSE 0 END),

        -- schedule_follow_up_visit (yes/no)
        ('schedule_follow_up_visit - Yes', CASE WHEN src.schedule_follow_up_visit = 'yes' THEN 1 ELSE 0 END),
        ('schedule_follow_up_visit - No', CASE WHEN src.schedule_follow_up_visit = 'no' THEN 1 ELSE 0 END),

        -- referred_to_health_facility_missed_nutrition_follow_up (yes)
        ('referred_to_health_facility_missed_nutrition_follow_up - Yes', CASE WHEN src.referred_to_health_facility_missed_nutrition_follow_up = 'yes' THEN 1 ELSE 0 END),

        -- ds_vaginal_bleeding (yes/no)
        ('ds_vaginal_bleeding - Yes', CASE WHEN src.ds_vaginal_bleeding = 'yes' THEN 1 ELSE 0 END),
        ('ds_vaginal_bleeding - No', CASE WHEN src.ds_vaginal_bleeding = 'no' THEN 1 ELSE 0 END),

        -- ds_lower_abdomen_pain (yes/no)
        ('ds_lower_abdomen_pain - Yes', CASE WHEN src.ds_lower_abdomen_pain = 'yes' THEN 1 ELSE 0 END),
        ('ds_lower_abdomen_pain - No', CASE WHEN src.ds_lower_abdomen_pain = 'no' THEN 1 ELSE 0 END),

        -- ds_severe_headache (yes/no)
        ('ds_severe_headache - Yes', CASE WHEN src.ds_severe_headache = 'yes' THEN 1 ELSE 0 END),
        ('ds_severe_headache - No', CASE WHEN src.ds_severe_headache = 'no' THEN 1 ELSE 0 END),

        -- ds_very_pale (yes/no)
        ('ds_very_pale - Yes', CASE WHEN src.ds_very_pale = 'yes' THEN 1 ELSE 0 END),
        ('ds_very_pale - No', CASE WHEN src.ds_very_pale = 'no' THEN 1 ELSE 0 END),

        -- ds_fever (yes/no)
        ('ds_fever - Yes', CASE WHEN src.ds_fever = 'yes' THEN 1 ELSE 0 END),
        ('ds_fever - No', CASE WHEN src.ds_fever = 'no' THEN 1 ELSE 0 END),

        -- ds_reduced_or_no_feotal_movements (yes/no)
        ('ds_reduced_or_no_feotal_movements - Yes', CASE WHEN src.ds_reduced_or_no_feotal_movements = 'yes' THEN 1 ELSE 0 END),
        ('ds_reduced_or_no_feotal_movements - No', CASE WHEN src.ds_reduced_or_no_feotal_movements = 'no' THEN 1 ELSE 0 END),

        -- ds_blurred_vision (yes/no)
        ('ds_blurred_vision - Yes', CASE WHEN src.ds_blurred_vision = 'yes' THEN 1 ELSE 0 END),
        ('ds_blurred_vision - No', CASE WHEN src.ds_blurred_vision = 'no' THEN 1 ELSE 0 END),

        -- ds_swelling (yes/no)
        ('ds_swelling - Yes', CASE WHEN src.ds_swelling = 'yes' THEN 1 ELSE 0 END),
        ('ds_swelling - No', CASE WHEN src.ds_swelling = 'no' THEN 1 ELSE 0 END),

        -- ds_breathlessness (yes/no)
        ('ds_breathlessness - Yes', CASE WHEN src.ds_breathlessness = 'yes' THEN 1 ELSE 0 END),
        ('ds_breathlessness - No', CASE WHEN src.ds_breathlessness = 'no' THEN 1 ELSE 0 END),

        -- ds_has_danger_signs (yes/' ')
        ('ds_has_danger_signs - Yes', CASE WHEN src.ds_has_danger_signs = 'yes' THEN 1 ELSE 0 END),

        -- ds_has_no_danger_signs (yes/' ')
        ('ds_has_no_danger_signs - Yes', CASE WHEN src.ds_has_no_danger_signs = 'yes' THEN 1 ELSE 0 END),

        -- ds_referred_to_health_facility_danger_signs (yes)
        ('ds_referred_to_health_facility_danger_signs - Yes', CASE WHEN src.ds_referred_to_health_facility_danger_signs = 'yes' THEN 1 ELSE 0 END),

        -- has_upcoming_anc_visits (yes/no)
        ('has_upcoming_anc_visits - Yes', CASE WHEN src.has_upcoming_anc_visits = 'yes' THEN 1 ELSE 0 END),
        ('has_upcoming_anc_visits - No', CASE WHEN src.has_upcoming_anc_visits = 'no' THEN 1 ELSE 0 END),

        -- number_of_anc_visits (1/2/3/4/5/6/7/8)
        ('number_of_anc_visits - 1', CASE WHEN src.number_of_anc_visits = '1' THEN 1 ELSE 0 END),
        ('number_of_anc_visits - 2', CASE WHEN src.number_of_anc_visits = '2' THEN 1 ELSE 0 END),
        ('number_of_anc_visits - 3', CASE WHEN src.number_of_anc_visits = '3' THEN 1 ELSE 0 END),
        ('number_of_anc_visits - 4', CASE WHEN src.number_of_anc_visits = '4' THEN 1 ELSE 0 END),
        ('number_of_anc_visits - 5', CASE WHEN src.number_of_anc_visits = '5' THEN 1 ELSE 0 END),
        ('number_of_anc_visits - 6', CASE WHEN src.number_of_anc_visits = '6' THEN 1 ELSE 0 END),
        ('number_of_anc_visits - 7', CASE WHEN src.number_of_anc_visits = '7' THEN 1 ELSE 0 END),
        ('number_of_anc_visits - 8', CASE WHEN src.number_of_anc_visits = '8' THEN 1 ELSE 0 END),

        -- anc_visits (anc_1/anc_2/anc_3/anc_4/anc_5/anc_6/anc_7/anc_8)
        ('anc_visits - Anc_1', CASE WHEN src.anc_visits LIKE '%anc_1%' THEN 1 ELSE 0 END),
        ('anc_visits - Anc_2', CASE WHEN src.anc_visits LIKE '%anc_2%' THEN 1 ELSE 0 END),
        ('anc_visits - Anc_3', CASE WHEN src.anc_visits LIKE '%anc_3%' THEN 1 ELSE 0 END),
        ('anc_visits - Anc_4', CASE WHEN src.anc_visits LIKE '%anc_4%' THEN 1 ELSE 0 END),
        ('anc_visits - Anc_5', CASE WHEN src.anc_visits LIKE '%anc_5%' THEN 1 ELSE 0 END),
        ('anc_visits - Anc_6', CASE WHEN src.anc_visits LIKE '%anc_6%' THEN 1 ELSE 0 END),
        ('anc_visits - Anc_7', CASE WHEN src.anc_visits LIKE '%anc_7%' THEN 1 ELSE 0 END),
        ('anc_visits - Anc_8', CASE WHEN src.anc_visits LIKE '%anc_8%' THEN 1 ELSE 0 END),

        -- hiv_test_done (yes/no)
        ('hiv_test_done - Yes', CASE WHEN src.hiv_test_done = 'yes' THEN 1 ELSE 0 END),
        ('hiv_test_done - No', CASE WHEN src.hiv_test_done = 'no' THEN 1 ELSE 0 END),

        -- hiv_test_result (positive/negative/unknown)
        ('hiv_test_result - Positive', CASE WHEN src.hiv_test_result LIKE '%positive%' THEN 1 ELSE 0 END),
        ('hiv_test_result - Negative', CASE WHEN src.hiv_test_result LIKE '%negative%' THEN 1 ELSE 0 END),
        ('hiv_test_result - Unknown', CASE WHEN src.hiv_test_result LIKE '%unknown%' THEN 1 ELSE 0 END),

        -- on_art_treatment (yes/no)
        ('on_art_treatment - Yes', CASE WHEN src.on_art_treatment = 'yes' THEN 1 ELSE 0 END),
        ('on_art_treatment - No', CASE WHEN src.on_art_treatment = 'no' THEN 1 ELSE 0 END),

        -- taking_medication (yes/no)
        ('taking_medication - Yes', CASE WHEN src.taking_medication = 'yes' THEN 1 ELSE 0 END),
        ('taking_medication - No', CASE WHEN src.taking_medication = 'no' THEN 1 ELSE 0 END),

        -- pregnancy_report_method (lmp/edd/no_information)
        ('pregnancy_report_method - Lmp', CASE WHEN src.pregnancy_report_method LIKE '%lmp%' THEN 1 ELSE 0 END),
        ('pregnancy_report_method - Edd', CASE WHEN src.pregnancy_report_method LIKE '%edd%' THEN 1 ELSE 0 END),
        ('pregnancy_report_method - No_information', CASE WHEN src.pregnancy_report_method LIKE '%no_information%' THEN 1 ELSE 0 END)
) AS unpivot(data_element, value)
WHERE value = 1;