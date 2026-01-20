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
    'family_planning' AS theme,
    'fp_registration' AS dataset,
    unpivot.data_element,
    unpivot.value,
    date,
    chw_id,
    contact_facility_id AS facility_id,
    district_id AS district_id,
    region_id AS region,
    patient_age_in_years,
    NULL AS patient_age_in_months,
    NULL AS patient_age_in_days,
    inputs_contact_sex AS patient_sex,
    inputs_contact_date_of_birth AS patient_dob,
    'cht' AS source_system,
    'fp_registration' AS source_form
FROM (
    SELECT
        uuid,
        date,
        chw_id,
        contact_facility_id,
        district_id,
        region_id,
        patient_age_in_years,
        inputs_contact_sex,
        inputs_contact_date_of_birth,

        -- indicator columns (categorical and numeric)
        LOWER(TRIM(fp_method)) AS fp_method,
        LOWER(TRIM(who_administered_dmpa)) AS who_administered_dmpa,
        LOWER(TRIM(enrol_on_fp_method)) AS enrol_on_fp_method,
        LOWER(TRIM(continue_current_fp_method)) AS continue_current_fp_method,
        LOWER(TRIM(patient_referred)) AS patient_referred,
        LOWER(TRIM(can_supply_fp_commodities)) AS can_supply_fp_commodities,
        coc_given,
        condoms_given,
        pop_given,
        dmpa_given,
        contraceptives_given,
        condoms_received,
        supply_limit,
        commodities_supplied_qty
    FROM cht.mv_fp_registration
) src
CROSS JOIN LATERAL (
    VALUES
        -- fp_method (combined_oral_contraceptives/progestreone_only_pills/dmpa/implant/iud/condoms/contraceptives/tubal_ligation/none) - binary
        ('fp_method - Combined_oral_contraceptives', CASE WHEN src.fp_method LIKE '%combined_oral_contraceptives%' THEN 1 ELSE 0 END),
        ('fp_method - Progestreone_only_pills', CASE WHEN src.fp_method LIKE '%progestreone_only_pills%' THEN 1 ELSE 0 END),
        ('fp_method - Dmpa', CASE WHEN src.fp_method LIKE '%dmpa%' THEN 1 ELSE 0 END),
        ('fp_method - Implant', CASE WHEN src.fp_method LIKE '%implant%' THEN 1 ELSE 0 END),
        ('fp_method - Iud', CASE WHEN src.fp_method LIKE '%iud%' THEN 1 ELSE 0 END),
        ('fp_method - Condoms', CASE WHEN src.fp_method LIKE '%condoms%' THEN 1 ELSE 0 END),
        ('fp_method - Contraceptives', CASE WHEN src.fp_method LIKE '%contraceptives%' THEN 1 ELSE 0 END),
        ('fp_method - Tubal_ligation', CASE WHEN src.fp_method LIKE '%tubal_ligation%' THEN 1 ELSE 0 END),
        ('fp_method - None', CASE WHEN src.fp_method LIKE '%none%' THEN 1 ELSE 0 END),

        -- who_administered_dmpa (provider_administered/self_injected) - binary
        ('who_administered_dmpa - Provider_administered', CASE WHEN src.who_administered_dmpa LIKE '%provider_administered%' THEN 1 ELSE 0 END),
        ('who_administered_dmpa - Self_injected', CASE WHEN src.who_administered_dmpa LIKE '%self_injected%' THEN 1 ELSE 0 END),

        -- enrol_on_fp_method (yes/no) - binary
        ('enrol_on_fp_method - Yes', CASE WHEN src.enrol_on_fp_method = 'yes' THEN 1 ELSE 0 END),
        ('enrol_on_fp_method - No', CASE WHEN src.enrol_on_fp_method = 'no' THEN 1 ELSE 0 END),

        -- continue_current_fp_method (yes/no) - binary
        ('continue_current_fp_method - Yes', CASE WHEN src.continue_current_fp_method = 'yes' THEN 1 ELSE 0 END),
        ('continue_current_fp_method - No', CASE WHEN src.continue_current_fp_method = 'no' THEN 1 ELSE 0 END),

        -- patient_referred (yes/no) - binary
        ('patient_referred - Yes', CASE WHEN src.patient_referred = 'yes' THEN 1 ELSE 0 END),
        ('patient_referred - No', CASE WHEN src.patient_referred = 'no' THEN 1 ELSE 0 END),

        -- can_supply_fp_commodities (yes/no) - binary
        ('can_supply_fp_commodities - Yes', CASE WHEN src.can_supply_fp_commodities = 'yes' THEN 1 ELSE 0 END),
        ('can_supply_fp_commodities - No', CASE WHEN src.can_supply_fp_commodities = 'no' THEN 1 ELSE 0 END),

        -- coc_given (int) - numeric, null to 0
        ('coc_given', COALESCE(src.coc_given, 0)),

        -- condoms_given (int) - numeric, null to 0
        ('condoms_given', COALESCE(src.condoms_given, 0)),

        -- pop_given (int) - numeric, null to 0
        ('pop_given', COALESCE(src.pop_given, 0)),

        -- dmpa_given (int) - numeric, null to 0
        ('dmpa_given', COALESCE(src.dmpa_given, 0)),

        -- contraceptives_given (int) - numeric, null to 0
        ('contraceptives_given', COALESCE(src.contraceptives_given, 0)),

        -- condoms_received (int) - numeric, null to 0
        ('condoms_received', COALESCE(src.condoms_received, 0)),

        -- supply_limit (int) - numeric, null to 0
        ('supply_limit', COALESCE(src.supply_limit, 0)),

        -- commodities_supplied_qty (int) - numeric, null to 0
        ('commodities_supplied_qty', COALESCE(src.commodities_supplied_qty, 0))
) AS unpivot(data_element, value)
WHERE value IS NOT NULL;