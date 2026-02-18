CREATE MATERIALIZED VIEW cht.mv_chw_hierarchy --32106, 1 second
TABLESPACE ts_report
AS

WITH users AS (
    SELECT
        doc ->> 'contact_id'      AS chw_id,
        doc ->> 'name'            AS username,
        doc ->> 'fullname'        AS chw_name,
        doc ->> 'phone'           AS phone,
        doc ->> 'email'           AS email,
        (doc -> 'facility_id') ->> 0 AS vht_area_id,

        CASE
            WHEN (doc -> 'roles') = '["chew","super_chew"]'::jsonb THEN 'SUPER CHEW'
            WHEN (doc -> 'roles') = '["chew"]'::jsonb THEN 'CHEW'
            WHEN EXISTS (
                SELECT 1
                FROM jsonb_array_elements_text(doc -> 'roles') r(role)
                WHERE r.role = 'chew'
            ) THEN 'CHEW'
            WHEN EXISTS (
                SELECT 1
                FROM jsonb_array_elements_text(doc -> 'roles') r(role)
                WHERE r.role = 'vht'
            ) THEN 'VHT'
            ELSE 'OTHER'
        END AS role

    FROM dwh.cht_data
    WHERE doc ->> 'type' = 'user-settings'
),

vht_area AS (
    SELECT
        doc ->> '_id'                         AS vht_area_id,
        doc ->> 'name'                        AS vht_area_name,
        doc ->> 'county'                      AS county,
        doc ->> 'sub_county'                  AS sub_county,
        doc ->> 'village'                     AS village,
        doc #>> '{parent,_id}'                AS parish_id
    FROM dwh.cht_data
    WHERE doc ->> 'type' = 'contact'
      AND doc ->> 'contact_type' = 'c50-health_center'
),

parish AS (
    SELECT
        doc ->> '_id'                 AS parish_id,
        doc ->> 'name'                AS parish,
        doc #>> '{parent,_id}'        AS facility_id
    FROM dwh.cht_data
    WHERE doc ->> 'type' = 'contact'
      AND doc ->> 'contact_type' = 'c40-parish'
),

facility AS (
    SELECT
        doc ->> '_id'                 AS facility_id,
        doc ->> 'name'                AS facility_name,
        doc ->> 'external_id'         AS dhis2_facility_id,
        doc #>> '{parent,_id}'        AS district_id
    FROM dwh.cht_data
    WHERE doc ->> 'type' = 'contact'
      AND doc ->> 'contact_type' = 'c30-district_hospital'
),

district AS (
    SELECT
        doc ->> '_id'                 AS district_id,
        doc ->> 'name'                AS district,
        doc #>> '{parent,_id}'        AS region_id
    FROM dwh.cht_data
    WHERE doc ->> 'type' = 'contact'
      AND doc ->> 'contact_type' = 'c20-district'
),

region AS (
    SELECT
        doc ->> '_id'                 AS region_id,
        doc ->> 'name'                AS region
    FROM dwh.cht_data
    WHERE doc ->> 'type' = 'contact'
      AND doc ->> 'contact_type' = 'c10-region'
)

SELECT
    u.chw_id,
    u.username,
    u.chw_name,
    u.phone,
    u.email,
    u.role,

    v.vht_area_id,
    v.vht_area_name,
    v.county,
    v.sub_county,
    v.village,

    p.parish_id,
    p.parish,

    f.facility_id,
    f.facility_name,
    f.dhis2_facility_id,

    d.district_id,
    d.district,

    r.region_id,
    r.region,
    CURRENT_TIMESTAMP AS last_refersh_date

FROM users u
LEFT JOIN vht_area v   ON u.vht_area_id = v.vht_area_id
LEFT JOIN parish p     ON v.parish_id = p.parish_id
LEFT JOIN facility f   ON p.facility_id = f.facility_id
LEFT JOIN district d   ON f.district_id = d.district_id
LEFT JOIN region r     ON d.region_id = r.region_id
WITH DATA;
