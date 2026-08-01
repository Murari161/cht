-- cht.mv_treatment_follow_up source
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
