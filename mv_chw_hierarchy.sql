SELECT cht.deps_save_and_drop_dependencies('cht', 'mv_chw_hierarchy');
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
        ), parish AS (
         SELECT cht_data.doc ->> '_id'::text AS parish_id,
            cht_data.doc ->> 'name'::text AS parish,
            cht_data.doc #>> '{parent,_id}'::text[] AS facility_id
           FROM dwh.cht_data
          WHERE cht_data.is_current = true AND (cht_data.doc ->> 'type'::text) = 'contact'::text AND (cht_data.doc ->> 'contact_type'::text) = 'c40-parish'::text
        ), facility AS (
         SELECT cht_data.doc ->> '_id'::text AS facility_id,
            cht_data.doc ->> 'name'::text AS facility_name,
            cht_data.doc ->> 'external_id'::text AS dhis2_facility_id,
            cht_data.doc #>> '{parent,_id}'::text[] AS district_id
           FROM dwh.cht_data
          WHERE cht_data.is_current = true AND (cht_data.doc ->> 'type'::text) = 'contact'::text AND (cht_data.doc ->> 'contact_type'::text) = 'c30-district_hospital'::text
        ), district AS (
         SELECT cht_data.doc ->> '_id'::text AS district_id,
            cht_data.doc ->> 'name'::text AS district,
            cht_data.doc #>> '{parent,_id}'::text[] AS region_id
           FROM dwh.cht_data
          WHERE cht_data.is_current = true AND (cht_data.doc ->> 'type'::text) = 'contact'::text AND (cht_data.doc ->> 'contact_type'::text) = 'c20-district'::text
        ), region AS (
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
    COALESCE(cf.facility_name, f.facility_name) AS facility_name,
    COALESCE(cf.dhis2_facility_id, f.dhis2_facility_id) AS dhis2_facility_id,
    COALESCE(cd.district_id, d.district_id) AS district_id,
    COALESCE(cd.district, d.district) AS district,
    COALESCE(cr.region_id, r.region_id) AS region_id,
    COALESCE(cr.region, r.region) AS region,
    CURRENT_TIMESTAMP AS last_refresh_date
   FROM users u
     LEFT JOIN vht_area v ON u.assigned_id = v.vht_area_id
     LEFT JOIN parish p ON v.parish_id = p.parish_id
     LEFT JOIN facility f ON p.facility_id = f.facility_id
     LEFT JOIN district d ON f.district_id = d.district_id
     LEFT JOIN region r ON d.region_id = r.region_id
     LEFT JOIN parish cp ON u.assigned_id = cp.parish_id
     LEFT JOIN facility cf ON cp.facility_id = cf.facility_id
     LEFT JOIN district cd ON cf.district_id = cd.district_id
     LEFT JOIN region cr ON cd.region_id = cr.region_id
WITH DATA;

SELECT cht.deps_restore_dependencies('cht', 'mv_chw_hierarchy');
-- 1. PRIMARY CHW LOOKUP (MUST HAVE - UNIQUE)
CREATE INDEX CONCURRENTLY idx_mv_chw_hierarchy_chw_id 
ON cht.mv_chw_hierarchy (chw_id);

-- 2. CHW + FACILITY (MUST HAVE - Most common filter)
CREATE INDEX CONCURRENTLY idx_mv_chw_hierarchy_chw_facility 
ON cht.mv_chw_hierarchy (chw_id, facility_id);

-- 3. CHW COVERING INDEX (MUST HAVE - 80% of joins covered)
CREATE INDEX CONCURRENTLY idx_mv_chw_hierarchy_chw_covering 
ON cht.mv_chw_hierarchy (chw_id) 
INCLUDE (role, chw_name, facility_name, dhis2_facility_id, district, region, phone, email);

-- 4. CHW + GEOGRAPHIC HIERARCHY (HIGH PRIORITY)
CREATE INDEX CONCURRENTLY idx_mv_chw_hierarchy_chw_geo 
ON cht.mv_chw_hierarchy (chw_id, region_id, district_id, facility_id, parish_id);

-- 5. CHW + DHIS2 FACILITY (HIGH PRIORITY - External reporting)
CREATE INDEX CONCURRENTLY idx_mv_chw_hierarchy_chw_dhis2 
ON cht.mv_chw_hierarchy (chw_id, dhis2_facility_id);

-- 6. CHW + ROLE (MEDIUM PRIORITY - Role-based queries)
CREATE INDEX CONCURRENTLY idx_mv_chw_hierarchy_chw_role 
ON cht.mv_chw_hierarchy (chw_id, role);

-- =====================================================
-- OPTIONAL: Facility-only indexes (if doing facility aggregates)
-- =====================================================

-- Facility + Role (for facility reporting without chw_id)
CREATE INDEX CONCURRENTLY idx_mv_chw_hierarchy_facility_role 
ON cht.mv_chw_hierarchy (facility_id, role, chw_id);
