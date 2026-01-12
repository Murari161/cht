INSERT INTO cht.drowning_long_table (
    uuid,
    dataset,
    data_element,
    category_option_combo,
    value,
    date,
    chw_id
)
SELECT
    uuid,
    'drowning' AS dataset,
    data_element,
    category_option_combo,
    value,
    date::date AS reported,
    inputs_contact_id AS chw_id
FROM (
    SELECT
        uuid,
        date::date,
        inputs_contact_id,
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
        ('incident_time', 'morning',      CASE WHEN src.incident_time LIKE '%morning%'      THEN 1 ELSE 0 END),
        ('incident_time', 'afternoon',    CASE WHEN src.incident_time LIKE '%afternoon%'    THEN 1 ELSE 0 END),
        ('incident_time', 'evening',      CASE WHEN src.incident_time LIKE '%evening%'      THEN 1 ELSE 0 END),
        ('incident_time', 'nighttime',    CASE WHEN src.incident_time LIKE '%night%'        THEN 1 ELSE 0 END),

        -- incident_waterbody
        ('incident_waterbody', 'lake',             CASE WHEN src.incident_waterbody LIKE '%lake%'            THEN 1 ELSE 0 END),
        ('incident_waterbody', 'river',            CASE WHEN src.incident_waterbody LIKE '%river%'           THEN 1 ELSE 0 END),
        ('incident_waterbody', 'pond',             CASE WHEN src.incident_waterbody LIKE '%pond%'            THEN 1 ELSE 0 END),
        ('incident_waterbody', 'valley dam',       CASE WHEN src.incident_waterbody LIKE '%valley%'          THEN 1 ELSE 0 END),
        ('incident_waterbody', 'swimming pool',    CASE WHEN src.incident_waterbody LIKE '%pool%'            THEN 1 ELSE 0 END),
        ('incident_waterbody', 'unprotected well', CASE WHEN src.incident_waterbody LIKE '%well%'            THEN 1 ELSE 0 END),
        ('incident_waterbody', 'stream',           CASE WHEN src.incident_waterbody LIKE '%stream%'          THEN 1 ELSE 0 END),
        ('incident_waterbody', 'swamp',            CASE WHEN src.incident_waterbody LIKE '%swamp%'           THEN 1 ELSE 0 END),
        ('incident_waterbody', 'basin / bucket',   CASE WHEN src.incident_waterbody LIKE '%basin%' OR src.incident_waterbody LIKE '%bucket%' THEN 1 ELSE 0 END),
        ('incident_waterbody', 'floods',           CASE WHEN src.incident_waterbody LIKE '%flood%'           THEN 1 ELSE 0 END),
        ('incident_waterbody', 'other',            CASE WHEN src.incident_waterbody LIKE '%other%'           THEN 1 ELSE 0 END),

        -- incident_type
        ('incident_type', 'mass casualty incident', CASE WHEN src.incident_type LIKE '%mass%' THEN 1 ELSE 0 END),
        ('incident_type', 'single drowning incident', CASE WHEN src.incident_type LIKE '%single%' THEN 1 ELSE 0 END),

        -- risk_activity
        ('risk_activity', 'fetching water',        CASE WHEN src.risk_activity LIKE '%fetch%'  THEN 1 ELSE 0 END),
        ('risk_activity', 'swimming',              CASE WHEN src.risk_activity LIKE '%swim%'   THEN 1 ELSE 0 END),
        ('risk_activity', 'bathing',               CASE WHEN src.risk_activity LIKE '%bath%'   THEN 1 ELSE 0 END),
        ('risk_activity', 'watering animals',      CASE WHEN src.risk_activity LIKE '%animal%' THEN 1 ELSE 0 END),
        ('risk_activity', 'fishing',               CASE WHEN src.risk_activity LIKE '%fish%'   THEN 1 ELSE 0 END),
        ('risk_activity', 'moving on water',       CASE WHEN src.risk_activity LIKE '%move%'   THEN 1 ELSE 0 END),
        ('risk_activity', 'other activity (specify)', CASE WHEN src.risk_activity LIKE '%other%' THEN 1 ELSE 0 END),

        -- risk_cause
        ('risk_cause', 'intentional',   CASE WHEN src.risk_cause LIKE '%intent%' THEN 1 ELSE 0 END),
        ('risk_cause', 'unintentional', CASE WHEN src.risk_cause LIKE '%unintent%' THEN 1 ELSE 0 END),
        ('risk_cause', 'don’t know',    CASE WHEN src.risk_cause LIKE '%don%' OR src.risk_cause LIKE '%dont%' THEN 1 ELSE 0 END),

        -- risk_supervision
        ('risk_supervision', 'yes',      CASE WHEN src.risk_supervision = 'yes' THEN 1 ELSE 0 END),
        ('risk_supervision', 'no',       CASE WHEN src.risk_supervision = 'no'  THEN 1 ELSE 0 END),
        ('risk_supervision', 'dont_know',CASE WHEN src.risk_supervision LIKE '%dont%' THEN 1 ELSE 0 END),

        -- risk_victim
        ('risk_victim', 'yes',      CASE WHEN src.risk_victim = 'yes' THEN 1 ELSE 0 END),
        ('risk_victim', 'no',       CASE WHEN src.risk_victim = 'no'  THEN 1 ELSE 0 END),
        ('risk_victim', 'dont_know',CASE WHEN src.risk_victim LIKE '%dont%' THEN 1 ELSE 0 END),

        -- risk_intoxicated
        ('risk_intoxicated', 'yes',      CASE WHEN src.risk_intoxicated = 'yes' THEN 1 ELSE 0 END),
        ('risk_intoxicated', 'no',       CASE WHEN src.risk_intoxicated = 'no'  THEN 1 ELSE 0 END),
        ('risk_intoxicated', 'dont_know',CASE WHEN src.risk_intoxicated LIKE '%dont%' THEN 1 ELSE 0 END),

        -- rescue_attempts
        ('rescue_attempts', 'yes',       CASE WHEN src.rescue_attempts = 'yes' THEN 1 ELSE 0 END),
        ('rescue_attempts', 'no',        CASE WHEN src.rescue_attempts = 'no'  THEN 1 ELSE 0 END),
        ('rescue_attempts', 'don''t_know', CASE WHEN src.rescue_attempts LIKE '%don''%' OR src.rescue_attempts LIKE '%dont%' THEN 1 ELSE 0 END),

        -- rescue_firstaid
        ('rescue_firstaid', 'yes',       CASE WHEN src.rescue_firstaid = 'yes' THEN 1 ELSE 0 END),
        ('rescue_firstaid', 'no',        CASE WHEN src.rescue_firstaid = 'no'  THEN 1 ELSE 0 END),
        ('rescue_firstaid', 'dont_know', CASE WHEN src.rescue_firstaid LIKE '%dont%' THEN 1 ELSE 0 END)
) AS unpivot(data_element, category_option_combo, value)
WHERE value = 1;
