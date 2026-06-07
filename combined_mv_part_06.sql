-- =====================================================================
-- Combined MV creation - PART 06 of 06  (10 views)
-- Generated: 2026-06-07 | Assumes cht.mv_chw_hierarchy exists | all WITH NO DATA
-- Each view is preceded by DROP MATERIALIZED VIEW IF EXISTS (no CASCADE)
-- Files in this part:
--   mv_health_education.sql
--   mv_vht_home_location.sql
--   mv_wash_report.sql
--   mv_clinic.sql
--   mv_fp_registration.sql
--   mv_anc_danger_sign_follow_up.sql
--   mv_copy_of_danger_signs_follow_up_report.sql
--   mv_pregnancy.sql
--   mv_child_nutrition_follow_up.sql
--   mv_household_model_follow_up.sql
-- =====================================================================


-- ---------------------------------------------------------------------
-- SOURCE: mv_health_education.sql
-- ---------------------------------------------------------------------

-- cht.mv_health_education_new source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_health_education;
CREATE MATERIALIZED VIEW cht.mv_health_education
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
    (NULLIF((doc -> 'geolocation'::text) ->> 'latitude'::text, ''::text))::double precision AS geolocation_latitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'longitude'::text, ''::text))::double precision AS geolocation_longitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'accuracy'::text, ''::text))::double precision AS geolocation_accuracy,
    (NULLIF((doc -> 'geolocation'::text) ->> 'altitude'::text, ''::text))::double precision AS geolocation_altitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'altitudeAccuracy'::text, ''::text))::double precision AS geolocation_altitude_accuracy,
    (NULLIF((doc -> 'geolocation'::text) ->> 'speed'::text, ''::text))::double precision AS geolocation_speed,
    (NULLIF((doc -> 'geolocation'::text) ->> 'heading'::text, ''::text))::double precision AS geolocation_heading,
    doc #>> '{fields,inputs,source}'::text[] AS inputs_source,
    doc #>> '{fields,inputs,source_id}'::text[] AS inputs_source_id,
    doc #>> '{fields,inputs,user,contact_id}'::text[] AS inputs_user_contact_id,
    doc #>> '{fields,inputs,user,facility_id}'::text[] AS inputs_user_facility_id,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    doc #>> '{fields,inputs,contact,contact,_id}'::text[] AS inputs_contact_contact_id,
    doc #>> '{fields,inputs,contact,contact,name}'::text[] AS inputs_contact_contact_name,
    doc #>> '{fields,inputs,contact,contact,date_of_birth}'::text[] AS inputs_contact_contact_date_of_birth,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,place_id}'::text[] AS place_id,
    doc #>> '{fields,chew_name}'::text[] AS chew_name,
    doc #>> '{fields,chew_date_of_birth}'::text[] AS chew_date_of_birth,
    doc #>> '{fields,chew_age_display}'::text[] AS chew_age_display,
    doc #>> '{fields,village_id}'::text[] AS village_id,
    doc #>> '{fields,village_name}'::text[] AS village_name,
    doc #>> '{fields,needs_signoff}'::text[] AS needs_signoff,
    doc #>> '{fields,chosen_venue}'::text[] AS chosen_venue,
    doc #>> '{fields,selected_village,venue}'::text[] AS selected_village_venue,
    doc #>> '{fields,selected_village,village_id}'::text[] AS selected_village_village_id,
    doc #>> '{fields,selected_village,name}'::text[] AS selected_village_name,
    doc #>> '{fields,geolocation,n_geolocation}'::text[] AS fields_geolocation_n_geolocation,
    doc #>> '{fields,geolocation,want_to_capture_gps}'::text[] AS fields_geolocation_want_to_capture_gps,
    doc #>> '{fields,geolocation,gps_capture_checklist}'::text[] AS fields_geolocation_gps_capture_checklist,
    doc #>> '{fields,geolocation,gps}'::text[] AS fields_geolocation_gps,
    doc #>> '{fields,geolocation,gps_capture_checklist_completed}'::text[] AS fields_geolocation_gps_capture_checklist_completed,
    doc #>> '{fields,geolocation,latitude}'::text[] AS fields_geolocation_latitude,
    doc #>> '{fields,geolocation,longitude}'::text[] AS fields_geolocation_longitude,
    doc #>> '{fields,geolocation,altitude}'::text[] AS fields_geolocation_altitude,
    doc #>> '{fields,geolocation,accuracy}'::text[] AS fields_geolocation_accuracy,
    doc #>> '{fields,geolocation,gps_location_picked_display}'::text[] AS fields_geolocation_gps_location_picked_display,
    doc #>> '{fields,geolocation,additional_comments}'::text[] AS fields_geolocation_additional_comments,
    doc #>> '{fields,g_health_education_topics,session_date}'::text[] AS he_session_date,
    doc #>> '{fields,g_health_education_topics,topics_covered}'::text[] AS he_topics_covered,
    doc #>> '{fields,g_health_education_topics,specify_other_topic}'::text[] AS he_specify_other_topic,
    doc #>> '{fields,g_wash_topic,wash_priorities}'::text[] AS g_wash_topic_wash_priorities,
    (doc #>> '{fields,g_wash_topic,nb_attendee_wash}'::text[])::integer AS g_wash_topic_nb_attendee_wash,
    doc #>> '{fields,g_wash_topic,additional_notes_wash}'::text[] AS g_wash_topic_additional_notes_wash,
    doc #>> '{fields,g_nutrition_promotion_topic,nutrition_practices}'::text[] AS g_nutrition_promotion_topic_nutrition_practices,
    (doc #>> '{fields,g_nutrition_promotion_topic,nb_attendee_food_promotion}'::text[])::integer AS g_nutrition_promotion_topic_nb_attendee_food_promotion,
    doc #>> '{fields,g_nutrition_promotion_topic,additional_notes_promotion}'::text[] AS g_nutrition_promotion_topic_additional_notes_promotion,
    doc #>> '{fields,g_non_communicable_diseases_topic,non_communicable_diseases_facts}'::text[] AS g_non_communicable_diseases_topic_non_communicable_diseases_fac,
    (doc #>> '{fields,g_non_communicable_diseases_topic,nb_attendee_commun_diseases}'::text[])::integer AS g_non_communicable_diseases_topic_nb_attendee_commun_diseases,
    doc #>> '{fields,g_non_communicable_diseases_topic,additional_notes_commun_diseases}'::text[] AS g_non_communicable_diseases_topic_additional_notes_commun_disea,
    doc #>> '{fields,g_leprosy_topic,leprosy_facts}'::text[] AS g_leprosy_topic_leprosy_facts,
    (doc #>> '{fields,g_leprosy_topic,nb_attendee_leprosy}'::text[])::integer AS g_leprosy_topic_nb_attendee_leprosy,
    doc #>> '{fields,g_leprosy_topic,additional_notes_leprosy}'::text[] AS g_leprosy_topic_additional_notes_leprosy,
    doc #>> '{fields,g_malaria_topic,malaria_facts}'::text[] AS g_malaria_topic_malaria_facts,
    (doc #>> '{fields,g_malaria_topic,nb_attendee_malaria}'::text[])::integer AS g_malaria_topic_nb_attendee_malaria,
    doc #>> '{fields,g_malaria_topic,additional_notes_malaria}'::text[] AS g_malaria_topic_additional_notes_malaria,
    doc #>> '{fields,g_hiv_aids_topic,hiv_aids_facts}'::text[] AS g_hiv_aids_topic_hiv_aids_facts,
    (doc #>> '{fields,g_hiv_aids_topic,nb_attendee_hiv}'::text[])::integer AS g_hiv_aids_topic_nb_attendee_hiv,
    doc #>> '{fields,g_hiv_aids_topic,additional_notes_hiv}'::text[] AS g_hiv_aids_topic_additional_notes_hiv,
    doc #>> '{fields,g_tb_topic,tb_facts}'::text[] AS g_tb_topic_tb_facts,
    (doc #>> '{fields,g_tb_topic,nb_attendee_tb}'::text[])::integer AS g_tb_topic_nb_attendee_tb,
    doc #>> '{fields,g_tb_topic,additional_notes_tb}'::text[] AS g_tb_topic_additional_notes_tb,
    doc #>> '{fields,g_maternal_health_topic,maternal_health_facts}'::text[] AS g_maternal_health_topic_maternal_health_facts,
    (doc #>> '{fields,g_maternal_health_topic,nb_attendee_maternal_health}'::text[])::integer AS g_maternal_health_topic_nb_attendee_maternal_health,
    doc #>> '{fields,g_maternal_health_topic,additional_notes_maternal_health}'::text[] AS g_maternal_health_topic_additional_notes_maternal_health,
    doc #>> '{fields,g_child_health_topic,child_health_facts}'::text[] AS g_child_health_topic_child_health_facts,
    (doc #>> '{fields,g_child_health_topic,nb_attendee_child_health}'::text[])::integer AS g_child_health_topic_nb_attendee_child_health,
    doc #>> '{fields,g_child_health_topic,additional_notes_child_health}'::text[] AS g_child_health_topic_additional_notes_child_health,
    (doc #>> '{fields,g_other_topic,nb_attendee_other_topic}'::text[])::integer AS g_other_topic_nb_attendee_other_topic,
    doc #>> '{fields,g_other_topic,additional_notes_other_topic}'::text[] AS g_other_topic_additional_notes_other_topic,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date
   FROM dwh.cht_data couchdb
LEFT JOIN cht.mv_chw_hierarchy h ON (couchdb.doc #>> '{contact,_id}') = h.chw_id
  WHERE (doc ->> 'form'::text) = 'health_education'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX mv_health_education_chw_id ON cht.mv_health_education USING btree (chw_id) TABLESPACE ts_indexes;
CREATE INDEX mv_health_education_reported ON cht.mv_health_education USING btree (reported) TABLESPACE ts_indexes;
CREATE INDEX mv_health_education_year_month_district ON cht.mv_health_education USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX mv_health_education_facility ON cht.mv_health_education USING btree (facility) TABLESPACE ts_indexes;
CREATE INDEX mv_health_education_dhis2_facility_id ON cht.mv_health_education USING btree (dhis2_facility_id) TABLESPACE ts_indexes;
CREATE INDEX mv_health_education_district ON cht.mv_health_education USING btree (district) TABLESPACE ts_indexes;  
CREATE INDEX mv_health_education_region ON cht.mv_health_education USING btree (region) TABLESPACE ts_indexes;  


-- ---------------------------------------------------------------------
-- SOURCE: mv_vht_home_location.sql
-- ---------------------------------------------------------------------

-- cht.mv_vht_home_location source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_vht_home_location;
CREATE MATERIALIZED VIEW cht.mv_vht_home_location
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
    (doc -> 'geolocation'::text) ->> 'code'::text AS geolocation_code,
    (doc -> 'geolocation'::text) ->> 'message'::text AS geolocation_message,
    (NULLIF((doc -> 'geolocation'::text) ->> 'latitude'::text, ''::text))::double precision AS geolocation_latitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'longitude'::text, ''::text))::double precision AS geolocation_longitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'accuracy'::text, ''::text))::double precision AS geolocation_accuracy,
    (NULLIF((doc -> 'geolocation'::text) ->> 'altitude'::text, ''::text))::double precision AS geolocation_altitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'altitudeAccuracy'::text, ''::text))::double precision AS geolocation_altitude_accuracy,
    (NULLIF((doc -> 'geolocation'::text) ->> 'speed'::text, ''::text))::double precision AS geolocation_speed,
    (NULLIF((doc -> 'geolocation'::text) ->> 'heading'::text, ''::text))::double precision AS geolocation_heading,
    doc #>> '{fields,inputs,source}'::text[] AS inputs_source,
    doc #>> '{fields,inputs,source_id}'::text[] AS inputs_source_id,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    doc #>> '{fields,geolocation,latitude}'::text[] AS fields_geolocation_latitude,
    doc #>> '{fields,geolocation,longitude}'::text[] AS fields_geolocation_longitude,
    doc #>> '{fields,geolocation,altitude}'::text[] AS fields_geolocation_altitude,
    doc #>> '{fields,geolocation,accuracy}'::text[] AS fields_geolocation_accuracy,
    doc #>> '{fields,geolocation,want_to_capture_gps}'::text[] AS fields_geolocation_want_to_capture_gps,
    doc #>> '{fields,geolocation,ensure_gps}'::text[] AS fields_geolocation_ensure_gps,
    doc #>> '{fields,geolocation,gps}'::text[] AS fields_geolocation_gps,
    doc #>> '{fields,geolocation,coordinates}'::text[] AS fields_geolocation_coordinates,
    doc #>> '{fields,geolocation,additional_comments}'::text[] AS fields_geolocation_additional_comments,
    doc #>> '{fields,geolocation,no_gps_reasons}'::text[] AS fields_geolocation_no_gps_reasons,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
FROM dwh.cht_data d LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id 
  WHERE (doc ->> 'form'::text) = 'vht_home_location'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX mv_vht_home_location_chw_id ON cht.mv_vht_home_location USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX mv_vht_home_location_reported ON cht.mv_vht_home_location USING btree (reported) tablespace ts_indexes;
CREATE INDEX mv_vht_home_location_monthname ON cht.mv_vht_home_location USING btree (monthname) tablespace ts_indexes;
CREATE INDEX mv_vht_home_location_year_month_district ON cht.mv_vht_home_location USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX mv_vht_home_location_region ON cht.mv_vht_home_location USING btree (region) tablespace ts_indexes;
CREATE INDEX mv_vht_home_location_district ON cht.mv_vht_home_location USING btree (district) tablespace ts_indexes;
CREATE INDEX mv_vht_home_location_village ON cht.mv_vht_home_location USING btree (village) tablespace ts_indexes;
CREATE INDEX mv_vht_home_location_facility ON cht.mv_vht_home_location USING btree (facility) tablespace ts_indexes;
CREATE INDEX mv_vht_home_location_dhis2_facility_id ON cht.mv_vht_home_location USING btree (dhis2_facility_id) tablespace ts_indexes;

-- ---------------------------------------------------------------------
-- SOURCE: mv_wash_report.sql
-- ---------------------------------------------------------------------

-- cht.mv_wash_report source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_wash_report;
CREATE MATERIALIZED VIEW cht.mv_wash_report
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
    (NULLIF((doc -> 'geolocation'::text) ->> 'latitude'::text, ''::text))::double precision AS geolocation_latitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'longitude'::text, ''::text))::double precision AS geolocation_longitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'accuracy'::text, ''::text))::double precision AS geolocation_accuracy,
    (NULLIF((doc -> 'geolocation'::text) ->> 'altitude'::text, ''::text))::double precision AS geolocation_altitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'altitudeAccuracy'::text, ''::text))::double precision AS geolocation_altitude_accuracy,
    (NULLIF((doc -> 'geolocation'::text) ->> 'speed'::text, ''::text))::double precision AS geolocation_speed,
    (NULLIF((doc -> 'geolocation'::text) ->> 'heading'::text, ''::text))::double precision AS geolocation_heading,
    doc #>> '{fields,inputs,source}'::text[] AS inputs_source,
    doc #>> '{fields,inputs,source_id}'::text[] AS inputs_source_id,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    doc #>> '{fields,inputs,contact,parent,village}'::text[] AS inputs_contact_parent_village,
    doc #>> '{fields,inputs,contact,contact,name}'::text[] AS inputs_contact_contact_name,
    doc #>> '{fields,visited_contact_uuid}'::text[] AS visited_contact_uuid,
    doc #>> '{fields,place_id}'::text[] AS place_id,
    doc #>> '{fields,place_name}'::text[] AS place_name,
    doc #>> '{fields,hh_head_name}'::text[] AS hh_head_name,
    doc #>> '{fields,chw_village}'::text[] AS chw_village,
    doc #>> '{fields,current_gps}'::text[] AS current_gps,
    (NULLIF(split_part(doc #>> '{fields,current_gps}'::text[], ' '::text, 1), ''::text))::double precision AS gps_lat,
    (NULLIF(split_part(doc #>> '{fields,current_gps}'::text[], ' '::text, 2), ''::text))::double precision AS gps_long,
    (NULLIF(split_part(doc #>> '{fields,current_gps}'::text[], ' '::text, 3), ''::text))::double precision AS gps_alt,
    (NULLIF(split_part(doc #>> '{fields,current_gps}'::text[], ' '::text, 4), ''::text))::double precision AS gps_accuracy,
    doc #>> '{fields,needs_signoff}'::text[] AS needs_signoff,
    doc #>> '{fields,geolocation,latitude}'::text[] AS location_latitude,
    doc #>> '{fields,geolocation,longitude}'::text[] AS location_longitude,
    doc #>> '{fields,geolocation,altitude}'::text[] AS location_altitude,
    doc #>> '{fields,geolocation,accuracy}'::text[] AS location_accuracy,
    doc #>> '{fields,geolocation,note_no_hh_gps}'::text[] AS location_note_no_hh_gps,
    doc #>> '{fields,geolocation,want_to_capture_gps}'::text[] AS location_want_to_capture_gps,
    doc #>> '{fields,geolocation,ensure_gps}'::text[] AS location_ensure_gps,
    doc #>> '{fields,geolocation,gps}'::text[] AS location_gps,
    doc #>> '{fields,geolocation,coordinates}'::text[] AS location_coordinates,
    doc #>> '{fields,geolocation,additional_comments}'::text[] AS location_additional_comments,
    doc #>> '{fields,group_wash,hh_in_sanitary_dwelling_house}'::text[] AS hh_in_sanitary_dwelling_house,
    doc #>> '{fields,group_wash,hh_access_safe_water_source}'::text[] AS hh_access_safe_water_source,
    doc #>> '{fields,group_wash,hh_have_safe_drinking_water}'::text[] AS hh_have_safe_drinking_water,
    doc #>> '{fields,group_wash,hh_have_sanitary_kitchen}'::text[] AS hh_have_sanitary_kitchen,
    doc #>> '{fields,group_wash,hh_have_drying_rack}'::text[] AS hh_have_drying_rack,
    doc #>> '{fields,group_wash,hh_have_backyard_garden}'::text[] AS hh_have_backyard_garden,
    doc #>> '{fields,group_wash,hh_have_rubbish_pit}'::text[] AS hh_have_rubbish_pit,
    doc #>> '{fields,group_wash,hh_have_bath_shelter}'::text[] AS hh_have_bath_shelter,
    doc #>> '{fields,group_wash,hh_sanitary_facility}'::text[] AS hh_sanitary_facility,
    doc #>> '{fields,group_wash,hh_sharing_sanitary_facility}'::text[] AS hh_sharing_sanitary_facility,
    doc #>> '{fields,group_wash,verify_hh_sharing_sanitary_facility}'::text[] AS verify_hh_sharing_sanitary_facility,
    doc #>> '{fields,group_wash,hh_kind_of_public_toilet}'::text[] AS hh_kind_of_public_toilet,
    doc #>> '{fields,group_wash,hh_latrine_fly_proof}'::text[] AS hh_latrine_fly_proof,
    doc #>> '{fields,group_wash,hh_floor_of_toilet_or_latrine}'::text[] AS hh_floor_of_toilet_or_latrine,
    doc #>> '{fields,group_wash,hh_toilet_conected_to_sewer}'::text[] AS hh_toilet_conected_to_sewer,
    doc #>> '{fields,group_wash,hh_sanitary_facility_filled_up}'::text[] AS hh_sanitary_facility_filled_up,
    doc #>> '{fields,group_wash,hh_empited_pit_latrine_or_septic_tank}'::text[] AS hh_empited_pit_latrine_or_septic_tank,
    doc #>> '{fields,group_wash,hh_emptying_services}'::text[] AS hh_emptying_services,
    doc #>> '{fields,group_wash,hh_emptied_contents_location}'::text[] AS hh_emptied_contents_location,
    doc #>> '{fields,group_wash,hh_handwashing_near_toilet_latrine}'::text[] AS hh_handwashing_near_toilet_latrine,
    doc #>> '{fields,group_wash,hh_handwashing_facility_status}'::text[] AS hh_handwashing_facility_status,
    doc #>> '{fields,group_wash,hh_is_odf}'::text[] AS hh_is_odf,
    doc #>> '{fields,hh_model_assessment,hh_have_drying_lines}'::text[] AS model_hh_have_drying_lines,
    doc #>> '{fields,hh_model_assessment,hh_have_animal_house}'::text[] AS model_hh_have_animal_house,
    doc #>> '{fields,hh_model_assessment,hh_have_food_storage_access}'::text[] AS model_hh_have_food_storage_access,
    doc #>> '{fields,hh_model_assessment,hh_compound_well_maintained}'::text[] AS model_hh_compound_well_maintained,
    doc #>> '{fields,hh_model_assessment,hh_have_vermin_rodent}'::text[] AS model_hh_have_vermin_rodent,
    doc #>> '{fields,hh_model_assessment,n_train_on_missing_indicators}'::text[] AS model_n_train_on_missing_indicators,
    doc #>> '{fields,hh_model_assessment,n_animal_house_indicator}'::text[] AS model_n_animal_house_indicator,
    doc #>> '{fields,hh_model_assessment,n_adequate_drying_lines_indicator}'::text[] AS model_n_adequate_drying_lines_indicator,
    doc #>> '{fields,hh_model_assessment,n_food_storage_indicator}'::text[] AS model_n_food_storage_indicator,
    doc #>> '{fields,hh_model_assessment,n_well_maintained_compound_indicator}'::text[] AS model_n_well_maintained_compound_indicator,
    doc #>> '{fields,hh_model_assessment,n_vermin_rodent_control_indicator}'::text[] AS model_n_vermin_rodent_control_indicator,
    doc #>> '{fields,is_model_household}'::text[] AS is_model_household,
    doc #>> '{fields,next_wash_report_task_date}'::text[] AS next_wash_report_task_date,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
FROM dwh.cht_data d LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id 
  WHERE (doc ->> 'form'::text) = 'wash_report'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX mv_wash_report_chw_id ON cht.mv_wash_report USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX mv_wash_report_reported ON cht.mv_wash_report USING btree (reported) tablespace ts_indexes;
CREATE INDEX mv_wash_report_year_month_district ON cht.mv_wash_report USING btree (year, month, district) tablespace ts_indexes;
CREATE INDEX mv_wash_report_date ON cht.mv_wash_report USING btree (date) tablespace ts_indexes;
CREATE INDEX mv_wash_report_region ON cht.mv_wash_report USING btree (region) tablespace ts_indexes;
CREATE INDEX mv_wash_report_district ON cht.mv_wash_report USING btree (district) tablespace ts_indexes;
CREATE INDEX mv_wash_report_village ON cht.mv_wash_report USING btree (village) tablespace ts_indexes;
CREATE INDEX mv_wash_report_facility ON cht.mv_wash_report USING btree (facility) tablespace ts_indexes;
CREATE INDEX mv_wash_report_dhis2_facility_id ON cht.mv_wash_report USING btree (dhis2_facility_id) tablespace ts_indexes; 

-- ---------------------------------------------------------------------
-- SOURCE: mv_clinic.sql
-- ---------------------------------------------------------------------

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

-- ---------------------------------------------------------------------
-- SOURCE: mv_fp_registration.sql
-- ---------------------------------------------------------------------

-- cht.mv_fp_registration source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_fp_registration;
CREATE MATERIALIZED VIEW cht.mv_fp_registration
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
    (NULLIF((doc -> 'geolocation'::text) ->> 'latitude'::text, ''::text))::double precision AS geolocation_latitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'longitude'::text, ''::text))::double precision AS geolocation_longitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'altitude'::text, ''::text))::double precision AS geolocation_altitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'accuracy'::text, ''::text))::double precision AS geolocation_accuracy,
    (NULLIF((doc -> 'geolocation'::text) ->> 'altitudeAccuracy'::text, ''::text))::double precision AS geolocation_altitude_accuracy,
    (NULLIF((doc -> 'geolocation'::text) ->> 'speed'::text, ''::text))::double precision AS geolocation_speed,
    (NULLIF((doc -> 'geolocation'::text) ->> 'heading'::text, ''::text))::double precision AS geolocation_heading,
    doc #>> '{fields,inputs,meta,location,lat}'::text[] AS inputs_location_lat,
    doc #>> '{fields,inputs,meta,location,long}'::text[] AS inputs_location_long,
    doc #>> '{fields,inputs,meta,location,error}'::text[] AS inputs_location_error,
    doc #>> '{fields,inputs,meta,location,message}'::text[] AS inputs_location_message,
    doc #>> '{fields,inputs,source}'::text[] AS inputs_source,
    doc #>> '{fields,inputs,source_id}'::text[] AS inputs_source_id,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    doc #>> '{fields,inputs,contact,patient_id}'::text[] AS inputs_contact_patient_id,
    doc #>> '{fields,inputs,contact,date_of_birth}'::text[] AS inputs_contact_date_of_birth,
    doc #>> '{fields,inputs,contact,sex}'::text[] AS inputs_contact_sex,
    doc #>> '{fields,inputs,contact,parent,_id}'::text[] AS inputs_parent_id,
    doc #>> '{fields,inputs,contact,parent,name}'::text[] AS inputs_parent_name,
    doc #>> '{fields,inputs,contact,parent,parent,contact,name}'::text[] AS inputs_parent_contact_name,
    doc #>> '{fields,inputs,contact,parent,parent,contact,phone}'::text[] AS inputs_parent_contact_phone,
    doc #>> '{fields,inputs,contact,parent,parent,_id}'::text[] AS inputs_parent_parent_id,
    doc #>> '{fields,inputs,contact,parent,parent,supervisor}'::text[] AS inputs_parent_supervisor,
    doc #>> '{fields,inputs,contact,parent,parent,parent,_id}'::text[] AS inputs_parent_parent_parent_id,
    doc #>> '{fields,source}'::text[] AS fields_source,
    doc #>> '{fields,source_id}'::text[] AS fields_source_id,
    doc #>> '{fields,patient_uuid}'::text[] AS patient_uuid,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,patient_name}'::text[] AS patient_name,
    doc #>> '{fields,patient_date_of_birth}'::text[] AS patient_date_of_birth,
    doc #>> '{fields,patient_age_in_years}'::text[] AS patient_age_in_years,
    doc #>> '{fields,age}'::text[] AS age,
    doc #>> '{fields,date_of_birth}'::text[] AS date_of_birth,
    doc #>> '{fields,chw_name}'::text[] AS chw_name,
    doc #>> '{fields,chw_phone}'::text[] AS chw_phone,
    doc #>> '{fields,current_fp_method_label}'::text[] AS current_fp_method_label,
    doc #>> '{fields,current_fp_method}'::text[] AS current_fp_method,
    doc #>> '{fields,chw_area_id}'::text[] AS chw_area_id,
    doc #>> '{fields,supervisor_id}'::text[] AS supervisor_id,
    doc #>> '{fields,branch_id}'::text[] AS branch_id,
    doc #>> '{fields,fp_next_appt_date}'::text[] AS fp_next_appt_date,
    (doc #>> '{fields,coc_given}'::text[])::integer AS coc_given,
    (doc #>> '{fields,condoms_given}'::text[])::integer AS condoms_given,
    (doc #>> '{fields,pop_given}'::text[])::integer AS pop_given,
    (doc #>> '{fields,dmpa_given}'::text[])::integer AS dmpa_given,
    (doc #>> '{fields,contraceptives_given}'::text[])::integer AS contraceptives_given,
    doc #>> '{fields,needs_method_change}'::text[] AS needs_method_change,
    doc #>> '{fields,has_been_referred}'::text[] AS has_been_referred,
    doc #>> '{fields,fp_registration,fp_method}'::text[] AS fp_method,
    doc #>> '{fields,fp_registration,fp_start_date}'::text[] AS fp_start_date,
    doc #>> '{fields,fp_registration,who_administered_dmpa}'::text[] AS who_administered_dmpa,
    (doc #>> '{fields,fp_registration,condoms_received}'::text[])::integer AS condoms_received,
    doc #>> '{fields,fp_registration,enrol_on_fp_method}'::text[] AS enrol_on_fp_method,
    doc #>> '{fields,fp_registration,continue_current_fp_method}'::text[] AS continue_current_fp_method,
    doc #>> '{fields,fp_registration,n_fp_referral_note}'::text[] AS n_fp_referral_note,
    doc #>> '{fields,fp_registration,patient_referred}'::text[] AS patient_referred,
    doc #>> '{fields,fp_registration,referral_follow_up_date}'::text[] AS referral_follow_up_date,
    doc #>> '{fields,fp_registration,can_supply_fp_commodities}'::text[] AS can_supply_fp_commodities,
    doc #>> '{fields,fp_registration,supply_item_name}'::text[] AS supply_item_name,
    doc #>> '{fields,fp_registration,supply_item_units}'::text[] AS supply_item_units,
    (doc #>> '{fields,fp_registration,supply_limit}'::text[])::integer AS supply_limit,
    (doc #>> '{fields,fp_registration,commodities_supplied_qty}'::text[])::integer AS commodities_supplied_qty,
    doc #>> '{fields,fp_registration,next_appt_date}'::text[] AS next_appt_date,
    doc #>> '{fields,fp_registration,format_next_appt_date}'::text[] AS format_next_appt_date,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date 
   FROM dwh.cht_data couchdb
LEFT JOIN cht.mv_chw_hierarchy h ON (couchdb.doc #>> '{contact,_id}') = h.chw_id
  WHERE (doc ->> 'form'::text) = 'fp_registration'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX mv_fp_registration_reported ON cht.mv_fp_registration USING btree (reported) tablespace ts_indexes;
CREATE INDEX mv_fp_registration_date ON cht.mv_fp_registration USING btree (date) tablespace ts_indexes;
CREATE INDEX mv_fp_registration_year_month_district ON cht.mv_fp_registration USING btree (year, month, district) tablespace ts_indexes;
CREATE INDEX mv_fp_registration_monthname ON cht.mv_fp_registration USING btree (monthname) tablespace ts_indexes;
CREATE INDEX mv_fp_registration_chw_id ON cht.mv_fp_registration USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX mv_fp_registration_district ON cht.mv_fp_registration USING btree (district) tablespace ts_indexes;
CREATE INDEX mv_fp_registration_facility ON cht.mv_fp_registration USING btree (facility) tablespace ts_indexes;
CREATE INDEX mv_fp_registration_dhis2_facility_id ON cht.mv_fp_registration USING btree (dhis2_facility_id) tablespace ts_indexes;
CREATE INDEX mv_fp_registration_fp__region ON cht.mv_fp_registration USING btree (region) tablespace ts_indexes;

-- ---------------------------------------------------------------------
-- SOURCE: mv_anc_danger_sign_follow_up.sql
-- ---------------------------------------------------------------------

-- cht.mv_anc_danger_sign_follow_up source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_anc_danger_sign_follow_up;
CREATE MATERIALIZED VIEW cht.mv_anc_danger_sign_follow_up
TABLESPACE ts_report
AS SELECT doc_id,
    rev_id,
    ((doc -> 'fields'::text) -> 'meta'::text) ->> 'instanceID'::text AS instanceid,
    ((doc -> 'fields'::text) -> 'meta'::text) ->> 'deprecatedID'::text AS deprecatedid,
    (doc -> 'geolocation'::text) ->> 'code'::text AS geolocation_code,
    (doc -> 'geolocation'::text) ->> 'message'::text AS geolocation_message,
    (NULLIF((doc -> 'geolocation'::text) ->> 'latitude'::text, ''::text))::double precision AS geolocation_latitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'longitude'::text, ''::text))::double precision AS geolocation_longitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'accuracy'::text, ''::text))::double precision AS geolocation_accuracy,
    (NULLIF((doc -> 'geolocation'::text) ->> 'altitude'::text, ''::text))::double precision AS geolocation_altitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'altitudeAccuracy'::text, ''::text))::double precision AS geolocation_altitude_accuracy,
    (NULLIF((doc -> 'geolocation'::text) ->> 'speed'::text, ''::text))::double precision AS geolocation_speed,
    (NULLIF((doc -> 'geolocation'::text) ->> 'heading'::text, ''::text))::double precision AS geolocation_heading,
    to_timestamp((NULLIF(doc ->> 'reported_date'::text, ''::text)::bigint / 1000)::double precision) AS reported,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY-MM-DD'))::date AS date,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY'))::INT AS year,
    to_char(to_timestamp((((doc ->>'reported_date'::text)::bigint) / 1000)::double precision), 'MM'::text)::integer AS month,
    TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'FMMonth') AS monthname,
    doc ->> 'form'::text AS form,
    doc ->> 'from'::text AS "from",
    doc ->> 'type'::text AS type,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'user'::text) ->> 'contact_id'::text AS user_contact_id,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'user'::text) ->> 'facility_id'::text AS facility_id,
    ((doc -> 'fields'::text) -> 'inputs'::text) ->> 'source_id'::text AS source_id,
    ((doc -> 'fields'::text) -> 'inputs'::text) ->> 'source'::text AS source,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> '_id'::text AS inputs_contact_id,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> 'name'::text AS contact_name,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> 'sex'::text AS sex,
    ((doc -> 'fields'::text) -> 'inputs'::text) ->> 't_fever'::text AS t_fever,
    ((doc -> 'fields'::text) -> 'inputs'::text) ->> 't_swelling'::text AS t_swelling,
    ((doc -> 'fields'::text) -> 'inputs'::text) ->> 't_vht_name'::text AS t_vht_name,
    ((doc -> 'fields'::text) -> 'inputs'::text) ->> 't_very_pale'::text AS t_very_pale,
    ((doc -> 'fields'::text) -> 'inputs'::text) ->> 't_vht_phone'::text AS t_vht_phone,
    ((doc -> 'fields'::text) -> 'inputs'::text) ->> 't_place_name'::text AS t_place_name,
    ((doc -> 'fields'::text) -> 'inputs'::text) ->> 't_blurred_vision'::text AS t_blurred_vision,
    ((doc -> 'fields'::text) -> 'inputs'::text) ->> 't_breathlessness'::text AS t_breathlessness,
    ((doc -> 'fields'::text) -> 'inputs'::text) ->> 't_hiv_test_result'::text AS t_hiv_test_result,
    ((doc -> 'fields'::text) -> 'inputs'::text) ->> 't_severe_headache'::text AS t_severe_headache,
    ((doc -> 'fields'::text) -> 'inputs'::text) ->> 't_has_hypertension'::text AS t_has_hypertension,
    ((doc -> 'fields'::text) -> 'inputs'::text) ->> 't_vaginal_bleeding'::text AS t_viginal_bleeding,
    ((doc -> 'fields'::text) -> 'inputs'::text) ->> 't_lower_abdomen_pain'::text AS t_lower_abdomen_pain,
    ((doc -> 'fields'::text) -> 'inputs'::text) ->> 't_reduced_or_no_feotal_movements'::text AS t_reduced_or_no_feotal_movements,
    (doc -> 'fields'::text) ->> 'patient_id'::text AS patient_id,
    ((doc -> 'fields'::text) -> 'action_taken'::text) ->> 'call_chw'::text AS call_chw,
    ((doc -> 'fields'::text) -> 'action_taken'::text) ->> 'call_button'::text AS call_button,
    ((doc -> 'fields'::text) -> 'action_taken'::text) ->> 'reason_vht_did_not_follow_up'::text AS reason_vht_did_not_follow_up,
    ((doc -> 'fields'::text) -> 'action_taken'::text) ->> 'vht_completed_referral_follow_up'::text AS vht_completed_referral_follow_up,
    ((doc -> 'fields'::text) -> 'danger_signs'::text) ->> 'very_pale'::text AS very_pale,
    ((doc -> 'fields'::text) -> 'danger_signs'::text) ->> 'blurred_vision'::text AS blurred_vision,
    ((doc -> 'fields'::text) -> 'danger_signs'::text) ->> 'referral_signs'::text AS referral_signs,
    ((doc -> 'fields'::text) -> 'danger_signs'::text) ->> 'lower_abdomen_pain'::text AS lower_abdomen_pain,
    ((doc -> 'fields'::text) -> 'danger_signs'::text) ->> 'reduced_or_no_feotal_movements'::text AS reduced_or_no_feotal_movements,
    (doc -> 'fields'::text) ->> 'patient_name'::text AS patient_name,
    (doc -> 'fields'::text) ->> 'patient_gender'::text AS patient_gender,
    (doc -> 'fields'::text) ->> 'patient_age_display'::text AS patient_age_display,
    (doc -> 'fields'::text) ->> 'patient_age_in_days'::text AS patient_age_in_days,
    (doc -> 'fields'::text) ->> 'patient_age_in_months'::text AS patient_age_in_months,
    (doc -> 'fields'::text) ->> 'patient_age_in_years'::text AS patient_age_in_years,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility_name,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
   FROM dwh.cht_data d
   LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id
  WHERE d.type = 'data_record'::text AND (d.doc ->> 'form'::text) = 'anc_danger_sign_follow_up'::text AND d.is_current IS TRUE
WITH NO DATA;

CREATE UNIQUE INDEX idx_mv_anc_danger_sign_follow_up_doc_id_rev_id
  ON cht.mv_anc_danger_sign_follow_up (doc_id, rev_id);
CREATE INDEX idx_mv_anc_danger_sign_follow_up_chw_id
  ON cht.mv_anc_danger_sign_follow_up (chw_id);
CREATE INDEX idx_mv_anc_danger_sign_follow_up_reported
  ON cht.mv_anc_danger_sign_follow_up (reported);
CREATE INDEX idx_mv_anc_danger_sign_follow_up_date
  ON cht.mv_anc_danger_sign_follow_up (date);
CREATE INDEX idx_mv_anc_danger_sign_follow_up_year_month_district
  ON cht.mv_anc_danger_sign_follow_up (year, month, district);
CREATE INDEX idx_mv_anc_danger_sign_follow_up_monthname
  ON cht.mv_anc_danger_sign_follow_up (monthname);

-- ---------------------------------------------------------------------
-- SOURCE: mv_copy_of_danger_signs_follow_up_report.sql
-- ---------------------------------------------------------------------

-- cht.mv_copy_of_danger_signs_follow_up_report source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_copy_of_danger_signs_follow_up_report;
CREATE MATERIALIZED VIEW cht.mv_copy_of_danger_signs_follow_up_report
TABLESPACE ts_report
AS SELECT doc ->> '_id'::text AS id,
    doc ->> '_rev'::text AS rev,
    doc ->> '_form'::text AS form,
    doc ->> 'type'::text AS type,
    to_timestamp((NULLIF(doc ->> 'reported_date'::text, ''::text)::bigint / 1000)::double precision) AS reported,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY-MM-DD'))::date AS date,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY'))::INT AS year,
    to_char(to_timestamp((((doc ->>'reported_date'::text)::bigint) / 1000)::double precision), 'MM'::text)::integer AS month,
    TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'FMMonth') AS monthname,
    (((doc -> 'field'::text) -> 'inputs'::text) -> 'contact'::text) -> '_id'::text AS inputs_contact_id,
    (((doc -> 'field'::text) -> 'inputs'::text) -> 'contact'::text) -> 'name'::text AS name,
    (doc -> 'field'::text) ->> 'source'::text AS source,
    (doc -> 'field'::text) ->> 'place_id'::text AS place_id,
    (doc -> 'field'::text) ->> 'vht_name'::text AS vht_name,
    (doc -> 'field'::text) ->> 'client_id'::text AS client_id,
    (doc -> 'field'::text) ->> 'source_id'::text AS source_id,
    (doc -> 'field'::text) ->> 'vht_phone'::text AS vht_phone,
    (doc -> 'field'::text) ->> 'place_name'::text AS place_name,
    (doc -> 'field'::text) ->> 'client_name'::text AS client_name,
    (doc -> 'field'::text) ->> 'created_by_doc'::text AS created_by_doc,
    (doc -> 'field'::text) ->> 'completed_referral'::text AS completed_referral,
    (doc -> 'field'::text) ->> 'still_has_danger_signs'::text AS still_has_danger_signs,
    (doc -> 'parent'::text) ->> '_id'::text AS parent_id,
    (doc -> 'contact'::text) ->> '_id'::text AS contact_id,
    (doc -> 'geolocation'::text) ->> 'code'::text AS geolocation_code,
    (doc -> 'geolocation'::text) ->> 'message'::text AS geolocation_message,
    (NULLIF((doc -> 'geolocation'::text) ->> 'latitude'::text, ''::text))::double precision AS geolocation_latitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'longitude'::text, ''::text))::double precision AS geolocation_longitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'accuracy'::text, ''::text))::double precision AS geolocation_accuracy,
    (NULLIF((doc -> 'geolocation'::text) ->> 'altitude'::text, ''::text))::double precision AS geolocation_altitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'altitudeAccuracy'::text, ''::text))::double precision AS geolocation_altitude_accuracy,
    (NULLIF((doc -> 'geolocation'::text) ->> 'speed'::text, ''::text))::double precision AS geolocation_speed,
    (NULLIF((doc -> 'geolocation'::text) ->> 'heading'::text, ''::text))::double precision AS geolocation_heading,
    doc ->> 'content_type'::text AS content_type,
    doc ->> 'reported_date'::text AS reported_date,
    doc #>> '{geolocation_log,0,timestamp}'::text[] AS "timestamp",
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date
   FROM dwh.cht_data
