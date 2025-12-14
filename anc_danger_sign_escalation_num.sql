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
    'ANC' AS theme,
    'anc_danger_sign_escalation' AS dataset,
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
    'anc_danger_sign_escalation' AS source_form
FROM (
    SELECT
        uuid,
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
        LOWER(TRIM(reason_vht_did_not_follow_up)) AS reason_vht_did_not_follow_up,
        LOWER(TRIM(vht_completed_referral_follow_up)) AS vht_completed_referral_follow_up
    FROM cht.mv_anc_danger_sign_escalation
) src
CROSS JOIN LATERAL (
    VALUES
        -- needs_signoff (true)
        ('needs_signoff - True', CASE WHEN src.needs_signoff = 'true' THEN 1 ELSE 0 END),

        -- reason_vht_did_not_follow_up (woman_not_available/vht_not_available/others)
        ('reason_vht_did_not_follow_up - Woman_not_available', CASE WHEN src.reason_vht_did_not_follow_up LIKE '%woman_not_available%' THEN 1 ELSE 0 END),
        ('reason_vht_did_not_follow_up - Vht_not_available', CASE WHEN src.reason_vht_did_not_follow_up LIKE '%vht_not_available%' THEN 1 ELSE 0 END),
        ('reason_vht_did_not_follow_up - Others', CASE WHEN src.reason_vht_did_not_follow_up LIKE '%others%' THEN 1 ELSE 0 END),

        -- vht_completed_referral_follow_up (yes/no)
        ('vht_completed_referral_follow_up - Yes', CASE WHEN src.vht_completed_referral_follow_up = 'yes' THEN 1 ELSE 0 END),
        ('vht_completed_referral_follow_up - No', CASE WHEN src.vht_completed_referral_follow_up = 'no' THEN 1 ELSE 0 END)
) AS unpivot(data_element, value)
WHERE value = 1;