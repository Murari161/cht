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
    'maternal' AS theme,
    'maternal_nutrition_follow_up' AS dataset,
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
    'maternal_nutrition_follow_up' AS source_form
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
        LOWER(TRIM(is_of_child_bearing_age)) AS is_of_child_bearing_age,
        LOWER(TRIM(went_to_facility)) AS went_to_facility,
        LOWER(TRIM(referred_to_health_facility)) AS referred_to_health_facility,
        LOWER(TRIM(nutrition_status)) AS nutrition_status,
        LOWER(TRIM(follow_up_outcome)) AS follow_up_outcome
    FROM cht.mv_maternal_nutrition_follow_up
) src
CROSS JOIN LATERAL (
    VALUES
        -- is_of_child_bearing_age (true/false) - binary
        ('is_of_child_bearing_age - True', CASE WHEN src.is_of_child_bearing_age = 'true' THEN 1 ELSE 0 END),
        ('is_of_child_bearing_age - False', CASE WHEN src.is_of_child_bearing_age = 'false' THEN 1 ELSE 0 END),

        -- went_to_facility (yes/no) - binary
        ('went_to_facility - Yes', CASE WHEN src.went_to_facility = 'yes' THEN 1 ELSE 0 END),
        ('went_to_facility - No', CASE WHEN src.went_to_facility = 'no' THEN 1 ELSE 0 END),

        -- referred_to_health_facility (yes) - binary
        ('referred_to_health_facility - Yes', CASE WHEN src.referred_to_health_facility = 'yes' THEN 1 ELSE 0 END),

        -- nutrition_status (healthy/malnourished) - binary
        ('nutrition_status - Healthy', CASE WHEN src.nutrition_status LIKE '%healthy%' THEN 1 ELSE 0 END),
        ('nutrition_status - Malnourished', CASE WHEN src.nutrition_status LIKE '%malnourished%' THEN 1 ELSE 0 END),

        -- follow_up_outcome (discharged/on_follow_up) - binary
        ('follow_up_outcome - Discharged', CASE WHEN src.follow_up_outcome LIKE '%discharged%' THEN 1 ELSE 0 END),
        ('follow_up_outcome - On_follow_up', CASE WHEN src.follow_up_outcome LIKE '%on_follow_up%' THEN 1 ELSE 0 END)
) AS unpivot(data_element, value)
WHERE value = 1;