LEFT JOIN cht.mv_chw_hierarchy h ON (dwh.cht_data.doc #>> '{contact,_id}') = h.chw_id
  WHERE type = 'data_record'::text AND (doc ->> 'form'::text) = 'copy_of_danger_signs_follow_up_report'::text
WITH NO DATA;

-- View indexes:
CREATE INDEX idx_mv_danger_followup_contact_id ON cht.mv_copy_of_danger_signs_follow_up_report USING btree (contact_id) tablespace ts_indexes;
CREATE INDEX idx_mv_danger_followup_parent_id ON cht.mv_copy_of_danger_signs_follow_up_report USING btree (parent_id) tablespace ts_indexes;
CREATE INDEX idx_mv_danger_followup_reported_date ON cht.mv_copy_of_danger_signs_follow_up_report USING btree (reported_date) tablespace ts_indexes;
CREATE INDEX idx_mv_danger_followup_chw_id ON cht.mv_copy_of_danger_signs_follow_up_report USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX idx_mv_danger_followup_year_month_district ON cht.mv_copy_of_danger_signs_follow_up_report USING btree (year, month, district) tablespace ts_indexes;

-- ---------------------------------------------------------------------
-- SOURCE: mv_pregnancy.sql
-- ---------------------------------------------------------------------

-- cht.mv_pregnancy source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_pregnancy;
CREATE MATERIALIZED VIEW cht.mv_pregnancy
TABLESPACE ts_report
AS SELECT d.doc ->> '_id'::text AS doc_id,
    d.doc ->> '_rev'::text AS rev,
    d.doc ->> 'form'::text AS form,
    d.doc ->> 'from'::text AS "from",
    d.doc ->> 'type'::text AS type,
    to_timestamp((NULLIF(d.doc ->> 'reported_date'::text, ''::text)::bigint / 1000)::double precision) AS reported,
    to_char(to_timestamp((((d.doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'YYYY-MM-DD'::text)::date AS date,
    to_char(to_timestamp((((d.doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'YYYY'::text)::integer AS year,
    to_char(to_timestamp((((d.doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'MM'::text)::integer AS month,
    to_char(to_timestamp((((d.doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'FMMonth'::text) AS monthname,
    ((d.doc -> 'fields'::text) -> 'meta'::text) ->> 'instanceID'::text AS instanceid,
    (((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) ->> 'deprecatedID'::text AS deprecatedid,
    ((((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) -> 'location'::text) ->> 'lat'::text AS location_lat,
    ((((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) -> 'location'::text) ->> 'long'::text AS location_long,
    ((((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) -> 'location'::text) ->> 'error'::text AS location_error,
    ((((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) -> 'location'::text) ->> 'message'::text AS location_message,
    (d.doc -> 'geolocation'::text) ->> 'code'::text AS geolocation_code,
    (d.doc -> 'geolocation'::text) ->> 'message'::text AS geolocation_message,
    (NULLIF((d.doc -> 'geolocation'::text) ->> 'latitude'::text, ''::text))::double precision AS geolocation_latitude,
    (NULLIF((d.doc -> 'geolocation'::text) ->> 'longitude'::text, ''::text))::double precision AS geolocation_longitude,
    (NULLIF((d.doc -> 'geolocation'::text) ->> 'accuracy'::text, ''::text))::double precision AS geolocation_accuracy,
    (NULLIF((d.doc -> 'geolocation'::text) ->> 'altitude'::text, ''::text))::double precision AS geolocation_altitude,
    (NULLIF((d.doc -> 'geolocation'::text) ->> 'altitudeAccuracy'::text, ''::text))::double precision AS geolocation_altitude_accuracy,
    (NULLIF((d.doc -> 'geolocation'::text) ->> 'speed'::text, ''::text))::double precision AS geolocation_speed,
    (NULLIF((d.doc -> 'geolocation'::text) ->> 'heading'::text, ''::text))::double precision AS geolocation_heading,
    d.doc #>> '{fields,inputs,source}'::text[] AS source,
    d.doc #>> '{fields,inputs,source_id}'::text[] AS source_id,
    d.doc #>> '{fields,inputs,user,contact_id}'::text[] AS user_contact_id,
    d.doc #>> '{fields,inputs,user,facility_id}'::text[] AS user_facility_id,
    d.doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    d.doc #>> '{fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    d.doc #>> '{fields,inputs,contact,date_of_birth}'::text[] AS inputs_contact_date_of_birth,
    d.doc #>> '{fields,inputs,contact,sex}'::text[] AS inputs_contact_sex,
    d.doc #>> '{fields,inputs,contact,parent,_id}'::text[] AS inputs_parent_id,
    d.doc #>> '{fields,inputs,contact,parent,name}'::text[] AS inputs_parent_name,
    d.doc #>> '{fields,is_of_child_bearing_age}'::text[] AS is_of_child_bearing_age,
    d.doc #>> '{fields,visited_contact_uuid}'::text[] AS visited_contact_uuid,
    d.doc #>> '{fields,patient_age_in_years}'::text[] AS patient_age_in_years,
    d.doc #>> '{fields,patient_age_in_months}'::text[] AS patient_age_in_months,
    d.doc #>> '{fields,patient_age_in_days}'::text[] AS patient_age_in_days,
    d.doc #>> '{fields,patient_age_display}'::text[] AS patient_age_display,
    d.doc #>> '{fields,patient_id}'::text[] AS patient_id,
    d.doc #>> '{fields,patient_name}'::text[] AS patient_name,
    d.doc #>> '{fields,patient_gender}'::text[] AS patient_gender,
    d.doc #>> '{fields,edd_std}'::text[] AS edd_std,
    d.doc #>> '{fields,edd_local}'::text[] AS edd_local,
    d.doc #>> '{fields,lmp}'::text[] AS lmp,
    d.doc #>> '{fields,nutrition_follow_up_date}'::text[] AS nutrition_follow_up_date,
    d.doc #>> '{fields,referred_for_nutrition_follow_up}'::text[] AS referred_for_nutrition_follow_up,
    d.doc #>> '{fields,chw_area_name}'::text[] AS chw_area_name,
    d.doc #>> '{fields,chw_name}'::text[] AS chw_name,
    d.doc #>> '{fields,chw_phone}'::text[] AS chw_phone,
    d.doc #>> '{fields,chw_village}'::text[] AS chw_village,
    d.doc #>> '{fields,needs_signoff}'::text[] AS needs_signoff,
    d.doc #>> '{fields,additional_doc,follow_up_date}'::text[] AS follow_up_date,
    d.doc #>> '{fields,additional_doc,client_age_in_years}'::text[] AS client_age_in_years,
    d.doc #>> '{fields,additional_doc,client_age_in_months}'::text[] AS client_age_in_months,
    d.doc #>> '{fields,additional_doc,client_age_in_days}'::text[] AS client_age_in_days,
    d.doc #>> '{fields,additional_doc,client_age_display}'::text[] AS client_age_display,
    d.doc #>> '{fields,additional_doc,client_sex}'::text[] AS client_sex,
    d.doc #>> '{fields,additional_doc,client_id}'::text[] AS client_id,
    d.doc #>> '{fields,additional_doc,client_uuid}'::text[] AS client_uuid,
    d.doc #>> '{fields,additional_doc,client_name}'::text[] AS client_name,
    d.doc #>> '{fields,additional_doc,place_id}'::text[] AS place_id,
    d.doc #>> '{fields,additional_doc,place_name}'::text[] AS place_name,
    d.doc #>> '{fields,additional_doc,vht_name}'::text[] AS vht_name,
    d.doc #>> '{fields,additional_doc,vht_phone}'::text[] AS vht_phone,
    d.doc #>> '{fields,group_safe_pregnancy_practices,using_llin}'::text[] AS using_llin,
    d.doc #>> '{fields,group_safe_pregnancy_practices,note_llin_prevents_malaria}'::text[] AS note_llin_prevents_malaria,
    d.doc #>> '{fields,group_safe_pregnancy_practices,refer_client_to_health_facility}'::text[] AS refer_client_to_health_facility,
    d.doc #>> '{fields,group_safe_pregnancy_practices,has_tt_card}'::text[] AS has_tt_card,
    d.doc #>> '{fields,group_safe_pregnancy_practices,tt_immunizations}'::text[] AS tt_immunizations,
    d.doc #>> '{fields,group_safe_pregnancy_practices,note_tt_protects_newborn_and_mother}'::text[] AS note_tt_protects_newborn_and_mother,
    d.doc #>> '{fields,group_safe_pregnancy_practices,note_two_tt_vaccines_per_pregnancy}'::text[] AS note_two_tt_vaccines_per_pregnancy,
    d.doc #>> '{fields,group_safe_pregnancy_practices,tt_refer_ack}'::text[] AS tt_refer_ack,
    d.doc #>> '{fields,group_safe_pregnancy_practices,received_tt_immunizations}'::text[] AS received_tt_immunizations,
    d.doc #>> '{fields,group_safe_pregnancy_practices,note_provide_nutrition_education}'::text[] AS note_provide_nutrition_education,
    d.doc #>> '{fields,group_safe_pregnancy_practices,note_encourage_micro_nutrient_supplementation}'::text[] AS note_encourage_micro_nutrient_supplementation,
    d.doc #>> '{fields,group_safe_pregnancy_practices,note_encourage_sleep_under_itns}'::text[] AS note_encourage_sleep_under_itns,
    d.doc #>> '{fields,group_safe_pregnancy_practices,note_encourage_men_to_participate}'::text[] AS note_encourage_men_to_participate,
    d.doc #>> '{fields,group_safe_pregnancy_practices,note_encourage_to_go_for_anc}'::text[] AS note_encourage_to_go_for_anc,
    d.doc #>> '{fields,group_nutrition_status,note_nutrition_status}'::text[] AS note_nutrition_status,
    d.doc #>> '{fields,group_nutrition_status,taken_muac}'::text[] AS taken_muac,
    d.doc #>> '{fields,group_nutrition_status,muac_measurement}'::text[] AS muac_measurement,
    d.doc #>> '{fields,group_nutrition_status,encourage_client_to_consume_sufficient_diet}'::text[] AS encourage_client_to_consume_sufficient_diet,
    d.doc #>> '{fields,group_nutrition_status,note_has_sam}'::text[] AS note_has_sam,
    d.doc #>> '{fields,group_nutrition_status,note_has_mam}'::text[] AS note_has_mam,
    d.doc #>> '{fields,group_nutrition_status,note_refer_to_health_facility}'::text[] AS note_refer_to_health_facility,
    d.doc #>> '{fields,group_nutrition_status,referred_to_health_facility_nutrition}'::text[] AS referred_to_health_facility_nutrition,
    d.doc #>> '{fields,group_nutrition_status,micro_nutrient_supplementation_received}'::text[] AS micro_nutrient_supplementation_received,
    d.doc #>> '{fields,group_nutrition_status,note_encourage_micro-nutrients}'::text[] AS note_encourage_micro_nutrients,
    d.doc #>> '{fields,group_nutrition_status,refer_to_health_facility_no_micro_nutrients}'::text[] AS refer_to_health_facility_no_micro_nutrients,
    d.doc #>> '{fields,group_nutrition_status,on_nutrition_follow_up}'::text[] AS on_nutrition_follow_up,
    d.doc #>> '{fields,group_nutrition_status,completed_last_nutrition_follow_up}'::text[] AS completed_last_nutrition_follow_up,
    d.doc #>> '{fields,group_nutrition_status,schedule_follow_up_visit}'::text[] AS schedule_follow_up_visit,
    d.doc #>> '{fields,group_nutrition_status,next_nutrition_follow_up_date}'::text[] AS next_nutrition_follow_up_date,
    d.doc #>> '{fields,group_nutrition_status,note_thank_you_nutrition_follow_up}'::text[] AS note_thank_you_nutrition_follow_up,
    d.doc #>> '{fields,group_nutrition_status,note_refer_did_not_complete_follow_up}'::text[] AS note_refer_did_not_complete_follow_up,
    d.doc #>> '{fields,group_nutrition_status,referred_to_health_facility_missed_nutrition_follow_up}'::text[] AS referred_to_health_facility_missed_nutrition_follow_up,
    d.doc #>> '{fields,group_danger_sign_check,note_danger_signs}'::text[] AS ds_note_danger_signs,
    d.doc #>> '{fields,group_danger_sign_check,vaginal_bleeding}'::text[] AS ds_vaginal_bleeding,
    d.doc #>> '{fields,group_danger_sign_check,lower_abdomen_pain}'::text[] AS ds_lower_abdomen_pain,
    d.doc #>> '{fields,group_danger_sign_check,severe_headache}'::text[] AS ds_severe_headache,
    d.doc #>> '{fields,group_danger_sign_check,very_pale}'::text[] AS ds_very_pale,
    d.doc #>> '{fields,group_danger_sign_check,fever}'::text[] AS ds_fever,
    d.doc #>> '{fields,group_danger_sign_check,reduced_or_no_feotal_movements}'::text[] AS ds_reduced_or_no_feotal_movements,
    d.doc #>> '{fields,group_danger_sign_check,blurred_vision}'::text[] AS ds_blurred_vision,
    d.doc #>> '{fields,group_danger_sign_check,swelling}'::text[] AS ds_swelling,
    d.doc #>> '{fields,group_danger_sign_check,breathlessness}'::text[] AS ds_breathlessness,
    d.doc #>> '{fields,group_danger_sign_check,has_danger_signs}'::text[] AS ds_has_danger_signs,
    d.doc #>> '{fields,group_danger_sign_check,has_no_danger_signs}'::text[] AS ds_has_no_danger_signs,
    d.doc #>> '{fields,group_danger_sign_check,note_has_no_danger_signs}'::text[] AS ds_note_has_no_danger_signs,
    d.doc #>> '{fields,group_danger_sign_check,note_has_danger_signs}'::text[] AS ds_note_has_danger_signs,
    d.doc #>> '{fields,group_danger_sign_check,referred_to_health_facility_danger_signs}'::text[] AS ds_referred_to_health_facility_danger_signs,
    d.doc #>> '{fields,group_danger_sign_check,note_complete_follow_up_task}'::text[] AS ds_note_complete_follow_up_task,
    d.doc #>> '{fields,group_scheduled_anc_visits,note_check_for_upcoming_anc_visits}'::text[] AS note_check_for_upcoming_anc_visits,
    d.doc #>> '{fields,group_scheduled_anc_visits,has_upcoming_anc_visits}'::text[] AS has_upcoming_anc_visits,
    d.doc #>> '{fields,group_scheduled_anc_visits,anc_appointment_date}'::text[] AS anc_appointment_date,
    d.doc #>> '{fields,group_past_anc_visits,number_of_anc_visits}'::text[] AS number_of_anc_visits,
    d.doc #>> '{fields,group_past_anc_visits,anc_visits}'::text[] AS anc_visits,
    d.doc #>> '{fields,group_past_anc_visits,hiv_test_done}'::text[] AS hiv_test_done,
    d.doc #>> '{fields,group_past_anc_visits,hiv_test_result}'::text[] AS hiv_test_result,
    d.doc #>> '{fields,group_past_anc_visits,note_reduce_risk_of_hiv}'::text[] AS note_reduce_risk_of_hiv,
    d.doc #>> '{fields,group_past_anc_visits,on_art_treatment}'::text[] AS on_art_treatment,
    d.doc #>> '{fields,group_past_anc_visits,taking_medication}'::text[] AS taking_medication,
    d.doc #>> '{fields,group_past_anc_visits,explain_the_mportance_of_taking_medication}'::text[] AS explain_the_mportance_of_taking_medication,
    d.doc #>> '{fields,group_past_anc_visits,note_encourage_client_to_take_medication}'::text[] AS note_encourage_client_to_take_medication,
    d.doc #>> '{fields,group_gestational_Age,note_pregnancy_registration_introduction}'::text[] AS note_pregnancy_registration_introduction,
    d.doc #>> '{fields,group_gestational_Age,pregnancy_report_method}'::text[] AS pregnancy_report_method,
    d.doc #>> '{fields,group_gestational_Age,lmp_start_date}'::text[] AS lmp_start_date,
    d.doc #>> '{fields,group_gestational_Age,lmp_start_date_local}'::text[] AS lmp_start_date_local,
    d.doc #>> '{fields,group_gestational_Age,estimated_edd_std}'::text[] AS estimated_edd_std,
    d.doc #>> '{fields,group_gestational_Age,estimated_edd_local}'::text[] AS estimated_edd_local,
    d.doc #>> '{fields,group_gestational_Age,note_entered_lmp}'::text[] AS note_entered_lmp,
    d.doc #>> '{fields,group_gestational_Age,note_estimated_edd}'::text[] AS note_estimated_edd,
    d.doc #>> '{fields,group_gestational_Age,entered_edd}'::text[] AS entered_edd,
    d.doc #>> '{fields,group_gestational_Age,entered_edd_local}'::text[] AS entered_edd_local,
    d.doc #>> '{fields,group_gestational_Age,pregnancy_age_in_weeks}'::text[] AS pregnancy_age_in_weeks,
    d.doc #>> '{fields,group_gestational_Age,note_pregnancy_age}'::text[] AS note_pregnancy_age,
    d.doc #>> '{fields,group_gestational_Age,note_no_information}'::text[] AS note_no_information,
    d.doc #>> '{fields,danger_signs,_vaginal_bleeding}'::text[] AS vaginal_bleeding,
    d.doc #>> '{fields,danger_signs,_lower_abdomen_pain}'::text[] AS lower_abdomen_pain,
    d.doc #>> '{fields,danger_signs,_severe_headache}'::text[] AS severe_headache,
    d.doc #>> '{fields,danger_signs,_very_pale}'::text[] AS very_pale,
    d.doc #>> '{fields,danger_signs,_fever}'::text[] AS fever,
    d.doc #>> '{fields,danger_signs,_reduced_or_no_feotal_movements}'::text[] AS reduced_or_no_feotal_movements,
    d.doc #>> '{fields,danger_signs,_blurred_vision}'::text[] AS blurred_vision,
    d.doc #>> '{fields,danger_signs,_swelling}'::text[] AS swelling,
    d.doc #>> '{fields,danger_signs,_breathlessness}'::text[] AS breathlessness,
    d.doc #>> '{contact,_id}'::text[] AS chw_id,
    h.facility,
    h.village,
    h.district,
    h.region,
    CURRENT_TIMESTAMP AS last_refresh_date
   FROM dwh.cht_data d
     LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}'::text[]) = h.chw_id
  WHERE (d.doc ->> 'form'::text) = 'pregnancy'::text AND d.is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX pregnancy_reported_idx ON cht.mv_pregnancy USING btree (reported) tablespace ts_indexes;
CREATE INDEX pregnancy_date_idx ON cht.mv_pregnancy USING btree (date) tablespace ts_indexes;
CREATE INDEX pregnancy_year_month_district_idx ON cht.mv_pregnancy USING btree (year, month, district) tablespace ts_indexes;
CREATE INDEX pregnancy_monthname_idx ON cht.mv_pregnancy USING btree (monthname) tablespace ts_indexes;
CREATE INDEX pregnancy_village_idx ON cht.mv_pregnancy USING btree (village) tablespace ts_indexes;
CREATE INDEX pregnancy_district_idx ON cht.mv_pregnancy USING btree (district) tablespace ts_indexes;
CREATE INDEX pregnancy_region_idx ON cht.mv_pregnancy USING btree (region) tablespace ts_indexes;

-- ---------------------------------------------------------------------
-- SOURCE: mv_child_nutrition_follow_up.sql
-- ---------------------------------------------------------------------

-- cht.mv_child_nutrition_follow_up source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_child_nutrition_follow_up;
CREATE MATERIALIZED VIEW cht.mv_child_nutrition_follow_up
TABLESPACE ts_report
AS SELECT doc ->> '_id'::text AS id,
    doc ->> '_rev'::text AS rev,
    to_timestamp((NULLIF(doc ->> 'reported_date'::text, ''::text)::bigint / 1000)::double precision) AS reported,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY-MM-DD'))::date AS date,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY'))::INT AS year,
    to_char(to_timestamp((((doc ->>'reported_date'::text)::bigint) / 1000)::double precision), 'MM'::text)::integer AS month,
    TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'FMMonth') AS monthname,
    doc ->> 'form'::text AS form,
    doc ->> 'from'::text AS "from",
    doc ->> 'type'::text AS type,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'user'::text) ->> 'contact_id'::text AS user_contact_id,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'user'::text) ->> 'facility_id'::text AS inputs_user_facility_id,
    ((doc -> 'fields'::text) -> 'inputs'::text) ->> 'source'::text AS source,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> '_id'::text AS inputs_contact_id,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> 'sex'::text AS inputs_contact_sex,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> 'name'::text AS inputs_contact_name,
    ((((doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) -> 'contact'::text) ->> 'date_of_birth'::text AS inputs_contact_date_of_birth,
    ((doc -> 'fields'::text) -> 'inputs'::text) ->> 'source_id'::text AS source_id,
    (doc -> 'fields'::text) ->> 'patient_id'::text AS patient_id,
    (doc -> 'fields'::text) ->> 'patient_name'::text AS patient_name,
    (doc -> 'fields'::text) ->> 'needs_signoff'::text AS needs_signoff,
    (doc -> 'fields'::text) ->> 'patient_gender'::text AS patient_gender,
    (doc -> 'fields'::text) ->> 'patient_age_display'::text AS patient_age_display,
    NULLIF((doc -> 'fields'::text) ->> 'patient_age_in_days'::text, 'NaN'::text)::integer AS patient_age_in_days,
    NULLIF((doc -> 'fields'::text) ->> 'patient_age_in_years'::text, 'NaN'::text)::integer AS patient_age_in_years,
    ((doc -> 'fields'::text) -> 'group_patient_summary'::text) ->> 'patient_health'::text AS patient_health,
    ((doc -> 'fields'::text) -> 'group_patient_summary'::text) ->> 'patient_malnourished'::text AS patient_malnourished,
    NULLIF((doc -> 'fields'::text) ->> 'patient_age_in_months'::text, ''::text)::integer AS patient_age_in_months,
    ((doc -> 'fields'::text) -> 'malnutrition_follow_up'::text) ->> 'educate_caregiver'::text AS educate_caregiver,
    ((doc -> 'fields'::text) -> 'malnutrition_follow_up'::text) ->> 'taken_to_facility'::text AS taken_to_facility,
    NULLIF(((doc -> 'fields'::text) -> 'malnutrition_follow_up'::text) ->> 'next_nutrition_visit_date'::text, ''::text)::date AS next_nutrition_visit_date,
    ((doc -> 'fields'::text) -> 'malnutrition_follow_up'::text) ->> 'outcome_of_follow_up_visit'::text AS outcome_of_follow_up_visit,
    ((doc -> 'fields'::text) -> 'malnutrition_follow_up'::text) ->> 'offer_and_select_nutrition_practices'::text AS offer_and_select_nutrition_practices,
    (doc -> 'geolocation'::text) ->> 'code'::text AS geolocation_code,
    (doc -> 'geolocation'::text) ->> 'message'::text AS geolocation_message,
    (NULLIF((doc -> 'geolocation'::text) ->> 'latitude'::text, ''::text))::double precision AS geolocation_latitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'longitude'::text, ''::text))::double precision AS geolocation_longitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'accuracy'::text, ''::text))::double precision AS geolocation_accuracy,
    (NULLIF((doc -> 'geolocation'::text) ->> 'altitude'::text, ''::text))::double precision AS geolocation_altitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'altitudeAccuracy'::text, ''::text))::double precision AS geolocation_altitude_accuracy,
    (NULLIF((doc -> 'geolocation'::text) ->> 'speed'::text, ''::text))::double precision AS geolocation_speed,
    (NULLIF((doc -> 'geolocation'::text) ->> 'heading'::text, ''::text))::double precision AS geolocation_heading,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date
   FROM dwh.cht_data
LEFT JOIN cht.mv_chw_hierarchy h ON (doc #>> '{contact,_id}') = h.chw_id
  WHERE type = 'data_record'::text AND (doc ->> 'form'::text) = 'child_nutrition_follow_up'::text
WITH NO DATA;

-- View indexes:
CREATE INDEX idx_mv_child_nutrition_date ON cht.mv_child_nutrition_follow_up USING btree (date) tablespace ts_indexes;
CREATE INDEX idx_mv_child_nutrition_year_month_district ON cht.mv_child_nutrition_follow_up USING btree (year, month, district) tablespace ts_indexes;
CREATE INDEX idx_mv_child_nutrition_district ON cht.mv_child_nutrition_follow_up USING btree (district) tablespace ts_indexes;
CREATE INDEX idx_mv_child_nutrition_region ON cht.mv_child_nutrition_follow_up USING btree (region) tablespace ts_indexes;
CREATE INDEX idx_mv_child_nutrition_chw_id ON cht.mv_child_nutrition_follow_up USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX idx_mv_child_nutrition_reported ON cht.mv_child_nutrition_follow_up USING btree (reported) tablespace ts_indexes;

-- ---------------------------------------------------------------------
-- SOURCE: mv_household_model_follow_up.sql
-- ---------------------------------------------------------------------

-- cht.mv_household_model_follow_up source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_household_model_follow_up;
CREATE MATERIALIZED VIEW cht.mv_household_model_follow_up
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
    (NULLIF((doc -> 'geolocation'::text) ->> 'latitude'::text, ''::text))::double precision AS geolocation_latitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'longitude'::text, ''::text))::double precision AS geolocation_longitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'accuracy'::text, ''::text))::double precision AS geolocation_accuracy,
    (NULLIF((doc -> 'geolocation'::text) ->> 'altitude'::text, ''::text))::double precision AS geolocation_altitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'altitudeAccuracy'::text, ''::text))::double precision AS geolocation_altitude_accuracy,
    (NULLIF((doc -> 'geolocation'::text) ->> 'speed'::text, ''::text))::double precision AS geolocation_speed,
    (NULLIF((doc -> 'geolocation'::text) ->> 'heading'::text, ''::text))::double precision AS geolocation_heading,
    doc #>> '{fields,inputs,source}'::text[] AS inputs_source,
    doc #>> '{fields,inputs,source_id}'::text[] AS inputs_source_id,
    doc #>> '{fields,inputs,t_hh_head_name}'::text[] AS inputs_t_hh_head_name,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    doc #>> '{fields,inputs,contact,parent,village}'::text[] AS inputs_contact_parent_village,
    doc #>> '{fields,inputs,contact,contact,name}'::text[] AS inputs_contact_contact_name,
    doc #>> '{fields,visited_contact_uuid}'::text[] AS visited_contact_uuid,
    doc #>> '{fields,place_id}'::text[] AS place_id,
    doc #>> '{fields,place_name}'::text[] AS place_name,
    doc #>> '{fields,hh_head_name}'::text[] AS hh_head_name,
    doc #>> '{fields,chw_village}'::text[] AS chw_village,
    doc #>> '{fields,current_gps}'::text[] AS current_gps,
    (NULLIF(split_part(doc #>> '{fields,current_gps}'::text[], ' '::text, 1), ''::text))::double precision AS gps_lat,
    (NULLIF(split_part(doc #>> '{fields,current_gps}'::text[], ' '::text, 2), ''::text))::double precision AS gps_long,
    (NULLIF(split_part(doc #>> '{fields,current_gps}'::text[], ' '::text, 3), ''::text))::double precision AS gps_alt,
    (NULLIF(split_part(doc #>> '{fields,current_gps}'::text[], ' '::text, 4), ''::text))::double precision AS gps_accuracy,
    doc #>> '{fields,needs_signoff}'::text[] AS needs_signoff,
    doc #>> '{fields,hh_head}'::text[] AS hh_head,
    doc #>> '{fields,geolocation,latitude}'::text[] AS location_latitude,
    doc #>> '{fields,geolocation,longitude}'::text[] AS location_longitude,
    doc #>> '{fields,geolocation,altitude}'::text[] AS location_altitude,
    doc #>> '{fields,geolocation,accuracy}'::text[] AS location_accuracy,
    doc #>> '{fields,geolocation,note_no_hh_gps}'::text[] AS location_note_no_hh_gps,
    doc #>> '{fields,geolocation,want_to_capture_gps}'::text[] AS location_want_to_capture_gps,
    doc #>> '{fields,geolocation,ensure_gps}'::text[] AS location_ensure_gps,
    doc #>> '{fields,geolocation,gps}'::text[] AS location_gps,
    doc #>> '{fields,geolocation,coordinates}'::text[] AS location_coordinates,
    doc #>> '{fields,geolocation,additional_comments}'::text[] AS location_additional_comments,
    doc #>> '{fields,group_wash,hh_in_sanitary_dwelling_house}'::text[] AS hh_in_sanitary_dwelling_house,
    doc #>> '{fields,group_wash,hh_access_safe_water_source}'::text[] AS hh_access_safe_water_source,
    doc #>> '{fields,group_wash,hh_have_safe_drinking_water}'::text[] AS hh_have_safe_drinking_water,
    doc #>> '{fields,group_wash,hh_have_sanitary_kitchen}'::text[] AS hh_have_sanitary_kitchen,
    doc #>> '{fields,group_wash,hh_have_drying_rack}'::text[] AS hh_have_drying_rack,
    doc #>> '{fields,group_wash,hh_have_backyard_garden}'::text[] AS hh_have_backyard_garden,
    doc #>> '{fields,group_wash,hh_have_rubbish_pit}'::text[] AS hh_have_rubbish_pit,
    doc #>> '{fields,group_wash,hh_have_bath_shelter}'::text[] AS hh_have_bath_shelter,
    doc #>> '{fields,group_wash,hh_sanitary_facility}'::text[] AS hh_sanitary_facility,
    doc #>> '{fields,group_wash,hh_sharing_sanitary_facility}'::text[] AS hh_sharing_sanitary_facility,
    doc #>> '{fields,group_wash,verify_hh_sharing_sanitary_facility}'::text[] AS verify_hh_sharing_sanitary_facility,
    doc #>> '{fields,group_wash,hh_kind_of_public_toilet}'::text[] AS hh_kind_of_public_toilet,
    doc #>> '{fields,group_wash,hh_latrine_fly_proof}'::text[] AS hh_latrine_fly_proof,
    doc #>> '{fields,group_wash,hh_floor_of_toilet_or_latrine}'::text[] AS hh_floor_of_toilet_or_latrine,
    doc #>> '{fields,group_wash,hh_toilet_conected_to_sewer}'::text[] AS hh_toilet_conected_to_sewer,
    doc #>> '{fields,group_wash,hh_sanitary_facility_filled_up}'::text[] AS hh_sanitary_facility_filled_up,
    doc #>> '{fields,group_wash,hh_empited_pit_latrine_or_septic_tank}'::text[] AS hh_empited_pit_latrine_or_septic_tank,
    doc #>> '{fields,group_wash,hh_emptying_services}'::text[] AS hh_emptying_services,
    doc #>> '{fields,group_wash,hh_emptied_contents_location}'::text[] AS hh_emptied_contents_location,
    doc #>> '{fields,group_wash,hh_handwashing_near_toilet_latrine}'::text[] AS hh_handwashing_near_toilet_latrine,
    doc #>> '{fields,group_wash,hh_handwashing_facility_status}'::text[] AS hh_handwashing_facility_status,
    doc #>> '{fields,group_wash,hh_is_odf}'::text[] AS hh_is_odf,
    doc #>> '{fields,hh_model_assessment,hh_have_drying_lines}'::text[] AS hh_have_drying_lines,
    doc #>> '{fields,hh_model_assessment,hh_have_animal_house}'::text[] AS hh_have_animal_house,
    doc #>> '{fields,hh_model_assessment,hh_have_food_storage_access}'::text[] AS hh_have_food_storage_access,
    doc #>> '{fields,hh_model_assessment,hh_compound_well_maintained}'::text[] AS hh_compound_well_maintained,
    doc #>> '{fields,hh_model_assessment,hh_have_vermin_rodent}'::text[] AS hh_have_vermin_rodent,
    doc #>> '{fields,hh_model_assessment,n_train_on_missing_indicators}'::text[] AS n_train_on_missing_indicators,
    doc #>> '{fields,hh_model_assessment,n_animal_house_indicator}'::text[] AS n_animal_house_indicator,
    doc #>> '{fields,hh_model_assessment,n_adequate_drying_lines_indicator}'::text[] AS n_adequate_drying_lines_indicator,
    doc #>> '{fields,hh_model_assessment,n_food_storage_indicator}'::text[] AS n_food_storage_indicator,
    doc #>> '{fields,hh_model_assessment,n_well_maintained_compound_indicator}'::text[] AS n_well_maintained_compound_indicator,
    doc #>> '{fields,hh_model_assessment,n_vermin_rodent_control_indicator}'::text[] AS n_vermin_rodent_control_indicator,
    doc #>> '{fields,hh_model_assessment,follow_household}'::text[] AS follow_household,
    doc #>> '{fields,hh_model_assessment,next_household_follow_up_date}'::text[] AS next_household_follow_up_date,
    doc #>> '{fields,is_model_household}'::text[] AS is_model_household,
    doc #>> '{fields,next_wash_report_task_date}'::text[] AS next_wash_report_task_date,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date 
   FROM dwh.cht_data
    LEFT JOIN cht.mv_chw_hierarchy h ON (dwh.cht_data.doc #>> '{contact,_id}') = h.chw_id
  WHERE (doc ->> 'form'::text) = 'household_model_follow_up'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX mv_household_model_follow_up_chw_id ON cht.mv_household_model_follow_up USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX mv_household_model_follow_up_reported ON cht.mv_household_model_follow_up USING btree (reported) tablespace ts_indexes;
CREATE INDEX mv_household_model_follow_up_year_month_district ON cht.mv_household_model_follow_up USING btree (year, month, district) tablespace ts_indexes;
CREATE INDEX mv_household_model_follow_up_district ON cht.mv_household_model_follow_up USING btree (district) tablespace ts_indexes;
CREATE INDEX mv_household_model_follow_up_facility ON cht.mv_household_model_follow_up USING btree (facility) tablespace ts_indexes;
CREATE INDEX mv_household_model_follow_up_dhis2_facility_id ON cht.mv_household_model_follow_up USING btree (dhis2_facility_id) tablespace ts_indexes;
CREATE INDEX mv_household_model_follow_up_village ON cht.mv_household_model_follow_up USING btree (village) tablespace ts_indexes;
CREATE INDEX mv_household_model_follow_up_region ON cht.mv_household_model_follow_up USING btree (region) tablespace ts_indexes;
