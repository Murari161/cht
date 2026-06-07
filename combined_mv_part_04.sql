-- =====================================================================
-- Combined MV creation - PART 04 of 06  (10 views)
-- Generated: 2026-06-07 | Assumes cht.mv_chw_hierarchy exists | all WITH NO DATA
-- Each view is preceded by DROP MATERIALIZED VIEW IF EXISTS (no CASCADE)
-- Files in this part:
--   mv_referral_follow_up.sql
--   mv_sdx_follow_up.sql
--   mv_sdx_notify.sql
--   mv_sdx_trigger.sql
--   mv_sputum_collection.sql
--   mv_sputum_collection_refusal.sql
--   mv_stock_count.sql
--   mv_stockout.sql
--   mv_support_supervision.sql
--   mv_tb_follow_up.sql
-- =====================================================================


-- ---------------------------------------------------------------------
-- SOURCE: mv_referral_follow_up.sql
-- ---------------------------------------------------------------------

-- cht.mv_referral_follow_up source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_referral_follow_up;
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

-- ---------------------------------------------------------------------
-- SOURCE: mv_sdx_follow_up.sql
-- ---------------------------------------------------------------------

-- cht.mv_sdx_follow_up source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_sdx_follow_up;
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

-- ---------------------------------------------------------------------
-- SOURCE: mv_sdx_notify.sql
-- ---------------------------------------------------------------------

-- cht.mv_sdx_notify source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_sdx_notify;
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

-- ---------------------------------------------------------------------
-- SOURCE: mv_sdx_trigger.sql
-- ---------------------------------------------------------------------

-- cht.mv_sdx_trigger source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_sdx_trigger;
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

-- ---------------------------------------------------------------------
-- SOURCE: mv_sputum_collection.sql
-- ---------------------------------------------------------------------

-- cht.mv_sputum_collection source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_sputum_collection;
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

-- ---------------------------------------------------------------------
-- SOURCE: mv_sputum_collection_refusal.sql
-- ---------------------------------------------------------------------

-- cht.mv_sputum_collection_refusal source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_sputum_collection_refusal;
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

-- ---------------------------------------------------------------------
-- SOURCE: mv_stock_count.sql
-- ---------------------------------------------------------------------

-- cht.mv_stock_count source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_stock_count;
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

-- ---------------------------------------------------------------------
-- SOURCE: mv_stockout.sql
-- ---------------------------------------------------------------------

-- cht.mv_stockout source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_stockout;
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

-- ---------------------------------------------------------------------
-- SOURCE: mv_support_supervision.sql
-- ---------------------------------------------------------------------

-- cht.mv_support_supervision source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_support_supervision;
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

-- ---------------------------------------------------------------------
-- SOURCE: mv_tb_follow_up.sql
-- ---------------------------------------------------------------------

-- cht.mv_tb_follow_up source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_tb_follow_up;
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
