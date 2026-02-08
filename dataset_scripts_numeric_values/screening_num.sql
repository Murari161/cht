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
    'screening' AS theme,
    'screening' AS dataset,
    unpivot.data_element,
    unpivot.value,
    date,
    chw_id,
    contact_facility_id AS facility_id,
    district_id AS district_id,
    region_id AS region,
    patient_age_in_years,
    patient_age_in_months,
    patient_age_in_days,
    patient_gender AS patient_sex,
    inputs_contact_date_of_birth AS patient_dob,
    'cht' AS source_system,
    'screening' AS source_form
FROM (
    SELECT
        uuid,
        date,
        chw_id,
        contact_facility_id,
        district_id,
        region_id,
        patient_age_in_years,
        patient_age_in_months,
        patient_age_in_days,
        patient_gender,
        inputs_contact_date_of_birth,

        -- indicator columns
        LOWER(TRIM(is_of_child_bearing_age)) AS is_of_child_bearing_age,
        LOWER(TRIM(p_is_pregnant)) AS p_is_pregnant,
        LOWER(TRIM(p_has_started_anc)) AS p_has_started_anc,
        LOWER(TRIM(p_referred_to_health_facility_anc)) AS p_referred_to_health_facility_anc,
        LOWER(TRIM(on_fp_method)) AS on_fp_method,
        LOWER(TRIM(fp_method)) AS fp_method,
        LOWER(TRIM(experiencing_fp_side_effects)) AS experiencing_fp_side_effects,
        LOWER(TRIM(change_fp_method)) AS change_fp_method,
        LOWER(TRIM(counseled_on_fp_methods)) AS counseled_on_fp_methods,
        LOWER(TRIM(referred_for_fp_services)) AS referred_for_fp_services,
        LOWER(TRIM(knows_lmp)) AS knows_lmp,
        LOWER(TRIM(lmp_approximate_date)) AS lmp_approximate_date,
        LOWER(TRIM(referred_for_pregnancy_test)) AS referred_for_pregnancy_test,
        LOWER(TRIM(hiv_test_for_hiv_last3months)) AS hiv_test_for_hiv_last3months,
        LOWER(TRIM(hiv_tested_hiv)) AS hiv_tested_hiv,
        LOWER(TRIM(hiv_not_tested_hiv)) AS hiv_not_tested_hiv,
        LOWER(TRIM(hiv_on_art_treatment)) AS hiv_on_art_treatment,
        LOWER(TRIM(hiv_taking_medication)) AS hiv_taking_medication,
        LOWER(TRIM(has_tb)) AS has_tb,
        LOWER(TRIM(on_tb_treatment)) AS on_tb_treatment,
        LOWER(TRIM(other_hpv_card)) AS other_hpv_card,
        LOWER(TRIM(other_received_hpv)) AS other_received_hpv,
        LOWER(TRIM(other_afp_vpd)) AS other_afp_vpd,
        LOWER(TRIM(other_refer_afp)) AS other_refer_afp,
        LOWER(TRIM(other_received_tt_vaccine)) AS other_received_tt_vaccine,
        LOWER(TRIM(other_has_hypertension)) AS other_has_hypertension,
        LOWER(TRIM(other_has_sickle_cell)) AS other_has_sickle_cell,
        LOWER(TRIM(other_uses_tobacco)) AS other_uses_tobacco,
        LOWER(TRIM(other_sleep_under_llin)) AS other_sleep_under_llin,
        LOWER(TRIM(other_why_not_using_llin)) AS other_why_not_using_llin
    FROM cht.mv_screening
) src
CROSS JOIN LATERAL (
    VALUES
        -- is_of_child_bearing_age (true/false) - binary
        ('is_of_child_bearing_age - True', CASE WHEN src.is_of_child_bearing_age = 'true' THEN 1 ELSE 0 END),
        ('is_of_child_bearing_age - False', CASE WHEN src.is_of_child_bearing_age = 'false' THEN 1 ELSE 0 END),

        -- p_is_pregnant (yes/no) - binary
        ('p_is_pregnant - Yes', CASE WHEN src.p_is_pregnant = 'yes' THEN 1 ELSE 0 END),
        ('p_is_pregnant - No', CASE WHEN src.p_is_pregnant = 'no' THEN 1 ELSE 0 END),

        -- p_has_started_anc (yes/no) - binary
        ('p_has_started_anc - Yes', CASE WHEN src.p_has_started_anc = 'yes' THEN 1 ELSE 0 END),
        ('p_has_started_anc - No', CASE WHEN src.p_has_started_anc = 'no' THEN 1 ELSE 0 END),

        -- p_referred_to_health_facility_anc (yes/no) - binary
        ('p_referred_to_health_facility_anc - Yes', CASE WHEN src.p_referred_to_health_facility_anc = 'yes' THEN 1 ELSE 0 END),
        ('p_referred_to_health_facility_anc - No', CASE WHEN src.p_referred_to_health_facility_anc = 'no' THEN 1 ELSE 0 END),

        -- on_fp_method (yes/no) - binary
        ('on_fp_method - Yes', CASE WHEN src.on_fp_method = 'yes' THEN 1 ELSE 0 END),
        ('on_fp_method - No', CASE WHEN src.on_fp_method = 'no' THEN 1 ELSE 0 END),

        -- fp_method (cocs/pops/dmpa_im/dmpa_sc/implants/iud/condoms/tl) - binary
        ('fp_method - Cocs', CASE WHEN src.fp_method LIKE '%cocs%' THEN 1 ELSE 0 END),
        ('fp_method - Pops', CASE WHEN src.fp_method LIKE '%pops%' THEN 1 ELSE 0 END),
        ('fp_method - Dmpa_im', CASE WHEN src.fp_method LIKE '%dmpa_im%' THEN 1 ELSE 0 END),
        ('fp_method - Dmpa_sc', CASE WHEN src.fp_method LIKE '%dmpa_sc%' THEN 1 ELSE 0 END),
        ('fp_method - Implants', CASE WHEN src.fp_method LIKE '%implants%' THEN 1 ELSE 0 END),
        ('fp_method - Iud', CASE WHEN src.fp_method LIKE '%iud%' THEN 1 ELSE 0 END),
        ('fp_method - Condoms', CASE WHEN src.fp_method LIKE '%condoms%' THEN 1 ELSE 0 END),
        ('fp_method - Tl', CASE WHEN src.fp_method LIKE '%tl%' THEN 1 ELSE 0 END),

        -- experiencing_fp_side_effects (yes/no) - binary
        ('experiencing_fp_side_effects - Yes', CASE WHEN src.experiencing_fp_side_effects = 'yes' THEN 1 ELSE 0 END),
        ('experiencing_fp_side_effects - No', CASE WHEN src.experiencing_fp_side_effects = 'no' THEN 1 ELSE 0 END),

        -- change_fp_method (yes/no) - binary
        ('change_fp_method - Yes', CASE WHEN src.change_fp_method = 'yes' THEN 1 ELSE 0 END),
        ('change_fp_method - No', CASE WHEN src.change_fp_method = 'no' THEN 1 ELSE 0 END),

        -- counseled_on_fp_methods (yes/no) - binary
        ('counseled_on_fp_methods - Yes', CASE WHEN src.counseled_on_fp_methods = 'yes' THEN 1 ELSE 0 END),
        ('counseled_on_fp_methods - No', CASE WHEN src.counseled_on_fp_methods = 'no' THEN 1 ELSE 0 END),

        -- referred_for_fp_services (yes/no) - binary
        ('referred_for_fp_services - Yes', CASE WHEN src.referred_for_fp_services = 'yes' THEN 1 ELSE 0 END),
        ('referred_for_fp_services - No', CASE WHEN src.referred_for_fp_services = 'no' THEN 1 ELSE 0 END),

        -- knows_lmp (yes/no) - binary
        ('knows_lmp - Yes', CASE WHEN src.knows_lmp = 'yes' THEN 1 ELSE 0 END),
        ('knows_lmp - No', CASE WHEN src.knows_lmp = 'no' THEN 1 ELSE 0 END),

        -- lmp_approximate_date (more_than_1_month_ago/less_than_1_month_ago) - binary
        ('lmp_approximate_date - More_than_1_month_ago', CASE WHEN src.lmp_approximate_date LIKE '%more_than_1_month_ago%' THEN 1 ELSE 0 END),
        ('lmp_approximate_date - Less_than_1_month_ago', CASE WHEN src.lmp_approximate_date LIKE '%less_than_1_month_ago%' THEN 1 ELSE 0 END),

        -- referred_for_pregnancy_test (yes/no) - binary
        ('referred_for_pregnancy_test - Yes', CASE WHEN src.referred_for_pregnancy_test = 'yes' THEN 1 ELSE 0 END),
        ('referred_for_pregnancy_test - No', CASE WHEN src.referred_for_pregnancy_test = 'no' THEN 1 ELSE 0 END),

        -- hiv_test_for_hiv_last3months (yes/no) - binary
        ('hiv_test_for_hiv_last3months - Yes', CASE WHEN src.hiv_test_for_hiv_last3months = 'yes' THEN 1 ELSE 0 END),
        ('hiv_test_for_hiv_last3months - No', CASE WHEN src.hiv_test_for_hiv_last3months = 'no' THEN 1 ELSE 0 END),

        -- hiv_tested_hiv (positive/negative/unknown) - binary
        ('hiv_tested_hiv - Positive', CASE WHEN src.hiv_tested_hiv LIKE '%positive%' THEN 1 ELSE 0 END),
        ('hiv_tested_hiv - Negative', CASE WHEN src.hiv_tested_hiv LIKE '%negative%' THEN 1 ELSE 0 END),
        ('hiv_tested_hiv - Unknown', CASE WHEN src.hiv_tested_hiv LIKE '%unknown%' THEN 1 ELSE 0 END),

        -- hiv_not_tested_hiv (positive/negative/unknown) - binary
        ('hiv_not_tested_hiv - Positive', CASE WHEN src.hiv_not_tested_hiv LIKE '%positive%' THEN 1 ELSE 0 END),
        ('hiv_not_tested_hiv - Negative', CASE WHEN src.hiv_not_tested_hiv LIKE '%negative%' THEN 1 ELSE 0 END),
        ('hiv_not_tested_hiv - Unknown', CASE WHEN src.hiv_not_tested_hiv LIKE '%unknown%' THEN 1 ELSE 0 END),

        -- hiv_on_art_treatment (yes/no) - binary
        ('hiv_on_art_treatment - Yes', CASE WHEN src.hiv_on_art_treatment = 'yes' THEN 1 ELSE 0 END),
        ('hiv_on_art_treatment - No', CASE WHEN src.hiv_on_art_treatment = 'no' THEN 1 ELSE 0 END),

        -- hiv_taking_medication (yes/no) - binary
        ('hiv_taking_medication - Yes', CASE WHEN src.hiv_taking_medication = 'yes' THEN 1 ELSE 0 END),
        ('hiv_taking_medication - No', CASE WHEN src.hiv_taking_medication = 'no' THEN 1 ELSE 0 END),

        -- has_tb (yes/no) - binary
        ('has_tb - Yes', CASE WHEN src.has_tb = 'yes' THEN 1 ELSE 0 END),
        ('has_tb - No', CASE WHEN src.has_tb = 'no' THEN 1 ELSE 0 END),

        -- on_tb_treatment (yes/no) - binary
        ('on_tb_treatment - Yes', CASE WHEN src.on_tb_treatment = 'yes' THEN 1 ELSE 0 END),
        ('on_tb_treatment - No', CASE WHEN src.on_tb_treatment = 'no' THEN 1 ELSE 0 END),

        -- other_hpv_card (yes/no) - binary
        ('other_hpv_card - Yes', CASE WHEN src.other_hpv_card = 'yes' THEN 1 ELSE 0 END),
        ('other_hpv_card - No', CASE WHEN src.other_hpv_card = 'no' THEN 1 ELSE 0 END),

        -- other_received_hpv (yes/no) - binary
        ('other_received_hpv - Yes', CASE WHEN src.other_received_hpv = 'yes' THEN 1 ELSE 0 END),
        ('other_received_hpv - No', CASE WHEN src.other_received_hpv = 'no' THEN 1 ELSE 0 END),

        -- other_afp_vpd (yes/no) - binary
        ('other_afp_vpd - Yes', CASE WHEN src.other_afp_vpd = 'yes' THEN 1 ELSE 0 END),
        ('other_afp_vpd - No', CASE WHEN src.other_afp_vpd = 'no' THEN 1 ELSE 0 END),

        -- other_refer_afp (true/false) - binary
        ('other_refer_afp - True', CASE WHEN src.other_refer_afp = 'true' THEN 1 ELSE 0 END),
        ('other_refer_afp - False', CASE WHEN src.other_refer_afp = 'false' THEN 1 ELSE 0 END),

        -- other_received_tt_vaccine (yes/no) - binary
        ('other_received_tt_vaccine - Yes', CASE WHEN src.other_received_tt_vaccine = 'yes' THEN 1 ELSE 0 END),
        ('other_received_tt_vaccine - No', CASE WHEN src.other_received_tt_vaccine = 'no' THEN 1 ELSE 0 END),

        -- other_has_hypertension (yes/no) - binary
        ('other_has_hypertension - Yes', CASE WHEN src.other_has_hypertension = 'yes' THEN 1 ELSE 0 END),
        ('other_has_hypertension - No', CASE WHEN src.other_has_hypertension = 'no' THEN 1 ELSE 0 END),

        -- other_has_sickle_cell (yes/no) - binary
        ('other_has_sickle_cell - Yes', CASE WHEN src.other_has_sickle_cell = 'yes' THEN 1 ELSE 0 END),
        ('other_has_sickle_cell - No', CASE WHEN src.other_has_sickle_cell = 'no' THEN 1 ELSE 0 END),

        -- other_uses_tobacco (yes/no) - binary
        ('other_uses_tobacco - Yes', CASE WHEN src.other_uses_tobacco = 'yes' THEN 1 ELSE 0 END),
        ('other_uses_tobacco - No', CASE WHEN src.other_uses_tobacco = 'no' THEN 1 ELSE 0 END),

        -- other_sleep_under_llin (yes/no) - binary
        ('other_sleep_under_llin - Yes', CASE WHEN src.other_sleep_under_llin = 'yes' THEN 1 ELSE 0 END),
        ('other_sleep_under_llin - No', CASE WHEN src.other_sleep_under_llin = 'no' THEN 1 ELSE 0 END),

        -- other_why_not_using_llin (has_no_llin/not_enough_llins/does_not_know_how_to_use/other) - binary
        ('other_why_not_using_llin - Has_no_llin', CASE WHEN src.other_why_not_using_llin LIKE '%has_no_llin%' THEN 1 ELSE 0 END),
        ('other_why_not_using_llin - Not_enough_llins', CASE WHEN src.other_why_not_using_llin LIKE '%not_enough_llins%' THEN 1 ELSE 0 END),
        ('other_why_not_using_llin - Does_not_know_how_to_use', CASE WHEN src.other_why_not_using_llin LIKE '%does_not_know_how_to_use%' THEN 1 ELSE 0 END),
        ('other_why_not_using_llin - Other', CASE WHEN src.other_why_not_using_llin LIKE '%other%' THEN 1 ELSE 0 END)
) AS unpivot(data_element, value)
WHERE value = 1;