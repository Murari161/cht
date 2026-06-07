-- =====================================================================
-- Combined MV creation - PART 05 of 06  (10 views)
-- Generated: 2026-06-07 | Assumes cht.mv_chw_hierarchy exists | all WITH NO DATA
-- Each view is preceded by DROP MATERIALIZED VIEW IF EXISTS (no CASCADE)
-- Files in this part:
--   mv_tb_referral_follow_up.sql
--   mv_tb_results_notification.sql
--   mv_tb_screening.sql
--   mv_tb_uncompleted_referral.sql
--   mv_training_evaluation.sql
--   mv_treatment_follow_up.sql
--   mv_uncompleted_referral.sql
--   mv_vht_consumption_log.sql
--   mv_vht_supervision.sql
--   mv_pregnancy_danger_sign_follow_up.sql
-- =====================================================================


-- ---------------------------------------------------------------------
-- SOURCE: mv_tb_referral_follow_up.sql
-- ---------------------------------------------------------------------

-- cht.mv_tb_referral_follow_up source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_tb_referral_follow_up;
CREATE MATERIALIZED VIEW cht.mv_tb_referral_follow_up
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
    doc #>> '{fields,inputs,t_tb_result}'::text[] AS t_tb_result,
    doc #>> '{fields,inputs,user,contact_id}'::text[] AS user_contact_id,
    doc #>> '{fields,inputs,user,facility_id}'::text[] AS user_facility_id,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    doc #>> '{fields,inputs,contact,date_of_birth}'::text[] AS inputs_contact_date_of_birth,
    doc #>> '{fields,inputs,contact,sex}'::text[] AS inputs_contact_sex,
    doc #>> '{fields,inputs,contact,parent,_id}'::text[] AS parent__id,
    doc #>> '{fields,inputs,contact,parent,name}'::text[] AS inputs_parent_name,
    doc #>> '{fields,inputs,contact,parent,parent,_id}'::text[] AS parent_parent__id,
    doc #>> '{fields,inputs,contact,parent,parent,name}'::text[] AS parent_parent_name,
    doc #>> '{fields,inputs,contact,parent,parent,supervisor}'::text[] AS supervisor,
    doc #>> '{fields,inputs,contact,parent,parent,phone}'::text[] AS phone,
    doc #>> '{fields,inputs,contact,parent,parent,village}'::text[] AS inputs_village,
    doc #>> '{fields,inputs,contact,parent,parent,contact,_id}'::text[] AS contact__id,
    doc #>> '{fields,inputs,contact,parent,parent,contact,phone}'::text[] AS contact_phone,
    doc #>> '{fields,inputs,contact,parent,parent,contact,name}'::text[] AS inputs_contact_name_2,
    doc #>> '{fields,inputs,contact,parent,parent,parent,_id}'::text[] AS parent_parent_parent__id,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,patient_name}'::text[] AS patient_name,
    doc #>> '{fields,patient_gender}'::text[] AS patient_gender,
    doc #>> '{fields,patient_age_in_years}'::text[] AS patient_age_in_years,
    doc #>> '{fields,patient_age_in_months}'::text[] AS patient_age_in_months,
    doc #>> '{fields,patient_age_in_days}'::text[] AS patient_age_in_days,
    doc #>> '{fields,patient_age_display}'::text[] AS patient_age_display,
    doc #>> '{fields,patient_pronoun}'::text[] AS patient_pronoun,
    doc #>> '{fields,place_name}'::text[] AS place_name,
    doc #>> '{fields,needs_signoff}'::text[] AS needs_signoff,
    doc #>> '{fields,treatment_information,patient_started_treatment}'::text[] AS patient_started_treatment,
    doc #>> '{fields,treatment_information,treatment_date}'::text[] AS treatment_date,
    doc #>> '{fields,referral_notification,encourage_to_to_facility}'::text[] AS encourage_to_to_facility,
    doc #>> '{fields,referral_notification,referred_to_health_facility}'::text[] AS referred_to_health_facility,
    doc #>> '{fields,referral_notification,went_to_facility_as_referred}'::text[] AS went_to_facility_as_referred,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
FROM dwh.cht_data d LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id 
  WHERE (doc ->> 'form'::text) = 'tb_referral_follow_up'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX tb_referral_follow_up_reported_idx ON cht.mv_tb_referral_follow_up USING btree (reported) tablespace ts_indexes;
CREATE INDEX tb_referral_follow_up_date_idx ON cht.mv_tb_referral_follow_up USING btree (date) tablespace ts_indexes;
CREATE INDEX tb_referral_follow_up_monthname_idx ON cht.mv_tb_referral_follow_up USING btree (monthname) tablespace ts_indexes;
CREATE INDEX mv_tb_referral_follow_up_year_month_district ON cht.mv_tb_referral_follow_up USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX tb_referral_follow_up_chw_id_idx ON cht.mv_tb_referral_follow_up USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX tb_referral_follow_up_facility_idx ON cht.mv_tb_referral_follow_up USING btree (facility) tablespace ts_indexes;
CREATE INDEX tb_referral_follow_up_dhis2_facility_id_idx ON cht.mv_tb_referral_follow_up USING btree (dhis2_facility_id) tablespace ts_indexes;
CREATE INDEX tb_referral_follow_up_village_idx ON cht.mv_tb_referral_follow_up USING btree (village) tablespace ts_indexes;
CREATE INDEX tb_referral_follow_up_district_idx ON cht.mv_tb_referral_follow_up USING btree (district) tablespace ts_indexes;
CREATE INDEX tb_referral_follow_up_region_idx ON cht.mv_tb_referral_follow_up USING btree (region) tablespace ts_indexes;

-- ---------------------------------------------------------------------
-- SOURCE: mv_tb_results_notification.sql
-- ---------------------------------------------------------------------

