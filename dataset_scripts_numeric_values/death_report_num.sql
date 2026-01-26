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
    'death_report' AS dataset,
    unpivot.data_element,
    unpivot.value,
    date,
    chw_id,
    contact_facility_id AS facility_id,
    district_id AS district_id,
    region_id AS region,
    t_client_age AS patient_age_in_years,
    NULL AS patient_age_in_months,
    NULL AS patient_age_in_days,
    t_client_sex AS patient_sex,
    t_client_birth_date AS patient_dob,
    'cht' AS source_system,
    'death_report' AS source_form
FROM (
    SELECT
        uuid,
        date,
        chw_id,
        contact_facility_id,
        district_id,
        region_id,
        t_client_age,
        t_client_sex,
        t_client_birth_date,

        -- indicator columns
        LOWER(TRIM(death_details_patient_sex)) AS death_details_patient_sex,
        LOWER(TRIM(death_details_place_of_death)) AS death_details_place_of_death,
        LOWER(TRIM(death_details_death_manner)) AS death_details_death_manner,
        LOWER(TRIM(death_details_accident_type)) AS death_details_accident_type,
        LOWER(TRIM(death_details_two_weeks_onset_illness)) AS death_details_two_weeks_onset_illness
    FROM cht.mv_death_report_new
) src
CROSS JOIN LATERAL (
    VALUES
        -- death_details_patient_sex (female/male) - binary
        ('death_details_patient_sex - Female', CASE WHEN src.death_details_patient_sex LIKE '%female%' THEN 1 ELSE 0 END),
        ('death_details_patient_sex - Male', CASE WHEN src.death_details_patient_sex LIKE '%male%' THEN 1 ELSE 0 END),

        -- death_details_place_of_death (health_facility/home/other) - binary
        ('death_details_place_of_death - Health_facility', CASE WHEN src.death_details_place_of_death LIKE '%health_facility%' THEN 1 ELSE 0 END),
        ('death_details_place_of_death - Home', CASE WHEN src.death_details_place_of_death LIKE '%home%' THEN 1 ELSE 0 END),
        ('death_details_place_of_death - Other', CASE WHEN src.death_details_place_of_death LIKE '%other%' THEN 1 ELSE 0 END),

        -- death_details_death_manner (disease/accident/suicide/death_by_killing/others) - binary
        ('death_details_death_manner - Disease', CASE WHEN src.death_details_death_manner LIKE '%disease%' THEN 1 ELSE 0 END),
        ('death_details_death_manner - Accident', CASE WHEN src.death_details_death_manner LIKE '%accident%' THEN 1 ELSE 0 END),
        ('death_details_death_manner - Suicide', CASE WHEN src.death_details_death_manner LIKE '%suicide%' THEN 1 ELSE 0 END),
        ('death_details_death_manner - Death_by_killing', CASE WHEN src.death_details_death_manner LIKE '%death_by_killing%' THEN 1 ELSE 0 END),
        ('death_details_death_manner - Others', CASE WHEN src.death_details_death_manner LIKE '%others%' THEN 1 ELSE 0 END),

        -- death_details_accident_type (road_accident/animal_bites/fires) - binary
        ('death_details_accident_type - Road_accident', CASE WHEN src.death_details_accident_type LIKE '%road_accident%' THEN 1 ELSE 0 END),
        ('death_details_accident_type - Animal_bites', CASE WHEN src.death_details_accident_type LIKE '%animal_bites%' THEN 1 ELSE 0 END),
        ('death_details_accident_type - Fires', CASE WHEN src.death_details_accident_type LIKE '%fires%' THEN 1 ELSE 0 END),

        -- death_details_two_weeks_onset_illness (yes/no) - binary
        ('death_details_two_weeks_onset_illness - Yes', CASE WHEN src.death_details_two_weeks_onset_illness = 'yes' THEN 1 ELSE 0 END),
        ('death_details_two_weeks_onset_illness - No', CASE WHEN src.death_details_two_weeks_onset_illness = 'no' THEN 1 ELSE 0 END)
) AS unpivot(data_element, value)
WHERE value = 1;INSERT INTO cht.fact_cht_numeric_values (
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
    'death_report' AS dataset,
    unpivot.data_element,
    unpivot.value,
    date,
    chw_id,
    contact_facility_id AS facility_id,
    district_id AS district_id,
    region_id AS region,
    t_client_age AS patient_age_in_years,
    NULL AS patient_age_in_months,
    NULL AS patient_age_in_days,
    t_client_sex AS patient_sex,
    t_client_birth_date AS patient_dob,
    'cht' AS source_system,
    'death_report' AS source_form
FROM (
    SELECT
        uuid,
        date,
        chw_id,
        contact_facility_id,
        district_id,
        region_id,
        t_client_age,
        t_client_sex,
        t_client_birth_date,

        -- indicator columns
        LOWER(TRIM(death_details_patient_sex)) AS death_details_patient_sex,
        LOWER(TRIM(death_details_place_of_death)) AS death_details_place_of_death,
        LOWER(TRIM(death_details_death_manner)) AS death_details_death_manner,
        LOWER(TRIM(death_details_accident_type)) AS death_details_accident_type,
        LOWER(TRIM(death_details_two_weeks_onset_illness)) AS death_details_two_weeks_onset_illness
    FROM cht.mv_death_report_new
) src
CROSS JOIN LATERAL (
    VALUES
        -- death_details_patient_sex (female/male) - binary
        ('death_details_patient_sex - Female', CASE WHEN src.death_details_patient_sex LIKE '%female%' THEN 1 ELSE 0 END),
        ('death_details_patient_sex - Male', CASE WHEN src.death_details_patient_sex LIKE '%male%' THEN 1 ELSE 0 END),

        -- death_details_place_of_death (health_facility/home/other) - binary
        ('death_details_place_of_death - Health_facility', CASE WHEN src.death_details_place_of_death LIKE '%health_facility%' THEN 1 ELSE 0 END),
        ('death_details_place_of_death - Home', CASE WHEN src.death_details_place_of_death LIKE '%home%' THEN 1 ELSE 0 END),
        ('death_details_place_of_death - Other', CASE WHEN src.death_details_place_of_death LIKE '%other%' THEN 1 ELSE 0 END),

        -- death_details_death_manner (disease/accident/suicide/death_by_killing/others) - binary
        ('death_details_death_manner - Disease', CASE WHEN src.death_details_death_manner LIKE '%disease%' THEN 1 ELSE 0 END),
        ('death_details_death_manner - Accident', CASE WHEN src.death_details_death_manner LIKE '%accident%' THEN 1 ELSE 0 END),
        ('death_details_death_manner - Suicide', CASE WHEN src.death_details_death_manner LIKE '%suicide%' THEN 1 ELSE 0 END),
        ('death_details_death_manner - Death_by_killing', CASE WHEN src.death_details_death_manner LIKE '%death_by_killing%' THEN 1 ELSE 0 END),
        ('death_details_death_manner - Others', CASE WHEN src.death_details_death_manner LIKE '%others%' THEN 1 ELSE 0 END),

        -- death_details_accident_type (road_accident/animal_bites/fires) - binary
        ('death_details_accident_type - Road_accident', CASE WHEN src.death_details_accident_type LIKE '%road_accident%' THEN 1 ELSE 0 END),
        ('death_details_accident_type - Animal_bites', CASE WHEN src.death_details_accident_type LIKE '%animal_bites%' THEN 1 ELSE 0 END),
        ('death_details_accident_type - Fires', CASE WHEN src.death_details_accident_type LIKE '%fires%' THEN 1 ELSE 0 END),

        -- death_details_two_weeks_onset_illness (yes/no) - binary
        ('death_details_two_weeks_onset_illness - Yes', CASE WHEN src.death_details_two_weeks_onset_illness = 'yes' THEN 1 ELSE 0 END),
        ('death_details_two_weeks_onset_illness - No', CASE WHEN src.death_details_two_weeks_onset_illness = 'no' THEN 1 ELSE 0 END)
) AS unpivot(data_element, value)
WHERE value = 1;