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
    'tb_referral_follow_up' AS dataset,
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
    'tb_referral_follow_up' AS source_form
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
        LOWER(TRIM(patient_started_treatment)) AS patient_started_treatment,
        LOWER(TRIM(referred_to_health_facility)) AS referred_to_health_facility,
        LOWER(TRIM(went_to_facility_as_referred)) AS went_to_facility_as_referred
    FROM cht.mv_tb_referral_follow_up
) src
CROSS JOIN LATERAL (
    VALUES
        -- patient_started_treatment (yes/no)
        ('patient_started_treatment - Yes', CASE WHEN src.patient_started_treatment = 'yes' THEN 1 ELSE 0 END),
        ('patient_started_treatment - No', CASE WHEN src.patient_started_treatment = 'no' THEN 1 ELSE 0 END),

        -- referred_to_health_facility (yes/no)
        ('referred_to_health_facility - Yes', CASE WHEN src.referred_to_health_facility = 'yes' THEN 1 ELSE 0 END),
        ('referred_to_health_facility - No', CASE WHEN src.referred_to_health_facility = 'no' THEN 1 ELSE 0 END),

        -- went_to_facility_as_referred (yes/no)
        ('went_to_facility_as_referred - Yes', CASE WHEN src.went_to_facility_as_referred = 'yes' THEN 1 ELSE 0 END),
        ('went_to_facility_as_referred - No', CASE WHEN src.went_to_facility_as_referred = 'no' THEN 1 ELSE 0 END)
) AS unpivot(data_element, value)
WHERE value = 1;