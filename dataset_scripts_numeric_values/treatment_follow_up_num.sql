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
    'child_health' AS theme,
    'treatment_follow_up' AS dataset,
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
    'treatment_follow_up' AS source_form
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
        LOWER(TRIM(referral_follow_up)) AS referral_follow_up,
        LOWER(TRIM(trigger_referral_follow_up)) AS trigger_referral_follow_up,
        LOWER(TRIM(follow_up_method)) AS follow_up_method,
        LOWER(TRIM(any_danger_signs)) AS any_danger_signs,
        LOWER(TRIM(how_is_child)) AS how_is_child,
        LOWER(TRIM(child_referred)) AS child_referred,
        LOWER(TRIM(feeding_advice)) AS feeding_advice
    FROM cht.mv_treatment_follow_up_new
) src
CROSS JOIN LATERAL (
    VALUES
        -- referral_follow_up (yes/no) - binary
        ('referral_follow_up - Yes', CASE WHEN src.referral_follow_up = 'yes' THEN 1 ELSE 0 END),
        ('referral_follow_up - No', CASE WHEN src.referral_follow_up = 'no' THEN 1 ELSE 0 END),

        -- trigger_referral_follow_up (yes/no) - binary
        ('trigger_referral_follow_up - Yes', CASE WHEN src.trigger_referral_follow_up = 'yes' THEN 1 ELSE 0 END),
        ('trigger_referral_follow_up - No', CASE WHEN src.trigger_referral_follow_up = 'no' THEN 1 ELSE 0 END),

        -- follow_up_method (in_person/by_phone) - binary
        ('follow_up_method - In_person', CASE WHEN src.follow_up_method LIKE '%in_person%' THEN 1 ELSE 0 END),
        ('follow_up_method - By_phone', CASE WHEN src.follow_up_method LIKE '%by_phone%' THEN 1 ELSE 0 END),

        -- any_danger_signs (convulsions/vomits_everything/fast_breathing/very_sleepy/yellow_eyes_palms/chest_indrawing/unable_to_drink_breastfeed/infected_umbilical_chord/low_temperature/fever_more_than7days/muac_red_yellow/none) - binary
        ('any_danger_signs - Convulsions', CASE WHEN src.any_danger_signs LIKE '%convulsions%' THEN 1 ELSE 0 END),
        ('any_danger_signs - Vomits_everything', CASE WHEN src.any_danger_signs LIKE '%vomits_everything%' THEN 1 ELSE 0 END),
        ('any_danger_signs - Fast_breathing', CASE WHEN src.any_danger_signs LIKE '%fast_breathing%' THEN 1 ELSE 0 END),
        ('any_danger_signs - Very_sleepy', CASE WHEN src.any_danger_signs LIKE '%very_sleepy%' THEN 1 ELSE 0 END),
        ('any_danger_signs - Yellow_eyes_palms', CASE WHEN src.any_danger_signs LIKE '%yellow_eyes_palms%' THEN 1 ELSE 0 END),
        ('any_danger_signs - Chest_indrawing', CASE WHEN src.any_danger_signs LIKE '%chest_indrawing%' THEN 1 ELSE 0 END),
        ('any_danger_signs - Unable_to_drink_breastfeed', CASE WHEN src.any_danger_signs LIKE '%unable_to_drink_breastfeed%' THEN 1 ELSE 0 END),
        ('any_danger_signs - Infected_umbilical_chord', CASE WHEN src.any_danger_signs LIKE '%infected_umbilical_chord%' THEN 1 ELSE 0 END),
        ('any_danger_signs - Low_temperature', CASE WHEN src.any_danger_signs LIKE '%low_temperature%' THEN 1 ELSE 0 END),
        ('any_danger_signs - Fever_more_than7days', CASE WHEN src.any_danger_signs LIKE '%fever_more_than7days%' THEN 1 ELSE 0 END),
        ('any_danger_signs - Muac_red_yellow', CASE WHEN src.any_danger_signs LIKE '%muac_red_yellow%' THEN 1 ELSE 0 END),
        ('any_danger_signs - None', CASE WHEN src.any_danger_signs LIKE '%none%' THEN 1 ELSE 0 END),

        -- how_is_child (is_better/not_better/cured) - binary
        ('how_is_child - Is_better', CASE WHEN src.how_is_child LIKE '%is_better%' THEN 1 ELSE 0 END),
        ('how_is_child - Not_better', CASE WHEN src.how_is_child LIKE '%not_better%' THEN 1 ELSE 0 END),
        ('how_is_child - Cured', CASE WHEN src.how_is_child LIKE '%cured%' THEN 1 ELSE 0 END),

        -- child_referred (yes) - binary
        ('child_referred - Yes', CASE WHEN src.child_referred = 'yes' THEN 1 ELSE 0 END),

        -- feeding_advice (give_more_liquids/give_soft_foods/encourage_child2eat/varied_foods) - binary
        ('feeding_advice - Give_more_liquids', CASE WHEN src.feeding_advice LIKE '%give_more_liquids%' THEN 1 ELSE 0 END),
        ('feeding_advice - Give_soft_foods', CASE WHEN src.feeding_advice LIKE '%give_soft_foods%' THEN 1 ELSE 0 END),
        ('feeding_advice - Encourage_child2eat', CASE WHEN src.feeding_advice LIKE '%encourage_child2eat%' THEN 1 ELSE 0 END),
        ('feeding_advice - Varied_foods', CASE WHEN src.feeding_advice LIKE '%varied_foods%' THEN 1 ELSE 0 END)
) AS unpivot(data_element, value)
WHERE value = 1;