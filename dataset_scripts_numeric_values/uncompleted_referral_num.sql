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
    'referral' AS theme,
    'uncompleted_referral' AS dataset,
    unpivot.data_element,
    unpivot.value,
    reported AS date,
    chw_id,
    facility_id,
    NULL AS district_id,
    NULL AS region,
    patient_age_in_years,
    patient_age_in_months,
    patient_age_in_days,
    patient_gender AS patient_sex,
    date_of_birth AS patient_dob,
    'cht' AS source_system,
    'uncompleted_referral' AS source_form
FROM (
    SELECT
        uuid,
        reported,
        chw_id,
        facility_id,
        patient_age_in_years,
        patient_age_in_months,
        patient_age_in_days,
        patient_gender,
        date_of_birth,

        -- indicator columns
        LOWER(TRIM(needs_signoff)) AS needs_signoff,
        LOWER(TRIM(refer_to_health_facility)) AS refer_to_health_facility,
        LOWER(TRIM(referral_reason)) AS referral_reason
    FROM cht.mv_uncompleted_referral
) src
CROSS JOIN LATERAL (
    VALUES
        -- needs_signoff (true) - binary
        ('needs_signoff - True', CASE WHEN src.needs_signoff = 'true' THEN 1 ELSE 0 END),

        -- refer_to_health_facility (yes) - binary
        ('refer_to_health_facility - Yes', CASE WHEN src.refer_to_health_facility = 'yes' THEN 1 ELSE 0 END),

        -- referral_reason (anc_danger_signs/newborn_danger_signs/missed_immunization_visits/experienced_onset_of_weakness) - binary
        ('referral_reason - Anc_danger_signs', CASE WHEN src.referral_reason LIKE '%anc_danger_signs%' THEN 1 ELSE 0 END),
        ('referral_reason - Newborn_danger_signs', CASE WHEN src.referral_reason LIKE '%newborn_danger_signs%' THEN 1 ELSE 0 END),
        ('referral_reason - Missed_immunization_visits', CASE WHEN src.referral_reason LIKE '%missed_immunization_visits%' THEN 1 ELSE 0 END),
        ('referral_reason - Experienced_onset_of_weakness', CASE WHEN src.referral_reason LIKE '%experienced_onset_of_weakness%' THEN 1 ELSE 0 END)
) AS unpivot(data_element, value)
WHERE value = 1;