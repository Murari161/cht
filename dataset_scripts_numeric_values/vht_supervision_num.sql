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
    'supervision' AS theme,
    'vht_supervision' AS dataset,
    unpivot.data_element,
    unpivot.value,
    date,
    chw_id,
    NULL AS facility_id,
    district_id AS district_id,
    region_id AS region,
    NULL AS patient_age_in_years,
    NULL AS patient_age_in_months,
    NULL AS patient_age_in_days,
    NULL AS patient_sex,
    NULL AS patient_dob,
    'cht' AS source_system,
    'vht_supervision' AS source_form
FROM (
    SELECT
        uuid,
        date,
        chw_id,
        district_id,
        region_id,

        -- indicator columns
        LOWER(TRIM(vht_supervised)) AS vht_supervised,
        LOWER(TRIM(vht_supervision_status)) AS vht_supervision_status
    FROM cht.mv_vht_supervision
) src
CROSS JOIN LATERAL (
    VALUES
        -- vht_supervised (yes/no) - binary
        ('vht_supervised - Yes', CASE WHEN src.vht_supervised = 'yes' THEN 1 ELSE 0 END),
        ('vht_supervised - No', CASE WHEN src.vht_supervised = 'no' THEN 1 ELSE 0 END),

        -- vht_supervision_status (yes/no) - binary
        ('vht_supervision_status - Yes', CASE WHEN src.vht_supervision_status = 'yes' THEN 1 ELSE 0 END),
        ('vht_supervision_status - No', CASE WHEN src.vht_supervision_status = 'no' THEN 1 ELSE 0 END)
) AS unpivot(data_element, value)
WHERE value = 1;