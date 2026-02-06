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
    'unmute' AS theme,
    'unmute' AS dataset,
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
    'unmute' AS source_form
FROM (
    SELECT
        uuid,
        date,
        chw_id,
        contact_facility_id,
        district_id,
        region_id,

        -- indicator columns
        LOWER(TRIM(g_unmute_reason)) AS g_unmute_reason
    FROM cht.mv_unmute
) src
CROSS JOIN LATERAL (
    VALUES
        -- g_unmute_reason (requested_services/moved_back/other) - binary
        ('g_unmute_reason - Requested_services', CASE WHEN src.g_unmute_reason LIKE '%requested_services%' THEN 1 ELSE 0 END),
        ('g_unmute_reason - Moved_back', CASE WHEN src.g_unmute_reason LIKE '%moved_back%' THEN 1 ELSE 0 END),
        ('g_unmute_reason - Other', CASE WHEN src.g_unmute_reason LIKE '%other%' THEN 1 ELSE 0 END)
) AS unpivot(data_element, value)
WHERE value = 1;