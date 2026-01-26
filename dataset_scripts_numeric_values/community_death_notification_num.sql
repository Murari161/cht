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
    'death' AS theme,
    'community_death_notification' AS dataset,
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
    'community_death_notification' AS source_form
FROM (
    SELECT
        uuid,
        date,
        chw_id,
        contact_facility_id,
        district_id,
        region_id,

        -- indicator columns (categorical and numeric)
        LOWER(TRIM(death_category)) AS death_category,
        LOWER(TRIM(mother_place_of_death)) AS mother_place_of_death,
        LOWER(TRIM(mother_death_timing)) AS mother_death_timing,
        LOWER(TRIM(mother_death_registered)) AS mother_death_registered,
        LOWER(TRIM(baby_sex)) AS baby_sex,
        LOWER(TRIM(baby_place_of_birth)) AS baby_place_of_birth,
        LOWER(TRIM(baby_birth_attendant)) AS baby_birth_attendant,
        LOWER(TRIM(baby_place_of_death)) AS baby_place_of_death,
        LOWER(TRIM(baby_multiple_pregnancy)) AS baby_multiple_pregnancy,
        baby_multiple_howmany,
        LOWER(TRIM(other_babies_alive)) AS other_babies_alive,
        LOWER(TRIM(baby_death_registered)) AS baby_death_registered
    FROM cht.mv_community_death_notification
) src
CROSS JOIN LATERAL (
    VALUES
        -- death_category (maternal/neonatal/stillbirth/mat_neonatal/mat_still) - binary
        ('death_category - Maternal', CASE WHEN src.death_category LIKE '%maternal%' THEN 1 ELSE 0 END),
        ('death_category - Neonatal', CASE WHEN src.death_category LIKE '%neonatal%' THEN 1 ELSE 0 END),
        ('death_category - Stillbirth', CASE WHEN src.death_category LIKE '%stillbirth%' THEN 1 ELSE 0 END),
        ('death_category - Mat_neonatal', CASE WHEN src.death_category LIKE '%mat_neonatal%' THEN 1 ELSE 0 END),
        ('death_category - Mat_still', CASE WHEN src.death_category LIKE '%mat_still%' THEN 1 ELSE 0 END),

        -- mother_place_of_death (facility/home/transit/other) - binary
        ('mother_place_of_death - Facility', CASE WHEN src.mother_place_of_death LIKE '%facility%' THEN 1 ELSE 0 END),
        ('mother_place_of_death - Home', CASE WHEN src.mother_place_of_death LIKE '%home%' THEN 1 ELSE 0 END),
        ('mother_place_of_death - Transit', CASE WHEN src.mother_place_of_death LIKE '%transit%' THEN 1 ELSE 0 END),
        ('mother_place_of_death - Other', CASE WHEN src.mother_place_of_death LIKE '%other%' THEN 1 ELSE 0 END),

        -- mother_death_timing (pregnancy/labour/after) - binary
        ('mother_death_timing - Pregnancy', CASE WHEN src.mother_death_timing LIKE '%pregnancy%' THEN 1 ELSE 0 END),
        ('mother_death_timing - Labour', CASE WHEN src.mother_death_timing LIKE '%labour%' THEN 1 ELSE 0 END),
        ('mother_death_timing - After', CASE WHEN src.mother_death_timing LIKE '%after%' THEN 1 ELSE 0 END),

        -- mother_death_registered (yes/no/dk) - binary
        ('mother_death_registered - Yes', CASE WHEN src.mother_death_registered = 'yes' THEN 1 ELSE 0 END),
        ('mother_death_registered - No', CASE WHEN src.mother_death_registered = 'no' THEN 1 ELSE 0 END),
        ('mother_death_registered - Dk', CASE WHEN src.mother_death_registered LIKE '%dk%' THEN 1 ELSE 0 END),

        -- baby_sex (male/femaleunknown) - binary
        ('baby_sex - Male', CASE WHEN src.baby_sex LIKE '%male%' THEN 1 ELSE 0 END),
        ('baby_sex - Female', CASE WHEN src.baby_sex LIKE '%female%' THEN 1 ELSE 0 END),
        ('baby_sex - Unknown', CASE WHEN src.baby_sex LIKE '%unknown%' THEN 1 ELSE 0 END),

        -- baby_place_of_birth (facility/home/transit/other) - binary
        ('baby_place_of_birth - Facility', CASE WHEN src.baby_place_of_birth LIKE '%facility%' THEN 1 ELSE 0 END),
        ('baby_place_of_birth - Home', CASE WHEN src.baby_place_of_birth LIKE '%home%' THEN 1 ELSE 0 END),
        ('baby_place_of_birth - Transit', CASE WHEN src.baby_place_of_birth LIKE '%transit%' THEN 1 ELSE 0 END),
        ('baby_place_of_birth - Other', CASE WHEN src.baby_place_of_birth LIKE '%other%' THEN 1 ELSE 0 END),

        -- baby_birth_attendant (hw/tba/family/other) - binary
        ('baby_birth_attendant - Hw', CASE WHEN src.baby_birth_attendant LIKE '%hw%' THEN 1 ELSE 0 END),
        ('baby_birth_attendant - Tba', CASE WHEN src.baby_birth_attendant LIKE '%tba%' THEN 1 ELSE 0 END),
        ('baby_birth_attendant - Family', CASE WHEN src.baby_birth_attendant LIKE '%family%' THEN 1 ELSE 0 END),
        ('baby_birth_attendant - Other', CASE WHEN src.baby_birth_attendant LIKE '%other%' THEN 1 ELSE 0 END),

        -- baby_place_of_death (facility/home/transit/other) - binary
        ('baby_place_of_death - Facility', CASE WHEN src.baby_place_of_death LIKE '%facility%' THEN 1 ELSE 0 END),
        ('baby_place_of_death - Home', CASE WHEN src.baby_place_of_death LIKE '%home%' THEN 1 ELSE 0 END),
        ('baby_place_of_death - Transit', CASE WHEN src.baby_place_of_death LIKE '%transit%' THEN 1 ELSE 0 END),
        ('baby_place_of_death - Other', CASE WHEN src.baby_place_of_death LIKE '%other%' THEN 1 ELSE 0 END),

        -- baby_multiple_pregnancy (yes/no) - binary
        ('baby_multiple_pregnancy - Yes', CASE WHEN src.baby_multiple_pregnancy = 'yes' THEN 1 ELSE 0 END),
        ('baby_multiple_pregnancy - No', CASE WHEN src.baby_multiple_pregnancy = 'no' THEN 1 ELSE 0 END),

        -- baby_multiple_howmany (int) - numeric, null to 0
        ('baby_multiple_howmany', COALESCE(src.baby_multiple_howmany, 0)),

        -- other_babies_alive (yes/no) - binary
        ('other_babies_alive - Yes', CASE WHEN src.other_babies_alive = 'yes' THEN 1 ELSE 0 END),
        ('other_babies_alive - No', CASE WHEN src.other_babies_alive = 'no' THEN 1 ELSE 0 END),

        -- baby_death_registered (yes/no/dk) - binary
        ('baby_death_registered - Yes', CASE WHEN src.baby_death_registered = 'yes' THEN 1 ELSE 0 END),
        ('baby_death_registered - No', CASE WHEN src.baby_death_registered = 'no' THEN 1 ELSE 0 END),
        ('baby_death_registered - Dk', CASE WHEN src.baby_death_registered LIKE '%dk%' THEN 1 ELSE 0 END)
) AS unpivot(data_element, value)
WHERE value IS NOT NULL;