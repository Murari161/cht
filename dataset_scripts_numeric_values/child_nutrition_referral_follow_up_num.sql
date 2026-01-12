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
    'child_nutrition_referral_follow_up' AS dataset,
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
    t_patient_gender AS patient_sex,
    t_patient_date_of_birth AS patient_dob,
    'cht' AS source_system,
    'child_nutrition_referral_follow_up' AS source_form
FROM (
    SELECT
        uuid,
        date,
        chw_id,
        facility_id,
        district,
        region,
        patient_age_in_years,
        patient_age_in_months,
        patient_age_in_days,
        t_patient_gender,
        t_patient_date_of_birth,

        -- indicator columns
        LOWER(TRIM(taken_to_facility)) AS taken_to_facility,
        LOWER(TRIM(nutritional_status)) AS nutritional_status,
        LOWER(TRIM(food_and_good_nutrition_choices)) AS food_and_good_nutrition_choices
    FROM cht.mv_child_nutrition_referral_follow_up
) src
CROSS JOIN LATERAL (
    VALUES
        -- taken_to_facility (yes/no)
        ('taken_to_facility - Yes', CASE WHEN src.taken_to_facility = 'yes' THEN 1 ELSE 0 END),
        ('taken_to_facility - No', CASE WHEN src.taken_to_facility = 'no' THEN 1 ELSE 0 END),

        -- nutritional_status (healthy/malnourished)
        ('nutritional_status - Healthy', CASE WHEN src.nutritional_status LIKE '%healthy%' THEN 1 ELSE 0 END),
        ('nutritional_status - Malnourished', CASE WHEN src.nutritional_status LIKE '%malnourished%' THEN 1 ELSE 0 END),

        -- food_and_good_nutrition_choices (importance_good_nutrition/balanced_diet/nutrition_requirements/diversified_diet/safe_handling)
        ('food_and_good_nutrition_choices - Importance_good_nutrition', CASE WHEN src.food_and_good_nutrition_choices LIKE '%importance_good_nutrition%' THEN 1 ELSE 0 END),
        ('food_and_good_nutrition_choices - Balanced_diet', CASE WHEN src.food_and_good_nutrition_choices LIKE '%balanced_diet%' THEN 1 ELSE 0 END),
        ('food_and_good_nutrition_choices - Nutrition_requirements', CASE WHEN src.food_and_good_nutrition_choices LIKE '%nutrition_requirements%' THEN 1 ELSE 0 END),
        ('food_and_good_nutrition_choices - Diversified_diet', CASE WHEN src.food_and_good_nutrition_choices LIKE '%diversified_diet%' THEN 1 ELSE 0 END),
        ('food_and_good_nutrition_choices - Safe_handling', CASE WHEN src.food_and_good_nutrition_choices LIKE '%safe_handling%' THEN 1 ELSE 0 END)
) AS unpivot(data_element, value)
WHERE value = 1;