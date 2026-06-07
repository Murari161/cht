-- =====================================================================
-- Combined MV creation - PART 01 of 06  (11 views)
-- Generated: 2026-06-07 | Assumes cht.mv_chw_hierarchy exists | all WITH NO DATA
-- Each view is preceded by DROP MATERIALIZED VIEW IF EXISTS (no CASCADE)
-- Files in this part:
--   mv_afp_notification.sql
--   mv_anc_danger_sign.sql
--   mv_anc_danger_sign_escalation.sql
--   mv_anc_danger_sign_notification.sql
--   mv_anc_visit_follow_up.sql
--   mv_anc_referral_follow_up.sql
--   mv_assessment.sql
--   mv_cebs_signal_report_chew.sql
--   mv_cebs_signal_report_vht.sql
--   mv_cebs_signal_verification.sql
--   mv_cebs_signal_verification_notification.sql
-- =====================================================================


-- ---------------------------------------------------------------------
-- SOURCE: mv_afp_notification.sql
-- ---------------------------------------------------------------------

-- cht.mv_afp_notification source

DROP MATERIALIZED VIEW IF EXISTS cht.mv_afp_notification;
CREATE MATERIALIZED VIEW cht.mv_afp_notification
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
    ((doc -> 'fields'::text) -> 'inputs'::text) ->> 'source'::text AS source,
    ((doc -> 'fields'::text) -> 'inputs'::text) ->> 'source_id'::text AS source_id,
    ((doc -> 'fields'::text) -> 'inputs'::text) ->> 't_patient_condition'::text AS t_patient_condition,
    ((doc -> 'fields'::text) -> 'inputs'::text) ->> 't_place_name'::text AS t_place_name,
    ((doc -> 'fields'::text) -> 'inputs'::text) ->> 't_vht_name'::text AS t_vht_name,
    ((doc -> 'fields'::text) -> 'inputs'::text) ->> 't_vht_phone'::text AS t_vht_phone,
    ((doc -> 'fields'::text) -> 'inputs'::text) ->> 't_patient_name'::text AS t_patient_name,
    ((doc -> 'fields'::text) -> 'inputs'::text) ->> 't_patient_gender'::text AS t_patient_gender,
    ((doc -> 'fields'::text) -> 'inputs'::text) ->> 't_patient_date_of_birth'::text AS t_patient_date_of_birth,
    ((doc -> 'fields'::text) -> 'inputs'::text) ->> 't_patient_id'::text AS t_patient_id,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'user'::text) ->> 'contact_id'::text AS user_contact_id,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'user'::text) ->> 'facility_id'::text AS user_facility_id,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> '_id'::text AS contact_id,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> 'name'::text AS contact_name,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> 'date_of_birth'::text AS contact_date_of_birth,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> 'sex'::text AS contact_sex,
    (doc -> 'fields'::text) ->> 'dob'::text AS dob,
    (doc -> 'fields'::text) ->> 'patient_age_in_years'::text AS patient_age_in_years,
    (doc -> 'fields'::text) ->> 'patient_age_in_months'::text AS patient_age_in_months,
    (doc -> 'fields'::text) ->> 'patient_age_in_days'::text AS patient_age_in_days,
    (doc -> 'fields'::text) ->> 'patient_age_display'::text AS patient_age_display,
    (doc -> 'fields'::text) ->> 'patient_id'::text AS patient_id,
    (doc -> 'fields'::text) ->> 'patient_name'::text AS patient_name,
    (doc -> 'fields'::text) ->> 'patient_gender'::text AS patient_gender,
    (doc -> 'fields'::text) ->> 'vht_name'::text AS vht_name,
    (doc -> 'fields'::text) ->> 'vht_phone'::text AS vht_phone,
    (doc -> 'fields'::text) ->> 'needs_signoff'::text AS needs_signoff,
    ((doc -> 'fields'::text) -> 'afp_confirmation'::text) ->> 'n_confirmation_note'::text AS n_confirmation_note,
    ((doc -> 'fields'::text) -> 'afp_confirmation'::text) ->> 'n_follow_up'::text AS n_follow_up,
    ((doc -> 'fields'::text) -> 'afp_confirmation'::text) ->> 'has_sudden_weakness_in_legs_and_arms'::text AS has_sudden_weakness_in_legs_and_arms,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
    CURRENT_TIMESTAMP AS last_refresh_date
   FROM dwh.cht_data d
   LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id 
  WHERE (d.doc ->> 'form'::text) = 'afp_notification'::text AND d.is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX mv_afp_notification_reported ON cht.mv_afp_notification USING btree (reported);
CREATE INDEX mv_afp_notification_chw_id ON cht.mv_afp_notification USING btree (chw_id);
create index mv_afp_notification_facility_id on cht.mv_afp_notification using btree (facility);
CREATE INDEX mv_afp_notification_district ON cht.mv_afp_notification USING btree (district);
CREATE INDEX mv_afp_notification_region ON cht.mv_afp_notification USING btree (region);
CREATE INDEX mv_afp_notification_date ON cht.mv_afp_notification USING btree (date);
CREATE INDEX mv_afp_notification_year_month_district ON cht.mv_afp_notification USING btree (year, month, district) TABLESPACE ts_indexes;


-- ---------------------------------------------------------------------
-- SOURCE: mv_anc_danger_sign.sql
-- ---------------------------------------------------------------------

-- cht.mv_anc_danger_sign source