-- cht.mv_tb_results_notification source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_tb_results_notification;
CREATE MATERIALIZED VIEW cht.mv_tb_results_notification
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
    doc #>> '{fields,t_tb_result}'::text[] AS t_tb_result,
    doc #>> '{fields,t_results_phone_number}'::text[] AS t_results_phone_number,
    doc #>> '{fields,t_cough}'::text[] AS t_cough,
    doc #>> '{fields,t_fever}'::text[] AS t_fever,
    doc #>> '{fields,t_weight_loss}'::text[] AS t_weight_loss,
    doc #>> '{fields,t_excessive_night_sweat}'::text[] AS t_excessive_night_sweat,
    doc #>> '{fields,t_poor_weight_gain}'::text[] AS t_poor_weight_gain,
    doc #>> '{fields,t_is_on_tb_treatment}'::text[] AS t_is_on_tb_treatment,
    doc #>> '{fields,t_prev_tb_result}'::text[] AS t_prev_tb_result,
    doc #>> '{fields,t_returned_result_barcode}'::text[] AS t_returned_result_barcode,
    doc #>> '{fields,inputs,user,contact_id}'::text[] AS user_contact_id,
    doc #>> '{fields,inputs,user,facility_id}'::text[] AS user_facility_id,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS contact_name,
    doc #>> '{fields,inputs,contact,date_of_birth}'::text[] AS contact_date_of_birth,
    doc #>> '{fields,inputs,contact,sex}'::text[] AS contact_sex,
    doc #>> '{fields,inputs,contact,parent,_id}'::text[] AS parent__id,
    doc #>> '{fields,inputs,contact,parent,name}'::text[] AS parent_name,
    doc #>> '{fields,inputs,contact,parent,parent,supervisor}'::text[] AS supervisor,
    doc #>> '{fields,inputs,contact,parent,parent,phone}'::text[] AS phone,
    doc #>> '{fields,patient_age_in_years}'::text[] AS patient_age_in_years,
    doc #>> '{fields,patient_age_in_months}'::text[] AS patient_age_in_months,
    doc #>> '{fields,patient_age_in_days}'::text[] AS patient_age_in_days,
    doc #>> '{fields,patient_age_display}'::text[] AS patient_age_display,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,patient_name}'::text[] AS patient_name,
    doc #>> '{fields,patient_gender}'::text[] AS patient_gender,
    doc #>> '{fields,patient_pronoun}'::text[] AS patient_pronoun,
    doc #>> '{fields,patient_adjective}'::text[] AS patient_adjective,
    doc #>> '{fields,tb_result}'::text[] AS tb_result,
    doc #>> '{fields,barcode_scanner_result}'::text[] AS barcode_scanner_result,
    doc #>> '{fields,cough}'::text[] AS cough,
    doc #>> '{fields,fever}'::text[] AS fever,
    doc #>> '{fields,weight_loss}'::text[] AS weight_loss,
    doc #>> '{fields,excessive_night_sweat}'::text[] AS excessive_night_sweat,
    doc #>> '{fields,poor_weight_gain}'::text[] AS poor_weight_gain,
    doc #>> '{fields,is_on_tb_treatment}'::text[] AS is_on_tb_treatment,
    doc #>> '{fields,patient_referred_to_health_facility}'::text[] AS patient_referred_to_health_facility,
    doc #>> '{fields,national_identification_number}'::text[] AS national_identification_number,
    doc #>> '{fields,client_category}'::text[] AS client_category,
    doc #>> '{fields,results_notification,note_tb_results}'::text[] AS note_tb_results,
    doc #>> '{fields,results_notification,note_barcode_id}'::text[] AS note_barcode_id,
    doc #>> '{fields,results_notification,note_results}'::text[] AS note_results,
    doc #>> '{fields,results_notification,refer_patient_to_health_facility}'::text[] AS refer_patient_to_health_facility,
    doc #>> '{fields,results_notification,confirm_refer_to_health_facility}'::text[] AS confirm_refer_to_health_facility,
    doc #>> '{fields,results_notification,explain_result_invalid}'::text[] AS explain_result_invalid,
    doc #>> '{fields,missing_results_notification,note_refer_to_health_facility}'::text[] AS note_refer_to_health_facility,
    doc #>> '{fields,missing_results_notification,note_explain_missing_result}'::text[] AS note_explain_missing_result,
    doc #>> '{fields,sputum_collection,give_patient_instructions}'::text[] AS give_patient_instructions,
    doc #>> '{fields,sputum_collection,has_patient_produced_sputum}'::text[] AS has_patient_produced_sputum,
    doc #>> '{fields,sputum_collection,confirm_container_tightly_closed}'::text[] AS confirm_container_tightly_closed,
    doc #>> '{fields,sputum_collection,confirm_send_sample_for_testing}'::text[] AS confirm_send_sample_for_testing,
    doc #>> '{fields,sputum_collection,leave_sputum_bottle_with_client}'::text[] AS leave_sputum_bottle_with_client,
    doc #>> '{fields,sputum_collection,has_left_sputum_bottle_with_client}'::text[] AS has_left_sputum_bottle_with_client,
    doc #>> '{fields,sputum_collection_consent,results_phone_number}'::text[] AS results_phone_number,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
FROM dwh.cht_data d LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id
  WHERE (doc ->> 'form'::text) = 'tb_results_notification'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX tb_results_notification_reported_idx ON cht.mv_tb_results_notification USING btree (reported) tablespace ts_indexes;
CREATE INDEX tb_results_notification_date_idx ON cht.mv_tb_results_notification USING btree (date) tablespace ts_indexes;
CREATE INDEX tb_results_notification_monthname_idx ON cht.mv_tb_results_notification USING btree (monthname) tablespace ts_indexes;
CREATE INDEX mv_tb_results_notification_year_month_district ON cht.mv_tb_results_notification USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX tb_results_notification_chw_id_idx ON cht.mv_tb_results_notification USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX tb_results_notification_facility_idx ON cht.mv_tb_results_notification USING btree (facility) tablespace ts_indexes;
CREATE INDEX tb_results_notification_dhis2_facility_id_idx ON cht.mv_tb_results_notification USING btree (dhis2_facility_id) tablespace ts_indexes;
CREATE INDEX tb_results_notification_village_idx ON cht.mv_tb_results_notification USING btree (village) tablespace ts_indexes;
CREATE INDEX tb_results_notification_district_idx ON cht.mv_tb_results_notification USING btree (district) tablespace ts_indexes;
CREATE INDEX tb_results_notification_region_idx ON cht.mv_tb_results_notification USING btree (region) tablespace ts_indexes;

-- ---------------------------------------------------------------------
-- SOURCE: mv_tb_screening.sql
-- ---------------------------------------------------------------------

