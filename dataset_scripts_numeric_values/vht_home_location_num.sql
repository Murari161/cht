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
    'household' AS theme,
    'vht_home_location' AS dataset,
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
    'vht_home_location' AS source_form
FROM (
    SELECT
        uuid,
        date,
        chw_id,
        contact_facility_id,
        district_id,
        region_id,

        -- indicator columns
        LOWER(TRIM(geolocation_want_to_capture_gps)) AS geolocation_want_to_capture_gps,
        LOWER(TRIM(geolocation_ensure_gps)) AS geolocation_ensure_gps
    FROM cht.mv_vht_home_location
) src
CROSS JOIN LATERAL (
    VALUES
        -- geolocation_want_to_capture_gps (yes/no) - binary
        ('geolocation_want_to_capture_gps - Yes', CASE WHEN src.geolocation_want_to_capture_gps = 'yes' THEN 1 ELSE 0 END),
        ('geolocation_want_to_capture_gps - No', CASE WHEN src.geolocation_want_to_capture_gps = 'no' THEN 1 ELSE 0 END),

        -- geolocation_ensure_gps (gps_enabled/clear_sky/at_hh) - binary
        ('geolocation_ensure_gps - Gps_enabled', CASE WHEN src.geolocation_ensure_gps LIKE '%gps_enabled%' THEN 1 ELSE 0 END),
        ('geolocation_ensure_gps - Clear_sky', CASE WHEN src.geolocation_ensure_gps LIKE '%clear_sky%' THEN 1 ELSE 0 END),
        ('geolocation_ensure_gps - At_hh', CASE WHEN src.geolocation_ensure_gps LIKE '%at_hh%' THEN 1 ELSE 0 END)
) AS unpivot(data_element, value)
WHERE value = 1;