DROP MATERIALIZED VIEW IF EXISTS cht.mv_anc_danger_sign;
CREATE MATERIALIZED VIEW cht.mv_anc_danger_sign
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
    doc #>> '{fields,inputs,source_id}'::text[] AS source_id,
    doc #>> '{fields,inputs,source}'::text[] AS source,
    doc #>> '{fields,inputs,is_follow_up}'::text[] AS is_follow_up,
    doc #>> '{fields,inputs,t_place_name}'::text[] AS t_place_name,
    doc #>> '{fields,inputs,t_vht_name}'::text[] AS t_vht_name,
    doc #>> '{fields,inputs,t_vht_phone}'::text[] AS t_vht_phone,
    doc #>> '{fields,inputs,user,contact_id}'::text[] AS user_contact_id,
    doc #>> '{fields,inputs,user,facility_id}'::text[] AS user_facility_id,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS contact_id,
    doc #>> '{fields,inputs,contact,date_of_birth}'::text[] AS contact_date_of_birth,
    doc #>> '{fields,inputs,contact,sex}'::text[] AS contact_sex,
    doc #>> '{fields,inputs,contact,name}'::text[] AS contact_name,
    doc #>> '{fields,inputs,contact,parent,_id}'::text[] AS parent_id,
    doc #>> '{fields,inputs,contact,parent,name}'::text[] AS parent_name,
    doc #>> '{fields,inputs,contact,parent,parent,village}'::text[] AS parent_village,
    doc #>> '{fields,inputs,contact,parent,parent,contact,phone}'::text[] AS parent_phone,
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
    doc #>> '{fields,follow_up_label}'::text[] AS follow_up_label,
    doc #>> '{fields,chw_area_name}'::text[] AS chw_area_name,
    doc #>> '{fields,chw_name}'::text[] AS chw_name,
    doc #>> '{fields,chw_phone}'::text[] AS chw_phone,
    doc #>> '{fields,chw_village}'::text[] AS chw_village,
    doc #>> '{fields,needs_signoff}'::text[] AS needs_signoff,
    doc #>> '{fields,group_danger_sign_check,visited_health_facility}'::text[] AS visited_health_facility,
    doc #>> '{fields,group_danger_sign_check,still_experiencing_danger_signs}'::text[] AS still_experiencing_danger_signs,
    doc #>> '{fields,group_danger_sign_check,note_monitor_till_next_anc_check_up_at_Facility}'::text[] AS note_monitor_till_next_anc_check_up_at_facility,
    doc #>> '{fields,group_danger_sign_check,note_still_experiencing_danger_signs}'::text[] AS note_still_experiencing_danger_signs,
    doc #>> '{fields,group_danger_sign_check,note_danger_signs}'::text[] AS note_danger_signs,
    doc #>> '{fields,group_danger_sign_check,vaginal_bleeding}'::text[] AS vaginal_bleeding,
    doc #>> '{fields,group_danger_sign_check,lower_abdomen_pain}'::text[] AS lower_abdomen_pain,
    doc #>> '{fields,group_danger_sign_check,severe_headache}'::text[] AS severe_headache,
    doc #>> '{fields,group_danger_sign_check,very_pale}'::text[] AS very_pale,
    doc #>> '{fields,group_danger_sign_check,fever}'::text[] AS fever,
    doc #>> '{fields,group_danger_sign_check,reduced_or_no_feotal_movements}'::text[] AS reduced_or_no_feotal_movements,
    doc #>> '{fields,group_danger_sign_check,blurred_vision}'::text[] AS blurred_vision,
    doc #>> '{fields,group_danger_sign_check,swelling}'::text[] AS swelling,
    doc #>> '{fields,group_danger_sign_check,breathlessness}'::text[] AS breathlessness,
    doc #>> '{fields,group_danger_sign_check,has_danger_signs}'::text[] AS has_danger_signs,
    doc #>> '{fields,group_danger_sign_check,has_no_danger_signs}'::text[] AS has_no_danger_signs,
    doc #>> '{fields,group_danger_sign_check,note_has_no_danger_signs}'::text[] AS note_has_no_danger_signs,
    doc #>> '{fields,group_danger_sign_check,note_has_danger_signs}'::text[] AS note_has_danger_signs,
    doc #>> '{fields,group_danger_sign_check,refer_to_health_facility}'::text[] AS refer_to_health_facility,
    doc #>> '{fields,group_danger_sign_check,note_complete_follow_up_task}'::text[] AS note_complete_follow_up_task, 
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
    CURRENT_TIMESTAMP AS last_refresh_date
   FROM dwh.cht_data couchdb
   LEFT JOIN cht.mv_chw_hierarchy h ON (couchdb.doc #>> '{contact,_id}') = h.chw_id 
  WHERE (couchdb.doc ->> 'form'::text) = 'anc_danger_sign'::text AND couchdb.is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX useview_anc_danger_sign_uuid ON cht.mv_anc_danger_sign USING btree (reported);
CREATE INDEX useview_anc_danger_sign_chw_id ON cht.mv_anc_danger_sign USING btree (chw_id);
CREATE INDEX useview_anc_danger_sign_facility_id ON cht.mv_anc_danger_sign USING btree (facility);
CREATE INDEX useview_anc_danger_sign_district ON cht.mv_anc_danger_sign USING btree (district);
CREATE INDEX useview_anc_danger_sign_region ON cht.mv_anc_danger_sign USING btree (region);
CREATE INDEX useview_anc_danger_sign_date ON cht.mv_anc_danger_sign USING btree (date);
CREATE INDEX mv_anc_danger_sign_year_month_district ON cht.mv_anc_danger_sign USING btree (year, month, district) TABLESPACE ts_indexes;

-- ---------------------------------------------------------------------
-- SOURCE: mv_anc_danger_sign_escalation.sql
-- ---------------------------------------------------------------------

-- cht.mv_anc_danger_sign_escalation source

DROP MATERIALIZED VIEW IF EXISTS cht.mv_anc_danger_sign_escalation;
CREATE MATERIALIZED VIEW cht.mv_anc_danger_sign_escalation
TABLESPACE ts_report
AS SELECT doc ->> '_id'::text AS uuid,
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
    doc #>> '{fields,inputs,user,contact_id}'::text[] AS user_contact_id,
    doc #>> '{fields,inputs,user,facility_id}'::text[] AS user_facility_id,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS contact_name,
    doc #>> '{fields,inputs,contact,sex}'::text[] AS contact_sex,
    doc #>> '{fields,inputs,contact,date_of_birth}'::text[] AS contact_date_of_birth,
    doc #>> '{fields,dob}'::text[] AS dob,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,patient_name}'::text[] AS patient_name,
    doc #>> '{fields,patient_gender}'::text[] AS patient_gender,
    doc #>> '{fields,needs_signoff}'::text[] AS needs_signoff,
    doc #>> '{fields,patient_age_display}'::text[] AS patient_age,
    doc #>> '{fields,patient_age_in_days}'::text[] AS patient_age_in_days,
    doc #>> '{fields,patient_age_in_months}'::text[] AS patient_age_in_months,
    doc #>> '{fields,patient_age_in_years}'::text[] AS patient_age_in_years,
    doc #>> '{fields,inputs,t_place_name}'::text[] AS tvh_place_name,
    doc #>> '{fields,inputs,t_vht_name}'::text[] AS vht_name,
    doc #>> '{fields,inputs,t_vht_phone}'::text[] AS vht_vht_phone,
    doc #>> '{fields,inputs,t_pregnancy_danger_signs}'::text[] AS t_pregnancy_danger_signs,
    doc #>> '{fields,inputs,t_reduced_or_no_feotal_movements}'::text[] AS t_reduced_or_no_feotal_movements,
    doc #>> '{fields,inputs,t_fever}'::text[] AS t_fever,
    doc #>> '{fields,inputs,t_swelling}'::text[] AS t_swelling,
    doc #>> '{fields,inputs,t_very_pale}'::text[] AS t_very_pale,
    doc #>> '{fields,inputs,t_blurred_vision}'::text[] AS t_blurred_vision,
    doc #>> '{fields,inputs,t_breathlessness}'::text[] AS t_breathlessness,
    doc #>> '{fields,inputs,t_severe_headache}'::text[] AS t_severe_headache,
    doc #>> '{fields,inputs,t_vaginal_bleeding}'::text[] AS t_vaginal_bleeding,
    doc #>> '{fields,inputs,t_lower_abdomen_pain}'::text[] AS t_lower_abdomen_pain,
    doc #>> '{fields,inputs,t_patient_id}'::text[] AS t_patient_id,
    doc #>> '{fields,inputs,t_patient_name}'::text[] AS t_patient_name,
    doc #>> '{fields,inputs,t_patient_gender}'::text[] AS t_patient_gender,
    doc #>> '{fields,inputs,t_patient_date_of_birth}'::text[] AS t_patient_date_of_birth,
    doc #>> '{fields,action_taken,explain_vht_not_submit_referral}'::text[] AS explain_vht_not_submit_referral,
    doc #>> '{fields,action_taken,reason_vht_did_not_follow_up}'::text[] AS reason_vht_did_not_follow_up,
    doc #>> '{fields,action_taken,specify}'::text[] AS other_reson_specify,
    doc #>> '{fields,action_taken,vht_completed_referral_follow_up}'::text[] AS vht_completed_referral_follow_up,
    doc #>> '{fields,action_taken,call_chw}'::text[] AS action_call_chw,
    doc #>> '{fields,action_taken,call_button}'::text[] AS action_call_button,
    doc #>> '{fields,danger_signs,referral_signs}'::text[] AS danger_signs_referral_signs,
    doc #>> '{fields,danger_signs,vaginal_bleeding}'::text[] AS danger_signs_vaginal_bleeding,
    doc #>> '{fields,danger_signs,lower_abdomen_pain}'::text[] AS danger_signs_lower_abdomen_pain,
    doc #>> '{fields,danger_signs,severe_headache}'::text[] AS danger_signs_severe_headache,
    doc #>> '{fields,danger_signs,very_pale}'::text[] AS danger_signs_very_pale,
    doc #>> '{fields,danger_signs,fever}'::text[] AS danger_signs_fever,
    doc #>> '{fields,danger_signs,reduced_or_no_feotal_movements}'::text[] AS danger_signs_reduced_or_no_feotal_movements,
    doc #>> '{fields,danger_signs,blurred_vision}'::text[] AS danger_signs_blurred_vision,
    doc #>> '{fields,danger_signs,swelling}'::text[] AS danger_signs_swelling,
    doc #>> '{fields,danger_signs,breathlessness}'::text[] AS danger_signs_breathlessness,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
    CURRENT_TIMESTAMP AS last_refresh_date
   FROM dwh.cht_data couchdb
    LEFT JOIN cht.mv_chw_hierarchy h ON (couchdb.doc #>> '{contact,_id}') = h.chw_id
  WHERE (couchdb.doc ->> 'form'::text) = 'anc_danger_sign_escalation'::text AND couchdb.is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX useview_anc_danger_sign_escalation_reported ON cht.mv_anc_danger_sign_escalation USING btree (reported);
CREATE INDEX useview_anc_danger_sign_escalation_chw_id ON cht.mv_anc_danger_sign_escalation USING btree (chw_id);
CREATE INDEX useview_anc_danger_sign_escalation_facility_id ON cht.mv_anc_danger_sign_escalation USING btree (facility);
CREATE INDEX useview_anc_danger_sign_escalation_district ON cht.mv_anc_danger_sign_escalation USING btree (district);
CREATE INDEX useview_anc_danger_sign_escalation_region ON cht.mv_anc_danger_sign_escalation USING btree (region);
CREATE INDEX useview_anc_danger_sign_escalation_date ON cht.mv_anc_danger_sign_escalation USING btree (date);
CREATE INDEX useview_anc_danger_sign_escalation_monthname ON cht.mv_anc_danger_sign_escalation USING btree (monthname);
CREATE INDEX mv_anc_danger_sign_escalation_year_month_district ON cht.mv_anc_danger_sign_escalation USING btree (year, month, district) TABLESPACE ts_indexes;

-- ---------------------------------------------------------------------
-- SOURCE: mv_anc_danger_sign_notification.sql
-- ---------------------------------------------------------------------

-- cht.mv_anc_danger_sign_notification source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_anc_danger_sign_notification;
CREATE MATERIALIZED VIEW cht.mv_anc_danger_sign_notification
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
    doc #>> '{fields,inputs,source}'::text[] AS source,
    doc #>> '{fields,inputs,source_id}'::text[] AS source_id,
    doc #>> '{fields,inputs,t_place_name}'::text[] AS t_place_name,
    doc #>> '{fields,inputs,t_vht_name}'::text[] AS t_vht_name,
    doc #>> '{fields,inputs,t_vht_phone}'::text[] AS t_vht_phone,
    doc #>> '{fields,inputs,t_vaginal_bleeding}'::text[] AS t_vaginal_bleeding,
    doc #>> '{fields,inputs,t_lower_abdomen_pain}'::text[] AS t_lower_abdomen_pain,
    doc #>> '{fields,inputs,t_severe_headache}'::text[] AS t_severe_headache,
    doc #>> '{fields,inputs,t_very_pale}'::text[] AS t_very_pale,
    doc #>> '{fields,inputs,t_fever}'::text[] AS t_fever,
    doc #>> '{fields,inputs,t_reduced_or_no_feotal_movements}'::text[] AS t_reduced_or_no_feotal_movements,
    doc #>> '{fields,inputs,t_blurred_vision}'::text[] AS t_blurred_vision,
    doc #>> '{fields,inputs,t_swelling}'::text[] AS t_swelling,
    doc #>> '{fields,inputs,t_breathlessness}'::text[] AS t_breathlessness,
    doc #>> '{fields,inputs,current_edd_std}'::text[] AS current_edd_std,
    doc #>> '{fields,inputs,t_patient_name}'::text[] AS t_patient_name,
    doc #>> '{fields,inputs,t_patient_gender}'::text[] AS t_patient_gender,
    doc #>> '{fields,inputs,t_patient_date_of_birth}'::text[] AS t_patient_date_of_birth,
    doc #>> '{fields,inputs,t_patient_id}'::text[] AS t_patient_id,
    doc #>> '{fields,inputs,user,contact_id}'::text[] AS user_contact_id,
    doc #>> '{fields,inputs,user,facility_id}'::text[] AS user_facility_id,
    doc #>> '{fields,inputs,contact,date_of_birth}'::text[] AS contact_date_of_birth,
    doc #>> '{fields,inputs,contact,sex}'::text[] AS contact_sex,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS contact_name,
    doc #>> '{fields,dob}'::text[] AS dob,
    doc #>> '{fields,patient_age_in_years}'::text[] AS patient_age_in_years,
    doc #>> '{fields,patient_age_in_months}'::text[] AS patient_age_in_months,
    doc #>> '{fields,patient_age_in_days}'::text[] AS patient_age_in_days,
    doc #>> '{fields,patient_age_display}'::text[] AS patient_age_display,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,patient_name}'::text[] AS patient_name,
    doc #>> '{fields,patient_gender}'::text[] AS patient_gender,
    doc #>> '{fields,current_pregnancy_age_in_weeks}'::text[] AS current_pregnancy_age_in_weeks,
    doc #>> '{fields,needs_signoff}'::text[] AS needs_signoff,
    doc #>> '{fields,referral_details,health_note}'::text[] AS referral_health_note,
    doc #>> '{fields,referral_details,vaginal_bleeding}'::text[] AS referral_vaginal_bleeding,
    doc #>> '{fields,referral_details,lower_abdomen_pain}'::text[] AS referral_lower_abdomen_pain,
    doc #>> '{fields,referral_details,severe_headache}'::text[] AS referral_severe_headache,
    doc #>> '{fields,referral_details,very_pale}'::text[] AS referral_very_pale,
    doc #>> '{fields,referral_details,fever}'::text[] AS referral_fever,
    doc #>> '{fields,referral_details,reduced_or_no_feotal_movements}'::text[] AS referral_reduced_or_no_feotal_movements,
    doc #>> '{fields,referral_details,blurred_vision}'::text[] AS referral_blurred_vision,
    doc #>> '{fields,referral_details,swelling}'::text[] AS referral_swelling,
    doc #>> '{fields,referral_details,breathlessness}'::text[] AS referral_breathlessness,
    doc #>> '{fields,danger_sign_check,follow_up_child}'::text[] AS follow_up_child,
    doc #>> '{fields,danger_sign_check,danger_signs}'::text[] AS danger_signs,
    doc #>> '{fields,referral,refer_to_facility}'::text[] AS refer_to_facility,
    doc #>> '{fields,referral,confirm_refer_to_facility}'::text[] AS confirm_refer_to_facility,
    doc #>> '{fields,health_education,select_health_condition}'::text[] AS select_health_condition,
    doc #>> '{fields,group_patient_summary,s_note_patient_details}'::text[] AS s_note_patient_details,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
   FROM dwh.cht_data d
   LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id
  WHERE (doc ->> 'form'::text) = 'anc_danger_sign_notification'::text AND d.is_current = true
WITH NO DATA;

-- View indexes:
CREATE INDEX mv_anc_danger_sign_notification_up_reported ON cht.mv_anc_danger_sign_notification USING btree (reported);
CREATE INDEX mv_anc_danger_sign_notification_up_date ON cht.mv_anc_danger_sign_notification USING btree (date);
CREATE INDEX mv_anc_danger_sign_notification_up_monthname ON cht.mv_anc_danger_sign_notification USING btree (monthname);
CREATE INDEX mv_anc_danger_sign_notification_up_year_month_district ON cht.mv_anc_danger_sign_notification USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX mv_anc_danger_sign_notification_up_chw_id ON cht.mv_anc_danger_sign_notification USING btree (chw_id);
CREATE INDEX mv_anc_danger_sign_notification_up_district ON cht.mv_anc_danger_sign_notification USING btree (district);
CREATE INDEX mv_anc_danger_sign_notification_up_region ON cht.mv_anc_danger_sign_notification USING btree (region);
CREATE INDEX mv_anc_danger_sign_notification_up_facility ON cht.mv_anc_danger_sign_notification USING btree (facility);
CREATE INDEX mv_anc_danger_sign_notification_up_dhis2_facility_id ON cht.mv_anc_danger_sign_notification USING btree (dhis2_facility_id);

-- ---------------------------------------------------------------------
-- SOURCE: mv_anc_visit_follow_up.sql
-- ---------------------------------------------------------------------

-- cht.mv_anc_visit_follow_up source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_anc_visit_follow_up;
CREATE MATERIALIZED VIEW cht.mv_anc_visit_follow_up
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
    ((doc -> 'fields'::text) -> 'inputs'::text) ->> 'source'::text AS source,
    ((doc -> 'fields'::text) -> 'inputs'::text) ->> 'source_id'::text AS source_id,
    ((doc -> 'fields'::text) -> 'inputs'::text) ->> 'current_edd_std'::text AS current_edd_std,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> '_id'::text AS inputs_contact_id,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> 'name'::text AS contact_name,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> 'date_of_birth'::text AS date_of_birth,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> 'sex'::text AS sex,
    ((((doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) -> 'parent'::text) ->> '_id'::text AS parent_id,
    (doc -> 'fields'::text) ->> 'is_of_child_bearing_age'::text AS is_of_child_bearing_age,
    (doc -> 'fields'::text) ->> 'visited_contact_uuid'::text AS visited_contact_uuid,
    (doc -> 'fields'::text) ->> 'patient_age_in_years'::text AS patient_age_in_years,
    (doc -> 'fields'::text) ->> 'patient_age_in_months'::text AS patient_age_in_months,
    (doc -> 'fields'::text) ->> 'patient_age_in_days'::text AS patient_age_in_days,
    (doc -> 'fields'::text) ->> 'patient_age_display'::text AS patient_age_display,
    (doc -> 'fields'::text) ->> 'patient_id'::text AS patient_id,
    (doc -> 'fields'::text) ->> 'patient_name'::text AS patient_name,
    (doc -> 'fields'::text) ->> 'patient_name_with_s'::text AS patient_name_with_s,
    (doc -> 'fields'::text) ->> 'patient_gender'::text AS patient_gender,
    (doc -> 'fields'::text) ->> 'current_edd_local'::text AS current_edd_local,
    (doc -> 'fields'::text) ->> 'current_pregnancy_age_in_weeks'::text AS current_pregnancy_age_in_weeks,
    (doc -> 'fields'::text) ->> 'edd_std'::text AS edd_std,
    (doc -> 'fields'::text) ->> 'edd_local'::text AS edd_local,
    (doc -> 'fields'::text) ->> 'pregnancy_ended'::text AS pregnancy_ended,
    (doc -> 'fields'::text) ->> 'pregnancy_ended_label'::text AS pregnancy_ended_label,
    (doc -> 'fields'::text) ->> 'referred_for_nutrition_follow_up'::text AS referred_for_nutrition_follow_up,
    ((doc -> 'fields'::text) -> 'group_follow_up'::text) ->> 'assess_this_pregnancy'::text AS assess_this_pregnancy,
    ((doc -> 'fields'::text) -> 'group_follow_up'::text) ->> 'start_this_pregnancy'::text AS start_this_pregnancy,
    ((doc -> 'fields'::text) -> 'group_follow_up'::text) ->> 'possible_death_cause'::text AS possible_death_cause,
    ((doc -> 'fields'::text) -> 'group_follow_up'::text) ->> 'note_submit_death_report'::text AS note_submit_death_report,
    ((doc -> 'fields'::text) -> 'group_follow_up'::text) ->> 'new_follow_up_date'::text AS new_follow_up_date,
    ((doc -> 'fields'::text) -> 'group_follow_up'::text) ->> 'is_available'::text AS is_available,
    ((doc -> 'fields'::text) -> 'update_pregnancy'::text) ->> 'edd_upto_date'::text AS edd_upto_date,
    ((doc -> 'fields'::text) -> 'update_pregnancy'::text) ->> 'correct_edd'::text AS correct_edd,
    ((doc -> 'fields'::text) -> 'update_pregnancy'::text) ->> 'new_gestation_age_in_weeks'::text AS new_gestation_age_in_weeks,
    ((doc -> 'fields'::text) -> 'update_pregnancy'::text) ->> 'note_refer_for_miscarriage'::text AS note_refer_for_miscarriage,
    ((doc -> 'fields'::text) -> 'update_pregnancy'::text) ->> 'date_of_miscarriage'::text AS date_of_miscarriage,
    ((doc -> 'fields'::text) -> 'update_pregnancy'::text) ->> 'note_reported_abortion'::text AS note_reported_abortion,
    ((doc -> 'fields'::text) -> 'update_pregnancy'::text) ->> 'note_reported_refused_care'::text AS note_reported_refused_care,
    ((doc -> 'fields'::text) -> 'update_pregnancy'::text) ->> 'refused_care_action'::text AS refused_care_action,
    ((doc -> 'fields'::text) -> 'update_pregnancy'::text) ->> 'migrated_action'::text AS migrated_action,
    ((doc -> 'fields'::text) -> 'update_pregnancy'::text) ->> 'note_reported_migrated'::text AS note_reported_migrated,
    ((doc -> 'fields'::text) -> 'update_pregnancy'::text) ->> 'note_submit_delivery_report'::text AS note_submit_delivery_report,
    ((doc -> 'fields'::text) -> 'group_past_anc_visits'::text) ->> 'completed_scheduled_anc_visit'::text AS completed_scheduled_anc_visit,
    ((doc -> 'fields'::text) -> 'group_past_anc_visits'::text) ->> 'anc_visits'::text AS anc_visits,
    ((doc -> 'fields'::text) -> 'group_past_anc_visits'::text) ->> 'date_anc_1'::text AS date_anc_1,
    ((doc -> 'fields'::text) -> 'group_past_anc_visits'::text) ->> 'date_anc_2'::text AS date_anc_2,
    ((doc -> 'fields'::text) -> 'group_past_anc_visits'::text) ->> 'date_anc_3'::text AS date_anc_3,
    ((doc -> 'fields'::text) -> 'group_past_anc_visits'::text) ->> 'date_anc_4'::text AS date_anc_4,
    ((doc -> 'fields'::text) -> 'group_past_anc_visits'::text) ->> 'person_who_accompanied_expectant_mother'::text AS person_who_accompanied_expectant_mother,
    ((doc -> 'fields'::text) -> 'group_upcoming_anc_visits'::text) ->> 'anc_appointment_date'::text AS anc_appointment_date,
    ((doc -> 'fields'::text) -> 'group_upcoming_anc_visits'::text) ->> 'anc_appointment_date_local'::text AS anc_appointment_date_local,
    ((doc -> 'fields'::text) -> 'group_missed_anc_visits'::text) ->> 'why_missed_anc_visit'::text AS why_missed_anc_visit,
    ((doc -> 'fields'::text) -> 'group_missed_anc_visits'::text) ->> 'note_encourage_to_go_for_anc'::text AS note_encourage_to_go_for_anc,
    ((doc -> 'fields'::text) -> 'group_missed_anc_visits'::text) ->> 'missed_anc_actions_taken'::text AS missed_anc_actions_taken,
    ((doc -> 'fields'::text) -> 'group_missed_anc_visits'::text) ->> 'facility_visit_date_for_missed_anc'::text AS facility_visit_date_for_missed_anc,
    ((doc -> 'fields'::text) -> 'group_missed_anc_visits'::text) ->> 'facility_visit_date_for_missed_anc_local'::text AS facility_visit_date_for_missed_anc_local,
    ((doc -> 'fields'::text) -> 'group_missed_anc_visits'::text) ->> 'refer_to_health_facility'::text AS refer_to_health_facility,
    ((doc -> 'fields'::text) -> 'group_safe_pregnancy_practices'::text) ->> 'using_llin'::text AS using_llin,
    ((doc -> 'fields'::text) -> 'group_safe_pregnancy_practices'::text) ->> 'note_llin_prevents_malaria'::text AS note_llin_prevents_malaria,
    ((doc -> 'fields'::text) -> 'group_safe_pregnancy_practices'::text) ->> 'referred_to_health_facility_llin'::text AS referred_to_health_facility_llin,
    ((doc -> 'fields'::text) -> 'group_safe_pregnancy_practices'::text) ->> 'tested_for_hiv_past3months'::text AS tested_for_hiv_past3months,
    ((doc -> 'fields'::text) -> 'group_safe_pregnancy_practices'::text) ->> 'hiv_test_result'::text AS hiv_test_result,
    ((doc -> 'fields'::text) -> 'group_safe_pregnancy_practices'::text) ->> 'on_art_treatment'::text AS on_art_treatment,
    ((doc -> 'fields'::text) -> 'group_safe_pregnancy_practices'::text) ->> 'note_encourage_client_attend_art_clinic'::text AS note_encourage_client_attend_art_clinic,
    ((doc -> 'fields'::text) -> 'group_safe_pregnancy_practices'::text) ->> 'client_taking_medication'::text AS client_taking_medication,
    ((doc -> 'fields'::text) -> 'group_safe_pregnancy_practices'::text) ->> 'note_explain_importance_of_medication'::text AS note_explain_importance_of_medication,
    ((doc -> 'fields'::text) -> 'group_safe_pregnancy_practices'::text) ->> 'note_encourage_client_to_take_medication'::text AS note_encourage_client_to_take_medication,
    ((doc -> 'fields'::text) -> 'group_safe_pregnancy_practices'::text) ->> 'note_encourage_client_to_reduce_hiv_risk'::text AS note_encourage_client_to_reduce_hiv_risk,
    ((doc -> 'fields'::text) -> 'group_safe_pregnancy_practices'::text) ->> 'note_advise_client_to_check_status'::text AS note_advise_client_to_check_status,
    ((doc -> 'fields'::text) -> 'group_safe_pregnancy_practices'::text) ->> 'current_hiv_test_result'::text AS current_hiv_test_result,
    ((doc -> 'fields'::text) -> 'group_safe_pregnancy_practices'::text) ->> 'note_encourage_client_to_retest'::text AS note_encourage_client_to_retest,
    ((doc -> 'fields'::text) -> 'group_safe_pregnancy_practices'::text) ->> 'note_encourage_and_refer_to_health_facility'::text AS note_encourage_and_refer_to_health_facility,
    ((doc -> 'fields'::text) -> 'group_safe_pregnancy_practices'::text) ->> 'client_on_art_treatment'::text AS client_on_art_treatment,
    ((doc -> 'fields'::text) -> 'group_safe_pregnancy_practices'::text) ->> 'note_encourage_client_begin_treatment'::text AS note_encourage_client_begin_treatment,
    ((doc -> 'fields'::text) -> 'group_safe_pregnancy_practices'::text) ->> 'is_client_taking_medication'::text AS is_client_taking_medication,
    ((doc -> 'fields'::text) -> 'group_safe_pregnancy_practices'::text) ->> 'note_explain_importance_of_taking_medication'::text AS note_explain_importance_of_taking_medication,
    ((doc -> 'fields'::text) -> 'group_safe_pregnancy_practices'::text) ->> 'note_encourage_client_to_continue_taking_medication'::text AS note_encourage_client_to_continue_taking_medication,
    ((doc -> 'fields'::text) -> 'group_safe_pregnancy_practices'::text) ->> 'received_tt_immunization'::text AS received_tt_immunization,
    ((doc -> 'fields'::text) -> 'group_safe_pregnancy_practices'::text) ->> 'note_tt_immunization_importance'::text AS note_tt_immunization_importance,
    ((doc -> 'fields'::text) -> 'group_safe_pregnancy_practices'::text) ->> 'note_tt_vaccination_protocol'::text AS note_tt_vaccination_protocol,
    ((doc -> 'fields'::text) -> 'group_nutrition_status'::text) ->> 'note_nutrition_status'::text AS note_nutrition_status,
    ((doc -> 'fields'::text) -> 'group_nutrition_status'::text) ->> 'taken_muac'::text AS taken_muac,
    ((doc -> 'fields'::text) -> 'group_nutrition_status'::text) ->> 'muac_measurement'::text AS muac_measurement,
    ((doc -> 'fields'::text) -> 'group_nutrition_status'::text) ->> 'encourage_client_to_consume_sufficient_diet'::text AS encourage_client_to_consume_sufficient_diet,
    ((doc -> 'fields'::text) -> 'group_nutrition_status'::text) ->> 'note_has_sam'::text AS note_has_sam,
    ((doc -> 'fields'::text) -> 'group_nutrition_status'::text) ->> 'note_has_mam'::text AS note_has_mam,
    ((doc -> 'fields'::text) -> 'group_nutrition_status'::text) ->> 'note_refer_to_health_facility'::text AS note_refer_to_health_facility,
    ((doc -> 'fields'::text) -> 'group_nutrition_status'::text) ->> 'referred_to_health_facility_nutrition'::text AS referred_to_health_facility_nutrition,
    ((doc -> 'fields'::text) -> 'group_nutrition_status'::text) ->> 'micro_nutrient_supplementation_received'::text AS micro_nutrient_supplementation_received,
    ((doc -> 'fields'::text) -> 'group_nutrition_status'::text) ->> 'note_encourage_micro-nutrients'::text AS note_encourage_micro_nutrients,
    ((doc -> 'fields'::text) -> 'group_nutrition_status'::text) ->> 'refer_to_health_facility_no_micro_nutrients'::text AS refer_to_health_facility_no_micro_nutrients,
    ((doc -> 'fields'::text) -> 'group_nutrition_status'::text) ->> 'on_nutrition_follow_up'::text AS on_nutrition_follow_up,
    ((doc -> 'fields'::text) -> 'group_nutrition_status'::text) ->> 'completed_last_nutrition_follow_up'::text AS completed_last_nutrition_follow_up,
    ((doc -> 'fields'::text) -> 'group_nutrition_status'::text) ->> 'next_nutrition_follow_up_date'::text AS next_nutrition_follow_up_date,
    ((doc -> 'fields'::text) -> 'group_nutrition_status'::text) ->> 'note_thank_you_nutrition_follow_up'::text AS note_thank_you_nutrition_follow_up,
    ((doc -> 'fields'::text) -> 'group_nutrition_status'::text) ->> 'note_refer_did_not_complete_follow_up'::text AS note_refer_did_not_complete_follow_up,
    ((doc -> 'fields'::text) -> 'group_nutrition_status'::text) ->> 'referred_to_health_facility_missed_nutrition_follow_up'::text AS referred_to_health_facility_missed_nutrition_follow_up,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date 
   FROM dwh.cht_data couchdb
    LEFT JOIN cht.mv_chw_hierarchy h ON (couchdb.doc #>> '{contact,_id}') = h.chw_id

  WHERE (doc ->> 'form'::text) = 'anc_visit_follow_up'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX mv_anc_visit_follow_up_reported ON cht.mv_anc_visit_follow_up USING btree (reported);
CREATE INDEX mv_anc_visit_follow_up_chw_id ON cht.mv_anc_visit_follow_up USING btree (chw_id);
CREATE INDEX mv_anc_visit_follow_up_year_month_district ON cht.mv_anc_visit_follow_up USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX mv_anc_visit_follow_up_date ON cht.mv_anc_visit_follow_up USING btree (date);
CREATE INDEX mv_anc_visit_follow_up_location ON cht.mv_anc_visit_follow_up USING btree (location_lat, location_long);
CREATE INDEX mv_anc_visit_follow_up_patient_id ON cht.mv_anc_visit_follow_up USING btree (patient_id);
CREATE INDEX mv_anc_visit_follow_up_visited_contact_uuid ON cht.mv_anc_visit_follow_up USING btree (visited_contact_uuid);
CREATE INDEX mv_anc_visit_follow_up_inputs_contact_id ON cht.mv_anc_visit_follow_up USING btree (inputs_contact_id);
CREATE INDEX mv_anc_visit_follow_up_parent_id ON cht.mv_anc_visit_follow_up USING btree (parent_id);

-- ---------------------------------------------------------------------
-- SOURCE: mv_anc_referral_follow_up.sql
-- ---------------------------------------------------------------------

-- cht.mv_anc_referral_follow_up_new source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_anc_referral_follow_up;
CREATE MATERIALIZED VIEW cht.mv_anc_referral_follow_up
TABLESPACE ts_report
AS SELECT doc ->> '_id'::text AS uuid,
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
    doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    doc #>> '{fields,inputs,contact,date_of_birth}'::text[] AS contact_date_of_birth,
    doc #>> '{fields,inputs,contact,name}'::text[] AS contact_name,
    doc #>> '{fields,inputs,contact,sex}'::text[] AS contact_sex,
    doc #>> '{fields,is_of_child_bearing_age}'::text[] AS is_of_child_bearing_age,
    doc #>> '{fields,patient_age_display}'::text[] AS patient_age_display,
    doc #>> '{fields,patient_age_in_days}'::text[] AS patient_age_in_days,
    doc #>> '{fields,patient_age_in_months}'::text[] AS patient_age_in_months,
    doc #>> '{fields,patient_age_in_years}'::text[] AS patient_age_in_years,
    doc #>> '{fields,patient_gender}'::text[] AS patient_gender,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,patient_name}'::text[] AS patient_name,
    doc #>> '{fields,patient_name_with_s}'::text[] AS patient_name_with_s,
    doc #>> '{fields,group_anc_defaulter,went_to_hospital}'::text[] AS went_to_hospital,
    doc #>> '{fields,group_missed_referral_details,actions_taken}'::text[] AS actions_taken,
    doc #>> '{fields,group_missed_referral_details,missed_referral_reason}'::text[] AS missed_referral_reason,
    doc #>> '{fields,group_missed_referral_details,missed_referral_reason_other}'::text[] AS missed_referral_reason_other,
    doc #>> '{fields,group_reminder,note_reminder_to_attend_anc}'::text[] AS note_reminder_to_attend_anc,
    doc #>> '{fields,group_referral_details,went_to_hospital}'::text[] AS group_referral_details_went_to_hospital,
    doc #>> '{fields,group_referral_details,pregnancy_test_outcome}'::text[] AS pregnancy_test_outcome,
    doc #>> '{fields,group_referral_details,note_enroll_into_care}'::text[] AS note_enroll_into_care,
    doc #>> '{fields,group_referral_details,note_fp_counsel}'::text[] AS note_fp_counsel,
    doc #>> '{fields,group_referral_details,reason_not_attended_referral}'::text[] AS reason_not_attended_referral,
    doc #>> '{fields,group_referral_details,reason_not_attended_referral_other}'::text[] AS reason_not_attended_referral_other,
    doc #>> '{fields,group_referral_details,note_counsel_on_early_anc_importance}'::text[] AS note_counsel_on_early_anc_importance,
    doc #>> '{fields,group_referral_details,agreed_to_go_to_facility}'::text[] AS agreed_to_go_to_facility,
    doc #>> '{fields,group_referral_details,facility_visit_date}'::text[] AS facility_visit_date,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date 
   FROM dwh.cht_data couchdb
    LEFT JOIN cht.mv_chw_hierarchy h ON (couchdb.doc #>> '{contact,_id}') = h.chw_id
  WHERE (doc ->> 'form'::text) = 'anc_referral_follow_up'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX mv_anc_referral_follow_up_uuid ON cht.mv_anc_referral_follow_up USING btree (reported);
CREATE INDEX mv_anc_referral_follow_up_chw_id ON cht.mv_anc_referral_follow_up USING btree (chw_id);
CREATE INDEX mv_anc_referral_follow_up_year_month_district ON cht.mv_anc_referral_follow_up USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX mv_anc_referral_follow_up_date ON cht.mv_anc_referral_follow_up USING btree (date);
CREATE INDEX mv_anc_referral_follow_up_facility ON cht.mv_anc_referral_follow_up USING btree (facility);
CREATE INDEX mv_anc_referral_follow_up_dhis2_facility_id ON cht.mv_anc_referral_follow_up USING btree (dhis2_facility_id);
CREATE INDEX mv_anc_referral_follow_up_district ON cht.mv_anc_referral_follow_up USING btree (district);
CREATE INDEX mv_anc_referral_follow_up_region ON cht.mv_anc_referral_follow_up USING btree (region);  


-- ---------------------------------------------------------------------
-- SOURCE: mv_assessment.sql
-- ---------------------------------------------------------------------

DROP MATERIALIZED VIEW IF EXISTS cht.mv_assessment;
CREATE MATERIALIZED VIEW cht.mv_assessment
TABLESPACE ts_report
AS
SELECT
    -- Standard fields (appear in all forms)
    doc ->> '_id'::text AS uuid,
    doc ->> 'form'::text AS form,
    doc ->> 'from'::text AS submitter,
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

    -- Form-specific fields (from the XML)
    doc #>> '{fields,inputs,source}'::text[] AS inputs_source,
    doc #>> '{fields,inputs,source_id}'::text[] AS inputs_source_id,
    doc #>> '{fields,inputs,user,contact_id}'::text[] AS inputs_user_contact_id,
    doc #>> '{fields,inputs,user,facility_id}'::text[] AS inputs_user_facility_id,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    doc #>> '{fields,inputs,contact,date_of_birth}'::text[] AS inputs_contact_date_of_birth,
    doc #>> '{fields,inputs,contact,sex}'::text[] AS inputs_contact_sex,
    doc #>> '{fields,inputs,contact,parent,_id}'::text[] AS inputs_contact_parent_id,
    doc #>> '{fields,inputs,contact,parent,name}'::text[] AS inputs_contact_parent_name,
    doc #>> '{fields,inputs,contact,parent,parent,_id}'::text[] AS inputs_contact_parent_parent_id,
    doc #>> '{fields,inputs,contact,parent,parent,name}'::text[] AS inputs_contact_parent_parent_name,
    doc #>> '{fields,inputs,contact,parent,parent,supervisor}'::text[] AS inputs_contact_parent_parent_supervisor,
    doc #>> '{fields,inputs,contact,parent,parent,phone}'::text[] AS inputs_contact_parent_parent_phone,
    doc #>> '{fields,inputs,contact,parent,parent,village}'::text[] AS inputs_contact_parent_parent_village,
    doc #>> '{fields,inputs,contact,parent,parent,contact,_id}'::text[] AS inputs_contact_parent_parent_contact_id,
    doc #>> '{fields,inputs,contact,parent,parent,contact,phone}'::text[] AS inputs_contact_parent_parent_contact_phone,
    doc #>> '{fields,inputs,contact,parent,parent,contact,name}'::text[] AS inputs_contact_parent_parent_contact_name,
    doc #>> '{fields,inputs,contact,parent,parent,parent,_id}'::text[] AS inputs_contact_parent_parent_parent_id,
    doc #>> '{fields,vaccines_received}'::text[] AS vaccines_received,
    doc #>> '{fields,vaccination_expected}'::text[] AS vaccination_expected,
    doc #>> '{fields,date_of_birth_local}'::text[] AS date_of_birth_local,
    doc #>> '{fields,visited_contact_uuid}'::text[] AS visited_contact_uuid,
    doc #>> '{fields,patient_age_in_years}'::text[] AS patient_age_in_years,
    doc #>> '{fields,patient_age_in_months}'::text[] AS patient_age_in_months,
    doc #>> '{fields,patient_age_in_days}'::text[] AS patient_age_in_days,
    doc #>> '{fields,patient_age_display}'::text[] AS patient_age_display,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,patient_name}'::text[] AS patient_name,
    doc #>> '{fields,patient_gender}'::text[] AS patient_gender,
    doc #>> '{fields,recently_assessed}'::text[] AS recently_assessed,
    doc #>> '{fields,is_hiv_positive}'::text[] AS is_hiv_positive,
    doc #>> '{fields,lastDoseOfVitaminADate}'::text[] AS lastDoseOfVitaminADate,
    doc #>> '{fields,symptom_cough}'::text[] AS symptom_cough,
    doc #>> '{fields,symptom_indrawn_chest}'::text[] AS symptom_indrawn_chest,
    doc #>> '{fields,symptom_fast_breathing}'::text[] AS symptom_fast_breathing,
    doc #>> '{fields,symptom_diarrhoea}'::text[] AS symptom_diarrhoea,
    doc #>> '{fields,symptom_fever}'::text[] AS symptom_fever,
    doc #>> '{fields,num_of_mrdt_tests}'::text[] AS num_of_mrdt_tests,
    doc #>> '{fields,symptom_malaria_test}'::text[] AS symptom_malaria_test,
    doc #>> '{fields,referral_follow_up}'::text[] AS referral_follow_up,
    doc #>> '{fields,give_prereferral_treatment}'::text[] AS give_prereferral_treatment,
    doc #>> '{fields,given_prereferral_treatment}'::text[] AS given_prereferral_treatment,
    doc #>> '{fields,diagnosis_cough}'::text[] AS diagnosis_cough,
    doc #>> '{fields,chw_area_id}'::text[] AS chw_area_id,
    doc #>> '{fields,chw_area_name}'::text[] AS chw_area_name,
    doc #>> '{fields,chw_name}'::text[] AS chw_name,
    doc #>> '{fields,chw_phone}'::text[] AS chw_phone,
    doc #>> '{fields,chw_village}'::text[] AS chw_village,
    doc #>> '{fields,supervisor_id}'::text[] AS supervisor_id,
    doc #>> '{fields,branch_id}'::text[] AS branch_id,
    doc #>> '{fields,fever_treatment}'::text[] AS fever_treatment,
    doc #>> '{fields,cough_treatment}'::text[] AS cough_treatment,
    doc #>> '{fields,diarrhoea_treatment}'::text[] AS diarrhoea_treatment,
    doc #>> '{fields,act_prereferral_treatment_quantity}'::text[] AS act_prereferral_treatment_quantity,
    doc #>> '{fields,act_treatment_quantity}'::text[] AS act_treatment_quantity,
    doc #>> '{fields,act_given}'::text[] AS act_given,
    doc #>> '{fields,zinc_given}'::text[] AS zinc_given,
    doc #>> '{fields,amoxicillin_prereferral_treatment_quantity}'::text[] AS amoxicillin_prereferral_treatment_quantity,
    doc #>> '{fields,amoxicillin_treatment_quantity}'::text[] AS amoxicillin_treatment_quantity,
    doc #>> '{fields,amoxicillin_given}'::text[] AS amoxicillin_given,
    doc #>> '{fields,mrdt_given}'::text[] AS mrdt_given,
    doc #>> '{fields,rectal_given}'::text[] AS rectal_given,
    doc #>> '{fields,gloves_given}'::text[] AS gloves_given,
    doc #>> '{fields,diagnosis_diarrhoea}'::text[] AS diagnosis_diarrhoea,
    doc #>> '{fields,diagnosis_fever}'::text[] AS diagnosis_fever,
    doc #>> '{fields,treat_child_for_diagnosis}'::text[] AS treat_child_for_diagnosis,
    doc #>> '{fields,hiv_exposure_label}'::text[] AS hiv_exposure_label,
    doc #>> '{fields,tb_exposure_label}'::text[] AS tb_exposure_label,
    doc #>> '{fields,needs_signoff}'::text[] AS needs_signoff,
    doc #>> '{fields,should_escalate_nutrtion_referral_follow_up}'::text[] AS should_escalate_nutrtion_referral_follow_up,
    doc #>> '{fields,should_escalate_to_chew}'::text[] AS should_escalate_to_chew,
    doc #>> '{fields,group_vht_assessment_date,vht_assessment_date}'::text[] AS vht_vht_assessment_date,
    doc #>> '{fields,group_vht_assessment_date,note_date_of_birth}'::text[] AS vht_note_date_of_birth,
    doc #>> '{fields,group_vht_assessment_date,is_date_of_birth_correct}'::text[] AS vht_is_date_of_birth_correct,
    doc #>> '{fields,group_vht_assessment_date,note_update_correct_date_of_birth}'::text[] AS vht_note_update_correct_date_of_birth,
    doc #>> '{fields,group_danger_sign_screening,any_danger_signs}'::text[] AS gany_danger_signs,
    doc #>> '{fields,group_danger_sign_screening,child_has_danger_signs}'::text[] AS gchild_has_danger_signs,
    doc #>> '{fields,group_danger_sign_screening,refer_urgent_to_health_facility}'::text[] AS grefer_urgent_to_health_facility,
    doc #>> '{fields,group_cough,has_cough}'::text[] AS g_has_cough,
    doc #>> '{fields,group_cough,cough_duration}'::text[] AS g_cough_duration,
    doc #>> '{fields,group_cough,has_chest_indrawing}'::text[] AS g_has_chest_indrawing,
    doc #>> '{fields,group_cough,note_check_fast_breathing}'::text[] AS g_note_check_fast_breathing,
    doc #>> '{fields,group_cough,cough_danger_sign}'::text[] AS g_cough_danger_sign,
    doc #>> '{fields,group_breathing,note_press_timer}'::text[] AS g_note_press_timer,
    doc #>> '{fields,group_breathing,note_fast_breathing_depends_on}'::text[] AS g_note_fast_breathing_depends_on,
    doc #>> '{fields,group_breathing,breath_count}'::text[] AS g_breath_count,
    doc #>> '{fields,group_breathing,fast_breathing}'::text[] AS g_fast_breathing,
    doc #>> '{fields,group_breathing,fast_breathing_note_true}'::text[] AS g_fast_breathing_note_true,
    doc #>> '{fields,group_breathing,fast_breathing_note_false}'::text[] AS g_fast_breathing_note_false,
    doc #>> '{fields,group_diarrhoea,has_diarrhoea}'::text[] AS g_has_diarrhoea,
    doc #>> '{fields,group_diarrhoea,diarrhoea_duration}'::text[] AS g_diarrhoea_duration,
    doc #>> '{fields,group_diarrhoea,blood_in_stool}'::text[] AS g_blood_in_stool,
    doc #>> '{fields,group_diarrhoea,diarrhoea_danger_sign}'::text[] AS g_diarrhoea_danger_sign,
    doc #>> '{fields,group_fever,has_fever}'::text[] AS g_has_fever,
    doc #>> '{fields,group_fever,has_thermometer}'::text[] AS g_has_thermometer,
    doc #>> '{fields,group_fever,patient_temperature}'::text[] AS g_patient_temperature,
    doc #>> '{fields,group_fever,fever_duration}'::text[] AS g_fever_duration,
    doc #>> '{fields,group_fever,has_mrdt}'::text[] AS g_has_mrdt,
    doc #>> '{fields,group_fever,mrdt_repeat_count}'::text[] AS g_mrdt_repeat_count,
    doc #>> '{fields,group_fever,mrdt_repeat,note_do_mrdt}'::text[] AS g_mrdt_repeat_note_do_mrdt,
    doc #>> '{fields,group_fever,mrdt_repeat,mrdt_used_repeat}'::text[] AS g_mrdt_repeat_mrdt_used_repeat,
    doc #>> '{fields,group_fever,mrdt_repeat,after_blood_note_carestat}'::text[] AS g_mrdt_repeat_after_blood_note_carestat,
    doc #>> '{fields,group_fever,mrdt_repeat,after_blood_note_bioline}'::text[] AS g_mrdt_repeat_after_blood_note_bioline,
    doc #>> '{fields,group_fever,mrdt_repeat,mrdt_result_repeat}'::text[] AS g_mrdt_repeat_mrdt_result_repeat,
    doc #>> '{fields,group_fever,mrdt_repeat,why_mrdt_not_done_repeat}'::text[] AS g_mrdt_repeat_why_mrdt_not_done_repeat,
    doc #>> '{fields,group_fever,mrdt_repeat,note_mrdt_positive_repeat}'::text[] AS g_mrdt_repeat_note_mrdt_positive_repeat,
    doc #>> '{fields,group_fever,mrdt_repeat,note_mrdt_negative}'::text[] AS g_mrdt_repeat_note_mrdt_negative,
    doc #>> '{fields,group_fever,mrdt_repeat,note_mrdt_no_results}'::text[] AS g_mrdt_repeat_note_mrdt_no_results,
    doc #>> '{fields,group_fever,mrdt_repeat,note_encourage_client_to_take_mrdt}'::text[] AS g_mrdt_repeat_note_encourage_client_to_take_mrdt,
    doc #>> '{fields,group_fever,want_to_repeat_mrdt}'::text[] AS g_want_to_repeat_mrdt,
    doc #>> '{fields,group_fever,mrdt_result}'::text[] AS g_mrdt_result,
    doc #>> '{fields,group_fever,mrdt_used}'::text[] AS g_mrdt_used,
    doc #>> '{fields,group_fever,why_mrdt_not_done}'::text[] AS g_why_mrdt_not_done,
    doc #>> '{fields,group_fever,note_mrdt_positive}'::text[] AS g_note_mrdt_positive,
    doc #>> '{fields,group_fever,fever_danger_sign}'::text[] AS g_fever_danger_sign,
    doc #>> '{fields,group_hiv_tb,has_hiv_exposure}'::text[] AS g_has_hiv_exposure,
    doc #>> '{fields,group_hiv_tb,has_tb_exposure}'::text[] AS g_has_tb_exposure,
    doc #>> '{fields,group_malnutrition,acute_malnutrition_signs}'::text[] AS g_acute_malnutrition_signs,
    doc #>> '{fields,group_malnutrition,note_use_muac_tape}'::text[] AS g_note_use_muac_tape,
    doc #>> '{fields,group_malnutrition,muac_colour}'::text[] AS g_muac_colour,
    doc #>> '{fields,group_malnutrition,child_sam}'::text[] AS g_child_sam,
    doc #>> '{fields,group_malnutrition,child_mam}'::text[] AS g_child_mam,
    doc #>> '{fields,group_malnutrition,refer_to_health_facility}'::text[] AS g_refer_to_health_facility,
    doc #>> '{fields,group_malnutrition,referred_to_health_facility}'::text[] AS mal_referred_to_health_facility,
    doc #>> '{fields,group_malnutrition,assess_for_exclusive_breastfeeding}'::text[] AS g_assess_for_exclusive_breastfeeding,
        -- Continuation of form-specific fields (from the XML)
    doc #>> '{fields,group_malnutrition,encourage_to_give_balanced_diet}'::text[] AS g_encourage_to_give_balanced_diet,
    doc #>> '{fields,group_malnutrition,appears_too_small}'::text[] AS g_appears_too_small,
    doc #>> '{fields,group_malnutrition,malnutrition_danger_sign}'::text[] AS g_malnutrition_danger_sign,
    doc #>> '{fields,group_immunization,has_chc}'::text[] AS g_has_chc,
    doc #>> '{fields,group_immunization,note_vaccines_received}'::text[] AS g_note_vaccines_received,
    doc #>> '{fields,group_immunization,immunization_received}'::text[] AS g_immunization_received,
    doc #>> '{fields,group_immunization,immunization_uptodate}'::text[] AS g_immunization_uptodate,
    doc #>> '{fields,group_immunization,note_uptodate}'::text[] AS g_note_uptodate,
    doc #>> '{fields,group_immunization,note_not_uptodate}'::text[] AS g_note_not_uptodate,
    doc #>> '{fields,group_immunization,refer_immunization_ack}'::text[] AS g_refer_immunization_ack,
    doc #>> '{fields,group_immunization,note_encourage_imm}'::text[] AS g_note_encourage_imm,
    doc #>> '{fields,group_immunization,afp_vpd}'::text[] AS g_afp_vpd,
    doc #>> '{fields,group_immunization,refer_afp_ack}'::text[] AS g_refer_afp_ack,
    doc #>> '{fields,group_other_information,exclusive_breast_feeding}'::text[] AS g_exclusive_breast_feeding,
    doc #>> '{fields,group_other_information,reason_child_not_breastfeeding}'::text[] AS g_reason_child_not_breastfeeding,
    doc #>> '{fields,group_other_information,not_breastfeeding_reason_other}'::text[] AS g_not_breastfeeding_reason_other,
    doc #>> '{fields,group_other_information,referred_to_health_facility}'::text[] AS other_referred_to_health_facility,
    doc #>> '{fields,group_other_information,still_breastfeeding}'::text[] AS g_still_breastfeeding,
    doc #>> '{fields,group_other_information,note_counsel_and_educate}'::text[] AS g_note_counsel_and_educate,
    doc #>> '{fields,group_other_information,note_educate_mother}'::text[] AS g_note_educate_mother,
    doc #>> '{fields,group_other_information,walking_or_crawling}'::text[] AS g_walking_or_crawling,
    doc #>> '{fields,group_other_information,note_educate_caregiver}'::text[] AS g_note_educate_caregiver,
    doc #>> '{fields,group_other_information,child_been_dewormed}'::text[] AS g_child_been_dewormed,
    doc #>> '{fields,group_other_information,note_vitamin_a}'::text[] AS g_note_vitamin_a,
    doc #>> '{fields,group_other_information,received_vitamin_a}'::text[] AS g_received_vitamin_a,
    doc #>> '{fields,group_other_information,last_vitamin_A_date}'::text[] AS g_last_vitamin_A_date,
    doc #>> '{fields,group_other_information,refer_to_health_facility_no_vitamin_a}'::text[] AS g_refer_to_health_facility_no_vitamin_a,
    doc #>> '{fields,group_other_information,note_vitamin_a_advice}'::text[] AS g_note_vitamin_a_advice,
    doc #>> '{fields,group_routine_care,wrap_baby_warm}'::text[] AS g_wrap_baby_warm,
    doc #>> '{fields,group_routine_care,skin_cord_care}'::text[] AS g_skin_cord_care,
    doc #>> '{fields,group_routine_care,breastfeeding_exclusively}'::text[] AS g_breastfeeding_exclusively,
    doc #>> '{fields,group_routine_care,wash_hands_before_handling_baby}'::text[] AS g_wash_hands_before_handling_baby,
    doc #>> '{fields,group_routine_care,bathe_baby_clean_water}'::text[] AS g_bathe_baby_clean_water,
    doc #>> '{fields,group_routine_care,do_not_apply_anything_on_cord}'::text[] AS g_do_not_apply_anything_on_cord,
    doc #>> '{fields,group_routine_care,start_breastfeeding_immediately}'::text[] AS g_start_breastfeeding_immediately,
    doc #>> '{fields,group_routine_care,feed_the_baby}'::text[] AS g_feed_the_baby,
    doc #>> '{fields,group_routine_care,ensure_baby_well_positioned}'::text[] AS g_ensure_baby_well_positioned,
    doc #>> '{fields,group_patient_summary,have_you_referred}' AS have_you_referred,
    -- Last column for tracking refresh
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date     

FROM dwh.cht_data d
LEFT JOIN cht.mv_chw_hierarchy h
  ON (d.doc #>> '{contact,_id}') = h.chw_id 

WHERE (doc ->> 'form'::text) = 'assessment'::text
  AND is_current
WITH NO DATA;

-- Indexes
CREATE INDEX mv_assessment_reported
    ON cht.mv_assessment USING btree (reported) TABLESPACE ts_indexes;
CREATE INDEX mv_assessment_patient_id
    ON cht.mv_assessment USING btree (patient_id) TABLESPACE ts_indexes;
CREATE INDEX mv_assessment_chw_id
    ON cht.mv_assessment USING btree (chw_id) TABLESPACE ts_indexes;
CREATE INDEX mv_assessment_date
    ON cht.mv_assessment USING btree (date) TABLESPACE ts_indexes;
-- Org hierarchy
CREATE INDEX mv_assessment_region_district_facility
ON cht.mv_assessment (region, district, facility) TABLESPACE ts_indexes;

CREATE INDEX mv_assessment_district
ON cht.mv_assessment (district) TABLESPACE ts_indexes;

CREATE INDEX mv_assessment_district_facility
ON cht.mv_assessment (district, facility) TABLESPACE ts_indexes;

-- High-impact (MOST IMPORTANT)
CREATE INDEX mv_assessment_year_month_district
ON cht.mv_assessment (year, month, district) TABLESPACE ts_indexes;



-- ---------------------------------------------------------------------
-- SOURCE: mv_cebs_signal_report_chew.sql
-- ---------------------------------------------------------------------

-- cht.mv_cebs_signal_report_chew source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_cebs_signal_report_chew;
CREATE MATERIALIZED VIEW cht.mv_cebs_signal_report_chew
TABLESPACE ts_report
AS SELECT d.doc ->> '_id'::text AS uuid,
    d.doc ->> 'form'::text AS form,
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
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 'source'::text AS source,
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 'source_id'::text AS source_id,
    (((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'user'::text) ->> 'contact_id'::text AS user_contact_id,
    (((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'user'::text) ->> 'facility_id'::text AS user_facility_id,
    (((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> '_id'::text AS inputs_contact_id,
    (((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> 'name'::text AS contact_name,
    (((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> 'village'::text AS contact_village,
    ((((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) -> 'contact'::text) ->> '_id'::text AS cont_contact_id,
    ((((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) -> 'contact'::text) ->> 'name'::text AS cont_contact_name,
    ((((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) -> 'contact'::text) ->> 'date_of_birth'::text AS cont_contact_date_of_birth,
    ((((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) -> 'contact'::text) ->> 'phone'::text AS cont_contact_phone,
    (d.doc -> 'fields'::text) ->> 'needs_signoff'::text AS needs_signoff,
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 'chw_name'::text AS chw_name,
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 'chw_phone'::text AS chw_phone,
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 'place_id'::text AS place_id,
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 'place_name'::text AS place_name,
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 'chw_village'::text AS chw_village,
    ((d.doc -> 'fields'::text) -> 'unusual_health_event'::text) ->> 'experienced_unusual_health_event'::text AS experienced_unusual_health_event,
    ((d.doc -> 'fields'::text) -> 'signal_type'::text) ->> 'signal_reported'::text AS signal_reported,
    ((d.doc -> 'fields'::text) -> 'signal_type'::text) ->> 'additional_information'::text AS additional_information,
    ((d.doc -> 'fields'::text) -> 'signal_type'::text) ->> 'person_under_vht_area'::text AS person_under_vht_area,
    ((d.doc -> 'fields'::text) -> 'signal_type'::text) ->> 'brief_description'::text AS brief_description,
    d.doc #>> '{contact,_id}'::text[] AS chw_id,
    h.facility,
    h.village,
    h.district,
    h.region,
    CURRENT_TIMESTAMP AS last_refresh_date
   FROM dwh.cht_data d
     LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}'::text[]) = h.chw_id
  WHERE (d.doc ->> 'form'::text) = 'cebs_signal_report_chew'::text AND d.is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX mv_cebs_signal_report_chew_eported ON cht.mv_cebs_signal_report_chew USING btree (reported) TABLESPACE ts_indexes;
CREATE INDEX mv_cebs_signal_report_chewchw_is ON cht.mv_cebs_signal_report_chew USING btree (chw_id) TABLESPACE ts_indexes;
CREATE INDEX mv_cebs_signal_report_chewchw_facility ON cht.mv_cebs_signal_report_chew USING btree (chw_id, facility) TABLESPACE ts_indexes;
CREATE INDEX mv_cebs_signal_report_chewchw_district ON cht.mv_cebs_signal_report_chew USING btree (chw_id, district) TABLESPACE ts_indexes;
CREATE INDEX mv_cebs_signal_report_chewchw_region ON cht.mv_cebs_signal_report_chew USING btree (chw_id, region) TABLESPACE ts_indexes;
CREATE INDEX mv_cebs_signal_report_chew_year_month_district ON cht.mv_cebs_signal_report_chew USING btree (year, month, district) TABLESPACE ts_indexes;

-- ---------------------------------------------------------------------
-- SOURCE: mv_cebs_signal_report_vht.sql
-- ---------------------------------------------------------------------

-- cht.mv_cebs_signal_report_vht source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_cebs_signal_report_vht;
CREATE MATERIALIZED VIEW cht.mv_cebs_signal_report_vht
TABLESPACE ts_report
AS SELECT d.doc ->> '_id'::text AS uuid,
    d.doc ->> 'form'::text AS form,
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
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 'source'::text AS source,
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 'source_id'::text AS source_id,
    (((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'user'::text) ->> 'contact_id'::text AS user_contact_id,
    (((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'user'::text) ->> 'facility_id'::text AS user_facility_id,
    (((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> '_id'::text AS contact_id,
    (((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> 'name'::text AS contact_name,
    (((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> 'village'::text AS contact_village,
    ((((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) -> 'contact'::text) ->> '_id'::text AS cont_contact_id,
    ((((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) -> 'contact'::text) ->> 'name'::text AS cont_contact_name,
    ((((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) -> 'contact'::text) ->> 'date_of_birth'::text AS cont_contact_date_of_birth,
    ((((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) -> 'contact'::text) ->> 'phone'::text AS cont_contact_phone,
    (d.doc -> 'fields'::text) ->> 'needs_signoff'::text AS needs_signoff,
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 'chw_name'::text AS chw_name,
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 'chw_phone'::text AS chw_phone,
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 'place_id'::text AS place_id,
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 'place_name'::text AS place_name,
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 'chw_village'::text AS chw_village,
    ((d.doc -> 'fields'::text) -> 'unusual_health_event'::text) ->> 'experienced_unusual_health_event'::text AS experienced_unusual_health_event,
    ((d.doc -> 'fields'::text) -> 'signal_type'::text) ->> 'signal_reported'::text AS signal_reported,
    ((d.doc -> 'fields'::text) -> 'signal_type'::text) ->> 'additional_information'::text AS additional_information,
    ((d.doc -> 'fields'::text) -> 'signal_type'::text) ->> 'person_under_vht_area'::text AS person_under_vht_area,
    ((d.doc -> 'fields'::text) -> 'signal_type'::text) ->> 'brief_description'::text AS brief_description,
    ((d.doc -> 'fields'::text) -> 'group_summary'::text) ->> 's_note_signal_report_summary_page'::text AS s_note_signal_report_summary_page,
    ((d.doc -> 'fields'::text) -> 'group_summary'::text) ->> 's_note_be_sure_to_submit'::text AS s_note_be_sure_to_submit,
    ((d.doc -> 'fields'::text) -> 'group_summary'::text) ->> 's_note_signal_details'::text AS s_note_signal_details,
    ((d.doc -> 'fields'::text) -> 'group_summary'::text) ->> 'no_signal_reported'::text AS no_signal_reported,
    ((d.doc -> 'fields'::text) -> 'group_summary'::text) ->> 's_note_fever_and_bleeding'::text AS s_note_fever_and_bleeding,
    ((d.doc -> 'fields'::text) -> 'group_summary'::text) ->> 's_note_unexplained_rash'::text AS s_note_unexplained_rash,
    ((d.doc -> 'fields'::text) -> 'group_summary'::text) ->> 's_note_sudden_or_unexplained_death'::text AS s_note_sudden_or_unexplained_death,
    ((d.doc -> 'fields'::text) -> 'group_summary'::text) ->> 's_note_bitten_by_dog_or_animal'::text AS s_note_bitten_by_dog_or_animal,
    ((d.doc -> 'fields'::text) -> 'group_summary'::text) ->> 's_note_abnormal_change_in_drinking_water'::text AS s_note_abnormal_change_in_drinking_water,
    ((d.doc -> 'fields'::text) -> 'group_summary'::text) ->> 's_note_public_health_threat'::text AS s_note_public_health_threat,
    ((d.doc -> 'fields'::text) -> 'group_summary'::text) ->> 's_note_key_instruction'::text AS s_note_key_instruction,
    ((d.doc -> 'fields'::text) -> 'group_summary'::text) ->> 'switch_on_data'::text AS switch_on_data,
    d.doc #>> '{contact,_id}'::text[] AS chw_id,
    h.facility,
    h.village,
    h.district,
    h.region,
    CURRENT_TIMESTAMP AS last_refresh_date
   FROM dwh.cht_data d
     LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}'::text[]) = h.chw_id
  WHERE (d.doc ->> 'form'::text) = 'cebs_signal_report_vht'::text AND d.is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX mv_cebs_signal_report_vht_eported ON cht.mv_cebs_signal_report_vht USING btree (reported) TABLESPACE ts_indexes;
CREATE INDEX mv_cebs_signal_report_vhtchw_is ON cht.mv_cebs_signal_report_vht USING btree (chw_id) TABLESPACE ts_indexes;
CREATE INDEX mv_cebs_signal_report_vht_region_district_facility
ON cht.mv_cebs_signal_report_vht (region, district, facility) TABLESPACE ts_indexes;

CREATE INDEX mv_cebs_signal_report_vht_district
ON cht.mv_cebs_signal_report_vht (district) TABLESPACE ts_indexes;

CREATE INDEX mv_cebs_signal_report_vht_district_facility
ON cht.mv_cebs_signal_report_vht (district, facility) TABLESPACE ts_indexes;

-- High-impact (MOST IMPORTANT)
CREATE INDEX mv_cebs_signal_report_vht_year_month_district
ON cht.mv_cebs_signal_report_vht (year, month, district) TABLESPACE ts_indexes;

-- ---------------------------------------------------------------------
-- SOURCE: mv_cebs_signal_verification.sql
-- ---------------------------------------------------------------------

-- cht.mv_cebs_signal_verification source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_cebs_signal_verification;
CREATE MATERIALIZED VIEW cht.mv_cebs_signal_verification
TABLESPACE ts_report
AS SELECT d.doc ->> '_id'::text AS uuid,
    d.doc ->> 'form'::text AS form,
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
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 't_patient_condition'::text AS t_patient_condition,
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 'source'::text AS source,
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 'source_id'::text AS source_id,
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 'vht_or_chew_name'::text AS vht_or_chew_name,
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 'vht_or_chew_phone'::text AS vht_or_chew_phone,
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 'vht_or_chew_area'::text AS vht_or_chew_area,
    (((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> '_id'::text AS contact_id,
    (((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> 'name'::text AS contact_name,
    ((((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) -> 'contact'::text) ->> '_id'::text AS inputs_contact_id,
    ((((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) -> 'contact'::text) ->> 'name'::text AS inputs_contact_name,
    ((((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) -> 'contact'::text) ->> 'date_of_birth'::text AS date_of_birth,
    (((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'user'::text) ->> 'name'::text AS user_name,
    (((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'user'::text) ->> 'contact_id'::text AS user_contact_id,
    (d.doc -> 'fields'::text) ->> 'place_id'::text AS place_id,
    (d.doc -> 'fields'::text) ->> 'place_name'::text AS place_name,
    (d.doc -> 'fields'::text) ->> 'supervisor_name'::text AS supervisor_name,
    (d.doc -> 'fields'::text) ->> 'supervisor_phone'::text AS supervisor_phone,
    (d.doc -> 'fields'::text) ->> 'signal_name'::text AS signal_name,
    (d.doc -> 'fields'::text) ->> 'needs_signoff'::text AS needs_signoff,
    (((d.doc -> 'fields'::text) -> 'signal_overview'::text) -> 'current_user'::text) ->> '_id'::text AS current_user_id,
    (((d.doc -> 'fields'::text) -> 'signal_overview'::text) -> 'current_user'::text) ->> 'name'::text AS current_user_name,
    (((d.doc -> 'fields'::text) -> 'signal_overview'::text) -> 'current_user'::text) ->> 'phone'::text AS current_user_phone,
    ((d.doc -> 'fields'::text) -> 'signal_overview'::text) ->> 'vht_or_chew_info'::text AS vht_or_chew_info,
    ((d.doc -> 'fields'::text) -> 'signal_overview'::text) ->> 'mode_of_verification'::text AS mode_of_verification,
    ((d.doc -> 'fields'::text) -> 'signal_overview'::text) ->> 'description_of_signal'::text AS description_of_signal,
    ((d.doc -> 'fields'::text) -> 'signal_verification'::text) ->> 'information_match_signal_type'::text AS information_match_signal_type,
    ((d.doc -> 'fields'::text) -> 'signal_verification'::text) ->> 'matching_signal'::text AS matching_signal,
    ((d.doc -> 'fields'::text) -> 'verification'::text) ->> 'signal_reported_before'::text AS signal_reported_before,
    ((d.doc -> 'fields'::text) -> 'verification'::text) ->> 'not_new_signal'::text AS not_new_signal,
    ((d.doc -> 'fields'::text) -> 'verification'::text) ->> 'health_threat_start'::text AS health_threat_start,
    ((d.doc -> 'fields'::text) -> 'verification'::text) ->> 'approximate_number_ill'::text AS approximate_number_ill,
    ((d.doc -> 'fields'::text) -> 'verification'::text) ->> 'approximate_number_dead'::text AS approximate_number_dead,
    ((d.doc -> 'fields'::text) -> 'verification'::text) ->> 'signal_involve_animals'::text AS signal_involve_animals,
    ((d.doc -> 'fields'::text) -> 'verification'::text) ->> 'animals_involved'::text AS animals_involved,
    ((d.doc -> 'fields'::text) -> 'verification'::text) ->> 'specify_animal_involved'::text AS specify_animal_involved,
    ((d.doc -> 'fields'::text) -> 'verification'::text) ->> 'approximate_animals_affected'::text AS approximate_animals_affected,
    ((d.doc -> 'fields'::text) -> 'verification'::text) ->> 'approximate_animals_dead'::text AS approximate_animals_dead,
    ((d.doc -> 'fields'::text) -> 'verification'::text) ->> 'source_of_information'::text AS source_of_information,
    ((d.doc -> 'fields'::text) -> 'verification'::text) ->> 'additional_information'::text AS additional_information,
    ((d.doc -> 'fields'::text) -> 'verification'::text) ->> 'date_health_threat_verified'::text AS date_health_threat_verified,
    ((d.doc -> 'fields'::text) -> 'verification'::text) ->> 'reported_threat_exists'::text AS reported_threat_exists,
    ((d.doc -> 'fields'::text) -> 'verification'::text) ->> 'note_reported_threat_does_not_exist'::text AS note_reported_threat_does_not_exist,
    ((d.doc -> 'fields'::text) -> 'verification'::text) ->> 'date_facility_informed'::text AS date_facility_informed,
    ((d.doc -> 'fields'::text) -> 'verification'::text) ->> 'signal_been_referred'::text AS signal_been_referred,
    d.doc #>> '{contact,_id}'::text[] AS chw_id,
    h.facility,
    h.village,
    h.district,
    h.region,
    CURRENT_TIMESTAMP AS last_refresh_date
   FROM dwh.cht_data d
     LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}'::text[]) = h.chw_id
  WHERE (d.doc ->> 'form'::text) = 'cebs_signal_verification'::text AND d.is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX mv_cebs_signal_verification_eported ON cht.mv_cebs_signal_verification USING btree (reported) TABLESPACE ts_indexes;
CREATE INDEX mv_cebs_signal_verificationchw_is ON cht.mv_cebs_signal_verification USING btree (chw_id) TABLESPACE ts_indexes;
CREATE INDEX mv_cebs_signal_verification_region_district_facility ON cht.mv_cebs_signal_verification (region, district, facility) TABLESPACE ts_indexes;
CREATE INDEX mv_cebs_signal_verification_year_month_district ON cht.mv_cebs_signal_verification USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX mv_cebs_signal_verification_district ON cht.mv_cebs_signal_verification (district) TABLESPACE ts_indexes;
CREATE INDEX mv_cebs_signal_verification_district_facility ON cht.mv_cebs_signal_verification (district, facility) TABLESPACE ts_indexes; 

-- ---------------------------------------------------------------------
-- SOURCE: mv_cebs_signal_verification_notification.sql
-- ---------------------------------------------------------------------

-- cht.mv_cebs_signal_verification_notification source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_cebs_signal_verification_notification;
CREATE MATERIALIZED VIEW cht.mv_cebs_signal_verification_notification
TABLESPACE ts_report
AS SELECT d.doc ->> '_id'::text AS uuid,
    d.doc ->> 'form'::text AS form,
    to_timestamp((NULLIF(d.doc ->> 'reported_date'::text, ''::text)::bigint / 1000)::double precision) AS reported,
    to_char(to_timestamp((((d.doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'YYYY-MM-DD'::text)::date AS date,
    to_char(to_timestamp((((d.doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'YYYY'::text)::integer AS year,
    to_char(to_timestamp((((d.doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'MM'::text)::integer AS month,
    to_char(to_timestamp((((d.doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'FMMonth'::text) AS monthname,
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
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 'source'::text AS source,
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 'source_id'::text AS source_id,
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 't_place_name'::text AS t_place_name,
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 't_place_id'::text AS t_place_id,
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 't_vht_or_chew_name'::text AS t_vht_or_chew_name,
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 't_vht_or_chew_phone'::text AS t_vht_or_chew_phone,
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 't_signal_name'::text AS t_signal_name,
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 't_does_not_match_signal'::text AS t_does_not_match_signal,
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 't_duplicate_signal'::text AS t_duplicate_signal,
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 't_threat_exists'::text AS t_threat_exists,
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 't_supervisor_name'::text AS t_supervisor_name,
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 't_supervisor_phone'::text AS t_supervisor_phone,
    (((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'user'::text) ->> 'contact_id'::text AS user_contact_id,
    (((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'user'::text) ->> 'facility_id'::text AS user_facility_id,
    (((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> '_id'::text AS contact_id,
    (((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> 'name'::text AS contact_name,
    (((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> 'date_of_birth'::text AS date_of_birth,
    (((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> 'sex'::text AS sex,
    (d.doc -> 'fields'::text) ->> 'supervisor'::text AS supervisor,
    (d.doc -> 'fields'::text) ->> 'supervisor_phone'::text AS supervisor_phone,
    (d.doc -> 'fields'::text) ->> 'vht_or_chew_name'::text AS vht_or_chew_name,
    (d.doc -> 'fields'::text) ->> 'vht_or_chew_phone'::text AS vht_or_chew_phone,
    (d.doc -> 'fields'::text) ->> 'signal_name'::text AS signal_name,
    (d.doc -> 'fields'::text) ->> 'does_not_match_signal'::text AS does_not_match_signal,
    (d.doc -> 'fields'::text) ->> 'is_duplicate_signal'::text AS is_duplicate_signal,
    (d.doc -> 'fields'::text) ->> 'threat_exists'::text AS threat_exists,
    (d.doc -> 'fields'::text) ->> 'needs_signoff'::text AS needs_signoff,
    ((d.doc -> 'fields'::text) -> 'notification'::text) ->> 'supervisor_verified_signal'::text AS supervisor_verified_signal,
    ((d.doc -> 'fields'::text) -> 'notification'::text) ->> 'findings'::text AS findings,
    ((d.doc -> 'fields'::text) -> 'notification'::text) ->> 'informatio_does_not_match_a_signal'::text AS informatio_does_not_match_a_signal,
    ((d.doc -> 'fields'::text) -> 'notification'::text) ->> 'duplicate_signal'::text AS notification_duplicate_signal,
    ((d.doc -> 'fields'::text) -> 'notification'::text) ->> 'threat_still_exists'::text AS threat_still_exists,
    ((d.doc -> 'fields'::text) -> 'notification'::text) ->> 'threat_no_longer_exists'::text AS threat_no_longer_exists,
    d.doc #>> '{contact,_id}'::text[] AS chw_id,
    h.facility,
    h.village,
    h.district,
    h.region,
    CURRENT_TIMESTAMP AS last_refresh_date
   FROM dwh.cht_data d
     LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}'::text[]) = h.chw_id
  WHERE (d.doc ->> 'form'::text) = 'cebs_signal_verification_notification'::text AND d.is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX mv_cebs_signal_verification_notification_eported ON cht.mv_cebs_signal_verification_notification USING btree (reported) TABLESPACE ts_indexes;
CREATE INDEX mv_cebs_signal_verification_notificationchw_is ON cht.mv_cebs_signal_verification_notification USING btree (chw_id) TABLESPACE ts_indexes;
CREATE INDEX mv_cebs_signal_verification_notificationdate ON cht.mv_cebs_signal_verification_notification USING btree (date) TABLESPACE ts_indexes;
CREATE INDEX mv_cebs_signal_verification_notification_year_month_district ON cht.mv_cebs_signal_verification_notification USING btree (year, month, district) TABLESPACE ts_indexes;
