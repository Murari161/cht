-- cht.mv_child_nutrition_follow_up source
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
