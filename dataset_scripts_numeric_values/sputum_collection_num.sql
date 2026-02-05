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
   uuid,
    'Tuberclosis' AS theme,
    'sputum_collection' AS dataset,
    unpivot.data_element,
    unpivot.value,
    date,
    chw_id,
    contact_facility_id as facility_id,
    district_id,
    region_id as region,
    patient_age_in_years,
    patient_age_in_months,
    patient_age_in_days,
    patient_gender AS patient_sex,
    n_contact_date_of_birth AS patient_dob,
    'cht' AS source_system,
    'sputum_collection' AS source_form
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
        n_contact_date_of_birth,

        -- indicator columns
        LOWER(TRIM(is_patient_available)) AS is_patient_available,
        LOWER(TRIM(has_produced_sputum)) AS has_produced_sputum,
        LOWER(TRIM(confirm_send_sample_for_testing)) AS confirm_send_sample_for_testing
    FROM cht.mv_sputum_collection
) src
CROSS JOIN LATERAL (
    VALUES
        -- is_patient_available (yes/no)
        ('is_patient_available - Yes', CASE WHEN src.is_patient_available = 'yes' THEN 1 ELSE 0 END),
        ('is_patient_available - No', CASE WHEN src.is_patient_available = 'no' THEN 1 ELSE 0 END),

        -- has_produced_sputum (yes/no)
        ('has_produced_sputum - Yes', CASE WHEN src.has_produced_sputum = 'yes' THEN 1 ELSE 0 END),
        ('has_produced_sputum - No', CASE WHEN src.has_produced_sputum = 'no' THEN 1 ELSE 0 END),

        -- confirm_send_sample_for_testing (yes)
        ('confirm_send_sample_for_testing - Yes', CASE WHEN src.confirm_send_sample_for_testing = 'yes' THEN 1 ELSE 0 END)
) AS unpivot(data_element, value)
WHERE value = 1;