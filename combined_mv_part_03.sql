-- =====================================================================
-- Combined MV creation - PART 03 of 06  (10 views)
-- Generated: 2026-06-07 | Assumes cht.mv_chw_hierarchy exists | all WITH NO DATA
-- Each view is preceded by DROP MATERIALIZED VIEW IF EXISTS (no CASCADE)
-- Files in this part:
--   mv_ha_danger_signs_follow_up.sql
--   mv_household_model_notification.sql
--   mv_maternal_health_education.sql
--   mv_maternal_nutrition_follow_up.sql
--   mv_mute.sql
--   mv_unmute.sql
--   mv_pnc_baby_follow_up.sql
--   mv_pnc_danger_sign.sql
--   mv_pnc_follow_up.sql
--   mv_screening.sql
-- =====================================================================


-- ---------------------------------------------------------------------
-- SOURCE: mv_ha_danger_signs_follow_up.sql
-- ---------------------------------------------------------------------

-- cht.mv_ha_danger_signs_follow_up_new source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_ha_danger_signs_follow_up;
CREATE MATERIALIZED VIEW cht.mv_ha_danger_signs_follow_up
TABLESPACE ts_report
AS SELECT doc ->> '_id'::text AS doc_id,
    doc ->> '_rev'::text AS rev,
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
    doc ->> 'from'::text AS "from",
    doc #>> '{fields,inputs,source}'::text[] AS source,
    doc #>> '{fields,inputs,source_id}'::text[] AS source_id,
    doc #>> '{fields,inputs,t_place_name}'::text[] AS t_place_name,
    doc #>> '{fields,inputs,t_created_by_doc}'::text[] AS t_created_by_doc,
    doc #>> '{fields,inputs,t_place_id}'::text[] AS t_place_id,
    doc #>> '{fields,inputs,t_patient_name}'::text[] AS t_patient_name,
    doc #>> '{fields,inputs,t_patient_id}'::text[] AS t_patient_id,
    doc #>> '{fields,inputs,t_vht_name}'::text[] AS t_vht_name,
    doc #>> '{fields,inputs,t_vht_phone}'::text[] AS t_vht_phone,
    doc #>> '{fields,inputs,t_patient_age_in_years}'::text[] AS t_patient_age_in_years,
    doc #>> '{fields,inputs,t_patient_age_in_months}'::text[] AS t_patient_age_in_months,
    doc #>> '{fields,inputs,t_patient_age_in_days}'::text[] AS t_patient_age_in_days,
    doc #>> '{fields,inputs,t_patient_age_display}'::text[] AS t_patient_age_display,
    doc #>> '{fields,inputs,t_patient_sex}'::text[] AS t_patient_sex,
    doc #>> '{fields,inputs,t_source}'::text[] AS t_source,
    doc #>> '{fields,inputs,t_source_id}'::text[] AS t_source_id,
    doc #>> '{fields,inputs,t_danger_signs}'::text[] AS t_danger_signs,
    doc #>> '{fields,inputs,user,contact_id}'::text[] AS user_contact_id,
    doc #>> '{fields,inputs,user,facility_id}'::text[] AS user_facility_id,
    doc #>> '{fields,place_id}'::text[] AS place_id,
    doc #>> '{fields,place_name}'::text[] AS place_name,
    doc #>> '{fields,needs_signoff}'::text[] AS needs_signoff,
    doc #>> '{fields,additional_doc,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,additional_doc,patient_name}'::text[] AS patient_name,
    doc #>> '{fields,additional_doc,patient_age_in_years}'::text[] AS patient_age_in_years,
    doc #>> '{fields,additional_doc,patient_age_in_months}'::text[] AS patient_age_in_months,
    doc #>> '{fields,additional_doc,patient_age_in_days}'::text[] AS patient_age_in_days,
    doc #>> '{fields,additional_doc,patient_age_display}'::text[] AS patient_age_display,
    doc #>> '{fields,additional_doc,patient_sex}'::text[] AS patient_sex,
    doc #>> '{fields,additional_doc,vht_area_id}'::text[] AS vht_area_id,
    doc #>> '{fields,additional_doc,vht_area_name}'::text[] AS vht_area_name,
    doc #>> '{fields,additional_doc,vht_name}'::text[] AS vht_name,
    doc #>> '{fields,additional_doc,vht_phone}'::text[] AS vht_phone,
    doc #>> '{fields,additional_doc,status}'::text[] AS status,
    doc #>> '{fields,additional_doc,status_other}'::text[] AS status_other,
    doc #>> '{fields,additional_doc,remarks}'::text[] AS remarks,
    doc #>> '{fields,additional_doc,follow_up_date}'::text[] AS follow_up_date,
    doc #>> '{fields,group_danger,danger_signs_note}'::text[] AS danger_signs_note,
    doc #>> '{fields,group_danger,danger_signs}'::text[] AS danger_signs,
    doc #>> '{fields,group_danger,vaginal_bleeding}'::text[] AS vaginal_bleeding,
    doc #>> '{fields,group_danger,lower_abdomen_pain}'::text[] AS lower_abdomen_pain,
    doc #>> '{fields,group_danger,severe_headache}'::text[] AS severe_headache,
    doc #>> '{fields,group_danger,very_pale}'::text[] AS very_pale,
    doc #>> '{fields,group_danger,fever}'::text[] AS fever,
    doc #>> '{fields,group_danger,reduced_or_no_feotal_movements}'::text[] AS reduced_or_no_feotal_movements,
    doc #>> '{fields,group_danger,blurred_vision}'::text[] AS blurred_vision,
    doc #>> '{fields,group_danger,swelling}'::text[] AS swelling,
    doc #>> '{fields,group_danger,breathlessness}'::text[] AS breathlessness,
    doc #>> '{fields,group_danger,woman_danger_sign_fever}'::text[] AS woman_danger_sign_fever,
    doc #>> '{fields,group_danger,woman_danger_sign_severe_headache}'::text[] AS woman_danger_sign_severe_headache,
    doc #>> '{fields,group_danger,woman_danger_sign_vaginal_bleeding}'::text[] AS woman_danger_sign_vaginal_bleeding,
    doc #>> '{fields,group_danger,woman_danger_sign_foul_vaginal_discharge}'::text[] AS woman_danger_sign_foul_vaginal_discharge,
    doc #>> '{fields,group_danger,woman_danger_sign_convulsions}'::text[] AS woman_danger_sign_convulsions,
    doc #>> '{fields,group_danger,child_vomits_everything}'::text[] AS child_vomits_everything,
    doc #>> '{fields,group_danger,child_has_convulsions}'::text[] AS child_has_convulsions,
    doc #>> '{fields,group_danger,child_cannot_drink_breastfeed}'::text[] AS child_cannot_drink_breastfeed,
    doc #>> '{fields,group_danger,child_unconscious}'::text[] AS child_unconscious,
    doc #>> '{fields,group_danger,child_has_low_temp}'::text[] AS child_has_low_temp,
    doc #>> '{fields,group_danger,child_has_yellow_eyes_or_palms}'::text[] AS child_has_yellow_eyes_or_palms,
    doc #>> '{fields,group_danger,child_has_infected_umbilical_cord}'::text[] AS child_has_infected_umbilical_cord,
    doc #>> '{fields,group_danger,child_has_chest_in_drawing}'::text[] AS child_has_chest_in_drawing,
    doc #>> '{fields,group_danger,child_vomiting_everything}'::text[] AS child_vomiting_everything,
    doc #>> '{fields,group_danger,child_has_difficulty_feeding}'::text[] AS child_has_difficulty_feeding,
    doc #>> '{fields,group_danger,child_has_body_stiffness}'::text[] AS child_has_body_stiffness,
    doc #>> '{fields,group_danger,child_has_fever}'::text[] AS child_has_fever,
    doc #>> '{fields,group_danger,child_has_yellow_skin}'::text[] AS child_has_yellow_skin,
    doc #>> '{fields,group_danger,call_button}'::text[] AS call_button,
    doc #>> '{fields,group_danger,action}'::text[] AS action,
    doc #>> '{fields,group_danger,specify}'::text[] AS specify,
    doc #>> '{fields,group_danger,comment}'::text[] AS comment,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date 
   FROM dwh.cht_data couchdb
