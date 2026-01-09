CREATE MATERIALIZED VIEW cht.mv_clinic
TABLESPACE ts_report
AS
SELECT
    -- Standard fields (reused from sample MV)
    doc ->> '_id'::text AS uuid,
    to_timestamp((NULLIF(doc ->> 'reported_date'::text, ''::text)::bigint / 1000)::double precision) AS reported,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY-MM-DD'))::date AS date,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY'))::INT AS year,
    TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'FMMonth') AS month,
    doc ->'geolocation'->>'code' AS geolocation_code,
    doc ->'geolocation'->>'message' AS geolocation_message,
    -- XML-specific fields (mapped from provided XML structure)
    -- Top-level fields
    doc ->'parent'->>'_id' AS parent_id,
    doc ->>'type' AS type,
    doc ->'contact' ->>'_id' AS contact_id,
    doc ->>'name' AS name,
    doc ->>'want_to_capture_gps' AS want_to_capture_gps,
    doc ->>'ensure_gps' AS ensure_gps,
    doc ->>'gps' AS gps,
    doc ->>'additional_comments' AS additional_comments,
    doc ->>'hh_number' AS hh_number,
    doc ->>'hh_head_name' AS hh_head_name,
    doc ->>'is_model_household' AS is_model_household,

    -- Geolocation subfields
    doc ->'geolocation'->>'latitude' AS geolocation_latitude,
    doc ->'geolocation'->>'longitude' AS geolocation_longitude,
    doc ->'geolocation'->>'altitude' AS geolocation_altitude,
    doc ->'geolocation'->>'accuracy' AS geolocation_accuracy,

    -- Group_wash subfields (sanitation and water-related)
    doc ->'group_wash'->>'hh_in_sanitary_dwelling_house' AS hh_in_sanitary_dwelling_house,
    doc ->'group_wash'->>'hh_access_safe_water_source' AS hh_access_safe_water_source,
    doc ->'group_wash'->>'hh_have_safe_drinking_water' AS hh_have_safe_drinking_water,
    doc ->'group_wash'->>'hh_have_sanitary_kitchen' AS hh_have_sanitary_kitchen,
    doc ->'group_wash'->>'hh_have_drying_rack' AS hh_have_drying_rack,
    doc ->'group_wash'->>'hh_have_backyard_garden' AS hh_have_backyard_garden,
    doc ->'group_wash'->>'hh_have_rubbish_pit' AS hh_have_rubbish_pit,
    doc ->'group_wash'->>'hh_have_bath_shelter' AS hh_have_bath_shelter,
    doc ->'group_wash'->>'hh_sanitary_facility' AS hh_sanitary_facility,
    doc ->'group_wash'->>'hh_sharing_sanitary_facility' AS hh_sharing_sanitary_facility,
    doc ->'group_wash'->>'verify_hh_sharing_sanitary_facility' AS verify_hh_sharing_sanitary_facility,
    doc ->'group_wash'->>'hh_kind_of_public_toilet' AS hh_kind_of_public_toilet,
    doc ->'group_wash'->>'hh_latrine_fly_proof' AS hh_latrine_fly_proof,
    doc ->'group_wash'->>'hh_floor_of_toilet_or_latrine' AS hh_floor_of_toilet_or_latrine,
    doc ->'group_wash'->>'hh_toilet_conected_to_sewer' AS hh_toilet_conected_to_sewer,
    doc ->'group_wash'->>'hh_sanitary_facility_filled_up' AS hh_sanitary_facility_filled_up,
    doc ->'group_wash'->>'hh_empited_pit_latrine_or_septic_tank' AS hh_empited_pit_latrine_or_septic_tank,
    doc ->'group_wash'->>'hh_emptying_services' AS hh_emptying_services,
    doc ->'group_wash'->>'hh_emptied_contents_location' AS hh_emptied_contents_location,
    doc ->'group_wash'->>'hh_handwashing_near_toilet_latrine' AS hh_handwashing_near_toilet_latrine,
    doc ->'group_wash'->>'hh_handwashing_facility_status' AS hh_handwashing_facility_status,
    doc ->'group_wash'->>'hh_is_odf' AS hh_is_odf,

    -- Hh_model_assessment subfields (indicators)
    doc ->'hh_model_assessment'->>'hh_have_drying_lines' AS hh_have_drying_lines,
    doc ->'hh_model_assessment'->>'hh_have_animal_house' AS hh_have_animal_house,
    doc ->'hh_model_assessment'->>'hh_have_food_storage_access' AS hh_have_food_storage_access,
    doc ->'hh_model_assessment'->>'hh_compound_well_maintained' AS hh_compound_well_maintained,
    doc ->'hh_model_assessment'->>'hh_have_vermin_rodent' AS hh_have_vermin_rodent,
    doc ->'hh_model_assessment'->>'n_train_on_missing_indicators' AS n_train_on_missing_indicators,
    doc ->'hh_model_assessment'->>'n_animal_house_indicator' AS n_animal_house_indicator,
    doc ->'hh_model_assessment'->>'n_adequate_drying_lines_indicator' AS n_adequate_drying_lines_indicator,
    doc ->'hh_model_assessment'->>'n_food_storage_indicator' AS n_food_storage_indicator,
    doc ->'hh_model_assessment'->>'n_well_maintained_compound_indicator' AS n_well_maintained_compound_indicator,
    doc ->'hh_model_assessment'->>'n_vermin_rodent_control_indicator' AS n_vermin_rodent_control_indicator,

    -- Last column for tracking refresh
    CURRENT_TIMESTAMP AS last_refresh_date

FROM dwh.cht_data
WHERE (doc ->> 'type'::text) = 'clinic'::text
  AND is_current
WITH DATA;


-- Index on parent (for hierarchical filtering, e.g., by parent entity)
CREATE INDEX idx_mv_clinic_parent_id
ON cht.mv_clinic (parent_id)
TABLESPACE ts_indexes;

-- Index on contact (for contact-related queries)
CREATE INDEX idx_mv_clinic_contact_id
ON cht.mv_clinic (contact_id)
TABLESPACE ts_indexes;

-- Index on uuid (for unique document lookups)
CREATE INDEX idx_mv_clinic_uuid
ON cht.mv_clinic (uuid)
TABLESPACE ts_indexes;

-- Index on reported (timestamp for reported_date; for time-based filtering)
CREATE INDEX idx_mv_clinic_reported
ON cht.mv_clinic (reported)
TABLESPACE ts_indexes;
