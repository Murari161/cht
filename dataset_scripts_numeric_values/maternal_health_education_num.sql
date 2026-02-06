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
    'maternal' AS theme,
    'maternal_health_education' AS dataset,
    unpivot.data_element,
    unpivot.value,
    reported AS date,
    chw_area_id AS chw_id,
    facility_id,
    parish__id AS district_id,
    region__id AS region,
    patient_age_in_years,
    patient_age_in_months,
    patient_age_in_days,
    patient_gender AS patient_sex,
    patient_date_of_birth AS patient_dob,
    'cht' AS source_system,
    'maternal_health_education' AS source_form
FROM (
    SELECT
        uuid,
        reported,
        chw_area_id,
        facility_id,
        parish__id,
        region__id,
        patient_age_in_years,
        patient_age_in_months,
        patient_age_in_days,
        patient_gender,
        patient_date_of_birth,

        -- indicator columns
        LOWER(TRIM(needs_signoff)) AS needs_signoff,
        LOWER(TRIM(no_pregnancy_danger_sign)) AS no_pregnancy_danger_sign,
        LOWER(TRIM(no_pregnancy_risk_factor)) AS no_pregnancy_risk_factor,
        LOWER(TRIM(is_pregnant)) AS is_pregnant,
        LOWER(TRIM(pregnancy_outcome)) AS pregnancy_outcome,
        LOWER(TRIM(topic)) AS topic
    FROM report.useview_maternal_health_education
) src
CROSS JOIN LATERAL (
    VALUES
        -- needs_signoff (true) - binary
        ('needs_signoff - True', CASE WHEN src.needs_signoff = 'true' THEN 1 ELSE 0 END),

        -- no_pregnancy_danger_sign (yes/no) - binary
        ('no_pregnancy_danger_sign - Yes', CASE WHEN src.no_pregnancy_danger_sign = 'yes' THEN 1 ELSE 0 END),
        ('no_pregnancy_danger_sign - No', CASE WHEN src.no_pregnancy_danger_sign = 'no' THEN 1 ELSE 0 END),

        -- no_pregnancy_risk_factor (true/false) - binary
        ('no_pregnancy_risk_factor - True', CASE WHEN src.no_pregnancy_risk_factor = 'true' THEN 1 ELSE 0 END),
        ('no_pregnancy_risk_factor - False', CASE WHEN src.no_pregnancy_risk_factor = 'false' THEN 1 ELSE 0 END),

        -- is_pregnant (yes/no) - binary
        ('is_pregnant - Yes', CASE WHEN src.is_pregnant = 'yes' THEN 1 ELSE 0 END),
        ('is_pregnant - No', CASE WHEN src.is_pregnant = 'no' THEN 1 ELSE 0 END),

        -- pregnancy_outcome (woman_delivered/woman_had_miscarriage) - binary
        ('pregnancy_outcome - Woman_delivered', CASE WHEN src.pregnancy_outcome LIKE '%woman_delivered%' THEN 1 ELSE 0 END),
        ('pregnancy_outcome - Woman_had_miscarriage', CASE WHEN src.pregnancy_outcome LIKE '%woman_had_miscarriage%' THEN 1 ELSE 0 END),

        -- topic (signs_of_pregnancy/care_during_pregnancy/anc_attendance/nutrition_in_pregnancy/risk_factor_to_high_risk_pregnancy/common_problems_in_pregnancy/danger_signs_in_pregnancy/protecting_babies_from_hiv/myths_and_misconceptions_pregnancy/birth_plan/what_to_do_labour/care_after_child_birth/nutrition_after_birth/when_to_start_breastfeeding/danger_signs_child_birth/family_planning) - binary
        ('topic - Signs_of_pregnancy', CASE WHEN src.topic LIKE '%signs_of_pregnancy%' THEN 1 ELSE 0 END),
        ('topic - Care_during_pregnancy', CASE WHEN src.topic LIKE '%care_during_pregnancy%' THEN 1 ELSE 0 END),
        ('topic - Anc_attendance', CASE WHEN src.topic LIKE '%anc_attendance%' THEN 1 ELSE 0 END),
        ('topic - Nutrition_in_pregnancy', CASE WHEN src.topic LIKE '%nutrition_in_pregnancy%' THEN 1 ELSE 0 END),
        ('topic - Risk_factor_to_high_risk_pregnancy', CASE WHEN src.topic LIKE '%risk_factor_to_high_risk_pregnancy%' THEN 1 ELSE 0 END),
        ('topic - Common_problems_in_pregnancy', CASE WHEN src.topic LIKE '%common_problems_in_pregnancy%' THEN 1 ELSE 0 END),
        ('topic - Danger_signs_in_pregnancy', CASE WHEN src.topic LIKE '%danger_signs_in_pregnancy%' THEN 1 ELSE 0 END),
        ('topic - Protecting_babies_from_hiv', CASE WHEN src.topic LIKE '%protecting_babies_from_hiv%' THEN 1 ELSE 0 END),
        ('topic - Myths_and_misconceptions_pregnancy', CASE WHEN src.topic LIKE '%myths_and_misconceptions_pregnancy%' THEN 1 ELSE 0 END),
        ('topic - Birth_plan', CASE WHEN src.topic LIKE '%birth_plan%' THEN 1 ELSE 0 END),
        ('topic - What_to_do_labour', CASE WHEN src.topic LIKE '%what_to_do_labour%' THEN 1 ELSE 0 END),
        ('topic - Care_after_child_birth', CASE WHEN src.topic LIKE '%care_after_child_birth%' THEN 1 ELSE 0 END),
        ('topic - Nutrition_after_birth', CASE WHEN src.topic LIKE '%nutrition_after_birth%' THEN 1 ELSE 0 END),
        ('topic - When_to_start_breastfeeding', CASE WHEN src.topic LIKE '%when_to_start_breastfeeding%' THEN 1 ELSE 0 END),
        ('topic - Danger_signs_child_birth', CASE WHEN src.topic LIKE '%danger_signs_child_birth%' THEN 1 ELSE 0 END),
        ('topic - Family_planning', CASE WHEN src.topic LIKE '%family_planning%' THEN 1 ELSE 0 END)
) AS unpivot(data_element, value)
WHERE value = 1;