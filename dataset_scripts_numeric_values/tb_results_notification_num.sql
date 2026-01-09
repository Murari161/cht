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
    'tb' AS theme,
    'tb_results_notification' AS dataset,
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
    'tb_results_notification' AS source_form
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
        LOWER(TRIM(confirm_refer_to_health_facility)) AS confirm_refer_to_health_facility,
        LOWER(TRIM(has_patient_produced_sputum)) AS has_patient_produced_sputum,
        LOWER(TRIM(confirm_send_sample_for_testing)) AS confirm_send_sample_for_testing,
        LOWER(TRIM(has_left_sputum_bottle_with_client)) AS has_left_sputum_bottle_with_client
    FROM cht.mv_tb_results_notification
) src
CROSS JOIN LATERAL (
    VALUES
        -- confirm_refer_to_health_facility (yes)
        ('confirm_refer_to_health_facility - Yes', CASE WHEN src.confirm_refer_to_health_facility = 'yes' THEN 1 ELSE 0 END),

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