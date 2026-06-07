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