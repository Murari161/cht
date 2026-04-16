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
      h.facility_name,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
FROM dwh.cht_data d
LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id
  WHERE (doc ->> 'form'::text) = 'sdx_follow_up'::text AND is_current
WITH DATA;

-- View indexes:
CREATE INDEX mv_sdx_follow_up_chw_id ON cht.mv_sdx_follow_up USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX mv_sdx_follow_up_reported ON cht.mv_sdx_follow_up USING btree (reported) tablespace ts_indexes;
CREATE INDEX mv_sdx_follow_up_date ON cht.mv_sdx_follow_up USING btree (date) tablespace ts_indexes;
CREATE INDEX mv_sdx_follow_up_year ON cht.mv_sdx_follow_up USING btree (year) tablespace ts_indexes;
CREATE INDEX mv_sdx_follow_up_month ON cht.mv_sdx_follow_up USING btree (month) tablespace ts_indexes;
CREATE INDEX mv_sdx_follow_up_monthname ON cht.mv_sdx_follow_up USING btree (monthname) tablespace ts_indexes;
CREATE INDEX mv_sdx_follow_up_district ON cht.mv_sdx_follow_up USING btree (district) tablespace ts_indexes;
CREATE INDEX mv_sdx_follow_up_region ON cht.mv_sdx_follow_up USING btree (region) tablespace ts_indexes;
CREATE INDEX mv_sdx_follow_up_facility_name ON cht.mv_sdx_follow_up USING btree (facility_name) tablespace ts_indexes;
CREATE INDEX mv_sdx_follow_up_dhis2_facility_id ON cht.mv_sdx_follow_up USING btree (dhis2_facility_id) tablespace ts_indexes;
CREATE INDEX mv_sdx_follow_up_village ON cht.mv_sdx_follow_up USING btree (village) tablespace ts_indexes;