LEFT JOIN cht.mv_chw_hierarchy h ON (couchdb.doc #>> '{contact,_id}') = h.chw_id
  WHERE (doc ->> 'form'::text) = 'ha_danger_signs_follow_up'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX ha_danger_signs_follow_up_reported_idx ON cht.mv_ha_danger_signs_follow_up USING btree (reported) TABLESPACE ts_indexes;
CREATE INDEX ha_danger_signs_follow_up_chw_id_idx ON cht.mv_ha_danger_signs_follow_up USING btree (chw_id) TABLESPACE ts_indexes;
CREATE INDEX ha_danger_signs_follow_up_district_idx ON cht.mv_ha_danger_signs_follow_up USING btree (district) TABLESPACE ts_indexes;
CREATE INDEX ha_danger_signs_follow_up_facility_idx ON cht.mv_ha_danger_signs_follow_up USING btree (facility) TABLESPACE ts_indexes;
CREATE INDEX mv_ha_danger_signs_follow_up_year_month_district ON cht.mv_ha_danger_signs_follow_up USING btree (year, month, district) TABLESPACE ts_indexes;

-- ---------------------------------------------------------------------
-- SOURCE: mv_household_model_notification.sql
-- ---------------------------------------------------------------------

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
    (NULLIF((doc -> 'geolocation'::text) ->> 'latitude'::text, ''::text))::double precision AS geolocation_latitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'longitude'::text, ''::text))::double precision AS geolocation_longitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'accuracy'::text, ''::text))::double precision AS geolocation_accuracy,
    (NULLIF((doc -> 'geolocation'::text) ->> 'altitude'::text, ''::text))::double precision AS geolocation_altitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'altitudeAccuracy'::text, ''::text))::double precision AS geolocation_altitude_accuracy,
    (NULLIF((doc -> 'geolocation'::text) ->> 'speed'::text, ''::text))::double precision AS geolocation_speed,
    (NULLIF((doc -> 'geolocation'::text) ->> 'heading'::text, ''::text))::double precision AS geolocation_heading,
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
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date 
   FROM dwh.cht_data couchdb
