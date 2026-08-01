-- ============================================================================
-- recreate_parish_mvs.sql
--
-- Drops & recreates (WITH NO DATA) every MV that gained the parish column.
-- Populate afterwards with a separate refresh (see refresh_all_mvs.sql).
--
-- Order:
--   1) tier_1a - MVs with NO dependents: plain DROP. Safe to run top-to-bottom.
--   2) tier_1b - the 4 MVs WITH dependents: DROP ... CASCADE (also drops their
--      dependent matviews). Run this block after 1). Recreate the dependent
--      matviews (mv_integrated_echis_performance, mv_delivery_report,
--      delivery_report) manually afterwards.
--
-- Generated from the individual mv_*.sql sources. Edit those, not this.
-- ============================================================================

--==========tier_0==========--
-- cht.mv_chw_hierarchy already exposes parish; it is UNCHANGED and NOT recreated
-- here. It is the parent of every MV below - do not drop it.

--==========tier_1a : NO dependents (plain DROP)==========--

-- -------- mv_afp_notification  (source: mv_afp_notification.sql) --------
DROP MATERIALIZED VIEW cht.mv_afp_notification;
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
      h.parish,
      h.district,
      h.region,
    CURRENT_TIMESTAMP AS last_refresh_date
   FROM dwh.cht_data d
   LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id 
  WHERE (d.doc ->> 'form'::text) = 'afp_notification'::text AND d.is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX mv_afp_notification_reported ON cht.mv_afp_notification USING btree (reported) TABLESPACE ts_indexes;
CREATE INDEX mv_afp_notification_chw_id ON cht.mv_afp_notification USING btree (chw_id) TABLESPACE ts_indexes;
create index mv_afp_notification_facility_id on cht.mv_afp_notification using btree (facility) TABLESPACE ts_indexes;
CREATE INDEX mv_afp_notification_district ON cht.mv_afp_notification USING btree (district) TABLESPACE ts_indexes;
CREATE INDEX mv_afp_notification_region ON cht.mv_afp_notification USING btree (region) TABLESPACE ts_indexes;
CREATE INDEX mv_afp_notification_date ON cht.mv_afp_notification USING btree (date) TABLESPACE ts_indexes;
CREATE INDEX mv_afp_notification_year_month_district ON cht.mv_afp_notification USING btree (year, month, district) TABLESPACE ts_indexes;


