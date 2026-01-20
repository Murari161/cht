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
    'fp_follow_up' AS dataset,
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
    'fp_follow_up' AS source_form
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
        LOWER(TRIM(on_fp)) AS on_fp,
        LOWER(TRIM(not_on_fp_reason)) AS not_on_fp_reason,
        LOWER(TRIM(referred_patient_not_on_fp)) AS referred_patient_not_on_fp,
        LOWER(TRIM(continue_current_fp_method)) AS continue_current_fp_method,
        LOWER(TRIM(can_supply_fp_commodities)) AS can_supply_fp_commodities,
        LOWER(TRIM(referred_patient_change_fp)) AS referred_patient_change_fp,
        coc_given,
        condoms_given,
        pop_given,
        dmpa_given,
        contraceptives_given,
        commodities_supplied_qty
    FROM cht.mv_fp_follow_up
) src
CROSS JOIN LATERAL (
    VALUES
        -- on_fp (yes/no) - binary
        ('on_fp - Yes', CASE WHEN src.on_fp = 'yes' THEN 1 ELSE 0 END),
        ('on_fp - No', CASE WHEN src.on_fp = 'no' THEN 1 ELSE 0 END),

        -- not_on_fp_reason (wants_baby/wants_change_fp/is_pregnant/side_effects/spouse_refused/other) - binary
        ('not_on_fp_reason - Wants_baby', CASE WHEN src.not_on_fp_reason LIKE '%wants_baby%' THEN 1 ELSE 0 END),
        ('not_on_fp_reason - Wants_change_fp', CASE WHEN src.not_on_fp_reason LIKE '%wants_change_fp%' THEN 1 ELSE 0 END),
        ('not_on_fp_reason - Is_pregnant', CASE WHEN src.not_on_fp_reason LIKE '%is_pregnant%' THEN 1 ELSE 0 END),
        ('not_on_fp_reason - Side_effects', CASE WHEN src.not_on_fp_reason LIKE '%side_effects%' THEN 1 ELSE 0 END),
        ('not_on_fp_reason - Spouse_refused', CASE WHEN src.not_on_fp_reason LIKE '%spouse_refused%' THEN 1 ELSE 0 END),
        ('not_on_fp_reason - Other', CASE WHEN src.not_on_fp_reason LIKE '%other%' THEN 1 ELSE 0 END),

        -- referred_patient_not_on_fp (yes) - binary
        ('referred_patient_not_on_fp - Yes', CASE WHEN src.referred_patient_not_on_fp = 'yes' THEN 1 ELSE 0 END),

        -- continue_current_fp_method (yes/no) - binary
        ('continue_current_fp_method - Yes', CASE WHEN src.continue_current_fp_method = 'yes' THEN 1 ELSE 0 END),
        ('continue_current_fp_method - No', CASE WHEN src.continue_current_fp_method = 'no' THEN 1 ELSE 0 END),

        -- can_supply_fp_commodities (yes/no) - binary
        ('can_supply_fp_commodities - Yes', CASE WHEN src.can_supply_fp_commodities = 'yes' THEN 1 ELSE 0 END),
        ('can_supply_fp_commodities - No', CASE WHEN src.can_supply_fp_commodities = 'no' THEN 1 ELSE 0 END),

        -- referred_patient_change_fp (yes/no) - binary
        ('referred_patient_change_fp - Yes', CASE WHEN src.referred_patient_change_fp = 'yes' THEN 1 ELSE 0 END),
        ('referred_patient_change_fp - No', CASE WHEN src.referred_patient_change_fp = 'no' THEN 1 ELSE 0 END),

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

        -- commodities_supplied_qty (int) - numeric, null to 0
        ('commodities_supplied_qty', COALESCE(src.commodities_supplied_qty, 0))
) AS unpivot(data_element, value)
WHERE value IS NOT NULL;