-- cht.mv_tb_follow_up source
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