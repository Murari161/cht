-- cht.mv_household_model_notification source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_household_model_notification;
CREATE MATERIALIZED VIEW cht.mv_household_model_notification
TABLESPACE ts_report
AS SELECT doc ->> '_id'::text AS uuid,
    doc ->> 'form'::text AS form,
    doc ->> 'from'::text AS submitter,
    to_timestamp((NULLIF(doc ->> 'reported_date'::text, ''::text)::bigint / 1000)::double precision) AS reported,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY-MM-DD'))::date AS date,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY'))::INT AS year,
    to_char(to_timestamp((((doc ->>'reported_date'::text)::bigint) / 1000)::double precision), 'MM'::text)::integer AS month,
    TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'FMMonth') AS monthname,
    ((doc -> 'fields'::text) -> 'meta'::text) ->> 'instanceID'::text AS instanceid,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) ->> 'deprecatedID'::text AS deprecatedid,
    ((((doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) -> 'location'::text) ->> 'lat'::text AS location_lat,
    ((((doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) -> 'location'::text) ->> 'long'::text AS location_long,
    ((((doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) -> 'location'::text) ->> 'error'::text AS location_error,
    ((((doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) -> 'location'::text) ->> 'message'::text AS location_message,
    (doc -> 'geolocation'::text) ->> 'code'::text AS geolocation_code,
    (doc -> 'geolocation'::text) ->> 'message'::text AS geolocation_message,
    doc #>> '{fields,inputs,source}'::text[] AS inputs_source,
    doc #>> '{fields,inputs,source_id}'::text[] AS inputs_source_id,
    doc #>> '{fields,inputs,t_sanitary_dwelling_house}'::text[] AS t_sanitary_dwelling_house,
    doc #>> '{fields,inputs,t_sanitary_kitchen}'::text[] AS t_sanitary_kitchen,
    doc #>> '{fields,inputs,t_drying_rack}'::text[] AS t_drying_rack,
    doc #>> '{fields,inputs,t_bath_shelter_with_soak_pit}'::text[] AS t_bath_shelter_with_soak_pit,
    doc #>> '{fields,inputs,t_sanitation_facility}'::text[] AS t_sanitation_facility,
    doc #>> '{fields,inputs,t_hh_latrine_fly_proof}'::text[] AS t_hh_latrine_fly_proof,
    doc #>> '{fields,inputs,t_hh_is_odf}'::text[] AS t_hh_is_odf,
    doc #>> '{fields,inputs,t_handwashing_facility_running_water}'::text[] AS t_handwashing_facility_running_water,
    doc #>> '{fields,inputs,t_rubbish_pit}'::text[] AS t_rubbish_pit,
    doc #>> '{fields,inputs,t_access_to_safe_water}'::text[] AS t_access_to_safe_water,
    doc #>> '{fields,inputs,t_adequate_drying_lines}'::text[] AS t_adequate_drying_lines,
    doc #>> '{fields,inputs,t_animal_house}'::text[] AS t_animal_house,
    doc #>> '{fields,inputs,t_food_storage}'::text[] AS t_food_storage,
    doc #>> '{fields,inputs,t_well_maintained_compound}'::text[] AS t_well_maintained_compound,
    doc #>> '{fields,inputs,t_vector_and_vermin_control}'::text[] AS t_vector_and_vermin_control,
    doc #>> '{fields,inputs,t_hh_head_name}'::text[] AS t_hh_head_name,
    doc #>> '{fields,inputs,t_place_name}'::text[] AS t_place_name,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    doc #>> '{fields,inputs,contact,parent,village}'::text[] AS inputs_contact_parent_village,
    doc #>> '{fields,inputs,contact,contact,name}'::text[] AS inputs_contact_contact_name,
    doc #>> '{fields,visited_contact_uuid}'::text[] AS visited_contact_uuid,
    doc #>> '{fields,place_id}'::text[] AS place_id,
    doc #>> '{fields,place_name}'::text[] AS place_name,
    doc #>> '{fields,hh_head_name}'::text[] AS hh_head_name,
    doc #>> '{fields,chw_village}'::text[] AS chw_village,
    doc #>> '{fields,notification,header_notification}'::text[] AS header_notification,
    doc #>> '{fields,notification,note_sanaitary_dwelling_house}'::text[] AS note_sanaitary_dwelling_house,
    doc #>> '{fields,notification,note_sanitary_kitchen}'::text[] AS note_sanitary_kitchen,
    doc #>> '{fields,notification,note_drying_rack}'::text[] AS note_drying_rack,
    doc #>> '{fields,notification,note_bath_shelter_with_soak_pit}'::text[] AS note_bath_shelter_with_soak_pit,
    doc #>> '{fields,notification,note_sanitation_facility}'::text[] AS note_sanitation_facility,
    doc #>> '{fields,notification,note_handwashing_facility_running_water}'::text[] AS note_handwashing_facility_running_water,
    doc #>> '{fields,notification,note_rubbish_pit}'::text[] AS note_rubbish_pit,
    doc #>> '{fields,notification,note_access_to_safe_water}'::text[] AS note_access_to_safe_water,
    doc #>> '{fields,notification,note_adequate_drying_lines}'::text[] AS note_adequate_drying_lines,
    doc #>> '{fields,notification,note_animal_house}'::text[] AS note_animal_house,
    doc #>> '{fields,notification,note_food_storage}'::text[] AS note_food_storage,
    doc #>> '{fields,notification,note_well_maintained_compound}'::text[] AS note_well_maintained_compound,
    doc #>> '{fields,notification,note_vector_and_vermin_control}'::text[] AS note_vector_and_vermin_control,
    doc #>> '{fields,notification,household_follow_up_date}'::text[] AS household_follow_up_date,
    doc #>> '{fields,group_notification_summary,s_note_household_details}'::text[] AS s_note_household_details,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility_name,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date 
   FROM dwh.cht_data couchdb
LEFT JOIN cht.mv_chw_hierarchy h ON (couchdb.doc #>> '{contact,_id}') = h.chw_id
  WHERE (doc ->> 'form'::text) = 'household_model_notification'::text AND is_current
WITH DATA;

-- View indexes:
CREATE INDEX mv_household_model_notification_reported ON cht.mv_household_model_notification USING btree (reported) tablespace ts_indexes; 
CREATE INDEX mv_household_model_notificationn_chw_id ON cht.mv_household_model_notification USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX mv_household_model_notification_date ON cht.mv_household_model_notification USING btree (date) tablespace ts_indexes;
CREATE INDEX mv_household_model_notification_year ON cht.mv_household_model_notification USING btree (year) tablespace ts_indexes;
CREATE INDEX mv_household_model_notification_month ON cht.mv_household_model_notification USING btree (month) tablespace ts_indexes;
CREATE INDEX mv_household_model_notification_monthname ON cht.mv_household_model_notification USING btree (monthname) tablespace ts_indexes; 
CREATE INDEX mv_household_model_notification_district ON cht.mv_household_model_notification USING btree (district) tablespace ts_indexes;
CREATE INDEX mv_household_model_notification_region ON cht.mv_household_model_notification USING btree (region) tablespace ts_indexes; 
CREATE INDEX mv_household_model_notification_facility_name ON cht.mv_household_model_notification USING btree (facility_name) tablespace ts_indexes; 
CREATE INDEX mv_household_model_notification_dhis2_facility_id ON cht.mv_household_model_notification USING btree (dhis2_facility_id) tablespace ts_indexes; 
CREATE INDEX mv_household_model_notification_village ON cht.mv_household_model_notification USING btree (village) tablespace ts_indexes;