LEFT JOIN cht.mv_chw_hierarchy h ON (couchdb.doc #>> '{contact,_id}') = h.chw_id
  WHERE (doc ->> 'form'::text) = 'household_model_notification'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX mv_household_model_notification_reported ON cht.mv_household_model_notification USING btree (reported) tablespace ts_indexes; 
CREATE INDEX mv_household_model_notificationn_chw_id ON cht.mv_household_model_notification USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX mv_household_model_notification_date ON cht.mv_household_model_notification USING btree (date) tablespace ts_indexes;
CREATE INDEX mv_household_model_notification_year_month_district ON cht.mv_household_model_notification USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX mv_household_model_notification_monthname ON cht.mv_household_model_notification USING btree (monthname) tablespace ts_indexes;
CREATE INDEX mv_household_model_notification_district ON cht.mv_household_model_notification USING btree (district) tablespace ts_indexes;
CREATE INDEX mv_household_model_notification_region ON cht.mv_household_model_notification USING btree (region) tablespace ts_indexes; 
CREATE INDEX mv_household_model_notification_facility ON cht.mv_household_model_notification USING btree (facility) tablespace ts_indexes; 
CREATE INDEX mv_household_model_notification_dhis2_facility_id ON cht.mv_household_model_notification USING btree (dhis2_facility_id) tablespace ts_indexes; 
CREATE INDEX mv_household_model_notification_village ON cht.mv_household_model_notification USING btree (village) tablespace ts_indexes;

-- ---------------------------------------------------------------------
-- SOURCE: mv_maternal_health_education.sql
-- ---------------------------------------------------------------------

-- cht.mv_maternal_health_education_new source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_maternal_health_education;
CREATE MATERIALIZED VIEW cht.mv_maternal_health_education
TABLESPACE ts_report
AS SELECT doc ->> '_id'::text AS doc_id,
    doc ->> '_rev'::text AS rev,
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
    doc ->> 'form'::text AS form,
    doc ->> 'from'::text AS "from",
    doc #>> '{fields,inputs,source}'::text[] AS source,
    doc #>> '{fields,inputs,source_id}'::text[] AS source_id,
    doc #>> '{fields,inputs,current_edd_std}'::text[] AS current_edd_std,
    doc #>> '{fields,inputs,anc_visits}'::text[] AS anc_visits,
    doc #>> '{fields,inputs,t_vaginal_bleeding}'::text[] AS t_vaginal_bleeding,
    doc #>> '{fields,inputs,t_lower_abdomen_pain}'::text[] AS t_lower_abdomen_pain,
    doc #>> '{fields,inputs,t_severe_headache}'::text[] AS t_severe_headache,
    doc #>> '{fields,inputs,t_very_pale}'::text[] AS t_very_pale,
    doc #>> '{fields,inputs,t_fever}'::text[] AS t_fever,
    doc #>> '{fields,inputs,t_reduced_or_no_feotal_movements}'::text[] AS t_reduced_or_no_feotal_movements,
    doc #>> '{fields,inputs,t_blurred_vision}'::text[] AS t_blurred_vision,
    doc #>> '{fields,inputs,t_swelling}'::text[] AS t_swelling,
    doc #>> '{fields,inputs,t_breathlessness}'::text[] AS t_breathlessness,
    doc #>> '{fields,inputs,t_has_hypertension}'::text[] AS t_has_hypertension,
    doc #>> '{fields,inputs,t_hiv_test_result}'::text[] AS t_hiv_test_result,
    doc #>> '{fields,inputs,t_patient_name}'::text[] AS t_patient_name,
    doc #>> '{fields,inputs,t_patient_gender}'::text[] AS t_patient_gender,
    doc #>> '{fields,inputs,t_patient_date_of_birth}'::text[] AS t_patient_date_of_birth,
    doc #>> '{fields,inputs,t_patient_id}'::text[] AS t_patient_id,
    doc #>> '{fields,inputs,user,contact_id}'::text[] AS user_contact_id,
    doc #>> '{fields,inputs,user,facility_id}'::text[] AS user_facility_id,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    doc #>> '{fields,inputs,contact,date_of_birth}'::text[] AS inputs_contact_date_of_birth,
    doc #>> '{fields,inputs,contact,sex}'::text[] AS inputs_contact_sex,
    doc #>> '{fields,inputs,contact,has_hypertension}'::text[] AS inputs_contact_has_hypertension,
    doc #>> '{fields,inputs,contact,hiv_test_result}'::text[] AS inputs_contact_hiv_test_result,
    doc #>> '{fields,dob}'::text[] AS dob,
    doc #>> '{fields,patient_age_in_years}'::text[] AS patient_age_in_years,
    doc #>> '{fields,patient_age_in_months}'::text[] AS patient_age_in_months,
    doc #>> '{fields,patient_age_in_days}'::text[] AS patient_age_in_days,
    doc #>> '{fields,patient_age_display}'::text[] AS patient_age_display,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,patient_name}'::text[] AS patient_name,
    doc #>> '{fields,patient_gender}'::text[] AS patient_gender,
    doc #>> '{fields,current_pregnancy_age_in_weeks}'::text[] AS current_pregnancy_age_in_weeks,
    doc #>> '{fields,no_pregnancy_danger_sign}'::text[] AS no_pregnancy_danger_sign,
    doc #>> '{fields,no_pregnancy_risk_factor}'::text[] AS no_pregnancy_risk_factor,
    doc #>> '{fields,needs_signoff}'::text[] AS needs_signoff,
    doc #>> '{fields,pregnancy_details,is_pregnant}'::text[] AS is_pregnant,
    doc #>> '{fields,pregnancy_details,pregnancy_outcome}'::text[] AS pregnancy_outcome,
    doc #>> '{fields,pregnancy_details,note_vht_delivery_report}'::text[] AS note_vht_delivery_report,
    doc #>> '{fields,pregnancy_details,refer_to_health_facility}'::text[] AS refer_to_health_facility,
    doc #>> '{fields,pregnancy_details,anc_visits_typo}'::text[] AS anc_visits_typo,
    doc #>> '{fields,pregnancy_details,patient_pregnancy_details}'::text[] AS patient_pregnancy_details,
    doc #>> '{fields,pregnancy_details,pregnancy_danger_signs}'::text[] AS pregnancy_danger_signs,
    doc #>> '{fields,pregnancy_details,danger_sign_none}'::text[] AS danger_sign_none,
    doc #>> '{fields,pregnancy_details,vaginal_bleeding}'::text[] AS vaginal_bleeding,
    doc #>> '{fields,pregnancy_details,lower_abdomen_pain}'::text[] AS lower_abdomen_pain,
    doc #>> '{fields,pregnancy_details,severe_headache}'::text[] AS severe_headache,
    doc #>> '{fields,pregnancy_details,very_pale}'::text[] AS very_pale,
    doc #>> '{fields,pregnancy_details,fever}'::text[] AS fever,
    doc #>> '{fields,pregnancy_details,reduced_or_no_feotal_movements}'::text[] AS reduced_or_no_feotal_movements,
    doc #>> '{fields,pregnancy_details,blurred_vision}'::text[] AS blurred_vision,
    doc #>> '{fields,pregnancy_details,swelling}'::text[] AS swelling,
    doc #>> '{fields,pregnancy_details,breathlessness}'::text[] AS breathlessness,
    doc #>> '{fields,pregnancy_details,pregnancy_risk_factors}'::text[] AS pregnancy_risk_factors,
    doc #>> '{fields,pregnancy_details,pregnancy_risk_none}'::text[] AS pregnancy_risk_none,
    doc #>> '{fields,pregnancy_details,below_18}'::text[] AS below_18,
    doc #>> '{fields,pregnancy_details,above_35}'::text[] AS above_35,
    doc #>> '{fields,pregnancy_details,hypertension}'::text[] AS hypertension,
    doc #>> '{fields,pregnancy_details,hiv_positive}'::text[] AS hiv_positive,
    doc #>> '{fields,pregnancy_details,next_maternal_health_date}'::text[] AS next_maternal_health_date,
    doc #>> '{fields,health_education,select_health_condition}'::text[] AS select_health_condition,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date
FROM dwh.cht_data d
LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id
  WHERE (doc ->> 'form'::text) = 'maternal_health_education'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX mv_maternal_health_education_reported ON cht.mv_maternal_health_education USING btree (reported) tablespace ts_indexes;
CREATE INDEX mv_maternal_health_education_chw_id ON cht.mv_maternal_health_education USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX mv_maternal_health_education_year_month_district ON cht.mv_maternal_health_education USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX mv_maternal_health_education_facility ON cht.mv_maternal_health_education USING btree (facility) tablespace ts_indexes;
CREATE INDEX mv_maternal_health_education_district ON cht.mv_maternal_health_education USING btree (district) tablespace ts_indexes;
CREATE INDEX mv_maternal_health_education_region ON cht.mv_maternal_health_education USING btree (region) tablespace ts_indexes;

-- ---------------------------------------------------------------------
-- SOURCE: mv_maternal_nutrition_follow_up.sql
-- ---------------------------------------------------------------------

-- cht.mv_maternal_nutrition_follow_up source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_maternal_nutrition_follow_up;
CREATE MATERIALIZED VIEW cht.mv_maternal_nutrition_follow_up
TABLESPACE ts_report
AS SELECT doc ->> '_id'::text AS doc_id,
    doc ->> '_rev'::text AS rev,
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
    doc ->> 'from'::text AS "from",
    doc #>> '{fields,inputs,source}'::text[] AS source,
    doc #>> '{fields,inputs,source_id}'::text[] AS source_id,
    doc #>> '{fields,inputs,is_referral_follow_up}'::text[] AS is_referral_follow_up,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    doc #>> '{fields,inputs,contact,date_of_birth}'::text[] AS inputs_contact_date_of_birth,
    doc #>> '{fields,inputs,contact,sex}'::text[] AS inputs_contact_sex,
    doc #>> '{fields,inputs,contact,parent,_id}'::text[] AS inputs_parent_id,
    doc #>> '{fields,is_of_child_bearing_age}'::text[] AS is_of_child_bearing_age,
    doc #>> '{fields,patient_age_in_years}'::text[] AS patient_age_in_years,
    doc #>> '{fields,patient_age_in_months}'::text[] AS patient_age_in_months,
    doc #>> '{fields,patient_age_in_days}'::text[] AS patient_age_in_days,
    doc #>> '{fields,patient_age_display}'::text[] AS patient_age_display,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,patient_name}'::text[] AS patient_name,
    doc #>> '{fields,patient_gender}'::text[] AS patient_gender,
    doc #>> '{fields,findings_value}'::text[] AS findings_value,
    doc #>> '{fields,findings_referral_follow_up_value}'::text[] AS findings_referral_follow_up_value,
    doc #>> '{fields,group_malnutrition_follow_up,went_to_facility}'::text[] AS went_to_facility,
    doc #>> '{fields,group_malnutrition_follow_up,note_nutritional_assessment_importance}'::text[] AS note_nutritional_assessment_importance,
    doc #>> '{fields,group_malnutrition_follow_up,referred_to_health_facility}'::text[] AS referred_to_health_facility,
    doc #>> '{fields,group_malnutrition_follow_up,nutrition_status}'::text[] AS nutrition_status,
    doc #>> '{fields,group_malnutrition_follow_up,agreed_facility_visit_date}'::text[] AS agreed_facility_visit_date,
    doc #>> '{fields,group_malnutrition_follow_up,follow_up_outcome}'::text[] AS follow_up_outcome,
    doc #>> '{fields,group_malnutrition_follow_up,next_clinic_visit_date}'::text[] AS next_clinic_visit_date,
    doc #>> '{fields,group_malnutrition_follow_up,educate_woman}'::text[] AS educate_woman,
    doc #>> '{fields,group_malnutrition_follow_up,counsel_and_woman_to_join_support_group}'::text[] AS counsel_and_woman_to_join_support_group,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date
   FROM dwh.cht_data couchdb
    LEFT JOIN cht.mv_chw_hierarchy h ON (couchdb.doc #>> '{contact,_id}') = h.chw_id
  WHERE (doc ->> 'form'::text) = 'maternal_nutrition_follow_up'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX maternal_nutrition_follow_up_reported_idx ON cht.mv_maternal_nutrition_follow_up USING btree (reported) tablespace ts_indexes;
CREATE INDEX maternal_nutrition_follow_up_date_idx ON cht.mv_maternal_nutrition_follow_up USING btree (date) tablespace ts_indexes;
CREATE INDEX mv_maternal_nutrition_follow_up_year_month_district ON cht.mv_maternal_nutrition_follow_up USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX maternal_nutrition_follow_up_monthname_idx ON cht.mv_maternal_nutrition_follow_up USING btree (monthname) tablespace ts_indexes;
CREATE INDEX maternal_nutrition_follow_up_chw_id_idx ON cht.mv_maternal_nutrition_follow_up USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX maternal_nutrition_follow_up_facility_idx ON cht.mv_maternal_nutrition_follow_up USING btree (facility) tablespace ts_indexes;
CREATE INDEX maternal_nutrition_follow_up_dhis2_facility_id_idx ON cht.mv_maternal_nutrition_follow_up USING btree (dhis2_facility_id) tablespace ts_indexes;
CREATE INDEX maternal_nutrition_follow_up_district_idx ON cht.mv_maternal_nutrition_follow_up USING btree (district) tablespace ts_indexes;
CREATE INDEX maternal_nutrition_follow_up_region_idx ON cht.mv_maternal_nutrition_follow_up USING btree (region) tablespace ts_indexes;

-- ---------------------------------------------------------------------
-- SOURCE: mv_mute.sql
-- ---------------------------------------------------------------------

-- cht.mv_mute source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_mute;
CREATE MATERIALIZED VIEW cht.mv_mute
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
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,contact_name}'::text[] AS contact_name,
    doc #>> '{fields,mute_reason}'::text[] AS mute_reason,
    doc #>> '{fields,mute_reason_other}'::text[] AS mute_reason_other,
    doc #>> '{fields,person_muting,g_mute_reason}'::text[] AS g_mute_reason,
    doc #>> '{fields,person_muting,g_mute_reason_other}'::text[] AS g_mute_reason_other,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
FROM dwh.cht_data d
LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id 
  WHERE (doc ->> 'form'::text) = 'mute'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX mv_mute_chw_id ON cht.mv_mute USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX mv_mute_reported ON cht.mv_mute USING btree (reported) tablespace ts_indexes;
CREATE INDEX mv_mute_year_month_district ON cht.mv_mute USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX mv_mute_district ON cht.mv_mute USING btree (district) tablespace ts_indexes;
CREATE INDEX mv_mute_village ON cht.mv_mute USING btree (village) tablespace ts_indexes;

-- ---------------------------------------------------------------------
-- SOURCE: mv_unmute.sql
-- ---------------------------------------------------------------------

-- cht.mv_unmute source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_unmute;
CREATE MATERIALIZED VIEW cht.mv_unmute
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
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,contact_name}'::text[] AS contact_name,
    doc #>> '{fields,unmute_reason}'::text[] AS unmute_reason,
    doc #>> '{fields,unmute_reason_other}'::text[] AS unmute_reason_other,
    doc #>> '{fields,person_unmuting,g_unmute_reason}'::text[] AS g_unmute_reason,
    doc #>> '{fields,person_unmuting,g_unmute_reason_other}'::text[] AS g_unmute_reason_other,
   doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