-- cht.mv_tb_screening source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_tb_screening;
CREATE MATERIALIZED VIEW cht.mv_tb_screening
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
    doc #>> '{fields,inputs,user,contact_id}'::text[] AS user_contact_id,
    doc #>> '{fields,inputs,user,facility_id}'::text[] AS user_facility_id,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    doc #>> '{fields,inputs,contact,date_of_birth}'::text[] AS inputs_contact_date_of_birth,
    doc #>> '{fields,inputs,contact,sex}'::text[] AS inputs_contact_sex,
    doc #>> '{fields,inputs,contact,phone}'::text[] AS inputs_contact_phone,
    doc #>> '{fields,inputs,contact,parent,_id}'::text[] AS inputs_parent_id,
    doc #>> '{fields,inputs,contact,parent,name}'::text[] AS inputs_parent_name,
    doc #>> '{fields,inputs,contact,parent,parent,supervisor}'::text[] AS inputs_supervisor,
    doc #>> '{fields,inputs,contact,parent,parent,phone}'::text[] AS inputs_parent_phone,
    doc #>> '{fields,inputs,contact,parent,parent,village}'::text[] AS inputs_village,
    doc #>> '{fields,patient_age_in_years}'::text[] AS patient_age_in_years,
    doc #>> '{fields,patient_age_in_months}'::text[] AS patient_age_in_months,
    doc #>> '{fields,patient_age_in_days}'::text[] AS patient_age_in_days,
    doc #>> '{fields,patient_age_display}'::text[] AS patient_age_display,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,patient_name}'::text[] AS patient_name,
    doc #>> '{fields,patient_gender}'::text[] AS patient_gender,
    doc #>> '{fields,patient_pronoun}'::text[] AS patient_pronoun,
    doc #>> '{fields,patient_adjective}'::text[] AS patient_adjective,
    doc #>> '{fields,patient_gender_pronoun}'::text[] AS patient_gender_pronoun,
    doc #>> '{fields,patient_phone}'::text[] AS patient_phone,
    doc #>> '{fields,still_on_tb_treatment}'::text[] AS still_on_tb_treatment,
    doc #>> '{fields,has_diabetes_on_screening}'::text[] AS has_diabetes_on_screening,
    doc #>> '{fields,is_a_miner_on_screening}'::text[] AS is_a_miner_on_screening,
    doc #>> '{fields,is_hiv_positive}'::text[] AS is_hiv_positive,
    doc #>> '{fields,patient_category}'::text[] AS patient_category,
    doc #>> '{fields,barcode_scanner_result}'::text[] AS barcode_scanner_result,
    doc #>> '{fields,is_presumptive_case}'::text[] AS is_presumptive_case,
    doc #>> '{fields,national_identification_number}'::text[] AS national_identification_number,
    doc #>> '{fields,client_category}'::text[] AS client_category,
    doc #>> '{fields,is_on_tb_treatment}'::text[] AS is_on_tb_treatment,
    doc #>> '{fields,cough}'::text[] AS cough,
    doc #>> '{fields,fever}'::text[] AS fever,
    doc #>> '{fields,excessive_night_sweat}'::text[] AS excessive_night_sweat,
    doc #>> '{fields,weight_loss}'::text[] AS weight_loss,
    doc #>> '{fields,poor_weight_gain}'::text[] AS poor_weight_gain,
    doc #>> '{fields,group_tb_screening,is_currently_on_tb_treatment}'::text[] AS is_currently_on_tb_treatment,
    doc #>> '{fields,group_tb_screening,is_still_on_tb_treatment}'::text[] AS is_still_on_tb_treatment,
    doc #>> '{fields,group_tb_screening,have_all_members_been_screened}'::text[] AS have_all_members_been_screened,
    doc #>> '{fields,group_tb_screening,refer_household_members}'::text[] AS refer_household_members,
    doc #>> '{fields,group_tb_health_education,health_education}'::text[] AS health_education,
    doc #>> '{fields,group_tb_health_education,benefits_of_tb_treatment}'::text[] AS benefits_of_tb_treatment,
    doc #>> '{fields,group_tb_health_education,drug_resistance}'::text[] AS drug_resistance,
    doc #>> '{fields,group_tb_health_education,explain_drug_resistance}'::text[] AS explain_drug_resistance,
    doc #>> '{fields,group_tb_health_education,health_education_basics}'::text[] AS health_education_basics,
    doc #>> '{fields,group_tb_health_education,what_is_tb}'::text[] AS what_is_tb,
    doc #>> '{fields,group_tb_health_education,tb_explanation}'::text[] AS tb_explanation,
    doc #>> '{fields,group_tb_health_education,tb_explanation_type}'::text[] AS tb_explanation_type,
    doc #>> '{fields,group_tb_health_education,who_risk_contracting_tb}'::text[] AS who_risk_contracting_tb,
    doc #>> '{fields,group_tb_signs_and_symptoms_of_tb,cough_2_weeks_or_more}'::text[] AS cough_2_weeks_or_more,
    doc #>> '{fields,group_tb_signs_and_symptoms_of_tb,excessive_night_sweats}'::text[] AS excessive_night_sweats,
    doc #>> '{fields,group_tb_signs_and_symptoms_of_tb,unexplained_weight_loss}'::text[] AS unexplained_weight_loss,
    doc #>> '{fields,group_tb_signs_and_symptoms_of_tb,loss_of_appetite_image}'::text[] AS loss_of_appetite_image,
    doc #>> '{fields,group_tb_signs_and_symptoms_of_tb,chest_pain_image}'::text[] AS chest_pain_image,
    doc #>> '{fields,group_tb_signs_and_symptoms_of_tb,poor_weight_gain_among_children}'::text[] AS poor_weight_gain_among_children,
    doc #>> '{fields,group_tb_health_and_status_check,select_tb_risk_factors}'::text[] AS select_tb_risk_factors,
    doc #>> '{fields,group_tb_signs_and_symptoms,currently_have_tb_signs}'::text[] AS currently_have_tb_signs,
    doc #>> '{fields,group_tb_signs_and_symptoms,cough_sign}'::text[] AS cough_sign,
    doc #>> '{fields,group_tb_signs_and_symptoms,cough_duration}'::text[] AS cough_duration,
    doc #>> '{fields,group_tb_signs_and_symptoms,blood_in_cough}'::text[] AS blood_in_cough,
    doc #>> '{fields,group_tb_signs_and_symptoms,fever_symptom}'::text[] AS fever_symptom,
    doc #>> '{fields,group_tb_signs_and_symptoms,fever_duration}'::text[] AS fever_duration,
    doc #>> '{fields,group_tb_signs_and_symptoms,weight_loss_sign}'::text[] AS weight_loss_sign,
    doc #>> '{fields,group_tb_signs_and_symptoms,excessive_night_sweat_sign}'::text[] AS excessive_night_sweat_sign,
    doc #>> '{fields,group_tb_signs_and_symptoms,loss_of_appetite}'::text[] AS loss_of_appetite,
    doc #>> '{fields,group_tb_signs_and_symptoms,chest_pain}'::text[] AS chest_pain,
    doc #>> '{fields,group_tb_signs_and_symptoms,poor_weight_gain_sign}'::text[] AS poor_weight_gain_sign,
    doc #>> '{fields,group_tb_signs_and_symptoms,had_contact_with_tb_person}'::text[] AS had_contact_with_tb_person,
    doc #>> '{fields,group_tb_signs_and_symptoms,suspected_tb_signs}'::text[] AS suspected_tb_signs,
    doc #>> '{fields,group_tb_prevention_measures,note_educate_patient}'::text[] AS note_educate_patient,
    doc #>> '{fields,group_tb_prevention_measures,refer_to_health_facility}'::text[] AS refer_to_health_facility,
    doc #>> '{fields,group_tb_prevention_measures,confirms_referral}'::text[] AS confirms_referral,
    doc #>> '{fields,sputum_collection_consent,consented_sputum_sample}'::text[] AS consented_sputum_sample,
    doc #>> '{fields,sputum_collection_consent,registered_phone_number}'::text[] AS registered_phone_number,
    doc #>> '{fields,sputum_collection_consent,receive_results_on_same_phonenumber}'::text[] AS receive_results_on_same_phonenumber,
    doc #>> '{fields,sputum_collection_consent,enter_new_phone_number}'::text[] AS enter_new_phone_number,
    doc #>> '{fields,sputum_collection_consent,no_registered_phone_number}'::text[] AS no_registered_phone_number,
    doc #>> '{fields,sputum_collection_consent,phonenumber_to_receive_results}'::text[] AS phonenumber_to_receive_results,
    doc #>> '{fields,sputum_collection_consent,results_phone_number}'::text[] AS results_phone_number,
    doc #>> '{fields,sputum_collection,sputum_collection}'::text[] AS sputum_collection,
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
FROM dwh.cht_data d LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id
  WHERE (doc ->> 'form'::text) = 'tb_screening'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX tb_screening_reported_idx ON cht.mv_tb_screening USING btree (reported);
