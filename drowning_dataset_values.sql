INSERT INTO cht.drowning_long_table_values (
    uuid,
    dataset,
    data_element,
    value,
    date,
    chw_id,
    facility_id,
    district_id,
    age,
    source_system,
    source_form
)
SELECT
    uuid,
    'drowning' AS dataset,
    unpivot.data_element,
    unpivot.value,
    date::date AS date,
    chw_id AS chw_id,
    facility_id,
    district_id,
    age,
    source_system,
    source_form
FROM (
    SELECT
        uuid,
        chw_id,
        date,
        facility_id,
        district_id,
        age,
        source_system,
        source_form,
        incident_time,
        incident_waterbody,
        incident_type,
        risk_activity,
        risk_cause,
        risk_supervision,
        risk_victim,
        risk_intoxicated,
        rescue_attempts,
        rescue_firstaid
    FROM cht.mv_drowning_workflow
) src
CROSS JOIN LATERAL (
    VALUES
        ('incident_time',       src.incident_time),
        ('incident_waterbody',  src.incident_waterbody),
        ('incident_type',       src.incident_type),
        ('risk_activity',       src.risk_activity),
        ('risk_cause',          src.risk_cause),
        ('risk_supervision',    src.risk_supervision),
        ('risk_victim',         src.risk_victim),
        ('risk_intoxicated',    src.risk_intoxicated),
        ('rescue_attempts',     src.rescue_attempts),
        ('rescue_firstaid',     src.rescue_firstaid)
) AS unpivot(data_element, value)
WHERE unpivot.value IS NOT NULL
  AND TRIM(unpivot.value) <> '';
