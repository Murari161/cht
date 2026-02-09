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
    'stock' AS theme,
    'stock_count' AS dataset,
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
    'stock_count' AS source_form
FROM (
    SELECT
        doc_id,
        date,
        chw_id,
        facility_id,
        district,
        region,

        -- indicator columns (all numeric)
        act_item_received,
        zinc_item_received,
        amoxicillin_item_received,
        malaria_rdts_item_received,
        pop_item_received,
        dmpa_item_received,
        misoprostol_item_received,
        coc_item_received,
        condoms_item_received,
        contraceptives_item_received,
        rectal_item_received,
        sayana_item_received,
        gloves_item_received,
        act,
        malaria_rdts,
        rectal,
        gloves,
        zinc,
        amoxicillin,
        pop,
        coc,
        contraceptives,
        dmpa,
        condoms
    FROM cht.mv_stock_count
) src
CROSS JOIN LATERAL (
    VALUES
        -- act_item_received (int) - numeric, null to 0
        ('act_item_received', COALESCE(src.act_item_received, 0)),

        -- zinc_item_received (int) - numeric, null to 0
        ('zinc_item_received', COALESCE(src.zinc_item_received, 0)),

        -- amoxicillin_item_received (int) - numeric, null to 0
        ('amoxicillin_item_received', COALESCE(src.amoxicillin_item_received, 0)),

        -- malaria_rdts_item_received (int) - numeric, null to 0
        ('malaria_rdts_item_received', COALESCE(src.malaria_rdts_item_received, 0)),

        -- pop_item_received (int) - numeric, null to 0
        ('pop_item_received', COALESCE(src.pop_item_received, 0)),

        -- dmpa_item_received (int) - numeric, null to 0
        ('dmpa_item_received', COALESCE(src.dmpa_item_received, 0)),

        -- misoprostol_item_received (int) - numeric, null to 0
        ('misoprostol_item_received', COALESCE(src.misoprostol_item_received, 0)),

        -- coc_item_received (int) - numeric, null to 0
        ('coc_item_received', COALESCE(src.coc_item_received, 0)),

        -- condoms_item_received (int) - numeric, null to 0
        ('condoms_item_received', COALESCE(src.condoms_item_received, 0)),

        -- contraceptives_item_received (int) - numeric, null to 0
        ('contraceptives_item_received', COALESCE(src.contraceptives_item_received, 0)),

        -- rectal_item_received (int) - numeric, null to 0
        ('rectal_item_received', COALESCE(src.rectal_item_received, 0)),

        -- sayana_item_received (int) - numeric, null to 0
        ('sayana_item_received', COALESCE(src.sayana_item_received, 0)),

        -- gloves_item_received (int) - numeric, null to 0
        ('gloves_item_received', COALESCE(src.gloves_item_received, 0)),

        -- act (int) - numeric, null to 0
        ('act', COALESCE(src.act, 0)),

        -- malaria_rdts (int) - numeric, null to 0
        ('malaria_rdts', COALESCE(src.malaria_rdts, 0)),

        -- rectal (int) - numeric, null to 0
        ('rectal', COALESCE(src.rectal, 0)),

        -- gloves (int) - numeric, null to 0
        ('gloves', COALESCE(src.gloves, 0)),

        -- zinc (int) - numeric, null to 0
        ('zinc', COALESCE(src.zinc, 0)),

        -- amoxicillin (int) - numeric, null to 0
        ('amoxicillin', COALESCE(src.amoxicillin, 0)),

        -- pop (int) - numeric, null to 0
        ('pop', COALESCE(src.pop, 0)),

        -- coc (int) - numeric, null to 0
        ('coc', COALESCE(src.coc, 0)),

        -- contraceptives (int) - numeric, null to 0
        ('contraceptives', COALESCE(src.contraceptives, 0)),

        -- dmpa (int) - numeric, null to 0
        ('dmpa', COALESCE(src.dmpa, 0)),

        -- condoms (int) - numeric, null to 0
        ('condoms', COALESCE(src.condoms, 0))
) AS unpivot(data_element, value)
WHERE value IS NOT NULL;