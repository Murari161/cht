-- cht.mv_cht_users_new source

CREATE MATERIALIZED VIEW cht.mv_cht_users_new
AS WITH base AS (
         SELECT cht_data.doc,
            cht_data.doc ->> '_id'::text AS uuid,
            cht_data.doc ->> 'type'::text AS type,
            cht_data.doc ->> 'contact_type'::text AS contact_type,
            cht_data.doc ->> 'name'::text AS name,
            cht_data.doc ->> 'phone'::text AS phone,
            cht_data.doc ->> 'phone2'::text AS phone2,
            cht_data.doc ->> 'date_of_birth'::text AS date_of_birth,
            cht_data.doc ->> 'sex'::text AS sex,
            cht_data.doc ->> 'external_id'::text AS external_id,
            cht_data.doc ->> 'reported_date'::text AS reported_date,
            cht_data.doc #>> '{contact,_id}'::text[] AS contact_id,
            cht_data.doc #>> '{parent,_id}'::text[] AS parent_id,
            cht_data.doc #>> '{parent,parent,_id}'::text[] AS grandparent_id,
            cht_data.doc -> 'roles'::text AS roles,
            cht_data.doc ->> 'sub_district'::text AS sub_district,
            cht_data.doc ->> 'sub_county'::text AS sub_county,
            cht_data.doc ->> 'village'::text AS village,
            cht_data.is_current
           FROM dwh.cht_data
          WHERE cht_data.is_current = true
        ), 
      user_settings AS (
    SELECT
        s.contact_id,
        s.roles,

        CASE
            WHEN s.roles = '["chew", "super_chew"]'::jsonb THEN 'SUPER CHEW'
            WHEN s.roles = '["super_chew", "chew"]'::jsonb THEN 'SUPER CHEW'
            WHEN s.roles = '["chew"]'::jsonb THEN 'CHEW'
            WHEN EXISTS (
                SELECT 1 FROM jsonb_array_elements_text(s.roles) r(role)
                WHERE r.role = 'super_chew'
            ) THEN 'SUPER CHEW'
            WHEN EXISTS (
                SELECT 1 FROM jsonb_array_elements_text(s.roles) r(role)
                WHERE r.role = 'chew'
            ) THEN 'CHEW'
            WHEN EXISTS (
                SELECT 1 FROM jsonb_array_elements_text(s.roles) r(role)
                WHERE r.role = 'vht'
            ) THEN 'VHT'
            ELSE 'OTHER'
        END AS role,

        string_agg(s.username, ', ') AS username,
        string_agg(s.fullname, ', ') AS fullname,
        NOT s.roles @> '["deactivated"]'::jsonb AS active

    FROM (
        SELECT
            doc ->> 'contact_id' AS contact_id,
            (doc -> 'roles')::jsonb AS roles,
            doc ->> 'name' AS username,
            doc ->> 'fullname' AS fullname
        FROM dwh.cht_data
        WHERE doc ->> 'type' = 'user-settings'
          AND is_current = true
    ) s
    GROUP BY s.contact_id, s.roles
)

 SELECT p.name,
    row_number() OVER (ORDER BY p.uuid) AS id,
    to_timestamp((NULLIF(a.reported_date, ''::text)::bigint / 1000)::double precision) AS reported,
    p.uuid,
    us.active,
    us.username,
    us.fullname,
    p.phone,
    p.phone2,
    p.date_of_birth,
    p.sex,
    a.contact_type AS parent_type,
    a.uuid AS area_uuid,
    f.uuid AS branch_uuid,
    f.name AS branch_name,
    NULLIF(f.contact_id, ''::text) AS supervisor_uuid,
    d.name AS district,
    a.sub_district,
    a.sub_county,
    parish.name AS parish,
    f.name AS facility,
    f.external_id AS dhis2_facility_id,
    a.village,
    us.roles,
    us.role as role,
    CURRENT_TIMESTAMP AS last_refresh_date
   FROM base a
     JOIN base p ON a.contact_id = p.uuid AND p.type = 'person'::text
     JOIN base parish ON a.parent_id = parish.uuid AND parish.contact_type = 'c40-parish'::text
     JOIN base f ON a.grandparent_id = f.uuid AND f.contact_type = 'c30-district_hospital'::text
     JOIN base d ON f.parent_id = d.uuid AND d.contact_type = 'c20-district'::text
     LEFT JOIN user_settings us ON us.contact_id = p.uuid
  WITH DATA;