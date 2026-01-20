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
    'ha' AS theme,
    'ha_danger_signs_follow_up' AS dataset,
    unpivot.data_element,
    unpivot.value,
    date,
    chw_id,
    facility_id,
    district AS district_id,
    region,
    t_patient_age_in_years AS patient_age_in_years,
    t_patient_age_in_months AS patient_age_in_months,
    t_patient_age_in_days AS patient_age_in_days,
    t_patient_sex AS patient_sex,
    NULL AS patient_dob,
    'cht' AS source_system,
    'ha_danger_signs_follow_up' AS source_form
FROM (
    SELECT
        doc_id,
        date,
        chw_id,
        facility_id,
        district,
        region,
        t_patient_age_in_years,
        t_patient_age_in_months,
        t_patient_age_in_days,
        t_patient_sex,

        -- indicator columns
        LOWER(TRIM(needs_signoff)) AS needs_signoff,
        LOWER(TRIM(danger_signs)) AS danger_signs,
        LOWER(TRIM(action)) AS action
    FROM cht.mv_ha_danger_signs_follow_up_new
) src
CROSS JOIN LATERAL (
    VALUES
        -- needs_signoff (true) - binary
        ('needs_signoff - True', CASE WHEN src.needs_signoff = 'true' THEN 1 ELSE 0 END),

        -- danger_signs (vaginal_bleeding/lower_abdomen_pain/severe_headache/very_pale/fever/reduced_or_no_feotal_movements/blurred_vision/swelling/breathlessness/woman_danger_sign_fever/woman_danger_sign_severe_headache/woman_danger_sign_vaginal_bleeding/woman_danger_sign_foul_vaginal_discharge/woman_danger_sign_convulsions/child_vomits_everything/child_has_convulsions/child_cannot_drink_breastfeed/child_unconscious/child_has_low_temp/child_has_yellow_eyes_or_palms/child_has_infected_umbilical_cord/child_has_chest_in_drawing/child_vomiting_everything/child_has_difficulty_feeding/child_has_body_stiffness/child_has_fever/child_has_yellow_skin) - binary
        ('danger_signs - Vaginal_bleeding', CASE WHEN src.danger_signs LIKE '%vaginal_bleeding%' THEN 1 ELSE 0 END),
        ('danger_signs - Lower_abdomen_pain', CASE WHEN src.danger_signs LIKE '%lower_abdomen_pain%' THEN 1 ELSE 0 END),
        ('danger_signs - Severe_headache', CASE WHEN src.danger_signs LIKE '%severe_headache%' THEN 1 ELSE 0 END),
        ('danger_signs - Very_pale', CASE WHEN src.danger_signs LIKE '%very_pale%' THEN 1 ELSE 0 END),
        ('danger_signs - Fever', CASE WHEN src.danger_signs LIKE '%fever%' THEN 1 ELSE 0 END),
        ('danger_signs - Reduced_or_no_feotal_movements', CASE WHEN src.danger_signs LIKE '%reduced_or_no_feotal_movements%' THEN 1 ELSE 0 END),
        ('danger_signs - Blurred_vision', CASE WHEN src.danger_signs LIKE '%blurred_vision%' THEN 1 ELSE 0 END),
        ('danger_signs - Swelling', CASE WHEN src.danger_signs LIKE '%swelling%' THEN 1 ELSE 0 END),
        ('danger_signs - Breathlessness', CASE WHEN src.danger_signs LIKE '%breathlessness%' THEN 1 ELSE 0 END),
        ('danger_signs - Woman_danger_sign_fever', CASE WHEN src.danger_signs LIKE '%woman_danger_sign_fever%' THEN 1 ELSE 0 END),
        ('danger_signs - Woman_danger_sign_severe_headache', CASE WHEN src.danger_signs LIKE '%woman_danger_sign_severe_headache%' THEN 1 ELSE 0 END),
        ('danger_signs - Woman_danger_sign_vaginal_bleeding', CASE WHEN src.danger_signs LIKE '%woman_danger_sign_vaginal_bleeding%' THEN 1 ELSE 0 END),
        ('danger_signs - Woman_danger_sign_foul_vaginal_discharge', CASE WHEN src.danger_signs LIKE '%woman_danger_sign_foul_vaginal_discharge%' THEN 1 ELSE 0 END),
        ('danger_signs - Woman_danger_sign_convulsions', CASE WHEN src.danger_signs LIKE '%woman_danger_sign_convulsions%' THEN 1 ELSE 0 END),
        ('danger_signs - Child_vomits_everything', CASE WHEN src.danger_signs LIKE '%child_vomits_everything%' THEN 1 ELSE 0 END),
        ('danger_signs - Child_has_convulsions', CASE WHEN src.danger_signs LIKE '%child_has_convulsions%' THEN 1 ELSE 0 END),
        ('danger_signs - Child_cannot_drink_breastfeed', CASE WHEN src.danger_signs LIKE '%child_cannot_drink_breastfeed%' THEN 1 ELSE 0 END),
        ('danger_signs - Child_unconscious', CASE WHEN src.danger_signs LIKE '%child_unconscious%' THEN 1 ELSE 0 END),
        ('danger_signs - Child_has_low_temp', CASE WHEN src.danger_signs LIKE '%child_has_low_temp%' THEN 1 ELSE 0 END),
        ('danger_signs - Child_has_yellow_eyes_or_palms', CASE WHEN src.danger_signs LIKE '%child_has_yellow_eyes_or_palms%' THEN 1 ELSE 0 END),
        ('danger_signs - Child_has_infected_umbilical_cord', CASE WHEN src.danger_signs LIKE '%child_has_infected_umbilical_cord%' THEN 1 ELSE 0 END),
        ('danger_signs - Child_has_chest_in_drawing', CASE WHEN src.danger_signs LIKE '%child_has_chest_in_drawing%' THEN 1 ELSE 0 END),
        ('danger_signs - Child_vomiting_everything', CASE WHEN src.danger_signs LIKE '%child_vomiting_everything%' THEN 1 ELSE 0 END),
        ('danger_signs - Child_has_difficulty_feeding', CASE WHEN src.danger_signs LIKE '%child_has_difficulty_feeding%' THEN 1 ELSE 0 END),
        ('danger_signs - Child_has_body_stiffness', CASE WHEN src.danger_signs LIKE '%child_has_body_stiffness%' THEN 1 ELSE 0 END),
        ('danger_signs - Child_has_fever', CASE WHEN src.danger_signs LIKE '%child_has_fever%' THEN 1 ELSE 0 END),
        ('danger_signs - Child_has_yellow_skin', CASE WHEN src.danger_signs LIKE '%child_has_yellow_skin%' THEN 1 ELSE 0 END),

        -- action (completed/to_follow_up/other) - binary
        ('action - Completed', CASE WHEN src.action LIKE '%completed%' THEN 1 ELSE 0 END),
        ('action - To_follow_up', CASE WHEN src.action LIKE '%to_follow_up%' THEN 1 ELSE 0 END),
        ('action - Other', CASE WHEN src.action LIKE '%other%' THEN 1 ELSE 0 END)
) AS unpivot(data_element, value)
WHERE value = 1;