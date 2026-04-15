-- cht.mv_child_health_escalation source

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
      h.facility_name,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
   FROM dwh.cht_data couchdb
LEFT JOIN cht.mv_chw_hierarchy h ON (couchdb.doc #>> '{contact,_id}') = h.chw_id
  WHERE (doc ->> 'form'::text) = 'child_health_escalation'::text AND is_current
WITH DATA;

-- View indexes:
CREATE INDEX mv_child_health_escalation_patient ON cht.mv_child_health_escalation USING btree (patient_id) tablespace ts_indexes;
CREATE INDEX mv_child_health_escalation_reported ON cht.mv_child_health_escalation USING btree (reported) tablespace ts_indexes;
CREATE INDEX mv_child_health_escalation_chw_id ON cht.mv_child_health_escalation USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX mv_child_health_escalation_district ON cht.mv_child_health_escalation USING btree (district) tablespace ts_indexes;
CREATE INDEX mv_child_health_escalation_facility ON cht.mv_child_health_escalation USING btree (facility_name) tablespace ts_indexes; 
CREATE INDEX mv_child_health_escalation_year_month ON cht.mv_child_health_escalation USING btree (year, month) tablespace ts_indexes;  