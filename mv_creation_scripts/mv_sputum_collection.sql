-- cht.mv_sputum_collection source
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
      h.facility_name,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
FROM dwh.cht_data d
LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id
  WHERE (doc ->> 'form'::text) = 'sputum_collection'::text AND is_current
WITH DATA;

-- View indexes:
CREATE INDEX mv_sputum_collection_chw_id ON cht.mv_sputum_collection USING btree (chw_id) Tablespace ts_indexes;
CREATE INDEX mv_sputum_collection_reported ON cht.mv_sputum_collection USING btree (reported) Tablespace ts_indexes;
CREATE INDEX mv_sputum_collection_date ON cht.mv_sputum_collection USING btree (date) Tablespace ts_indexes;
CREATE INDEX mv_sputum_collection_year ON cht.mv_sputum_collection USING btree (year) Tablespace ts_indexes;
CREATE INDEX mv_sputum_collection_month ON cht.mv_sputum_collection USING btree (month) Tablespace ts_indexes;
CREATE INDEX mv_sputum_collection_monthname ON cht.mv_sputum_collection USING btree (monthname) Tablespace ts_indexes;
CREATE INDEX mv_sputum_collection_district ON cht.mv_sputum_collection USING btree (district) Tablespace ts_indexes;
CREATE INDEX mv_sputum_collection_region ON cht.mv_sputum_collection USING btree (region) Tablespace ts_indexes;
CREATE INDEX mv_sputum_collection_facility_name ON cht.mv_sputum_collection USING btree (facility_name) Tablespace ts_indexes;
CREATE INDEX mv_sputum_collection_dhis2_facility_id ON cht.mv_sputum_collection USING btree (dhis2_facility_id) Tablespace ts_indexes;
CREATE INDEX mv_sputum_collection_village ON cht.mv_sputum_collection USING btree (village) Tablespace ts_indexes;