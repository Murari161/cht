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
    'mute' AS theme,
    'mute' AS dataset,
    unpivot.data_element,
    unpivot.value,
    date,
    chw_id,
    contact_facility_id AS facility_id,
    district_id AS district_id,
    region_id AS region,
    NULL AS patient_age_in_years,
    NULL AS patient_age_in_months,
    NULL AS patient_age_in_days,
    NULL AS patient_sex,
    NULL AS patient_dob,
    'cht' AS source_system,
    'mute' AS source_form
FROM (
    SELECT
        uuid,
        date,
        chw_id,
        contact_facility_id,
        district_id,
        region_id,

        -- indicator columns
        LOWER(TRIM(g_mute_reason)) AS g_mute_reason
    FROM cht.mv_mute
) src
CROSS JOIN LATERAL (
    VALUES
        -- g_mute_reason (refused_services/temp_relocation/perm_relocation/other) - binary
        ('g_mute_reason - Refused_services', CASE WHEN src.g_mute_reason LIKE '%refused_services%' THEN 1 ELSE 0 END),
        ('g_mute_reason - Temp_relocation', CASE WHEN src.g_mute_reason LIKE '%temp_relocation%' THEN 1 ELSE 0 END),
        ('g_mute_reason - Perm_relocation', CASE WHEN src.g_mute_reason LIKE '%perm_relocation%' THEN 1 ELSE 0 END),
        ('g_mute_reason - Other', CASE WHEN src.g_mute_reason LIKE '%other%' THEN 1 ELSE 0 END)
) AS unpivot(data_element, value)
WHERE value = 1;