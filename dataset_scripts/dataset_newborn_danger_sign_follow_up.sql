INSERT INTO cht.fact_cht_values (
    uuid,
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
    'newborn_danger_sign_follow_up' AS dataset,
    unpivot.data_element,
    unpivot.value,
    reported::date AS date,
    contact__id AS chw_id,
    facility_id AS facility_id,
    district AS district_id,
    region,
    patient_age_in_years,
    patient_age_in_months,
    patient_age_in_days,
    patient_gender AS patient_sex,
    date_of_birth AS patient_dob,
    'cht' AS source_system,
    'newborn_danger_sign_follow_up' AS source_form
FROM (
    SELECT
        uuid,
        reported,
        contact__id,
        facility_id,
        district,
        region,
        patient_age_in_years,
        patient_age_in_months,
        patient_age_in_days,
        patient_gender,
        date_of_birth,

        -- indicator columns from MV
        taken_to_health_facility,
        still_experiencing_danger_signs,
        breathing_difficulty,
        not_breastfeeding_well,
        feels_hot_or_cold,
        less_active,
        yellow_body,
        has_danger_signs
    FROM cht.mv_newborn_danger_sign_follow_up
) src
CROSS JOIN LATERAL (
    VALUES
        ('taken_to_health_facility', src.taken_to_health_facility),
        ('still_experiencing_danger_signs', src.still_experiencing_danger_signs),
        ('breathing_difficulty', src.breathing_difficulty),
        ('not_breastfeeding_well', src.not_breastfeeding_well),
        ('feels_hot_or_cold', src.feels_hot_or_cold),
        ('less_active', src.less_active),
        ('yellow_body', src.yellow_body),
        ('has_danger_signs', src.has_danger_signs)
) AS unpivot(data_element, value)
WHERE unpivot.value IS NOT NULL
  AND TRIM(unpivot.value) <> '';