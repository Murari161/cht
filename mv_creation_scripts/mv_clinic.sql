-- cht.mv_clinic source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_clinic;
CREATE MATERIALIZED VIEW cht.mv_clinic
TABLESPACE ts_report
AS SELECT doc ->> '_id'::text AS uuid,
    to_timestamp((NULLIF(doc ->> 'reported_date'::text, ''::text)::bigint / 1000)::double precision) AS reported,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY-MM-DD'))::date AS date,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY'))::INT AS year,
    to_char(to_timestamp((((doc ->>'reported_date'::text)::bigint) / 1000)::double precision), 'MM'::text)::integer AS month,
    TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'FMMonth') AS monthname,
    (doc -> 'geolocation'::text) ->> 'code'::text AS geolocation_code,
    (doc -> 'geolocation'::text) ->> 'message'::text AS geolocation_message,
    (doc -> 'parent'::text) ->> '_id'::text AS parent_id,
    doc ->> 'type'::text AS type,
    (doc -> 'contact'::text) ->> '_id'::text AS contact_id,
    doc ->> 'name'::text AS name,
    doc ->> 'want_to_capture_gps'::text AS want_to_capture_gps,
    doc ->> 'ensure_gps'::text AS ensure_gps,
    doc ->> 'gps'::text AS gps,
    doc ->> 'additional_comments'::text AS additional_comments,
    doc ->> 'hh_number'::text AS hh_number,
    doc ->> 'hh_head_name'::text AS hh_head_name,
    doc ->> 'is_model_household'::text AS is_model_household,
    (NULLIF((doc -> 'geolocation'::text) ->> 'latitude'::text, ''::text))::double precision AS geolocation_latitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'longitude'::text, ''::text))::double precision AS geolocation_longitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'altitude'::text, ''::text))::double precision AS geolocation_altitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'accuracy'::text, ''::text))::double precision AS geolocation_accuracy,
    (NULLIF((doc -> 'geolocation'::text) ->> 'altitudeAccuracy'::text, ''::text))::double precision AS geolocation_altitude_accuracy,
    (NULLIF((doc -> 'geolocation'::text) ->> 'speed'::text, ''::text))::double precision AS geolocation_speed,
    (NULLIF((doc -> 'geolocation'::text) ->> 'heading'::text, ''::text))::double precision AS geolocation_heading,
    (doc -> 'group_wash'::text) ->> 'hh_in_sanitary_dwelling_house'::text AS hh_in_sanitary_dwelling_house,
    (doc -> 'group_wash'::text) ->> 'hh_access_safe_water_source'::text AS hh_access_safe_water_source,
    (doc -> 'group_wash'::text) ->> 'hh_have_safe_drinking_water'::text AS hh_have_safe_drinking_water,
    (doc -> 'group_wash'::text) ->> 'hh_have_sanitary_kitchen'::text AS hh_have_sanitary_kitchen,
    (doc -> 'group_wash'::text) ->> 'hh_have_drying_rack'::text AS hh_have_drying_rack,
    (doc -> 'group_wash'::text) ->> 'hh_have_backyard_garden'::text AS hh_have_backyard_garden,
    (doc -> 'group_wash'::text) ->> 'hh_have_rubbish_pit'::text AS hh_have_rubbish_pit,
    (doc -> 'group_wash'::text) ->> 'hh_have_bath_shelter'::text AS hh_have_bath_shelter,
    (doc -> 'group_wash'::text) ->> 'hh_sanitary_facility'::text AS hh_sanitary_facility,
    (doc -> 'group_wash'::text) ->> 'hh_sharing_sanitary_facility'::text AS hh_sharing_sanitary_facility,
    (doc -> 'group_wash'::text) ->> 'verify_hh_sharing_sanitary_facility'::text AS verify_hh_sharing_sanitary_facility,
    (doc -> 'group_wash'::text) ->> 'hh_kind_of_public_toilet'::text AS hh_kind_of_public_toilet,
    (doc -> 'group_wash'::text) ->> 'hh_latrine_fly_proof'::text AS hh_latrine_fly_proof,
    (doc -> 'group_wash'::text) ->> 'hh_floor_of_toilet_or_latrine'::text AS hh_floor_of_toilet_or_latrine,
    (doc -> 'group_wash'::text) ->> 'hh_toilet_conected_to_sewer'::text AS hh_toilet_conected_to_sewer,
    (doc -> 'group_wash'::text) ->> 'hh_sanitary_facility_filled_up'::text AS hh_sanitary_facility_filled_up,
    (doc -> 'group_wash'::text) ->> 'hh_empited_pit_latrine_or_septic_tank'::text AS hh_empited_pit_latrine_or_septic_tank,
    (doc -> 'group_wash'::text) ->> 'hh_emptying_services'::text AS hh_emptying_services,
    (doc -> 'group_wash'::text) ->> 'hh_emptied_contents_location'::text AS hh_emptied_contents_location,
    (doc -> 'group_wash'::text) ->> 'hh_handwashing_near_toilet_latrine'::text AS hh_handwashing_near_toilet_latrine,
    (doc -> 'group_wash'::text) ->> 'hh_handwashing_facility_status'::text AS hh_handwashing_facility_status,
    (doc -> 'group_wash'::text) ->> 'hh_is_odf'::text AS hh_is_odf,
    (doc -> 'hh_model_assessment'::text) ->> 'hh_have_drying_lines'::text AS hh_have_drying_lines,
    (doc -> 'hh_model_assessment'::text) ->> 'hh_have_animal_house'::text AS hh_have_animal_house,
    (doc -> 'hh_model_assessment'::text) ->> 'hh_have_food_storage_access'::text AS hh_have_food_storage_access,
    (doc -> 'hh_model_assessment'::text) ->> 'hh_compound_well_maintained'::text AS hh_compound_well_maintained,
    (doc -> 'hh_model_assessment'::text) ->> 'hh_have_vermin_rodent'::text AS hh_have_vermin_rodent,
    (doc -> 'hh_model_assessment'::text) ->> 'n_train_on_missing_indicators'::text AS n_train_on_missing_indicators,
    (doc -> 'hh_model_assessment'::text) ->> 'n_animal_house_indicator'::text AS n_animal_house_indicator,
    (doc -> 'hh_model_assessment'::text) ->> 'n_adequate_drying_lines_indicator'::text AS n_adequate_drying_lines_indicator,
    (doc -> 'hh_model_assessment'::text) ->> 'n_food_storage_indicator'::text AS n_food_storage_indicator,
    (doc -> 'hh_model_assessment'::text) ->> 'n_well_maintained_compound_indicator'::text AS n_well_maintained_compound_indicator,
    (doc -> 'hh_model_assessment'::text) ->> 'n_vermin_rodent_control_indicator'::text AS n_vermin_rodent_control_indicator,
    doc #>> '{parent,_id}'                         AS vht_area_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date 
   FROM dwh.cht_data