FROM dwh.cht_data d
LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id
  WHERE (doc ->> 'form'::text) = 'unmute'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX mv_unmute_chw_id ON cht.mv_unmute USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX mv_unmute_reported ON cht.mv_unmute USING btree (reported) tablespace ts_indexes;
CREATE INDEX mv_unmute_year_month_district ON cht.mv_unmute USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX mv_unmute_district_year_month ON cht.mv_unmute USING btree (district, year, month) tablespace ts_indexes;

-- ---------------------------------------------------------------------
-- SOURCE: mv_pnc_baby_follow_up.sql
-- ---------------------------------------------------------------------

-- cht.mv_pnc_baby_follow_up source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_pnc_baby_follow_up;
CREATE MATERIALIZED VIEW cht.mv_pnc_baby_follow_up
TABLESPACE ts_report
AS SELECT doc ->> '_id'::text AS doc_id,
    doc ->> '_rev'::text AS rev,
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
    doc ->> 'form'::text AS form,
    doc ->> 'from'::text AS "from",
    doc #>> '{fields,inputs,source}'::text[] AS source,
    doc #>> '{fields,inputs,source_id}'::text[] AS source_id,
    doc #>> '{fields,inputs,user,contact_id}'::text[] AS user_contact_id,
    doc #>> '{fields,inputs,user,facility_id}'::text[] AS user_facility_id,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    doc #>> '{fields,inputs,contact,date_of_birth}'::text[] AS inputs_contact_date_of_birth,
    doc #>> '{fields,inputs,contact,sex}'::text[] AS inputs_contact_sex,
    doc #>> '{fields,patient_age_in_years}'::text[] AS patient_age_in_years,
    doc #>> '{fields,patient_age_in_months}'::text[] AS patient_age_in_months,
    doc #>> '{fields,patient_age_in_days}'::text[] AS patient_age_in_days,
    doc #>> '{fields,patient_age_display}'::text[] AS patient_age_display,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,patient_name}'::text[] AS patient_name,
    doc #>> '{fields,patient_name_with_s}'::text[] AS patient_name_with_s,
    doc #>> '{fields,patient_gender}'::text[] AS patient_gender,
    doc #>> '{fields,has_danger_signs}'::text[] AS has_danger_signs,
    doc #>> '{fields,pnc_visit_label}'::text[] AS pnc_visit_label,
    doc #>> '{fields,chw_name}'::text[] AS chw_name,
    doc #>> '{fields,chw_phone}'::text[] AS chw_phone,
    doc #>> '{fields,chw_village}'::text[] AS chw_village,
    doc #>> '{fields,group_pnc_visit_details,has_attended_pnc}'::text[] AS has_attended_pnc,
    doc #>> '{fields,group_pnc_visit_details,patient_age_1_day_older}'::text[] AS patient_age_1_day_older,
    doc #>> '{fields,group_pnc_visit_details,pnc_visit}'::text[] AS pnc_visit,
    doc #>> '{fields,group_pnc_visit_details,pnc_visit_date}'::text[] AS pnc_visit_date,
    doc #>> '{fields,group_missed_pnc,reason_missed_pnc}'::text[] AS reason_missed_pnc,
    doc #>> '{fields,group_missed_pnc,other_missed_pnc}'::text[] AS other_missed_pnc,
    doc #>> '{fields,group_missed_pnc,has_agreed_to_pnc_visit}'::text[] AS has_agreed_to_pnc_visit,
    doc #>> '{fields,group_missed_pnc,note_pnc_visit_counsel}'::text[] AS note_pnc_visit_counsel,
    doc #>> '{fields,group_missed_pnc,date_agreed_to_pnc_visit}'::text[] AS date_agreed_to_pnc_visit,
    doc #>> '{fields,group_baby_condition,baby_condition}'::text[] AS baby_condition,
    doc #>> '{fields,group_baby_condition,death_date}'::text[] AS death_date,
    doc #>> '{fields,group_baby_condition,breastfeeding_exclusively}'::text[] AS breastfeeding_exclusively,
    doc #>> '{fields,group_baby_condition,breastfeeding_within_1hour_delivery}'::text[] AS breastfeeding_within_1hour_delivery,
    doc #>> '{fields,group_baby_condition,note_any_danger_signs}'::text[] AS note_any_danger_signs,
    doc #>> '{fields,group_baby_condition,child_has_chest_in_drawing}'::text[] AS child_has_chest_in_drawing,
    doc #>> '{fields,group_baby_condition,child_has_convulsions}'::text[] AS child_has_convulsions,
    doc #>> '{fields,group_baby_condition,child_vomiting_everything}'::text[] AS child_vomiting_everything,
    doc #>> '{fields,group_baby_condition,child_unconscious}'::text[] AS child_unconscious,
    doc #>> '{fields,group_baby_condition,child_has_infected_umbilical_cord}'::text[] AS child_has_infected_umbilical_cord,
    doc #>> '{fields,group_baby_condition,child_has_difficulty_feeding}'::text[] AS child_has_difficulty_feeding,
    doc #>> '{fields,group_baby_condition,child_has_body_stiffness}'::text[] AS child_has_body_stiffness,
    doc #>> '{fields,group_baby_condition,child_has_fever}'::text[] AS child_has_fever,
    doc #>> '{fields,group_baby_condition,child_has_yellow_skin}'::text[] AS child_has_yellow_skin,
    doc #>> '{fields,group_baby_condition,note_refer_to_facility}'::text[] AS note_refer_to_facility,
    doc #>> '{fields,group_baby_condition,referred_to_facility}'::text[] AS referred_to_facility,
    doc #>> '{fields,additional_doc,type}'::text[] AS additional_doc_type,
    doc #>> '{fields,additional_doc,content_type}'::text[] AS additional_doc_content_type,
    doc #>> '{fields,additional_doc,form}'::text[] AS additional_doc_form,
    doc #>> '{fields,additional_doc,contact,_id}'::text[] AS additional_doc_contact__id,
    doc #>> '{fields,additional_doc,parent,_id}'::text[] AS additional_doc_parent__id,
    doc #>> '{fields,additional_doc,fields,inputs,source}'::text[] AS additional_doc_inputs_source,
    doc #>> '{fields,additional_doc,fields,inputs,source_id}'::text[] AS additional_doc_inputs_source_id,
    doc #>> '{fields,additional_doc,fields,created_by_doc}'::text[] AS additional_doc_created_by_doc,
    doc #>> '{fields,additional_doc,fields,client_id}'::text[] AS additional_doc_client_id,
    doc #>> '{fields,additional_doc,fields,client_uuid}'::text[] AS additional_doc_client_uuid,
    doc #>> '{fields,additional_doc,fields,client_name}'::text[] AS additional_doc_client_name,
    doc #>> '{fields,additional_doc,fields,place_id}'::text[] AS additional_doc_place_id,
    doc #>> '{fields,additional_doc,fields,place_name}'::text[] AS additional_doc_place_name,
    doc #>> '{fields,additional_doc,fields,vht_name}'::text[] AS additional_doc_vht_name,
    doc #>> '{fields,additional_doc,fields,vht_phone}'::text[] AS additional_doc_vht_phone,
    doc #>> '{fields,additional_doc,fields,follow_up_date}'::text[] AS additional_doc_follow_up_date,
    doc #>> '{fields,additional_doc,fields,client_age_in_years}'::text[] AS additional_doc_client_age_in_years,
    doc #>> '{fields,additional_doc,fields,client_age_in_months}'::text[] AS additional_doc_client_age_in_months,
    doc #>> '{fields,additional_doc,fields,client_age_in_days}'::text[] AS additional_doc_client_age_in_days,
    doc #>> '{fields,additional_doc,fields,client_age_display}'::text[] AS additional_doc_client_age_display,
    doc #>> '{fields,additional_doc,fields,client_sex}'::text[] AS additional_doc_client_sex,
    doc #>> '{fields,additional_doc,fields,danger_signs,_child_has_chest_in_drawing}'::text[] AS additional_doc_child_has_chest_in_drawing,
    doc #>> '{fields,additional_doc,fields,danger_signs,_child_has_convulsions}'::text[] AS additional_doc_child_has_convulsions,
    doc #>> '{fields,additional_doc,fields,danger_signs,_child_vomiting_everything}'::text[] AS additional_doc_child_vomiting_everything,
    doc #>> '{fields,additional_doc,fields,danger_signs,_child_unconscious}'::text[] AS additional_doc_child_unconscious,
    doc #>> '{fields,additional_doc,fields,danger_signs,_child_has_infected_umbilical_cord}'::text[] AS additional_doc_child_has_infected_umbilical_cord,
    doc #>> '{fields,additional_doc,fields,danger_signs,_child_has_difficulty_feeding}'::text[] AS additional_doc_child_has_difficulty_feeding,
    doc #>> '{fields,additional_doc,fields,danger_signs,_child_has_body_stiffness}'::text[] AS additional_doc_child_has_body_stiffness,
    doc #>> '{fields,additional_doc,fields,danger_signs,_child_has_fever}'::text[] AS additional_doc_child_has_fever,
    doc #>> '{fields,additional_doc,fields,danger_signs,_child_has_yellow_skin}'::text[] AS additional_doc_child_has_yellow_skin,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
