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
    'ICCM' AS theme,
    'child_health_notification' AS dataset,
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
    'child_health_notification' AS source_form
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
        LOWER(TRIM(client_condition)) AS client_condition,
        LOWER(TRIM(taken_to_facility)) AS taken_to_facility,
        LOWER(TRIM(confirm_refer_to_facility)) AS confirm_refer_to_facility,
        LOWER(TRIM(select_health_condition)) AS select_health_condition
    FROM cht.mv_child_health_notification
) src
CROSS JOIN LATERAL (
    VALUES
        -- client_condition (getting_better/getting_worse/no_change)
        ('client_condition - Getting_better', CASE WHEN src.client_condition LIKE '%getting_better%' THEN 1 ELSE 0 END),
        ('client_condition - Getting_worse', CASE WHEN src.client_condition LIKE '%getting_worse%' THEN 1 ELSE 0 END),
        ('client_condition - No_change', CASE WHEN src.client_condition LIKE '%no_change%' THEN 1 ELSE 0 END),

        -- taken_to_facility (yes/no)
        ('taken_to_facility - Yes', CASE WHEN src.taken_to_facility = 'yes' THEN 1 ELSE 0 END),
        ('taken_to_facility - No', CASE WHEN src.taken_to_facility = 'no' THEN 1 ELSE 0 END),

        -- confirm_refer_to_facility (yes)
        ('confirm_refer_to_facility - Yes', CASE WHEN src.confirm_refer_to_facility = 'yes' THEN 1 ELSE 0 END),

        -- select_health_condition (proper_care_of_new_born/ensure_cleanliness/how_to_keep_new_born/new_born_babys_eyes/danger_signs_in_newborns/importance_of_breastfeeding/immunization_definition/immunization_schedule)
        ('select_health_condition - Proper_care_of_new_born', CASE WHEN src.select_health_condition LIKE '%proper_care_of_new_born%' THEN 1 ELSE 0 END),
        ('select_health_condition - Ensure_cleanliness', CASE WHEN src.select_health_condition LIKE '%ensure_cleanliness%' THEN 1 ELSE 0 END),
        ('select_health_condition - How_to_keep_new_born', CASE WHEN src.select_health_condition LIKE '%how_to_keep_new_born%' THEN 1 ELSE 0 END),
        ('select_health_condition - New_born_babys_eyes', CASE WHEN src.select_health_condition LIKE '%new_born_babys_eyes%' THEN 1 ELSE 0 END),
        ('select_health_condition - Danger_signs_in_newborns', CASE WHEN src.select_health_condition LIKE '%danger_signs_in_newborns%' THEN 1 ELSE 0 END),
        ('select_health_condition - Importance_of_breastfeeding', CASE WHEN src.select_health_condition LIKE '%importance_of_breastfeeding%' THEN 1 ELSE 0 END),
        ('select_health_condition - Immunization_definition', CASE WHEN src.select_health_condition LIKE '%immunization_definition%' THEN 1 ELSE 0 END),
        ('select_health_condition - Immunization_schedule', CASE WHEN src.select_health_condition LIKE '%immunization_schedule%' THEN 1 ELSE 0 END)
) AS unpivot(data_element, value)
WHERE value = 1;