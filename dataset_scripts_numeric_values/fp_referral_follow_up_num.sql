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
    'family_planning' AS theme,
    'fp_referral_follow_up' AS dataset,
    unpivot.data_element,
    unpivot.value,
    date,
    chw_id,
    contact_facility_id AS facility_id,
    district_id AS district_id,
    region_id AS region,
    patient_age_in_years,
    NULL AS patient_age_in_months,
    NULL AS patient_age_in_days,
    inputs_contact_sex AS patient_sex,
    inputs_contact_date_of_birth AS patient_dob,
    'cht' AS source_system,
    'fp_referral_follow_up' AS source_form
FROM (
    SELECT
        uuid,
        date,
        chw_id,
        contact_facility_id,
        district_id,
        region_id,
        patient_age_in_years,
        inputs_contact_sex,
        inputs_contact_date_of_birth,

        -- indicator columns
        LOWER(TRIM(visited_facility)) AS visited_facility,
        LOWER(TRIM(enrolled_fp)) AS enrolled_fp,
        LOWER(TRIM(reason_not_enrolled_fp)) AS reason_not_enrolled_fp
    FROM cht.mv_fp_referral_follow_up
) src
CROSS JOIN LATERAL (
    VALUES
        -- visited_facility (yes/no)
        ('visited_facility - Yes', CASE WHEN src.visited_facility = 'yes' THEN 1 ELSE 0 END),
        ('visited_facility - No', CASE WHEN src.visited_facility = 'no' THEN 1 ELSE 0 END),

        -- enrolled_fp (yes/no)
        ('enrolled_fp - Yes', CASE WHEN src.enrolled_fp = 'yes' THEN 1 ELSE 0 END),
        ('enrolled_fp - No', CASE WHEN src.enrolled_fp = 'no' THEN 1 ELSE 0 END),

        -- reason_not_enrolled_fp (is_pregnant/refused)
        ('reason_not_enrolled_fp - Is_pregnant', CASE WHEN src.reason_not_enrolled_fp LIKE '%is_pregnant%' THEN 1 ELSE 0 END),
        ('reason_not_enrolled_fp - Refused', CASE WHEN src.reason_not_enrolled_fp LIKE '%refused%' THEN 1 ELSE 0 END)
) AS unpivot(data_element, value)
WHERE value = 1;