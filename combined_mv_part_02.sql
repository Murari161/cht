-- =====================================================================
-- Combined MV creation - PART 02 of 06  (11 views)
-- Generated: 2026-06-07 | Assumes cht.mv_chw_hierarchy exists | all WITH NO DATA
-- Each view is preceded by DROP MATERIALIZED VIEW IF EXISTS (no CASCADE)
-- Files in this part:
--   mv_child_health_escalation.sql
--   mv_child_health_notification.sql
--   mv_child_nutrition_referral_follow_up.sql
--   mv_community_death_notification.sql
--   mv_death_report.sql
--   mv_death_notification.sql
--   mv_delivery.sql
--   mv_delivery_check.sql
--   mv_drowning_workflow.sql
--   mv_fp_follow_up.sql
--   mv_fp_referral_follow_up.sql
-- =====================================================================


-- ---------------------------------------------------------------------
-- SOURCE: mv_child_health_escalation.sql
-- ---------------------------------------------------------------------

-- cht.mv_child_health_escalation source

DROP MATERIALIZED VIEW IF EXISTS cht.mv_child_health_escalation;
CREATE MATERIALIZED VIEW cht.mv_child_health_escalation
TABLESPACE ts_report
AS SELECT doc ->> '_id'::text AS doc_id,
    doc ->> '_rev'::text AS rev,
    doc ->> 'form'::text AS form,
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
    doc ->> 'from'::text AS submitter,
    doc ->> 'content_type'::text AS top_content_type,
    to_timestamp((NULLIF(doc #>> '{form_version,time}'::text[], ''::text)::bigint::numeric / 1000.0)::double precision) AS form_version_time,
    doc #>> '{fields,inputs,source}'::text[] AS inputs_source,
    doc #>> '{fields,inputs,source_id}'::text[] AS source_id,
    doc #>> '{fields,inputs,user,contact_id}'::text[] AS inputs_chw_id,
    doc #>> '{fields,inputs,t_place_name}'::text[] AS village_name,
    doc #>> '{fields,inputs,t_vht_name}'::text[] AS t_vht_name,
    doc #>> '{fields,inputs,t_vht_phone}'::text[] AS t_vht_phone,
    doc #>> '{fields,inputs,t_danger_signs}'::text[] AS t_danger_signs,
    doc #>> '{fields,inputs,t_blood_in_stool}'::text[] AS t_blood_in_stool,
    doc #>> '{fields,inputs,t_cough_duration}'::text[] AS t_cough_duration,
    doc #>> '{fields,inputs,t_fast_breathing}'::text[] AS t_fast_breathing,
    doc #>> '{fields,inputs,t_fever_duration}'::text[] AS t_fever_duration,
    doc #>> '{fields,inputs,t_chest_indrawing}'::text[] AS t_chest_indrawing,
    doc #>> '{fields,inputs,t_diarrhoea_duration}'::text[] AS t_diarrhoea_duration,
    doc #>> '{fields,inputs,t_immunization_referral}'::text[] AS t_immunization_referral,
    doc #>> '{fields,dob}'::text[] AS dob,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,patient_name}'::text[] AS patient_name,
    doc #>> '{fields,patient_gender}'::text[] AS patient_gender,
    doc #>> '{fields,patient_age_display}'::text[] AS patient_age_display,
    doc #>> '{fields,patient_age_in_days}'::text[] AS patient_age_in_days,
    doc #>> '{fields,patient_age_in_months}'::text[] AS patient_age_in_months,
    doc #>> '{fields,patient_age_in_years}'::text[] AS patient_age_in_years,
    doc #>> '{fields,needs_signoff}'::text[] AS needs_signoff,
    doc #>> '{fields,action_taken,completed_referral_follow_up}'::text[] AS completed_referral_follow_up,
    doc #>> '{fields,action_taken,reason_vht_did_not_follow_up}'::text[] AS reason_vht_did_not_follow_up,
    doc #>> '{fields,action_taken,specify}'::text[] AS reason_specify,
    doc #>> '{fields,action_taken,text_explain_vht_did_not_submit_form}'::text[] AS text_explain_vht_did_not_submit_form,
    doc #>> '{fields,action_taken,call_chw}'::text[] AS action_call_chw,
    doc #>> '{fields,action_taken,call_button}'::text[] AS action_call_button,
    doc #>> '{fields,action_taken,note_health_educate}'::text[] AS note_health_educate,
    doc #>> '{fields,danger_signs,referral_signs}'::text[] AS danger_signs_referral_signs,
    doc #>> '{fields,danger_signs,vomits_everything}'::text[] AS danger_signs_vomits_everything,
    doc #>> '{fields,danger_signs,convulsions}'::text[] AS danger_signs_convulsions,
    doc #>> '{fields,danger_signs,very_sleepy}'::text[] AS danger_signs_very_sleepy,
    doc #>> '{fields,danger_signs,smaller_than_usual}'::text[] AS danger_signs_smaller_than_usual,
    doc #>> '{fields,danger_signs,infected_umblical_cord}'::text[] AS danger_signs_infected_umblical_cord,
    doc #>> '{fields,danger_signs,chest_in_drawing}'::text[] AS danger_signs_chest_in_drawing,
    doc #>> '{fields,danger_signs,not_able_to_breastfeed}'::text[] AS danger_signs_not_able_to_breastfeed,
    doc #>> '{fields,danger_signs,many_pustules}'::text[] AS danger_signs_many_pustules,
    doc #>> '{fields,danger_signs,fever_or_low_temperature}'::text[] AS danger_signs_fever_or_low_temperature,
    doc #>> '{fields,danger_signs,yellow_eyes}'::text[] AS danger_signs_yellow_eyes,
    doc #>> '{fields,danger_signs,cough}'::text[] AS danger_signs_cough,
    doc #>> '{fields,danger_signs,diarrhoea}'::text[] AS danger_signs_diarrhoea,
    doc #>> '{fields,danger_signs,blood_in_stool}'::text[] AS danger_signs_blood_in_stool,
    doc #>> '{fields,danger_signs,fever_duration}'::text[] AS danger_signs_fever_duration,
    doc #>> '{fields,danger_signs,immunization_missed}'::text[] AS danger_signs_immunization_missed,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
   FROM dwh.cht_data couchdb
LEFT JOIN cht.mv_chw_hierarchy h ON (couchdb.doc #>> '{contact,_id}') = h.chw_id
  WHERE (doc ->> 'form'::text) = 'child_health_escalation'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX mv_child_health_escalation_patient ON cht.mv_child_health_escalation USING btree (patient_id) tablespace ts_indexes;
CREATE INDEX mv_child_health_escalation_reported ON cht.mv_child_health_escalation USING btree (reported) tablespace ts_indexes;
CREATE INDEX mv_child_health_escalation_chw_id ON cht.mv_child_health_escalation USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX mv_child_health_escalation_district ON cht.mv_child_health_escalation USING btree (district) tablespace ts_indexes;
CREATE INDEX mv_child_health_escalation_facility ON cht.mv_child_health_escalation USING btree (facility) tablespace ts_indexes; 
CREATE INDEX mv_child_health_escalation_year_month_district ON cht.mv_child_health_escalation USING btree (year, month, district) TABLESPACE ts_indexes;

-- ---------------------------------------------------------------------
-- SOURCE: mv_child_health_notification.sql
-- ---------------------------------------------------------------------

-- cht.mv_child_health_notification source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_child_health_notification;
CREATE MATERIALIZED VIEW cht.mv_child_health_notification
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
    doc #>> '{fields,dob}'::text[] AS dob,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS contact_id,
    doc #>> '{fields,inputs,contact,date_of_birth}'::text[] AS contact_date_of_birth,
    doc #>> '{fields,inputs,contact,name}'::text[] AS contact_name,
    doc #>> '{fields,inputs,contact,sex}'::text[] AS contact_sex,
    doc #>> '{fields,inputs,source}'::text[] AS source,
    doc #>> '{fields,inputs,source_id}'::text[] AS source_id,
    doc #>> '{fields,inputs,t_patient_condition}'::text[] AS t_patient_condition,
    doc #>> '{fields,inputs,t_patient_date_of_birth}'::text[] AS t_patient_date_of_birth,
    doc #>> '{fields,inputs,t_patient_gender}'::text[] AS t_patient_gender,
    doc #>> '{fields,inputs,t_patient_id}'::text[] AS t_patient_id,
    doc #>> '{fields,inputs,t_patient_name}'::text[] AS t_patient_name,
    doc #>> '{fields,inputs,t_place_name}'::text[] AS t_place_name,
    doc #>> '{fields,inputs,t_vht_name}'::text[] AS t_vht_name,
    doc #>> '{fields,inputs,t_vht_phone}'::text[] AS t_vht_phone,
    doc #>> '{fields,inputs,user,contact_id}'::text[] AS user_contact_id,
    doc #>> '{fields,inputs,user,facility_id}'::text[] AS user_facility_id,
    doc #>> '{fields,needs_signoff}'::text[] AS needs_signoff,
    doc #>> '{fields,patient_age_display}'::text[] AS patient_age_display,
    doc #>> '{fields,patient_age_in_days}'::text[] AS patient_age_in_days,
    doc #>> '{fields,patient_age_in_months}'::text[] AS patient_age_in_months,
    doc #>> '{fields,patient_age_in_years}'::text[] AS patient_age_in_years,
    doc #>> '{fields,patient_gender}'::text[] AS patient_gender,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,patient_name}'::text[] AS patient_name,
    doc #>> '{fields,referral_details_note}'::text[] AS referral_details_note,
    doc #>> '{fields,referral_details,health_note}'::text[] AS health_note,
    doc #>> '{fields,danger_sign_check,follow_up_child}'::text[] AS follow_up_child,
    doc #>> '{fields,danger_sign_check,client_condition}'::text[] AS client_condition,
    doc #>> '{fields,referral,taken_to_facility}'::text[] AS taken_to_facility,
    doc #>> '{fields,referral,refer_to_facility}'::text[] AS refer_to_facility,
    doc #>> '{fields,referral,confirm_refer_to_facility}'::text[] AS confirm_refer_to_facility,
    doc #>> '{fields,health_education,select_health_condition}'::text[] AS select_health_condition,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date 
   FROM dwh.cht_data couchdb
LEFT JOIN cht.mv_chw_hierarchy h ON (couchdb.doc #>> '{contact,_id}') = h.chw_id
  WHERE (doc ->> 'form'::text) = 'child_health_notification'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX mv_child_health_notification_reported ON cht.mv_child_health_notification USING btree (reported) tablespace ts_indexes;
CREATE INDEX mv_child_health_notification_date ON cht.mv_child_health_notification USING btree (date) tablespace ts_indexes;
CREATE INDEX mv_child_health_notification_year_month_district ON cht.mv_child_health_notification USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX mv_child_health_notification_chw_id ON cht.mv_child_health_notification USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX mv_child_health_notification_district ON cht.mv_child_health_notification USING btree (district) tablespace ts_indexes;
CREATE INDEX mv_child_health_notification_region ON cht.mv_child_health_notification USING btree (region) tablespace ts_indexes;
CREATE INDEX mv_child_health_notification_facility ON cht.mv_child_health_notification USING btree (facility) tablespace ts_indexes;
CREATE INDEX mv_child_health_notification_dhis2_facility_id ON cht.mv_child_health_notification USING btree (dhis2_facility_id) tablespace ts_indexes;  

-- ---------------------------------------------------------------------
-- SOURCE: mv_child_nutrition_referral_follow_up.sql
-- ---------------------------------------------------------------------

-- cht.mv_child_nutrition_referral_follow_up source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_child_nutrition_referral_follow_up;
CREATE MATERIALIZED VIEW cht.mv_child_nutrition_referral_follow_up
TABLESPACE ts_report
AS SELECT doc ->> '_id'::text AS uuid,
    doc ->> 'form'::text AS form,
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
    doc ->> 'from'::text AS submitter,
    doc ->> '_rev'::text AS rev,
    doc ->> 'content_type'::text AS top_content_type,
    to_timestamp((NULLIF(doc #>> '{form_version,time}'::text[], ''::text)::bigint::numeric / 1000.0)::double precision) AS form_version_time,
    doc #>> '{fields,inputs,source}'::text[] AS source,
    doc #>> '{fields,inputs,source_id}'::text[] AS source_id,
    doc #>> '{fields,inputs,t_acute_malnutrition_signs}'::text[] AS t_acute_malnutrition_signs,
    doc #>> '{fields,inputs,t_appears_too_small}'::text[] AS t_appears_too_small,
    doc #>> '{fields,inputs,t_muac_color}'::text[] AS t_muac_color,
    doc #>> '{fields,inputs,t_patient_date_of_birth}'::text[] AS t_patient_date_of_birth,
    doc #>> '{fields,inputs,t_patient_gender}'::text[] AS t_patient_gender,
    doc #>> '{fields,inputs,t_patient_id}'::text[] AS t_patient_id,
    doc #>> '{fields,inputs,t_patient_name}'::text[] AS t_patient_name,
    doc #>> '{fields,inputs,t_place_name}'::text[] AS t_place_name,
    doc #>> '{fields,inputs,t_vht_name}'::text[] AS t_vht_name,
    doc #>> '{fields,inputs,t_vht_phone}'::text[] AS t_vht_phone,
    doc #>> '{fields,needs_signoff}'::text[] AS needs_signoff,
    doc #>> '{fields,patient_age_display}'::text[] AS patient_age_display,
    doc #>> '{fields,patient_age_in_days}'::text[] AS patient_age_in_days,
    doc #>> '{fields,patient_age_in_months}'::text[] AS patient_age_in_months,
    doc #>> '{fields,patient_age_in_years}'::text[] AS patient_age_in_years,
    doc #>> '{fields,referral_notification,referral_signs}'::text[] AS referral_signs,
    doc #>> '{fields,referral_notification,note_yellow_muac}'::text[] AS note_yellow_muac,
    doc #>> '{fields,referral_notification,note_hair_colour_change}'::text[] AS note_hair_colour_change,
    doc #>> '{fields,referral_notification,confirm_child_taken_to_facility}'::text[] AS confirm_child_taken_to_facility,
    doc #>> '{fields,referral_notification,note_swelling_both_feet}'::text[] AS note_swelling_both_feet,
    doc #>> '{fields,referral_notification,note_too_thin}'::text[] AS note_too_thin,
    doc #>> '{fields,referral_notification,note_red_muac}'::text[] AS note_red_muac,
    doc #>> '{fields,referral_notification,note_too_small_for_age}'::text[] AS note_too_small_for_age,
    doc #>> '{fields,referral_completion,taken_to_facility}'::text[] AS taken_to_facility,
    doc #>> '{fields,referral_completion,remind_care_giver}'::text[] AS remind_care_giver,
    doc #>> '{fields,referral_completion,nutritional_status}'::text[] AS nutritional_status,
    doc #>> '{fields,referral_completion,next_nutrition_visit_date}'::text[] AS next_nutrition_visit_date,
    doc #>> '{fields,referral_completion,educate_caregiver}'::text[] AS educate_caregiver,
    doc #>> '{fields,food_and_good_nutrition,food_and_good_nutrition_choices}'::text[] AS food_and_good_nutrition_choices,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date
   FROM dwh.cht_data
LEFT JOIN cht.mv_chw_hierarchy h ON (doc #>> '{contact,_id}') = h.chw_id
  WHERE (doc ->> 'form'::text) = 'child_nutrition_referral_follow_up'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX useview_child_nutrition_referral_follow_up_reported ON cht.mv_child_nutrition_referral_follow_up USING btree (reported) tablespace ts_indexes;
CREATE INDEX useview_child_nutrition_referral_follow_up_chw_id ON cht.mv_child_nutrition_referral_follow_up USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX useview_child_nutrition_referral_follow_up_district ON cht.mv_child_nutrition_referral_follow_up USING btree (district) tablespace ts_indexes;
CREATE INDEX useview_child_nutrition_referral_follow_up_facility ON cht.mv_child_nutrition_referral_follow_up USING btree (facility) tablespace ts_indexes; 
CREATE INDEX mv_child_nutrition_referral_follow_up_year_month_district ON cht.mv_child_nutrition_referral_follow_up USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX useview_child_nutrition_referral_follow_up_patient_id ON cht.mv_child_nutrition_referral_follow_up USING btree (t_patient_id) tablespace ts_indexes;

-- ---------------------------------------------------------------------
-- SOURCE: mv_community_death_notification.sql
-- ---------------------------------------------------------------------

-- cht.mv_community_death_notification source

DROP MATERIALIZED VIEW IF EXISTS cht.mv_community_death_notification;
CREATE MATERIALIZED VIEW cht.mv_community_death_notification
TABLESPACE ts_report
AS SELECT d.doc ->> '_id'::text AS uuid,
    d.doc ->> 'form'::text AS form,
    d.doc ->> 'from'::text AS submitter,
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
    h.chw_name AS chw_name,
    h.phone,
    h.role,
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 'source'::text AS source,
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 'source_id'::text AS source_id,
    (((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> '_id'::text AS contact_id,
    (((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> 'name'::text AS contact_name,
    (((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> 'date_of_birth'::text AS contact_date_of_birth,
    ((d.doc -> 'fields'::text) -> 'reporter_info'::text) ->> 'head_household_name'::text AS head_household_name,
    ((d.doc -> 'fields'::text) -> 'reporter_info'::text) ->> 'head_household_contact'::text AS head_household_contact,
    ((d.doc -> 'fields'::text) -> 'reporter_info'::text) ->> 'mother_name'::text AS mother_name,
    ((d.doc -> 'fields'::text) -> 'reporter_info'::text) ->> 'mother_dob'::text AS mother_dob,
    ((d.doc -> 'fields'::text) -> 'reporter_info'::text) ->> 'mother_age'::text AS mother_age,
    ((d.doc -> 'fields'::text) -> 'reporter_info'::text) ->> 'mother_pregnanies'::text AS mother_pregnanies,
    ((d.doc -> 'fields'::text) -> 'reporter_info'::text) ->> 'mother_village'::text AS mother_village,
    ((d.doc -> 'fields'::text) -> 'reporter_info'::text) ->> 'Woman_parish'::text AS woman_parish,
    ((d.doc -> 'fields'::text) -> 'reporter_info'::text) ->> 'Woman_subcounty'::text AS woman_subcounty,
    ((d.doc -> 'fields'::text) -> 'reporter_info'::text) ->> 'Woman_district'::text AS woman_district,
    ((d.doc -> 'fields'::text) -> 'reporter_info'::text) ->> 'Woman_Usual_Res'::text AS woman_usual_residence,
    ((d.doc -> 'fields'::text) -> 'reporter_info'::text) ->> 'Woman_Temp_village'::text AS woman_temporary_village,
    ((d.doc -> 'fields'::text) -> 'reporter_info'::text) ->> 'Woman_Temp_Parish'::text AS woman_temporary_parish,
    ((d.doc -> 'fields'::text) -> 'reporter_info'::text) ->> 'Woman_Temp_subcounty'::text AS woman_temporary_subcounty,
    ((d.doc -> 'fields'::text) -> 'reporter_info'::text) ->> 'Woman_Temp_District'::text AS woman_temporary_district,
    ((d.doc -> 'fields'::text) -> 'reporter_info'::text) ->> 'Informer_name'::text AS informer_name,
    ((d.doc -> 'fields'::text) -> 'reporter_info'::text) ->> 'Informer_contact'::text AS informer_contact,
    ((d.doc -> 'fields'::text) -> 'death_type'::text) ->> 'death_category'::text AS death_category,
    ((d.doc -> 'fields'::text) -> 'mothers_details'::text) ->> 'mother_death_timing'::text AS mother_death_timing,
    ((d.doc -> 'fields'::text) -> 'mothers_details'::text) ->> 'Woman_Nationality'::text AS woman_nationality,
    ((d.doc -> 'fields'::text) -> 'mothers_details'::text) ->> 'mother_date_of_death'::text AS mother_date_of_death,
    ((d.doc -> 'fields'::text) -> 'mothers_details'::text) ->> 'mother_time_of_death'::text AS mother_time_of_death,
    ((d.doc -> 'fields'::text) -> 'mothers_details'::text) ->> 'MD_Weeks'::text AS maternal_death_weeks,
    ((d.doc -> 'fields'::text) -> 'mothers_details'::text) ->> 'mother_days_after_delivery'::text AS mother_days_after_delivery,
    ((d.doc -> 'fields'::text) -> 'mothers_details'::text) ->> 'mother_place_of_death'::text AS mother_place_of_death,
    ((d.doc -> 'fields'::text) -> 'mothers_details'::text) ->> 'MD_Place_Spec'::text AS maternal_death_place,
    ((d.doc -> 'fields'::text) -> 'mothers_details'::text) ->> 'mother_cause_of_death'::text AS mother_cause_of_death,
    ((d.doc -> 'fields'::text) -> 'mothers_details'::text) ->> 'MD_Carer'::text AS carer_for_mother_before_death,
    ((d.doc -> 'fields'::text) -> 'mothers_details'::text) ->> 'MD_Carer_Rel'::text AS carer_relationship_to_mother,
    ((d.doc -> 'fields'::text) -> 'mothers_details'::text) ->> 'MD_Carer_Contact'::text AS carer_contact,
    ((d.doc -> 'fields'::text) -> 'baby_details'::text) ->> 'baby_place_of_birth'::text AS baby_place_of_birth,
    ((d.doc -> 'fields'::text) -> 'baby_details'::text) ->> 'baby_sex'::text AS baby_sex,
    ((d.doc -> 'fields'::text) -> 'baby_details'::text) ->> 'baby_birth_date'::text AS baby_birth_date,
    ((d.doc -> 'fields'::text) -> 'baby_details'::text) ->> 'baby_birth_time'::text AS baby_birth_time,
    ((d.doc -> 'fields'::text) -> 'baby_details'::text) ->> 'baby_death_date'::text AS baby_death_date,
    ((d.doc -> 'fields'::text) -> 'baby_details'::text) ->> 'baby_death_time'::text AS baby_death_time,
    ((d.doc -> 'fields'::text) -> 'baby_details'::text) ->> 'NND_24'::text AS neonatal_death_24,
    ((d.doc -> 'fields'::text) -> 'baby_details'::text) ->> 'NND_age_H'::text AS neonatal_age_hours,
    ((d.doc -> 'fields'::text) -> 'baby_details'::text) ->> 'NND_age_days'::text AS neonatal_death_age_days,
    ((d.doc -> 'fields'::text) -> 'baby_details'::text) ->> 'baby_place_of_death'::text AS baby_place_of_death,
    ((d.doc -> 'fields'::text) -> 'baby_details'::text) ->> 'NND_place_Spec'::text AS neonatal_death_place,
    ((d.doc -> 'fields'::text) -> 'baby_details'::text) ->> 'NND_Cause'::text AS neonatal_death_cause,
    ((d.doc -> 'fields'::text) -> 'baby_details'::text) ->> 'NND_Mother'::text AS neonate_with_mother,
    ((d.doc -> 'fields'::text) -> 'baby_details'::text) ->> 'NND_carer'::text AS neonate_with_carer,
    ((d.doc -> 'fields'::text) -> 'baby_details'::text) ->> 'NND_carer_contact'::text AS neonate_with_carer_contact,
    ((d.doc -> 'fields'::text) -> 'baby_details'::text) ->> 'baby_multiple_pregnancy'::text AS baby_multiple_pregnancy,
    ((d.doc -> 'fields'::text) -> 'baby_details'::text) ->> 'baby_multiple_howmany'::text AS baby_multiple_howmany,
    ((d.doc -> 'fields'::text) -> 'baby_details'::text) ->> 'NND_other_death'::text AS neonatal_other_death,
    ((d.doc -> 'fields'::text) -> 'baby_details'::text) ->> 'other_babies_alive'::text AS other_babies_alive,
    ((d.doc -> 'fields'::text) -> 'baby_details_stillbirth'::text) ->> 'SB_date'::text AS still_birth_date,
    ((d.doc -> 'fields'::text) -> 'baby_details_stillbirth'::text) ->> 'SB_time'::text AS still_birth_time,
    ((d.doc -> 'fields'::text) -> 'baby_details_stillbirth'::text) ->> 'SB_sex'::text AS still_birth_sex,
    ((d.doc -> 'fields'::text) -> 'baby_details_stillbirth'::text) ->> 'SB_place'::text AS still_birth_place,
    ((d.doc -> 'fields'::text) -> 'baby_details_stillbirth'::text) ->> 'SB_place_spec'::text AS still_birth_place_spec,
    ((d.doc -> 'fields'::text) -> 'baby_details_stillbirth'::text) ->> 'Comment'::text AS comment,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date 
   FROM dwh.cht_data d
     LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id
  WHERE (d.doc ->> 'form'::text) = 'community_death_notification'::text AND d.is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX mv_community_death_notification_chw ON cht.mv_community_death_notification USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX mv_community_death_notification_reported ON cht.mv_community_death_notification USING btree (reported) tablespace ts_indexes;
CREATE INDEX mv_community_death_notification_year_month_district ON cht.mv_community_death_notification USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX mv_community_death_notification_district ON cht.mv_community_death_notification USING btree (district) tablespace ts_indexes;
CREATE INDEX mv_community_death_notification_source ON cht.mv_community_death_notification USING btree (source) tablespace ts_indexes;
CREATE INDEX mv_community_death_notification_source_id ON cht.mv_community_death_notification USING btree (source_id) tablespace ts_indexes;
CREATE INDEX mv_community_death_notification_contact_id ON cht.mv_community_death_notification USING btree (contact_id) tablespace ts_indexes;
CREATE INDEX mv_community_death_notification_chw_district ON cht.mv_community_death_notification USING btree (chw_id, district) tablespace ts_indexes;
CREATE INDEX mv_community_death_notification_chw_district_reported ON cht.mv_community_death_notification USING btree (chw_id, district, reported) tablespace ts_indexes;


-- ---------------------------------------------------------------------
-- SOURCE: mv_death_report.sql
-- ---------------------------------------------------------------------

-- cht.mv_death_report source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_death_report;
CREATE MATERIALIZED VIEW cht.mv_death_report
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
    doc #>> '{fields,inputs,user,phone}'::text[] AS inputs_user_phone,
    doc #>> '{fields,inputs,user,name}'::text[] AS inputs_user_name,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    doc #>> '{fields,inputs,contact,national_identification_number}'::text[] AS inputs_contact_national_identification_number,
    doc #>> '{fields,inputs,contact,date_of_birth}'::text[] AS inputs_contact_date_of_birth,
    doc #>> '{fields,inputs,contact,sex}'::text[] AS inputs_contact_sex,
    doc #>> '{fields,inputs,contact,parent,_id}'::text[] AS inputs_contact_parent_id,
    doc #>> '{fields,inputs,contact,parent,parent,_id}'::text[] AS inputs_contact_parent_parent_id,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,patient_name}'::text[] AS patient_name,
    doc #>> '{fields,patient_age}'::text[] AS patient_age,
    doc #>> '{fields,patient_family_id}'::text[] AS patient_family_id,
    doc #>> '{fields,date_of_death}'::text[] AS date_of_death,
    doc #>> '{fields,death_details,patient_sex}'::text[] AS death_details_patient_sex,
    doc #>> '{fields,death_details,death_date}'::text[] AS death_details_death_date,
    doc #>> '{fields,death_details,place_of_death}'::text[] AS death_details_place_of_death,
    doc #>> '{fields,death_details,specify_death}'::text[] AS death_details_specify_death,
    doc #>> '{fields,death_details,other_comments}'::text[] AS death_details_other_comments,
    doc #>> '{fields,death_details,death_notification_number}'::text[] AS death_details_death_notification_number,
    doc #>> '{fields,death_details,death_manner}'::text[] AS death_details_death_manner,
    doc #>> '{fields,death_details,death_manner_other}'::text[] AS death_details_death_manner_other,
    doc #>> '{fields,death_details,accident_type}'::text[] AS death_details_accident_type,
    doc #>> '{fields,death_details,two_weeks_onset_illness}'::text[] AS death_details_two_weeks_onset_illness,
    doc #>> '{fields,health_center_id}'::text[] AS health_center_id,
    doc #>> '{fields,place_id}'::text[] AS death_report_submission_place_id,
    doc #>> '{fields,t_client_id}'::text[] AS t_client_id,
    doc #>> '{fields,t_user_name}'::text[] AS t_user_name,
    doc #>> '{fields,t_client_age}'::text[] AS t_client_age,
    doc #>> '{fields,t_client_sex}'::text[] AS t_client_sex,
    doc #>> '{fields,t_client_name}'::text[] AS t_client_name,
    doc #>> '{fields,t_user_contact_id}'::text[] AS t_user_contact_id,
    doc #>> '{fields,t_client_birth_date}'::text[] AS t_client_birth_date,
    doc #>> '{fields,t_client_death_date}'::text[] AS t_client_death_date,
    doc #>> '{fields,t_client_cause_of_death}'::text[] AS t_client_cause_of_death,
    doc #>> '{fields,t_client_place_of_death}'::text[] AS t_client_place_of_death,
    doc #>> '{fields,t_client_national_identification_number}'::text[] AS t_client_national_identification_number,
    doc #>> '{contact,_id}'                         AS vht_area_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date
   FROM dwh.cht_data
LEFT JOIN cht.mv_chw_hierarchy h ON (doc #>> '{contact,_id}') = h.vht_area_id
  WHERE (doc ->> 'form'::text) = 'death_report'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX mv_death_report_vht_area_id ON cht.mv_death_report USING btree (vht_area_id) tablespace ts_indexes;
CREATE INDEX mv_death_report_reported_new ON cht.mv_death_report USING btree (reported) tablespace ts_indexes;
CREATE INDEX mv_death_report_year_month_district ON cht.mv_death_report USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX mv_death_report_date_of_death ON cht.mv_death_report USING btree (date_of_death) tablespace ts_indexes;
CREATE INDEX mv_death_report_district ON cht.mv_death_report USING btree (district) tablespace ts_indexes;
CREATE INDEX mv_death_report_facility ON cht.mv_death_report USING btree (facility) tablespace ts_indexes; 
CREATE INDEX mv_death_report_patient_id ON cht.mv_death_report USING btree (patient_id) tablespace ts_indexes;

-- ---------------------------------------------------------------------
-- SOURCE: mv_death_notification.sql
-- ---------------------------------------------------------------------

-- cht.mv_death_notification source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_death_notification;
CREATE MATERIALIZED VIEW cht.mv_death_notification
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
    doc #>> '{fields,inputs,t_client_death_date}'::text[] AS inputs_t_client_death_date,
    doc #>> '{fields,inputs,t_client_birth_date}'::text[] AS inputs_t_client_birth_date,
    doc #>> '{fields,inputs,t_client_name}'::text[] AS inputs_t_client_name,
    doc #>> '{fields,inputs,t_client_id}'::text[] AS inputs_t_client_id,
    doc #>> '{fields,inputs,t_client_national_identification_number}'::text[] AS inputs_t_client_national_identification_number,
    doc #>> '{fields,inputs,t_client_sex}'::text[] AS inputs_t_client_sex,
    doc #>> '{fields,inputs,t_client_age}'::text[] AS inputs_t_client_age,
    doc #>> '{fields,inputs,t_client_death_report_date}'::text[] AS inputs_t_client_death_report_date,
    doc #>> '{fields,inputs,t_client_place_of_death}'::text[] AS inputs_t_client_place_of_death,
    doc #>> '{fields,inputs,t_client_place_of_death_other}'::text[] AS inputs_t_client_place_of_death_other,
    doc #>> '{fields,inputs,t_client_cause_of_death}'::text[] AS inputs_t_client_cause_of_death,
    doc #>> '{fields,inputs,t_user_contact_id}'::text[] AS inputs_t_user_contact_id,
    doc #>> '{fields,inputs,t_user_name}'::text[] AS inputs_t_user_name,
    doc #>> '{fields,inputs,t_user_phone}'::text[] AS inputs_t_user_phone,
    doc #>> '{fields,inputs,user,contact_id}'::text[] AS inputs_user_contact_id,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    doc #>> '{fields,inputs,contact,date_of_birth}'::text[] AS inputs_contact_date_of_birth,
    doc #>> '{fields,inputs,contact,sex}'::text[] AS inputs_contact_sex,
    doc #>> '{fields,inputs,contact,parent,_id}'::text[] AS inputs_contact_parent_id,
    doc #>> '{fields,inputs,contact,parent,parent,_id}'::text[] AS inputs_contact_parent_parent_id,
    doc #>> '{fields,health_center_id}'::text[] AS health_center_id,
    doc #>> '{fields,supervisor_id}'::text[] AS supervisor_id,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,needs_signoff}'::text[] AS needs_signoff,
    doc #>> '{fields,date_of_death}'::text[] AS date_of_death,
    doc #>> '{fields,notification_details,user_details}'::text[] AS notification_details_user_details,
    doc #>> '{fields,notification_details,client_details}'::text[] AS notification_details_client_details,
    doc #>> '{fields,notification_details,death_details}'::text[] AS notification_details_death_details,
    doc #>> '{fields,notification_details,note_call_vht}'::text[] AS notification_details_note_call_vht,
    doc #>> '{fields,notification_details,call_button}'::text[] AS notification_details_call_button,
    doc #>> '{fields,notification_details,call_summary}'::text[] AS notification_details_call_summary,
    doc #>> '{fields,notification_details,verification_status}'::text[] AS notification_details_verification_status,
    doc #>> '{fields,notification_details,death_not_verified_reason}'::text[] AS notification_details_death_not_verified_reason,
    doc #>> '{fields,notification_details,not_verified_vht_note}'::text[] AS notification_details_not_verified_vht_note,
    doc #>> '{fields,notification_details,actions}'::text[] AS notification_details_actions,
    doc #>> '{fields,notification_details,action_others}'::text[] AS notification_details_action_others,
    doc #>> '{fields,notification_details,action_note}'::text[] AS notification_details_action_note,
    doc #>> '{fields,status}'::text[] AS submission_status,
    doc #>> '{fields,death_report}'::text[] AS submission_death_report,
    doc #>> '{fields,place_id}'::text[] AS submission_place_id,
    doc #>> '{fields,needs_signoff}'::text[] AS submission_needs_signoff,
    doc #>> '{fields,date_of_death}'::text[] AS submission_date_of_death,
    doc #>> '{fields,d_client_death_date}'::text[] AS submission_d_client_death_date,
    doc #>> '{fields,d_client_birth_date}'::text[] AS submission_d_client_birth_date,
    doc #>> '{fields,d_client_name}'::text[] AS submission_d_client_name,
    doc #>> '{fields,d_client_id}'::text[] AS submission_d_client_id,
    doc #>> '{fields,d_client_national_identification_number}'::text[] AS submission_d_client_national_identification_number,
    doc #>> '{fields,d_client_sex}'::text[] AS submission_d_client_sex,
    doc #>> '{fields,d_client_age}'::text[] AS submission_d_client_age,
    doc #>> '{fields,d_client_death_report_date}'::text[] AS submission_d_client_death_report_date,
    doc #>> '{fields,d_client_place_of_death}'::text[] AS submission_d_client_place_of_death,
    doc #>> '{fields,d_client_place_of_death_other}'::text[] AS submission_d_client_place_of_death_other,
    doc #>> '{fields,d_client_cause_of_death}'::text[] AS submission_d_client_cause_of_death,
    doc #>> '{fields,d_user_contact_id}'::text[] AS submission_d_user_contact_id,
    doc #>> '{fields,d_user_name}'::text[] AS submission_d_user_name,
    doc #>> '{fields,d_user_phone}'::text[] AS submission_d_user_phone,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date 
   FROM dwh.cht_data couchdb
LEFT JOIN cht.mv_chw_hierarchy h ON (couchdb.doc #>> '{contact,_id}') = h.chw_id
  WHERE (doc ->> 'form'::text) = 'death_notification'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX mv_death_notification_chw_id ON cht.mv_death_notification USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX mv_death_notification_reported ON cht.mv_death_notification USING btree (reported) tablespace ts_indexes;
CREATE INDEX mv_death_notification_year_month_district ON cht.mv_death_notification USING btree (year, month, district) TABLESPACE ts_indexes;

-- ---------------------------------------------------------------------
-- SOURCE: mv_delivery.sql
-- ---------------------------------------------------------------------

-- cht.mv_delivery source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_delivery;
CREATE MATERIALIZED VIEW cht.mv_delivery
TABLESPACE ts_report
AS SELECT d.doc ->> '_id'::text AS uuid,
    d.doc ->> '_rev'::text AS rev,
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
    d.doc #>> '{fields,inputs,source_id}'::text[] AS source_id,
    d.doc #>> '{fields,inputs,source}'::text[] AS source,
    d.doc ->> 'form'::text AS form,
    d.doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    d.doc #>> '{fields,inputs,contact,sex}'::text[] AS inputs_contact_sex,
    d.doc #>> '{fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    d.doc #>> '{fields,inputs,contact,date_of_birth}'::text[] AS inputs_contact_date_of_birth,
    d.doc #>> '{fields,is_of_child_bearing_age}'::text[] AS is_of_child_bearing_age,
    d.doc #>> '{fields,visited_contact_uuid}'::text[] AS visited_contact_uuid,
    d.doc #>> '{fields,family_id}'::text[] AS family_id,
    d.doc #>> '{fields,area_id}'::text[] AS area_id,
    d.doc #>> '{fields,facility_id}'::text[] AS facility_id,
    d.doc #>> '{fields,patient_age_in_years}'::text[] AS patient_age_in_years,
    d.doc #>> '{fields,patient_age_in_months}'::text[] AS patient_age_in_months,
    d.doc #>> '{fields,patient_age_in_days}'::text[] AS patient_age_in_days,
    d.doc #>> '{fields,patient_age_display}'::text[] AS patient_age_display,
    d.doc #>> '{fields,patient_id}'::text[] AS patient_id,
    d.doc #>> '{fields,patient_name}'::text[] AS patient_name,
    d.doc #>> '{fields,patient_gender}'::text[] AS patient_gender,
    d.doc #>> '{fields,today_date}'::text[] AS today_date,
    d.doc #>> '{fields,days_since_delivery_date}'::text[] AS days_since_delivery_date,
    d.doc #>> '{fields,referred_for_nutrition_follow_up}'::text[] AS referred_for_nutrition_follow_up,
    d.doc #>> '{fields,delivery_place_label}'::text[] AS delivery_place_label,
    d.doc #>> '{fields,pregnancy_hiv_test_result}'::text[] AS pregnancy_hiv_test_result,
    d.doc #>> '{fields,group_woman_condition,woman_outcome}'::text[] AS woman_outcome,
    d.doc #>> '{fields,group_delivery_outcomes,number_of_babies_delivered}'::text[] AS number_of_babies_delivered,
    d.doc #>> '{fields,group_delivery_outcomes,number_of_babies_alive}'::text[] AS number_of_babies_alive,
    d.doc #>> '{fields,group_woman_danger_sign_check,note_title_danger_sign}'::text[] AS note_title_danger_sign,
    d.doc #>> '{fields,group_woman_danger_sign_check,note_has_any_danger_signs_woman}'::text[] AS note_has_any_danger_signs_woman,
    d.doc #>> '{fields,group_woman_danger_sign_check,woman_danger_sign_fever}'::text[] AS woman_danger_sign_fever,
    d.doc #>> '{fields,group_woman_danger_sign_check,woman_danger_sign_severe_headache}'::text[] AS woman_danger_sign_severe_headache,
    d.doc #>> '{fields,group_woman_danger_sign_check,woman_danger_sign_vaginal_bleeding}'::text[] AS woman_danger_sign_vaginal_bleeding,
    d.doc #>> '{fields,group_woman_danger_sign_check,woman_danger_sign_foul_vaginal_discharge}'::text[] AS woman_danger_sign_foul_vaginal_discharge,
    d.doc #>> '{fields,group_woman_danger_sign_check,woman_danger_sign_convulsions}'::text[] AS woman_danger_sign_convulsions,
    d.doc #>> '{fields,group_woman_danger_sign_check,has_danger_signs_woman}'::text[] AS has_danger_signs_woman,
    d.doc #>> '{fields,group_woman_danger_sign_check,note_refer_woman_danger_signs}'::text[] AS note_refer_woman_danger_signs,
    d.doc #>> '{fields,group_woman_danger_sign_check,referred_woman_danger_signs}'::text[] AS referred_woman_danger_signs,
    d.doc #>> '{fields,group_woman_danger_sign_check,woman_date_of_death}'::text[] AS woman_date_of_death,
    d.doc #>> '{fields,group_woman_danger_sign_check,woman_place_of_death}'::text[] AS woman_place_of_death,
    d.doc #>> '{fields,group_woman_danger_sign_check,woman_place_of_death_other}'::text[] AS woman_place_of_death_other,
    d.doc #>> '{fields,group_woman_danger_sign_check,delivered_babies_before_dying}'::text[] AS delivered_babies_before_dying,
    d.doc #>> '{fields,group_woman_danger_sign_check,woman_dead_additional_notes}'::text[] AS woman_dead_additional_notes,
    d.doc #>> '{fields,group_woman_danger_sign_check,note_woman_dead_notes_detailed}'::text[] AS note_woman_dead_notes_detailed,
    d.doc #>> '{fields,group_woman_danger_sign_check,note_encourage_kangaroo_fathers}'::text[] AS note_encourage_kangaroo_fathers,
    d.doc #>> '{fields,group_baby_condition,child_repeat,0,child_profile,name}'::text[] AS name,
    d.doc #>> '{fields,group_baby_condition,child_repeat,0,child_profile,sex}'::text[] AS sex,
    d.doc #>> '{fields,group_baby_condition,child_repeat,0,child_profile,type}'::text[] AS type,
    d.doc #>> '{fields,group_baby_condition,child_repeat,0,child_profile,parent,_id}'::text[] AS house_hold_id,
    d.doc #>> '{fields,group_baby_condition,child_repeat,0,child_profile,baby_name}'::text[] AS baby_name,
    d.doc #>> '{fields,group_baby_condition,child_repeat,0,child_profile,mother_id}'::text[] AS mother_id,
    d.doc #>> '{fields,group_baby_condition,child_repeat,0,child_profile,date_of_birth}'::text[] AS date_of_birth,
    d.doc #>> '{fields,group_baby_condition,child_repeat,0,child_profile,baby_condition}'::text[] AS baby_condition,
    d.doc #>> '{fields,group_baby_condition,child_repeat,0,child_profile,created_by_doc}'::text[] AS created_by_doc,
    d.doc #>> '{fields,group_baby_condition,child_repeat,0,child_profile,has_danger_signs_baby}'::text[] AS has_danger_signs_baby,
    d.doc #>> '{fields,group_baby_condition,child_repeat,0,child_profile,baby_danger_sign_body}'::text[] AS baby_danger_sign_body,
    d.doc #>> '{fields,group_baby_condition,child_repeat,0,child_profile,baby_danger_sign_fever}'::text[] AS baby_danger_sign_fever,
    d.doc #>> '{fields,group_baby_condition,child_repeat,0,child_profile,baby_danger_sign_drowsy}'::text[] AS baby_danger_sign_drowsy,
    d.doc #>> '{fields,group_baby_condition,child_repeat,0,child_profile,breastfed_within_one_hour}'::text[] AS breastfed_within_one_hour,
    d.doc #>> '{fields,group_baby_condition,child_repeat,0,child_profile,baby_danger_sign_blue_skin}'::text[] AS baby_danger_sign_blue_skin,
    d.doc #>> '{fields,group_baby_condition,child_repeat,0,child_profile,note_any_baby_danger_signs}'::text[] AS note_any_baby_danger_signs,
    d.doc #>> '{fields,group_baby_condition,child_repeat,0,child_profile,baby_danger_sign_yellow_skin}'::text[] AS baby_danger_sign_yellow_skin,
    d.doc #>> '{fields,group_baby_condition,child_repeat,0,child_profile,is_exclusively_breast_feeding}'::text[] AS is_exclusively_breast_feeding,
    d.doc #>> '{fields,group_baby_condition,child_repeat,0,child_profile,baby_danger_sign_body_stiffness}'::text[] AS baby_danger_sign_body_stiffness,
    d.doc #>> '{fields,group_baby_condition,child_repeat,0,child_profile,baby_danger_sign_vomits_everything}'::text[] AS baby_danger_sign_vomits_everything,
    d.doc #>> '{fields,group_baby_condition,child_repeat,0,child_profile,baby_danger_sign_infected_convulsions}'::text[] AS baby_danger_sign_infected_convulsions,
    d.doc #>> '{fields,group_baby_condition,child_repeat,0,child_profile,baby_danger_sign_infected_umbilical_cord}'::text[] AS baby_danger_sign_infected_umbilical_cord,
    d.doc #>> '{fields,group_baby_condition,child_repeat,0,child_profile,baby_danger_sign_infected_feeding_difficulty}'::text[] AS baby_danger_sign_infected_feeding_difficulty,
    d.doc #>> '{fields,group_delivery_information,delivery_date}'::text[] AS delivery_date,
    d.doc #>> '{fields,group_delivery_information,delivery_date_local}'::text[] AS delivery_date_local,
    d.doc #>> '{fields,group_delivery_information,delivery_place}'::text[] AS delivery_place,
    d.doc #>> '{fields,group_delivery_information,delivery_place_other}'::text[] AS delivery_place_other,
    d.doc #>> '{fields,group_delivery_information,delivery_method}'::text[] AS delivery_method,
    d.doc #>> '{fields,group_delivery_information,who_conducted_delivery}'::text[] AS who_conducted_delivery,
    d.doc #>> '{fields,group_delivery_information,who_conducted_delivery_other}'::text[] AS who_conducted_delivery_other,
    d.doc #>> '{fields,group_delivery_information,note_referred_to_health_facility_danger_signs}'::text[] AS note_referred_to_health_facility_danger_signs,
    d.doc #>> '{fields,group_delivery_information,referred_to_health_facility_home_delivery}'::text[] AS referred_to_health_facility_home_delivery,
    d.doc #>> '{fields,group_delivery_information,agreed_health_facility_visit_date}'::text[] AS agreed_health_facility_visit_date,
    d.doc #>> '{fields,group_death_report_baby,baby_date_of_death}'::text[] AS baby_date_of_death,
    d.doc #>> '{fields,group_death_report_baby,baby_place_of_death}'::text[] AS baby_place_of_death,
    d.doc #>> '{fields,group_death_report_baby,baby_place_of_death_other}'::text[] AS baby_place_of_death_other,
    d.doc #>> '{fields,group_death_report_baby,still_birth}'::text[] AS still_birth,
    d.doc #>> '{fields,group_death_report_baby,baby_death_additional_notes}'::text[] AS baby_death_additional_notes,
    d.doc #>> '{fields,group_woman_nutritional_status,note_nutrition_status}'::text[] AS note_nutrition_status,
    d.doc #>> '{fields,group_woman_nutritional_status,taken_muac}'::text[] AS taken_muac,
    d.doc #>> '{fields,group_woman_nutritional_status,muac_measurement}'::text[] AS muac_measurement,
    d.doc #>> '{fields,group_woman_nutritional_status,encourage_client_to_consume_sufficient_diet}'::text[] AS encourage_client_to_consume_sufficient_diet,
    d.doc #>> '{fields,group_woman_nutritional_status,note_has_sam}'::text[] AS note_has_sam,
    d.doc #>> '{fields,group_woman_nutritional_status,note_has_mam}'::text[] AS note_has_mam,
    d.doc #>> '{fields,group_woman_nutritional_status,note_refer_to_health_facility}'::text[] AS note_refer_to_health_facility,
    d.doc #>> '{fields,group_woman_nutritional_status,referred_to_health_facility_nutrition}'::text[] AS referred_to_health_facility_nutrition,
    d.doc #>> '{fields,group_woman_nutritional_status,micro_nutrient_supplementation_received}'::text[] AS micro_nutrient_supplementation_received,
    d.doc #>> '{fields,group_woman_nutritional_status,note_encourage_micro-nutrients}'::text[] AS note_encourage_micro_nutrients,
    d.doc #>> '{fields,group_woman_nutritional_status,counsel_mother}'::text[] AS counsel_mother,
    d.doc #>> '{fields,group_woman_nutritional_status,referred_to_health_facility_no_micro_nutrient-supplementation}'::text[] AS referred_to_health_facility_no_micro_nutrient_supplementation,
    d.doc #>> '{fields,group_safe_postnatal_practices,note_eat_well}'::text[] AS note_eat_well,
    d.doc #>> '{fields,group_safe_postnatal_practices,note_exclusive_breastfeeding_counsel}'::text[] AS note_exclusive_breastfeeding_counsel,
    d.doc #>> '{fields,group_safe_postnatal_practices,note_positioning_and_attachment}'::text[] AS note_positioning_and_attachment,
    d.doc #>> '{fields,group_safe_postnatal_practices,note_how_to_keep_baby_warm}'::text[] AS note_how_to_keep_baby_warm,
    d.doc #>> '{fields,group_safe_postnatal_practices,note_sleep_under_llin}'::text[] AS note_sleep_under_llin,
    d.doc #>> '{fields,group_safe_postnatal_practices,note_keep_umbilical_cord_clean}'::text[] AS note_keep_umbilical_cord_clean,
    d.doc #>> '{fields,group_safe_postnatal_practices,note_introduce_age_appropiate_foods}'::text[] AS note_introduce_age_appropiate_foods,
    d.doc #>> '{fields,group_safe_postnatal_practices,note_infants_receive_vitamin_a}'::text[] AS note_infants_receive_vitamin_a,
    d.doc #>> '{fields,group_safe_postnatal_practices,note_micro_nutrient_supplements}'::text[] AS note_micro_nutrient_supplements,
    d.doc #>> '{fields,group_safe_postnatal_practices,note_promote_early_childhood_stimulation}'::text[] AS note_promote_early_childhood_stimulation,
    d.doc #>> '{fields,group_safe_postnatal_practices,note_counsel_women_living_with_hiv}'::text[] AS note_counsel_women_living_with_hiv,
    d.doc #>> '{fields,group_safe_postnatal_practices,note_hiv_exposed_infants}'::text[] AS note_hiv_exposed_infants,
    d.doc #>> '{fields,group_safe_postnatal_practices,note_hiv_infected_infants}'::text[] AS note_hiv_infected_infants,
    d.doc #>> '{fields,group_pnc_visits,who_recommendation}'::text[] AS who_recommendation,
    d.doc #>> '{fields,group_pnc_visits,pnc_visits}'::text[] AS pnc_visits,
    d.doc #>> '{contact,_id}'::text[] AS chw_id,
    h.facility,
    h.village,
    h.district,
    h.region,
    CURRENT_TIMESTAMP AS last_refresh_date
   FROM dwh.cht_data d
     LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}'::text[]) = h.chw_id
  WHERE (d.doc ->> 'form'::text) = 'delivery'::text AND d.is_current = true
WITH NO DATA;

-- View indexes:
CREATE INDEX mv_delivery_reported ON cht.mv_delivery USING btree (reported) tablespace ts_indexes;
CREATE INDEX mv_delivery_year_month_district ON cht.mv_delivery USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX mv_delivery_date ON cht.mv_delivery USING btree (date) tablespace ts_indexes;
CREATE INDEX mv_delivery_inputs_contact_id ON cht.mv_delivery USING btree (inputs_contact_id) tablespace ts_indexes;
CREATE INDEX mv_delivery_chw_id ON cht.mv_delivery USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX mv_delivery_facility ON cht.mv_delivery USING btree (facility) tablespace ts_indexes;
CREATE INDEX mv_delivery_district ON cht.mv_delivery USING btree (district) tablespace ts_indexes;

-- ---------------------------------------------------------------------
-- SOURCE: mv_delivery_check.sql
-- ---------------------------------------------------------------------

-- cht.mv_delivery_check source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_delivery_check;
CREATE MATERIALIZED VIEW cht.mv_delivery_check
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
    doc #>> '{fields,inputs,contact,_id}'::text[] AS contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS contact_name,
    doc #>> '{fields,inputs,contact,date_of_birth}'::text[] AS contact_date_of_birth,
    doc #>> '{fields,inputs,contact,sex}'::text[] AS contact_sex,
    doc #>> '{fields,inputs,contact,parent,_id}'::text[] AS parent_id,
    doc #>> '{fields,is_of_child_bearing_age}'::text[] AS is_of_child_bearing_age,
    doc #>> '{fields,patient_age_in_years}'::text[] AS patient_age_in_years,
    doc #>> '{fields,patient_age_in_months}'::text[] AS patient_age_in_months,
    doc #>> '{fields,patient_age_in_days}'::text[] AS patient_age_in_days,
    doc #>> '{fields,patient_age_display}'::text[] AS patient_age_display,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,patient_name}'::text[] AS patient_name,
    doc #>> '{fields,patient_gender}'::text[] AS patient_gender,
    doc #>> '{fields,group_pregnancy_status,has_delivered}'::text[] AS has_delivered,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date
   FROM dwh.cht_data
    LEFT JOIN cht.mv_chw_hierarchy h ON (dwh.cht_data.doc #>> '{contact,_id}') = h.chw_id
  WHERE (doc ->> 'form'::text) = 'delivery_check'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX delivery_reported_idx ON cht.mv_delivery_check USING btree (reported) tablespace ts_indexes;
CREATE INDEX delivery_date_idx ON cht.mv_delivery_check USING btree (date) tablespace ts_indexes;
CREATE INDEX mv_delivery_check_year_month_district ON cht.mv_delivery_check USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX delivery_chw_id_idx ON cht.mv_delivery_check USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX delivery_district_idx ON cht.mv_delivery_check USING btree (district) tablespace ts_indexes;
CREATE INDEX delivery_facility_idx ON cht.mv_delivery_check USING btree (facility) tablespace ts_indexes;

-- ---------------------------------------------------------------------
-- SOURCE: mv_drowning_workflow.sql
-- ---------------------------------------------------------------------

DROP MATERIALIZED VIEW IF EXISTS cht.mv_drowning_workflow;
CREATE MATERIALIZED VIEW cht.mv_drowning_workflow
TABLESPACE ts_report
AS
SELECT
    doc ->> '_id'::text                              AS doc_id,
    doc ->> '_rev'::text                             AS rev,                                 -- [NEW FIELD]
    to_timestamp((NULLIF(doc ->> 'reported_date'::text, ''::text)::bigint / 1000)::double precision) AS reported,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY-MM-DD'))::date AS date,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY'))::INT AS year,
    to_char(to_timestamp((((doc ->>'reported_date'::text)::bigint) / 1000)::double precision), 'MM'::text)::integer AS month,
    TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'FMMonth') AS monthname,
    doc ->'fields'->'meta'->>'instanceID' AS instanceID,
    doc ->'fields'->'inputs'->'meta'->>'deprecatedID' AS deprecatedID,
    doc ->'fields'->'inputs'->'meta'->'location'->>'lat' AS location_lat,
    doc ->'fields'->'inputs'->'meta'->'location'->>'long' AS location_long,
    doc ->'fields'->'inputs'->'meta'->'location'->>'error' AS location_error,
    doc ->'fields'->'inputs'->'meta'->'location'->>'message' AS location_message,
    doc ->'geolocation'->>'code' AS geolocation_code,
    doc ->'geolocation'->>'message' AS geolocation_message,
    (NULLIF((doc -> 'geolocation'::text) ->> 'latitude'::text, ''::text))::double precision AS geolocation_latitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'longitude'::text, ''::text))::double precision AS geolocation_longitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'accuracy'::text, ''::text))::double precision AS geolocation_accuracy,
    (NULLIF((doc -> 'geolocation'::text) ->> 'altitude'::text, ''::text))::double precision AS geolocation_altitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'altitudeAccuracy'::text, ''::text))::double precision AS geolocation_altitude_accuracy,
    (NULLIF((doc -> 'geolocation'::text) ->> 'speed'::text, ''::text))::double precision AS geolocation_speed,
    (NULLIF((doc -> 'geolocation'::text) ->> 'heading'::text, ''::text))::double precision AS geolocation_heading,
    doc ->> 'from'::text                             AS  from,
  
    doc #>> '{fields,inputs,source}'::text[]          AS source,
    doc #>> '{fields,inputs,source_id}'::text[]       AS source_id,
    doc #>> '{fields,inputs,contact,_id}'::text[]     AS inputs_contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[]    AS inputs_contact_name,
    doc #>> '{fields,inputs,patient_id}'::text[]      AS patient_id,
    doc #>> '{fields,inputs,contact_name}'::text[]    AS contact_name_input,

    doc #>> '{fields,incident,date}'::text[]        AS incident_date,
    doc #>> '{fields,incident,time}'::text[]        AS incident_time,
    doc #>> '{fields,incident,waterbody}'::text[]   AS incident_waterbody,
    doc #>> '{fields,incident,type}'::text[]        AS incident_type,

    doc #>> '{fields,risk,activity}'::text[]        AS risk_activity,
    doc #>> '{fields,risk,cause}'::text[]           AS risk_cause,
    doc #>> '{fields,risk,supervision}'::text[]     AS risk_supervision,
    doc #>> '{fields,risk,victim}'::text[]          AS risk_victim,
    doc #>> '{fields,risk,intoxicated}'::text[]     AS risk_intoxicated,

    doc #>> '{fields,rescue,attempts}'::text[]       AS rescue_attempts,
    doc #>> '{fields,rescue,firstaid}'::text[]       AS rescue_firstaid,
    doc #>> '{fields,drowning,outcome}'::text[]       AS outcome,


    --- reporting hierarchy
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date    


FROM dwh.cht_data AS couchdb
LEFT JOIN cht.mv_chw_hierarchy h ON (couchdb.doc #>> '{contact,_id}') = h.chw_id
WHERE (doc ->> 'form') = 'drowning_workflow'
  AND is_current
WITH NO DATA;

CREATE INDEX screening_reported_idx
    ON cht.mv_drowning_workflow USING btree (reported) tablespace ts_indexes;
CREATE INDEX mv_drowning_workflow_year_month_district
    ON cht.mv_drowning_workflow USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX screening_chw_id_idx
    ON cht.mv_drowning_workflow USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX screening_district_idx
    ON cht.mv_drowning_workflow USING btree (district) tablespace ts_indexes;
CREATE INDEX screening_region_idx
    ON cht.mv_drowning_workflow USING btree (region) tablespace ts_indexes;


-- ---------------------------------------------------------------------
-- SOURCE: mv_fp_follow_up.sql
-- ---------------------------------------------------------------------

-- cht.mv_fp_follow_up source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_fp_follow_up;
CREATE MATERIALIZED VIEW cht.mv_fp_follow_up
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
    doc #>> '{fields,inputs,contact,patient_id}'::text[] AS inputs_contact_patient_id,
    doc #>> '{fields,inputs,contact,date_of_birth}'::text[] AS inputs_contact_date_of_birth,
    doc #>> '{fields,inputs,contact,sex}'::text[] AS inputs_contact_sex,
    doc #>> '{fields,inputs,contact,parent,parent,_id}'::text[] AS inputs_parent_parent_id,
    doc #>> '{fields,inputs,contact,parent,parent,supervisor}'::text[] AS inputs_parent_supervisor,
    doc #>> '{fields,inputs,contact,parent,parent,contact,name}'::text[] AS inputs_parent_contact_name,
    doc #>> '{fields,inputs,contact,parent,parent,contact,phone}'::text[] AS inputs_parent_contact_phone,
    doc #>> '{fields,inputs,contact,parent,parent,contact,_id}'::text[] AS inputs_parent_contact_id,
    doc #>> '{fields,inputs,contact,parent,parent,parent,_id}'::text[] AS inputs_parent_parent_parent_id,
    doc #>> '{fields,source}'::text[] AS source,
    doc #>> '{fields,source_id}'::text[] AS source_id,
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
    doc #>> '{fields,fp_next_appt_date}'::text[] AS fp_next_appt_date,
    doc #>> '{fields,wants_or_is_pregnant}'::text[] AS wants_or_is_pregnant,
    doc #>> '{fields,needs_method_change}'::text[] AS needs_method_change,
    doc #>> '{fields,has_been_referred}'::text[] AS has_been_referred,
    doc #>> '{fields,chw_area_id}'::text[] AS chw_area_id,
    doc #>> '{fields,branch_id}'::text[] AS branch_id,
    (doc #>> '{fields,coc_given}'::text[])::integer AS coc_given,
    (doc #>> '{fields,condoms_given}'::text[])::integer AS condoms_given,
    (doc #>> '{fields,pop_given}'::text[])::integer AS pop_given,
    (doc #>> '{fields,dmpa_given}'::text[])::integer AS dmpa_given,
    (doc #>> '{fields,contraceptives_given}'::text[])::integer AS contraceptives_given,
    doc #>> '{fields,fp_follow_up,on_fp}'::text[] AS on_fp,
    doc #>> '{fields,fp_follow_up,not_on_fp_reason}'::text[] AS not_on_fp_reason,
    doc #>> '{fields,fp_follow_up,not_on_fp_reason_other}'::text[] AS not_on_fp_reason_other,
    doc #>> '{fields,fp_follow_up,n_thank_patient}'::text[] AS n_thank_patient,
    doc #>> '{fields,fp_follow_up,n_refer_change_fp}'::text[] AS n_refer_change_fp,
    doc #>> '{fields,fp_follow_up,referred_patient_not_on_fp}'::text[] AS referred_patient_not_on_fp,
    doc #>> '{fields,fp_follow_up,n_enroll_pregnancy}'::text[] AS n_enroll_pregnancy,
    doc #>> '{fields,fp_follow_up,n_counsel_woman}'::text[] AS n_counsel_woman,
    doc #>> '{fields,fp_follow_up,n_fp_method}'::text[] AS n_fp_method,
    doc #>> '{fields,fp_follow_up,continue_current_fp_method}'::text[] AS continue_current_fp_method,
    doc #>> '{fields,fp_follow_up,n_refer_patient_change_fp}'::text[] AS n_refer_patient_change_fp,
    doc #>> '{fields,fp_follow_up,can_supply_fp_commodities}'::text[] AS can_supply_fp_commodities,
    doc #>> '{fields,fp_follow_up,supply_item_units}'::text[] AS supply_item_units,
    doc #>> '{fields,fp_follow_up,supply_limit}'::text[] AS supply_limit,
    (doc #>> '{fields,fp_follow_up,commodities_supplied_qty}'::text[])::integer AS commodities_supplied_qty,
    doc #>> '{fields,fp_follow_up,referred_patient_change_fp}'::text[] AS referred_patient_change_fp,
    doc #>> '{fields,fp_follow_up,next_appt_date}'::text[] AS next_appt_date,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date 
   FROM dwh.cht_data couchdb
LEFT JOIN cht.mv_chw_hierarchy h ON (couchdb.doc #>> '{contact,_id}') = h.chw_id
  WHERE (doc ->> 'form'::text) = 'fp_follow_up'::text AND is_current
WITH NO DATA;

-- Indexes for cht.mv_fp_follow_up
-- Adjust "month" if a table uses a different period column name.
CREATE INDEX idx_mv_fp_follow_up_chw_year_month
  ON cht.mv_fp_follow_up (chw_id, year, month) tablespace ts_indexes;
CREATE INDEX idx_mv_fp_follow_up_chw_date
  ON cht.mv_fp_follow_up (chw_id, date)tablespace ts_indexes;
CREATE INDEX idx_mv_fp_follow_up_chw_reported
  ON cht.mv_fp_follow_up (chw_id, reported) tablespace ts_indexes;
  --WHERE reported IS NOT NULL;
CREATE INDEX idx_mv_fp_follow_up_chw_current_fp_method
  ON cht.mv_fp_follow_up (chw_id, current_fp_method) tablespace ts_indexes;
CREATE INDEX idx_mv_fp_follow_up_year_month_district
  ON cht.mv_fp_follow_up USING btree (year, month, district) TABLESPACE ts_indexes;

-- ---------------------------------------------------------------------
-- SOURCE: mv_fp_referral_follow_up.sql
-- ---------------------------------------------------------------------

-- cht.mv_fp_referral_follow_up source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_fp_referral_follow_up;
CREATE MATERIALIZED VIEW cht.mv_fp_referral_follow_up
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
    doc #>> '{fields,inputs,contact,patient_id}'::text[] AS inputs_contact_patient_id,
    doc #>> '{fields,inputs,contact,date_of_birth}'::text[] AS inputs_contact_date_of_birth,
    doc #>> '{fields,inputs,contact,sex}'::text[] AS inputs_contact_sex,
    doc #>> '{fields,inputs,contact,parent,parent,contact,name}'::text[] AS inputs_parent_contact_name,
    doc #>> '{fields,inputs,contact,parent,parent,contact,phone}'::text[] AS inputs_parent_contact_phone,
    doc #>> '{fields,source_input}'::text[] AS source_input,
    doc #>> '{fields,source_id_input}'::text[] AS source_id_input,
    doc #>> '{fields,patient_uuid}'::text[] AS patient_uuid,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,patient_name}'::text[] AS patient_name,
    doc #>> '{fields,patient_date_of_birth}'::text[] AS patient_date_of_birth,
    doc #>> '{fields,patient_age_in_years}'::text[] AS patient_age_in_years,
    doc #>> '{fields,age}'::text[] AS age,
    doc #>> '{fields,date_of_birth}'::text[] AS date_of_birth,
    doc #>> '{fields,chw_name}'::text[] AS chw_name,
    doc #>> '{fields,chw_phone}'::text[] AS chw_phone,
    doc #>> '{fields,fp_ref_follow_up,visited_facility}'::text[] AS visited_facility,
    doc #>> '{fields,fp_ref_follow_up,enrolled_fp}'::text[] AS enrolled_fp,
    doc #>> '{fields,fp_ref_follow_up,n_fp_registration}'::text[] AS n_fp_registration,
    doc #>> '{fields,fp_ref_follow_up,reason_not_enrolled_fp}'::text[] AS reason_not_enrolled_fp,
    doc #>> '{fields,fp_ref_follow_up,n_pregnancy_registration}'::text[] AS n_pregnancy_registration,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date 
   FROM dwh.cht_data couchdb
LEFT JOIN cht.mv_chw_hierarchy h ON (couchdb.doc #>> '{contact,_id}') = h.chw_id
  WHERE (doc ->> 'form'::text) = 'fp_referral_follow_up'::text AND is_current
WITH NO DATA;

CREATE INDEX idx_mv_fp_referral_follow_up_uuid ON cht.mv_fp_referral_follow_up (uuid) tablespace ts_indexes;
CREATE INDEX idx_mv_fp_referral_follow_up_chw_id ON cht.mv_fp_referral_follow_up (chw_id) tablespace ts_indexes;
CREATE INDEX mv_fp_referral_follow_up_year_month_district ON cht.mv_fp_referral_follow_up USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX idx_mv_fp_referral_follow_up_date ON cht.mv_fp_referral_follow_up (date) tablespace ts_indexes;
CREATE INDEX idx_mv_fp_referral_follow_up_reported ON cht.mv_fp_referral_follow_up (reported) tablespace ts_indexes;
CREATE INDEX idx_mv_fp_referral_follow_up_facility ON cht.mv_fp_referral_follow_up (facility) tablespace ts_indexes;
CREATE INDEX idx_mv_fp_referral_follow_up_dhis2_facility_id ON cht.mv_fp_referral_follow_up (dhis2_facility_id) tablespace ts_indexes;
CREATE INDEX idx_mv_fp_referral_follow_up_district ON cht.mv_fp_referral_follow_up (district) tablespace ts_indexes;
CREATE INDEX idx_mv_fp_referral_follow_up_region ON cht.mv_fp_referral_follow_up (region) tablespace ts_indexes; 
