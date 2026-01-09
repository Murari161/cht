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
    'anc_danger_sign' AS dataset,
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
    'anc_danger_sign' AS source_form
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
        LOWER(TRIM(is_of_child_bearing_age)) AS is_of_child_bearing_age,
        LOWER(TRIM(needs_signoff)) AS needs_signoff,
        LOWER(TRIM(visited_health_facility)) AS visited_health_facility,
        LOWER(TRIM(still_experiencing_danger_signs)) AS still_experiencing_danger_signs,
        LOWER(TRIM(vaginal_bleeding)) AS vaginal_bleeding,
        LOWER(TRIM(lower_abdomen_pain)) AS lower_abdomen_pain,
        LOWER(TRIM(severe_headache)) AS severe_headache,
        LOWER(TRIM(very_pale)) AS very_pale,
        LOWER(TRIM(fever)) AS fever,
        LOWER(TRIM(reduced_or_no_feotal_movements)) AS reduced_or_no_feotal_movements,
        LOWER(TRIM(blurred_vision)) AS blurred_vision,
        LOWER(TRIM(swelling)) AS swelling,
        LOWER(TRIM(breathlessness)) AS breathlessness,
        LOWER(TRIM(has_danger_signs)) AS has_danger_signs,
        LOWER(TRIM(has_no_danger_signs)) AS has_no_danger_signs,
        LOWER(TRIM(refer_to_health_facility)) AS refer_to_health_facility
    FROM cht.mv_anc_danger_sign
) src
CROSS JOIN LATERAL (
    VALUES
        -- is_of_child_bearing_age (yes/no)
        ('is_of_child_bearing_age - Yes', CASE WHEN src.is_of_child_bearing_age = 'yes' THEN 1 ELSE 0 END),
        ('is_of_child_bearing_age - No', CASE WHEN src.is_of_child_bearing_age = 'no' THEN 1 ELSE 0 END),

        -- needs_signoff (true)
        ('needs_signoff - True', CASE WHEN src.needs_signoff = 'true' THEN 1 ELSE 0 END),

        -- visited_health_facility (yes/no)
        ('visited_health_facility - Yes', CASE WHEN src.visited_health_facility = 'yes' THEN 1 ELSE 0 END),
        ('visited_health_facility - No', CASE WHEN src.visited_health_facility = 'no' THEN 1 ELSE 0 END),

        -- still_experiencing_danger_signs (yes/no)
        ('still_experiencing_danger_signs - Yes', CASE WHEN src.still_experiencing_danger_signs = 'yes' THEN 1 ELSE 0 END),
        ('still_experiencing_danger_signs - No', CASE WHEN src.still_experiencing_danger_signs = 'no' THEN 1 ELSE 0 END),

        -- vaginal_bleeding (yes/no)
        ('vaginal_bleeding - Yes', CASE WHEN src.vaginal_bleeding = 'yes' THEN 1 ELSE 0 END),
        ('vaginal_bleeding - No', CASE WHEN src.vaginal_bleeding = 'no' THEN 1 ELSE 0 END),

        -- lower_abdomen_pain (yes/no)
        ('lower_abdomen_pain - Yes', CASE WHEN src.lower_abdomen_pain = 'yes' THEN 1 ELSE 0 END),
        ('lower_abdomen_pain - No', CASE WHEN src.lower_abdomen_pain = 'no' THEN 1 ELSE 0 END),

        -- severe_headache (yes/no)
        ('severe_headache - Yes', CASE WHEN src.severe_headache = 'yes' THEN 1 ELSE 0 END),
        ('severe_headache - No', CASE WHEN src.severe_headache = 'no' THEN 1 ELSE 0 END),

        -- very_pale (yes/no)
        ('very_pale - Yes', CASE WHEN src.very_pale = 'yes' THEN 1 ELSE 0 END),
        ('very_pale - No', CASE WHEN src.very_pale = 'no' THEN 1 ELSE 0 END),

        -- fever (yes/no)
        ('fever - Yes', CASE WHEN src.fever = 'yes' THEN 1 ELSE 0 END),
        ('fever - No', CASE WHEN src.fever = 'no' THEN 1 ELSE 0 END),

        -- reduced_or_no_feotal_movements (yes/no)
        ('reduced_or_no_feotal_movements - Yes', CASE WHEN src.reduced_or_no_feotal_movements = 'yes' THEN 1 ELSE 0 END),
        ('reduced_or_no_feotal_movements - No', CASE WHEN src.reduced_or_no_feotal_movements = 'no' THEN 1 ELSE 0 END),

        -- blurred_vision (yes/no)
        ('blurred_vision - Yes', CASE WHEN src.blurred_vision = 'yes' THEN 1 ELSE 0 END),
        ('blurred_vision - No', CASE WHEN src.blurred_vision = 'no' THEN 1 ELSE 0 END),

        -- swelling (yes/no)
        ('swelling - Yes', CASE WHEN src.swelling = 'yes' THEN 1 ELSE 0 END),
        ('swelling - No', CASE WHEN src.swelling = 'no' THEN 1 ELSE 0 END),

        -- breathlessness (yes/no)
        ('breathlessness - Yes', CASE WHEN src.breathlessness = 'yes' THEN 1 ELSE 0 END),
        ('breathlessness - No', CASE WHEN src.breathlessness = 'no' THEN 1 ELSE 0 END),

        -- has_danger_signs (yes)
        ('has_danger_signs - Yes', CASE WHEN src.has_danger_signs = 'yes' THEN 1 ELSE 0 END),

        -- has_no_danger_signs (yes)
        ('has_no_danger_signs - Yes', CASE WHEN src.has_no_danger_signs = 'yes' THEN 1 ELSE 0 END),

        -- refer_to_health_facility (yes)
        ('refer_to_health_facility - Yes', CASE WHEN src.refer_to_health_facility = 'yes' THEN 1 ELSE 0 END)
) AS unpivot(data_element, value)
WHERE value = 1;