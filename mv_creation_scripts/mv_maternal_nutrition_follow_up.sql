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
      h.facility_name,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date
   FROM dwh.cht_data couchdb
    LEFT JOIN cht.mv_chw_hierarchy h ON (couchdb.doc #>> '{contact,_id}') = h.chw_id
  WHERE (doc ->> 'form'::text) = 'maternal_nutrition_follow_up'::text AND is_current
WITH DATA;

-- View indexes:
CREATE INDEX maternal_nutrition_follow_up_reported_idx ON cht.mv_maternal_nutrition_follow_up USING btree (reported) tablespace ts_indexes;
CREATE INDEX maternal_nutrition_follow_up_date_idx ON cht.mv_maternal_nutrition_follow_up USING btree (date) tablespace ts_indexes;
CREATE INDEX maternal_nutrition_follow_up_year_idx ON cht.mv_maternal_nutrition_follow_up USING btree (year) tablespace ts_indexes;
CREATE INDEX maternal_nutrition_follow_up_month_idx ON cht.mv_maternal_nutrition_follow_up USING btree (month) tablespace ts_indexes;
CREATE INDEX maternal_nutrition_follow_up_monthname_idx ON cht.mv_maternal_nutrition_follow_up USING btree (monthname) tablespace ts_indexes;
CREATE INDEX maternal_nutrition_follow_up_chw_id_idx ON cht.mv_maternal_nutrition_follow_up USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX maternal_nutrition_follow_up_facility_name_idx ON cht.mv_maternal_nutrition_follow_up USING btree (facility_name) tablespace ts_indexes;
CREATE INDEX maternal_nutrition_follow_up_dhis2_facility_id_idx ON cht.mv_maternal_nutrition_follow_up USING btree (dhis2_facility_id) tablespace ts_indexes;
CREATE INDEX maternal_nutrition_follow_up_district_idx ON cht.mv_maternal_nutrition_follow_up USING btree (district) tablespace ts_indexes;
CREATE INDEX maternal_nutrition_follow_up_region_idx ON cht.mv_maternal_nutrition_follow_up USING btree (region) tablespace ts_indexes;