CREATE INDEX tb_screening_date_idx ON cht.mv_tb_screening USING btree (date);
CREATE INDEX tb_screening_monthname_idx ON cht.mv_tb_screening USING btree (monthname);
CREATE INDEX mv_tb_screening_year_month_district ON cht.mv_tb_screening USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX tb_screening_chw_id_idx ON cht.mv_tb_screening USING btree (chw_id);
CREATE INDEX tb_screening_facility_idx ON cht.mv_tb_screening USING btree (facility);
CREATE INDEX tb_screening_dhis2_facility_id_idx ON cht.mv_tb_screening USING btree (dhis2_facility_id);
CREATE INDEX tb_screening_village_idx ON cht.mv_tb_screening USING btree (village);
CREATE INDEX tb_screening_district_idx ON cht.mv_tb_screening USING btree (district);
CREATE INDEX tb_screening_region_idx ON cht.mv_tb_screening USING btree (region);

-- ---------------------------------------------------------------------
-- SOURCE: mv_tb_uncompleted_referral.sql
-- ---------------------------------------------------------------------

DROP MATERIALIZED VIEW IF EXISTS cht.mv_tb_uncompleted_referral;
CREATE MATERIALIZED VIEW cht.mv_tb_uncompleted_referral
TABLESPACE ts_report
AS
SELECT
    doc ->> '_id'::text                              AS doc_id,
    doc ->> '_rev'::text                             AS rev,                                 -- [NEW FIELD]
    to_timestamp((NULLIF(doc ->> 'reported_date'::text, ''::text)::bigint / 1000)::double precision) AS reported,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY-MM-DD'))::date AS date,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY'))::INT AS year,
    TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'FMMonth') AS month,
    doc ->'fields'->'meta'->>'instanceID' AS instanceID,
    doc ->'fields'->'inputs'->'meta'->>'deprecatedID' AS deprecatedID,
    doc ->'fields'->'inputs'->'meta'->'location'->>'lat' AS location_lat,
    doc ->'fields'->'inputs'->'meta'->'location'->>'long' AS location_long,
    doc ->'fields'->'inputs'->'meta'->'location'->>'error' AS location_error,
    doc ->'fields'->'inputs'->'meta'->'location'->>'message' AS location_message,
    doc ->'geolocation'->>'code' AS geolocation_code,
    doc ->'geolocation'->>'message' AS geolocation_message,
    (NULLIF((doc -> 'geolocation'::text) ->> 'latitude'::text, ''::text))::double precision AS geolocation_latitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'longitude'::text, ''::text))::double precision AS geolocation_longitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'accuracy'::text, ''::text))::double precision AS geolocation_accuracy,
    (NULLIF((doc -> 'geolocation'::text) ->> 'altitude'::text, ''::text))::double precision AS geolocation_altitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'altitudeAccuracy'::text, ''::text))::double precision AS geolocation_altitude_accuracy,
    (NULLIF((doc -> 'geolocation'::text) ->> 'speed'::text, ''::text))::double precision AS geolocation_speed,
    (NULLIF((doc -> 'geolocation'::text) ->> 'heading'::text, ''::text))::double precision AS geolocation_heading,
    doc ->> 'from'::text                             AS  from,

     doc #>> '{fields,inputs,source}'                                    AS source,
     doc #>> '{fields,inputs,source_id}'                                 AS source_id,
     doc #>> '{fields,inputs,t_tb_result}'                               AS t_tb_result,
     doc #>> '{fields,inputs,t_place_name}'                              AS t_place_name,
     doc #>> '{fields,inputs,t_patient_name}'                            AS t_patient_name,
     doc #>> '{fields,inputs,user,contact_id}'                           AS user_contact_id,
     doc #>> '{fields,inputs,user,facility_id}'                          AS user_facility_id,
     doc #>> '{fields,inputs,contact,_id}'                               AS contact_id,
     doc #>> '{fields,inputs,contact,name}'                              AS contact_name,
     doc #>> '{fields,inputs,contact,date_of_birth}'                     AS contact_date_of_birth,
     doc #>> '{fields,inputs,contact,sex}'                               AS contact_sex,
     doc #>> '{fields,patient_id}'                                       AS patient_id,
     doc #>> '{fields,patient_name}'                                     AS patient_name,
     doc #>> '{fields,tb_result}'                                        AS tb_result,
     doc #>> '{fields,place_name}'                                       AS place_name,
     doc #>> '{fields,needs_signoff}'                                    AS needs_signoff,
    
    doc #>> '{fields,referral_notification,generated_note_name_25}'  AS generated_note_name_25,
    doc #>> '{fields,referral_notification,referred_to_health_facility}'  AS referred_to_health_facility,

        --- reporting hierarchy
    doc #>> '{contact,_id}'                         AS chw_id,                   
    doc #>> '{contact,parent,_id}'                  AS chw_area_id,  
    doc #>> '{contact,parent,parent,_id}'           AS facility_id,                                    
    doc #>> '{contact,parent,parent,parent,_id}'    AS parish_id,              
    doc #>> '{contact,parent,parent,parent,parent,_id}'           AS district,                 
    doc #>> '{contact,parent,parent,parent,parent,parent,_id}'    AS region,
    CURRENT_TIMESTAMP                                 AS last_refresh_date  

FROM dwh.cht_data
WHERE (doc ->> 'form') = 'tb_uncompleted_referral'
  AND is_current
WITH NO DATA;

CREATE INDEX uncompleted_referral_reported_idx
    ON cht.mv_uncompleted_referral USING btree (reported);
CREATE INDEX mv_tb_uncompleted_referral_year_month_district ON cht.mv_tb_uncompleted_referral USING btree (year, month, district) TABLESPACE ts_indexes;


-- ---------------------------------------------------------------------
-- SOURCE: mv_training_evaluation.sql
-- ---------------------------------------------------------------------

