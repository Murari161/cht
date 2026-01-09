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
    'pnc_danger_sign' AS dataset,
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
    'pnc_danger_sign' AS source_form
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
        LOWER(TRIM(visited_health_facility)) AS visited_health_facility,
        LOWER(TRIM(still_experiencing_danger_signs)) AS still_experiencing_danger_signs,
        LOWER(TRIM(excessive_bleeding)) AS excessive_bleeding,
        LOWER(TRIM(vaginal_discharge)) AS vaginal_discharge,
        LOWER(TRIM(severe_abdominal_pain)) AS severe_abdominal_pain,
        LOWER(TRIM(swelling)) AS swelling,
        LOWER(TRIM(blurred_vision)) AS blurred_vision,
        LOWER(TRIM(fever)) AS fever,
        LOWER(TRIM(excessive_tiredness)) AS excessive_tiredness,
        LOWER(TRIM(breathlessness)) AS breathlessness,
        LOWER(TRIM(has_danger_signs)) AS has_danger_signs,
        LOWER(TRIM(has_no_danger_signs)) AS has_no_danger_signs,
        LOWER(TRIM(referred_to_facility)) AS referred_to_facility
    FROM cht.mv_pnc_danger_sign
) src
CROSS JOIN LATERAL (
    VALUES
        -- visited_health_facility (yes/no)
        ('visited_health_facility - Yes', CASE WHEN src.visited_health_facility = 'yes' THEN 1 ELSE 0 END),
        ('visited_health_facility - No', CASE WHEN src.visited_health_facility = 'no' THEN 1 ELSE 0 END),

        -- still_experiencing_danger_signs (yes/no)
        ('still_experiencing_danger_signs - Yes', CASE WHEN src.still_experiencing_danger_signs = 'yes' THEN 1 ELSE 0 END),
        ('still_experiencing_danger_signs - No', CASE WHEN src.still_experiencing_danger_signs = 'no' THEN 1 ELSE 0 END),

        -- excessive_bleeding (yes/no)
        ('excessive_bleeding - Yes', CASE WHEN src.excessive_bleeding = 'yes' THEN 1 ELSE 0 END),
        ('excessive_bleeding - No', CASE WHEN src.excessive_bleeding = 'no' THEN 1 ELSE 0 END),

        -- vaginal_discharge (yes/no)
        ('vaginal_discharge - Yes', CASE WHEN src.vaginal_discharge = 'yes' THEN 1 ELSE 0 END),
        ('vaginal_discharge - No', CASE WHEN src.vaginal_discharge = 'no' THEN 1 ELSE 0 END),

        -- severe_abdominal_pain (yes/no)
        ('severe_abdominal_pain - Yes', CASE WHEN src.severe_abdominal_pain = 'yes' THEN 1 ELSE 0 END),
        ('severe_abdominal_pain - No', CASE WHEN src.severe_abdominal_pain = 'no' THEN 1 ELSE 0 END),

        -- swelling (yes/no)
        ('swelling - Yes', CASE WHEN src.swelling = 'yes' THEN 1 ELSE 0 END),
        ('swelling - No', CASE WHEN src.swelling = 'no' THEN 1 ELSE 0 END),

        -- blurred_vision (yes/no)
        ('blurred_vision - Yes', CASE WHEN src.blurred_vision = 'yes' THEN 1 ELSE 0 END),
        ('blurred_vision - No', CASE WHEN src.blurred_vision = 'no' THEN 1 ELSE 0 END),

        -- fever (yes/no)
        ('fever - Yes', CASE WHEN src.fever = 'yes' THEN 1 ELSE 0 END),
        ('fever - No', CASE WHEN src.fever = 'no' THEN 1 ELSE 0 END),

        -- excessive_tiredness (yes/no)
        ('excessive_tiredness - Yes', CASE WHEN src.excessive_tiredness = 'yes' THEN 1 ELSE 0 END),
        ('excessive_tiredness - No', CASE WHEN src.excessive_tiredness = 'no' THEN 1 ELSE 0 END),

        -- breathlessness (yes/no)
        ('breathlessness - Yes', CASE WHEN src.breathlessness = 'yes' THEN 1 ELSE 0 END),
        ('breathlessness - No', CASE WHEN src.breathlessness = 'no' THEN 1 ELSE 0 END),

        -- has_danger_signs (yes/no)
        ('has_danger_signs - Yes', CASE WHEN src.has_danger_signs = 'yes' THEN 1 ELSE 0 END),
        ('has_danger_signs - No', CASE WHEN src.has_danger_signs = 'no' THEN 1 ELSE 0 END),

        -- has_no_danger_signs (yes/no)
        ('has_no_danger_signs - Yes', CASE WHEN src.has_no_danger_signs = 'yes' THEN 1 ELSE 0 END),
        ('has_no_danger_signs - No', CASE WHEN src.has_no_danger_signs = 'no' THEN 1 ELSE 0 END),

        -- referred_to_facility (yes/no)
        ('referred_to_facility - Yes', CASE WHEN src.referred_to_facility = 'yes' THEN 1 ELSE 0 END),
        ('referred_to_facility - No', CASE WHEN src.referred_to_facility = 'no' THEN 1 ELSE 0 END)
) AS unpivot(data_element, value)
WHERE value = 1;