FROM dwh.cht_data d
LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id
  WHERE (doc ->> 'form'::text) = 'pnc_baby_follow_up'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX pnc_baby_follow_up_reported_idx ON cht.mv_pnc_baby_follow_up USING btree (reported) TABLESPACE ts_indexes;
CREATE INDEX pnc_baby_follow_up_uuid_idx ON cht.mv_pnc_baby_follow_up USING btree (doc_id) TABLESPACE ts_indexes;
CREATE INDEX pnc_baby_follow_up_chw_id_idx ON cht.mv_pnc_baby_follow_up USING btree (chw_id) TABLESPACE ts_indexes;
CREATE INDEX pnc_baby_follow_up_district_idx ON cht.mv_pnc_baby_follow_up USING btree (district) TABLESPACE ts_indexes;
CREATE INDEX pnc_baby_follow_up_region_idx ON cht.mv_pnc_baby_follow_up USING btree (region) TABLESPACE ts_indexes;
CREATE INDEX pnc_baby_follow_up_village_idx ON cht.mv_pnc_baby_follow_up USING btree (village) TABLESPACE ts_indexes;
CREATE INDEX pnc_baby_follow_up_date_idx ON cht.mv_pnc_baby_follow_up USING btree (date) TABLESPACE ts_indexes;
CREATE INDEX mv_pnc_baby_follow_up_year_month_district ON cht.mv_pnc_baby_follow_up USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX pnc_baby_follow_up_monthname_idx ON cht.mv_pnc_baby_follow_up USING btree (monthname) TABLESPACE ts_indexes;

-- ---------------------------------------------------------------------
-- SOURCE: mv_pnc_danger_sign.sql
-- ---------------------------------------------------------------------