-- cht.mv_training_evaluation source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_training_evaluation;
CREATE MATERIALIZED VIEW cht.mv_training_evaluation
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
    doc #>> '{fields,form_for_child_in_household_score}'::text[] AS form_for_child_in_household_score,
    doc #>> '{fields,option_for_reminder_score}'::text[] AS option_for_reminder_score,
    doc #>> '{fields,form_available_to_all_score}'::text[] AS form_available_to_all_score,
    doc #>> '{fields,who_is_responsible_for_hh_registration_score}'::text[] AS responsible_for_hh_registration_score,
    doc #>> '{fields,true_false_score}'::text[] AS true_false_score,
    doc #>> '{fields,tab_for_graphical_representation_score}'::text[] AS tab_for_graphical_representation_score,
    doc #>> '{fields,menu_for_reporting_issues_score}'::text[] AS menu_for_reporting_issues_score,
    doc #>> '{fields,option_facilitates_data_upload_score}'::text[] AS option_facilitates_data_upload_score,
    doc #>> '{fields,form_for_collecting_symptoms_score}'::text[] AS form_for_collecting_symptoms_score,
    doc #>> '{fields,option_for_completing_form_score}'::text[] AS option_for_completing_form_score,
    doc #>> '{fields,your_score}'::text[] AS your_score,
    doc #>> '{fields,group_test_questions,trainee_name}'::text[] AS trainee_name,
    doc #>> '{fields,group_test_questions,phone_number}'::text[] AS trainee_phone_number,
    doc #>> '{fields,group_test_questions,note_instructions}'::text[] AS note_instructions,
    doc #>> '{fields,group_test_questions,form_for_child_in_household}'::text[] AS form_for_child_in_household,
    doc #>> '{fields,group_test_questions,option_for_reminder}'::text[] AS option_for_reminder,
    doc #>> '{fields,group_test_questions,form_available_to_all}'::text[] AS form_available_to_all,
    doc #>> '{fields,group_test_questions,who_is_responsible_for_hh_registration}'::text[] AS responsible_for_hh_registration,
    doc #>> '{fields,group_test_questions,true_false}'::text[] AS true_false,
    doc #>> '{fields,group_test_questions,tab_for_graphical_representation}'::text[] AS tab_for_graphical_representation,
    doc #>> '{fields,group_test_questions,menu_for_reporting_issues}'::text[] AS menu_for_reporting_issues,
    doc #>> '{fields,group_test_questions,option_facilitates_data_upload}'::text[] AS option_facilitates_data_upload,
    doc #>> '{fields,group_test_questions,form_for_collecting_symptoms}'::text[] AS form_for_collecting_symptoms,
    doc #>> '{fields,group_test_questions,option_for_completing_form}'::text[] AS option_for_completing_form,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
FROM dwh.cht_data d LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id 
  WHERE (doc ->> 'form'::text) = 'training_evaluation'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX training_evaluation_reported_idx ON cht.mv_training_evaluation USING btree (reported) tablespace ts_indexes;
CREATE INDEX training_evaluation_date_idx ON cht.mv_training_evaluation USING btree (date) tablespace ts_indexes;
CREATE INDEX training_evaluation_monthname_idx ON cht.mv_training_evaluation USING btree (monthname) tablespace ts_indexes;
CREATE INDEX mv_training_evaluation_year_month_district ON cht.mv_training_evaluation USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX training_evaluation_district_idx ON cht.mv_training_evaluation USING btree (district) tablespace ts_indexes;
CREATE INDEX training_evaluation_region_idx ON cht.mv_training_evaluation USING btree (region) tablespace ts_indexes;
CREATE INDEX training_evaluation_chw_id_idx ON cht.mv_training_evaluation USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX training_evaluation_facility_idx ON cht.mv_training_evaluation USING btree (facility) tablespace ts_indexes;
CREATE INDEX training_evaluation_dhis2_facility_id_idx ON cht.mv_training_evaluation USING btree (dhis2_facility_id) tablespace ts_indexes;
CREATE INDEX training_evaluation_village_idx ON cht.mv_training_evaluation USING btree (village) tablespace ts_indexes;
CREATE INDEX training_evaluation_last_refresh_date_idx ON cht.mv_training_evaluation USING btree (last_refresh_date) tablespace ts_indexes;                                                     

-- ---------------------------------------------------------------------
-- SOURCE: mv_treatment_follow_up.sql
-- ---------------------------------------------------------------------

-- cht.mv_treatment_follow_up source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_treatment_follow_up;
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

-- ---------------------------------------------------------------------
-- SOURCE: mv_uncompleted_referral.sql
-- ---------------------------------------------------------------------

-- cht.mv_uncompleted_referral source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_uncompleted_referral;
CREATE MATERIALIZED VIEW cht.mv_uncompleted_referral
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
    doc #>> '{fields,inputs,t_tb_result}'::text[] AS t_tb_result,
    doc #>> '{fields,inputs,t_place_name}'::text[] AS t_place_name,
    doc #>> '{fields,inputs,t_patient_name}'::text[] AS t_patient_name,
    doc #>> '{fields,inputs,user,contact_id}'::text[] AS user_contact_id,
    doc #>> '{fields,inputs,user,facility_id}'::text[] AS user_facility_id,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    doc #>> '{fields,inputs,contact,date_of_birth}'::text[] AS inputs_contact_date_of_birth,
    doc #>> '{fields,inputs,contact,sex}'::text[] AS inputs_contact_sex,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,patient_name}'::text[] AS patient_name,
    doc #>> '{fields,tb_result}'::text[] AS tb_result,
    doc #>> '{fields,place_name}'::text[] AS place_name,
    doc #>> '{fields,needs_signoff}'::text[] AS needs_signoff,
    doc #>> '{fields,referral_notification,generated_note_name_25}'::text[] AS generated_note_name_25,
    doc #>> '{fields,referral_notification,referred_to_health_facility}'::text[] AS referred_to_health_facility,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
FROM dwh.cht_data d LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id
  WHERE (doc ->> 'form'::text) = 'tb_uncompleted_referral'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX uncompleted_referral_reported_idx ON cht.mv_uncompleted_referral USING btree (reported);
CREATE INDEX uncompleted_referral_date_idx ON cht.mv_uncompleted_referral USING btree (date);
CREATE INDEX uncompleted_referral_monthname_idx ON cht.mv_uncompleted_referral USING btree (monthname);
CREATE INDEX mv_uncompleted_referral_year_month_district ON cht.mv_uncompleted_referral USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX uncompleted_referral_district_idx ON cht.mv_uncompleted_referral USING btree (district);
CREATE INDEX uncompleted_referral_region_idx ON cht.mv_uncompleted_referral USING btree (region);
CREATE INDEX uncompleted_referral_chw_id_idx ON cht.mv_uncompleted_referral USING btree (chw_id);
CREATE INDEX uncompleted_referral_facility_idx ON cht.mv_uncompleted_referral USING btree (facility);
CREATE INDEX uncompleted_referral_dhis2_facility_id_idx ON cht.mv_uncompleted_referral USING btree (dhis2_facility_id);
CREATE INDEX uncompleted_referral_village_idx ON cht.mv_uncompleted_referral USING btree (village);

