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
    'newborn_danger_sign_follow_up' AS dataset,
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
    contact_date_of_birth AS patient_dob,
    'cht' AS source_system,
    'newborn_danger_sign_follow_up' AS source_form
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
        contact_date_of_birth,

        -- indicator columns
        LOWER(TRIM(needs_signoff)) AS needs_signoff,
        LOWER(TRIM(taken_to_health_facility)) AS taken_to_health_facility,
        LOWER(TRIM(still_experiencing_danger_signs)) AS still_experiencing_danger_signs,
        LOWER(TRIM(breathing_difficulty)) AS breathing_difficulty,
        LOWER(TRIM(not_breastfeeding_Well)) AS not_breastfeeding_Well,
        LOWER(TRIM(feels_hot_or_cold)) AS feels_hot_or_cold,
        LOWER(TRIM(less_active)) AS less_active,
        LOWER(TRIM(yellow_body)) AS yellow_body,
        LOWER(TRIM(has_danger_signs)) AS has_danger_signs
    FROM cht.mv_newborn_danger_sign_follow_up
) src
CROSS JOIN LATERAL (
    VALUES
        -- needs_signoff (true) - binary
        ('needs_signoff - True', CASE WHEN src.needs_signoff = 'true' THEN 1 ELSE 0 END),

        -- taken_to_health_facility (yes/no) - binary
        ('taken_to_health_facility - Yes', CASE WHEN src.taken_to_health_facility = 'yes' THEN 1 ELSE 0 END),
        ('taken_to_health_facility - No', CASE WHEN src.taken_to_health_facility = 'no' THEN 1 ELSE 0 END),

        -- still_experiencing_danger_signs (yes/no) - binary
        ('still_experiencing_danger_signs - Yes', CASE WHEN src.still_experiencing_danger_signs = 'yes' THEN 1 ELSE 0 END),
        ('still_experiencing_danger_signs - No', CASE WHEN src.still_experiencing_danger_signs = 'no' THEN 1 ELSE 0 END),

        -- breathing_difficulty (yes/no) - binary
        ('breathing_difficulty - Yes', CASE WHEN src.breathing_difficulty = 'yes' THEN 1 ELSE 0 END),
        ('breathing_difficulty - No', CASE WHEN src.breathing_difficulty = 'no' THEN 1 ELSE 0 END),

        -- not_breastfeeding_Well (yes/no) - binary
        ('not_breastfeeding_Well - Yes', CASE WHEN src.not_breastfeeding_Well = 'yes' THEN 1 ELSE 0 END),
        ('not_breastfeeding_Well - No', CASE WHEN src.not_breastfeeding_Well = 'no' THEN 1 ELSE 0 END),

        -- feels_hot_or_cold (yes/no) - binary
        ('feels_hot_or_cold - Yes', CASE WHEN src.feels_hot_or_cold = 'yes' THEN 1 ELSE 0 END),
        ('feels_hot_or_cold - No', CASE WHEN src.feels_hot_or_cold = 'no' THEN 1 ELSE 0 END),

        -- less_active (yes/no) - binary
        ('less_active - Yes', CASE WHEN src.less_active = 'yes' THEN 1 ELSE 0 END),
        ('less_active - No', CASE WHEN src.less_active = 'no' THEN 1 ELSE 0 END),

        -- yellow_body (yes/no) - binary
        ('yellow_body - Yes', CASE WHEN src.yellow_body = 'yes' THEN 1 ELSE 0 END),
        ('yellow_body - No', CASE WHEN src.yellow_body = 'no' THEN 1 ELSE 0 END),

        -- has_danger_signs (yes/no) - binary
        ('has_danger_signs - Yes', CASE WHEN src.has_danger_signs = 'yes' THEN 1 ELSE 0 END),
        ('has_danger_signs - No', CASE WHEN src.has_danger_signs = 'no' THEN 1 ELSE 0 END)
) AS unpivot(data_element, value)
WHERE value = 1;