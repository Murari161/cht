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
    'sputum_collection_refusal' AS dataset,
    unpivot.data_element,
    unpivot.value,
    date,
    chw_id,
    contact_facility_id as facility_id,
    district_id AS district_id,
    region_id as region,
    patient_age_in_years,
    patient_age_in_months,
    patient_age_in_days,
    patient_gender AS patient_sex,
    patient_dob,
    'cht' AS source_system,
    'sputum_collection_refusal' AS source_form
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
        null as patient_dob,

        -- indicator columns
        LOWER(TRIM(consented_sputum_sample)) AS consented_sputum_sample,
        LOWER(TRIM(receive_results_on_same_phonenumber)) AS receive_results_on_same_phonenumber,
        LOWER(TRIM(has_patient_produced_sputum)) AS has_patient_produced_sputum,
        LOWER(TRIM(confirm_send_sample_for_testing)) AS confirm_send_sample_for_testing,
        LOWER(TRIM(has_left_sputum_bottle_with_client)) AS has_left_sputum_bottle_with_client
    FROM cht.mv_sputum_collection_refusal
) src
CROSS JOIN LATERAL (
    VALUES
        -- consented_sputum_sample (yes/no)
        ('consented_sputum_sample - Yes', CASE WHEN src.consented_sputum_sample = 'yes' THEN 1 ELSE 0 END),
        ('consented_sputum_sample - No', CASE WHEN src.consented_sputum_sample = 'no' THEN 1 ELSE 0 END),

        -- receive_results_on_same_phonenumber (yes/no)
        ('receive_results_on_same_phonenumber - Yes', CASE WHEN src.receive_results_on_same_phonenumber = 'yes' THEN 1 ELSE 0 END),
        ('receive_results_on_same_phonenumber - No', CASE WHEN src.receive_results_on_same_phonenumber = 'no' THEN 1 ELSE 0 END),

        -- has_patient_produced_sputum (yes/no)
        ('has_patient_produced_sputum - Yes', CASE WHEN src.has_patient_produced_sputum = 'yes' THEN 1 ELSE 0 END),
        ('has_patient_produced_sputum - No', CASE WHEN src.has_patient_produced_sputum = 'no' THEN 1 ELSE 0 END),

        -- confirm_send_sample_for_testing (yes)
        ('confirm_send_sample_for_testing - Yes', CASE WHEN src.confirm_send_sample_for_testing = 'yes' THEN 1 ELSE 0 END),

        -- has_left_sputum_bottle_with_client (yes/no)
        ('has_left_sputum_bottle_with_client - Yes', CASE WHEN src.has_left_sputum_bottle_with_client = 'yes' THEN 1 ELSE 0 END),
        ('has_left_sputum_bottle_with_client - No', CASE WHEN src.has_left_sputum_bottle_with_client = 'no' THEN 1 ELSE 0 END)
) AS unpivot(data_element, value)
WHERE value = 1;