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
    'pnc' AS theme,
    'pnc_baby_follow_up' AS dataset,
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
    'pnc_baby_follow_up' AS source_form
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
        LOWER(TRIM(has_attended_pnc)) AS has_attended_pnc,
        LOWER(TRIM(pnc_visit)) AS pnc_visit,
        LOWER(TRIM(reason_missed_pnc)) AS reason_missed_pnc,
        LOWER(TRIM(has_agreed_to_pnc_visit)) AS has_agreed_to_pnc_visit,
        LOWER(TRIM(breastfeeding_exclusively)) AS breastfeeding_exclusively,
        LOWER(TRIM(breastfeeding_within_1hour_delivery)) AS breastfeeding_within_1hour_delivery,
        LOWER(TRIM(child_has_chest_in_drawing)) AS child_has_chest_in_drawing,
        LOWER(TRIM(child_has_convulsions)) AS child_has_convulsions,
        LOWER(TRIM(child_vomiting_everything)) AS child_vomiting_everything,
        LOWER(TRIM(child_unconscious)) AS child_unconscious,
        LOWER(TRIM(child_has_infected_umbilical_cord)) AS child_has_infected_umbilical_cord,
        LOWER(TRIM(child_has_difficulty_feeding)) AS child_has_difficulty_feeding,
        LOWER(TRIM(child_has_body_stiffness)) AS child_has_body_stiffness,
        LOWER(TRIM(child_has_fever)) AS child_has_fever,
        LOWER(TRIM(child_has_yellow_skin)) AS child_has_yellow_skin,
        LOWER(TRIM(referred_to_facility)) AS referred_to_facility
    FROM cht.mv_pnc_baby_follow_up
) src
CROSS JOIN LATERAL (
    VALUES
        -- has_attended_pnc (yes/no)
        ('has_attended_pnc - Yes', CASE WHEN src.has_attended_pnc = 'yes' THEN 1 ELSE 0 END),
        ('has_attended_pnc - No', CASE WHEN src.has_attended_pnc = 'no' THEN 1 ELSE 0 END),

        -- pnc_visit (1/3/7)
        ('pnc_visit - 1', CASE WHEN src.pnc_visit = '1' THEN 1 ELSE 0 END),
        ('pnc_visit - 3', CASE WHEN src.pnc_visit = '3' THEN 1 ELSE 0 END),
        ('pnc_visit - 7', CASE WHEN src.pnc_visit = '7' THEN 1 ELSE 0 END),

        -- reason_missed_pnc (relocated/no_transport/had_traveled/does_not_consider_important/other)
        ('reason_missed_pnc - Relocated', CASE WHEN src.reason_missed_pnc LIKE '%relocated%' THEN 1 ELSE 0 END),
        ('reason_missed_pnc - No_transport', CASE WHEN src.reason_missed_pnc LIKE '%no_transport%' THEN 1 ELSE 0 END),
        ('reason_missed_pnc - Had_traveled', CASE WHEN src.reason_missed_pnc LIKE '%had_traveled%' THEN 1 ELSE 0 END),
        ('reason_missed_pnc - Does_not_consider_important', CASE WHEN src.reason_missed_pnc LIKE '%does_not_consider_important%' THEN 1 ELSE 0 END),
        ('reason_missed_pnc - Other', CASE WHEN src.reason_missed_pnc LIKE '%other%' THEN 1 ELSE 0 END),

        -- has_agreed_to_pnc_visit (yes/no)
        ('has_agreed_to_pnc_visit - Yes', CASE WHEN src.has_agreed_to_pnc_visit = 'yes' THEN 1 ELSE 0 END),
        ('has_agreed_to_pnc_visit - No', CASE WHEN src.has_agreed_to_pnc_visit = 'no' THEN 1 ELSE 0 END),

        -- breastfeeding_exclusively (yes/no)
        ('breastfeeding_exclusively - Yes', CASE WHEN src.breastfeeding_exclusively = 'yes' THEN 1 ELSE 0 END),
        ('breastfeeding_exclusively - No', CASE WHEN src.breastfeeding_exclusively = 'no' THEN 1 ELSE 0 END),

        -- breastfeeding_within_1hour_delivery (yes/no)
        ('breastfeeding_within_1hour_delivery - Yes', CASE WHEN src.breastfeeding_within_1hour_delivery = 'yes' THEN 1 ELSE 0 END),
        ('breastfeeding_within_1hour_delivery - No', CASE WHEN src.breastfeeding_within_1hour_delivery = 'no' THEN 1 ELSE 0 END),

        -- child_has_chest_in_drawing (yes/no)
        ('child_has_chest_in_drawing - Yes', CASE WHEN src.child_has_chest_in_drawing = 'yes' THEN 1 ELSE 0 END),
        ('child_has_chest_in_drawing - No', CASE WHEN src.child_has_chest_in_drawing = 'no' THEN 1 ELSE 0 END),

        -- child_has_convulsions (yes/no)
        ('child_has_convulsions - Yes', CASE WHEN src.child_has_convulsions = 'yes' THEN 1 ELSE 0 END),
        ('child_has_convulsions - No', CASE WHEN src.child_has_convulsions = 'no' THEN 1 ELSE 0 END),

        -- child_vomiting_everything (yes/no)
        ('child_vomiting_everything - Yes', CASE WHEN src.child_vomiting_everything = 'yes' THEN 1 ELSE 0 END),
        ('child_vomiting_everything - No', CASE WHEN src.child_vomiting_everything = 'no' THEN 1 ELSE 0 END),

        -- child_unconscious (yes/no)
        ('child_unconscious - Yes', CASE WHEN src.child_unconscious = 'yes' THEN 1 ELSE 0 END),
        ('child_unconscious - No', CASE WHEN src.child_unconscious = 'no' THEN 1 ELSE 0 END),

        -- child_has_infected_umbilical_cord (yes/no)
        ('child_has_infected_umbilical_cord - Yes', CASE WHEN src.child_has_infected_umbilical_cord = 'yes' THEN 1 ELSE 0 END),
        ('child_has_infected_umbilical_cord - No', CASE WHEN src.child_has_infected_umbilical_cord = 'no' THEN 1 ELSE 0 END),

        -- child_has_difficulty_feeding (yes/no)
        ('child_has_difficulty_feeding - Yes', CASE WHEN src.child_has_difficulty_feeding = 'yes' THEN 1 ELSE 0 END),
        ('child_has_difficulty_feeding - No', CASE WHEN src.child_has_difficulty_feeding = 'no' THEN 1 ELSE 0 END),

        -- child_has_body_stiffness (yes/no)
        ('child_has_body_stiffness - Yes', CASE WHEN src.child_has_body_stiffness = 'yes' THEN 1 ELSE 0 END),
        ('child_has_body_stiffness - No', CASE WHEN src.child_has_body_stiffness = 'no' THEN 1 ELSE 0 END),

        -- child_has_fever (yes/no)
        ('child_has_fever - Yes', CASE WHEN src.child_has_fever = 'yes' THEN 1 ELSE 0 END),
        ('child_has_fever - No', CASE WHEN src.child_has_fever = 'no' THEN 1 ELSE 0 END),

        -- child_has_yellow_skin (yes/no)
        ('child_has_yellow_skin - Yes', CASE WHEN src.child_has_yellow_skin = 'yes' THEN 1 ELSE 0 END),
        ('child_has_yellow_skin - No', CASE WHEN src.child_has_yellow_skin = 'no' THEN 1 ELSE 0 END),

        -- referred_to_facility (yes/no)
        ('referred_to_facility - Yes', CASE WHEN src.referred_to_facility = 'yes' THEN 1 ELSE 0 END),
        ('referred_to_facility - No', CASE WHEN src.referred_to_facility = 'no' THEN 1 ELSE 0 END)
) AS unpivot(data_element, value)
WHERE value = 1;