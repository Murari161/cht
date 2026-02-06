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
    'referral' AS theme,
    'referral_follow_up' AS dataset,
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
    'referral_follow_up' AS source_form
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
        LOWER(TRIM(follow_up_method)) AS follow_up_method,
        LOWER(TRIM(patient_condition)) AS patient_condition,
        LOWER(TRIM(went_to_health_facility)) AS went_to_health_facility,
        LOWER(TRIM(interact_with_healthcare)) AS interact_with_healthcare,
        LOWER(TRIM(hc_attendant)) AS hc_attendant
    FROM cht.mv_referral_follow_up
) src
CROSS JOIN LATERAL (
    VALUES
        -- needs_signoff (true) - binary
        ('needs_signoff - True', CASE WHEN src.needs_signoff = 'true' THEN 1 ELSE 0 END),

        -- follow_up_method (in_person/by_phone) - binary
        ('follow_up_method - In_person', CASE WHEN src.follow_up_method LIKE '%in_person%' THEN 1 ELSE 0 END),
        ('follow_up_method - By_phone', CASE WHEN src.follow_up_method LIKE '%by_phone%' THEN 1 ELSE 0 END),

        -- patient_condition (improving/no_change/getting_worse) - binary
        ('patient_condition - Improving', CASE WHEN src.patient_condition LIKE '%improving%' THEN 1 ELSE 0 END),
        ('patient_condition - No_change', CASE WHEN src.patient_condition LIKE '%no_change%' THEN 1 ELSE 0 END),
        ('patient_condition - Getting_worse', CASE WHEN src.patient_condition LIKE '%getting_worse%' THEN 1 ELSE 0 END),

        -- went_to_health_facility (yes/no) - binary
        ('went_to_health_facility - Yes', CASE WHEN src.went_to_health_facility = 'yes' THEN 1 ELSE 0 END),
        ('went_to_health_facility - No', CASE WHEN src.went_to_health_facility = 'no' THEN 1 ELSE 0 END),

        -- interact_with_healthcare (yes/no) - binary
        ('interact_with_healthcare - Yes', CASE WHEN src.interact_with_healthcare = 'yes' THEN 1 ELSE 0 END),
        ('interact_with_healthcare - No', CASE WHEN src.interact_with_healthcare = 'no' THEN 1 ELSE 0 END),

        -- hc_attendant (nurse/doctor/clinical_officer/other) - binary
        ('hc_attendant - Nurse', CASE WHEN src.hc_attendant LIKE '%nurse%' THEN 1 ELSE 0 END),
        ('hc_attendant - Doctor', CASE WHEN src.hc_attendant LIKE '%doctor%' THEN 1 ELSE 0 END),
        ('hc_attendant - Clinical_officer', CASE WHEN src.hc_attendant LIKE '%clinical_officer%' THEN 1 ELSE 0 END),
        ('hc_attendant - Other', CASE WHEN src.hc_attendant LIKE '%other%' THEN 1 ELSE 0 END)
) AS unpivot(data_element, value)
WHERE value = 1;