-- -------- mv_anc_danger_sign  (source: mv_anc_danger_sign.sql) --------
DROP MATERIALIZED VIEW cht.mv_anc_danger_sign;
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
      h.parish,
      h.district,
      h.region,
    CURRENT_TIMESTAMP AS last_refresh_date
   FROM dwh.cht_data couchdb
   LEFT JOIN cht.mv_chw_hierarchy h ON (couchdb.doc #>> '{contact,_id}') = h.chw_id 
  WHERE (couchdb.doc ->> 'form'::text) = 'anc_danger_sign'::text AND couchdb.is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX useview_anc_danger_sign_uuid ON cht.mv_anc_danger_sign USING btree (reported) TABLESPACE ts_indexes;
CREATE INDEX useview_anc_danger_sign_chw_id ON cht.mv_anc_danger_sign USING btree (chw_id) TABLESPACE ts_indexes;
CREATE INDEX useview_anc_danger_sign_facility_id ON cht.mv_anc_danger_sign USING btree (facility) TABLESPACE ts_indexes;
CREATE INDEX useview_anc_danger_sign_district ON cht.mv_anc_danger_sign USING btree (district) TABLESPACE ts_indexes;
CREATE INDEX useview_anc_danger_sign_region ON cht.mv_anc_danger_sign USING btree (region) TABLESPACE ts_indexes;
CREATE INDEX useview_anc_danger_sign_date ON cht.mv_anc_danger_sign USING btree (date) TABLESPACE ts_indexes;
CREATE INDEX mv_anc_danger_sign_year_month_district ON cht.mv_anc_danger_sign USING btree (year, month, district) TABLESPACE ts_indexes;


-- -------- mv_anc_danger_sign_escalation  (source: mv_anc_danger_sign_escalation.sql) --------
DROP MATERIALIZED VIEW cht.mv_anc_danger_sign_escalation;
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
      h.parish,
      h.district,
      h.region,
    CURRENT_TIMESTAMP AS last_refresh_date
   FROM dwh.cht_data couchdb
    LEFT JOIN cht.mv_chw_hierarchy h ON (couchdb.doc #>> '{contact,_id}') = h.chw_id
  WHERE (couchdb.doc ->> 'form'::text) = 'anc_danger_sign_escalation'::text AND couchdb.is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX useview_anc_danger_sign_escalation_reported ON cht.mv_anc_danger_sign_escalation USING btree (reported) TABLESPACE ts_indexes;
CREATE INDEX useview_anc_danger_sign_escalation_chw_id ON cht.mv_anc_danger_sign_escalation USING btree (chw_id) TABLESPACE ts_indexes;
CREATE INDEX useview_anc_danger_sign_escalation_facility_id ON cht.mv_anc_danger_sign_escalation USING btree (facility) TABLESPACE ts_indexes;
CREATE INDEX useview_anc_danger_sign_escalation_district ON cht.mv_anc_danger_sign_escalation USING btree (district) TABLESPACE ts_indexes;
CREATE INDEX useview_anc_danger_sign_escalation_region ON cht.mv_anc_danger_sign_escalation USING btree (region) TABLESPACE ts_indexes;
CREATE INDEX useview_anc_danger_sign_escalation_date ON cht.mv_anc_danger_sign_escalation USING btree (date) TABLESPACE ts_indexes;
CREATE INDEX useview_anc_danger_sign_escalation_monthname ON cht.mv_anc_danger_sign_escalation USING btree (monthname) TABLESPACE ts_indexes;
CREATE INDEX mv_anc_danger_sign_escalation_year_month_district ON cht.mv_anc_danger_sign_escalation USING btree (year, month, district) TABLESPACE ts_indexes;


-- -------- mv_anc_danger_sign_follow_up  (source: mv_anc_danger_sign_follow_up.sql) --------
DROP MATERIALIZED VIEW cht.mv_anc_danger_sign_follow_up;
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
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.parish,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
   FROM dwh.cht_data d
   LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id
  WHERE d.type = 'data_record'::text AND (d.doc ->> 'form'::text) = 'anc_danger_sign_follow_up'::text AND d.is_current IS TRUE
WITH NO DATA;

CREATE INDEX idx_mv_anc_danger_sign_follow_up_doc_id_rev_id
  ON cht.mv_anc_danger_sign_follow_up (doc_id, rev_id) TABLESPACE ts_indexes;
CREATE INDEX idx_mv_anc_danger_sign_follow_up_chw_id
  ON cht.mv_anc_danger_sign_follow_up (chw_id) TABLESPACE ts_indexes;
CREATE INDEX idx_mv_anc_danger_sign_follow_up_reported
  ON cht.mv_anc_danger_sign_follow_up (reported) TABLESPACE ts_indexes;
CREATE INDEX idx_mv_anc_danger_sign_follow_up_date
  ON cht.mv_anc_danger_sign_follow_up (date) TABLESPACE ts_indexes;
CREATE INDEX idx_mv_anc_danger_sign_follow_up_year_month_district
  ON cht.mv_anc_danger_sign_follow_up (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX idx_mv_anc_danger_sign_follow_up_monthname
  ON cht.mv_anc_danger_sign_follow_up (monthname) TABLESPACE ts_indexes;


-- -------- mv_anc_danger_sign_notification  (source: mv_anc_danger_sign_notification.sql) --------
DROP MATERIALIZED VIEW cht.mv_anc_danger_sign_notification;
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
      h.parish,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
   FROM dwh.cht_data d
   LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id
  WHERE (doc ->> 'form'::text) = 'anc_danger_sign_notification'::text AND d.is_current = true
WITH NO DATA;

-- View indexes:
CREATE INDEX mv_anc_danger_sign_notification_up_reported ON cht.mv_anc_danger_sign_notification USING btree (reported) TABLESPACE ts_indexes;
CREATE INDEX mv_anc_danger_sign_notification_up_date ON cht.mv_anc_danger_sign_notification USING btree (date) TABLESPACE ts_indexes;
CREATE INDEX mv_anc_danger_sign_notification_up_monthname ON cht.mv_anc_danger_sign_notification USING btree (monthname) TABLESPACE ts_indexes;
CREATE INDEX mv_anc_danger_sign_notification_up_year_month_district ON cht.mv_anc_danger_sign_notification USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX mv_anc_danger_sign_notification_up_chw_id ON cht.mv_anc_danger_sign_notification USING btree (chw_id) TABLESPACE ts_indexes;
CREATE INDEX mv_anc_danger_sign_notification_up_district ON cht.mv_anc_danger_sign_notification USING btree (district) TABLESPACE ts_indexes;
CREATE INDEX mv_anc_danger_sign_notification_up_region ON cht.mv_anc_danger_sign_notification USING btree (region) TABLESPACE ts_indexes;
CREATE INDEX mv_anc_danger_sign_notification_up_facility ON cht.mv_anc_danger_sign_notification USING btree (facility) TABLESPACE ts_indexes;
CREATE INDEX mv_anc_danger_sign_notification_up_dhis2_facility_id ON cht.mv_anc_danger_sign_notification USING btree (dhis2_facility_id) TABLESPACE ts_indexes;


-- -------- mv_anc_referral_follow_up  (source: mv_anc_referral_follow_up.sql) --------
DROP MATERIALIZED VIEW cht.mv_anc_referral_follow_up;
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
      h.parish,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date 
   FROM dwh.cht_data couchdb
    LEFT JOIN cht.mv_chw_hierarchy h ON (couchdb.doc #>> '{contact,_id}') = h.chw_id
  WHERE (doc ->> 'form'::text) = 'anc_referral_follow_up'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX mv_anc_referral_follow_up_uuid ON cht.mv_anc_referral_follow_up USING btree (reported) TABLESPACE ts_indexes;
CREATE INDEX mv_anc_referral_follow_up_chw_id ON cht.mv_anc_referral_follow_up USING btree (chw_id) TABLESPACE ts_indexes;
CREATE INDEX mv_anc_referral_follow_up_year_month_district ON cht.mv_anc_referral_follow_up USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX mv_anc_referral_follow_up_date ON cht.mv_anc_referral_follow_up USING btree (date) TABLESPACE ts_indexes;
CREATE INDEX mv_anc_referral_follow_up_facility ON cht.mv_anc_referral_follow_up USING btree (facility) TABLESPACE ts_indexes;
CREATE INDEX mv_anc_referral_follow_up_dhis2_facility_id ON cht.mv_anc_referral_follow_up USING btree (dhis2_facility_id) TABLESPACE ts_indexes;
CREATE INDEX mv_anc_referral_follow_up_district ON cht.mv_anc_referral_follow_up USING btree (district) TABLESPACE ts_indexes;
CREATE INDEX mv_anc_referral_follow_up_region ON cht.mv_anc_referral_follow_up USING btree (region) TABLESPACE ts_indexes;  


-- -------- mv_anc_visit_follow_up  (source: mv_anc_visit_follow_up.sql) --------
DROP MATERIALIZED VIEW cht.mv_anc_visit_follow_up;
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
      h.parish,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date 
   FROM dwh.cht_data couchdb
    LEFT JOIN cht.mv_chw_hierarchy h ON (couchdb.doc #>> '{contact,_id}') = h.chw_id

  WHERE (doc ->> 'form'::text) = 'anc_visit_follow_up'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX mv_anc_visit_follow_up_reported ON cht.mv_anc_visit_follow_up USING btree (reported) TABLESPACE ts_indexes;
CREATE INDEX mv_anc_visit_follow_up_chw_id ON cht.mv_anc_visit_follow_up USING btree (chw_id) TABLESPACE ts_indexes;
CREATE INDEX mv_anc_visit_follow_up_year_month_district ON cht.mv_anc_visit_follow_up USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX mv_anc_visit_follow_up_date ON cht.mv_anc_visit_follow_up USING btree (date) TABLESPACE ts_indexes;
CREATE INDEX mv_anc_visit_follow_up_location ON cht.mv_anc_visit_follow_up USING btree (location_lat, location_long) TABLESPACE ts_indexes;
CREATE INDEX mv_anc_visit_follow_up_patient_id ON cht.mv_anc_visit_follow_up USING btree (patient_id) TABLESPACE ts_indexes;
CREATE INDEX mv_anc_visit_follow_up_visited_contact_uuid ON cht.mv_anc_visit_follow_up USING btree (visited_contact_uuid) TABLESPACE ts_indexes;
CREATE INDEX mv_anc_visit_follow_up_inputs_contact_id ON cht.mv_anc_visit_follow_up USING btree (inputs_contact_id) TABLESPACE ts_indexes;
CREATE INDEX mv_anc_visit_follow_up_parent_id ON cht.mv_anc_visit_follow_up USING btree (parent_id) TABLESPACE ts_indexes;


-- -------- mv_assessment  (source: mv_assessment.sql) --------
DROP MATERIALIZED VIEW cht.mv_assessment;
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
    -- HealthPulse / mRDT photo-AI top-level flags (added from latest assessment.xml)
    doc #>> '{fields,launch_healthpulse}'::text[] AS launch_healthpulse,
    doc #>> '{fields,hide_healthpulse_section}'::text[] AS hide_healthpulse_section,
    doc #>> '{fields,show_mrdt_mismatch_note}'::text[] AS show_mrdt_mismatch_note,
    doc #>> '{fields,some_concern}'::text[] AS some_concern,
    doc #>> '{fields,difference_in_results}'::text[] AS difference_in_results,
    doc #>> '{fields,show_malaria_screening_referral}'::text[] AS show_malaria_screening_referral,
    doc #>> '{fields,scanned_test_results}'::text[] AS scanned_test_results,
    doc #>> '{fields,captured_request_id}'::text[] AS captured_request_id,
    doc #>> '{fields,show_health_pulse_failed}'::text[] AS show_health_pulse_failed,
    doc #>> '{fields,is_mrdt_vht}'::text[] AS is_mrdt_vht,
    doc #>> '{fields,is_unblinded_mrdt_vht}'::text[] AS is_unblinded_mrdt_vht,
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
    -- mrdt_repeat group was flattened in the latest form; remapped to group_fever,* (notes dropped)
    doc #>> '{fields,group_fever,mrdt_used_repeat}'::text[] AS g_mrdt_used_repeat,
    doc #>> '{fields,group_fever,mrdt_result_repeat}'::text[] AS g_mrdt_result_repeat,
    doc #>> '{fields,group_fever,why_mrdt_not_done_repeat}'::text[] AS g_why_mrdt_not_done_repeat,
    doc #>> '{fields,group_fever,has_mrdt_repeat_question}'::text[] AS g_has_mrdt_repeat_question,
    doc #>> '{fields,group_fever,mrdt_used_repeat_question}'::text[] AS g_mrdt_used_repeat_question,
    doc #>> '{fields,group_fever,mrdt_result_repeat_question}'::text[] AS g_mrdt_result_repeat_question,
    doc #>> '{fields,group_fever,why_mrdt_not_done_repeat_question}'::text[] AS g_why_mrdt_not_done_repeat_question,
    doc #>> '{fields,group_fever,refer_to_facililty_invalid_test}'::text[] AS g_refer_to_facililty_invalid_test,
    doc #>> '{fields,group_fever,photo_consent}'::text[] AS g_photo_consent,
    doc #>> '{fields,group_fever,mrdt_lock_state}'::text[] AS g_mrdt_lock_state,
    doc #>> '{fields,group_fever,locked_mrdt_result}'::text[] AS g_locked_mrdt_result,
    doc #>> '{fields,group_fever,want_to_repeat_mrdt}'::text[] AS g_want_to_repeat_mrdt,
    doc #>> '{fields,group_fever,mrdt_result}'::text[] AS g_mrdt_result,
    doc #>> '{fields,group_fever,mrdt_used}'::text[] AS g_mrdt_used,
    doc #>> '{fields,group_fever,why_mrdt_not_done}'::text[] AS g_why_mrdt_not_done,
    doc #>> '{fields,group_fever,note_mrdt_positive}'::text[] AS g_note_mrdt_positive,
    doc #>> '{fields,group_fever,fever_danger_sign}'::text[] AS g_fever_danger_sign,
    -- malaria_screening: new HealthPulse mRDT photo-AI workflow (app config plumbing intentionally excluded)
    doc #>> '{fields,malaria_screening,health_pulse_section,vht_photo}'::text[] AS ms_vht_photo,
    doc #>> '{fields,malaria_screening,health_pulse_section,rdt_app,rdt_app_outputs,resultsBundle,requestId}'::text[] AS ms_rdt_out_request_id,
    doc #>> '{fields,malaria_screening,health_pulse_section,rdt_app,rdt_app_outputs,resultsBundle,capturedImageUri}'::text[] AS ms_rdt_out_captured_image_uri,
    doc #>> '{fields,malaria_screening,health_pulse_section,rdt_app,rdt_app_outputs,resultsBundle,sampleImage}'::text[] AS ms_rdt_out_sample_image,
    doc #>> '{fields,malaria_screening,health_pulse_section,rdt_app,rdt_app_outputs,resultsBundle,globalConcerns}'::text[] AS ms_rdt_out_global_concerns,
    doc #>> '{fields,malaria_screening,health_pulse_section,rdt_app,rdt_app_outputs,resultsBundle,detectedRdt,concerns}'::text[] AS ms_rdt_out_detected_concerns,
    doc #>> '{fields,malaria_screening,health_pulse_section,rdt_app,rdt_app_outputs,resultsBundle,detectedRdt,classification}'::text[] AS ms_rdt_out_detected_classification,
    doc #>> '{fields,malaria_screening,health_pulse_section,out_request_id}'::text[] AS ms_out_request_id,
    doc #>> '{fields,malaria_screening,health_pulse_section,out_sample_image}'::text[] AS ms_out_sample_image,
    doc #>> '{fields,malaria_screening,health_pulse_section,out_classification}'::text[] AS ms_out_classification,
    doc #>> '{fields,malaria_screening,health_pulse_section,out_global_concerns}'::text[] AS ms_out_global_concerns,
    doc #>> '{fields,malaria_screening,health_pulse_section,out_concerns}'::text[] AS ms_out_concerns,
    doc #>> '{fields,malaria_screening,health_pulse_section,lower_classification}'::text[] AS ms_lower_classification,
    doc #>> '{fields,malaria_screening,health_pulse_section,save_photo}'::text[] AS ms_save_photo,
    doc #>> '{fields,malaria_screening,health_pulse_section,mrdt_discordance}'::text[] AS ms_mrdt_discordance,
    doc #>> '{fields,malaria_screening,health_pulse_section,photo_attempt_check}'::text[] AS ms_photo_attempt_check,
    doc #>> '{fields,malaria_screening,health_pulse_section,capture_ux_text}'::text[] AS ms_capture_ux_text,
    doc #>> '{fields,malaria_screening,concernsFlag}'::text[] AS ms_concerns_flag,
    doc #>> '{fields,malaria_screening,storedConcernsFlag}'::text[] AS ms_stored_concerns_flag,
    doc #>> '{fields,malaria_screening,storedClassification}'::text[] AS ms_stored_classification,
    doc #>> '{fields,malaria_screening,storedImageUri}'::text[] AS ms_stored_image_uri,
    doc #>> '{fields,malaria_screening,confirm_child_referral_mrdt_result}'::text[] AS ms_confirm_child_referral_mrdt_result,
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
    -- group_patient_summary treatment/commodity acknowledgements (added from latest assessment.xml)
    doc #>> '{fields,group_patient_summary,cough_prereferral_treatment_given}'::text[] AS cough_prereferral_treatment_given,
    doc #>> '{fields,group_patient_summary,diarrhoea_prereferral_treatment_given}'::text[] AS diarrhoea_prereferral_treatment_given,
    doc #>> '{fields,group_patient_summary,fever_prereferral_treatment_given}'::text[] AS fever_prereferral_treatment_given,
    doc #>> '{fields,group_patient_summary,danger_sign_prereferral_treatment_given}'::text[] AS danger_sign_prereferral_treatment_given,
    doc #>> '{fields,group_patient_summary,cough_treatment_given}'::text[] AS cough_treatment_given,
    doc #>> '{fields,group_patient_summary,diarrhoea_treatment_given}'::text[] AS diarrhoea_treatment_given,
    doc #>> '{fields,group_patient_summary,fever_treatment_given}'::text[] AS fever_treatment_given,
    doc #>> '{fields,group_patient_summary,gloves_used_mrdt}'::text[] AS gloves_used_mrdt,
    doc #>> '{fields,group_patient_summary,test_kits_used_mrdt}'::text[] AS test_kits_used_mrdt,
    doc #>> '{fields,group_patient_summary,gloves_used_rectal}'::text[] AS gloves_used_rectal,
    -- Last column for tracking refresh
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.parish,
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



-- -------- mv_cebs_signal_report_chew  (source: mv_cebs_signal_report_chew.sql) --------
DROP MATERIALIZED VIEW cht.mv_cebs_signal_report_chew;
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
    h.parish,
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


-- -------- mv_cebs_signal_report_vht  (source: mv_cebs_signal_report_vht.sql) --------
DROP MATERIALIZED VIEW cht.mv_cebs_signal_report_vht;
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
    h.parish,
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


-- -------- mv_cebs_signal_verification  (source: mv_cebs_signal_verification.sql) --------
DROP MATERIALIZED VIEW cht.mv_cebs_signal_verification;
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
    h.parish,
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


-- -------- mv_cebs_signal_verification_notification  (source: mv_cebs_signal_verification_notification.sql) --------
DROP MATERIALIZED VIEW cht.mv_cebs_signal_verification_notification;
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
    h.parish,
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


-- -------- mv_child_health_escalation  (source: mv_child_health_escalation.sql) --------
DROP MATERIALIZED VIEW cht.mv_child_health_escalation;
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
      h.parish,
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


-- -------- mv_child_health_notification  (source: mv_child_health_notification.sql) --------
DROP MATERIALIZED VIEW cht.mv_child_health_notification;
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
      h.parish,
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


-- -------- mv_child_nutrition_follow_up  (source: mv_child_nutrition_follow_up.sql) --------
DROP MATERIALIZED VIEW cht.mv_child_nutrition_follow_up;
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
      h.parish,
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


-- -------- mv_child_nutrition_referral_follow_up  (source: mv_child_nutrition_referral_follow_up.sql) --------
DROP MATERIALIZED VIEW cht.mv_child_nutrition_referral_follow_up;
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
      h.parish,
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


-- -------- mv_clinic  (source: mv_clinic.sql) --------
DROP MATERIALIZED VIEW cht.mv_clinic;
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
      h.parish,
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


-- -------- mv_community_death_notification  (source: mv_community_death_notification.sql) --------
DROP MATERIALIZED VIEW cht.mv_community_death_notification;
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
      h.parish,
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


-- -------- mv_copy_of_danger_signs_follow_up_report  (source: mv_copy_of_danger_signs_follow_up_report.sql) --------
DROP MATERIALIZED VIEW cht.mv_copy_of_danger_signs_follow_up_report;
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
      h.parish,
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


-- -------- mv_death_notification  (source: mv_death_notification.sql) --------
DROP MATERIALIZED VIEW cht.mv_death_notification;
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
      h.parish,
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


-- -------- mv_death_report  (source: mv_death_report.sql) --------
DROP MATERIALIZED VIEW cht.mv_death_report;
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
      h.parish,
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


-- -------- mv_delivery_check  (source: mv_delivery_check.sql) --------
DROP MATERIALIZED VIEW cht.mv_delivery_check;
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
      h.parish,
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


-- -------- mv_drowning_workflow  (source: mv_drowning_workflow.sql) --------
DROP MATERIALIZED VIEW cht.mv_drowning_workflow;
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
      h.parish,
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


-- -------- mv_fp_follow_up  (source: mv_fp_follow_up.sql) --------
DROP MATERIALIZED VIEW cht.mv_fp_follow_up;
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
      h.parish,
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


-- -------- mv_fp_referral_follow_up  (source: mv_fp_referral_follow_up.sql) --------
DROP MATERIALIZED VIEW cht.mv_fp_referral_follow_up;
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
      h.parish,
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


-- -------- mv_fp_registration  (source: mv_fp_registration.sql) --------
DROP MATERIALIZED VIEW cht.mv_fp_registration;
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
      h.parish,
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


-- -------- mv_gbv_community_form  (source: mv_gbv_community_form.sql) --------
DROP MATERIALIZED VIEW cht.mv_gbv_community_form;
CREATE MATERIALIZED VIEW cht.mv_gbv_community_form
TABLESPACE ts_report
AS SELECT d.doc ->> '_id'::text AS uuid,
    d.doc ->> 'form'::text AS form,
    d.doc ->> '_rev'::text AS rev,
    to_timestamp((NULLIF(d.doc ->> 'reported_date'::text, ''::text)::bigint / 1000)::double precision) AS reported,
    to_char(to_timestamp((((d.doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'YYYY-MM-DD'::text)::date AS date,
    to_char(to_timestamp((((d.doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'YYYY'::text)::integer AS year,
    to_char(to_timestamp((((d.doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'MM'::text)::integer AS month,
    to_char(to_timestamp((((d.doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'FMMonth'::text) AS monthname,
    ((d.doc -> 'fields'::text) -> 'meta'::text) ->> 'instanceID'::text AS instanceid,
    ((((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) -> 'location'::text) ->> 'lat'::text AS "Location Lat",
    ((((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) -> 'location'::text) ->> 'long'::text AS "Location Long",
    ((((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) -> 'location'::text) ->> 'error'::text AS "Location Error",
    ((((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) -> 'location'::text) ->> 'message'::text AS "Location Message",
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 'source'::text AS "Source",
    ((d.doc -> 'fields'::text) -> 'inputs'::text) ->> 'source_id'::text AS "Source ID",
    (((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'user'::text) ->> 'contact_id'::text AS "User Contact ID",
    (((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'user'::text) ->> 'facility_id'::text AS "User Facility ID",
    (((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> '_id'::text AS "CHEW Area Id",
    (((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> 'name'::text AS "CHEW Area Name",
    ((((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) -> 'contact'::text) ->> '_id'::text AS "CHEW ID",
    ((((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) -> 'contact'::text) ->> 'name'::text AS "CHEW Name",
    ((((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) -> 'contact'::text) ->> 'date_of_birth'::text AS "CHEW Date of Birth",
    ((((d.doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) -> 'contact'::text) ->> 'phone'::text AS "Phone",
    (d.doc -> 'fields'::text) ->> 'chew_name'::text AS "CHEW Name (calculated)",
    (d.doc -> 'fields'::text) ->> 'chew_phone'::text AS "CHEW Phone (calculated)",
    (d.doc -> 'fields'::text) ->> 'place_id'::text AS "ID",
    (d.doc -> 'fields'::text) ->> 'place_name'::text AS "Name",
    (d.doc -> 'fields'::text) ->> 'start_time'::text AS "Time interview starts (system)",
    ((d.doc -> 'fields'::text) -> 'opening'::text) ->> 'note1_1'::text AS "Opening Note 1-1",
    ((d.doc -> 'fields'::text) -> 'opening'::text) ->> 'tool'::text AS "Please select an interview to be conducted",
    ((d.doc -> 'fields'::text) -> 'opening'::text) ->> 'consent'::text AS "Has the respondent agreed to be interviewed?",
    (d.doc -> 'fields'::text) ->> 'tool_label'::text AS "Tool Label (calculated)",
    (d.doc -> 'fields'::text) ->> 'interview_date'::text AS "Interview Date (calculated)",
    (d.doc -> 'fields'::text) ->> 'interviewer'::text AS "Interviewer (calculated)",
    ((d.doc -> 'fields'::text) -> 'lc1_group'::text) ->> 'note1_lc'::text AS "LC1 Note 1-LC",
    ((d.doc -> 'fields'::text) -> 'lc1_group'::text) ->> 'lc1'::text AS "LC1: Aware of physical violence in past 3 months?",
    ((d.doc -> 'fields'::text) -> 'lc1_group'::text) ->> 'lc2'::text AS "LC2: Heard of sexual violence in past 3 months?",
    ((d.doc -> 'fields'::text) -> 'lc1_group'::text) ->> 'lc4'::text AS "LC4: Total cases of violence/child abuse (past 3 months)",
    ((d.doc -> 'fields'::text) -> 'lc1_group'::text) ->> 'lc4_calc'::text AS "LC4 Calculated",
    ((d.doc -> 'fields'::text) -> 'lc1_group'::text) ->> 'lc15'::text AS "LC15: Risky households/locations/circumstances?",
    ((d.doc -> 'fields'::text) -> 'lc1_group'::text) ->> 'lc15b'::text AS "LC15B: Which kind of households?",
    ((d.doc -> 'fields'::text) -> 'lc1_group'::text) ->> 'lc16'::text AS "LC16: How are survivors helped?",
    ((d.doc -> 'fields'::text) -> 'lc1_group'::text) ->> 'lccases_repeat_count'::text AS "LCCases Repeat Count",
    ((d.doc -> 'fields'::text) -> 'hm_group'::text) ->> 'note1_hm'::text AS "HM Note 1-HM",
    ((d.doc -> 'fields'::text) -> 'hm_group'::text) ->> 'hm1'::text AS "HM1: Learners reported sexual touching/force?",
    ((d.doc -> 'fields'::text) -> 'hm_group'::text) ->> 'hm2'::text AS "HM2: How many learners reported?",
    ((d.doc -> 'fields'::text) -> 'hm_group'::text) ->> 'hm2_calc'::text AS "HM2 Calculated",
    ((d.doc -> 'fields'::text) -> 'hm_group'::text) ->> 'hm11'::text AS "HM11: Unsafe places/situations at school?",
    ((d.doc -> 'fields'::text) -> 'hm_group'::text) ->> 'hm12'::text AS "HM12: When/where do concerns occur?",
    ((d.doc -> 'fields'::text) -> 'hm_group'::text) ->> 'hm12oth'::text AS "HM12 Other",
    ((d.doc -> 'fields'::text) -> 'hm_group'::text) ->> 'hm13'::text AS "HM13: Gifts for sexual acts?",
    ((d.doc -> 'fields'::text) -> 'hm_group'::text) ->> 'hm14'::text AS "HM14: Were they linked to care?",
    ((d.doc -> 'fields'::text) -> 'hm_group'::text) ->> 'hm14b'::text AS "HM14B: Where linked?",
    ((d.doc -> 'fields'::text) -> 'hm_group'::text) ->> 'hm14both'::text AS "HM14 Both",
    ((d.doc -> 'fields'::text) -> 'hm_group'::text) ->> 'hm15'::text AS "HM15: Who gives gifts?",
    ((d.doc -> 'fields'::text) -> 'hm_group'::text) ->> 'hm16'::text AS "HM16: Coerced/promised help?",
    ((d.doc -> 'fields'::text) -> 'hm_group'::text) ->> 'hm17'::text AS "HM17: How were they helped?",
    ((d.doc -> 'fields'::text) -> 'hm_group'::text) ->> 'hm17oth'::text AS "HM17 Other",
    ((d.doc -> 'fields'::text) -> 'hm_group'::text) ->> 'schcases_repeat_count'::text AS "School Cases Repeat Count",
    ((d.doc -> 'fields'::text) -> 'hh_group'::text) ->> 'note1_hh'::text AS "HH Note 1-HH",
    ((d.doc -> 'fields'::text) -> 'hh_group'::text) ->> 'hh1'::text AS "HH1: Household member physically/sexually harmed?",
    ((d.doc -> 'fields'::text) -> 'hh_group'::text) ->> 'hh2'::text AS "HH2: Who was harmed (age)?",
    ((d.doc -> 'fields'::text) -> 'hh_group'::text) ->> 'hh3'::text AS "HH3: Who was harmed (sex)?",
    ((d.doc -> 'fields'::text) -> 'hh_group'::text) ->> 'hh4'::text AS "HH4: By who?",
    ((d.doc -> 'fields'::text) -> 'hh_group'::text) ->> 'hh5'::text AS "HH5: Did survivors report/seek help?",
    ((d.doc -> 'fields'::text) -> 'hh_group'::text) ->> 'hh6'::text AS "HH6: Where reported?",
    ((d.doc -> 'fields'::text) -> 'hh_group'::text) ->> 'hh6oth'::text AS "HH6 Other",
    ((d.doc -> 'fields'::text) -> 'hh_group'::text) ->> 'hh7'::text AS "HH7: Report barriers?",
    ((d.doc -> 'fields'::text) -> 'hh_group'::text) ->> 'hh7oth'::text AS "HH7 Other",
    ((d.doc -> 'fields'::text) -> 'hh_group'::text) ->> 'hh9'::text AS "HH9: Need immediate assistance?",
    ((d.doc -> 'fields'::text) -> 'hh_group'::text) ->> 'hh10'::text AS "HH10: Victim has disability?",
    ((d.doc -> 'fields'::text) -> 'hh_group'::text) ->> 'hh10b'::text AS "HH10B: Type of case",
    ((d.doc -> 'fields'::text) -> 'hh_group'::text) ->> 'hh10c'::text AS "HH10C: Intimate-partner violence?",
    ((d.doc -> 'fields'::text) -> 'hh_group'::text) ->> 'hh1note'::text AS "HH1 Note",
    ((d.doc -> 'fields'::text) -> 'pc_group'::text) ->> 'note1_pc'::text AS "PC Note 1-PC",
    ((d.doc -> 'fields'::text) -> 'pc_group'::text) ->> 'pc1'::text AS "PC1: Who was harmed (age)?",
    ((d.doc -> 'fields'::text) -> 'pc_group'::text) ->> 'pc2'::text AS "PC2: Who was harmed (sex)?",
    ((d.doc -> 'fields'::text) -> 'pc_group'::text) ->> 'pc3'::text AS "PC3: By who?",
    ((d.doc -> 'fields'::text) -> 'pc_group'::text) ->> 'pc4'::text AS "PC4: Type of violence?",
    ((d.doc -> 'fields'::text) -> 'pc_group'::text) ->> 'pc5'::text AS "PC5: Where did it happen?",
    ((d.doc -> 'fields'::text) -> 'pc_group'::text) ->> 'pc5oth'::text AS "PC5 Other",
    ((d.doc -> 'fields'::text) -> 'pc_group'::text) ->> 'pc6a'::text AS "PC6A: Case referred?",
    ((d.doc -> 'fields'::text) -> 'pc_group'::text) ->> 'pc6b'::text AS "PC6B: Where referred?",
    ((d.doc -> 'fields'::text) -> 'pc_group'::text) ->> 'pc6both'::text AS "PC6 Both",
    ((d.doc -> 'fields'::text) -> 'pc_group'::text) ->> 'pc7'::text AS "PC7: Victim has disability?",
    ((d.doc -> 'fields'::text) -> 'pc_group'::text) ->> 'pc7b'::text AS "PC7B: Type of case",
    ((d.doc -> 'fields'::text) -> 'pc_group'::text) ->> 'pc7c'::text AS "PC7C: Intimate-partner violence?",
    ((d.doc -> 'fields'::text) -> 'pc_group'::text) ->> 'pc8'::text AS "PC8: Brief description",
    (d.doc -> 'fields'::text) ->> 'consenta'::text AS "If no consent, reason for refusal",
    (d.doc -> 'fields'::text) ->> 'obs'::text AS "Record any helpful observation/comment",
    (d.doc -> 'fields'::text) ->> 'end_time'::text AS "End Time (system)",
    d.doc #>> '{contact,_id}'::text[] AS chw_id,
    h.facility,
    h.village,
    h.parish,
    h.district,
    h.region,
    CURRENT_TIMESTAMP AS last_refresh_date
   FROM dwh.cht_data d
     LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}'::text[]) = h.chw_id
  WHERE (d.doc ->> 'form'::text) = 'gbv_community_form'::text AND d.is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX mv_gbv_community_chw_idx ON cht.mv_gbv_community_form USING btree (chw_id) TABLESPACE ts_indexes;
CREATE INDEX mv_gbv_community_reported_idx ON cht.mv_gbv_community_form USING btree (reported) TABLESPACE ts_indexes;
CREATE INDEX mv_gbv_community_date_idx ON cht.mv_gbv_community_form USING btree (date) TABLESPACE ts_indexes;
CREATE INDEX mv_gbv_community_year_idx ON cht.mv_gbv_community_form USING btree (year) TABLESPACE ts_indexes;
CREATE INDEX mv_gbv_community_month_idx ON cht.mv_gbv_community_form USING btree (month) TABLESPACE ts_indexes;   


-- -------- mv_ha_danger_signs_follow_up  (source: mv_ha_danger_signs_follow_up.sql) --------
DROP MATERIALIZED VIEW cht.mv_ha_danger_signs_follow_up;
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
      h.parish,
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


-- -------- mv_health_education  (source: mv_health_education.sql) --------
DROP MATERIALIZED VIEW cht.mv_health_education;
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
      h.parish,
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


-- -------- mv_household_model_follow_up  (source: mv_household_model_follow_up.sql) --------
DROP MATERIALIZED VIEW cht.mv_household_model_follow_up;
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
      h.parish,
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


-- -------- mv_household_model_notification  (source: mv_household_model_notification.sql) --------
DROP MATERIALIZED VIEW cht.mv_household_model_notification;
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
      h.parish,
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


-- -------- mv_maternal_health_education  (source: mv_maternal_health_education.sql) --------
DROP MATERIALIZED VIEW cht.mv_maternal_health_education;
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
      h.parish,
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


-- -------- mv_maternal_nutrition_follow_up  (source: mv_maternal_nutrition_follow_up.sql) --------
DROP MATERIALIZED VIEW cht.mv_maternal_nutrition_follow_up;
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
      h.parish,
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


-- -------- mv_mute  (source: mv_mute.sql) --------
DROP MATERIALIZED VIEW cht.mv_mute;
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
      h.parish,
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


-- -------- mv_newborn_danger_sign_follow_up  (source: mv_newborn_danger_sign_follow_up.sql) --------
DROP MATERIALIZED VIEW cht.mv_newborn_danger_sign_follow_up;
CREATE MATERIALIZED VIEW cht.mv_newborn_danger_sign_follow_up
TABLESPACE ts_report
AS SELECT doc ->> '_id'::text AS uuid,
    doc ->> '_rev'::text AS rev,
    doc ->> 'form'::text AS form,
    to_timestamp((NULLIF(doc ->> 'reported_date'::text, ''::text)::bigint / 1000)::double precision) AS reported,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY-MM-DD'))::date AS date,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY'))::INT AS year,
    to_char(to_timestamp((((doc ->>'reported_date'::text)::bigint) / 1000)::double precision), 'MM'::text)::integer AS month,
    TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'FMMonth') AS monthname,
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
    doc #>> '{fields,inputs,source}'::text[] AS source,
    doc #>> '{fields,inputs,source_id}'::text[] AS source_id,
    doc #>> '{fields,inputs,t_place_name}'::text[] AS t_place_name,
    doc #>> '{fields,inputs,t_vht_name}'::text[] AS t_vht_name,
    doc #>> '{fields,inputs,t_vht_phone}'::text[] AS t_vht_phone,
    doc #>> '{fields,inputs,user,contact_id}'::text[] AS contact_id,
    doc #>> '{fields,inputs,user,facility_id}'::text[] AS facility_id,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS _id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS name,
    doc #>> '{fields,inputs,contact,date_of_birth}'::text[] AS date_of_birth,
    doc #>> '{fields,inputs,contact,sex}'::text[] AS sex,
    doc #>> '{fields,inputs,contact,parent,_id}'::text[] AS parent__id,
    doc #>> '{fields,inputs,contact,parent,name}'::text[] AS parent_name,
    doc #>> '{fields,inputs,contact,parent,parent,_id}'::text[] AS parent_parent__id,
    doc #>> '{fields,inputs,contact,parent,parent,name}'::text[] AS parent_parent_name,
    doc #>> '{fields,inputs,contact,parent,parent,contact,_id}'::text[] AS contact__id,
    doc #>> '{fields,inputs,contact,parent,parent,contact,name}'::text[] AS contact_name,
    doc #>> '{fields,inputs,contact,parent,parent,contact,phone}'::text[] AS phone,
    doc #>> '{fields,patient_age_in_years}'::text[] AS patient_age_in_years,
    doc #>> '{fields,patient_age_in_months}'::text[] AS patient_age_in_months,
    doc #>> '{fields,patient_age_in_days}'::text[] AS patient_age_in_days,
    doc #>> '{fields,patient_age_display}'::text[] AS patient_age_display,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,patient_name}'::text[] AS patient_name,
    doc #>> '{fields,patient_gender}'::text[] AS patient_gender,
    doc #>> '{fields,chw_name}'::text[] AS chw_name,
    doc #>> '{fields,chw_phone}'::text[] AS chw_phone,
    doc #>> '{fields,chw_village}'::text[] AS chw_village,
    doc #>> '{fields,needs_signoff}'::text[] AS needs_signoff,
    doc #>> '{fields,group_danger_sign_follow_up,taken_to_health_facility}'::text[] AS taken_to_health_facility,
    doc #>> '{fields,group_danger_sign_follow_up,still_experiencing_danger_signs}'::text[] AS still_experiencing_danger_signs,
    doc #>> '{fields,group_danger_sign_follow_up,breathing_difficulty}'::text[] AS breathing_difficulty,
    doc #>> '{fields,group_danger_sign_follow_up,not_breastfeeding_Well}'::text[] AS not_breastfeeding_well,
    doc #>> '{fields,group_danger_sign_follow_up,feels_hot_or_cold}'::text[] AS feels_hot_or_cold,
    doc #>> '{fields,group_danger_sign_follow_up,less_active}'::text[] AS less_active,
    doc #>> '{fields,group_danger_sign_follow_up,yellow_body}'::text[] AS yellow_body,
    doc #>> '{fields,group_danger_sign_follow_up,has_danger_signs}'::text[] AS has_danger_signs,
    doc #>> '{fields,additional_doc,type}'::text[] AS type,
    doc #>> '{fields,additional_doc,content_type}'::text[] AS content_type,
    doc #>> '{fields,additional_doc,form}'::text[] AS form_field,
    doc #>> '{fields,additional_doc,contact,_id}'::text[] AS additional_doc_contact__id,
    doc #>> '{fields,additional_doc,parent,_id}'::text[] AS additional_doc_parent__id,
    doc #>> '{fields,additional_doc,fields,inputs,source}'::text[] AS inputs_source,
    doc #>> '{fields,additional_doc,fields,inputs,source_id}'::text[] AS inputs_source_id,
    doc #>> '{fields,additional_doc,fields,inputs,contact,_id}'::text[] AS inputs_contact__id,
    doc #>> '{fields,additional_doc,fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    doc #>> '{fields,additional_doc,fields,created_by_doc}'::text[] AS created_by_doc,
    doc #>> '{fields,additional_doc,fields,client_id}'::text[] AS client_id,
    doc #>> '{fields,additional_doc,fields,client_uuid}'::text[] AS client_uuid,
    doc #>> '{fields,additional_doc,fields,client_name}'::text[] AS client_name,
    doc #>> '{fields,additional_doc,fields,place_id}'::text[] AS place_id,
    doc #>> '{fields,additional_doc,fields,place_name}'::text[] AS place_name,
    doc #>> '{fields,additional_doc,fields,vht_name}'::text[] AS vht_name,
    doc #>> '{fields,additional_doc,fields,vht_phone}'::text[] AS vht_phone,
    doc #>> '{fields,additional_doc,fields,follow_up_date}'::text[] AS follow_up_date,
    doc #>> '{fields,additional_doc,fields,client_age_in_years}'::text[] AS client_age_in_years,
    doc #>> '{fields,additional_doc,fields,client_age_in_months}'::text[] AS client_age_in_months,
    doc #>> '{fields,additional_doc,fields,client_age_in_days}'::text[] AS client_age_in_days,
    doc #>> '{fields,additional_doc,fields,client_age_display}'::text[] AS client_age_display,
    doc #>> '{fields,additional_doc,fields,client_sex}'::text[] AS client_sex,
    doc #>> '{fields,additional_doc,fields,danger_signs,_breathing_difficulty}'::text[] AS _breathing_difficulty,
    doc #>> '{fields,additional_doc,fields,danger_signs,_not_breastfeeding_Well}'::text[] AS _not_breastfeeding_well,
    doc #>> '{fields,additional_doc,fields,danger_signs,_feels_hot_or_cold}'::text[] AS _feels_hot_or_cold,
    doc #>> '{fields,additional_doc,fields,danger_signs,_less_active}'::text[] AS _less_active,
    doc #>> '{fields,additional_doc,fields,danger_signs,_yellow_body}'::text[] AS _yellow_body,
    doc #>> '{fields,additional_doc_follow_up,type}'::text[] AS additional_doc_follow_up_type,
    doc #>> '{fields,additional_doc_follow_up,content_type}'::text[] AS additional_doc_follow_up_content_type,
    doc #>> '{fields,additional_doc_follow_up,form}'::text[] AS additional_doc_follow_up_form,
    doc #>> '{fields,additional_doc_follow_up,contact,_id}'::text[] AS additional_doc_follow_up_contact__id,
    doc #>> '{fields,additional_doc_follow_up,parent,_id}'::text[] AS additional_doc_follow_up_parent__id,
    doc #>> '{fields,additional_doc_follow_up,fields,inputs,source}'::text[] AS fields_inputs_source,
    doc #>> '{fields,additional_doc_follow_up,fields,inputs,source_id}'::text[] AS fields_inputs_source_id,
    doc #>> '{fields,additional_doc_follow_up,fields,inputs,contact,_id}'::text[] AS fields_inputs_contact__id,
    doc #>> '{fields,additional_doc_follow_up,fields,inputs,contact,name}'::text[] AS fields_inputs_contact_name,
    doc #>> '{fields,additional_doc_follow_up,fields,created_by_doc}'::text[] AS fields_created_by_doc,
    doc #>> '{fields,additional_doc_follow_up,fields,client_id}'::text[] AS fields_client_id,
    doc #>> '{fields,additional_doc_follow_up,fields,client_name}'::text[] AS fields_client_name,
    doc #>> '{fields,additional_doc_follow_up,fields,place_id}'::text[] AS fields_place_id,
    doc #>> '{fields,additional_doc_follow_up,fields,place_name}'::text[] AS fields_place_name,
    doc #>> '{fields,additional_doc_follow_up,fields,vht_name}'::text[] AS fields_vht_name,
    doc #>> '{fields,additional_doc_follow_up,fields,vht_phone}'::text[] AS fields_vht_phone,
    doc #>> '{fields,additional_doc_follow_up,fields,completed_referral}'::text[] AS completed_referral,
    doc #>> '{fields,additional_doc_follow_up,fields,still_has_danger_signs}'::text[] AS still_has_danger_signs,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.parish,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
FROM dwh.cht_data d
LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id 
 WHERE (doc ->> 'form'::text) = 'newborn_danger_sign_follow_up'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX newborn_danger_sign_follow_up_reported_idx ON cht.mv_newborn_danger_sign_follow_up USING btree (reported) tablespace ts_indexes;
CREATE INDEX newborn_danger_sign_follow_up_chw_id_idx ON cht.mv_newborn_danger_sign_follow_up USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX newborn_danger_sign_follow_up_district_idx ON cht.mv_newborn_danger_sign_follow_up USING btree (district) tablespace ts_indexes;
CREATE INDEX newborn_danger_sign_follow_up_facility_id_idx ON cht.mv_newborn_danger_sign_follow_up USING btree (dhis2_facility_id) tablespace ts_indexes;
CREATE INDEX newborn_danger_sign_follow_up_village_idx ON cht.mv_newborn_danger_sign_follow_up USING btree (village) tablespace ts_indexes;
CREATE INDEX newborn_danger_sign_follow_up_region_idx ON cht.mv_newborn_danger_sign_follow_up USING btree (region) tablespace ts_indexes;
CREATE INDEX newborn_danger_sign_follow_up_year_idx ON cht.mv_newborn_danger_sign_follow_up USING btree (year) tablespace ts_indexes;
CREATE INDEX newborn_danger_sign_follow_up_month_idx ON cht.mv_newborn_danger_sign_follow_up USING btree (month) tablespace ts_indexes;
CREATE INDEX newborn_danger_sign_follow_up_patient_id_idx ON cht.mv_newborn_danger_sign_follow_up USING btree (patient_id) tablespace ts_indexes;


-- -------- mv_pnc_baby_follow_up  (source: mv_pnc_baby_follow_up.sql) --------
DROP MATERIALIZED VIEW cht.mv_pnc_baby_follow_up;
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
      h.parish,
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


-- -------- mv_pnc_danger_sign  (source: mv_pnc_danger_sign.sql) --------
DROP MATERIALIZED VIEW cht.mv_pnc_danger_sign;
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
      h.parish,
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


-- -------- mv_pnc_follow_up  (source: mv_pnc_follow_up.sql) --------
DROP MATERIALIZED VIEW cht.mv_pnc_follow_up;
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
      h.parish,
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


-- -------- mv_pregnancy_danger_sign_follow_up  (source: mv_pregnancy_danger_sign_follow_up.sql) --------
DROP MATERIALIZED VIEW cht.mv_pregnancy_danger_sign_follow_up;
CREATE MATERIALIZED VIEW cht.mv_pregnancy_danger_sign_follow_up
TABLESPACE ts_report
AS SELECT doc_id,
    rev_id,
    ((doc -> 'fields'::text) -> 'meta'::text) ->> 'instanceID'::text AS instanceid,
    ((doc -> 'fields'::text) -> 'meta'::text) ->> 'deprecatedID'::text AS deprecatedid,
    (doc -> 'geolocation'::text) ->> 'code'::text AS code,
    (doc -> 'geolocation'::text) ->> 'message'::text AS message,
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
    ((doc -> 'fields'::text) -> 'data'::text) ->> '__fits'::text AS fits,
    ((doc -> 'fields'::text) -> 'data'::text) ->> '__fever'::text AS fever,
    ((doc -> 'fields'::text) -> 'data'::text) ->> '__very_pale'::text AS very_pale,
    ((doc -> 'fields'::text) -> 'data'::text) ->> '__visited_hf'::text AS visited_hf,
    ((doc -> 'fields'::text) -> 'data'::text) ->> '__easily_tired'::text AS easily_tired,
    ((doc -> 'fields'::text) -> 'data'::text) ->> '__breaking_water'::text AS breaking_water,
    ((doc -> 'fields'::text) -> 'data'::text) ->> '__breathlessness'::text AS breathlessness,
    ((doc -> 'fields'::text) -> 'data'::text) ->> '__has_danger_sign'::text AS has_danger_sign,
    ((doc -> 'fields'::text) -> 'data'::text) ->> '__severe_headache'::text AS severe_headache,
    ((doc -> 'fields'::text) -> 'data'::text) ->> '__vaginal_bleeding'::text AS vaginal_bleeding,
    ((doc -> 'fields'::text) -> 'data'::text) ->> '__face_hand_swelling'::text AS face_hand_swelling,
    ((doc -> 'fields'::text) -> 'data'::text) ->> '__severe_abdominal_pain'::text AS severe_abdominal_pain,
    ((doc -> 'fields'::text) -> 'data'::text) ->> '__reduced_or_no_fetal_movements'::text AS reduced_or_no_fetal_movements,
    ((doc -> 'fields'::text) -> 'data'::text) ->> '__still_experiencing_danger_sign'::text AS still_experiencing_danger_sign,
    (((doc -> 'fields'::text) -> 'data'::text) -> 'meta'::text) ->> '__source_id'::text AS source_id,
    ((doc -> 'fields'::text) -> 'inputs'::text) ->> 'source'::text AS source,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> '_id'::text AS inputs_contact_id,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> 'sex'::text AS inputs_contact_sex,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> 'name'::text AS inputs_contact_name,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'parent'::text) ->> '_id'::text AS parent_id,
    ((((((doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) -> 'parent'::text) -> 'parent'::text) -> 'contact'::text) ->> 'phone'::text AS phone,
    ((((((doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) -> 'parent'::text) -> 'parent'::text) -> 'contact'::text) ->> 'chw_name'::text AS chw_name,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> 'patient_id'::text AS patient_id,
    (doc -> 'fields'::text) ->> 'patient_uuid'::text AS patient_uuid,
    (doc -> 'fields'::text) ->> 'pregnancy_uuid_ctx'::text AS pregnancy_uuid_ctx,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> 'date_of_birth'::text AS date_of_birth,
    (doc -> 'fields'::text) ->> 'patient_name'::text AS patient_name,
    (doc -> 'fields'::text) ->> 'patient_short_name'::text AS patient_short_name,
    (doc -> 'fields'::text) ->> 'patient_age_in_years'::text AS patient_age_in_years,
    (doc -> 'fields'::text) ->> 'patient_short_name_start'::text AS patient_short_name_start,
    (doc -> 'fields'::text) ->> 't_danger_signs_referral_follow_up'::text AS t_danger_signs_referral_follow_up,
    (doc -> 'fields'::text) ->> 't_danger_signs_referral_follow_up_date'::text AS t_danger_signs_referral_follow_up_date,
    ((doc -> 'fields'::text) -> 'danger_signs'::text) ->> 'visit_confirm'::text AS visit_confirm,
    (((doc -> 'fields'::text) -> 'danger_signs'::text) -> 'custom_translations'::text) ->> 'custom_woman_label'::text AS custom_woman_label,
    (((doc -> 'fields'::text) -> 'danger_signs'::text) -> 'custom_translations'::text) ->> 'custom_woman_start_label'::text AS custom_woman_start_label,
    (((doc -> 'fields'::text) -> 'danger_signs'::text) -> 'custom_translations'::text) ->> 'custom_woman_label_translator'::text AS custom_woman_label_translator,
    (((doc -> 'fields'::text) -> 'danger_signs'::text) -> 'custom_translations'::text) ->> 'custom_woman_start_label_translator'::text AS custom_woman_start_label_translator,
    ((doc -> 'fields'::text) -> 'danger_signs'::text) ->> 'danger_sign_present'::text AS danger_sign_present,
    ((doc -> 'fields'::text) -> 'danger_signs'::text) ->> 'r_danger_sign_present'::text AS r_danger_sign_present,
    ((doc -> 'fields'::text) -> 'danger_signs'::text) ->> 'congratulate_no_ds_note'::text AS congratulate_no_ds_note,
   doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.parish,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
FROM dwh.cht_data d
LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id
  WHERE type = 'data_record'::text AND (doc ->> 'form'::text) = 'pregnancy_danger_sign_follow_up'::text AND is_current IS TRUE
WITH NO DATA;

CREATE INDEX pregnancy_danger_sign_follow_up_reported_idx ON cht.mv_pregnancy_danger_sign_follow_up USING btree (reported) tablespace ts_indexes;
CREATE INDEX pregnancy_danger_sign_follow_up_date_idx ON cht.mv_pregnancy_danger_sign_follow_up USING btree (date) tablespace ts_indexes;
CREATE INDEX pregnancy_danger_sign_follow_up_monthname_idx ON cht.mv_pregnancy_danger_sign_follow_up USING btree (monthname) tablespace ts_indexes;
CREATE INDEX mv_pregnancy_danger_sign_follow_up_year_month_district ON cht.mv_pregnancy_danger_sign_follow_up USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX pregnancy_danger_sign_follow_up_village_idx ON cht.mv_pregnancy_danger_sign_follow_up USING btree (village) tablespace ts_indexes;
CREATE INDEX pregnancy_danger_sign_follow_up_district_idx ON cht.mv_pregnancy_danger_sign_follow_up USING btree (district) tablespace ts_indexes;
CREATE INDEX pregnancy_danger_sign_follow_up_region_idx ON cht.mv_pregnancy_danger_sign_follow_up USING btree (region) tablespace ts_indexes;


-- -------- mv_referral_follow_up  (source: mv_referral_follow_up.sql) --------
DROP MATERIALIZED VIEW cht.mv_referral_follow_up;
CREATE MATERIALIZED VIEW cht.mv_referral_follow_up
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
    doc #>> '{fields,inputs,follow_up_type}'::text[] AS follow_up_type,
    doc #>> '{fields,inputs,t_place_name}'::text[] AS t_place_name,
    doc #>> '{fields,inputs,t_vht_name}'::text[] AS t_vht_name,
    doc #>> '{fields,inputs,t_vht_phone}'::text[] AS t_vht_phone,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    doc #>> '{fields,inputs,contact,date_of_birth}'::text[] AS inputs_contact_date_of_birth,
    doc #>> '{fields,inputs,contact,sex}'::text[] AS inputs_contact_sex,
    doc #>> '{fields,inputs,contact,parent,_id}'::text[] AS parent_id,
    doc #>> '{fields,inputs,contact,parent,parent,name}'::text[] AS parent_name,
    doc #>> '{fields,inputs,contact,parent,parent,supervisor}'::text[] AS supervisor,
    doc #>> '{fields,inputs,contact,parent,parent,phone}'::text[] AS phone,
    doc #>> '{fields,patient_age_in_years}'::text[] AS patient_age_in_years,
    doc #>> '{fields,patient_age_in_months}'::text[] AS patient_age_in_months,
    doc #>> '{fields,patient_age_in_days}'::text[] AS patient_age_in_days,
    doc #>> '{fields,patient_age_display}'::text[] AS patient_age_display,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,patient_name}'::text[] AS patient_name,
    doc #>> '{fields,patient_gender}'::text[] AS patient_gender,
    doc #>> '{fields,referral_follow_up_again}'::text[] AS referral_follow_up_again,
    doc #>> '{fields,chw_name}'::text[] AS chw_name,
    doc #>> '{fields,chw_phone}'::text[] AS chw_phone,
    doc #>> '{fields,chw_village}'::text[] AS chw_village,
    doc #>> '{fields,needs_signoff}'::text[] AS needs_signoff,
    doc #>> '{fields,group_follow_up,follow_up_date}'::text[] AS follow_up_date,
    doc #>> '{fields,group_follow_up,follow_up_method}'::text[] AS follow_up_method,
    doc #>> '{fields,group_person_condition,patient_condition}'::text[] AS patient_condition,
    doc #>> '{fields,group_referral_information,went_to_health_facility}'::text[] AS went_to_health_facility,
    doc #>> '{fields,group_referral_information,interact_with_healthcare}'::text[] AS interact_with_healthcare,
    doc #>> '{fields,group_referral_information,note_encourage_to_visit_health_facility}'::text[] AS note_encourage_to_visit_health_facility,
    doc #>> '{fields,group_referral_information,hc_visit_date}'::text[] AS hc_visit_date,
    doc #>> '{fields,group_referral_information,hc_attendant}'::text[] AS hc_attendant,
    doc #>> '{fields,group_referral_information,hc_attendant_other}'::text[] AS hc_attendant_other,
    doc #>> '{fields,group_referral_information,hc_name}'::text[] AS hc_name,
    doc #>> '{fields,group_referral_information,action_taken}'::text[] AS action_taken,
    doc #>> '{fields,group_referral_information,instructions_for_vht}'::text[] AS instructions_for_vht,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.parish,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
FROM dwh.cht_data d
LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id
  WHERE (doc ->> 'form'::text) = 'referral_follow_up'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX referral_follow_up_reported_idx ON cht.mv_referral_follow_up USING btree (reported) tablespace ts_indexes;
CREATE INDEX referral_follow_up_date_idx ON cht.mv_referral_follow_up USING btree (date) tablespace ts_indexes;
CREATE INDEX referral_follow_up_monthname_idx ON cht.mv_referral_follow_up USING btree (monthname) tablespace ts_indexes;
CREATE INDEX mv_referral_follow_up_year_month_district ON cht.mv_referral_follow_up USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX referral_follow_up_district_idx ON cht.mv_referral_follow_up USING btree (district) tablespace ts_indexes;
CREATE INDEX referral_follow_up_region_idx ON cht.mv_referral_follow_up USING btree (region) tablespace ts_indexes;
CREATE INDEX referral_follow_up_chw_id_idx ON cht.mv_referral_follow_up USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX referral_follow_up_facility_idx ON cht.mv_referral_follow_up USING btree (facility) tablespace ts_indexes;
CREATE INDEX referral_follow_up_dhis2_facility_id_idx ON cht.mv_referral_follow_up USING btree (dhis2_facility_id) tablespace ts_indexes;
CREATE INDEX referral_follow_up_village_idx ON cht.mv_referral_follow_up USING btree (village) tablespace ts_indexes;
CREATE INDEX referral_follow_up_patient_id_idx ON cht.mv_referral_follow_up USING btree (patient_id) tablespace ts_indexes;


-- -------- mv_sdx_follow_up  (source: mv_sdx_follow_up.sql) --------
DROP MATERIALIZED VIEW cht.mv_sdx_follow_up;
CREATE MATERIALIZED VIEW cht.mv_sdx_follow_up
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
    doc #>> '{fields,inputs,latest_referral_status}'::text[] AS inputs_latest_referral_status,
    doc #>> '{fields,inputs,vht_id}'::text[] AS inputs_vht_id,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    doc #>> '{fields,inputs,contact,date_of_birth}'::text[] AS inputs_contact_date_of_birth,
    doc #>> '{fields,inputs,contact,sex}'::text[] AS inputs_contact_sex,
    doc #>> '{fields,inputs,contact,parent,_id}'::text[] AS inputs_contact_parent_id,
    doc #>> '{fields,inputs,contact,parent,name}'::text[] AS inputs_contact_parent_name,
    doc #>> '{fields,inputs,contact,parent,parent,_id}'::text[] AS inputs_contact_parent_parent_id,
    doc #>> '{fields,inputs,contact,parent,parent,name}'::text[] AS inputs_contact_parent_parent_name,
    doc #>> '{fields,inputs,contact,parent,parent,parent,_id}'::text[] AS inputs_contact_parent_parent_parent_id,
    doc #>> '{fields,inputs,contact,parent,parent,parent,name}'::text[] AS inputs_contact_parent_parent_parent_name,
    doc #>> '{fields,vht_area_id}'::text[] AS vht_area_id,
    doc #>> '{fields,facility_id}'::text[] AS facility_id,
    doc #>> '{fields,patient_age_in_years}'::text[] AS patient_age_in_years,
    doc #>> '{fields,patient_age_in_months}'::text[] AS patient_age_in_months,
    doc #>> '{fields,patient_age_in_days}'::text[] AS patient_age_in_days,
    doc #>> '{fields,patient_age_display}'::text[] AS patient_age_display,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,_child_id}'::text[] AS _child_id,
    doc #>> '{fields,patient_name}'::text[] AS patient_name,
    doc #>> '{fields,patient_gender}'::text[] AS patient_gender,
    doc #>> '{fields,referral_follow_up}'::text[] AS referral_follow_up,
    doc #>> '{fields,trigger_referral_follow_up}'::text[] AS trigger_referral_follow_up,
    doc #>> '{fields,group_danger_signs,did_visit}'::text[] AS ds_did_visit,
    doc #>> '{fields,group_danger_signs,no_visit_reason}'::text[] AS ds_no_visit_reason,
    doc #>> '{fields,group_danger_signs,no_visit_reason_other}'::text[] AS ds_no_visit_reason_other,
    doc #>> '{fields,group_danger_signs,follow_up_date}'::text[] AS ds_follow_up_date,
    doc #>> '{fields,group_danger_signs,follow_up_method}'::text[] AS ds_follow_up_method,
    doc #>> '{fields,group_danger_signs,note_look_for_danger_signs}'::text[] AS ds_note_look_for_danger_signs,
    doc #>> '{fields,group_danger_signs,any_danger_signs}'::text[] AS ds_any_danger_signs,
    doc #>> '{fields,group_danger_signs,note_refer_urgently}'::text[] AS ds_note_refer_urgently,
    doc #>> '{fields,group_danger_signs,child_referred}'::text[] AS ds_child_referred,
    doc #>> '{fields,group_follow_up,how_is_child}'::text[] AS how_is_child,
    doc #>> '{fields,group_follow_up,note_if_better}'::text[] AS note_if_better,
    doc #>> '{fields,group_follow_up,child_referred}'::text[] AS child_referred,
    doc #>> '{fields,group_follow_up,note_refer_to_health_facility}'::text[] AS note_refer_to_health_facility,
    doc #>> '{fields,group_follow_up,note_cured}'::text[] AS note_cured,
    doc #>> '{fields,group_key_health_messages,note_feeding_advice}'::text[] AS note_feeding_advice,
    doc #>> '{fields,group_key_health_messages,note_give_more_liquids}'::text[] AS note_give_more_liquids,
    doc #>> '{fields,group_key_health_messages,note_give_soft_foods}'::text[] AS note_give_soft_foods,
    doc #>> '{fields,group_key_health_messages,note_encourage_child2eat}'::text[] AS note_encourage_child2eat,
    doc #>> '{fields,group_key_health_messages,note_varied_foods}'::text[] AS note_varied_foods,
    doc #>> '{fields,group_discharge_messages,note_discharge_advice}'::text[] AS note_discharge_advice,
    doc #>> '{fields,group_discharge_messages,note_check_treatment_complete}'::text[] AS note_check_treatment_complete,
    doc #>> '{fields,group_discharge_messages,note_remember_follow_ups}'::text[] AS note_remember_follow_ups,
    doc #>> '{fields,group_discharge_messages,note_return_if_danger_signs}'::text[] AS note_return_if_danger_signs,
    doc #>> '{fields,group_watch_danger_signs,note_danger_signs_advice}'::text[] AS note_danger_signs_advice,
    doc #>> '{fields,group_watch_danger_signs,note_convulsions}'::text[] AS note_convulsions,
    doc #>> '{fields,group_watch_danger_signs,note_vomits_everything}'::text[] AS note_vomits_everything,
    doc #>> '{fields,group_watch_danger_signs,note_fast_breathing}'::text[] AS note_fast_breathing,
    doc #>> '{fields,group_watch_danger_signs,note_very_sleepy}'::text[] AS note_very_sleepy,
    doc #>> '{fields,group_watch_danger_signs,note_yellow_eyes_palms}'::text[] AS note_yellow_eyes_palms,
    doc #>> '{fields,group_watch_danger_signs,note_chest_indrawing}'::text[] AS note_chest_indrawing,
    doc #>> '{fields,group_watch_danger_signs,note_unable_to_drink_breastfeed}'::text[] AS note_unable_to_drink_breastfeed,
    doc #>> '{fields,group_watch_danger_signs,note_cough}'::text[] AS note_cough,
    doc #>> '{fields,group_watch_danger_signs,note_infected_umbilical_chord}'::text[] AS note_infected_umbilical_chord,
    doc #>> '{fields,group_watch_danger_signs,note_low_temperature}'::text[] AS note_low_temperature,
    doc #>> '{fields,group_watch_danger_signs,note_fever_more_than7days}'::text[] AS note_fever_more_than7days,
    doc #>> '{fields,group_watch_danger_signs,note_muac_red_yellow}'::text[] AS note_muac_red_yellow,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.parish,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
FROM dwh.cht_data d
LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id
  WHERE (doc ->> 'form'::text) = 'sdx_follow_up'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX mv_sdx_follow_up_chw_id ON cht.mv_sdx_follow_up USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX mv_sdx_follow_up_reported ON cht.mv_sdx_follow_up USING btree (reported) tablespace ts_indexes;
CREATE INDEX mv_sdx_follow_up_date ON cht.mv_sdx_follow_up USING btree (date) tablespace ts_indexes;
CREATE INDEX mv_sdx_follow_up_monthname ON cht.mv_sdx_follow_up USING btree (monthname) tablespace ts_indexes;
CREATE INDEX mv_sdx_follow_up_year_month_district ON cht.mv_sdx_follow_up USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX mv_sdx_follow_up_district ON cht.mv_sdx_follow_up USING btree (district) tablespace ts_indexes;
CREATE INDEX mv_sdx_follow_up_region ON cht.mv_sdx_follow_up USING btree (region) tablespace ts_indexes;
CREATE INDEX mv_sdx_follow_up_facility ON cht.mv_sdx_follow_up USING btree (facility) tablespace ts_indexes;
CREATE INDEX mv_sdx_follow_up_dhis2_facility_id ON cht.mv_sdx_follow_up USING btree (dhis2_facility_id) tablespace ts_indexes;
CREATE INDEX mv_sdx_follow_up_village ON cht.mv_sdx_follow_up USING btree (village) tablespace ts_indexes;


-- -------- mv_sdx_notify  (source: mv_sdx_notify.sql) --------
DROP MATERIALIZED VIEW cht.mv_sdx_notify;
CREATE MATERIALIZED VIEW cht.mv_sdx_notify
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
    doc #>> '{fields,inputs,source}'::text[] AS source,
    doc #>> '{fields,inputs,source_id}'::text[] AS source_id,
    doc #>> '{fields,inputs,vht_id}'::text[] AS vht_id,
    doc #>> '{fields,inputs,vht_name}'::text[] AS vht_name,
    doc #>> '{fields,inputs,child_name}'::text[] AS child_name,
    doc #>> '{fields,inputs,hoh_name}'::text[] AS hoh_name,
    doc #>> '{fields,inputs,hoh_phone}'::text[] AS hoh_phone,
    doc #>> '{fields,inputs,child_dob}'::text[] AS child_dob,
    doc #>> '{fields,inputs,child_age}'::text[] AS child_age,
    doc #>> '{fields,inputs,child_sex}'::text[] AS child_sex,
    doc #>> '{fields,inputs,location}'::text[] AS location,
    doc #>> '{fields,inputs,risk_cat}'::text[] AS risk_cat,
    doc #>> '{fields,inputs,num_followups}'::text[] AS num_followups,
    doc #>> '{fields,inputs,discharge_facility}'::text[] AS discharge_facility,
    doc #>> '{fields,inputs,discharge_ts}'::text[] AS discharge_ts,
    doc #>> '{fields,inputs,fu_date_1}'::text[] AS fu_date_1,
    doc #>> '{fields,inputs,fu_date_2}'::text[] AS fu_date_2,
    doc #>> '{fields,inputs,fu_date_3}'::text[] AS fu_date_3,
    doc #>> '{fields,inputs,diagnosis}'::text[] AS diagnosis,
    doc #>> '{fields,inputs,sdx_id}'::text[] AS sdx_id,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS contact_id,
    doc #>> '{fields,inputs,contact,patient_id}'::text[] AS contact_patient_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS contact_name,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,patient_name}'::text[] AS patient_name,
    doc #>> '{fields,notification,header}'::text[] AS n_header,
    doc #>> '{fields,notification,intro}'::text[] AS n_intro,
    doc #>> '{fields,notification,name}'::text[] AS n_name,
    doc #>> '{fields,notification,_id}'::text[] AS n_id,
    doc #>> '{fields,notification,info_header}'::text[] AS n_info_header,
    doc #>> '{fields,notification,info_name}'::text[] AS n_info_name,
    doc #>> '{fields,notification,info_dob}'::text[] AS n_info_dob,
    doc #>> '{fields,notification,info_location}'::text[] AS n_info_location,
    doc #>> '{fields,notification,info_hoh_name}'::text[] AS n_info_hoh_name,
    doc #>> '{fields,notification,info_hoh_phone}'::text[] AS n_info_hoh_phone,
    doc #>> '{fields,notification,info_disch_fac}'::text[] AS n_info_disch_fac,
    doc #>> '{fields,notification,info_diagnosis}'::text[] AS n_info_diagnosis,
    doc #>> '{fields,notification,info_fu_date_1}'::text[] AS n_info_fu_date_1,
    doc #>> '{fields,notification,info_fu_date_2}'::text[] AS n_info_fu_date_2,
    doc #>> '{fields,notification,info_fu_date_3}'::text[] AS n_info_fu_date_3,
    doc #>> '{fields,notification,info_sdx_id}'::text[] AS n_info_sdx_id,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.parish,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
FROM dwh.cht_data d
LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id
  WHERE (doc ->> 'form'::text) = 'sdx_notify'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX mv_sdx_notify_chw_id ON cht.mv_sdx_notify USING btree (chw_id) TABLESPACE ts_indexes;
CREATE INDEX mv_sdx_notify_reported ON cht.mv_sdx_notify USING btree (reported) TABLESPACE ts_indexes;
CREATE INDEX mv_sdx_notify_date ON cht.mv_sdx_notify USING btree (date) TABLESPACE ts_indexes;
CREATE INDEX mv_sdx_notify_monthname ON cht.mv_sdx_notify USING btree (monthname) TABLESPACE ts_indexes;
CREATE INDEX mv_sdx_notify_year_month_district ON cht.mv_sdx_notify USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX mv_sdx_notify_district ON cht.mv_sdx_notify USING btree (district) TABLESPACE ts_indexes;
CREATE INDEX mv_sdx_notify_region ON cht.mv_sdx_notify USING btree (region) TABLESPACE ts_indexes;
CREATE INDEX mv_sdx_notify_village ON cht.mv_sdx_notify USING btree (village) TABLESPACE ts_indexes;
CREATE INDEX mv_sdx_notify_facility ON cht.mv_sdx_notify USING btree (facility) TABLESPACE ts_indexes;
CREATE INDEX mv_sdx_notify_dhis2_facility_id ON cht.mv_sdx_notify USING btree (dhis2_facility_id) TABLESPACE ts_indexes;


-- -------- mv_sdx_trigger  (source: mv_sdx_trigger.sql) --------
DROP MATERIALIZED VIEW cht.mv_sdx_trigger;
CREATE MATERIALIZED VIEW cht.mv_sdx_trigger
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
    doc #>> '{fields,inputs,contact,vht_id}'::text[] AS inputs_contact_vht_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,patient_name}'::text[] AS patient_name,
    doc #>> '{fields,child_name}'::text[] AS child_name,
    doc #>> '{fields,hoh_name}'::text[] AS hoh_name,
    doc #>> '{fields,hoh_phone}'::text[] AS hoh_phone,
    doc #>> '{fields,child_age}'::text[] AS child_age,
    doc #>> '{fields,child_dob}'::text[] AS child_dob,
    doc #>> '{fields,child_sex}'::text[] AS child_sex,
    doc #>> '{fields,location}'::text[] AS location,
    doc #>> '{fields,risk_cat}'::text[] AS risk_cat,
    doc #>> '{fields,num_followups}'::text[] AS num_followups,
    doc #>> '{fields,discharge_facility}'::text[] AS discharge_facility,
    doc #>> '{fields,discharge_ts}'::text[] AS discharge_ts,
    doc #>> '{fields,fu_date_1}'::text[] AS fu_date_1,
    doc #>> '{fields,fu_date_2}'::text[] AS fu_date_2,
    doc #>> '{fields,fu_date_3}'::text[] AS fu_date_3,
    doc #>> '{fields,diagnosis}'::text[] AS diagnosis,
    doc #>> '{fields,sdx_id}'::text[] AS sdx_id,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.parish,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
FROM dwh.cht_data d
LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id 
  WHERE (doc ->> 'form'::text) = 'sdx_trigger'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX mv_sdx_trigger_chw_id ON cht.mv_sdx_trigger USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX mv_sdx_trigger_reported ON cht.mv_sdx_trigger USING btree (reported) tablespace ts_indexes;
CREATE INDEX mv_sdx_trigger_date ON cht.mv_sdx_trigger USING btree (date) tablespace ts_indexes;
CREATE INDEX mv_sdx_trigger_monthname ON cht.mv_sdx_trigger USING btree (monthname) tablespace ts_indexes;
CREATE INDEX mv_sdx_trigger_year_month_district ON cht.mv_sdx_trigger USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX mv_sdx_trigger_district ON cht.mv_sdx_trigger USING btree (district) tablespace ts_indexes;
CREATE INDEX mv_sdx_trigger_region ON cht.mv_sdx_trigger USING btree (region) tablespace ts_indexes;
CREATE INDEX mv_sdx_trigger_village ON cht.mv_sdx_trigger USING btree (village) tablespace ts_indexes;
CREATE INDEX mv_sdx_trigger_facility ON cht.mv_sdx_trigger USING btree (facility) tablespace ts_indexes;
CREATE INDEX mv_sdx_trigger_dhis2_facility_id ON cht.mv_sdx_trigger USING btree (dhis2_facility_id) tablespace ts_indexes;


-- -------- mv_sputum_collection  (source: mv_sputum_collection.sql) --------
DROP MATERIALIZED VIEW cht.mv_sputum_collection;
CREATE MATERIALIZED VIEW cht.mv_sputum_collection
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
    doc #>> '{fields,inputs,source}'::text[] AS n_source,
    doc #>> '{fields,inputs,source_id}'::text[] AS n_source_id,
    doc #>> '{fields,inputs,t_barcode_scanner_result}'::text[] AS n_t_barcode_scanner_result,
    doc #>> '{fields,inputs,t_results_phone_number}'::text[] AS n_t_results_phone_number,
    doc #>> '{fields,inputs,t_cough}'::text[] AS n_t_cough,
    doc #>> '{fields,inputs,t_fever}'::text[] AS n_t_fever,
    doc #>> '{fields,inputs,t_weight_loss}'::text[] AS n_t_weight_loss,
    doc #>> '{fields,inputs,t_excessive_night_sweat}'::text[] AS n_t_excessive_night_sweat,
    doc #>> '{fields,inputs,t_poor_weight_gain}'::text[] AS n_t_poor_weight_gain,
    doc #>> '{fields,inputs,t_is_on_tb_treatment}'::text[] AS n_t_is_on_tb_treatment,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS n_contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS n_contact_name,
    doc #>> '{fields,inputs,contact,date_of_birth}'::text[] AS n_contact_date_of_birth,
    doc #>> '{fields,inputs,contact,sex}'::text[] AS n_contact_sex,
    doc #>> '{fields,inputs,contact,national_identification_number}'::text[] AS n_contact_national_identification_number,
    doc #>> '{fields,inputs,contact,client_category}'::text[] AS n_contact_client_category,
    doc #>> '{fields,inputs,contact,parent,_id}'::text[] AS n_contact_parent_id,
    doc #>> '{fields,patient_age_in_years}'::text[] AS patient_age_in_years,
    doc #>> '{fields,patient_age_in_months}'::text[] AS patient_age_in_months,
    doc #>> '{fields,patient_age_in_days}'::text[] AS patient_age_in_days,
    doc #>> '{fields,patient_age_display}'::text[] AS patient_age_display,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,patient_name}'::text[] AS patient_name,
    doc #>> '{fields,patient_gender}'::text[] AS patient_gender,
    doc #>> '{fields,patient_pronoun}'::text[] AS patient_pronoun,
    doc #>> '{fields,barcode_scanner_result}'::text[] AS barcode_scanner_result,
    doc #>> '{fields,cough}'::text[] AS cough,
    doc #>> '{fields,fever}'::text[] AS fever,
    doc #>> '{fields,weight_loss}'::text[] AS weight_loss,
    doc #>> '{fields,excessive_night_sweat}'::text[] AS excessive_night_sweat,
    doc #>> '{fields,poor_weight_gain}'::text[] AS poor_weight_gain,
    doc #>> '{fields,is_on_tb_treatment}'::text[] AS is_on_tb_treatment,
    doc #>> '{fields,national_identification_number}'::text[] AS national_identification_number,
    doc #>> '{fields,client_category}'::text[] AS client_category,
    doc #>> '{fields,patient_sputum_collection_date}'::text[] AS p_sputum_collection_date,
    doc #>> '{fields,sputum_collection,is_patient_available}'::text[] AS is_patient_available,
    doc #>> '{fields,sputum_collection,patient_availability_date}'::text[] AS patient_availability_date,
    doc #>> '{fields,sputum_collection,has_produced_sputum}'::text[] AS has_produced_sputum,
    doc #>> '{fields,sputum_collection,confirm_bottle_is_tightly_closed}'::text[] AS confirm_bottle_is_tightly_closed,
    doc #>> '{fields,sputum_collection,confirm_send_sample_for_testing}'::text[] AS confirm_send_sample_for_testing,
    doc #>> '{fields,sputum_collection,inform_on_importance_of_testing}'::text[] AS inform_on_importance_of_testing,
    doc #>> '{fields,sputum_collection_consent,results_phone_number}'::text[] AS consent_results_phone_number,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.parish,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
FROM dwh.cht_data d
LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id
  WHERE (doc ->> 'form'::text) = 'sputum_collection'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX mv_sputum_collection_chw_id ON cht.mv_sputum_collection USING btree (chw_id) Tablespace ts_indexes;
CREATE INDEX mv_sputum_collection_reported ON cht.mv_sputum_collection USING btree (reported) Tablespace ts_indexes;
CREATE INDEX mv_sputum_collection_date ON cht.mv_sputum_collection USING btree (date) Tablespace ts_indexes;
CREATE INDEX mv_sputum_collection_monthname ON cht.mv_sputum_collection USING btree (monthname) Tablespace ts_indexes;
CREATE INDEX mv_sputum_collection_year_month_district ON cht.mv_sputum_collection USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX mv_sputum_collection_district ON cht.mv_sputum_collection USING btree (district) Tablespace ts_indexes;
CREATE INDEX mv_sputum_collection_region ON cht.mv_sputum_collection USING btree (region) Tablespace ts_indexes;
CREATE INDEX mv_sputum_collection_facility ON cht.mv_sputum_collection USING btree (facility) Tablespace ts_indexes;
CREATE INDEX mv_sputum_collection_dhis2_facility_id ON cht.mv_sputum_collection USING btree (dhis2_facility_id) Tablespace ts_indexes;
CREATE INDEX mv_sputum_collection_village ON cht.mv_sputum_collection USING btree (village) Tablespace ts_indexes;


-- -------- mv_sputum_collection_refusal  (source: mv_sputum_collection_refusal.sql) --------
DROP MATERIALIZED VIEW cht.mv_sputum_collection_refusal;
CREATE MATERIALIZED VIEW cht.mv_sputum_collection_refusal
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
    doc #>> '{fields,inputs,source}'::text[] AS source,
    doc #>> '{fields,inputs,source_id}'::text[] AS source_id,
    doc #>> '{fields,inputs,t_place_name}'::text[] AS t_place_name,
    doc #>> '{fields,inputs,t_patient_name}'::text[] AS t_patient_name,
    doc #>> '{fields,inputs,t_patient_gender}'::text[] AS t_patient_gender,
    doc #>> '{fields,inputs,t_patient_phone}'::text[] AS t_patient_phone,
    doc #>> '{fields,inputs,t_patient_age_in_years}'::text[] AS t_patient_age_in_years,
    doc #>> '{fields,inputs,t_patient_id}'::text[] AS t_patient_id,
    doc #>> '{fields,inputs,t_cough}'::text[] AS t_cough,
    doc #>> '{fields,inputs,t_fever}'::text[] AS t_fever,
    doc #>> '{fields,inputs,t_weight_loss}'::text[] AS t_weight_loss,
    doc #>> '{fields,inputs,t_excessive_night_sweat}'::text[] AS t_excessive_night_sweat,
    doc #>> '{fields,inputs,t_poor_weight_gain}'::text[] AS t_poor_weight_gain,
    doc #>> '{fields,inputs,t_is_on_tb_treatment}'::text[] AS t_is_on_tb_treatment,
    doc #>> '{fields,inputs,t_client_category}'::text[] AS t_client_category,
    doc #>> '{fields,inputs,t_patient_age_display}'::text[] AS t_patient_age_display,
    doc #>> '{fields,inputs,t_patient_age_in_days}'::text[] AS t_patient_age_in_days,
    doc #>> '{fields,inputs,t_patient_age_in_months}'::text[] AS t_patient_age_in_months,
    doc #>> '{fields,inputs,t_chw_area_id}'::text[] AS t_chw_area_id,
    doc #>> '{fields,inputs,t_chw_area_name}'::text[] AS t_chw_area_name,
    doc #>> '{fields,inputs,t_chw_name}'::text[] AS t_chw_name,
    doc #>> '{fields,inputs,t_national_identification_number}'::text[] AS t_national_identification_number,
    doc #>> '{fields,inputs,t_chw_id}'::text[] AS t_chw_id,
    doc #>> '{fields,inputs,t_chw_phone}'::text[] AS t_chw_phone,
    doc #>> '{fields,inputs,user,contact_id}'::text[] AS user_contact_id,
    doc #>> '{fields,inputs,user,facility_id}'::text[] AS user_facility_id,
    doc #>> '{fields,patient_age_in_years}'::text[] AS patient_age_in_years,
    doc #>> '{fields,patient_age_in_months}'::text[] AS patient_age_in_months,
    doc #>> '{fields,patient_age_in_days}'::text[] AS patient_age_in_days,
    doc #>> '{fields,patient_age_display}'::text[] AS patient_age_display,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,patient_name}'::text[] AS patient_name,
    doc #>> '{fields,patient_pronoun}'::text[] AS patient_pronoun,
    doc #>> '{fields,patient_gender}'::text[] AS patient_gender,
    doc #>> '{fields,patient_possessive_pronoun}'::text[] AS patient_possessive_pronoun,
    doc #>> '{fields,patient_gender_pronoun}'::text[] AS patient_gender_pronoun,
    doc #>> '{fields,patient_phone}'::text[] AS patient_phone,
    doc #>> '{fields,place_id}'::text[] AS place_id,
    doc #>> '{fields,place_name}'::text[] AS place_name,
    doc #>> '{fields,cough}'::text[] AS cough,
    doc #>> '{fields,fever}'::text[] AS fever,
    doc #>> '{fields,weight_loss}'::text[] AS weight_loss,
    doc #>> '{fields,excessive_night_sweat}'::text[] AS excessive_night_sweat,
    doc #>> '{fields,poor_weight_gain}'::text[] AS poor_weight_gain,
    doc #>> '{fields,is_on_tb_treatment}'::text[] AS is_on_tb_treatment,
    doc #>> '{fields,client_category}'::text[] AS client_category,
    doc #>> '{fields,national_identification_number}'::text[] AS national_identification_number,
    doc #>> '{fields,barcode_scanner_result}'::text[] AS barcode_scanner_result,
    doc #>> '{fields,needs_signoff}'::text[] AS needs_signoff,
    doc #>> '{fields,sputum_collection_refusal,note_to_ha}'::text[] AS note_to_ha,
    doc #>> '{fields,sputum_collection_consent,consented_sputum_sample}'::text[] AS consented_sputum_sample,
    doc #>> '{fields,sputum_collection_consent,inform_tb_focal_person}'::text[] AS inform_tb_focal_person,
    doc #>> '{fields,sputum_collection_consent,registered_phone_number}'::text[] AS registered_phone_number,
    doc #>> '{fields,sputum_collection_consent,receive_results_on_same_phonenumber}'::text[] AS receive_results_on_same_phonenumber,
    doc #>> '{fields,sputum_collection_consent,enter_new_phone_number}'::text[] AS enter_new_phone_number,
    doc #>> '{fields,sputum_collection_consent,no_registered_phone_number}'::text[] AS no_registered_phone_number,
    doc #>> '{fields,sputum_collection_consent,phonenumber_to_receive_results}'::text[] AS phonenumber_to_receive_results,
    doc #>> '{fields,sputum_collection_consent,results_phone_number}'::text[] AS results_phone_number,
    doc #>> '{fields,group_barcode,action}'::text[] AS group_barcode_action,
    doc #>> '{fields,group_barcode,tap_barcode_scanner}'::text[] AS barcode_tap_barcode_scanner,
    doc #>> '{fields,group_barcode,outputs,CHT_BARCODE}'::text[] AS barcode_outputs_cht_barcode,
    doc #>> '{fields,sputum_collection,give_patient_instructions}'::text[] AS give_patient_instructions,
    doc #>> '{fields,sputum_collection,has_patient_produced_sputum}'::text[] AS has_patient_produced_sputum,
    doc #>> '{fields,sputum_collection,confirm_container_tightly_closed}'::text[] AS confirm_container_tightly_closed,
    doc #>> '{fields,sputum_collection,confirm_send_sample_for_testing}'::text[] AS confirm_send_sample_for_testing,
    doc #>> '{fields,sputum_collection,leave_sputum_bottle_with_client}'::text[] AS leave_sputum_bottle_with_client,
    doc #>> '{fields,sputum_collection,keep_container_closed}'::text[] AS keep_container_closed,
    doc #>> '{fields,sputum_collection,has_left_sputum_bottle_with_client}'::text[] AS has_left_sputum_bottle_with_client,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.parish,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
FROM dwh.cht_data d
LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id
  WHERE (doc ->> 'form'::text) = 'sputum_collection_refusal'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX mv_sputum_collection_refusal_chw_id ON cht.mv_sputum_collection_refusal USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX mv_sputum_collection_refusal_reported ON cht.mv_sputum_collection_refusal USING btree (reported) tablespace ts_indexes;
CREATE INDEX mv_sputum_collection_refusal_date ON cht.mv_sputum_collection_refusal USING btree (date) tablespace ts_indexes;
CREATE INDEX mv_sputum_collection_refusal_monthname ON cht.mv_sputum_collection_refusal USING btree (monthname) tablespace ts_indexes;
CREATE INDEX mv_sputum_collection_refusal_year_month_district ON cht.mv_sputum_collection_refusal USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX mv_sputum_collection_refusal_district ON cht.mv_sputum_collection_refusal USING btree (district) tablespace ts_indexes;
CREATE INDEX mv_sputum_collection_refusal_region ON cht.mv_sputum_collection_refusal USING btree (region) tablespace ts_indexes;
CREATE INDEX mv_sputum_collection_refusal_facility ON cht.mv_sputum_collection_refusal USING btree (facility) tablespace ts_indexes;
CREATE INDEX mv_sputum_collection_refusal_dhis2_facility_id ON cht.mv_sputum_collection_refusal USING btree (dhis2_facility_id) tablespace ts_indexes;
CREATE INDEX mv_sputum_collection_refusal_village ON cht.mv_sputum_collection_refusal USING btree (village) tablespace ts_indexes;


-- -------- mv_stock_count  (source: mv_stock_count.sql) --------
DROP MATERIALIZED VIEW cht.mv_stock_count;
CREATE MATERIALIZED VIEW cht.mv_stock_count
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
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,act_item_received}'::text[] AS act_item_received,
    doc #>> '{fields,zinc_item_received}'::text[] AS zinc_item_received,
    doc #>> '{fields,amoxicillin_item_received}'::text[] AS amoxicillin_item_received,
    doc #>> '{fields,malaria_rdts_item_received}'::text[] AS malaria_rdts_item_received,
    doc #>> '{fields,pop_item_received}'::text[] AS pop_item_received,
    doc #>> '{fields,dmpa_item_received}'::text[] AS dmpa_item_received,
    doc #>> '{fields,misoprostol_item_received}'::text[] AS misoprostol_item_received,
    doc #>> '{fields,coc_item_received}'::text[] AS coc_item_received,
    doc #>> '{fields,condoms_item_received}'::text[] AS condoms_item_received,
    doc #>> '{fields,contraceptives_item_received}'::text[] AS contraceptives_item_received,
    doc #>> '{fields,rectal_item_received}'::text[] AS rectal_item_received,
    doc #>> '{fields,sayana_item_received}'::text[] AS sayana_item_received,
    doc #>> '{fields,gloves_item_received}'::text[] AS gloves_item_received,
    doc #>> '{fields,is_mch_instance}'::text[] AS is_mch_instance,
    doc #>> '{fields,items,commodities_note}'::text[] AS commodities_note,
    doc #>> '{fields,items,act}'::text[] AS act,
    doc #>> '{fields,items,malaria_rdts}'::text[] AS malaria_rdts,
    doc #>> '{fields,items,rectal}'::text[] AS rectal,
    doc #>> '{fields,items,gloves}'::text[] AS gloves,
    doc #>> '{fields,items,zinc}'::text[] AS zinc,
    doc #>> '{fields,items,amoxicillin}'::text[] AS amoxicillin,
    doc #>> '{fields,items,pop}'::text[] AS pop,
    doc #>> '{fields,items,coc}'::text[] AS coc,
    doc #>> '{fields,items,contraceptives}'::text[] AS contraceptives,
    doc #>> '{fields,items,dmpa}'::text[] AS dmpa,
    doc #>> '{fields,items,condoms}'::text[] AS condoms,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.parish,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
FROM dwh.cht_data d LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id 
  WHERE (doc ->> 'form'::text) = 'stock_count'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX mv_stock_count_reported_idx ON cht.mv_stock_count USING btree (reported) tablespace ts_indexes;
CREATE INDEX mv_stock_count_date_idx ON cht.mv_stock_count USING btree (date) tablespace ts_indexes;
CREATE INDEX mv_stock_count_monthname_idx ON cht.mv_stock_count USING btree (monthname) tablespace ts_indexes;
CREATE INDEX mv_stock_count_year_month_district ON cht.mv_stock_count USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX mv_stock_count_chw_id_idx ON cht.mv_stock_count USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX mv_stock_count_facility_idx ON cht.mv_stock_count USING btree (facility) tablespace ts_indexes;
CREATE INDEX mv_stock_count_dhis2_facility_id_idx ON cht.mv_stock_count USING btree (dhis2_facility_id) tablespace ts_indexes;
CREATE INDEX mv_stock_count_village_idx ON cht.mv_stock_count USING btree (village) tablespace ts_indexes;
CREATE INDEX mv_stock_count_district_idx ON cht.mv_stock_count USING btree (district) tablespace ts_indexes;
CREATE INDEX mv_stock_count_region_idx ON cht.mv_stock_count USING btree (region) tablespace ts_indexes;


-- -------- mv_stockout  (source: mv_stockout.sql) --------
DROP MATERIALIZED VIEW cht.mv_stockout;
CREATE MATERIALIZED VIEW cht.mv_stockout
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
    doc #>> '{fields,inputs,act_stock_value}'::text[] AS act_stock_value,
    doc #>> '{fields,inputs,gloves_stock_value}'::text[] AS gloves_stock_value,
    doc #>> '{fields,inputs,zinc_stock_value}'::text[] AS zinc_stock_value,
    doc #>> '{fields,inputs,amoxicillin_stock_value}'::text[] AS amoxicillin_stock_value,
    doc #>> '{fields,inputs,malaria_rdts_stock_value}'::text[] AS malaria_rdts_stock_value,
    doc #>> '{fields,inputs,pop_stock_value}'::text[] AS pop_stock_value,
    doc #>> '{fields,inputs,dmpa_stock_value}'::text[] AS dmpa_stock_value,
    doc #>> '{fields,inputs,misoprostol_stock_value}'::text[] AS misoprostol_stock_value,
    doc #>> '{fields,inputs,coc_stock_value}'::text[] AS coc_stock_value,
    doc #>> '{fields,inputs,condoms_stock_value}'::text[] AS condoms_stock_value,
    doc #>> '{fields,inputs,contraceptives_stock_value}'::text[] AS contraceptives_stock_value,
    doc #>> '{fields,inputs,rectal_stock_value}'::text[] AS rectal_stock_value,
    doc #>> '{fields,inputs,sayana_stock_value}'::text[] AS sayana_stock_value,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    doc #>> '{fields,inputs,contact,contact,name}'::text[] AS nested_contact_name,
    doc #>> '{fields,place_id}'::text[] AS place_id,
    doc #>> '{fields,private}'::text[] AS private,
    doc #>> '{fields,place_name}'::text[] AS place_name,
    doc #>> '{fields,vht_name}'::text[] AS vht_name,
    doc #>> '{fields,act_low}'::text[] AS act_low,
    doc #>> '{fields,amoxicillin_low}'::text[] AS amoxicillin_low,
    doc #>> '{fields,zinc_low}'::text[] AS zinc_low,
    doc #>> '{fields,condoms_low}'::text[] AS condoms_low,
    doc #>> '{fields,rdts_low}'::text[] AS rdts_low,
    doc #>> '{fields,coc_low}'::text[] AS coc_low,
    doc #>> '{fields,pop_low}'::text[] AS pop_low,
    doc #>> '{fields,contraceptives_low}'::text[] AS contraceptives_low,
    doc #>> '{fields,dmpa_low}'::text[] AS dmpa_low,
    doc #>> '{fields,rectal_low}'::text[] AS rectal_low,
    doc #>> '{fields,gloves_low}'::text[] AS gloves_low,
    doc #>> '{fields,vht_stock_details,note_low_stock}'::text[] AS note_low_stock,
    doc #>> '{fields,vht_stock_details,act_at_hand}'::text[] AS act_at_hand,
    doc #>> '{fields,vht_stock_details,mrdt_at_hand}'::text[] AS mrdt_at_hand,
    doc #>> '{fields,vht_stock_details,rectal_at_hand}'::text[] AS rectal_at_hand,
    doc #>> '{fields,vht_stock_details,gloves_at_hand}'::text[] AS gloves_at_hand,
    doc #>> '{fields,vht_stock_details,zinc_at_hand}'::text[] AS zinc_at_hand,
    doc #>> '{fields,vht_stock_details,amoxicillin_at_hand}'::text[] AS amoxicillin_at_hand,
    doc #>> '{fields,vht_stock_details,pop_at_hand}'::text[] AS pop_at_hand,
    doc #>> '{fields,vht_stock_details,coc_at_hand}'::text[] AS coc_at_hand,
    doc #>> '{fields,vht_stock_details,contraceptives_at_hand}'::text[] AS contraceptives_at_hand,
    doc #>> '{fields,vht_stock_details,dmpa_at_hand}'::text[] AS dmpa_at_hand,
    doc #>> '{fields,vht_stock_details,condom_at_hand}'::text[] AS condom_at_hand,
    doc #>> '{fields,vht_stock_details,action,note_replenish_stock}'::text[] AS action_note_replenish_stock,
    doc #>> '{fields,vht_stock_details,action,action_taken}'::text[] AS action_taken,
    doc #>> '{fields,vht_stock_details,action,other_action_taken}'::text[] AS action_other_action_taken,
    doc #>> '{fields,vht_stock_details,action,issued_stock_note}'::text[] AS action_issued_stock_note,
    doc #>> '{fields,inputs,contact,_id}'                         AS vht_area_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.parish,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
FROM dwh.cht_data d LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{fields,inputs,contact,_id}') = h.vht_area_id 
  WHERE (doc ->> 'form'::text) = 'stockout'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX mv_stockout_reported_idx ON cht.mv_stockout USING btree (reported) tablespace ts_indexes;
CREATE INDEX mv_stockout_date_idx ON cht.mv_stockout USING btree (date) tablespace ts_indexes;
CREATE INDEX mv_stockout_monthname_idx ON cht.mv_stockout USING btree (monthname) tablespace ts_indexes;
CREATE INDEX mv_stockout_year_month_district ON cht.mv_stockout USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX mv_stockout_vht_area_id_idx ON cht.mv_stockout USING btree (vht_area_id) tablespace ts_indexes;
CREATE INDEX mv_stockout_facility_idx ON cht.mv_stockout USING btree (facility) tablespace ts_indexes;
CREATE INDEX mv_stockout_dhis2_facility_id_idx ON cht.mv_stockout USING btree (dhis2_facility_id) tablespace ts_indexes;


-- -------- mv_support_supervision  (source: mv_support_supervision.sql) --------
DROP MATERIALIZED VIEW cht.mv_support_supervision;
CREATE MATERIALIZED VIEW cht.mv_support_supervision
TABLESPACE ts_report
AS SELECT d.doc ->> '_id'::text AS doc_id,
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
    d.doc ->> 'form'::text AS form,
    d.doc ->> 'from'::text AS "from",
    d.doc #>> '{fields,source}'::text[] AS source,
    d.doc #>> '{fields,source_id}'::text[] AS source_id,
    d.doc #>> '{fields,inputs,task_id}'::text[] AS task_id,
    d.doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    d.doc #>> '{fields,inputs,contact,patient_id}'::text[] AS inputs_contact_patient_id,
    d.doc #>> '{fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    d.doc #>> '{fields,inputs,contact,contact,reported_date}'::text[] AS reported_date,
    d.doc #>> '{fields,inputs,contact,parent,_id}'::text[] AS parent_id, --
    d.doc #>> '{fields,inputs,contact,parent,parent,name}'::text[] AS parent_name,
    d.doc #>> '{fields,inputs,contact,parent,parent,phone}'::text[] AS phone,
    d.doc #>> '{fields,patient_id}'::text[] AS patient_id,
    d.doc #>> '{fields,vht_name}'::text[] AS vht_name,
    d.doc #>> '{fields,last_supervised}'::text[] AS last_supervised,
    d.doc #>> '{fields,supervisions_last_quarter}'::text[] AS supervisions_last_quarter,
    d.doc #>> '{fields,months_active}'::text[] AS months_active,
    d.doc #>> '{fields,commodity_gloves}'::text[] AS commodity_gloves,
    d.doc #>> '{fields,commodity_malaria}'::text[] AS commodity_malaria,
    d.doc #>> '{fields,commodity_muac}'::text[] AS commodity_muac,
    d.doc #>> '{fields,commodity_act}'::text[] AS commodity_act,
    d.doc #>> '{fields,commodity_amox}'::text[] AS commodity_amox,
    d.doc #>> '{fields,commodity_ors}'::text[] AS commodity_ors,
    d.doc #>> '{fields,commodity_rectal}'::text[] AS commodity_rectal,
    d.doc #>> '{fields,commodity_pops}'::text[] AS commodity_pops,
    d.doc #>> '{fields,commodity_cocs}'::text[] AS commodity_cocs,
    d.doc #>> '{fields,commodity_ec}'::text[] AS commodity_ec,
    d.doc #>> '{fields,details,vht_name_usage}'::text[] AS vht_name_usage,
    d.doc #>> '{fields,details,vht_education}'::text[] AS vht_education,
    d.doc #>> '{fields,support_supervision,supervision_type}'::text[] AS supervision_type,
    d.doc #>> '{fields,support_supervision,note_scheduled}'::text[] AS note_scheduled,
    d.doc #>> '{fields,support_supervision,note_spot_checking}'::text[] AS note_spot_checking,
    d.doc #>> '{fields,support_supervision,facility}'::text[] AS supervision_facility,
    d.doc #>> '{fields,support_supervision,note_number_supervision}'::text[] AS note_number_supervision,
    d.doc #>> '{fields,support_supervision,note_last_supervised}'::text[] AS note_last_supervised,
    d.doc #>> '{fields,support_supervision,last_supervision}'::text[] AS last_supervision,
    d.doc #>> '{fields,support_supervision,feedback}'::text[] AS supervision_feedback,
    d.doc #>> '{fields,support_supervision,actions,action_taken}'::text[] AS supervision_action_taken,
    d.doc #>> '{fields,support_supervision,actions,solution}'::text[] AS supervision_solution,
    d.doc #>> '{fields,support_supervision,actions,solution_timeline}'::text[] AS supervision_solution_timeline,
    d.doc #>> '{fields,support_supervision,actions,responsible_person}'::text[] AS supervision_responsible_person,
    d.doc #>> '{fields,training,services_offered}'::text[] AS services_offered,
    d.doc #>> '{fields,training,specify}'::text[] AS training_specify,
    d.doc #>> '{fields,training,vht_training}'::text[] AS vht_training,
    d.doc #>> '{fields,training,echis_training}'::text[] AS echis_training,
    d.doc #>> '{fields,training,actions,action_taken}'::text[] AS training_action_taken,
    d.doc #>> '{fields,training,actions,solution}'::text[] AS training_solution,
    d.doc #>> '{fields,training,actions,solution_timeline}'::text[] AS training_solution_timeline,
    d.doc #>> '{fields,training,actions,responsible_person}'::text[] AS training_responsible_person,
    d.doc #>> '{fields,tools_guidelines,tools}'::text[] AS tools,
    d.doc #>> '{fields,tools_guidelines,specify_tools}'::text[] AS specify_tools,
    d.doc #>> '{fields,tools_guidelines,iccm_tools}'::text[] AS iccm_tools,
    d.doc #>> '{fields,tools_guidelines,specify_icmm_tools}'::text[] AS specify_icmm_tools,
    d.doc #>> '{fields,tools_guidelines,paper}'::text[] AS paper,
    d.doc #>> '{fields,tools_guidelines,actions,action_taken}'::text[] AS tools_action_taken,
    d.doc #>> '{fields,tools_guidelines,actions,solution_timeline}'::text[] AS tools_solution_timeline,
    d.doc #>> '{fields,tools_guidelines,actions,responsible_person}'::text[] AS tools_responsible_person,
    d.doc #>> '{fields,medicines,available_medicines}'::text[] AS available_medicines,
    d.doc #>> '{fields,medicines,physical_count}'::text[] AS physical_count,
    d.doc #>> '{fields,medicines,stock_out}'::text[] AS stock_out,
    d.doc #>> '{fields,medicines,replenished}'::text[] AS replenished,
    d.doc #>> '{fields,medicines,vht_challenges}'::text[] AS vht_challenges,
    d.doc #>> '{fields,medicines,vht_store}'::text[] AS vht_store,
    d.doc #>> '{fields,medicines,dispose}'::text[] AS dispose,
    d.doc #>> '{fields,medicines,actions,action_taken}'::text[] AS medicines_action_taken,
    d.doc #>> '{fields,medicines,actions,solution}'::text[] AS medicines_solution,
    d.doc #>> '{fields,medicines,actions,solution_timeline}'::text[] AS medicines_solution_timeline,
    d.doc #>> '{fields,medicines,actions,responsible_person}'::text[] AS medicines_responsible_person,
    d.doc #>> '{fields,referral,assess_vht}'::text[] AS assess_vht,
    d.doc #>> '{fields,referral,illness}'::text[] AS illness,
    d.doc #>> '{fields,referral,vht_guidelines}'::text[] AS vht_guidelines,
    d.doc #>> '{fields,referral,job_aids}'::text[] AS job_aids,
    d.doc #>> '{fields,referral,danger_signs}'::text[] AS danger_signs,
    d.doc #>> '{fields,referral,children_treated}'::text[] AS children_treated,
    d.doc #>> '{fields,referral,children_followed}'::text[] AS children_followed,
    d.doc #>> '{fields,referral,alerts}'::text[] AS alerts,
    d.doc #>> '{fields,referral,actions,action_taken}'::text[] AS referral_action_taken,
    d.doc #>> '{fields,referral,actions,solution}'::text[] AS referral_solution,
    d.doc #>> '{fields,referral,actions,solution_timeline}'::text[] AS referral_solution_timeline,
    d.doc #>> '{fields,referral,actions,responsible_person}'::text[] AS referral_responsible_person,
    d.doc #>> '{fields,reporting,bundles}'::text[] AS bundles,
    (d.doc #>> '{fields,reporting,bundles_received}'::text[])::integer AS bundles_received,
    d.doc #>> '{fields,reporting,last_sync}'::text[] AS last_sync,
    d.doc #>> '{fields,reporting,facilitation}'::text[] AS facilitation,
    d.doc #>> '{fields,reporting,actions,action_taken}'::text[] AS reporting_action_taken,
    d.doc #>> '{fields,reporting,actions,solution}'::text[] AS reporting_solution,
    d.doc #>> '{fields,reporting,actions,solution_timeline}'::text[] AS reporting_solution_timeline,
    d.doc #>> '{fields,reporting,actions,responsible_person}'::text[] AS reporting_responsible_person,
    d.doc #>> '{fields,behavior,education_messages}'::text[] AS education_messages,
    d.doc #>> '{fields,behavior,number_deliveries}'::text[] AS number_deliveries,
    d.doc #>> '{fields,behavior,number_births}'::text[] AS number_births,
    d.doc #>> '{fields,behavior,dialogues}'::text[] AS dialogues,
    d.doc #>> '{fields,behavior,actions,action_taken}'::text[] AS behavior_action_taken,
    d.doc #>> '{fields,behavior,actions,solution}'::text[] AS behavior_solution,
    d.doc #>> '{fields,behavior,actions,solution_timeline}'::text[] AS behavior_solution_timeline,
    d.doc #>> '{fields,behavior,actions,responsible_person}'::text[] AS behavior_responsible_person,
    d.doc #>> '{fields,challenges,issues}'::text[] AS issues,
    d.doc #>> '{fields,challenges,describe_issues}'::text[] AS describe_issues,
    d.doc #>> '{fields,challenges,other_challenges}'::text[] AS other_challenges,
    d.doc #>> '{fields,challenges,actions,action_taken}'::text[] AS action_taken,
    d.doc #>> '{fields,challenges,actions,solution}'::text[] AS solution,
    d.doc #>> '{fields,challenges,actions,solution_timeline}'::text[] AS solution_timeline,
    d.doc #>> '{fields,challenges,actions,responsible_person}'::text[] AS responsible_person,
    d.doc #>> '{fields,inputs,contact,parent,_id}'::text[] AS vht_area_id,
    h.facility,
    h.dhis2_facility_id,
    h.village,
    h.parish,
    h.district,
    h.region,
    CURRENT_TIMESTAMP AS last_refresh_date
   FROM dwh.cht_data d
     LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{fields,inputs,contact,parent,_id}'::text[]) = h.vht_area_id
  WHERE (d.doc ->> 'form'::text) = 'support_supervision'::text AND d.is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX support_supervision_reported_idx ON cht.mv_support_supervision USING btree (reported) tablespace ts_indexes;
CREATE INDEX support_supervision_date_idx ON cht.mv_support_supervision USING btree (date) tablespace ts_indexes;
CREATE INDEX support_supervision_monthname_idx ON cht.mv_support_supervision USING btree (monthname) tablespace ts_indexes;
CREATE INDEX mv_support_supervision_year_month_district ON cht.mv_support_supervision USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX support_supervision_vht_area_id_idx ON cht.mv_support_supervision USING btree (vht_area_id) tablespace ts_indexes;
CREATE INDEX support_supervision_facility_idx ON cht.mv_support_supervision USING btree (facility) tablespace ts_indexes;
CREATE INDEX support_supervision_dhis2_facility_id_idx ON cht.mv_support_supervision USING btree (dhis2_facility_id) tablespace ts_indexes;
CREATE INDEX support_supervision_village_idx ON cht.mv_support_supervision USING btree (village) tablespace ts_indexes;
CREATE INDEX support_supervision_district_idx ON cht.mv_support_supervision USING btree (district) tablespace ts_indexes;
CREATE INDEX support_supervision_region_idx ON cht.mv_support_supervision USING btree (region) tablespace ts_indexes; 


-- -------- mv_tb_follow_up  (source: mv_tb_follow_up.sql) --------
DROP MATERIALIZED VIEW cht.mv_tb_follow_up;
CREATE MATERIALIZED VIEW cht.mv_tb_follow_up
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
    doc #>> '{fields,inputs,treatmentStartDate}'::text[] AS treatmentstartdate,
    doc #>> '{fields,inputs,user,contact_id}'::text[] AS user_contact_id,
    doc #>> '{fields,inputs,user,facility_id}'::text[] AS user_facility_id,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    doc #>> '{fields,inputs,contact,date_of_birth}'::text[] AS date_of_birth,
    doc #>> '{fields,inputs,contact,sex}'::text[] AS sex,
    doc #>> '{fields,inputs,contact,phone}'::text[] AS phone,
    doc #>> '{fields,inputs,contact,phone2}'::text[] AS phone2,
    doc #>> '{fields,inputs,contact,client_category}'::text[] AS client_category,
    doc #>> '{fields,inputs,contact,parent,_id}'::text[] AS parent__id,
    doc #>> '{fields,inputs,contact,parent,name}'::text[] AS parent_name,
    doc #>> '{fields,inputs,contact,parent,parent,_id}'::text[] AS parent_parent__id,
    doc #>> '{fields,inputs,contact,parent,parent,name}'::text[] AS parent_parent_name,
    doc #>> '{fields,inputs,contact,parent,parent,supervisor}'::text[] AS supervisor,
    doc #>> '{fields,inputs,contact,parent,parent,phone}'::text[] AS parent_phone,
    doc #>> '{fields,inputs,contact,parent,parent,contact,_id}'::text[] AS contact__id,
    doc #>> '{fields,inputs,contact,parent,parent,contact,phone}'::text[] AS contact_phone,
    doc #>> '{fields,inputs,contact,parent,parent,contact,name}'::text[] AS contact_name,
    doc #>> '{fields,inputs,contact,parent,parent,parent,_id}'::text[] AS parent_parent_parent__id,
    doc #>> '{fields,patient_age_in_years}'::text[] AS patient_age_in_years,
    doc #>> '{fields,patient_age_in_months}'::text[] AS patient_age_in_months,
    doc #>> '{fields,patient_age_in_days}'::text[] AS patient_age_in_days,
    doc #>> '{fields,patient_age_display}'::text[] AS patient_age_display,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,patient_name}'::text[] AS patient_name,
    doc #>> '{fields,patient_gender}'::text[] AS patient_gender,
    doc #>> '{fields,patient_pronoun}'::text[] AS patient_pronoun,
    doc #>> '{fields,patient_phone}'::text[] AS patient_phone,
    doc #>> '{fields,tb_treatment_start_date}'::text[] AS tb_treatment_start_date,
    doc #>> '{fields,start_date}'::text[] AS start_date,
    doc #>> '{fields,tb_adherence,taking_tb_drugs}'::text[] AS taking_tb_drugs,
    doc #>> '{fields,tb_adherence,attending_scheduled_clinic_visits}'::text[] AS attending_scheduled_clinic_visits,
    doc #>> '{fields,tb_test_reminder,has_exited_tb_program}'::text[] AS has_exited_tb_program,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.parish,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
FROM dwh.cht_data d LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id 
  WHERE (doc ->> 'form'::text) = 'tb_follow_up'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX tb_follow_up_reported_idx ON cht.mv_tb_follow_up USING btree (reported) tablespace ts_indexes;
CREATE INDEX tb_follow_up_date_idx ON cht.mv_tb_follow_up USING btree (date) tablespace ts_indexes;
CREATE INDEX tb_follow_up_monthname_idx ON cht.mv_tb_follow_up USING btree (monthname) tablespace ts_indexes;
CREATE INDEX mv_tb_follow_up_year_month_district ON cht.mv_tb_follow_up USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX tb_follow_up_district_idx ON cht.mv_tb_follow_up USING btree (district) tablespace ts_indexes;
CREATE INDEX tb_follow_up_region_idx ON cht.mv_tb_follow_up USING btree (region) tablespace ts_indexes;
CREATE INDEX tb_follow_up_chw_id_idx ON cht.mv_tb_follow_up USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX tb_follow_up_facility_idx ON cht.mv_tb_follow_up USING btree (facility) tablespace ts_indexes;
CREATE INDEX tb_follow_up_dhis2_facility_id_idx ON cht.mv_tb_follow_up USING btree (dhis2_facility_id) tablespace ts_indexes;
CREATE INDEX tb_follow_up_village_idx ON cht.mv_tb_follow_up USING btree (village) tablespace ts_indexes; 


-- -------- mv_tb_referral_follow_up  (source: mv_tb_referral_follow_up.sql) --------
DROP MATERIALIZED VIEW cht.mv_tb_referral_follow_up;
CREATE MATERIALIZED VIEW cht.mv_tb_referral_follow_up
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
    doc ->> 'from'::text AS "from",
    doc #>> '{fields,inputs,source}'::text[] AS source,
    doc #>> '{fields,inputs,source_id}'::text[] AS source_id,
    doc #>> '{fields,inputs,t_tb_result}'::text[] AS t_tb_result,
    doc #>> '{fields,inputs,user,contact_id}'::text[] AS user_contact_id,
    doc #>> '{fields,inputs,user,facility_id}'::text[] AS user_facility_id,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    doc #>> '{fields,inputs,contact,date_of_birth}'::text[] AS inputs_contact_date_of_birth,
    doc #>> '{fields,inputs,contact,sex}'::text[] AS inputs_contact_sex,
    doc #>> '{fields,inputs,contact,parent,_id}'::text[] AS parent__id,
    doc #>> '{fields,inputs,contact,parent,name}'::text[] AS inputs_parent_name,
    doc #>> '{fields,inputs,contact,parent,parent,_id}'::text[] AS parent_parent__id,
    doc #>> '{fields,inputs,contact,parent,parent,name}'::text[] AS parent_parent_name,
    doc #>> '{fields,inputs,contact,parent,parent,supervisor}'::text[] AS supervisor,
    doc #>> '{fields,inputs,contact,parent,parent,phone}'::text[] AS phone,
    doc #>> '{fields,inputs,contact,parent,parent,village}'::text[] AS inputs_village,
    doc #>> '{fields,inputs,contact,parent,parent,contact,_id}'::text[] AS contact__id,
    doc #>> '{fields,inputs,contact,parent,parent,contact,phone}'::text[] AS contact_phone,
    doc #>> '{fields,inputs,contact,parent,parent,contact,name}'::text[] AS inputs_contact_name_2,
    doc #>> '{fields,inputs,contact,parent,parent,parent,_id}'::text[] AS parent_parent_parent__id,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,patient_name}'::text[] AS patient_name,
    doc #>> '{fields,patient_gender}'::text[] AS patient_gender,
    doc #>> '{fields,patient_age_in_years}'::text[] AS patient_age_in_years,
    doc #>> '{fields,patient_age_in_months}'::text[] AS patient_age_in_months,
    doc #>> '{fields,patient_age_in_days}'::text[] AS patient_age_in_days,
    doc #>> '{fields,patient_age_display}'::text[] AS patient_age_display,
    doc #>> '{fields,patient_pronoun}'::text[] AS patient_pronoun,
    doc #>> '{fields,place_name}'::text[] AS place_name,
    doc #>> '{fields,needs_signoff}'::text[] AS needs_signoff,
    doc #>> '{fields,treatment_information,patient_started_treatment}'::text[] AS patient_started_treatment,
    doc #>> '{fields,treatment_information,treatment_date}'::text[] AS treatment_date,
    doc #>> '{fields,referral_notification,encourage_to_to_facility}'::text[] AS encourage_to_to_facility,
    doc #>> '{fields,referral_notification,referred_to_health_facility}'::text[] AS referred_to_health_facility,
    doc #>> '{fields,referral_notification,went_to_facility_as_referred}'::text[] AS went_to_facility_as_referred,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.parish,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
FROM dwh.cht_data d LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id 
  WHERE (doc ->> 'form'::text) = 'tb_referral_follow_up'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX tb_referral_follow_up_reported_idx ON cht.mv_tb_referral_follow_up USING btree (reported) tablespace ts_indexes;
CREATE INDEX tb_referral_follow_up_date_idx ON cht.mv_tb_referral_follow_up USING btree (date) tablespace ts_indexes;
CREATE INDEX tb_referral_follow_up_monthname_idx ON cht.mv_tb_referral_follow_up USING btree (monthname) tablespace ts_indexes;
CREATE INDEX mv_tb_referral_follow_up_year_month_district ON cht.mv_tb_referral_follow_up USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX tb_referral_follow_up_chw_id_idx ON cht.mv_tb_referral_follow_up USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX tb_referral_follow_up_facility_idx ON cht.mv_tb_referral_follow_up USING btree (facility) tablespace ts_indexes;
CREATE INDEX tb_referral_follow_up_dhis2_facility_id_idx ON cht.mv_tb_referral_follow_up USING btree (dhis2_facility_id) tablespace ts_indexes;
CREATE INDEX tb_referral_follow_up_village_idx ON cht.mv_tb_referral_follow_up USING btree (village) tablespace ts_indexes;
CREATE INDEX tb_referral_follow_up_district_idx ON cht.mv_tb_referral_follow_up USING btree (district) tablespace ts_indexes;
CREATE INDEX tb_referral_follow_up_region_idx ON cht.mv_tb_referral_follow_up USING btree (region) tablespace ts_indexes;


-- -------- mv_tb_results_notification  (source: mv_tb_results_notification.sql) --------
DROP MATERIALIZED VIEW cht.mv_tb_results_notification;
CREATE MATERIALIZED VIEW cht.mv_tb_results_notification
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
    doc #>> '{fields,t_tb_result}'::text[] AS t_tb_result,
    doc #>> '{fields,t_results_phone_number}'::text[] AS t_results_phone_number,
    doc #>> '{fields,t_cough}'::text[] AS t_cough,
    doc #>> '{fields,t_fever}'::text[] AS t_fever,
    doc #>> '{fields,t_weight_loss}'::text[] AS t_weight_loss,
    doc #>> '{fields,t_excessive_night_sweat}'::text[] AS t_excessive_night_sweat,
    doc #>> '{fields,t_poor_weight_gain}'::text[] AS t_poor_weight_gain,
    doc #>> '{fields,t_is_on_tb_treatment}'::text[] AS t_is_on_tb_treatment,
    doc #>> '{fields,t_prev_tb_result}'::text[] AS t_prev_tb_result,
    doc #>> '{fields,t_returned_result_barcode}'::text[] AS t_returned_result_barcode,
    doc #>> '{fields,inputs,user,contact_id}'::text[] AS user_contact_id,
    doc #>> '{fields,inputs,user,facility_id}'::text[] AS user_facility_id,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS contact_name,
    doc #>> '{fields,inputs,contact,date_of_birth}'::text[] AS contact_date_of_birth,
    doc #>> '{fields,inputs,contact,sex}'::text[] AS contact_sex,
    doc #>> '{fields,inputs,contact,parent,_id}'::text[] AS parent__id,
    doc #>> '{fields,inputs,contact,parent,name}'::text[] AS parent_name,
    doc #>> '{fields,inputs,contact,parent,parent,supervisor}'::text[] AS supervisor,
    doc #>> '{fields,inputs,contact,parent,parent,phone}'::text[] AS phone,
    doc #>> '{fields,patient_age_in_years}'::text[] AS patient_age_in_years,
    doc #>> '{fields,patient_age_in_months}'::text[] AS patient_age_in_months,
    doc #>> '{fields,patient_age_in_days}'::text[] AS patient_age_in_days,
    doc #>> '{fields,patient_age_display}'::text[] AS patient_age_display,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,patient_name}'::text[] AS patient_name,
    doc #>> '{fields,patient_gender}'::text[] AS patient_gender,
    doc #>> '{fields,patient_pronoun}'::text[] AS patient_pronoun,
    doc #>> '{fields,patient_adjective}'::text[] AS patient_adjective,
    doc #>> '{fields,tb_result}'::text[] AS tb_result,
    doc #>> '{fields,barcode_scanner_result}'::text[] AS barcode_scanner_result,
    doc #>> '{fields,cough}'::text[] AS cough,
    doc #>> '{fields,fever}'::text[] AS fever,
    doc #>> '{fields,weight_loss}'::text[] AS weight_loss,
    doc #>> '{fields,excessive_night_sweat}'::text[] AS excessive_night_sweat,
    doc #>> '{fields,poor_weight_gain}'::text[] AS poor_weight_gain,
    doc #>> '{fields,is_on_tb_treatment}'::text[] AS is_on_tb_treatment,
    doc #>> '{fields,patient_referred_to_health_facility}'::text[] AS patient_referred_to_health_facility,
    doc #>> '{fields,national_identification_number}'::text[] AS national_identification_number,
    doc #>> '{fields,client_category}'::text[] AS client_category,
    doc #>> '{fields,results_notification,note_tb_results}'::text[] AS note_tb_results,
    doc #>> '{fields,results_notification,note_barcode_id}'::text[] AS note_barcode_id,
    doc #>> '{fields,results_notification,note_results}'::text[] AS note_results,
    doc #>> '{fields,results_notification,refer_patient_to_health_facility}'::text[] AS refer_patient_to_health_facility,
    doc #>> '{fields,results_notification,confirm_refer_to_health_facility}'::text[] AS confirm_refer_to_health_facility,
    doc #>> '{fields,results_notification,explain_result_invalid}'::text[] AS explain_result_invalid,
    doc #>> '{fields,missing_results_notification,note_refer_to_health_facility}'::text[] AS note_refer_to_health_facility,
    doc #>> '{fields,missing_results_notification,note_explain_missing_result}'::text[] AS note_explain_missing_result,
    doc #>> '{fields,sputum_collection,give_patient_instructions}'::text[] AS give_patient_instructions,
    doc #>> '{fields,sputum_collection,has_patient_produced_sputum}'::text[] AS has_patient_produced_sputum,
    doc #>> '{fields,sputum_collection,confirm_container_tightly_closed}'::text[] AS confirm_container_tightly_closed,
    doc #>> '{fields,sputum_collection,confirm_send_sample_for_testing}'::text[] AS confirm_send_sample_for_testing,
    doc #>> '{fields,sputum_collection,leave_sputum_bottle_with_client}'::text[] AS leave_sputum_bottle_with_client,
    doc #>> '{fields,sputum_collection,has_left_sputum_bottle_with_client}'::text[] AS has_left_sputum_bottle_with_client,
    doc #>> '{fields,sputum_collection_consent,results_phone_number}'::text[] AS results_phone_number,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.parish,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
FROM dwh.cht_data d LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id
  WHERE (doc ->> 'form'::text) = 'tb_results_notification'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX tb_results_notification_reported_idx ON cht.mv_tb_results_notification USING btree (reported) tablespace ts_indexes;
CREATE INDEX tb_results_notification_date_idx ON cht.mv_tb_results_notification USING btree (date) tablespace ts_indexes;
CREATE INDEX tb_results_notification_monthname_idx ON cht.mv_tb_results_notification USING btree (monthname) tablespace ts_indexes;
CREATE INDEX mv_tb_results_notification_year_month_district ON cht.mv_tb_results_notification USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX tb_results_notification_chw_id_idx ON cht.mv_tb_results_notification USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX tb_results_notification_facility_idx ON cht.mv_tb_results_notification USING btree (facility) tablespace ts_indexes;
CREATE INDEX tb_results_notification_dhis2_facility_id_idx ON cht.mv_tb_results_notification USING btree (dhis2_facility_id) tablespace ts_indexes;
CREATE INDEX tb_results_notification_village_idx ON cht.mv_tb_results_notification USING btree (village) tablespace ts_indexes;
CREATE INDEX tb_results_notification_district_idx ON cht.mv_tb_results_notification USING btree (district) tablespace ts_indexes;
CREATE INDEX tb_results_notification_region_idx ON cht.mv_tb_results_notification USING btree (region) tablespace ts_indexes;


-- -------- mv_tb_screening  (source: mv_tb_screening.sql) --------
DROP MATERIALIZED VIEW cht.mv_tb_screening;
CREATE MATERIALIZED VIEW cht.mv_tb_screening
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
    doc #>> '{fields,inputs,user,contact_id}'::text[] AS user_contact_id,
    doc #>> '{fields,inputs,user,facility_id}'::text[] AS user_facility_id,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    doc #>> '{fields,inputs,contact,date_of_birth}'::text[] AS inputs_contact_date_of_birth,
    doc #>> '{fields,inputs,contact,sex}'::text[] AS inputs_contact_sex,
    doc #>> '{fields,inputs,contact,phone}'::text[] AS inputs_contact_phone,
    doc #>> '{fields,inputs,contact,parent,_id}'::text[] AS inputs_parent_id,
    doc #>> '{fields,inputs,contact,parent,name}'::text[] AS inputs_parent_name,
    doc #>> '{fields,inputs,contact,parent,parent,supervisor}'::text[] AS inputs_supervisor,
    doc #>> '{fields,inputs,contact,parent,parent,phone}'::text[] AS inputs_parent_phone,
    doc #>> '{fields,inputs,contact,parent,parent,village}'::text[] AS inputs_village,
    doc #>> '{fields,patient_age_in_years}'::text[] AS patient_age_in_years,
    doc #>> '{fields,patient_age_in_months}'::text[] AS patient_age_in_months,
    doc #>> '{fields,patient_age_in_days}'::text[] AS patient_age_in_days,
    doc #>> '{fields,patient_age_display}'::text[] AS patient_age_display,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,patient_name}'::text[] AS patient_name,
    doc #>> '{fields,patient_gender}'::text[] AS patient_gender,
    doc #>> '{fields,patient_pronoun}'::text[] AS patient_pronoun,
    doc #>> '{fields,patient_adjective}'::text[] AS patient_adjective,
    doc #>> '{fields,patient_gender_pronoun}'::text[] AS patient_gender_pronoun,
    doc #>> '{fields,patient_phone}'::text[] AS patient_phone,
    doc #>> '{fields,still_on_tb_treatment}'::text[] AS still_on_tb_treatment,
    doc #>> '{fields,has_diabetes_on_screening}'::text[] AS has_diabetes_on_screening,
    doc #>> '{fields,is_a_miner_on_screening}'::text[] AS is_a_miner_on_screening,
    doc #>> '{fields,is_hiv_positive}'::text[] AS is_hiv_positive,
    doc #>> '{fields,patient_category}'::text[] AS patient_category,
    doc #>> '{fields,barcode_scanner_result}'::text[] AS barcode_scanner_result,
    doc #>> '{fields,is_presumptive_case}'::text[] AS is_presumptive_case,
    doc #>> '{fields,national_identification_number}'::text[] AS national_identification_number,
    doc #>> '{fields,client_category}'::text[] AS client_category,
    doc #>> '{fields,is_on_tb_treatment}'::text[] AS is_on_tb_treatment,
    doc #>> '{fields,cough}'::text[] AS cough,
    doc #>> '{fields,fever}'::text[] AS fever,
    doc #>> '{fields,excessive_night_sweat}'::text[] AS excessive_night_sweat,
    doc #>> '{fields,weight_loss}'::text[] AS weight_loss,
    doc #>> '{fields,poor_weight_gain}'::text[] AS poor_weight_gain,
    doc #>> '{fields,group_tb_screening,is_currently_on_tb_treatment}'::text[] AS is_currently_on_tb_treatment,
    doc #>> '{fields,group_tb_screening,is_still_on_tb_treatment}'::text[] AS is_still_on_tb_treatment,
    doc #>> '{fields,group_tb_screening,have_all_members_been_screened}'::text[] AS have_all_members_been_screened,
    doc #>> '{fields,group_tb_screening,refer_household_members}'::text[] AS refer_household_members,
    doc #>> '{fields,group_tb_health_education,health_education}'::text[] AS health_education,
    doc #>> '{fields,group_tb_health_education,benefits_of_tb_treatment}'::text[] AS benefits_of_tb_treatment,
    doc #>> '{fields,group_tb_health_education,drug_resistance}'::text[] AS drug_resistance,
    doc #>> '{fields,group_tb_health_education,explain_drug_resistance}'::text[] AS explain_drug_resistance,
    doc #>> '{fields,group_tb_health_education,health_education_basics}'::text[] AS health_education_basics,
    doc #>> '{fields,group_tb_health_education,what_is_tb}'::text[] AS what_is_tb,
    doc #>> '{fields,group_tb_health_education,tb_explanation}'::text[] AS tb_explanation,
    doc #>> '{fields,group_tb_health_education,tb_explanation_type}'::text[] AS tb_explanation_type,
    doc #>> '{fields,group_tb_health_education,who_risk_contracting_tb}'::text[] AS who_risk_contracting_tb,
    doc #>> '{fields,group_tb_signs_and_symptoms_of_tb,cough_2_weeks_or_more}'::text[] AS cough_2_weeks_or_more,
    doc #>> '{fields,group_tb_signs_and_symptoms_of_tb,excessive_night_sweats}'::text[] AS excessive_night_sweats,
    doc #>> '{fields,group_tb_signs_and_symptoms_of_tb,unexplained_weight_loss}'::text[] AS unexplained_weight_loss,
    doc #>> '{fields,group_tb_signs_and_symptoms_of_tb,loss_of_appetite_image}'::text[] AS loss_of_appetite_image,
    doc #>> '{fields,group_tb_signs_and_symptoms_of_tb,chest_pain_image}'::text[] AS chest_pain_image,
    doc #>> '{fields,group_tb_signs_and_symptoms_of_tb,poor_weight_gain_among_children}'::text[] AS poor_weight_gain_among_children,
    doc #>> '{fields,group_tb_health_and_status_check,select_tb_risk_factors}'::text[] AS select_tb_risk_factors,
    doc #>> '{fields,group_tb_signs_and_symptoms,currently_have_tb_signs}'::text[] AS currently_have_tb_signs,
    doc #>> '{fields,group_tb_signs_and_symptoms,cough_sign}'::text[] AS cough_sign,
    doc #>> '{fields,group_tb_signs_and_symptoms,cough_duration}'::text[] AS cough_duration,
    doc #>> '{fields,group_tb_signs_and_symptoms,blood_in_cough}'::text[] AS blood_in_cough,
    doc #>> '{fields,group_tb_signs_and_symptoms,fever_symptom}'::text[] AS fever_symptom,
    doc #>> '{fields,group_tb_signs_and_symptoms,fever_duration}'::text[] AS fever_duration,
    doc #>> '{fields,group_tb_signs_and_symptoms,weight_loss_sign}'::text[] AS weight_loss_sign,
    doc #>> '{fields,group_tb_signs_and_symptoms,excessive_night_sweat_sign}'::text[] AS excessive_night_sweat_sign,
    doc #>> '{fields,group_tb_signs_and_symptoms,loss_of_appetite}'::text[] AS loss_of_appetite,
    doc #>> '{fields,group_tb_signs_and_symptoms,chest_pain}'::text[] AS chest_pain,
    doc #>> '{fields,group_tb_signs_and_symptoms,poor_weight_gain_sign}'::text[] AS poor_weight_gain_sign,
    doc #>> '{fields,group_tb_signs_and_symptoms,had_contact_with_tb_person}'::text[] AS had_contact_with_tb_person,
    doc #>> '{fields,group_tb_signs_and_symptoms,suspected_tb_signs}'::text[] AS suspected_tb_signs,
    doc #>> '{fields,group_tb_prevention_measures,note_educate_patient}'::text[] AS note_educate_patient,
    doc #>> '{fields,group_tb_prevention_measures,refer_to_health_facility}'::text[] AS refer_to_health_facility,
    doc #>> '{fields,group_tb_prevention_measures,confirms_referral}'::text[] AS confirms_referral,
    doc #>> '{fields,sputum_collection_consent,consented_sputum_sample}'::text[] AS consented_sputum_sample,
    doc #>> '{fields,sputum_collection_consent,registered_phone_number}'::text[] AS registered_phone_number,
    doc #>> '{fields,sputum_collection_consent,receive_results_on_same_phonenumber}'::text[] AS receive_results_on_same_phonenumber,
    doc #>> '{fields,sputum_collection_consent,enter_new_phone_number}'::text[] AS enter_new_phone_number,
    doc #>> '{fields,sputum_collection_consent,no_registered_phone_number}'::text[] AS no_registered_phone_number,
    doc #>> '{fields,sputum_collection_consent,phonenumber_to_receive_results}'::text[] AS phonenumber_to_receive_results,
    doc #>> '{fields,sputum_collection_consent,results_phone_number}'::text[] AS results_phone_number,
    doc #>> '{fields,sputum_collection,sputum_collection}'::text[] AS sputum_collection,
    doc #>> '{fields,sputum_collection,has_patient_produced_sputum}'::text[] AS has_patient_produced_sputum,
    doc #>> '{fields,sputum_collection,confirm_container_tightly_closed}'::text[] AS confirm_container_tightly_closed,
    doc #>> '{fields,sputum_collection,confirm_send_sample_for_testing}'::text[] AS confirm_send_sample_for_testing,
    doc #>> '{fields,sputum_collection,leave_sputum_bottle_with_client}'::text[] AS leave_sputum_bottle_with_client,
    doc #>> '{fields,sputum_collection,keep_container_closed}'::text[] AS keep_container_closed,
    doc #>> '{fields,sputum_collection,has_left_sputum_bottle_with_client}'::text[] AS has_left_sputum_bottle_with_client,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.parish,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
FROM dwh.cht_data d LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id
  WHERE (doc ->> 'form'::text) = 'tb_screening'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX tb_screening_reported_idx ON cht.mv_tb_screening USING btree (reported) TABLESPACE ts_indexes;
CREATE INDEX tb_screening_date_idx ON cht.mv_tb_screening USING btree (date) TABLESPACE ts_indexes;
CREATE INDEX tb_screening_monthname_idx ON cht.mv_tb_screening USING btree (monthname) TABLESPACE ts_indexes;
CREATE INDEX mv_tb_screening_year_month_district ON cht.mv_tb_screening USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX tb_screening_chw_id_idx ON cht.mv_tb_screening USING btree (chw_id) TABLESPACE ts_indexes;
CREATE INDEX tb_screening_facility_idx ON cht.mv_tb_screening USING btree (facility) TABLESPACE ts_indexes;
CREATE INDEX tb_screening_dhis2_facility_id_idx ON cht.mv_tb_screening USING btree (dhis2_facility_id) TABLESPACE ts_indexes;
CREATE INDEX tb_screening_village_idx ON cht.mv_tb_screening USING btree (village) TABLESPACE ts_indexes;
CREATE INDEX tb_screening_district_idx ON cht.mv_tb_screening USING btree (district) TABLESPACE ts_indexes;
CREATE INDEX tb_screening_region_idx ON cht.mv_tb_screening USING btree (region) TABLESPACE ts_indexes;


-- -------- mv_tb_uncompleted_referral  (source: mv_tb_uncompleted_referral.sql) --------
DROP MATERIALIZED VIEW cht.mv_tb_uncompleted_referral;
CREATE MATERIALIZED VIEW cht.mv_tb_uncompleted_referral
TABLESPACE ts_report
AS
SELECT
    doc ->> '_id'::text                              AS doc_id,
    doc ->> '_rev'::text                             AS rev,                                 -- [NEW FIELD]
    to_timestamp((NULLIF(doc ->> 'reported_date'::text, ''::text)::bigint / 1000)::double precision) AS reported,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY-MM-DD'))::date AS date,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY'))::INT AS year,
    TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'FMMonth') AS month,
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

     doc #>> '{fields,inputs,source}'                                    AS source,
     doc #>> '{fields,inputs,source_id}'                                 AS source_id,
     doc #>> '{fields,inputs,t_tb_result}'                               AS t_tb_result,
     doc #>> '{fields,inputs,t_place_name}'                              AS t_place_name,
     doc #>> '{fields,inputs,t_patient_name}'                            AS t_patient_name,
     doc #>> '{fields,inputs,user,contact_id}'                           AS user_contact_id,
     doc #>> '{fields,inputs,user,facility_id}'                          AS user_facility_id,
     doc #>> '{fields,inputs,contact,_id}'                               AS contact_id,
     doc #>> '{fields,inputs,contact,name}'                              AS contact_name,
     doc #>> '{fields,inputs,contact,date_of_birth}'                     AS contact_date_of_birth,
     doc #>> '{fields,inputs,contact,sex}'                               AS contact_sex,
     doc #>> '{fields,patient_id}'                                       AS patient_id,
     doc #>> '{fields,patient_name}'                                     AS patient_name,
     doc #>> '{fields,tb_result}'                                        AS tb_result,
     doc #>> '{fields,place_name}'                                       AS place_name,
     doc #>> '{fields,needs_signoff}'                                    AS needs_signoff,
    
    doc #>> '{fields,referral_notification,generated_note_name_25}'  AS generated_note_name_25,
    doc #>> '{fields,referral_notification,referred_to_health_facility}'  AS referred_to_health_facility,

        --- reporting hierarchy
    doc #>> '{contact,_id}'                         AS chw_id,                   
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.parish,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
FROM dwh.cht_data d LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id
  WHERE (doc ->> 'form'::text) = 'tb_uncompleted_referral'::text AND is_current
WITH NO DATA;

CREATE INDEX mv_tb_uncompleted_referral_reported_idx
    ON cht.mv_uncompleted_referral USING btree (reported) TABLESPACE ts_indexes;
CREATE INDEX mv_tb_uncompleted_referral_year_month_district ON cht.mv_tb_uncompleted_referral USING btree (year, month, district) TABLESPACE ts_indexes;


-- -------- mv_training_evaluation  (source: mv_training_evaluation.sql) --------
DROP MATERIALIZED VIEW cht.mv_training_evaluation;
CREATE MATERIALIZED VIEW cht.mv_training_evaluation
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
    doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    doc #>> '{fields,form_for_child_in_household_score}'::text[] AS form_for_child_in_household_score,
    doc #>> '{fields,option_for_reminder_score}'::text[] AS option_for_reminder_score,
    doc #>> '{fields,form_available_to_all_score}'::text[] AS form_available_to_all_score,
    doc #>> '{fields,who_is_responsible_for_hh_registration_score}'::text[] AS responsible_for_hh_registration_score,
    doc #>> '{fields,true_false_score}'::text[] AS true_false_score,
    doc #>> '{fields,tab_for_graphical_representation_score}'::text[] AS tab_for_graphical_representation_score,
    doc #>> '{fields,menu_for_reporting_issues_score}'::text[] AS menu_for_reporting_issues_score,
    doc #>> '{fields,option_facilitates_data_upload_score}'::text[] AS option_facilitates_data_upload_score,
    doc #>> '{fields,form_for_collecting_symptoms_score}'::text[] AS form_for_collecting_symptoms_score,
    doc #>> '{fields,option_for_completing_form_score}'::text[] AS option_for_completing_form_score,
    doc #>> '{fields,your_score}'::text[] AS your_score,
    doc #>> '{fields,group_test_questions,trainee_name}'::text[] AS trainee_name,
    doc #>> '{fields,group_test_questions,phone_number}'::text[] AS trainee_phone_number,
    doc #>> '{fields,group_test_questions,note_instructions}'::text[] AS note_instructions,
    doc #>> '{fields,group_test_questions,form_for_child_in_household}'::text[] AS form_for_child_in_household,
    doc #>> '{fields,group_test_questions,option_for_reminder}'::text[] AS option_for_reminder,
    doc #>> '{fields,group_test_questions,form_available_to_all}'::text[] AS form_available_to_all,
    doc #>> '{fields,group_test_questions,who_is_responsible_for_hh_registration}'::text[] AS responsible_for_hh_registration,
    doc #>> '{fields,group_test_questions,true_false}'::text[] AS true_false,
    doc #>> '{fields,group_test_questions,tab_for_graphical_representation}'::text[] AS tab_for_graphical_representation,
    doc #>> '{fields,group_test_questions,menu_for_reporting_issues}'::text[] AS menu_for_reporting_issues,
    doc #>> '{fields,group_test_questions,option_facilitates_data_upload}'::text[] AS option_facilitates_data_upload,
    doc #>> '{fields,group_test_questions,form_for_collecting_symptoms}'::text[] AS form_for_collecting_symptoms,
    doc #>> '{fields,group_test_questions,option_for_completing_form}'::text[] AS option_for_completing_form,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.parish,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
FROM dwh.cht_data d LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id 
  WHERE (doc ->> 'form'::text) = 'training_evaluation'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX training_evaluation_reported_idx ON cht.mv_training_evaluation USING btree (reported) tablespace ts_indexes;
CREATE INDEX training_evaluation_date_idx ON cht.mv_training_evaluation USING btree (date) tablespace ts_indexes;
CREATE INDEX training_evaluation_monthname_idx ON cht.mv_training_evaluation USING btree (monthname) tablespace ts_indexes;
CREATE INDEX mv_training_evaluation_year_month_district ON cht.mv_training_evaluation USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX training_evaluation_district_idx ON cht.mv_training_evaluation USING btree (district) tablespace ts_indexes;
CREATE INDEX training_evaluation_region_idx ON cht.mv_training_evaluation USING btree (region) tablespace ts_indexes;
CREATE INDEX training_evaluation_chw_id_idx ON cht.mv_training_evaluation USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX training_evaluation_facility_idx ON cht.mv_training_evaluation USING btree (facility) tablespace ts_indexes;
CREATE INDEX training_evaluation_dhis2_facility_id_idx ON cht.mv_training_evaluation USING btree (dhis2_facility_id) tablespace ts_indexes;
CREATE INDEX training_evaluation_village_idx ON cht.mv_training_evaluation USING btree (village) tablespace ts_indexes;
CREATE INDEX training_evaluation_last_refresh_date_idx ON cht.mv_training_evaluation USING btree (last_refresh_date) tablespace ts_indexes;                                                     


-- -------- mv_treatment_follow_up  (source: mv_treatment_follow_up.sql) --------
DROP MATERIALIZED VIEW cht.mv_treatment_follow_up;
CREATE MATERIALIZED VIEW cht.mv_treatment_follow_up
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
    doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    doc #>> '{fields,inputs,contact,date_of_birth}'::text[] AS inputs_contact_date_of_birth,
    doc #>> '{fields,inputs,contact,sex}'::text[] AS inputs_contact_sex,
    doc #>> '{fields,inputs,contact,parent,_id}'::text[] AS inputs_coparent_id,
    doc #>> '{fields,inputs,contact,parent,name}'::text[] AS inputs_contact_parent_name,
    doc #>> '{fields,patient_age_in_years}'::text[] AS patient_age_in_years,
    doc #>> '{fields,patient_age_in_months}'::text[] AS patient_age_in_months,
    doc #>> '{fields,patient_age_in_days}'::text[] AS patient_age_in_days,
    doc #>> '{fields,patient_age_display}'::text[] AS patient_age_display,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,patient_name}'::text[] AS patient_name,
    doc #>> '{fields,patient_gender}'::text[] AS patient_gender,
    doc #>> '{fields,referral_follow_up}'::text[] AS referral_follow_up,
    doc #>> '{fields,trigger_referral_follow_up}'::text[] AS trigger_referral_follow_up,
    doc #>> '{fields,group_danger_signs,follow_up_date}'::text[] AS follow_up_date,
    doc #>> '{fields,group_danger_signs,follow_up_method}'::text[] AS follow_up_method,
    doc #>> '{fields,group_danger_signs,note_look_for_danger_signs_in_person}'::text[] AS note_look_for_danger_signs_in_person,
    doc #>> '{fields,group_danger_signs,note_ask_for_danger_signs_on_phone}'::text[] AS note_ask_for_danger_signs_on_phone,
    doc #>> '{fields,group_danger_signs,any_danger_signs}'::text[] AS any_danger_signs,
    doc #>> '{fields,group_danger_signs,note_refer_urgently}'::text[] AS note_refer_urgently,
    doc #>> '{fields,group_follow_up,how_is_child}'::text[] AS how_is_child,
    doc #>> '{fields,group_follow_up,note_if_better}'::text[] AS note_if_better,
    doc #>> '{fields,group_follow_up,child_referred}'::text[] AS child_referred,
    doc #>> '{fields,group_follow_up,note_refer_to_health_facility}'::text[] AS note_refer_to_health_facility,
    doc #>> '{fields,group_follow_up,note_cured}'::text[] AS note_cured,
    doc #>> '{fields,group_key_health_messages,feeding_advice}'::text[] AS feeding_advice,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.parish,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
FROM dwh.cht_data d LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id 
  WHERE (doc ->> 'form'::text) = 'treatment_follow_up'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX treatment_follow_up_reported_idx ON cht.mv_treatment_follow_up USING btree (reported) tablespace ts_indexes;
CREATE INDEX treatment_follow_up_date_idx ON cht.mv_treatment_follow_up USING btree (date) tablespace ts_indexes;
CREATE INDEX treatment_follow_up_monthname_idx ON cht.mv_treatment_follow_up USING btree (monthname) tablespace ts_indexes;
CREATE INDEX mv_treatment_follow_up_year_month_district ON cht.mv_treatment_follow_up USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX treatment_follow_up_district_idx ON cht.mv_treatment_follow_up USING btree (district) tablespace ts_indexes;
CREATE INDEX treatment_follow_up_region_idx ON cht.mv_treatment_follow_up USING btree (region) tablespace ts_indexes;
CREATE INDEX treatment_follow_up_chw_id_idx ON cht.mv_treatment_follow_up USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX treatment_follow_up_facility_idx ON cht.mv_treatment_follow_up USING btree (facility) tablespace ts_indexes;
CREATE INDEX treatment_follow_up_dhis2_facility_id_idx ON cht.mv_treatment_follow_up USING btree (dhis2_facility_id) tablespace ts_indexes;
CREATE INDEX treatment_follow_up_village_idx ON cht.mv_treatment_follow_up USING btree (village) tablespace ts_indexes;


-- -------- mv_uncompleted_referral  (source: mv_uncompleted_referral.sql) --------
DROP MATERIALIZED VIEW cht.mv_uncompleted_referral;
CREATE MATERIALIZED VIEW cht.mv_uncompleted_referral
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
    doc #>> '{fields,inputs,t_tb_result}'::text[] AS t_tb_result,
    doc #>> '{fields,inputs,t_place_name}'::text[] AS t_place_name,
    doc #>> '{fields,inputs,t_patient_name}'::text[] AS t_patient_name,
    doc #>> '{fields,inputs,user,contact_id}'::text[] AS user_contact_id,
    doc #>> '{fields,inputs,user,facility_id}'::text[] AS user_facility_id,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    doc #>> '{fields,inputs,contact,date_of_birth}'::text[] AS inputs_contact_date_of_birth,
    doc #>> '{fields,inputs,contact,sex}'::text[] AS inputs_contact_sex,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,patient_name}'::text[] AS patient_name,
    doc #>> '{fields,tb_result}'::text[] AS tb_result,
    doc #>> '{fields,place_name}'::text[] AS place_name,
    doc #>> '{fields,needs_signoff}'::text[] AS needs_signoff,
    doc #>> '{fields,referral_notification,generated_note_name_25}'::text[] AS generated_note_name_25,
    doc #>> '{fields,referral_notification,referred_to_health_facility}'::text[] AS referred_to_health_facility,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.parish,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
FROM dwh.cht_data d LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id
  WHERE (doc ->> 'form'::text) = 'tb_uncompleted_referral'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX uncompleted_referral_reported_idx ON cht.mv_uncompleted_referral USING btree (reported) TABLESPACE ts_indexes;
CREATE INDEX uncompleted_referral_date_idx ON cht.mv_uncompleted_referral USING btree (date) TABLESPACE ts_indexes;
CREATE INDEX uncompleted_referral_monthname_idx ON cht.mv_uncompleted_referral USING btree (monthname) TABLESPACE ts_indexes;
CREATE INDEX mv_uncompleted_referral_year_month_district ON cht.mv_uncompleted_referral USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX uncompleted_referral_district_idx ON cht.mv_uncompleted_referral USING btree (district) TABLESPACE ts_indexes;
CREATE INDEX uncompleted_referral_region_idx ON cht.mv_uncompleted_referral USING btree (region) TABLESPACE ts_indexes;
CREATE INDEX uncompleted_referral_chw_id_idx ON cht.mv_uncompleted_referral USING btree (chw_id) TABLESPACE ts_indexes;
CREATE INDEX uncompleted_referral_facility_idx ON cht.mv_uncompleted_referral USING btree (facility) TABLESPACE ts_indexes;
CREATE INDEX uncompleted_referral_dhis2_facility_id_idx ON cht.mv_uncompleted_referral USING btree (dhis2_facility_id) TABLESPACE ts_indexes;
CREATE INDEX uncompleted_referral_village_idx ON cht.mv_uncompleted_referral USING btree (village) TABLESPACE ts_indexes;


-- -------- mv_unmute  (source: mv_unmute.sql) --------
DROP MATERIALIZED VIEW cht.mv_unmute;
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
      h.parish,
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


-- -------- mv_useview_ai_image_assessment  (source: mv_useview_ai_image_assessments.sql) --------
DROP MATERIALIZED VIEW cht.mv_useview_ai_image_assessment;
CREATE MATERIALIZED VIEW IF NOT EXISTS cht.mv_useview_ai_image_assessment TABLESPACE ts_report AS
SELECT
  doc ->> '_id'::TEXT AS uuid,
  doc #>> '{contact,_id}'::TEXT[] AS chw,
  to_timestamp((nullif(doc ->> 'reported_date'::TEXT, ''::TEXT)::BIGINT / 1000)::DOUBLE PRECISION) AS reported,
  (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY-MM-DD'))::date AS date,
  (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY'))::INT AS year,
  (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'MM'))::INT AS month,
    TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'FMMonth') AS monthname,
  doc #>> '{contact,_id}'::TEXT[] AS reported_by,
  doc #>> '{contact,parent,_id}'::TEXT[] AS reported_by_parent,
  doc #>> '{fields,inputs,meta,location,lat}' AS location_lat,
  doc #>> '{fields,inputs,meta,location,long}' AS location_long,
  doc #>> '{fields,inputs,meta,location,error}' AS location_error,
  doc #>> '{fields,inputs,meta,location,message}' AS location_message,
  doc #>> '{fields,inputs,source}' AS inputs_source,
  doc #>> '{fields,inputs,source_id}' AS inputs_source_id,
  doc #>> '{fields,inputs,contact,_id}' AS contact_id,
  doc #>> '{fields,inputs,contact,sex}' AS contact_sex,
  doc #>> '{fields,inputs,contact,name}' AS contact_name,
  nullif(doc #>> '{fields,inputs,contact,date_of_birth}', '')::DATE AS date_of_birth,
  --doc #>> '{fields,patient_id}' AS patient_id,
  doc #>> '{fields,inputs,contact,name}' AS inputs_patient_name,
  --doc #>> '{fields,patient_gender}' AS patient_gender,
  doc #>> '{fields,vaccines_received}'::text[] AS vaccines_received,
  doc #>> '{fields,vaccination_expected}'::text[] AS vaccination_expected,
  doc #>> '{fields,date_of_birth_local}'::text[] AS date_of_birth_local,
  doc #>> '{fields,visited_contact_uuid}'::text[] AS visited_contact_uuid,
  CASE
    WHEN (doc #>> '{fields,patient_age_in_days}'::text[]) = ''::text OR (doc #>> '{fields,patient_age_in_days}'::text[]) ~ 'NaN'::text 
      THEN 99
    ELSE (doc #>> '{fields,patient_age_in_days}'::text[])::integer
  END AS patient_age_in_days,
  CASE
    WHEN (doc #>> '{fields,patient_age_in_months}'::text[]) = ''::text OR (doc #>> '{fields,patient_age_in_months}'::text[]) ~ 'NaN'::text 
      THEN 99
    ELSE (doc #>> '{fields,patient_age_in_months}'::text[])::integer
  END AS patient_age_in_months,
  CASE
    WHEN (doc #>> '{fields,patient_age_in_years}'::text[]) = ''::text OR (doc #>> '{fields,patient_age_in_years}'::text[]) ~ 'NaN'::text 
      THEN 99
    ELSE (doc #>> '{fields,patient_age_in_years}'::text[])::integer
  END AS patient_age_in_years,
  doc #>> '{fields,patient_age_display}'::text[] AS patient_age_display,
  doc #>> '{fields,patient_id}'::text[] AS patient_id,
  doc #>> '{fields,patient_name}'::text[] AS patient_name,
  doc #>> '{fields,patient_gender}'::text[] AS patient_gender,
  doc #>> '{fields,launch_healthpulse}'::text[] AS launch_healthpulse,
  doc #>> '{fields,hide_healthpulse_section}'::text[] AS hide_healthpulse_section,
  doc #>> '{fields,show_mrdt_mismatch_note}'::text[] AS show_mrdt_mismatch_note,
  doc #>> '{fields,some_concern}'::text[] AS some_concern,
  doc #>> '{fields,should_escalate_to_chew}'::text[] AS should_escalate_to_chew,
  doc #>> '{fields,difference_in_results}'::text[] AS difference_in_results,
  doc #>> '{fields,show_malaria_screening_referral}'::text[] AS show_malaria_screening_referral,
  doc #>> '{fields,scanned_test_results}'::text[] AS scanned_test_results,
  doc #>> '{fields,captured_request_id}'::text[] AS captured_request_id,
  doc #>> '{fields,show_health_pulse_failed}'::text[] AS show_health_pulse_failed,
  doc #>> '{fields,is_mrdt_vht}'::text[] AS is_mrdt_vht,
  doc #>> '{fields,is_unblinded_mrdt_vht}'::text[] AS is_unblinded_mrdt_vht,
  doc #>> '{fields,group_vht_assessment_date,vht_assessment_date}' AS vht_assessment_date,
  doc #>> '{fields,group_fever,has_fever}'::text[] AS has_fever,
  doc #>> '{fields,group_fever,has_thermometer}'::text[] AS has_thermometer,
  doc #>> '{fields,group_fever,patient_temperature}'::text[] AS patient_temperature,
  doc #>> '{fields,group_fever,fever_duration}'::text[] AS fever_duration,
  doc #>> '{fields,group_fever,has_mrdt}'::text[] AS has_mrdt,
  doc #>> '{fields,group_fever,mrdt_usVSed_repeat}'::text[] AS mrdt_used_repeat,
  doc #>> '{fields,group_fever,mrdt_result_repeat}'::text[] AS mrdt_result_repeat,
  doc #>> '{fields,group_fever,why_mrdt_not_done_repeat}'::text[] AS why_mrdt_not_done_repeat,
  doc #>> '{fields,group_fever,want_to_repeat_mrdt}'::text[] AS want_to_repeat_mrdt,
  doc #>> '{fields,group_fever,has_mrdt_repeat_question}'::text[] AS has_mrdt_repeat_question,
  doc #>> '{fields,group_fever,mrdt_used_repeat_question}'::text[] AS mrdt_used_repeat_question,
  doc #>> '{fields,group_fever,mrdt_result_repeat_question}'::text[] AS mrdt_result_repeat_question,
  doc #>> '{fields,group_fever,why_mrdt_not_done_repeat_question}'::text[] AS why_mrdt_not_done_repeat_question,
  doc #>> '{fields,group_fever,refer_to_facililty_invalid_test}'::text[] AS refer_to_facililty_invalid_test,
  doc #>> '{fields,group_fever,photo_consent}'::text[] AS photo_consent,
  doc #>> '{fields,group_fever,mrdt_result}'::text[] AS mrdt_result,
  doc #>> '{fields,group_fever,mrdt_used}'::text[] AS mrdt_used,
  doc #>> '{fields,group_fever,why_mrdt_not_done}'::text[] AS why_mrdt_not_done,
  doc #>> '{fields,group_fever,note_mrdt_positive}'::text[] AS note_mrdt_positive,
  doc #>> '{fields,group_fever,fever_danger_sign}'::text[] AS fever_danger_sign,
  doc #>> '{fields,group_fever,mrdt_lock_state}'::text[] AS mrdt_lock_state,
  doc #>> '{fields,group_fever,locked_mrdt_result}'::text[] AS locked_mrdt_result,
  doc #>> '{fields,malaria_screening,concernsFlag}'::text[] AS concernsFlag,
  doc #>> '{fields,malaria_screening,storedConcernsFlag}'::text[] AS storedConcernsFlag,
  doc #>> '{fields,malaria_screening,storedClassification}'::text[] AS storedClassification,
  doc #>> '{fields,malaria_screening,storedImageUri}' AS storedImageUri,
  round(octet_length(doc #>> '{fields,malaria_screening,storedImageUri}')/1024.0/1024.0, 2) AS image_size_mb,
  doc #>> '{fields,malaria_screening,confirm_child_referral_mrdt_result}'::text[] AS confirm_child_referral_mrdt_result,
  doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.parish,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date 
FROM
  dwh.cht_data couchdb
  LEFT JOIN cht.mv_chw_hierarchy h ON (couchdb.doc #>> '{contact,_id}') = h.chw_id
WHERE
  doc ->> 'form' = 'assessment'
  AND is_current = true
  WITH NO DATA;


--SELECT deps_restore_dependencies('public', 'useview_ai_image_assessment');

/* adding indexes */
CREATE INDEX useview_ai_image_assessment_uuid ON cht.mv_useview_ai_image_assessment USING btree(uuid) TABLESPACE ts_indexes;

/* permissions */
--ALTER MATERIALIZED VIEW useview_ai_image_assessment OWNER TO vhtapp_access;
--GRANT SELECT ON useview_ai_image_assessment TO analytics;


-- -------- mv_useview_missing_mrdt_photo  (source: mv_useview_missing_mrdt_photo.sql) --------
DROP MATERIALIZED VIEW cht.mv_useview_missing_mrdt_photo;
CREATE MATERIALIZED VIEW cht.mv_useview_missing_mrdt_photo 
tablespace ts_report AS
SELECT
  doc #>> '{_id}' AS uuid,
  to_timestamp((nullif(doc ->> 'reported_date'::text, ''::text)::bigint / 1000)::double precision) AS reported,
  (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY-MM-DD'))::date AS date,
  (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY'))::INT AS year,
  (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'MM'))::INT AS month,
    TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'FMMonth') AS monthname,
  doc #>> '{contact,_id}'::text[] AS reported_by,
  doc #>> '{contact,parent,_id}'::text[] AS reported_by_parent,
  doc #>> '{fields,inputs,source}'::text[] AS source,
  doc #>> '{fields,inputs,source_id}'::text[] AS source_id,
  doc #>> '{fields,inputs,t_vht_name}'::text[] AS t_vht_name,
  doc #>> '{fields,inputs,t_vht_phone}'::text[] AS t_vht_phone,
  doc #>> '{fields,inputs,t_patient_name}'::text[] AS t_patient_name,
  doc #>> '{fields,inputs,user,contact_id}'::text[] AS contact_id,
  doc #>> '{fields,inputs,user,facility_id}'::text[] AS facility_id,
  doc #>> '{fields,inputs,contact,_id}'::text[] AS _id,
  doc #>> '{fields,inputs,contact,name}'::text[] AS name,
  doc #>> '{fields,inputs,contact,date_of_birth}'::text[] AS date_of_birth,
  doc #>> '{fields,inputs,contact,sex}'::text[] AS sex,
  doc #>> '{fields,patient_id}'::text[] AS patient_id,
  doc #>> '{fields,patient_name}'::text[] AS patient_name,
  doc #>> '{fields,needs_signoff}'::text[] AS needs_signoff,
  doc #>> '{fields,missing_mrdt_photo,indicate_support}'::text[] AS indicate_support,
 doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.parish,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date 
   FROM dwh.cht_data couchdb
    LEFT JOIN cht.mv_chw_hierarchy h ON (couchdb.doc #>> '{contact,_id}') = h.chw_id
WHERE
  doc ->> 'form' = 'missing_mrdt_photo'
  AND is_current = true 
  WITH NO DATA;

--SELECT deps_restore_dependencies('public', 'mv_useview_missing_mrdt_photo');

/* adding indexes */
CREATE INDEX mv_useview_missing_mrdt_photo_uuid ON cht.mv_useview_missing_mrdt_photo USING btree(uuid) tablespace ts_indexes;

/* permissions */
--ALTER MATERIALIZED VIEW cht.mv_useview_missing_mrdt_photo OWNER TO vhtapp_access;
--GRANT SELECT ON cht.mv_useview_missing_mrdt_photo TO analytics;


-- -------- mv_useview_mrdt_mismatch  (source: mv_useview_mrdt_mismatch.sql) --------
DROP MATERIALIZED VIEW cht.mv_useview_mrdt_mismatch;
CREATE MATERIALIZED VIEW cht.mv_useview_mrdt_mismatch
tablespace ts_report AS
SELECT
  doc #>> '{_id}' AS uuid,
  to_timestamp((nullif(doc ->> 'reported_date'::text, ''::text)::bigint / 1000)::double precision) AS reported,
  (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY-MM-DD'))::date AS date,
  (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY'))::INT AS year,
  (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'MM'))::INT AS month,
    TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'FMMonth') AS monthname,
  doc #>> '{contact,_id}'::text[] AS reported_by,
  doc #>> '{contact,parent,_id}'::text[] AS reported_by_parent,
  doc #>> '{fields,inputs,source}'::text[] AS source,
  doc #>> '{fields,inputs,source_id}'::text[] AS source_id,
  doc #>> '{fields,inputs,t_vht_name}'::text[] AS t_vht_name,
  doc #>> '{fields,inputs,t_vht_phone}'::text[] AS t_vht_phone,
  doc #>> '{fields,inputs,t_patient_name}'::text[] AS t_patient_name,
  doc #>> '{fields,inputs,t_vht_test_results}'::text[] AS t_vht_test_results,
  doc #>> '{fields,inputs,t_scanned_test_results}'::text[] AS t_scanned_test_results,
  doc #>> '{fields,inputs,user,contact_id}'::text[] AS contact_id,
  doc #>> '{fields,inputs,user,facility_id}'::text[] AS facility_id,
  doc #>> '{fields,inputs,contact,_id}'::text[] AS _id,
  doc #>> '{fields,inputs,contact,name}'::text[] AS name,
  doc #>> '{fields,inputs,contact,date_of_birth}'::text[] AS date_of_birth,
  doc #>> '{fields,inputs,contact,sex}'::text[] AS sex,
  doc #>> '{fields,patient_id}'::text[] AS patient_id,
  doc #>> '{fields,patient_name}'::text[] AS patient_name,
  doc #>> '{fields,needs_signoff}'::text[] AS needs_signoff,
  doc #>> '{fields,mrdt_discrepancy,vht_photo}'::text[] AS vht_photo,
  doc #>> '{fields,mrdt_discrepancy,confirm_mentorship}'::text[] AS confirm_mentorship,
  doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.parish,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date 
   FROM dwh.cht_data couchdb
  LEFT JOIN cht.mv_chw_hierarchy h ON (couchdb.doc #>> '{contact,_id}') = h.chw_id

WHERE
  doc ->> 'form' = 'mrdt_mismatch'
  AND is_current = true 
  WITH NO DATA;

--SELECT deps_restore_dependencies('public', 'mv_useview_mrdt_mismatch');

/* adding indexes */
CREATE INDEX mv_useview_mrdt_mismatch_uuid ON cht.mv_useview_mrdt_mismatch USING btree(uuid) tablespace ts_indexes;

/* permissions */
--ALTER MATERIALIZED VIEW cht.mv_useview_mrdt_mismatch OWNER TO vhtapp_access;
--GRANT SELECT ON cht.mv_useview_mrdt_mismatch TO analytics;


-- -------- mv_vht_consumption_log  (source: mv_vht_consumption_log.sql) --------
DROP MATERIALIZED VIEW cht.mv_vht_consumption_log;
CREATE MATERIALIZED VIEW cht.mv_vht_consumption_log
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
    doc #>> '{fields,act_item_received}'::text[] AS act_item_received,
    doc #>> '{fields,act_item_returned}'::text[] AS act_item_returned,
    doc #>> '{fields,zinc_item_received}'::text[] AS zinc_item_received,
    doc #>> '{fields,zinc_item_returned}'::text[] AS zinc_item_returned,
    doc #>> '{fields,amoxicillin_item_received}'::text[] AS amoxicillin_item_received,
    doc #>> '{fields,amoxicillin_item_returned}'::text[] AS amoxicillin_item_returned,
    doc #>> '{fields,malaria_rdts_item_received}'::text[] AS malaria_rdts_item_received,
    doc #>> '{fields,malaria_rdts_item_returned}'::text[] AS malaria_rdts_item_returned,
    doc #>> '{fields,pop_item_received}'::text[] AS pop_item_received,
    doc #>> '{fields,pop_item_returned}'::text[] AS pop_item_returned,
    doc #>> '{fields,dmpa_item_received}'::text[] AS dmpa_item_received,
    doc #>> '{fields,dmpa_item_returned}'::text[] AS dmpa_item_returned,
    doc #>> '{fields,misoprostol_item_received}'::text[] AS misoprostol_item_received,
    doc #>> '{fields,misoprostol_item_returned}'::text[] AS misoprostol_item_returned,
    doc #>> '{fields,coc_item_received}'::text[] AS coc_item_received,
    doc #>> '{fields,coc_item_returned}'::text[] AS coc_item_returned,
    doc #>> '{fields,condoms_item_received}'::text[] AS condoms_item_received,
    doc #>> '{fields,condoms_item_returned}'::text[] AS condoms_item_returned,
    doc #>> '{fields,contraceptives_item_received}'::text[] AS contraceptives_item_received,
    doc #>> '{fields,contraceptives_item_returned}'::text[] AS contraceptives_item_returned,
    doc #>> '{fields,rectal_item_received}'::text[] AS rectal_item_received,
    doc #>> '{fields,rectal_item_returned}'::text[] AS rectal_item_returned,
    doc #>> '{fields,sayana_item_received}'::text[] AS sayana_item_received,
    doc #>> '{fields,sayana_item_returned}'::text[] AS sayana_item_returned,
    doc #>> '{fields,gloves_item_received}'::text[] AS gloves_item_received,
    doc #>> '{fields,gloves_item_returned}'::text[] AS gloves_item_returned,
    doc #>> '{fields,is_mch_instance}'::text[] AS is_mch_instance,
    doc #>> '{fields,items,date}'::text[] AS items_date,
    doc #>> '{fields,items,reported_stock}'::text[] AS items_reported_stock,
    doc #>> '{fields,items,return_note}'::text[] AS items_return_note,
    doc #>> '{fields,items,receive_note}'::text[] AS items_receive_note,
    doc #>> '{fields,items_received,add_note}'::text[] AS items_received_add_note,
    doc #>> '{fields,items_received,act}'::text[] AS items_received_act,
    doc #>> '{fields,items_received,malaria_rdts}'::text[] AS items_received_malaria_rdts,
    doc #>> '{fields,items_received,rectal}'::text[] AS items_received_rectal,
    doc #>> '{fields,items_received,gloves}'::text[] AS items_received_gloves,
    doc #>> '{fields,items_received,zinc}'::text[] AS items_received_zinc,
    doc #>> '{fields,items_received,amoxicillin}'::text[] AS items_received_amoxicillin,
    doc #>> '{fields,items_received,pop}'::text[] AS items_received_pop,
    doc #>> '{fields,items_received,coc}'::text[] AS items_received_coc,
    doc #>> '{fields,items_received,contraceptives}'::text[] AS items_received_contraceptives,
    doc #>> '{fields,items_received,dmpa}'::text[] AS items_received_dmpa,
    doc #>> '{fields,items_received,condoms}'::text[] AS items_received_condoms,
    doc #>> '{fields,items_returned,return_note}'::text[] AS items_returned_return_note,
    doc #>> '{fields,items_returned,act_r}'::text[] AS items_returned_act_r,
    doc #>> '{fields,items_returned,malaria_rdts_r}'::text[] AS items_returned_malaria_rdts_r,
    doc #>> '{fields,items_returned,rectal_r}'::text[] AS items_returned_rectal_r,
    doc #>> '{fields,items_returned,gloves_r}'::text[] AS items_returned_gloves_r,
    doc #>> '{fields,items_returned,zinc_r}'::text[] AS items_returned_zinc_r,
    doc #>> '{fields,items_returned,amoxicillin_r}'::text[] AS items_returned_amoxicillin_r,
    doc #>> '{fields,items_returned,pop_r}'::text[] AS items_returned_pop_r,
    doc #>> '{fields,items_returned,coc_r}'::text[] AS items_returned_coc_r,
    doc #>> '{fields,items_returned,contraceptives_r}'::text[] AS items_returned_contraceptives_r,
    doc #>> '{fields,items_returned,dmpa_r}'::text[] AS items_returned_dmpa_r,
    doc #>> '{fields,items_returned,condoms_r}'::text[] AS items_returned_condoms_r,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.parish,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
FROM dwh.cht_data d LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id
  WHERE (doc ->> 'form'::text) = 'vht_consumption_log'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX mv_vht_consumption_log_chw_id ON cht.mv_vht_consumption_log USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX mv_vht_consumption_log_reported ON cht.mv_vht_consumption_log USING btree (reported) tablespace ts_indexes;
CREATE INDEX mv_vht_consumption_log_date ON cht.mv_vht_consumption_log USING btree (date) tablespace ts_indexes;
CREATE INDEX mv_vht_consumption_log_monthname ON cht.mv_vht_consumption_log USING btree (monthname) tablespace ts_indexes;
CREATE INDEX mv_vht_consumption_log_year_month_district ON cht.mv_vht_consumption_log USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX mv_vht_consumption_log_district ON cht.mv_vht_consumption_log USING btree (district) tablespace ts_indexes;
CREATE INDEX mv_vht_consumption_log_region ON cht.mv_vht_consumption_log USING btree (region) tablespace ts_indexes;
CREATE INDEX mv_vht_consumption_log_facility ON cht.mv_vht_consumption_log USING btree (facility) tablespace ts_indexes;  
CREATE INDEX mv_vht_consumption_log_dhis2_facility_id ON cht.mv_vht_consumption_log USING btree (dhis2_facility_id) tablespace ts_indexes;
CREATE INDEX mv_vht_consumption_log_village ON cht.mv_vht_consumption_log USING btree (village) tablespace ts_indexes;


-- -------- mv_vht_home_location  (source: mv_vht_home_location.sql) --------
DROP MATERIALIZED VIEW cht.mv_vht_home_location;
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
      h.parish,
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


-- -------- mv_wash_report  (source: mv_wash_report.sql) --------
DROP MATERIALIZED VIEW cht.mv_wash_report;
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
      h.parish,
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


--==========tier_1b : WITH dependents (DROP ... CASCADE)==========--
-- Run AFTER tier_1a. Each CASCADE drops the MV plus its dependent matview(s).
-- You are recreating those dependents manually.

-- -------- mv_person  (source: mv_person.sql) --------
-- NOTE: mv_integrated_echis_performace depends on this MV; the CASCADE below also DROPs it.
--       Remember to recreate that dependent MV afterwards (noted by you).
DROP MATERIALIZED VIEW cht.mv_person CASCADE;
CREATE MATERIALIZED VIEW cht.mv_person
TABLESPACE ts_report
AS SELECT doc ->> '_id'::text AS doc_id,
    doc ->> '_rev'::text AS rev,
    doc ->> 'imported_date'::text AS imported_date,
    to_timestamp((NULLIF(doc ->> 'reported_date'::text, ''::text)::bigint / 1000)::double precision) AS reported,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY-MM-DD'))::date AS date,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY'))::INT AS year,
    to_char(to_timestamp((((doc ->>'reported_date'::text)::bigint) / 1000)::double precision), 'MM'::text)::integer AS month,
    TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'FMMonth') AS monthname,
    doc ->> 'type'::text AS type,
    doc ->> 'household_id'::text AS household_id,
    doc ->> 'name'::text AS name,
    doc ->> 'date_of_birth'::text AS date_of_birth,
    doc ->> 'sex'::text AS sex,
    doc ->> 'today_d'::text AS today_d,
    doc ->> 'c_name'::text AS c_name,
    doc ->> 'notes'::text AS notes,
    doc ->> 'c_sex'::text AS c_sex,
    doc ->> 'dob_method'::text AS dob_method,
    doc ->> 'dob_calendar'::text AS dob_calendar,
    doc ->> 'age_years'::text AS age_years,
    doc ->> 'ephemeral_years'::text AS ephemeral_years,
    doc ->> 'dob_approx'::text AS dob_approx,
    doc ->> 'dob_raw'::text AS dob_raw,
    doc ->> 'c_dob_iso'::text AS c_dob_iso,
    doc ->> 'c_dob_debug'::text AS c_dob_debug,
    doc ->> 'current_age'::text AS current_age,
    doc ->> 'date_vht_visit'::text AS date_vht_visit,
    doc ->> 'has_disability'::text AS has_disability,
    doc ->> 'test_for_hiv_last3months'::text AS test_for_hiv_last3months,
    doc ->> 'hiv_test_result'::text AS hiv_test_result,
    doc ->> 'on_art_treatment'::text AS on_art_treatment,
    doc ->> 'has_tb'::text AS has_tb,
    doc ->> 'on_tb_treatment'::text AS on_tb_treatment,
    doc ->> 'current_fp_method'::text AS current_fp_method,
    doc ->> 'current_fp_method_label'::text AS current_fp_method_label,
    doc ->> 'phone'::text AS phone,
    doc ->> 'phone2'::text AS phone2,
    doc ->> 'p_date_vht_visit'::text AS p_date_vht_visit,
    doc ->> 'relationship_with_hh'::text AS relationship_with_hh,
    doc ->> 'other_relationship'::text AS other_relationship,
    doc ->> 'client_category'::text AS client_category,
    doc ->> 'national_identification_number'::text AS national_identification_number,
    doc ->> 'refugee_identification_number'::text AS refugee_identification_number,
    doc ->> 'p_has_disability'::text AS p_has_disability,
    doc ->> 'disability'::text AS disability,
    doc ->> 'assistive_tech'::text AS assistive_tech,
    doc ->> 'rehabilitation'::text AS rehabilitation,
    doc ->> 'afp_vpd'::text AS afp_vpd,
    doc ->> 'refer_afp'::text AS refer_afp,
    doc ->> 'child_in_school'::text AS child_in_school,
    doc ->> 'p_test_for_hiv_last3months'::text AS p_test_for_hiv_last3months,
    doc ->> 'hiv_test_result_label'::text AS hiv_test_result_label,
    doc ->> 'p_hiv_test_result'::text AS p_hiv_test_result,
    doc ->> 'p_on_art_treatment'::text AS p_on_art_treatment,
    doc ->> 'note_attend_art_clinic'::text AS note_attend_art_clinic,
    doc ->> 'taking_medication'::text AS taking_medication,
    doc ->> 'note_explain_importance_taking_med'::text AS note_explain_importance_taking_med,
    doc ->> 'note_encourage_to_continue_taking_med'::text AS note_encourage_to_continue_taking_med,
    doc ->> 'note_encourage_client'::text AS note_encourage_client,
    doc ->> 'note_advise_client_check_status'::text AS note_advise_client_check_status,
    doc ->> 'note_advise_client_check_status2'::text AS note_advise_client_check_status2,
    doc ->> 'p_has_tb'::text AS p_has_tb,
    doc ->> 'p_on_tb_treatment'::text AS p_on_tb_treatment,
    doc ->> 'note_tb_referral'::text AS note_tb_referral,
    doc ->> 'received_hpv_'::text AS received_hpv_,
    doc ->> 'hpv_card'::text AS hpv_card,
    doc ->> 'received_hpv'::text AS received_hpv,
    doc ->> 'check_hpv_note'::text AS check_hpv_note,
    doc ->> 'educate_hpv_note'::text AS educate_hpv_note,
    doc ->> 'refer_hpv'::text AS refer_hpv,
    doc ->> 'received_tt_vaccine'::text AS received_tt_vaccine,
    doc ->> 'takes_alcohol'::text AS takes_alcohol,
    doc ->> 'has_hypertension'::text AS has_hypertension,
    doc ->> 'has_sickle_cell'::text AS has_sickle_cell,
    doc ->> 'uses_tobacco'::text AS uses_tobacco,
    doc ->> 'sleep_under_llin'::text AS sleep_under_llin,
    doc ->> 'why_not_using_llin'::text AS why_not_using_llin,
    doc ->> 'why_not_using_llin_other'::text AS why_not_using_llin_other,
    doc ->> 'note_vht_assist_how_to_get_llin'::text AS note_vht_assist_how_to_get_llin,
    doc ->> 'note_vht_demonstrate_on_llin_use'::text AS note_vht_demonstrate_on_llin_use,
    doc ->> 'using_fp_method'::text AS using_fp_method,
    doc ->> 'fp_method'::text AS fp_method,
    doc ->> 'note_fp_registration'::text AS note_fp_registration,
    doc #>> '{parent,_id}'::text[] AS household_id_2,
    doc #>> '{contact,_id}'                         AS vht_area_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.parish,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
FROM dwh.cht_data d
LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{parent,parent,_id}') = h.vht_area_id
  WHERE (doc ->> 'type'::text) = 'person'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX person_doc_id_idx ON cht.mv_person USING btree (doc_id) tablespace ts_indexes;
CREATE INDEX person_household_id_idx ON cht.mv_person USING btree (household_id) tablespace ts_indexes;
CREATE INDEX person_reported_idx ON cht.mv_person USING btree (reported) tablespace ts_indexes;
CREATE INDEX person_vht_area_id_idx ON cht.mv_person USING btree (vht_area_id) tablespace ts_indexes;
CREATE INDEX person_district_idx ON cht.mv_person USING btree (district) tablespace ts_indexes;
CREATE INDEX person_dhis2_facility_id_idx ON cht.mv_person USING btree (dhis2_facility_id) tablespace ts_indexes;
CREATE INDEX person_facility_idx ON cht.mv_person USING btree (facility) tablespace ts_indexes;
CREATE INDEX person_district ON cht.mv_person USING btree (district) tablespace ts_indexes;
CREATE INDEX person_region ON cht.mv_person USING btree (region) tablespace ts_indexes;
CREATE INDEX person_village ON cht.mv_person USING btree (village) tablespace ts_indexes;


-- -------- mv_screening  (source: mv_screening.sql) --------
-- NOTE: mv_integrated_echis_performace depends on this MV; the CASCADE below also DROPs it.
--       Remember to recreate that dependent MV afterwards (noted by you).
DROP MATERIALIZED VIEW cht.mv_screening CASCADE;
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
      h.parish,
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


-- -------- mv_delivery  (source: mv_delivery.sql) --------
-- NOTE: mv_delivery_report depends on this MV; the CASCADE below also DROPs it.
--       Remember to recreate that dependent MV afterwards (noted by you).
DROP MATERIALIZED VIEW cht.mv_delivery CASCADE;
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
    NULLIF((d.doc -> 'geolocation'::text) ->> 'latitude'::text, ''::text)::double precision AS geolocation_latitude,
    NULLIF((d.doc -> 'geolocation'::text) ->> 'longitude'::text, ''::text)::double precision AS geolocation_longitude,
    NULLIF((d.doc -> 'geolocation'::text) ->> 'accuracy'::text, ''::text)::double precision AS geolocation_accuracy,
    NULLIF((d.doc -> 'geolocation'::text) ->> 'altitude'::text, ''::text)::double precision AS geolocation_altitude,
    NULLIF((d.doc -> 'geolocation'::text) ->> 'altitudeAccuracy'::text, ''::text)::double precision AS geolocation_altitude_accuracy,
    NULLIF((d.doc -> 'geolocation'::text) ->> 'speed'::text, ''::text)::double precision AS geolocation_speed,
    NULLIF((d.doc -> 'geolocation'::text) ->> 'heading'::text, ''::text)::double precision AS geolocation_heading,
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
    h.dhis2_facility_id,
    h.village,
    h.parish,
    h.district,
    h.region,
    CURRENT_TIMESTAMP AS last_refresh_date
   FROM dwh.cht_data d
     LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}'::text[]) = h.chw_id
  WHERE (d.doc ->> 'form'::text) = 'delivery'::text AND d.is_current = true
WITH NO DATA;

-- View indexes:
CREATE INDEX mv_delivery_chw_id ON cht.mv_delivery USING btree (chw_id) TABLESPACE ts_indexes;
CREATE INDEX mv_delivery_date ON cht.mv_delivery USING btree (date) TABLESPACE ts_indexes;
CREATE INDEX mv_delivery_district ON cht.mv_delivery USING btree (district) TABLESPACE ts_indexes;
CREATE INDEX mv_delivery_facility ON cht.mv_delivery USING btree (facility) TABLESPACE ts_indexes;
CREATE INDEX mv_delivery_inputs_contact_id ON cht.mv_delivery USING btree (inputs_contact_id) TABLESPACE ts_indexes;
CREATE INDEX mv_delivery_reported ON cht.mv_delivery USING btree (reported) TABLESPACE ts_indexes;
CREATE INDEX mv_delivery_year_month_district ON cht.mv_delivery USING btree (year, month, district) TABLESPACE ts_indexes;


-- -------- mv_pregnancy  (source: mv_pregnancy.sql) --------
-- NOTE: mv_delivery_report depends on this MV; the CASCADE below also DROPs it.
--       Remember to recreate that dependent MV afterwards (noted by you).
DROP MATERIALIZED VIEW cht.mv_pregnancy CASCADE;
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
    NULLIF((d.doc -> 'geolocation'::text) ->> 'latitude'::text, ''::text)::double precision AS geolocation_latitude,
    NULLIF((d.doc -> 'geolocation'::text) ->> 'longitude'::text, ''::text)::double precision AS geolocation_longitude,
    NULLIF((d.doc -> 'geolocation'::text) ->> 'accuracy'::text, ''::text)::double precision AS geolocation_accuracy,
    NULLIF((d.doc -> 'geolocation'::text) ->> 'altitude'::text, ''::text)::double precision AS geolocation_altitude,
    NULLIF((d.doc -> 'geolocation'::text) ->> 'altitudeAccuracy'::text, ''::text)::double precision AS geolocation_altitude_accuracy,
    NULLIF((d.doc -> 'geolocation'::text) ->> 'speed'::text, ''::text)::double precision AS geolocation_speed,
    NULLIF((d.doc -> 'geolocation'::text) ->> 'heading'::text, ''::text)::double precision AS geolocation_heading,
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
    h.dhis2_facility_id,
    h.village,
    h.parish,
    h.district,
    h.region,
    CURRENT_TIMESTAMP AS last_refresh_date
   FROM dwh.cht_data d
     LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}'::text[]) = h.chw_id
  WHERE (d.doc ->> 'form'::text) = 'pregnancy'::text AND d.is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX pregnancy_date_idx ON cht.mv_pregnancy USING btree (date) TABLESPACE ts_indexes;
CREATE INDEX pregnancy_district_idx ON cht.mv_pregnancy USING btree (district) TABLESPACE ts_indexes;
CREATE INDEX pregnancy_monthname_idx ON cht.mv_pregnancy USING btree (monthname) TABLESPACE ts_indexes;
CREATE INDEX pregnancy_region_idx ON cht.mv_pregnancy USING btree (region) TABLESPACE ts_indexes;
CREATE INDEX pregnancy_reported_idx ON cht.mv_pregnancy USING btree (reported) TABLESPACE ts_indexes;
CREATE INDEX pregnancy_village_idx ON cht.mv_pregnancy USING btree (village) TABLESPACE ts_indexes;
CREATE INDEX pregnancy_year_month_district_idx ON cht.mv_pregnancy USING btree (year, month, district) TABLESPACE ts_indexes;


--==========tier_2==========--
-- Dependent matviews dropped by the CASCADEs above - recreate these manually:
--   cht.mv_integrated_echis_performance  (mv_integrated_echis_performace.sql)
--   cht.mv_delivery_report               (mv_delivery_report.sql)
--   delivery_report                      (albert_delivery_report.sql, if deployed)
-- Also out of scope for parish: mv_chew_performance, mv_vht_supervision.
