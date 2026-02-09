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
    'stockout' AS theme,
    'stockout' AS dataset,
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
    'stockout' AS source_form
FROM (
    SELECT
        doc_id,
        date,
        chw_id,
        facility_id,
        district,
        region,

        -- indicator columns (numeric and categorical)
        act_stock_value,
        gloves_stock_value,
        zinc_stock_value,
        amoxicillin_stock_value,
        malaria_rdts_stock_value,
        pop_stock_value,
        dmpa_stock_value,
        misoprostol_stock_value,
        coc_stock_value,
        condoms_stock_value,
        contraceptives_stock_value,
        rectal_stock_value,
        sayana_stock_value,
        LOWER(TRIM(act_low)) AS act_low,
        LOWER(TRIM(amoxicillin_low)) AS amoxicillin_low,
        LOWER(TRIM(zinc_low)) AS zinc_low,
        LOWER(TRIM(condoms_low)) AS condoms_low,
        LOWER(TRIM(rdts_low)) AS rdts_low,
        LOWER(TRIM(coc_low)) AS coc_low,
        LOWER(TRIM(pop_low)) AS pop_low,
        LOWER(TRIM(contraceptives_low)) AS contraceptives_low,
        LOWER(TRIM(dmpa_low)) AS dmpa_low,
        LOWER(TRIM(rectal_low)) AS rectal_low,
        LOWER(TRIM(gloves_low)) AS gloves_low,
        LOWER(TRIM(action_taken)) AS action_taken
    FROM cht.mv_stockout
) src
CROSS JOIN LATERAL (
    VALUES
        -- act_stock_value (int) - numeric, null to 0
        ('act_stock_value', COALESCE(src.act_stock_value, 0)),

        -- gloves_stock_value (int) - numeric, null to 0
        ('gloves_stock_value', COALESCE(src.gloves_stock_value, 0)),

        -- zinc_stock_value (int) - numeric, null to 0
        ('zinc_stock_value', COALESCE(src.zinc_stock_value, 0)),

        -- amoxicillin_stock_value (int) - numeric, null to 0
        ('amoxicillin_stock_value', COALESCE(src.amoxicillin_stock_value, 0)),

        -- malaria_rdts_stock_value (int) - numeric, null to 0
        ('malaria_rdts_stock_value', COALESCE(src.malaria_rdts_stock_value, 0)),

        -- pop_stock_value (int) - numeric, null to 0
        ('pop_stock_value', COALESCE(src.pop_stock_value, 0)),

        -- dmpa_stock_value (int) - numeric, null to 0
        ('dmpa_stock_value', COALESCE(src.dmpa_stock_value, 0)),

        -- misoprostol_stock_value (int) - numeric, null to 0
        ('misoprostol_stock_value', COALESCE(src.misoprostol_stock_value, 0)),

        -- coc_stock_value (int) - numeric, null to 0
        ('coc_stock_value', COALESCE(src.coc_stock_value, 0)),

        -- condoms_stock_value (int) - numeric, null to 0
        ('condoms_stock_value', COALESCE(src.condoms_stock_value, 0)),

        -- contraceptives_stock_value (int) - numeric, null to 0
        ('contraceptives_stock_value', COALESCE(src.contraceptives_stock_value, 0)),

        -- rectal_stock_value (int) - numeric, null to 0
        ('rectal_stock_value', COALESCE(src.rectal_stock_value, 0)),

        -- sayana_stock_value (int) - numeric, null to 0
        ('sayana_stock_value', COALESCE(src.sayana_stock_value, 0)),

        -- act_low (yes/no) - binary
        ('act_low - Yes', CASE WHEN src.act_low = 'yes' THEN 1 ELSE 0 END),
        ('act_low - No', CASE WHEN src.act_low = 'no' THEN 1 ELSE 0 END),

        -- amoxicillin_low (yes/no) - binary
        ('amoxicillin_low - Yes', CASE WHEN src.amoxicillin_low = 'yes' THEN 1 ELSE 0 END),
        ('amoxicillin_low - No', CASE WHEN src.amoxicillin_low = 'no' THEN 1 ELSE 0 END),

        -- zinc_low (yes/no) - binary
        ('zinc_low - Yes', CASE WHEN src.zinc_low = 'yes' THEN 1 ELSE 0 END),
        ('zinc_low - No', CASE WHEN src.zinc_low = 'no' THEN 1 ELSE 0 END),

        -- condoms_low (yes/no) - binary
        ('condoms_low - Yes', CASE WHEN src.condoms_low = 'yes' THEN 1 ELSE 0 END),
        ('condoms_low - No', CASE WHEN src.condoms_low = 'no' THEN 1 ELSE 0 END),

        -- rdts_low (yes/no) - binary
        ('rdts_low - Yes', CASE WHEN src.rdts_low = 'yes' THEN 1 ELSE 0 END),
        ('rdts_low - No', CASE WHEN src.rdts_low = 'no' THEN 1 ELSE 0 END),

        -- coc_low (yes/no) - binary
        ('coc_low - Yes', CASE WHEN src.coc_low = 'yes' THEN 1 ELSE 0 END),
        ('coc_low - No', CASE WHEN src.coc_low = 'no' THEN 1 ELSE 0 END),

        -- pop_low (yes/no) - binary
        ('pop_low - Yes', CASE WHEN src.pop_low = 'yes' THEN 1 ELSE 0 END),
        ('pop_low - No', CASE WHEN src.pop_low = 'no' THEN 1 ELSE 0 END),

        -- contraceptives_low (yes/no) - binary
        ('contraceptives_low - Yes', CASE WHEN src.contraceptives_low = 'yes' THEN 1 ELSE 0 END),
        ('contraceptives_low - No', CASE WHEN src.contraceptives_low = 'no' THEN 1 ELSE 0 END),

        -- dmpa_low (yes/no) - binary
        ('dmpa_low - Yes', CASE WHEN src.dmpa_low = 'yes' THEN 1 ELSE 0 END),
        ('dmpa_low - No', CASE WHEN src.dmpa_low = 'no' THEN 1 ELSE 0 END),

        -- rectal_low (yes/no) - binary
        ('rectal_low - Yes', CASE WHEN src.rectal_low = 'yes' THEN 1 ELSE 0 END),
        ('rectal_low - No', CASE WHEN src.rectal_low = 'no' THEN 1 ELSE 0 END),

        -- gloves_low (yes/no) - binary
        ('gloves_low - Yes', CASE WHEN src.gloves_low = 'yes' THEN 1 ELSE 0 END),
        ('gloves_low - No', CASE WHEN src.gloves_low = 'no' THEN 1 ELSE 0 END),

        -- action_taken (to_vht/no_stock/shared_to_vht/others) - binary
        ('action_taken - To_vht', CASE WHEN src.action_taken LIKE '%to_vht%' THEN 1 ELSE 0 END),
        ('action_taken - No_stock', CASE WHEN src.action_taken LIKE '%no_stock%' THEN 1 ELSE 0 END),
        ('action_taken - Shared_to_vht', CASE WHEN src.action_taken LIKE '%shared_to_vht%' THEN 1 ELSE 0 END),
        ('action_taken - Others', CASE WHEN src.action_taken LIKE '%others%' THEN 1 ELSE 0 END)
) AS unpivot(data_element, value)
WHERE value IS NOT NULL;