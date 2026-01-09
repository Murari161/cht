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
    'drowning' AS theme,
    'drowning_workflow' AS dataset,
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
    'drowning_workflow' AS source_form
FROM (
    SELECT
        doc_id,
        date,
        chw_id,
        facility_id,
        district,
        region,

        -- indicator columns
        LOWER(TRIM(time)) AS time,
        LOWER(TRIM(waterbody)) AS waterbody,
        LOWER(TRIM(type)) AS type,
        LOWER(TRIM(activity)) AS activity,
        LOWER(TRIM(cause)) AS cause,
        LOWER(TRIM(victim)) AS victim,
        LOWER(TRIM(intoxicated)) AS intoxicated,
        LOWER(TRIM(attempts)) AS attempts,
        LOWER(TRIM(firstaid)) AS firstaid,
        LOWER(TRIM(outcome)) AS outcome
    FROM report.mv_drowning
) src
CROSS JOIN LATERAL (
    VALUES
        -- time (Morning/Afternoon/Evening/Nighttime)
        ('time - Morning', CASE WHEN src.time LIKE '%morning%' THEN 1 ELSE 0 END),
        ('time - Afternoon', CASE WHEN src.time LIKE '%afternoon%' THEN 1 ELSE 0 END),
        ('time - Evening', CASE WHEN src.time LIKE '%evening%' THEN 1 ELSE 0 END),
        ('time - Nighttime', CASE WHEN src.time LIKE '%night%' THEN 1 ELSE 0 END),

        -- waterbody (Lake/River/Pond/Valley dam/Swimming pool/Unprotected well/Stream/Swamp/"Basin / bucket"/Floods/"Other (specif")
        ('waterbody - Lake', CASE WHEN src.waterbody LIKE '%lake%' THEN 1 ELSE 0 END),
        ('waterbody - River', CASE WHEN src.waterbody LIKE '%river%' THEN 1 ELSE 0 END),
        ('waterbody - Pond', CASE WHEN src.waterbody LIKE '%pond%' THEN 1 ELSE 0 END),
        ('waterbody - Valley dam', CASE WHEN src.waterbody LIKE '%valley%' THEN 1 ELSE 0 END),
        ('waterbody - Swimming pool', CASE WHEN src.waterbody LIKE '%pool%' THEN 1 ELSE 0 END),
        ('waterbody - Unprotected well', CASE WHEN src.waterbody LIKE '%well%' THEN 1 ELSE 0 END),
        ('waterbody - Stream', CASE WHEN src.waterbody LIKE '%stream%' THEN 1 ELSE 0 END),
        ('waterbody - Swamp', CASE WHEN src.waterbody LIKE '%swamp%' THEN 1 ELSE 0 END),
        ('waterbody - Basin / bucket', CASE WHEN src.waterbody LIKE '%basin%' OR src.waterbody LIKE '%bucket%' THEN 1 ELSE 0 END),
        ('waterbody - Floods', CASE WHEN src.waterbody LIKE '%flood%' THEN 1 ELSE 0 END),
        ('waterbody - Other', CASE WHEN src.waterbody LIKE '%other%' THEN 1 ELSE 0 END),

        -- type ("Mass casualty incident (more than two people involved) "/"Single drowning incident (one to two people)")
        ('type - Mass casualty incident', CASE WHEN src.type LIKE '%mass%' THEN 1 ELSE 0 END),
        ('type - Single drowning incident', CASE WHEN src.type LIKE '%single%' THEN 1 ELSE 0 END),

        -- activity (Fetching water/Swimming/Bathing/Watering animals/Fishing/Moving on water/Other activity (specify))
        ('activity - Fetching water', CASE WHEN src.activity LIKE '%fetch%' THEN 1 ELSE 0 END),
        ('activity - Swimming', CASE WHEN src.activity LIKE '%swim%' THEN 1 ELSE 0 END),
        ('activity - Bathing', CASE WHEN src.activity LIKE '%bath%' THEN 1 ELSE 0 END),
        ('activity - Watering animals', CASE WHEN src.activity LIKE '%animal%' THEN 1 ELSE 0 END),
        ('activity - Fishing', CASE WHEN src.activity LIKE '%fish%' THEN 1 ELSE 0 END),
        ('activity - Moving on water', CASE WHEN src.activity LIKE '%move%' THEN 1 ELSE 0 END),
        ('activity - Other activity', CASE WHEN src.activity LIKE '%other%' THEN 1 ELSE 0 END),

        -- cause (Intentional/Unintentional/Don’t know)
        ('cause - Intentional', CASE WHEN src.cause LIKE '%intent%' THEN 1 ELSE 0 END),
        ('cause - Unintentional', CASE WHEN src.cause LIKE '%unintent%' THEN 1 ELSE 0 END),
        ('cause - Don’t know', CASE WHEN src.cause LIKE '%don%' OR src.cause LIKE '%dont%' THEN 1 ELSE 0 END),

        -- victim (yes/no/dont_know)
        ('victim - Yes', CASE WHEN src.victim = 'yes' THEN 1 ELSE 0 END),
        ('victim - No', CASE WHEN src.victim = 'no' THEN 1 ELSE 0 END),
        ('victim - Dont_know', CASE WHEN src.victim LIKE '%dont%' THEN 1 ELSE 0 END),

        -- intoxicated (yes/no/dont_know)
        ('intoxicated - Yes', CASE WHEN src.intoxicated = 'yes' THEN 1 ELSE 0 END),
        ('intoxicated - No', CASE WHEN src.intoxicated = 'no' THEN 1 ELSE 0 END),
        ('intoxicated - Dont_know', CASE WHEN src.intoxicated LIKE '%dont%' THEN 1 ELSE 0 END),

        -- attempts (yes/no/don’t_know)
        ('attempts - Yes', CASE WHEN src.attempts = 'yes' THEN 1 ELSE 0 END),
        ('attempts - No', CASE WHEN src.attempts = 'no' THEN 1 ELSE 0 END),
        ('attempts - Don’t_know', CASE WHEN src.attempts LIKE '%don%' OR src.attempts LIKE '%dont%' THEN 1 ELSE 0 END),

        -- firstaid (yes/no/dont_know)
        ('firstaid - Yes', CASE WHEN src.firstaid = 'yes' THEN 1 ELSE 0 END),
        ('firstaid - No', CASE WHEN src.firstaid = 'no' THEN 1 ELSE 0 END),
        ('firstaid - Dont_know', CASE WHEN src.firstaid LIKE '%dont%' THEN 1 ELSE 0 END),

        -- outcome (Victim died/Victim survive)
        ('outcome - Victim died', CASE WHEN src.outcome LIKE '%died%' THEN 1 ELSE 0 END),
        ('outcome - Victim survive', CASE WHEN src.outcome LIKE '%survive%' THEN 1 ELSE 0 END)
) AS unpivot(data_element, value)
WHERE value = 1;