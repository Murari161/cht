
-- cht.mv_chw_hierarchy_test source
cht.deps_save_and_drop_dependencies('cht', 'mv_chw_hierarchy');
DROP MATERIALIZED VIEW cht.mv_chw_hierarchy;
CREATE MATERIALIZED VIEW cht.mv_chw_hierarchy
TABLESPACE ts_report
AS WITH users AS (
         SELECT cht_data.doc ->> 'contact_id'::text AS chw_id,
            cht_data.doc ->> 'name'::text AS username,
            cht_data.doc ->> 'fullname'::text AS chw_name,
            cht_data.doc ->> 'phone'::text AS phone,
            cht_data.doc ->> 'email'::text AS email,
            (cht_data.doc -> 'facility_id'::text) ->> 0 AS assigned_id,
                CASE
                    WHEN (cht_data.doc -> 'roles'::text) = '["chew", "super_chew"]'::jsonb THEN 'SUPER CHEW'::text
                    WHEN (cht_data.doc -> 'roles'::text) = '["chew"]'::jsonb THEN 'CHEW'::text
                    WHEN (EXISTS ( SELECT 1
                       FROM jsonb_array_elements_text(cht_data.doc -> 'roles'::text) r_1(role)
                      WHERE r_1.role = 'supervisor'::text)) THEN 'SUPERVISOR'::text
                    WHEN (EXISTS ( SELECT 1
                       FROM jsonb_array_elements_text(cht_data.doc -> 'roles'::text) r_1(role)
                      WHERE r_1.role = 'chew'::text)) THEN 'CHEW'::text
                    WHEN (EXISTS ( SELECT 1
                       FROM jsonb_array_elements_text(cht_data.doc -> 'roles'::text) r_1(role)
                      WHERE r_1.role = 'vht'::text)) THEN 'VHT'::text
                    ELSE 'OTHER'::text
                END AS role
           FROM dwh.cht_data
          WHERE cht_data.is_current = true AND (cht_data.doc ->> 'type'::text) = 'user-settings'::text
        ), vht_area AS (
         SELECT cht_data.doc ->> '_id'::text AS vht_area_id,
            cht_data.doc ->> 'name'::text AS vht_area_name,
            cht_data.doc ->> 'county'::text AS county,
            cht_data.doc ->> 'sub_county'::text AS sub_county,
            cht_data.doc ->> 'village'::text AS village,
            cht_data.doc #>> '{parent,_id}'::text[] AS parish_id
           FROM dwh.cht_data
          WHERE cht_data.is_current = true AND (cht_data.doc ->> 'type'::text) = 'contact'::text AND (cht_data.doc ->> 'contact_type'::text) = 'c50-health_center'::text
        ), parish_cte AS (
         SELECT cht_data.doc ->> '_id'::text AS parish_id,
            cht_data.doc ->> 'name'::text AS parish,
            cht_data.doc #>> '{parent,_id}'::text[] AS facility_id
           FROM dwh.cht_data
          WHERE cht_data.is_current = true AND (cht_data.doc ->> 'type'::text) = 'contact'::text AND (cht_data.doc ->> 'contact_type'::text) = 'c40-parish'::text
        ), facility_cte AS (
         SELECT cht_data.doc ->> '_id'::text AS facility_id,
            cht_data.doc ->> 'name'::text AS facility,
            cht_data.doc ->> 'external_id'::text AS dhis2_facility_id,
            cht_data.doc #>> '{parent,_id}'::text[] AS district_id
           FROM dwh.cht_data
          WHERE cht_data.is_current = true AND (cht_data.doc ->> 'type'::text) = 'contact'::text AND (cht_data.doc ->> 'contact_type'::text) = 'c30-district_hospital'::text
        ), district_cte AS (
         SELECT cht_data.doc ->> '_id'::text AS district_id,
            cht_data.doc ->> 'name'::text AS district,
            cht_data.doc #>> '{parent,_id}'::text[] AS region_id
           FROM dwh.cht_data
          WHERE cht_data.is_current = true AND (cht_data.doc ->> 'type'::text) = 'contact'::text AND (cht_data.doc ->> 'contact_type'::text) = 'c20-district'::text
        ), region_cte AS (
         SELECT cht_data.doc ->> '_id'::text AS region_id,
            cht_data.doc ->> 'name'::text AS region
           FROM dwh.cht_data
          WHERE cht_data.is_current = true AND (cht_data.doc ->> 'type'::text) = 'contact'::text AND (cht_data.doc ->> 'contact_type'::text) = 'c10-region'::text
        )
 SELECT u.chw_id,
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
    COALESCE(cp.parish_id, p.parish_id) AS parish_id,
    COALESCE(cp.parish, p.parish) AS parish,
    COALESCE(cf.facility_id, f.facility_id) AS facility_id,
    COALESCE(cf.facility, f.facility) AS facility,
    COALESCE(cf.dhis2_facility_id, f.dhis2_facility_id) AS dhis2_facility_id,
    COALESCE(cd.district_id, d.district_id) AS district_id,
    COALESCE(cd.district, d.district) AS district,
    COALESCE(cr.region_id, r.region_id) AS region_id,
    COALESCE(cr.region, r.region) AS region,
    CURRENT_TIMESTAMP AS last_refresh_date
   FROM users u
     LEFT JOIN vht_area v ON u.assigned_id = v.vht_area_id
     LEFT JOIN parish_cte p ON v.parish_id = p.parish_id
     LEFT JOIN facility_cte f ON p.facility_id = f.facility_id
     LEFT JOIN district_cte d ON f.district_id = d.district_id
     LEFT JOIN region_cte r ON d.region_id = r.region_id
     LEFT JOIN parish_cte cp ON u.assigned_id = cp.parish_id
     LEFT JOIN facility_cte cf ON cp.facility_id = cf.facility_id
     LEFT JOIN district_cte cd ON cf.district_id = cd.district_id
     LEFT JOIN region_cte cr ON cd.region_id = cr.region_id
WITH DATA;

CREATE INDEX idx_mv_chw_hierarchy_chw_covering ON cht.mv_chw_hierarchy USING btree (chw_id) INCLUDE (role, chw_name, facility, dhis2_facility_id, district, region, phone, email);
CREATE INDEX idx_mv_chw_hierarchy_district_role ON cht.mv_chw_hierarchy USING btree (district, role);
CREATE INDEX idx_mv_chw_hierarchy_vht_lookup ON cht.mv_chw_hierarchy USING btree (role, district, chw_id) INCLUDE (facility, dhis2_facility_id, chw_name, village);