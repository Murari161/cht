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
    'Tuberclosis' AS theme,
    'tb_follow_up' AS dataset,
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
    date_of_birth AS patient_dob,
    'cht' AS source_system,
    'tb_follow_up' AS source_form
FROM (
    SELECT
        doc_id,
        date,
        chw_id,
        contact_facility_id,
        district_id,
        region_id,
        patient_age_in_years,
        patient_age_in_months,
        patient_age_in_days,
        patient_gender,
        date_of_birth,

        -- indicator columns
        LOWER(TRIM(taking_tb_drugs)) AS taking_tb_drugs,
        LOWER(TRIM(attending_scheduled_clinic_visits)) AS attending_scheduled_clinic_visits,
        LOWER(TRIM(has_exited_tb_program)) AS has_exited_tb_program
    FROM cht.mv_tb_follow_up
) src
CROSS JOIN LATERAL (
    VALUES
        -- taking_tb_drugs (yes/no)
        ('taking_tb_drugs - Yes', CASE WHEN src.taking_tb_drugs = 'yes' THEN 1 ELSE 0 END),
        ('taking_tb_drugs - No', CASE WHEN src.taking_tb_drugs = 'no' THEN 1 ELSE 0 END),

        -- attending_scheduled_clinic_visits (yes/no)
        ('attending_scheduled_clinic_visits - Yes', CASE WHEN src.attending_scheduled_clinic_visits = 'yes' THEN 1 ELSE 0 END),
        ('attending_scheduled_clinic_visits - No', CASE WHEN src.attending_scheduled_clinic_visits = 'no' THEN 1 ELSE 0 END),

        -- has_exited_tb_program (yes/no)
        ('has_exited_tb_program - Yes', CASE WHEN src.has_exited_tb_program = 'yes' THEN 1 ELSE 0 END),
        ('has_exited_tb_program - No', CASE WHEN src.has_exited_tb_program = 'no' THEN 1 ELSE 0 END)
) AS unpivot(data_element, value)
WHERE value = 1;