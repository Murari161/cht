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
    'anc_referral_follow_up' AS dataset,
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
    'anc_referral_follow_up' AS source_form
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
        LOWER(TRIM(went_to_hospital)) AS went_to_hospital,
        LOWER(TRIM(actions_taken)) AS actions_taken,
        LOWER(TRIM(missed_referral_reason)) AS missed_referral_reason,
        LOWER(TRIM(group_referral_details_went_to_hospital)) AS group_referral_details_went_to_hospital,
        LOWER(TRIM(pregnancy_test_outcome)) AS pregnancy_test_outcome,
        LOWER(TRIM(reason_not_attended_referral)) AS reason_not_attended_referral,
        LOWER(TRIM(agreed_to_go_to_facility)) AS agreed_to_go_to_facility
    FROM cht.mv_anc_referral_follow_up_new
) src
CROSS JOIN LATERAL (
    VALUES
        -- went_to_hospital (yes/no)
        ('went_to_hospital - Yes', CASE WHEN src.went_to_hospital = 'yes' THEN 1 ELSE 0 END),
        ('went_to_hospital - No', CASE WHEN src.went_to_hospital = 'no' THEN 1 ELSE 0 END),

        -- actions_taken (referred/provided_key_messages)
        ('actions_taken - Referred', CASE WHEN src.actions_taken LIKE '%referred%' THEN 1 ELSE 0 END),
        ('actions_taken - Provided_key_messages', CASE WHEN src.actions_taken LIKE '%provided_key_messages%' THEN 1 ELSE 0 END),

        -- missed_referral_reason (lacked_transport/not_important/other)
        ('missed_referral_reason - Lacked_transport', CASE WHEN src.missed_referral_reason LIKE '%lacked_transport%' THEN 1 ELSE 0 END),
        ('missed_referral_reason - Not_important', CASE WHEN src.missed_referral_reason LIKE '%not_important%' THEN 1 ELSE 0 END),
        ('missed_referral_reason - Other', CASE WHEN src.missed_referral_reason LIKE '%other%' THEN 1 ELSE 0 END),

        -- group_referral_details_went_to_hospital (yes/no)
        ('group_referral_details_went_to_hospital - Yes', CASE WHEN src.group_referral_details_went_to_hospital = 'yes' THEN 1 ELSE 0 END),
        ('group_referral_details_went_to_hospital - No', CASE WHEN src.group_referral_details_went_to_hospital = 'no' THEN 1 ELSE 0 END),

        -- pregnancy_test_outcome (positive/negative)
        ('pregnancy_test_outcome - Positive', CASE WHEN src.pregnancy_test_outcome LIKE '%positive%' THEN 1 ELSE 0 END),
        ('pregnancy_test_outcome - Negative', CASE WHEN src.pregnancy_test_outcome LIKE '%negative%' THEN 1 ELSE 0 END),

        -- reason_not_attended_referral (pregnancy_too_young/lacked_transport/other)
        ('reason_not_attended_referral - Pregnancy_too_young', CASE WHEN src.reason_not_attended_referral LIKE '%pregnancy_too_young%' THEN 1 ELSE 0 END),
        ('reason_not_attended_referral - Lacked_transport', CASE WHEN src.reason_not_attended_referral LIKE '%lacked_transport%' THEN 1 ELSE 0 END),
        ('reason_not_attended_referral - Other', CASE WHEN src.reason_not_attended_referral LIKE '%other%' THEN 1 ELSE 0 END),

        -- agreed_to_go_to_facility (yes/no)
        ('agreed_to_go_to_facility - Yes', CASE WHEN src.agreed_to_go_to_facility = 'yes' THEN 1 ELSE 0 END),
        ('agreed_to_go_to_facility - No', CASE WHEN src.agreed_to_go_to_facility = 'no' THEN 1 ELSE 0 END)
) AS unpivot(data_element, value)
WHERE value = 1;