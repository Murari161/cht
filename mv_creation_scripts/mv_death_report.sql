-- cht.mv_death_report source
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
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date
   FROM dwh.cht_data
LEFT JOIN cht.mv_chw_hierarchy h ON (doc #>> '{contact,_id}') = h.vht_area_id
  WHERE (doc ->> 'form'::text) = 'death_report'::text AND is_current
WITH DATA;

-- View indexes:
CREATE INDEX mv_death_report_vht_area_id ON cht.mv_death_report USING btree (vht_area_id) tablespace ts_indexes;
CREATE INDEX mv_death_report_reported_new ON cht.mv_death_report USING btree (reported) tablespace ts_indexes;
CREATE INDEX mv_death_report_year_month ON cht.mv_death_report USING btree (year, month) tablespace ts_indexes;
CREATE INDEX mv_death_report_date_of_death ON cht.mv_death_report USING btree (date_of_death) tablespace ts_indexes;
CREATE INDEX mv_death_report_district ON cht.mv_death_report USING btree (district) tablespace ts_indexes;
CREATE INDEX mv_death_report_facility ON cht.mv_death_report USING btree (facility) tablespace ts_indexes; 
CREATE INDEX mv_death_report_patient_id ON cht.mv_death_report USING btree (patient_id) tablespace ts_indexes;