-- cht.mv_pnc_danger_sign source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_pnc_danger_sign;
CREATE MATERIALIZED VIEW cht.mv_pnc_danger_sign
TABLESPACE ts_report
AS SELECT doc ->> '_id'::text AS doc_id,
    doc ->> '_rev'::text AS rev,
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
    doc ->> 'form'::text AS form,
    doc ->> 'from'::text AS "from",
    doc #>> '{fields,inputs,source}'::text[] AS source,
    doc #>> '{fields,inputs,source_id}'::text[] AS source_id,
    doc #>> '{fields,inputs,is_follow_up}'::text[] AS is_follow_up,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    doc #>> '{fields,inputs,contact,date_of_birth}'::text[] AS inputs_contact_date_of_birth,
    doc #>> '{fields,inputs,contact,sex}'::text[] AS inputs_contact_sex,
    doc #>> '{fields,inputs,contact,parent,_id}'::text[] AS inputs_parent_id,
    doc #>> '{fields,is_of_child_bearing_age}'::text[] AS is_of_child_bearing_age,
    doc #>> '{fields,visited_contact_uuid}'::text[] AS visited_contact_uuid,
    doc #>> '{fields,patient_age_in_years}'::text[] AS patient_age_in_years,
    doc #>> '{fields,patient_age_in_months}'::text[] AS patient_age_in_months,
    doc #>> '{fields,patient_age_in_days}'::text[] AS patient_age_in_days,
    doc #>> '{fields,patient_age_display}'::text[] AS patient_age_display,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,patient_name}'::text[] AS patient_name,
    doc #>> '{fields,patient_name_with_s}'::text[] AS patient_name_with_s,
    doc #>> '{fields,patient_gender}'::text[] AS patient_gender,
    doc #>> '{fields,group_danger_sign,visited_health_facility}'::text[] AS visited_health_facility,
    doc #>> '{fields,group_danger_sign,still_experiencing_danger_signs}'::text[] AS still_experiencing_danger_signs,
    doc #>> '{fields,group_danger_sign,note_monitor_till_next_pnc_check_up}'::text[] AS note_monitor_till_next_pnc_check_up,
    doc #>> '{fields,group_danger_sign,note_still_experiencing_danger_signs}'::text[] AS note_still_experiencing_danger_signs,
    doc #>> '{fields,group_danger_sign,note_danger_signs}'::text[] AS note_danger_signs,
    doc #>> '{fields,group_danger_sign,excessive_bleeding}'::text[] AS excessive_bleeding,
    doc #>> '{fields,group_danger_sign,vaginal_discharge}'::text[] AS vaginal_discharge,
    doc #>> '{fields,group_danger_sign,severe_abdominal_pain}'::text[] AS severe_abdominal_pain,
    doc #>> '{fields,group_danger_sign,swelling}'::text[] AS swelling,
    doc #>> '{fields,group_danger_sign,blurred_vision}'::text[] AS blurred_vision,
    doc #>> '{fields,group_danger_sign,fever}'::text[] AS fever,
    doc #>> '{fields,group_danger_sign,excessive_tiredness}'::text[] AS excessive_tiredness,
    doc #>> '{fields,group_danger_sign,breathlessness}'::text[] AS breathlessness,
    doc #>> '{fields,group_danger_sign,has_danger_signs}'::text[] AS has_danger_signs,
    doc #>> '{fields,group_danger_sign,has_no_danger_signs}'::text[] AS has_no_danger_signs,
    doc #>> '{fields,group_danger_sign,note_refer}'::text[] AS note_refer,
    doc #>> '{fields,group_danger_sign,referred_to_facility}'::text[] AS referred_to_facility,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
FROM dwh.cht_data d
LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id 
  WHERE (doc ->> 'form'::text) = 'pnc_danger_sign'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX pnc_danger_sign_reported_idx ON cht.mv_pnc_danger_sign USING btree (reported) tablespace ts_indexes;
CREATE INDEX pnc_danger_sign_date_idx ON cht.mv_pnc_danger_sign USING btree (date) tablespace ts_indexes;
CREATE INDEX mv_pnc_danger_sign_year_month_district ON cht.mv_pnc_danger_sign USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX pnc_danger_sign_monthname_idx ON cht.mv_pnc_danger_sign USING btree (monthname) tablespace ts_indexes;
CREATE INDEX pnc_danger_sign_chw_id_idx ON cht.mv_pnc_danger_sign USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX pnc_danger_sign_facility_idx ON cht.mv_pnc_danger_sign USING btree (facility) tablespace ts_indexes;
CREATE INDEX pnc_danger_sign_dhis2_facility_id_idx ON cht.mv_pnc_danger_sign USING btree (dhis2_facility_id) tablespace ts_indexes;
CREATE INDEX pnc_danger_sign_village_idx ON cht.mv_pnc_danger_sign USING btree (village) tablespace ts_indexes;
CREATE INDEX pnc_danger_sign_district_idx ON cht.mv_pnc_danger_sign USING btree (district) tablespace ts_indexes;
CREATE INDEX pnc_danger_sign_region_idx ON cht.mv_pnc_danger_sign USING btree (region) tablespace ts_indexes;

-- ---------------------------------------------------------------------
-- SOURCE: mv_pnc_follow_up.sql
-- ---------------------------------------------------------------------

