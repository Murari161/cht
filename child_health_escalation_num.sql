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
    'ICCM' AS theme,
    'child_health_escalation' AS dataset,
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
    dob AS patient_dob,
    'cht' AS source_system,
    'child_health_escalation' AS source_form
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
        dob,

        -- indicator columns
        LOWER(TRIM(completed_referral_follow_up)) AS completed_referral_follow_up,
        LOWER(TRIM(reason_vht_did_not_follow_up)) AS reason_vht_did_not_follow_up
    FROM cht.mv_child_health_escalation
) src
CROSS JOIN LATERAL (
    VALUES
        -- completed_referral_follow_up (yes/no)
        ('completed_referral_follow_up - Yes', CASE WHEN src.completed_referral_follow_up = 'yes' THEN 1 ELSE 0 END),
        ('completed_referral_follow_up - No', CASE WHEN src.completed_referral_follow_up = 'no' THEN 1 ELSE 0 END),

        -- reason_vht_did_not_follow_up (child_not_available/vht_not_available/caregiver_refused_to_follow_up/others)
        ('reason_vht_did_not_follow_up - Child_not_available', CASE WHEN src.reason_vht_did_not_follow_up LIKE '%child_not_available%' THEN 1 ELSE 0 END),
        ('reason_vht_did_not_follow_up - Vht_not_available', CASE WHEN src.reason_vht_did_not_follow_up LIKE '%vht_not_available%' THEN 1 ELSE 0 END),
        ('reason_vht_did_not_follow_up - Caregiver_refused_to_follow_up', CASE WHEN src.reason_vht_did_not_follow_up LIKE '%caregiver_refused_to_follow_up%' THEN 1 ELSE 0 END),
        ('reason_vht_did_not_follow_up - Others', CASE WHEN src.reason_vht_did_not_follow_up LIKE '%others%' THEN 1 ELSE 0 END)
) AS unpivot(data_element, value)
WHERE value = 1;