-- cht.mv_households source
-- Dependency-aware recreate: mv_integrated_echis_performace reads from this view.
SELECT cht.deps_save_and_drop_dependencies('cht', 'mv_households');
DROP MATERIALIZED VIEW cht.mv_households;
CREATE MATERIALIZED VIEW cht.mv_households
TABLESPACE ts_report
AS SELECT doc ->> '_id'::text AS id,
    doc ->> 'name'::text AS name,
    doc ->> 'type'::text AS type,
    doc ->> 'contact_type'::text AS contact_type,
    (doc -> 'contact'::text) ->> '_id'::text AS contact_id,
    doc ->> 'imported_date'::text AS imported_date,
    to_timestamp((((doc ->> 'reported_date'::text)::bigint) / 1000)::double precision) AS reported_at,
    ((doc -> 'parent'::text) -> 'parent'::text) ->> '_id'::text AS parish_id,
    par.parish AS parish,
    ((((doc -> 'parent'::text) -> 'parent'::text) -> 'parent'::text) -> 'parent'::text) ->> '_id'::text AS district,
    (((((doc -> 'parent'::text) -> 'parent'::text) -> 'parent'::text) -> 'parent'::text) -> 'parent'::text) ->> '_id'::text AS region,
    (doc -> 'group_wash'::text) ->> 'hh_is_odf'::text AS hh_is_odf,
    (doc -> 'group_wash'::text) ->> 'hh_have_drying_rack'::text AS hh_have_drying_rack,
    (doc -> 'group_wash'::text) ->> 'hh_have_rubbish_pit'::text AS hh_have_rubbish_pit,
    (doc -> 'group_wash'::text) ->> 'hh_have_bath_shelter'::text AS hh_have_bath_shelter,
    (doc -> 'group_wash'::text) ->> 'hh_latrine_fly_proof'::text AS hh_latrine_fly_proof,
    (doc -> 'group_wash'::text) ->> 'hh_sanitary_facility'::text AS hh_sanitary_facility,
    (doc -> 'group_wash'::text) ->> 'hh_have_backyard_garden'::text AS hh_have_backyard_garden,
    (doc -> 'group_wash'::text) ->> 'hh_have_sanitary_kitchen'::text AS hh_have_sanitary_kitchen,
    (doc -> 'group_wash'::text) ->> 'hh_access_safe_water_source'::text AS hh_access_safe_water_source,
    (doc -> 'group_wash'::text) ->> 'hh_have_safe_drinking_water'::text AS hh_have_safe_drinking_water,
    (doc -> 'group_wash'::text) ->> 'hh_floor_of_toilet_or_latrine'::text AS hh_floor_of_toilet_or_latrine,
    (doc -> 'group_wash'::text) ->> 'hh_in_sanitary_dwelling_house'::text AS hh_in_sanitary_dwelling_house,
    (doc -> 'group_wash'::text) ->> 'hh_handwashing_facility_status'::text AS hh_handwashing_facility_status,
    (doc -> 'group_wash'::text) ->> 'hh_sanitary_facility_filled_up'::text AS hh_sanitary_facility_filled_up,
    (doc -> 'group_wash'::text) ->> 'hh_handwashing_near_toilet_latrine'::text AS hh_handwashing_near_toilet_latrine,
    (doc -> 'group_wash'::text) ->> 'hh_empited_pit_latrine_or_septic_tank'::text AS hh_emptied_pit_latrine_or_septic_tank
   FROM dwh.cht_data
     LEFT JOIN (
         SELECT cht_data.doc ->> '_id'::text AS parish_id,
                cht_data.doc ->> 'name'::text AS parish
         FROM dwh.cht_data
         WHERE (cht_data.doc ->> 'type'::text) = 'contact'::text
           AND (cht_data.doc ->> 'contact_type'::text) = 'c40-parish'::text
           AND cht_data.is_current
     ) par ON (((doc -> 'parent'::text) -> 'parent'::text) ->> '_id'::text) = par.parish_id
  WHERE (doc ->> 'type'::text) = 'contact'::text
    AND (doc ->> 'contact_type'::text) = 'c60-clinic'::text
    AND is_current
WITH DATA;

-- View indexes:
CREATE INDEX idx_mv_households_contact_id ON cht.mv_households USING btree (contact_id);
CREATE INDEX idx_mv_households_district ON cht.mv_households USING btree (district);
CREATE INDEX idx_mv_households_id ON cht.mv_households USING btree (id);
CREATE INDEX idx_mv_households_region ON cht.mv_households USING btree (region);
CREATE INDEX idx_mv_households_parish_id ON cht.mv_households USING btree (parish_id);

-- Rebind dependent materialized views (mv_integrated_echis_performace):
SELECT cht.deps_restore_dependencies('cht', 'mv_households');
