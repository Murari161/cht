-- cht.mv_anc_danger_sign_follow_up source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_anc_danger_sign_follow_up;
CREATE MATERIALIZED VIEW cht.mv_anc_danger_sign_follow_up
TABLESPACE ts_report
AS SELECT doc_id,
    rev_id,
    ((doc -> 'fields'::text) -> 'meta'::text) ->> 'instanceID'::text AS instanceid,
    ((doc -> 'fields'::text) -> 'meta'::text) ->> 'deprecatedID'::text AS deprecatedid,
    (doc -> 'geolocation'::text) ->> 'speed'::text AS speed,
    (doc -> 'geolocation'::text) ->> 'heading'::text AS heading,
    (doc -> 'geolocation'::text) ->> 'accuracy'::text AS accuracy,
    (doc -> 'geolocation'::text) ->> 'altitude'::text AS altitude,
    (doc -> 'geolocation'::text) ->> 'latitude'::text AS latitude,
    (doc -> 'geolocation'::text) ->> 'longitude'::text AS longitude,
    (doc -> 'geolocation'::text) ->> 'altitudeAccuracy'::text AS altitudeaccuracy,
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
  WHERE d.type = 'data_record'::text AND (d.doc ->> 'form'::text) = 'anc_danger_sign_escalation'::text AND d.is_current IS TRUE
WITH DATA;

CREATE UNIQUE INDEX idx_mv_anc_danger_sign_follow_up_doc_id_rev_id
  ON cht.mv_anc_danger_sign_follow_up (doc_id, rev_id);
CREATE INDEX idx_mv_anc_danger_sign_follow_up_chw_id
  ON cht.mv_anc_danger_sign_follow_up (chw_id);
CREATE INDEX idx_mv_anc_danger_sign_follow_up_reported
  ON cht.mv_anc_danger_sign_follow_up (reported);
CREATE INDEX idx_mv_anc_danger_sign_follow_up_date
  ON cht.mv_anc_danger_sign_follow_up (date);
CREATE INDEX idx_mv_anc_danger_sign_follow_up_year
  ON cht.mv_anc_danger_sign_follow_up (year);
CREATE INDEX idx_mv_anc_danger_sign_follow_up_month
  ON cht.mv_anc_danger_sign_follow_up (month);
CREATE INDEX idx_mv_anc_danger_sign_follow_up_monthname
  ON cht.mv_anc_danger_sign_follow_up (monthname);