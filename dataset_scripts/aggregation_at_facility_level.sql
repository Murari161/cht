CREATE TABLE cht.fact_facility_aggregates (
    facility_id text NOT NULL,
    theme text NOT NULL,
    data_element text NOT NULL,
    year_month text NOT NULL,  -- e.g., '2023-10' from EXTRACT
    total_occurrences bigint DEFAULT 0,  -- SUM of value (counts 1s)
    unique_patients bigint DEFAULT 0,    -- COUNT DISTINCT uuid
    avg_patient_age_years numeric,       -- AVG patient_age_in_years
    last_updated timestamp DEFAULT now(),
    PRIMARY KEY (facility_id, theme, data_element, year_month)
);


TRUNCATE TABLE cht.fact_facility_aggregates;  -- Or use INSERT with ON CONFLICT for incremental updates

INSERT INTO cht.fact_facility_aggregates (
    facility_id,
    theme,
    data_element,
    year_month,
    total_occurrences,
    unique_patients,
    avg_patient_age_years
)
SELECT
    facility_id,
    theme,
    data_element,
    TO_CHAR(date, 'YYYY-MM') AS year_month,  -- Monthly bucket; change to 'YYYY' for yearly
    SUM(value)::bigint AS total_occurrences,  -- Sum of 1s = count of occurrences
    COUNT(DISTINCT uuid)::bigint AS unique_patients,
    ROUND(AVG(patient_age_in_years), 2) AS avg_patient_age_years
FROM cht.fact_cht_values
WHERE value = 1  -- Only include rows where the indicator is true (though fact table already filters this)
  AND facility_id IS NOT NULL
  AND theme IS NOT NULL
GROUP BY facility_id, theme, data_element, TO_CHAR(date, 'YYYY-MM');