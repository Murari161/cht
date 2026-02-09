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
    'tb' AS theme,
    'tb_uncompleted_referral' AS dataset,
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
    NULL AS patient_sex,
    NULL AS patient_dob,
    'cht' AS source_system,
    'tb_uncompleted_referral' AS source_form
FROM (
    SELECT
        doc_id,
        date,
        chw_id,
        facility_id,
        district,
        region,

        -- indicator columns
        LOWER(TRIM(needs_signoff)) AS needs_signoff,
        LOWER(TRIM(tb_result)) AS tb_result,
        LOWER(TRIM(referred_to_health_facility)) AS referred_to_health_facility
    FROM cht.mv_tb_uncompleted_referral
) src
CROSS JOIN LATERAL (
    VALUES
        -- needs_signoff (true) - binary
        ('needs_signoff - True', CASE WHEN src.needs_signoff = 'true' THEN 1 ELSE 0 END),

        -- tb_result (Positive TB Results/Negative TB Results/Invalid TB Results) - binary
        ('tb_result - Positive TB Results', CASE WHEN src.tb_result LIKE '%positive tb results%' THEN 1 ELSE 0 END),
        ('tb_result - Negative TB Results', CASE WHEN src.tb_result LIKE '%negative tb results%' THEN 1 ELSE 0 END),
        ('tb_result - Invalid TB Results', CASE WHEN src.tb_result LIKE '%invalid tb results%' THEN 1 ELSE 0 END),

        -- referred_to_health_facility (yes) - binary
        ('referred_to_health_facility - Yes', CASE WHEN src.referred_to_health_facility = 'yes' THEN 1 ELSE 0 END)
) AS unpivot(data_element, value)
WHERE value = 1;