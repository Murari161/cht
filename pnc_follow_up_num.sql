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
    'pnc' AS theme,
    'pnc_follow_up' AS dataset,
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
    'pnc_follow_up' AS source_form
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
        LOWER(TRIM(went_facility_as_referred)) AS went_facility_as_referred,
        LOWER(TRIM(missed_referral_reason)) AS missed_referral_reason,
        LOWER(TRIM(missed_referral_actions)) AS missed_referral_actions,
        LOWER(TRIM(mother_condition)) AS mother_condition,
        LOWER(TRIM(is_available)) AS is_available,
        LOWER(TRIM(missed_visit_reason)) AS missed_visit_reason,
        LOWER(TRIM(agreed_to_go_for_pnc_visit)) AS agreed_to_go_for_pnc_visit,
        LOWER(TRIM(has_attended_pnc_facility)) AS has_attended_pnc_facility,
        LOWER(TRIM(pnc_visit)) AS pnc_visit,
        LOWER(TRIM(on_nutrition_follow_up)) AS on_nutrition_follow_up,
        LOWER(TRIM(taken_muac)) AS taken_muac,
        LOWER(TRIM(muac_measurement)) AS muac_measurement,
        LOWER(TRIM(referred_to_health_facility_nutrition)) AS referred_to_health_facility_nutrition,
        LOWER(TRIM(completed_last_nutrition_follow_up)) AS completed_last_nutrition_follow_up,
        LOWER(TRIM(referred_to_health_facility_missed_nutrition_follow_up)) AS referred_to_health_facility_missed_nutrition_follow_up
    FROM cht.mv_pnc_follow_up
) src
CROSS JOIN LATERAL (
    VALUES
        -- went_facility_as_referred (yes/no)
        ('went_facility_as_referred - Yes', CASE WHEN src.went_facility_as_referred = 'yes' THEN 1 ELSE 0 END),
        ('went_facility_as_referred - No', CASE WHEN src.went_facility_as_referred = 'no' THEN 1 ELSE 0 END),

        -- missed_referral_reason (lacked_transport/not_important/other)
        ('missed_referral_reason - Lacked_transport', CASE WHEN src.missed_referral_reason LIKE '%lacked_transport%' THEN 1 ELSE 0 END),
        ('missed_referral_reason - Not_important', CASE WHEN src.missed_referral_reason LIKE '%not_important%' THEN 1 ELSE 0 END),
        ('missed_referral_reason - Other', CASE WHEN src.missed_referral_reason LIKE '%other%' THEN 1 ELSE 0 END),

        -- missed_referral_actions (referred/provided_key_message)
        ('missed_referral_actions - Referred', CASE WHEN src.missed_referral_actions LIKE '%referred%' THEN 1 ELSE 0 END),
        ('missed_referral_actions - Provided_key_message', CASE WHEN src.missed_referral_actions LIKE '%provided_key_message%' THEN 1 ELSE 0 END),

        -- mother_condition (alive/dead)
        ('mother_condition - Alive', CASE WHEN src.mother_condition LIKE '%alive%' THEN 1 ELSE 0 END),
        ('mother_condition - Dead', CASE WHEN src.mother_condition LIKE '%dead%' THEN 1 ELSE 0 END),

        -- is_available (yes/no)
        ('is_available - Yes', CASE WHEN src.is_available = 'yes' THEN 1 ELSE 0 END),
        ('is_available - No', CASE WHEN src.is_available = 'no' THEN 1 ELSE 0 END),

        -- missed_visit_reason (relocated/no_transport/had_traveled/not_important/other)
        ('missed_visit_reason - Relocated', CASE WHEN src.missed_visit_reason LIKE '%relocated%' THEN 1 ELSE 0 END),
        ('missed_visit_reason - No_transport', CASE WHEN src.missed_visit_reason LIKE '%no_transport%' THEN 1 ELSE 0 END),
        ('missed_visit_reason - Had_traveled', CASE WHEN src.missed_visit_reason LIKE '%had_traveled%' THEN 1 ELSE 0 END),
        ('missed_visit_reason - Not_important', CASE WHEN src.missed_visit_reason LIKE '%not_important%' THEN 1 ELSE 0 END),
        ('missed_visit_reason - Other', CASE WHEN src.missed_visit_reason LIKE '%other%' THEN 1 ELSE 0 END),

        -- agreed_to_go_for_pnc_visit (yes/no)
        ('agreed_to_go_for_pnc_visit - Yes', CASE WHEN src.agreed_to_go_for_pnc_visit = 'yes' THEN 1 ELSE 0 END),
        ('agreed_to_go_for_pnc_visit - No', CASE WHEN src.agreed_to_go_for_pnc_visit = 'no' THEN 1 ELSE 0 END),

        -- has_attended_pnc_facility (yes/no)
        ('has_attended_pnc_facility - Yes', CASE WHEN src.has_attended_pnc_facility = 'yes' THEN 1 ELSE 0 END),
        ('has_attended_pnc_facility - No', CASE WHEN src.has_attended_pnc_facility = 'no' THEN 1 ELSE 0 END),

        -- pnc_visit (within_24_hours/7_days/6_weeks)
        ('pnc_visit - Within_24_hours', CASE WHEN src.pnc_visit LIKE '%within_24_hours%' THEN 1 ELSE 0 END),
        ('pnc_visit - 7_days', CASE WHEN src.pnc_visit LIKE '%7_days%' THEN 1 ELSE 0 END),
        ('pnc_visit - 6_weeks', CASE WHEN src.pnc_visit LIKE '%6_weeks%' THEN 1 ELSE 0 END),

        -- on_nutrition_follow_up (yes/no)
        ('on_nutrition_follow_up - Yes', CASE WHEN src.on_nutrition_follow_up = 'yes' THEN 1 ELSE 0 END),
        ('on_nutrition_follow_up - No', CASE WHEN src.on_nutrition_follow_up = 'no' THEN 1 ELSE 0 END),

        -- taken_muac (yes/no)
        ('taken_muac - Yes', CASE WHEN src.taken_muac = 'yes' THEN 1 ELSE 0 END),
        ('taken_muac - No', CASE WHEN src.taken_muac = 'no' THEN 1 ELSE 0 END),

        -- muac_measurement (red/yellow/green)
        ('muac_measurement - Red', CASE WHEN src.muac_measurement LIKE '%red%' THEN 1 ELSE 0 END),
        ('muac_measurement - Yellow', CASE WHEN src.muac_measurement LIKE '%yellow%' THEN 1 ELSE 0 END),
        ('muac_measurement - Green', CASE WHEN src.muac_measurement LIKE '%green%' THEN 1 ELSE 0 END),

        -- referred_to_health_facility_nutrition (yes/no)
        ('referred_to_health_facility_nutrition - Yes', CASE WHEN src.referred_to_health_facility_nutrition = 'yes' THEN 1 ELSE 0 END),
        ('referred_to_health_facility_nutrition - No', CASE WHEN src.referred_to_health_facility_nutrition = 'no' THEN 1 ELSE 0 END),

        -- completed_last_nutrition_follow_up (yes/no)
        ('completed_last_nutrition_follow_up - Yes', CASE WHEN src.completed_last_nutrition_follow_up = 'yes' THEN 1 ELSE 0 END),
        ('completed_last_nutrition_follow_up - No', CASE WHEN src.completed_last_nutrition_follow_up = 'no' THEN 1 ELSE 0 END),

        -- referred_to_health_facility_missed_nutrition_follow_up (yes/no)
        ('referred_to_health_facility_missed_nutrition_follow_up - Yes', CASE WHEN src.referred_to_health_facility_missed_nutrition_follow_up = 'yes' THEN 1 ELSE 0 END),
        ('referred_to_health_facility_missed_nutrition_follow_up - No', CASE WHEN src.referred_to_health_facility_missed_nutrition_follow_up = 'no' THEN 1 ELSE 0 END)
) AS unpivot(data_element, value)
WHERE value = 1;