-- cht.mv_pnc_follow_up source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_pnc_follow_up;
CREATE MATERIALIZED VIEW cht.mv_pnc_follow_up
TABLESPACE ts_report
AS SELECT doc ->> '_id'::text AS doc_id,
    doc ->> '_rev'::text AS rev,
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
    doc ->> 'form'::text AS form,
    doc ->> 'from'::text AS "from",
    doc #>> '{fields,inputs,source}'::text[] AS source,
    doc #>> '{fields,inputs,source_id}'::text[] AS source_id,
    doc #>> '{fields,inputs,task_name}'::text[] AS task_name,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    doc #>> '{fields,inputs,contact,date_of_birth}'::text[] AS inputs_contact_date_of_birth,
    doc #>> '{fields,inputs,contact,sex}'::text[] AS inputs_contact_sex,
    doc #>> '{fields,inputs,contact,parent,_id}'::text[] AS inputs_parent_id,
    doc #>> '{fields,is_of_child_bearing_age}'::text[] AS is_of_child_bearing_age,
    doc #>> '{fields,patient_age_in_years}'::text[] AS patient_age_in_years,
    doc #>> '{fields,patient_age_in_months}'::text[] AS patient_age_in_months,
    doc #>> '{fields,patient_age_in_days}'::text[] AS patient_age_in_days,
    doc #>> '{fields,patient_age_display}'::text[] AS patient_age_display,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,patient_name}'::text[] AS patient_name,
    doc #>> '{fields,patient_gender}'::text[] AS patient_gender,
    doc #>> '{fields,patient_name_with_s}'::text[] AS patient_name_with_s,
    doc #>> '{fields,nutrition_follow_up_date}'::text[] AS nutrition_follow_up_date,
    doc #>> '{fields,referred_for_nutrition_follow_up}'::text[] AS referred_for_nutrition_follow_up,
    doc #>> '{fields,group_label}'::text[] AS group_label,
    doc #>> '{fields,group_pnc_referral_follow_up,went_facility_as_referred}'::text[] AS went_facility_as_referred,
    doc #>> '{fields,group_missed_referral_details,missed_referral_reason}'::text[] AS missed_referral_reason,
    doc #>> '{fields,group_missed_referral_details,specify_other}'::text[] AS specify_other,
    doc #>> '{fields,group_missed_referral_details,missed_referral_actions}'::text[] AS missed_referral_actions,
    doc #>> '{fields,group_mother_condition,mother_condition}'::text[] AS mother_condition,
    doc #>> '{fields,group_mother_condition,date_of_death}'::text[] AS date_of_death,
    doc #>> '{fields,group_follow_up,is_available}'::text[] AS is_available,
    doc #>> '{fields,group_follow_up,follow_up_again_date}'::text[] AS follow_up_again_date,
    doc #>> '{fields,group_missed_pnc_visit,missed_visit_reason}'::text[] AS missed_visit_reason,
    doc #>> '{fields,group_missed_pnc_visit,missed_visit_reason_other}'::text[] AS missed_visit_reason_other,
    doc #>> '{fields,group_missed_pnc_visit,note_pnc_importance}'::text[] AS note_pnc_importance,
    doc #>> '{fields,group_missed_pnc_visit,agreed_to_go_for_pnc_visit}'::text[] AS agreed_to_go_for_pnc_visit,
    doc #>> '{fields,group_missed_pnc_visit,agreed_date_for_pnc_visit}'::text[] AS agreed_date_for_pnc_visit,
    doc #>> '{fields,group_pnc_visit,has_attended_pnc_facility}'::text[] AS has_attended_pnc_facility,
    doc #>> '{fields,group_pnc_visit,pnc_visit}'::text[] AS pnc_visit,
    doc #>> '{fields,group_pnc_visit,visit_date}'::text[] AS visit_date,
    doc #>> '{fields,group_woman_nutritional_status,note_nutrition_status}'::text[] AS note_nutrition_status,
    doc #>> '{fields,group_woman_nutritional_status,on_nutrition_follow_up}'::text[] AS on_nutrition_follow_up,
    doc #>> '{fields,group_woman_nutritional_status,note_use_muac_tape}'::text[] AS note_use_muac_tape,
    doc #>> '{fields,group_woman_nutritional_status,taken_muac}'::text[] AS taken_muac,
    doc #>> '{fields,group_woman_nutritional_status,muac_measurement}'::text[] AS muac_measurement,
    doc #>> '{fields,group_woman_nutritional_status,note_has_sam}'::text[] AS note_has_sam,
    doc #>> '{fields,group_woman_nutritional_status,note_has_mam}'::text[] AS note_has_mam,
    doc #>> '{fields,group_woman_nutritional_status,note_refer_to_health_facility}'::text[] AS note_refer_to_health_facility,
    doc #>> '{fields,group_woman_nutritional_status,referred_to_health_facility_nutrition}'::text[] AS referred_to_health_facility_nutrition,
    doc #>> '{fields,group_woman_nutritional_status,completed_last_nutrition_follow_up}'::text[] AS completed_last_nutrition_follow_up,
    doc #>> '{fields,group_woman_nutritional_status,next_nutrition_follow_up_date}'::text[] AS next_nutrition_follow_up_date,
    doc #>> '{fields,group_woman_nutritional_status,note_thank_you_nutrition_follow_up}'::text[] AS note_thank_you_nutrition_follow_up,
    doc #>> '{fields,group_woman_nutritional_status,note_refer_did_not_complete_follow_up}'::text[] AS note_refer_did_not_complete_follow_up,
    doc #>> '{fields,group_woman_nutritional_status,referred_to_health_facility_missed_nutrition_follow_up}'::text[] AS referred_to_health_facility_missed_nutrition_follow_up,
    doc #>> '{fields,group_safe_postnatal_practices,note_eat_well}'::text[] AS note_eat_well,
    doc #>> '{fields,group_safe_postnatal_practices,note_exclusive_breast_feeding}'::text[] AS note_exclusive_breast_feeding,
    doc #>> '{fields,group_safe_postnatal_practices,note_keep_baby_warm}'::text[] AS note_keep_baby_warm,
    doc #>> '{fields,group_safe_postnatal_practices,note_use_llin}'::text[] AS note_use_llin,
    doc #>> '{fields,group_safe_postnatal_practices,note_clean_dry_umbilical_cord}'::text[] AS note_clean_dry_umbilical_cord,
    doc #>> '{fields,group_safe_postnatal_practices,note_fp}'::text[] AS note_fp,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
FROM dwh.cht_data d
LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id
  WHERE (doc ->> 'form'::text) = 'pnc_follow_up'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX pnc_follow_up_reported_idx ON cht.mv_pnc_follow_up USING btree (reported) tablespace ts_indexes;
CREATE INDEX pnc_follow_up_date_idx ON cht.mv_pnc_follow_up USING btree (date) tablespace ts_indexes;
CREATE INDEX mv_pnc_follow_up_year_month_district ON cht.mv_pnc_follow_up USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX pnc_follow_up_monthname_idx ON cht.mv_pnc_follow_up USING btree (monthname) tablespace ts_indexes;
CREATE INDEX pnc_follow_up_village_idx ON cht.mv_pnc_follow_up USING btree (village) tablespace ts_indexes;
CREATE INDEX pnc_follow_up_district_idx ON cht.mv_pnc_follow_up USING btree (district) tablespace ts_indexes;
CREATE INDEX pnc_follow_up_region_idx ON cht.mv_pnc_follow_up USING btree (region) tablespace ts_indexes;
CREATE INDEX pnc_follow_up_chw_id_idx ON cht.mv_pnc_follow_up USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX pnc_follow_up_facility_idx ON cht.mv_pnc_follow_up USING btree (facility) tablespace ts_indexes;
CREATE INDEX pnc_follow_up_dhis2_facility_id_idx ON cht.mv_pnc_follow_up USING btree (dhis2_facility_id) tablespace ts_indexes;

-- ---------------------------------------------------------------------
-- SOURCE: mv_screening.sql
-- ---------------------------------------------------------------------