LEFT JOIN cht.mv_chw_hierarchy h ON (doc #>> '{parent,_id}') = h.vht_area_id
  WHERE (doc ->> 'type'::text) = 'clinic'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX idx_mv_clinic_contact_id ON cht.mv_clinic USING btree (contact_id) tablespace ts_indexes; 
CREATE INDEX idx_mv_clinic_parent_id ON cht.mv_clinic USING btree (parent_id) tablespace ts_indexes;
CREATE INDEX idx_mv_clinic_reported ON cht.mv_clinic USING btree (reported) tablespace ts_indexes;
CREATE INDEX idx_mv_clinic_uuid ON cht.mv_clinic USING btree (uuid) tablespace ts_indexes;
CREATE INDEX idx_mv_clinic_year_month_district ON cht.mv_clinic USING btree (year, month, district) tablespace ts_indexes;
CREATE INDEX idx_mv_clinic_vht_area_id ON cht.mv_clinic USING btree (vht_area_id) tablespace ts_indexes;
CREATE INDEX idx_mv_clinic_district ON cht.mv_clinic USING btree (district) tablespace ts_indexes;
CREATE INDEX idx_mv_clinic_region ON cht.mv_clinic USING btree (region) tablespace ts_indexes;
CREATE INDEX idx_mv_clinic_facility ON cht.mv_clinic USING btree (facility) tablespace ts_indexes;
CREATE INDEX idx_mv_clinic_dhis2_facility_id ON cht.mv_clinic USING btree (dhis2_facility_id) tablespace ts_indexes;