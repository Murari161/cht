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
    'ANC' AS theme,
    'anc_visit_follow_up' AS dataset,
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
    'anc_visit_follow_up' AS source_form
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
        LOWER(TRIM(pregnancy_ended)) AS pregnancy_ended,
        LOWER(TRIM(referred_for_nutrition_follow_up)) AS referred_for_nutrition_follow_up,
        LOWER(TRIM(assess_this_pregnancy)) AS assess_this_pregnancy,
        LOWER(TRIM(start_this_pregnancy)) AS start_this_pregnancy,
        LOWER(TRIM(is_available)) AS is_available,
        LOWER(TRIM(edd_upto_date)) AS edd_upto_date,
        LOWER(TRIM(refused_care_action)) AS refused_care_action,
        LOWER(TRIM(migrated_action)) AS migrated_action,
        LOWER(TRIM(completed_scheduled_anc_visit)) AS completed_scheduled_anc_visit,
        LOWER(TRIM(anc_visits)) AS anc_visits,
        LOWER(TRIM(person_who_accompanied_expectant_mother)) AS person_who_accompanied_expectant_mother,
        LOWER(TRIM(why_missed_anc_visit)) AS why_missed_anc_visit,
        LOWER(TRIM(missed_anc_actions_taken)) AS missed_anc_actions_taken,
        LOWER(TRIM(refer_to_health_facility)) AS refer_to_health_facility,
        LOWER(TRIM(client_on_art_treatment)) AS client_on_art_treatment,
        LOWER(TRIM(client_taking_medication)) AS client_taking_medication,
        LOWER(TRIM(current_hiv_test_result)) AS current_hiv_test_result,
        LOWER(TRIM(hiv_test_result)) AS hiv_test_result,
        LOWER(TRIM(is_client_taking_medication)) AS is_client_taking_medication,
        LOWER(TRIM(on_art_treatment)) AS on_art_treatment,
        LOWER(TRIM(referred_to_health_facility_llin)) AS referred_to_health_facility_llin,
        LOWER(TRIM(using_llin)) AS using_llin,
        LOWER(TRIM(tested_for_hiv_past3months)) AS tested_for_hiv_past3months,
        LOWER(TRIM(received_tt_immunization)) AS received_tt_immunization,
        LOWER(TRIM(completed_last_nutrition_follow_up)) AS completed_last_nutrition_follow_up,
        LOWER(TRIM(micro_nutrient_supplementation_received)) AS micro_nutrient_supplementation_received,
        LOWER(TRIM(refer_to_health_facility_no_micro_nutrients)) AS refer_to_health_facility_no_micro_nutrients,
        LOWER(TRIM(referred_to_health_facility_missed_nutrition_follow_up)) AS referred_to_health_facility_missed_nutrition_follow_up,
        LOWER(TRIM(taken_muac)) AS taken_muac,
        LOWER(TRIM(muac_measurement)) AS muac_measurement,
        LOWER(TRIM(referred_to_health_facility_nutrition)) AS referred_to_health_facility_nutrition,
        LOWER(TRIM(on_nutrition_follow_up)) AS on_nutrition_follow_up
    FROM cht.mv_anc_visit_follow_up
) src
CROSS JOIN LATERAL (
    VALUES
        -- pregnancy_ended (yes/no)
        ('pregnancy_ended - Yes', CASE WHEN src.pregnancy_ended = 'yes' THEN 1 ELSE 0 END),
        ('pregnancy_ended - No', CASE WHEN src.pregnancy_ended = 'no' THEN 1 ELSE 0 END),

        -- referred_for_nutrition_follow_up (yes/no)
        ('referred_for_nutrition_follow_up - Yes', CASE WHEN src.referred_for_nutrition_follow_up = 'yes' THEN 1 ELSE 0 END),
        ('referred_for_nutrition_follow_up - No', CASE WHEN src.referred_for_nutrition_follow_up = 'no' THEN 1 ELSE 0 END),

        -- assess_this_pregnancy (yes/no)
        ('assess_this_pregnancy - Yes', CASE WHEN src.assess_this_pregnancy = 'yes' THEN 1 ELSE 0 END),
        ('assess_this_pregnancy - No', CASE WHEN src.assess_this_pregnancy = 'no' THEN 1 ELSE 0 END),

        -- start_this_pregnancy (delivered/miscarriage/abortion/refusing_care/migrated/died/follow_up_later)
        ('start_this_pregnancy - Delivered', CASE WHEN src.start_this_pregnancy LIKE '%delivered%' THEN 1 ELSE 0 END),
        ('start_this_pregnancy - Miscarriage', CASE WHEN src.start_this_pregnancy LIKE '%miscarriage%' THEN 1 ELSE 0 END),
        ('start_this_pregnancy - Abortion', CASE WHEN src.start_this_pregnancy LIKE '%abortion%' THEN 1 ELSE 0 END),
        ('start_this_pregnancy - Refusing_care', CASE WHEN src.start_this_pregnancy LIKE '%refusing_care%' THEN 1 ELSE 0 END),
        ('start_this_pregnancy - Migrated', CASE WHEN src.start_this_pregnancy LIKE '%migrated%' THEN 1 ELSE 0 END),
        ('start_this_pregnancy - Died', CASE WHEN src.start_this_pregnancy LIKE '%died%' THEN 1 ELSE 0 END),
        ('start_this_pregnancy - Follow_up_later', CASE WHEN src.start_this_pregnancy LIKE '%follow_up_later%' THEN 1 ELSE 0 END),

        -- is_available (yes/no)
        ('is_available - Yes', CASE WHEN src.is_available = 'yes' THEN 1 ELSE 0 END),
        ('is_available - No', CASE WHEN src.is_available = 'no' THEN 1 ELSE 0 END),

        -- edd_upto_date (yes/no)
        ('edd_upto_date - Yes', CASE WHEN src.edd_upto_date = 'yes' THEN 1 ELSE 0 END),
        ('edd_upto_date - No', CASE WHEN src.edd_upto_date = 'no' THEN 1 ELSE 0 END),

        -- refused_care_action (clear_this_task/no_more_tasks)
        ('refused_care_action - Clear_this_task', CASE WHEN src.refused_care_action LIKE '%clear_this_task%' THEN 1 ELSE 0 END),
        ('refused_care_action - No_more_tasks', CASE WHEN src.refused_care_action LIKE '%no_more_tasks%' THEN 1 ELSE 0 END),

        -- migrated_action (clear_this_task/no_more_tasks)
        ('migrated_action - Clear_this_task', CASE WHEN src.migrated_action LIKE '%clear_this_task%' THEN 1 ELSE 0 END),
        ('migrated_action - No_more_tasks', CASE WHEN src.migrated_action LIKE '%no_more_tasks%' THEN 1 ELSE 0 END),

        -- completed_scheduled_anc_visit (yes/no)
        ('completed_scheduled_anc_visit - Yes', CASE WHEN src.completed_scheduled_anc_visit = 'yes' THEN 1 ELSE 0 END),
        ('completed_scheduled_anc_visit - No', CASE WHEN src.completed_scheduled_anc_visit = 'no' THEN 1 ELSE 0 END),

        -- anc_visits (anc_1/anc_1 anc_2/anc_1 anc_2 anc_3/anc_1 anc_2 anc_3 anc_4/anc_1 anc_2 anc_3 anc_4 anc_gt_4)
        ('anc_visits - Anc_1', CASE WHEN src.anc_visits LIKE '%anc_1%' THEN 1 ELSE 0 END),
        ('anc_visits - Anc_1 anc_2', CASE WHEN src.anc_visits = 'anc_1 anc_2' THEN 1 ELSE 0 END),
        ('anc_visits - Anc_1 anc_2 anc_3', CASE WHEN src.anc_visits = 'anc_1 anc_2 anc_3' THEN 1 ELSE 0 END),
        ('anc_visits - Anc_1 anc_2 anc_3 anc_4', CASE WHEN src.anc_visits = 'anc_1 anc_2 anc_3 anc_4' THEN 1 ELSE 0 END),
        ('anc_visits - Anc_1 anc_2 anc_3 anc_4 anc_gt_4', CASE WHEN src.anc_visits = 'anc_1 anc_2 anc_3 anc_4 anc_gt_4' THEN 1 ELSE 0 END),

        -- person_who_accompanied_expectant_mother (parent/chw/husband/other_relative/non_family_member)
        ('person_who_accompanied_expectant_mother - Parent', CASE WHEN src.person_who_accompanied_expectant_mother LIKE '%parent%' THEN 1 ELSE 0 END),
        ('person_who_accompanied_expectant_mother - Chw', CASE WHEN src.person_who_accompanied_expectant_mother LIKE '%chw%' THEN 1 ELSE 0 END),
        ('person_who_accompanied_expectant_mother - Husband', CASE WHEN src.person_who_accompanied_expectant_mother LIKE '%husband%' THEN 1 ELSE 0 END),
        ('person_who_accompanied_expectant_mother - Other_relative', CASE WHEN src.person_who_accompanied_expectant_mother LIKE '%other_relative%' THEN 1 ELSE 0 END),
        ('person_who_accompanied_expectant_mother - Non_family_member', CASE WHEN src.person_who_accompanied_expectant_mother LIKE '%non_family_member%' THEN 1 ELSE 0 END),

        -- why_missed_anc_visit (was_not_reminded/had_traveled/too_early_start_clinic)
        ('why_missed_anc_visit - Was_not_reminded', CASE WHEN src.why_missed_anc_visit LIKE '%was_not_reminded%' THEN 1 ELSE 0 END),
        ('why_missed_anc_visit - Had_traveled', CASE WHEN src.why_missed_anc_visit LIKE '%had_traveled%' THEN 1 ELSE 0 END),
        ('why_missed_anc_visit - Too_early_start_clinic', CASE WHEN src.why_missed_anc_visit LIKE '%too_early_start_clinic%' THEN 1 ELSE 0 END),

        -- missed_anc_actions_taken (referred/provided_key_health_message/accompanied_to_facility)
        ('missed_anc_actions_taken - Referred', CASE WHEN src.missed_anc_actions_taken LIKE '%referred%' THEN 1 ELSE 0 END),
        ('missed_anc_actions_taken - Provided_key_health_message', CASE WHEN src.missed_anc_actions_taken LIKE '%provided_key_health_message%' THEN 1 ELSE 0 END),
        ('missed_anc_actions_taken - Accompanied_to_facility', CASE WHEN src.missed_anc_actions_taken LIKE '%accompanied_to_facility%' THEN 1 ELSE 0 END),

        -- refer_to_health_facility (yes)
        ('refer_to_health_facility - Yes', CASE WHEN src.refer_to_health_facility = 'yes' THEN 1 ELSE 0 END),

        -- client_on_art_treatment (yes/no)
        ('client_on_art_treatment - Yes', CASE WHEN src.client_on_art_treatment = 'yes' THEN 1 ELSE 0 END),
        ('client_on_art_treatment - No', CASE WHEN src.client_on_art_treatment = 'no' THEN 1 ELSE 0 END),

        -- client_taking_medication (yes/no)
        ('client_taking_medication - Yes', CASE WHEN src.client_taking_medication = 'yes' THEN 1 ELSE 0 END),
        ('client_taking_medication - No', CASE WHEN src.client_taking_medication = 'no' THEN 1 ELSE 0 END),

        -- current_hiv_test_result (positive/negative/unknown)
        ('current_hiv_test_result - Positive', CASE WHEN src.current_hiv_test_result LIKE '%positive%' THEN 1 ELSE 0 END),
        ('current_hiv_test_result - Negative', CASE WHEN src.current_hiv_test_result LIKE '%negative%' THEN 1 ELSE 0 END),
        ('current_hiv_test_result - Unknown', CASE WHEN src.current_hiv_test_result LIKE '%unknown%' THEN 1 ELSE 0 END),

        -- hiv_test_result (positive/negative/unknown)
        ('hiv_test_result - Positive', CASE WHEN src.hiv_test_result LIKE '%positive%' THEN 1 ELSE 0 END),
        ('hiv_test_result - Negative', CASE WHEN src.hiv_test_result LIKE '%negative%' THEN 1 ELSE 0 END),
        ('hiv_test_result - Unknown', CASE WHEN src.hiv_test_result LIKE '%unknown%' THEN 1 ELSE 0 END),

        -- is_client_taking_medication (yes/no)
        ('is_client_taking_medication - Yes', CASE WHEN src.is_client_taking_medication = 'yes' THEN 1 ELSE 0 END),
        ('is_client_taking_medication - No', CASE WHEN src.is_client_taking_medication = 'no' THEN 1 ELSE 0 END),

        -- on_art_treatment (yes/no)
        ('on_art_treatment - Yes', CASE WHEN src.on_art_treatment = 'yes' THEN 1 ELSE 0 END),
        ('on_art_treatment - No', CASE WHEN src.on_art_treatment = 'no' THEN 1 ELSE 0 END),

        -- referred_to_health_facility_llin (yes)
        ('referred_to_health_facility_llin - Yes', CASE WHEN src.referred_to_health_facility_llin = 'yes' THEN 1 ELSE 0 END),

        -- using_llin (yes/no)
        ('using_llin - Yes', CASE WHEN src.using_llin = 'yes' THEN 1 ELSE 0 END),
        ('using_llin - No', CASE WHEN src.using_llin = 'no' THEN 1 ELSE 0 END),

        -- tested_for_hiv_past3months (yes/no)
        ('tested_for_hiv_past3months - Yes', CASE WHEN src.tested_for_hiv_past3months = 'yes' THEN 1 ELSE 0 END),
        ('tested_for_hiv_past3months - No', CASE WHEN src.tested_for_hiv_past3months = 'no' THEN 1 ELSE 0 END),

        -- received_tt_immunization (yes/no)
        ('received_tt_immunization - Yes', CASE WHEN src.received_tt_immunization = 'yes' THEN 1 ELSE 0 END),
        ('received_tt_immunization - No', CASE WHEN src.received_tt_immunization = 'no' THEN 1 ELSE 0 END),

        -- completed_last_nutrition_follow_up (yes/no)
        ('completed_last_nutrition_follow_up - Yes', CASE WHEN src.completed_last_nutrition_follow_up = 'yes' THEN 1 ELSE 0 END),
        ('completed_last_nutrition_follow_up - No', CASE WHEN src.completed_last_nutrition_follow_up = 'no' THEN 1 ELSE 0 END),

        -- micro_nutrient_supplementation_received (yes/no)
        ('micro_nutrient_supplementation_received - Yes', CASE WHEN src.micro_nutrient_supplementation_received = 'yes' THEN 1 ELSE 0 END),
        ('micro_nutrient_supplementation_received - No', CASE WHEN src.micro_nutrient_supplementation_received = 'no' THEN 1 ELSE 0 END),

        -- refer_to_health_facility_no_micro_nutrients (yes)
        ('refer_to_health_facility_no_micro_nutrients - Yes', CASE WHEN src.refer_to_health_facility_no_micro_nutrients = 'yes' THEN 1 ELSE 0 END),

        -- referred_to_health_facility_missed_nutrition_follow_up (yes)
        ('referred_to_health_facility_missed_nutrition_follow_up - Yes', CASE WHEN src.referred_to_health_facility_missed_nutrition_follow_up = 'yes' THEN 1 ELSE 0 END),

        -- taken_muac (yes/no)
        ('taken_muac - Yes', CASE WHEN src.taken_muac = 'yes' THEN 1 ELSE 0 END),
        ('taken_muac - No', CASE WHEN src.taken_muac = 'no' THEN 1 ELSE 0 END),

        -- muac_measurement (red/yellow/green)
        ('muac_measurement - Red', CASE WHEN src.muac_measurement LIKE '%red%' THEN 1 ELSE 0 END),
        ('muac_measurement - Yellow', CASE WHEN src.muac_measurement LIKE '%yellow%' THEN 1 ELSE 0 END),
        ('muac_measurement - Green', CASE WHEN src.muac_measurement LIKE '%green%' THEN 1 ELSE 0 END),

        -- referred_to_health_facility_nutrition (yes)
        ('referred_to_health_facility_nutrition - Yes', CASE WHEN src.referred_to_health_facility_nutrition = 'yes' THEN 1 ELSE 0 END),

        -- on_nutrition_follow_up (yes/no)
        ('on_nutrition_follow_up - Yes', CASE WHEN src.on_nutrition_follow_up = 'yes' THEN 1 ELSE 0 END),
        ('on_nutrition_follow_up - No', CASE WHEN src.on_nutrition_follow_up = 'no' THEN 1 ELSE 0 END)
) AS unpivot(data_element, value)
WHERE value = 1;