-- ---------------------------------------------------------------------
-- SOURCE: mv_vht_consumption_log.sql
-- ---------------------------------------------------------------------

-- cht.mv_vht_consumption_log source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_vht_consumption_log;
CREATE MATERIALIZED VIEW cht.mv_vht_consumption_log
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
    doc #>> '{fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,act_item_received}'::text[] AS act_item_received,
    doc #>> '{fields,act_item_returned}'::text[] AS act_item_returned,
    doc #>> '{fields,zinc_item_received}'::text[] AS zinc_item_received,
    doc #>> '{fields,zinc_item_returned}'::text[] AS zinc_item_returned,
    doc #>> '{fields,amoxicillin_item_received}'::text[] AS amoxicillin_item_received,
    doc #>> '{fields,amoxicillin_item_returned}'::text[] AS amoxicillin_item_returned,
    doc #>> '{fields,malaria_rdts_item_received}'::text[] AS malaria_rdts_item_received,
    doc #>> '{fields,malaria_rdts_item_returned}'::text[] AS malaria_rdts_item_returned,
    doc #>> '{fields,pop_item_received}'::text[] AS pop_item_received,
    doc #>> '{fields,pop_item_returned}'::text[] AS pop_item_returned,
    doc #>> '{fields,dmpa_item_received}'::text[] AS dmpa_item_received,
    doc #>> '{fields,dmpa_item_returned}'::text[] AS dmpa_item_returned,
    doc #>> '{fields,misoprostol_item_received}'::text[] AS misoprostol_item_received,
    doc #>> '{fields,misoprostol_item_returned}'::text[] AS misoprostol_item_returned,
    doc #>> '{fields,coc_item_received}'::text[] AS coc_item_received,
    doc #>> '{fields,coc_item_returned}'::text[] AS coc_item_returned,
    doc #>> '{fields,condoms_item_received}'::text[] AS condoms_item_received,
    doc #>> '{fields,condoms_item_returned}'::text[] AS condoms_item_returned,
    doc #>> '{fields,contraceptives_item_received}'::text[] AS contraceptives_item_received,
    doc #>> '{fields,contraceptives_item_returned}'::text[] AS contraceptives_item_returned,
    doc #>> '{fields,rectal_item_received}'::text[] AS rectal_item_received,
    doc #>> '{fields,rectal_item_returned}'::text[] AS rectal_item_returned,
    doc #>> '{fields,sayana_item_received}'::text[] AS sayana_item_received,
    doc #>> '{fields,sayana_item_returned}'::text[] AS sayana_item_returned,
    doc #>> '{fields,gloves_item_received}'::text[] AS gloves_item_received,
    doc #>> '{fields,gloves_item_returned}'::text[] AS gloves_item_returned,
    doc #>> '{fields,is_mch_instance}'::text[] AS is_mch_instance,
    doc #>> '{fields,items,date}'::text[] AS items_date,
    doc #>> '{fields,items,reported_stock}'::text[] AS items_reported_stock,
    doc #>> '{fields,items,return_note}'::text[] AS items_return_note,
    doc #>> '{fields,items,receive_note}'::text[] AS items_receive_note,
    doc #>> '{fields,items_received,add_note}'::text[] AS items_received_add_note,
    doc #>> '{fields,items_received,act}'::text[] AS items_received_act,
    doc #>> '{fields,items_received,malaria_rdts}'::text[] AS items_received_malaria_rdts,
    doc #>> '{fields,items_received,rectal}'::text[] AS items_received_rectal,
    doc #>> '{fields,items_received,gloves}'::text[] AS items_received_gloves,
    doc #>> '{fields,items_received,zinc}'::text[] AS items_received_zinc,
    doc #>> '{fields,items_received,amoxicillin}'::text[] AS items_received_amoxicillin,
    doc #>> '{fields,items_received,pop}'::text[] AS items_received_pop,
    doc #>> '{fields,items_received,coc}'::text[] AS items_received_coc,
    doc #>> '{fields,items_received,contraceptives}'::text[] AS items_received_contraceptives,
    doc #>> '{fields,items_received,dmpa}'::text[] AS items_received_dmpa,
    doc #>> '{fields,items_received,condoms}'::text[] AS items_received_condoms,
    doc #>> '{fields,items_returned,return_note}'::text[] AS items_returned_return_note,
    doc #>> '{fields,items_returned,act_r}'::text[] AS items_returned_act_r,
    doc #>> '{fields,items_returned,malaria_rdts_r}'::text[] AS items_returned_malaria_rdts_r,
    doc #>> '{fields,items_returned,rectal_r}'::text[] AS items_returned_rectal_r,
    doc #>> '{fields,items_returned,gloves_r}'::text[] AS items_returned_gloves_r,
    doc #>> '{fields,items_returned,zinc_r}'::text[] AS items_returned_zinc_r,
    doc #>> '{fields,items_returned,amoxicillin_r}'::text[] AS items_returned_amoxicillin_r,
    doc #>> '{fields,items_returned,pop_r}'::text[] AS items_returned_pop_r,
    doc #>> '{fields,items_returned,coc_r}'::text[] AS items_returned_coc_r,
    doc #>> '{fields,items_returned,contraceptives_r}'::text[] AS items_returned_contraceptives_r,
    doc #>> '{fields,items_returned,dmpa_r}'::text[] AS items_returned_dmpa_r,
    doc #>> '{fields,items_returned,condoms_r}'::text[] AS items_returned_condoms_r,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
FROM dwh.cht_data d LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id
  WHERE (doc ->> 'form'::text) = 'vht_consumption_log'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX mv_vht_consumption_log_chw_id ON cht.mv_vht_consumption_log USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX mv_vht_consumption_log_reported ON cht.mv_vht_consumption_log USING btree (reported) tablespace ts_indexes;
CREATE INDEX mv_vht_consumption_log_date ON cht.mv_vht_consumption_log USING btree (date) tablespace ts_indexes;
CREATE INDEX mv_vht_consumption_log_monthname ON cht.mv_vht_consumption_log USING btree (monthname) tablespace ts_indexes;
CREATE INDEX mv_vht_consumption_log_year_month_district ON cht.mv_vht_consumption_log USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX mv_vht_consumption_log_district ON cht.mv_vht_consumption_log USING btree (district) tablespace ts_indexes;
CREATE INDEX mv_vht_consumption_log_region ON cht.mv_vht_consumption_log USING btree (region) tablespace ts_indexes;
CREATE INDEX mv_vht_consumption_log_facility ON cht.mv_vht_consumption_log USING btree (facility) tablespace ts_indexes;  
CREATE INDEX mv_vht_consumption_log_dhis2_facility_id ON cht.mv_vht_consumption_log USING btree (dhis2_facility_id) tablespace ts_indexes;
CREATE INDEX mv_vht_consumption_log_village ON cht.mv_vht_consumption_log USING btree (village) tablespace ts_indexes;

