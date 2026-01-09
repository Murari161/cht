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
    'child_nutrition' AS theme,
    'child_nutrition_follow_up' AS dataset,
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
    'child_nutrition_follow_up' AS source_form
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
        LOWER(TRIM(offer_and_select_nutrition_practices)) AS offer_and_select_nutrition_practices,
        LOWER(TRIM(outcome_of_follow_up_visit)) AS outcome_of_follow_up_visit,
        LOWER(TRIM(taken_to_facility)) AS taken_to_facility,
        LOWER(TRIM(needs_signoff)) AS needs_signoff
    FROM cht.mv_child_nutrition_follow_up_new
) src
CROSS JOIN LATERAL (
    VALUES
        -- offer_and_select_nutrition_practices (definition_good_nutrition/balanced_diet/key_nutrition_requirements/access_to_diversified_diet/safe_preparation_food)
        ('offer_and_select_nutrition_practices - Definition_good_nutrition', CASE WHEN src.offer_and_select_nutrition_practices LIKE '%definition_good_nutrition%' THEN 1 ELSE 0 END),
        ('offer_and_select_nutrition_practices - Balanced_diet', CASE WHEN src.offer_and_select_nutrition_practices LIKE '%balanced_diet%' THEN 1 ELSE 0 END),
        ('offer_and_select_nutrition_practices - Key_nutrition_requirements', CASE WHEN src.offer_and_select_nutrition_practices LIKE '%key_nutrition_requirements%' THEN 1 ELSE 0 END),
        ('offer_and_select_nutrition_practices - Access_to_diversified_diet', CASE WHEN src.offer_and_select_nutrition_practices LIKE '%access_to_diversified_diet%' THEN 1 ELSE 0 END),
        ('offer_and_select_nutrition_practices - Safe_preparation_food', CASE WHEN src.offer_and_select_nutrition_practices LIKE '%safe_preparation_food%' THEN 1 ELSE 0 END),

        -- outcome_of_follow_up_visit (child_discharged/child_on_follow_up)
        ('outcome_of_follow_up_visit - Child_discharged', CASE WHEN src.outcome_of_follow_up_visit LIKE '%child_discharged%' THEN 1 ELSE 0 END),
        ('outcome_of_follow_up_visit - Child_on_follow_up', CASE WHEN src.outcome_of_follow_up_visit LIKE '%child_on_follow_up%' THEN 1 ELSE 0 END),

        -- taken_to_facility (yes/no)
        ('taken_to_facility - Yes', CASE WHEN src.taken_to_facility = 'yes' THEN 1 ELSE 0 END),
        ('taken_to_facility - No', CASE WHEN src.taken_to_facility = 'no' THEN 1 ELSE 0 END),

        -- needs_signoff (true)
        ('needs_signoff - True', CASE WHEN src.needs_signoff = 'true' THEN 1 ELSE 0 END)
) AS unpivot(data_element, value)
WHERE value = 1;