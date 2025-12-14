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
    'uncompleted_referral' AS dataset,
    unpivot.data_element,
    unpivot.value,
    date,
    chw_id,
    facility_id,
    district AS district_id,
    region,
    NULL AS patient_age_in_years,
    NULL AS patient_age_in_months,
    NULL AS patient_age_in_days,
    contact_sex AS patient_sex,
    contact_date_of_birth AS patient_dob,
    'cht' AS source_system,
    'uncompleted_referral' AS source_form
FROM (
    SELECT
        doc_id,
        date,
        chw_id,
        facility_id,
        district,
        region,
        contact_sex,
        contact_date_of_birth,

        -- indicator columns from MV
        tb_result,
        place_name,
        needs_signoff,
        generated_note_name_25,
        referred_to_health_facility
    FROM cht.mv_uncompleted_referral
) src
CROSS JOIN LATERAL (
    VALUES
        ('tb_result', src.tb_result),
        ('place_name', src.place_name),
        ('needs_signoff', src.needs_signoff),
        ('generated_note_name_25', src.generated_note_name_25),
        ('referred_to_health_facility', src.referred_to_health_facility)
) AS unpivot(data_element, value)
WHERE unpivot.value IS NOT NULL
  AND TRIM(unpivot.value) <> '';