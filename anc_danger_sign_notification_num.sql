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
    'anc' AS theme,
    'anc_danger_sign_notification' AS dataset,
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
    'anc_danger_sign_notification' AS source_form
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
        LOWER(TRIM(danger_signs)) AS danger_signs,
        LOWER(TRIM(confirm_refer_to_facility)) AS confirm_refer_to_facility,
        LOWER(TRIM(select_health_condition)) AS select_health_condition
    FROM cht.mv_anc_danger_sign_notification
) src
CROSS JOIN LATERAL (
    VALUES
        -- needs_signoff (true)
        ('needs_signoff - True', CASE WHEN src.needs_signoff = 'true' THEN 1 ELSE 0 END),

        -- danger_signs (vaginal_bleeding/lower_abdomen_pain/severe_headache/very_pale/fever/reduced_or_no_feotal_movements/blurred_vision/swelling/breathlessness/none)
        ('danger_signs - Vaginal_bleeding', CASE WHEN src.danger_signs LIKE '%vaginal_bleeding%' THEN 1 ELSE 0 END),
        ('danger_signs - Lower_abdomen_pain', CASE WHEN src.danger_signs LIKE '%lower_abdomen_pain%' THEN 1 ELSE 0 END),
        ('danger_signs - Severe_headache', CASE WHEN src.danger_signs LIKE '%severe_headache%' THEN 1 ELSE 0 END),
        ('danger_signs - Very_pale', CASE WHEN src.danger_signs LIKE '%very_pale%' THEN 1 ELSE 0 END),
        ('danger_signs - Fever', CASE WHEN src.danger_signs LIKE '%fever%' THEN 1 ELSE 0 END),
        ('danger_signs - Reduced_or_no_feotal_movements', CASE WHEN src.danger_signs LIKE '%reduced_or_no_feotal_movements%' THEN 1 ELSE 0 END),
        ('danger_signs - Blurred_vision', CASE WHEN src.danger_signs LIKE '%blurred_vision%' THEN 1 ELSE 0 END),
        ('danger_signs - Swelling', CASE WHEN src.danger_signs LIKE '%swelling%' THEN 1 ELSE 0 END),
        ('danger_signs - Breathlessness', CASE WHEN src.danger_signs LIKE '%breathlessness%' THEN 1 ELSE 0 END),
        ('danger_signs - None', CASE WHEN src.danger_signs LIKE '%none%' THEN 1 ELSE 0 END),

        -- confirm_refer_to_facility (yes)
        ('confirm_refer_to_facility - Yes', CASE WHEN src.confirm_refer_to_facility = 'yes' THEN 1 ELSE 0 END),

        -- select_health_condition (care_during_pregnancy/anc_attendance/nutrition_in_pregnancy/risk_factor_to_high_risk_pregnancy/common_problems_in_pregnancy/danger_signs_in_pregnancy/protecting_babies_from_hiv/birth_plan/demonstrate_maama_kit/what_to_do_labour/care_after_child_birth/nutrition_after_birth/when_to_start_breastfeeding/danger_signs_child_birth/family_planning)
        ('select_health_condition - Care_during_pregnancy', CASE WHEN src.select_health_condition LIKE '%care_during_pregnancy%' THEN 1 ELSE 0 END),
        ('select_health_condition - Anc_attendance', CASE WHEN src.select_health_condition LIKE '%anc_attendance%' THEN 1 ELSE 0 END),
        ('select_health_condition - Nutrition_in_pregnancy', CASE WHEN src.select_health_condition LIKE '%nutrition_in_pregnancy%' THEN 1 ELSE 0 END),
        ('select_health_condition - Risk_factor_to_high_risk_pregnancy', CASE WHEN src.select_health_condition LIKE '%risk_factor_to_high_risk_pregnancy%' THEN 1 ELSE 0 END),
        ('select_health_condition - Common_problems_in_pregnancy', CASE WHEN src.select_health_condition LIKE '%common_problems_in_pregnancy%' THEN 1 ELSE 0 END),
        ('select_health_condition - Danger_signs_in_pregnancy', CASE WHEN src.select_health_condition LIKE '%danger_signs_in_pregnancy%' THEN 1 ELSE 0 END),
        ('select_health_condition - Protecting_babies_from_hiv', CASE WHEN src.select_health_condition LIKE '%protecting_babies_from_hiv%' THEN 1 ELSE 0 END),
        ('select_health_condition - Birth_plan', CASE WHEN src.select_health_condition LIKE '%birth_plan%' THEN 1 ELSE 0 END),
        ('select_health_condition - Demonstrate_maama_kit', CASE WHEN src.select_health_condition LIKE '%demonstrate_maama_kit%' THEN 1 ELSE 0 END),
        ('select_health_condition - What_to_do_labour', CASE WHEN src.select_health_condition LIKE '%what_to_do_labour%' THEN 1 ELSE 0 END),
        ('select_health_condition - Care_after_child_birth', CASE WHEN src.select_health_condition LIKE '%care_after_child_birth%' THEN 1 ELSE 0 END),
        ('select_health_condition - Nutrition_after_birth', CASE WHEN src.select_health_condition LIKE '%nutrition_after_birth%' THEN 1 ELSE 0 END),
        ('select_health_condition - When_to_start_breastfeeding', CASE WHEN src.select_health_condition LIKE '%when_to_start_breastfeeding%' THEN 1 ELSE 0 END),
        ('select_health_condition - Danger_signs_child_birth', CASE WHEN src.select_health_condition LIKE '%danger_signs_child_birth%' THEN 1 ELSE 0 END),
        ('select_health_condition - Family_planning', CASE WHEN src.select_health_condition LIKE '%family_planning%' THEN 1 ELSE 0 END)
) AS unpivot(data_element, value)
WHERE value = 1;