-- ---------------------------------------------------------------------
-- SOURCE: mv_vht_supervision.sql
-- ---------------------------------------------------------------------

-- cht.mv_vht_supervision source

DROP MATERIALIZED VIEW IF EXISTS cht.mv_vht_supervision;
CREATE MATERIALIZED VIEW cht.mv_vht_supervision
TABLESPACE ts_report
AS SELECT couchdb.doc ->> '_id'::text AS uuid,
    couchdb.doc ->> 'form'::text AS form,
    couchdb.doc ->> 'from'::text AS submitter,
    to_timestamp((NULLIF(couchdb.doc ->> 'reported_date'::text, ''::text)::bigint / 1000)::double precision) AS reported,
    to_char(to_timestamp((((couchdb.doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'YYYY-MM-DD'::text)::date AS date,
    to_char(to_timestamp((((couchdb.doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'YYYY'::text)::integer AS year,
    to_char(to_timestamp((((couchdb.doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'MM'::text)::integer AS month,
    to_char(to_timestamp((((couchdb.doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'FMMonth'::text) AS monthname,
    ((couchdb.doc -> 'fields'::text) -> 'meta'::text) ->> 'instanceID'::text AS instanceid,
    (((couchdb.doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) ->> 'deprecatedID'::text AS deprecatedid,
    ((((couchdb.doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) -> 'location'::text) ->> 'lat'::text AS location_lat,
    ((((couchdb.doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) -> 'location'::text) ->> 'long'::text AS location_long,
    ((((couchdb.doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) -> 'location'::text) ->> 'error'::text AS location_error,
    ((((couchdb.doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) -> 'location'::text) ->> 'message'::text AS location_message,
    (couchdb.doc -> 'geolocation'::text) ->> 'code'::text AS geolocation_code,
    (couchdb.doc -> 'geolocation'::text) ->> 'message'::text AS geolocation_message,
    (NULLIF((couchdb.doc -> 'geolocation'::text) ->> 'latitude'::text, ''::text))::double precision AS geolocation_latitude,
    (NULLIF((couchdb.doc -> 'geolocation'::text) ->> 'longitude'::text, ''::text))::double precision AS geolocation_longitude,
    (NULLIF((couchdb.doc -> 'geolocation'::text) ->> 'accuracy'::text, ''::text))::double precision AS geolocation_accuracy,
    (NULLIF((couchdb.doc -> 'geolocation'::text) ->> 'altitude'::text, ''::text))::double precision AS geolocation_altitude,
    (NULLIF((couchdb.doc -> 'geolocation'::text) ->> 'altitudeAccuracy'::text, ''::text))::double precision AS geolocation_altitude_accuracy,
    (NULLIF((couchdb.doc -> 'geolocation'::text) ->> 'speed'::text, ''::text))::double precision AS geolocation_speed,
    (NULLIF((couchdb.doc -> 'geolocation'::text) ->> 'heading'::text, ''::text))::double precision AS geolocation_heading,
    couchdb.doc #>> '{contact,_id}'::text[] AS vht_supervisor_id,
    sup_users.fullname AS supervisor_name,
    vht_users.fullname AS vht_name,
    couchdb.doc #>> '{contact,parent,_id}'::text[] AS facility_id,
    contactview.facility AS facility_name,
    couchdb.doc #>> '{contact,parent,parent,_id}'::text[] AS district_check,
    contactview.district AS district,
    couchdb.doc #>> '{contact,parent,parent,parent,_id}'::text[] AS region,
    couchdb.doc #>> '{fields,inputs,source}'::text[] AS inputs_source,
    couchdb.doc #>> '{fields,inputs,contact,_id}'::text[] AS vht_area_uuid,
    couchdb.doc #>> '{fields,inputs,contact,name}'::text[] AS vht_name_encrypted,
    couchdb.doc #>> '{fields,inputs,contact,contact,name}'::text[] AS inputs_contact_contact_name,
    couchdb.doc #>> '{fields,private}'::text[] AS private,
    couchdb.doc #>> '{fields,place_name}'::text[] AS place_name,
    couchdb.doc #>> '{fields,vht_supervised}'::text[] AS vht_supervised,
    couchdb.doc #>> '{fields,group_vht_supervision_status,vht_supervision_status}'::text[] AS vht_supervision_status,
    CURRENT_TIMESTAMP AS last_refresh_date
   FROM dwh.cht_data couchdb
     LEFT JOIN cht.mv_cht_users sup_users ON (couchdb.doc #>> '{contact,_id}'::text[]) = sup_users.contact_id
     LEFT JOIN report.contactview_vht contactview ON (couchdb.doc #>> '{fields,inputs,contact,_id}'::text[]) = contactview.area_uuid
     LEFT JOIN cht.mv_cht_users vht_users ON contactview.uuid = vht_users.contact_id
  WHERE (couchdb.doc ->> 'form'::text) = 'vht_supervision'::text AND couchdb.is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX mv_vht_supervision_chw_id ON cht.mv_vht_supervision USING btree (vht_supervisor_id);
CREATE INDEX mv_vht_supervision_reported ON cht.mv_vht_supervision USING btree (reported);
CREATE INDEX mv_vht_supervision_year_month_district ON cht.mv_vht_supervision USING btree (year, month, district) TABLESPACE ts_indexes;

-- ---------------------------------------------------------------------
-- SOURCE: mv_pregnancy_danger_sign_follow_up.sql
-- ---------------------------------------------------------------------

-- cht.mv_pregnancy_danger_sign_follow_up source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_pregnancy_danger_sign_follow_up;
CREATE MATERIALIZED VIEW cht.mv_pregnancy_danger_sign_follow_up
TABLESPACE ts_report
AS SELECT doc_id,
    rev_id,
    ((doc -> 'fields'::text) -> 'meta'::text) ->> 'instanceID'::text AS instanceid,
    ((doc -> 'fields'::text) -> 'meta'::text) ->> 'deprecatedID'::text AS deprecatedid,
    (doc -> 'geolocation'::text) ->> 'code'::text AS code,
    (doc -> 'geolocation'::text) ->> 'message'::text AS message,
    (NULLIF((doc -> 'geolocation'::text) ->> 'latitude'::text, ''::text))::double precision AS geolocation_latitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'longitude'::text, ''::text))::double precision AS geolocation_longitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'accuracy'::text, ''::text))::double precision AS geolocation_accuracy,
    (NULLIF((doc -> 'geolocation'::text) ->> 'altitude'::text, ''::text))::double precision AS geolocation_altitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'altitudeAccuracy'::text, ''::text))::double precision AS geolocation_altitude_accuracy,
    (NULLIF((doc -> 'geolocation'::text) ->> 'speed'::text, ''::text))::double precision AS geolocation_speed,
    (NULLIF((doc -> 'geolocation'::text) ->> 'heading'::text, ''::text))::double precision AS geolocation_heading,
    to_timestamp((NULLIF(doc ->> 'reported_date'::text, ''::text)::bigint / 1000)::double precision) AS reported,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY-MM-DD'))::date AS date,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY'))::INT AS year,
    to_char(to_timestamp((((doc ->>'reported_date'::text)::bigint) / 1000)::double precision), 'MM'::text)::integer AS month,
    TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'FMMonth') AS monthname,

    doc ->> 'form'::text AS form,
    doc ->> 'from'::text AS "from",
    doc ->> 'type'::text AS type,
    ((doc -> 'fields'::text) -> 'data'::text) ->> '__fits'::text AS fits,
    ((doc -> 'fields'::text) -> 'data'::text) ->> '__fever'::text AS fever,
    ((doc -> 'fields'::text) -> 'data'::text) ->> '__very_pale'::text AS very_pale,
    ((doc -> 'fields'::text) -> 'data'::text) ->> '__visited_hf'::text AS visited_hf,
    ((doc -> 'fields'::text) -> 'data'::text) ->> '__easily_tired'::text AS easily_tired,
    ((doc -> 'fields'::text) -> 'data'::text) ->> '__breaking_water'::text AS breaking_water,
    ((doc -> 'fields'::text) -> 'data'::text) ->> '__breathlessness'::text AS breathlessness,
    ((doc -> 'fields'::text) -> 'data'::text) ->> '__has_danger_sign'::text AS has_danger_sign,
    ((doc -> 'fields'::text) -> 'data'::text) ->> '__severe_headache'::text AS severe_headache,
    ((doc -> 'fields'::text) -> 'data'::text) ->> '__vaginal_bleeding'::text AS vaginal_bleeding,
    ((doc -> 'fields'::text) -> 'data'::text) ->> '__face_hand_swelling'::text AS face_hand_swelling,
    ((doc -> 'fields'::text) -> 'data'::text) ->> '__severe_abdominal_pain'::text AS severe_abdominal_pain,
    ((doc -> 'fields'::text) -> 'data'::text) ->> '__reduced_or_no_fetal_movements'::text AS reduced_or_no_fetal_movements,
    ((doc -> 'fields'::text) -> 'data'::text) ->> '__still_experiencing_danger_sign'::text AS still_experiencing_danger_sign,
    (((doc -> 'fields'::text) -> 'data'::text) -> 'meta'::text) ->> '__source_id'::text AS source_id,
    ((doc -> 'fields'::text) -> 'inputs'::text) ->> 'source'::text AS source,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> '_id'::text AS inputs_contact_id,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> 'sex'::text AS inputs_contact_sex,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> 'name'::text AS inputs_contact_name,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'parent'::text) ->> '_id'::text AS parent_id,
    ((((((doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) -> 'parent'::text) -> 'parent'::text) -> 'contact'::text) ->> 'phone'::text AS phone,
    ((((((doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) -> 'parent'::text) -> 'parent'::text) -> 'contact'::text) ->> 'chw_name'::text AS chw_name,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> 'patient_id'::text AS patient_id,
    (doc -> 'fields'::text) ->> 'patient_uuid'::text AS patient_uuid,
    (doc -> 'fields'::text) ->> 'pregnancy_uuid_ctx'::text AS pregnancy_uuid_ctx,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> 'date_of_birth'::text AS date_of_birth,
    (doc -> 'fields'::text) ->> 'patient_name'::text AS patient_name,
    (doc -> 'fields'::text) ->> 'patient_short_name'::text AS patient_short_name,
    (doc -> 'fields'::text) ->> 'patient_age_in_years'::text AS patient_age_in_years,
    (doc -> 'fields'::text) ->> 'patient_short_name_start'::text AS patient_short_name_start,
    (doc -> 'fields'::text) ->> 't_danger_signs_referral_follow_up'::text AS t_danger_signs_referral_follow_up,
    (doc -> 'fields'::text) ->> 't_danger_signs_referral_follow_up_date'::text AS t_danger_signs_referral_follow_up_date,
    ((doc -> 'fields'::text) -> 'danger_signs'::text) ->> 'visit_confirm'::text AS visit_confirm,
    (((doc -> 'fields'::text) -> 'danger_signs'::text) -> 'custom_translations'::text) ->> 'custom_woman_label'::text AS custom_woman_label,
    (((doc -> 'fields'::text) -> 'danger_signs'::text) -> 'custom_translations'::text) ->> 'custom_woman_start_label'::text AS custom_woman_start_label,
    (((doc -> 'fields'::text) -> 'danger_signs'::text) -> 'custom_translations'::text) ->> 'custom_woman_label_translator'::text AS custom_woman_label_translator,
    (((doc -> 'fields'::text) -> 'danger_signs'::text) -> 'custom_translations'::text) ->> 'custom_woman_start_label_translator'::text AS custom_woman_start_label_translator,
    ((doc -> 'fields'::text) -> 'danger_signs'::text) ->> 'danger_sign_present'::text AS danger_sign_present,
    ((doc -> 'fields'::text) -> 'danger_signs'::text) ->> 'r_danger_sign_present'::text AS r_danger_sign_present,
    ((doc -> 'fields'::text) -> 'danger_signs'::text) ->> 'congratulate_no_ds_note'::text AS congratulate_no_ds_note,
   doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
FROM dwh.cht_data d
LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id
  WHERE type = 'data_record'::text AND (doc ->> 'form'::text) = 'pregnancy_danger_sign_follow_up'::text AND is_current IS TRUE
WITH NO DATA;

CREATE INDEX pregnancy_danger_sign_follow_up_reported_idx ON cht.mv_pregnancy_danger_sign_follow_up USING btree (reported) tablespace ts_indexes;
CREATE INDEX pregnancy_danger_sign_follow_up_date_idx ON cht.mv_pregnancy_danger_sign_follow_up USING btree (date) tablespace ts_indexes;
CREATE INDEX pregnancy_danger_sign_follow_up_monthname_idx ON cht.mv_pregnancy_danger_sign_follow_up USING btree (monthname) tablespace ts_indexes;
CREATE INDEX mv_pregnancy_danger_sign_follow_up_year_month_district ON cht.mv_pregnancy_danger_sign_follow_up USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX pregnancy_danger_sign_follow_up_village_idx ON cht.mv_pregnancy_danger_sign_follow_up USING btree (village) tablespace ts_indexes;
CREATE INDEX pregnancy_danger_sign_follow_up_district_idx ON cht.mv_pregnancy_danger_sign_follow_up USING btree (district) tablespace ts_indexes;
CREATE INDEX pregnancy_danger_sign_follow_up_region_idx ON cht.mv_pregnancy_danger_sign_follow_up USING btree (region) tablespace ts_indexes;
