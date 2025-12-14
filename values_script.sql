INSERT INTO cht.drowning_long_table (
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
    uuid,
    'drowning' as theme,
    'drowning' AS dataset,
    data_element,
    value,
    date::date AS reported,
    inputs_contact_id AS chw_id,    
    contact_facility_id AS facility_id,
    district_id AS district_id,
    region_id AS region,
    patient_age_in_years,
    patient_age_in_months,
    patient_age_in_days,
    inputs_contact_sex AS patient_sex,
    inputs_contact_date_of_birth AS patient_dob,
    'cht' AS source_system,
    'fp_follow_up' AS source_form
FROM (
    SELECT
        uuid,
        date::date,
        inputs_contact_id,        
        contact_facility_id,
        district_id,
        region_id,
        patient_age_in_years,
        inputs_contact_sex,
        inputs_contact_date_of_birth,
        --indicator columns
        LOWER(TRIM(incident_time)) AS incident_time,
        LOWER(TRIM(incident_waterbody)) AS incident_waterbody,
        LOWER(TRIM(incident_type)) AS incident_type,
        LOWER(TRIM(risk_activity)) AS risk_activity,
        LOWER(TRIM(risk_cause)) AS risk_cause,
        LOWER(TRIM(risk_supervision)) AS risk_supervision,
        LOWER(TRIM(risk_victim)) AS risk_victim,
        LOWER(TRIM(risk_intoxicated)) AS risk_intoxicated,
        LOWER(TRIM(rescue_attempts)) AS rescue_attempts,
        LOWER(TRIM(rescue_firstaid)) AS rescue_firstaid
    FROM cht.mv_drowning_workflow
) src
CROSS JOIN LATERAL (
    VALUES
        -- incident_time
        ('incident_time_morning',      CASE WHEN src.incident_time LIKE '%morning%'      THEN 1 ELSE 0 END),
        ('incident_time_afternoon',    CASE WHEN src.incident_time LIKE '%afternoon%'    THEN 1 ELSE 0 END),
        ('incident_time_evening',      CASE WHEN src.incident_time LIKE '%evening%'      THEN 1 ELSE 0 END),
        ('incident_time_nighttime',    CASE WHEN src.incident_time LIKE '%night%'        THEN 1 ELSE 0 END),

        -- incident_waterbody
        ('incident_waterbody_lake',             CASE WHEN src.incident_waterbody LIKE '%lake%'            THEN 1 ELSE 0 END),
        ('incident_waterbody_river',            CASE WHEN src.incident_waterbody LIKE '%river%'           THEN 1 ELSE 0 END),
        ('incident_waterbody_pond',             CASE WHEN src.incident_waterbody LIKE '%pond%'            THEN 1 ELSE 0 END),
        ('incident_waterbody_valley dam',       CASE WHEN src.incident_waterbody LIKE '%valley%'          THEN 1 ELSE 0 END),
        ('incident_waterbody_swimming pool',    CASE WHEN src.incident_waterbody LIKE '%pool%'            THEN 1 ELSE 0 END),
        ('incident_waterbody_unprotected well', CASE WHEN src.incident_waterbody LIKE '%well%'            THEN 1 ELSE 0 END),
        ('incident_waterbody_stream',           CASE WHEN src.incident_waterbody LIKE '%stream%'          THEN 1 ELSE 0 END),
        ('incident_waterbody_swamp',            CASE WHEN src.incident_waterbody LIKE '%swamp%'           THEN 1 ELSE 0 END),
        ('incident_waterbody_basin / bucket',   CASE WHEN src.incident_waterbody LIKE '%basin%' OR src.incident_waterbody LIKE '%bucket%' THEN 1 ELSE 0 END),
        ('incident_waterbody_floods',           CASE WHEN src.incident_waterbody LIKE '%flood%'           THEN 1 ELSE 0 END),
        ('incident_waterbody_other',            CASE WHEN src.incident_waterbody LIKE '%other%'           THEN 1 ELSE 0 END),

        -- incident_type
        ('incident_type_mass casualty incident', CASE WHEN src.incident_type LIKE '%mass%' THEN 1 ELSE 0 END),
        ('incident_type_single drowning incident', CASE WHEN src.incident_type LIKE '%single%' THEN 1 ELSE 0 END),

        -- risk_activity
        ('risk_activity_fetching water',        CASE WHEN src.risk_activity LIKE '%fetch%'  THEN 1 ELSE 0 END),
        ('risk_activity_swimming',              CASE WHEN src.risk_activity LIKE '%swim%'   THEN 1 ELSE 0 END),
        ('risk_activity_bathing',               CASE WHEN src.risk_activity LIKE '%bath%'   THEN 1 ELSE 0 END),
        ('risk_activity_watering animals',      CASE WHEN src.risk_activity LIKE '%animal%' THEN 1 ELSE 0 END),
        ('risk_activity_fishing',               CASE WHEN src.risk_activity LIKE '%fish%'   THEN 1 ELSE 0 END),
        ('risk_activity_moving on water',       CASE WHEN src.risk_activity LIKE '%move%'   THEN 1 ELSE 0 END),
        ('risk_activity_other activity (specify)', CASE WHEN src.risk_activity LIKE '%other%' THEN 1 ELSE 0 END),

        -- risk_cause
        ('risk_cause_intentional',   CASE WHEN src.risk_cause LIKE '%intent%' THEN 1 ELSE 0 END),
        ('risk_cause_unintentional', CASE WHEN src.risk_cause LIKE '%unintent%' THEN 1 ELSE 0 END),
        ('risk_cause_don’t know',    CASE WHEN src.risk_cause LIKE '%don%' OR src.risk_cause LIKE '%dont%' THEN 1 ELSE 0 END),

        -- risk_supervision
        ('risk_supervision_yes',      CASE WHEN src.risk_supervision = 'yes' THEN 1 ELSE 0 END),
        ('risk_supervision_no',       CASE WHEN src.risk_supervision = 'no'  THEN 1 ELSE 0 END),
        ('risk_supervision_dont_know',CASE WHEN src.risk_supervision LIKE '%dont%' THEN 1 ELSE 0 END),

        -- risk_victim
        ('risk_victim_yes',      CASE WHEN src.risk_victim = 'yes' THEN 1 ELSE 0 END),
        ('risk_victim_no',       CASE WHEN src.risk_victim = 'no'  THEN 1 ELSE 0 END),
        ('risk_victim_dont_know',CASE WHEN src.risk_victim LIKE '%dont%' THEN 1 ELSE 0 END),

        -- risk_intoxicated
        ('risk_intoxicated_yes',      CASE WHEN src.risk_intoxicated = 'yes' THEN 1 ELSE 0 END),
        ('risk_intoxicated_no',       CASE WHEN src.risk_intoxicated = 'no'  THEN 1 ELSE 0 END),
        ('risk_intoxicated_dont_know',CASE WHEN src.risk_intoxicated LIKE '%dont%' THEN 1 ELSE 0 END),

        -- rescue_attempts
        ('rescue_attempts_yes',       CASE WHEN src.rescue_attempts = 'yes' THEN 1 ELSE 0 END),
        ('rescue_attempts_no',        CASE WHEN src.rescue_attempts = 'no'  THEN 1 ELSE 0 END),
        ('rescue_attempts_don''t_know', CASE WHEN src.rescue_attempts LIKE '%don''%' OR src.rescue_attempts LIKE '%dont%' THEN 1 ELSE 0 END),

        -- rescue_firstaid
        ('rescue_firstaid_yes',       CASE WHEN src.rescue_firstaid = 'yes' THEN 1 ELSE 0 END),
        ('rescue_firstaid_no',        CASE WHEN src.rescue_firstaid = 'no'  THEN 1 ELSE 0 END),
        ('rescue_firstaid_dont_know', CASE WHEN src.rescue_firstaid LIKE '%dont%' THEN 1 ELSE 0 END)
) AS unpivot(data_element, value)
WHERE value = 1;
