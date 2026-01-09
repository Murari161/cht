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
    doc_id AS uuid,
    'delivery_check' AS dataset,
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
    'delivery_check' AS source_form
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

        -- indicator columns from MV
        is_of_child_bearing_age,
        has_delivered,
        note_complete_delivery_form
    FROM cht.mv_delivery_check
) src
CROSS JOIN LATERAL (
    VALUES
        ('is_of_child_bearing_age', src.is_of_child_bearing_age),
        ('has_delivered', src.has_delivered),
        ('note_complete_delivery_form', src.note_complete_delivery_form)
) AS unpivot(data_element, value)
WHERE unpivot.value IS NOT NULL
  AND TRIM(unpivot.value) <> '';