-- cht.mv_screening source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_screening;
CREATE MATERIALIZED VIEW cht.mv_screening
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
    doc #>> '{fields,inputs,contact,date_of_birth}'::text[] AS inputs_contact_date_of_birth,
    doc #>> '{fields,inputs,contact,sex}'::text[] AS inputs_contact_sex,
    doc #>> '{fields,inputs,contact,parent,_id}'::text[] AS inputs_contact_parent_id,
    doc #>> '{fields,visited_contact_uuid}'::text[] AS visited_contact_uuid,
    doc #>> '{fields,patient_age_in_years}'::text[] AS patient_age_in_years,
    doc #>> '{fields,patient_age_in_months}'::text[] AS patient_age_in_months,
    doc #>> '{fields,patient_age_in_days}'::text[] AS patient_age_in_days,
    doc #>> '{fields,patient_age_display}'::text[] AS patient_age_display,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,patient_name}'::text[] AS patient_name,
    doc #>> '{fields,patient_gender}'::text[] AS patient_gender,
    doc #>> '{fields,patient_name_with_s}'::text[] AS patient_name_with_s,
    doc #>> '{fields,today_date}'::text[] AS today_date,
    doc #>> '{fields,is_of_child_bearing_age}'::text[] AS is_of_child_bearing_age,
    doc #>> '{fields,fp_registration_method}'::text[] AS fp_registration_method,
    doc #>> '{fields,group_pregnancy_screening,is_pregnant}'::text[] AS p_is_pregnant,
    doc #>> '{fields,group_pregnancy_screening,has_started_anc}'::text[] AS p_has_started_anc,
    doc #>> '{fields,group_pregnancy_screening,note_refer_to_health_facility_anc}'::text[] AS p_note_refer_to_health_facility_anc,
    doc #>> '{fields,group_pregnancy_screening,referred_to_health_facility_anc}'::text[] AS p_referred_to_health_facility_anc,
    doc #>> '{fields,group_pregnancy_screening,note_register_pregnancy}'::text[] AS p_note_register_pregnancy,
    doc #>> '{fields,group_family_planning_screening,note_fp_registration}'::text[] AS note_fp_registration,
    doc #>> '{fields,group_family_planning_screening,on_fp_method}'::text[] AS on_fp_method,
    doc #>> '{fields,group_family_planning_screening,fp_method}'::text[] AS fp_method,
    doc #>> '{fields,group_family_planning_screening,fp_method_label}'::text[] AS fp_method_label,
    doc #>> '{fields,group_family_planning_screening,experiencing_fp_side_effects}'::text[] AS experiencing_fp_side_effects,
    doc #>> '{fields,group_family_planning_screening,note_refer_counsel_and_refer}'::text[] AS note_refer_counsel_and_refer,
    doc #>> '{fields,group_family_planning_screening,change_fp_method}'::text[] AS change_fp_method,
    doc #>> '{fields,group_family_planning_screening,note_counsel_on_all_fp_methods}'::text[] AS note_counsel_on_all_fp_methods,
    doc #>> '{fields,group_family_planning_screening,counseled_on_fp_methods}'::text[] AS counseled_on_fp_methods,
    doc #>> '{fields,group_family_planning_screening,referred_for_fp_services}'::text[] AS referred_for_fp_services,
    doc #>> '{fields,group_family_planning_screening,follow_up_date_fp_services}'::text[] AS follow_up_date_fp_services,
    doc #>> '{fields,group_family_planning_screening,note_register_using_fp_registration_form}'::text[] AS note_register_using_fp_registration_form,
    doc #>> '{fields,group_family_planning_screening,knows_lmp}'::text[] AS knows_lmp,
    doc #>> '{fields,group_family_planning_screening,lmp_start_date}'::text[] AS lmp_start_date,
    doc #>> '{fields,group_family_planning_screening,days_elapsed_since_lmp}'::text[] AS days_elapsed_since_lmp,
    doc #>> '{fields,group_family_planning_screening,lmp_approximate_date}'::text[] AS lmp_approximate_date,
    doc #>> '{fields,group_family_planning_screening,note_refer_for_pregnancy_test}'::text[] AS note_refer_for_pregnancy_test,
    doc #>> '{fields,group_family_planning_screening,note_educate_on_available_fp_services}'::text[] AS note_educate_on_available_fp_services,
    doc #>> '{fields,group_family_planning_screening,referred_for_pregnancy_test}'::text[] AS referred_for_pregnancy_test,
    doc #>> '{fields,group_family_planning_screening,follow_up_date_pregnancy_test}'::text[] AS follow_up_date_pregnancy_test,
    doc #>> '{fields,group_hiv_screening,test_for_hiv_last3months}'::text[] AS hiv_test_for_hiv_last3months,
    doc #>> '{fields,group_hiv_screening,hiv_test_result}'::text[] AS hiv_hiv_test_result,
    doc #>> '{fields,group_hiv_screening,tested_hiv}'::text[] AS hiv_tested_hiv,
    doc #>> '{fields,group_hiv_screening,not_tested_hiv}'::text[] AS hiv_not_tested_hiv,
    doc #>> '{fields,group_hiv_screening,on_art_treatment}'::text[] AS hiv_on_art_treatment,
    doc #>> '{fields,group_hiv_screening,note_attend_art_clinic}'::text[] AS hiv_note_attend_art_clinic,
    doc #>> '{fields,group_hiv_screening,taking_medication}'::text[] AS hiv_taking_medication,
    doc #>> '{fields,group_hiv_screening,note_explain_importance_taking_med}'::text[] AS hiv_note_explain_importance_taking_med,
    doc #>> '{fields,group_hiv_screening,note_encourage_to_continue_taking_med}'::text[] AS hiv_note_encourage_to_continue_taking_med,
    doc #>> '{fields,group_hiv_screening,note_encourage_client}'::text[] AS hiv_note_encourage_client,
    doc #>> '{fields,group_hiv_screening,note_advise_client_check_status}'::text[] AS hiv_note_advise_client_check_status,
    doc #>> '{fields,group_hiv_screening,note_advise_client_check_status2}'::text[] AS hiv_note_advise_client_check_status2,
    doc #>> '{fields,group_tb_screening,has_tb}'::text[] AS has_tb,
    doc #>> '{fields,group_tb_screening,on_tb_treatment}'::text[] AS on_tb_treatment,
    doc #>> '{fields,group_tb_screening,note_refer_not_on_tb_treatment}'::text[] AS note_refer_not_on_tb_treatment,
    doc #>> '{fields,group_other_screening,hpv_card}'::text[] AS other_hpv_card,
    doc #>> '{fields,group_other_screening,received_hpv}'::text[] AS other_received_hpv,
    doc #>> '{fields,group_other_screening,check_hpv_note}'::text[] AS other_check_hpv_note,
    doc #>> '{fields,group_other_screening,educate_hpv_note}'::text[] AS other_educate_hpv_note,
    doc #>> '{fields,group_other_screening,afp_vpd}'::text[] AS other_afp_vpd,
    doc #>> '{fields,group_other_screening,refer_afp}'::text[] AS other_refer_afp,
    doc #>> '{fields,group_other_screening,received_tt_vaccine}'::text[] AS other_received_tt_vaccine,
    doc #>> '{fields,group_other_screening,has_hypertension}'::text[] AS other_has_hypertension,
    doc #>> '{fields,group_other_screening,has_sickle_cell}'::text[] AS other_has_sickle_cell,
    doc #>> '{fields,group_other_screening,uses_tobacco}'::text[] AS other_uses_tobacco,
    doc #>> '{fields,group_other_screening,sleep_under_llin}'::text[] AS other_sleep_under_llin,
    doc #>> '{fields,group_other_screening,why_not_using_llin}'::text[] AS other_why_not_using_llin,
    doc #>> '{fields,group_other_screening,why_not_using_llin_other}'::text[] AS other_why_not_using_llin_other,
    doc #>> '{fields,group_other_screening,note_vht_assist_how_to_get_llin}'::text[] AS other_note_vht_assist_how_to_get_llin,
    doc #>> '{fields,group_other_screening,note_vht_demonstrate_on_llin_use}'::text[] AS other_note_vht_demonstrate_on_llin_use,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
FROM dwh.cht_data d
LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id
  WHERE (doc ->> 'form'::text) = 'screening'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX mv_screening_chw_id ON cht.mv_screening USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX mv_screening_reported ON cht.mv_screening USING btree (reported) tablespace ts_indexes;
CREATE INDEX mv_screening_date ON cht.mv_screening USING btree (date) tablespace ts_indexes;
CREATE INDEX mv_screening_year_month_district ON cht.mv_screening USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX mv_screening_monthname ON cht.mv_screening USING btree (monthname) tablespace ts_indexes;
CREATE INDEX mv_screening_district ON cht.mv_screening USING btree (district) tablespace ts_indexes;
CREATE INDEX mv_screening_region ON cht.mv_screening USING btree (region) tablespace ts_indexes;
CREATE INDEX mv_screening_facility ON cht.mv_screening USING btree (facility) tablespace ts_indexes;
CREATE INDEX mv_screening_dhis2_facility_id ON cht.mv_screening USING btree (dhis2_facility_id) tablespace ts_indexes;
