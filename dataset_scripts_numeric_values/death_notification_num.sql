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
    'death' AS theme,
    'death_notification' AS dataset,
    unpivot.data_element,
    unpivot.value,
    date,
    chw_id,
    contact_facility_id AS facility_id,
    district_id AS district_id,
    region_id AS region,
    inputs_t_client_age AS patient_age_in_years,
    NULL AS patient_age_in_months,
    NULL AS patient_age_in_days,
    inputs_t_client_sex AS patient_sex,
    inputs_t_client_birth_date AS patient_dob,
    'cht' AS source_system,
    'death_notification' AS source_form
FROM (
    SELECT
        uuid,
        date,
        chw_id,
        contact_facility_id,
        district_id,
        region_id,
        inputs_t_client_age,
        inputs_t_client_sex,
        inputs_t_client_birth_date,

        -- indicator columns
        LOWER(TRIM(needs_signoff)) AS needs_signoff,
        LOWER(TRIM(notification_details_verification_status)) AS notification_details_verification_status,
        LOWER(TRIM(notification_details_actions)) AS notification_details_actions
    FROM cht.mv_death_notification
) src
CROSS JOIN LATERAL (
    VALUES
        -- needs_signoff (true) - binary
        ('needs_signoff - True', CASE WHEN src.needs_signoff = 'true' THEN 1 ELSE 0 END),

        -- notification_details_verification_status (not_available/verified/not_verified) - binary
        ('notification_details_verification_status - Not_available', CASE WHEN src.notification_details_verification_status LIKE '%not_available%' THEN 1 ELSE 0 END),
        ('notification_details_verification_status - Verified', CASE WHEN src.notification_details_verification_status LIKE '%verified%' THEN 1 ELSE 0 END),
        ('notification_details_verification_status - Not_verified', CASE WHEN src.notification_details_verification_status LIKE '%not_verified%' THEN 1 ELSE 0 END),

        -- notification_details_actions (notified_relevant/verbal_autopsy/others) - binary
        ('notification_details_actions - Notified_relevant', CASE WHEN src.notification_details_actions LIKE '%notified_relevant%' THEN 1 ELSE 0 END),
        ('notification_details_actions - Verbal_autopsy', CASE WHEN src.notification_details_actions LIKE '%verbal_autopsy%' THEN 1 ELSE 0 END),
        ('notification_details_actions - Others', CASE WHEN src.notification_details_actions LIKE '%others%' THEN 1 ELSE 0 END)
) AS unpivot(data_element, value)
WHERE value = 1;