-- Create the materialized view
CREATE MATERIALIZED VIEW cht.mv_chw_hierarchy_2 AS
SELECT
    -- From user-settings
    u.doc ->> 'name' AS username,
    u.doc ->> 'email' AS email,
    u.doc ->> 'phone' AS phone,
    u.doc ->> 'fullname' AS chw_name,
    CASE
        WHEN (u.doc -> 'roles') = '["chew", "super_chew"]'::jsonb THEN 'SUPER CHEW'::text
        WHEN (u.doc -> 'roles') = '["chew"]'::jsonb THEN 'CHEW'::text
        WHEN EXISTS (
            SELECT 1
            FROM jsonb_array_elements_text(u.doc -> 'roles') r(role)
            WHERE r.role = 'chew'::text
        ) THEN 'CHEW'::text
        WHEN EXISTS (
            SELECT 1
            FROM jsonb_array_elements_text(u.doc -> 'roles') r(role)
            WHERE r.role = 'vht'::text
        ) THEN 'VHT'::text
        ELSE 'OTHER'::text
    END AS role,
    (u.doc -> 'facility_id' ->> 0) AS vht_area_id,
    
    -- From c50-health_center
    c50.doc ->> 'name' AS vht_area_name,
    c50.doc ->> 'county' AS county,
    c50.doc ->> 'village' AS village,
    c50.doc ->> 'sub_county' AS sub_county,
    
    -- From c40-parish
    c40.doc ->> 'name' AS parish,
    c40.doc ->> '_id' AS parish_id,  -- Assuming this aligns with c30's _id
    
    -- From c30-district_hospital
    c30.doc ->> 'name' AS facility_name,
    c30.doc ->> 'external_id' AS dhis2_facility_id,
    
    -- From c20-district
    c20.doc ->> 'name' AS district,
    c20.doc ->> '_id' AS district_id,
    
    -- From c10-region
    c10.doc ->> 'name' AS region,
    c10.doc ->> '_id' AS region_id
FROM
    dwh.cht_data u
JOIN
    dwh.cht_data c50 ON (u.doc -> 'facility_id' ->> 0) = (c50.doc ->> '_id')
    AND c50.doc ->> 'type' = 'contact'
    AND c50.doc ->> 'contact_type' = 'c50-health_center'
JOIN
    dwh.cht_data c40 ON (c50.doc -> 'parent' ->> '_id') = (c40.doc ->> '_id')
    AND c40.doc ->> 'type' = 'contact'
    AND c40.doc ->> 'contact_type' = 'c40-parish'
JOIN
    dwh.cht_data c30 ON (c40.doc -> 'parent' ->> '_id') = (c30.doc ->> '_id')
    AND c30.doc ->> 'type' = 'contact'
    AND c30.doc ->> 'contact_type' = 'c30-district_hospital'
JOIN
    dwh.cht_data c20 ON (c30.doc -> 'parent' ->> '_id') = (c20.doc ->> '_id')
    AND c20.doc ->> 'type' = 'contact'
    AND c20.doc ->> 'contact_type' = 'c20-district'
JOIN
    dwh.cht_data c10 ON (c20.doc -> 'parent' ->> '_id') = (c10.doc ->> '_id')
    AND c10.doc ->> 'type' = 'contact'
    AND c10.doc ->> 'contact_type' = 'c10-region'
WHERE
    u.doc ->> 'type' = 'user-settings';

-- Optional: Create an index for better query performance on the view
CREATE INDEX idx_combined_view_username ON dwh.combined_view (username);
-- Add more indexes as needed based on common query patterns