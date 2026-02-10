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
    'stock' AS theme,
    'vht_consumption_log' AS dataset,
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
    'vht_consumption_log' AS source_form
FROM (
    SELECT
        uuid,
        date,
        chw_id,
        contact_facility_id,
        district_id,
        region_id,

        -- indicator columns (all numeric)
        act_item_received,
        act_item_returned,
        zinc_item_received,
        zinc_item_returned,
        amoxicillin_item_received,
        amoxicillin_item_returned,
        malaria_rdts_item_received,
        malaria_rdts_item_returned,
        pop_item_received,
        pop_item_returned,
        dmpa_item_received,
        dmpa_item_returned,
        misoprostol_item_received,
        misoprostol_item_returned,
        coc_item_received,
        coc_item_returned,
        condoms_item_received,
        condoms_item_returned,
        contraceptives_item_received,
        contraceptives_item_returned,
        rectal_item_received,
        rectal_item_returned,
        sayana_item_received,
        sayana_item_returned,
        gloves_item_received,
        gloves_item_returned,
        items_received_act,
        items_received_malaria_rdts,
        items_received_rectal,
        items_received_gloves,
        items_received_zinc,
        items_received_amoxicillin,
        items_received_pop,
        items_received_coc,
        items_received_contraceptives,
        items_received_dmpa,
        items_received_condoms,
        items_returned_act_r,
        items_returned_malaria_rdts_r,
        items_returned_rectal_r,
        items_returned_gloves_r,
        items_returned_zinc_r,
        items_returned_amoxicillin_r,
        items_returned_pop_r,
        items_returned_coc_r,
        items_returned_contraceptives_r,
        items_returned_dmpa_r,
        items_returned_condoms_r
    FROM cht.mv_vht_consumption_log
) src
CROSS JOIN LATERAL (
    VALUES
        -- act_item_received (int) - numeric, null to 0
        ('act_item_received', COALESCE(src.act_item_received, 0)),

        -- act_item_returned (int) - numeric, null to 0
        ('act_item_returned', COALESCE(src.act_item_returned, 0)),

        -- zinc_item_received (int) - numeric, null to 0
        ('zinc_item_received', COALESCE(src.zinc_item_received, 0)),

        -- zinc_item_returned (int) - numeric, null to 0
        ('zinc_item_returned', COALESCE(src.zinc_item_returned, 0)),

        -- amoxicillin_item_received (int) - numeric, null to 0
        ('amoxicillin_item_received', COALESCE(src.amoxicillin_item_received, 0)),

        -- amoxicillin_item_returned (int) - numeric, null to 0
        ('amoxicillin_item_returned', COALESCE(src.amoxicillin_item_returned, 0)),

        -- malaria_rdts_item_received (int) - numeric, null to 0
        ('malaria_rdts_item_received', COALESCE(src.malaria_rdts_item_received, 0)),

        -- malaria_rdts_item_returned (int) - numeric, null to 0
        ('malaria_rdts_item_returned', COALESCE(src.malaria_rdts_item_returned, 0)),

        -- pop_item_received (int) - numeric, null to 0
        ('pop_item_received', COALESCE(src.pop_item_received, 0)),

        -- pop_item_returned (int) - numeric, null to 0
        ('pop_item_returned', COALESCE(src.pop_item_returned, 0)),

        -- dmpa_item_received (int) - numeric, null to 0
        ('dmpa_item_received', COALESCE(src.dmpa_item_received, 0)),

        -- dmpa_item_returned (int) - numeric, null to 0
        ('dmpa_item_returned', COALESCE(src.dmpa_item_returned, 0)),

        -- misoprostol_item_received (int) - numeric, null to 0
        ('misoprostol_item_received', COALESCE(src.misoprostol_item_received, 0)),

        -- misoprostol_item_returned (int) - numeric, null to 0
        ('misoprostol_item_returned', COALESCE(src.misoprostol_item_returned, 0)),

        -- coc_item_received (int) - numeric, null to 0
        ('coc_item_received', COALESCE(src.coc_item_received, 0)),

        -- coc_item_returned (int) - numeric, null to 0
        ('coc_item_returned', COALESCE(src.coc_item_returned, 0)),

        -- condoms_item_received (int) - numeric, null to 0
        ('condoms_item_received', COALESCE(src.condoms_item_received, 0)),

        -- condoms_item_returned (int) - numeric, null to 0
        ('condoms_item_returned', COALESCE(src.condoms_item_returned, 0)),

        -- contraceptives_item_received (int) - numeric, null to 0
        ('contraceptives_item_received', COALESCE(src.contraceptives_item_received, 0)),

        -- contraceptives_item_returned (int) - numeric, null to 0
        ('contraceptives_item_returned', COALESCE(src.contraceptives_item_returned, 0)),

        -- rectal_item_received (int) - numeric, null to 0
        ('rectal_item_received', COALESCE(src.rectal_item_received, 0)),

        -- rectal_item_returned (int) - numeric, null to 0
        ('rectal_item_returned', COALESCE(src.rectal_item_returned, 0)),

        -- sayana_item_received (int) - numeric, null to 0
        ('sayana_item_received', COALESCE(src.sayana_item_received, 0)),

        -- sayana_item_returned (int) - numeric, null to 0
        ('sayana_item_returned', COALESCE(src.sayana_item_returned, 0)),

        -- gloves_item_received (int) - numeric, null to 0
        ('gloves_item_received', COALESCE(src.gloves_item_received, 0)),

        -- gloves_item_returned (int) - numeric, null to 0
        ('gloves_item_returned', COALESCE(src.gloves_item_returned, 0)),

        -- items_received_act (int) - numeric, null to 0
        ('items_received_act', COALESCE(src.items_received_act, 0)),

        -- items_received_malaria_rdts (int) - numeric, null to 0
        ('items_received_malaria_rdts', COALESCE(src.items_received_malaria_rdts, 0)),

        -- items_received_rectal (int) - numeric, null to 0
        ('items_received_rectal', COALESCE(src.items_received_rectal, 0)),

        -- items_received_gloves (int) - numeric, null to 0
        ('items_received_gloves', COALESCE(src.items_received_gloves, 0)),

        -- items_received_zinc (int) - numeric, null to 0
        ('items_received_zinc', COALESCE(src.items_received_zinc, 0)),

        -- items_received_amoxicillin (int) - numeric, null to 0
        ('items_received_amoxicillin', COALESCE(src.items_received_amoxicillin, 0)),

        -- items_received_pop (int) - numeric, null to 0
        ('items_received_pop', COALESCE(src.items_received_pop, 0)),

        -- items_received_coc (int) - numeric, null to 0
        ('items_received_coc', COALESCE(src.items_received_coc, 0)),

        -- items_received_contraceptives (int) - numeric, null to 0
        ('items_received_contraceptives', COALESCE(src.items_received_contraceptives, 0)),

        -- items_received_dmpa (int) - numeric, null to 0
        ('items_received_dmpa', COALESCE(src.items_received_dmpa, 0)),

        -- items_received_condoms (int) - numeric, null to 0
        ('items_received_condoms', COALESCE(src.items_received_condoms, 0)),

        -- items_returned_act_r (int) - numeric, null to 0
        ('items_returned_act_r', COALESCE(src.items_returned_act_r, 0)),

        -- items_returned_malaria_rdts_r (int) - numeric, null to 0
        ('items_returned_malaria_rdts_r', COALESCE(src.items_returned_malaria_rdts_r, 0)),

        -- items_returned_rectal_r (int) - numeric, null to 0
        ('items_returned_rectal_r', COALESCE(src.items_returned_rectal_r, 0)),

        -- items_returned_gloves_r (int) - numeric, null to 0
        ('items_returned_gloves_r', COALESCE(src.items_returned_gloves_r, 0)),

        -- items_returned_zinc_r (int) - numeric, null to 0
        ('items_returned_zinc_r', COALESCE(src.items_returned_zinc_r, 0)),

        -- items_returned_amoxicillin_r (int) - numeric, null to 0
        ('items_returned_amoxicillin_r', COALESCE(src.items_returned_amoxicillin_r, 0)),

        -- items_returned_pop_r (int) - numeric, null to 0
        ('items_returned_pop_r', COALESCE(src.items_returned_pop_r, 0)),

        -- items_returned_coc_r (int) - numeric, null to 0
        ('items_returned_coc_r', COALESCE(src.items_returned_coc_r, 0)),

        -- items_returned_contraceptives_r (int) - numeric, null to 0
        ('items_returned_contraceptives_r', COALESCE(src.items_returned_contraceptives_r, 0)),

        -- items_returned_dmpa_r (int) - numeric, null to 0
        ('items_returned_dmpa_r', COALESCE(src.items_returned_dmpa_r, 0)),

        -- items_returned_condoms_r (int) - numeric, null to 0
        ('items_returned_condoms_r', COALESCE(src.items_returned_condoms_r, 0))
) AS unpivot(data_element, value)
WHERE value IS NOT NULL;