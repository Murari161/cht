CREATE MATERIALIZED VIEW report.mv_sputum_collection_refusal
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
    doc ->> 'from'::text                             AS  from,

    doc #>> '{fields,inputs,source}'                                      AS source,
    doc #>> '{fields,inputs,source_id}'                                   AS source_id,
    doc #>> '{fields,inputs,t_place_name}'                                AS t_place_name,
    doc #>> '{fields,inputs,t_patient_name}'                              AS t_patient_name,
    doc #>> '{fields,inputs,t_patient_gender}'                            AS t_patient_gender,
    doc #>> '{fields,inputs,t_patient_phone}'                             AS t_patient_phone,
    doc #>> '{fields,inputs,t_patient_age_in_years}'                      AS t_patient_age_in_years,
    doc #>> '{fields,inputs,t_patient_id}'                                AS t_patient_id,
    doc #>> '{fields,inputs,t_cough}'                                     AS t_cough,
    doc #>> '{fields,inputs,t_fever}'                                     AS t_fever,
    doc #>> '{fields,inputs,t_weight_loss}'                               AS t_weight_loss,
    doc #>> '{fields,inputs,t_excessive_night_sweat}'                     AS t_excessive_night_sweat,
    doc #>> '{fields,inputs,t_poor_weight_gain}'                          AS t_poor_weight_gain,
    doc #>> '{fields,inputs,t_is_on_tb_treatment}'                        AS t_is_on_tb_treatment,
    doc #>> '{fields,inputs,t_client_category}'                           AS t_client_category,
    doc #>> '{fields,inputs,t_patient_age_display}'                       AS t_patient_age_display,
    doc #>> '{fields,inputs,t_patient_age_in_days}'                       AS t_patient_age_in_days,
    doc #>> '{fields,inputs,t_patient_age_in_months}'                     AS t_patient_age_in_months,
    doc #>> '{fields,inputs,t_chw_area_id}'                               AS t_chw_area_id,
    doc #>> '{fields,inputs,t_chw_area_name}'                             AS t_chw_area_name,
    doc #>> '{fields,inputs,t_chw_name}'                                  AS t_chw_name,
    doc #>> '{fields,inputs,t_national_identification_number}'            AS t_national_identification_number,
    doc #>> '{fields,inputs,t_chw_id}'                                    AS t_chw_id,
    doc #>> '{fields,inputs,t_chw_phone}'                                 AS t_chw_phone,
    doc #>> '{fields,inputs,user,contact_id}'                             AS user_contact_id,
    doc #>> '{fields,inputs,user,facility_id}'                            AS user_facility_id,

    doc #>> '{fields,patient_age_in_years}'                               AS patient_age_in_years,
    doc #>> '{fields,patient_age_in_months}'                              AS patient_age_in_months,
    doc #>> '{fields,patient_age_in_days}'                                AS patient_age_in_days,
    doc #>> '{fields,patient_age_display}'                                AS patient_age_display,
    doc #>> '{fields,patient_id}'                                         AS patient_id,
    doc #>> '{fields,patient_name}'                                       AS patient_name,
    doc #>> '{fields,patient_pronoun}'                                    AS patient_pronoun,
    doc #>> '{fields,patient_gender}'                                     AS patient_gender,
    doc #>> '{fields,patient_possessive_pronoun}'                         AS patient_possessive_pronoun,
    doc #>> '{fields,patient_gender_pronoun}'                             AS patient_gender_pronoun,
    doc #>> '{fields,patient_phone}'                                      AS patient_phone,
    doc #>> '{fields,place_id}'                                           AS place_id,
    doc #>> '{fields,place_name}'                                         AS place_name,
    doc #>> '{fields,cough}'                                              AS cough,
    doc #>> '{fields,fever}'                                              AS fever,
    doc #>> '{fields,weight_loss}'                                        AS weight_loss,
    doc #>> '{fields,excessive_night_sweat}'                              AS excessive_night_sweat,
    doc #>> '{fields,poor_weight_gain}'                                   AS poor_weight_gain,
    doc #>> '{fields,is_on_tb_treatment}'                                 AS is_on_tb_treatment,
    doc #>> '{fields,client_category}'                                    AS client_category,
    doc #>> '{fields,national_identification_number}'                     AS national_identification_number,
    doc #>> '{fields,barcode_scanner_result}'                             AS barcode_scanner_result,
    doc #>> '{fields,needs_signoff}'                                      AS needs_signoff,

    doc #>> '{field,sputum_collection_refusal,note_to_ha}'    AS note_to_ha,
    
    doc #>> '{fields,sputum_collection_consent,consented_sputum_sample}'           AS consented_sputum_sample,
    doc #>> '{fields,sputum_collection_consent,inform_tb_focal_person}'            AS inform_tb_focal_person,
    doc #>> '{fields,sputum_collection_consent,registered_phone_number}'           AS registered_phone_number,
    doc #>> '{fields,sputum_collection_consent,receive_results_on_same_phonenumber}' AS receive_results_on_same_phonenumber,
    doc #>> '{fields,sputum_collection_consent,enter_new_phone_number}'            AS enter_new_phone_number,
    doc #>> '{fields,sputum_collection_consent,no_registered_phone_number}'        AS no_registered_phone_number,
    doc #>> '{fields,sputum_collection_consent,phonenumber_to_receive_results}'    AS phonenumber_to_receive_results,
    doc #>> '{fields,sputum_collection_consent,results_phone_number}'              AS results_phone_number,

    doc #>> '{fields,sputum_collection,give_patient_instructions}'         AS give_patient_instructions,
    doc #>> '{fields,sputum_collection,has_patient_produced_sputum}'       AS has_patient_produced_sputum,
    doc #>> '{fields,sputum_collection,confirm_container_tightly_closed}'  AS confirm_container_tightly_closed,
    doc #>> '{fields,sputum_collection,confirm_send_sample_for_testing}'   AS confirm_send_sample_for_testing,
    doc #>> '{fields,sputum_collection,leave_sputum_bottle_with_client}'   AS leave_sputum_bottle_with_client,
    doc #>> '{fields,sputum_collection,keep_container_closed}'             AS keep_container_closed,
    doc #>> '{fields,sputum_collection,has_left_sputum_bottle_with_client}' AS has_left_sputum_bottle_with_client,

    doc #>> '{fields,group_summary,group_summary}'                AS group_summary,
    doc #>> '{fields,group_summary,s_summary_submit}'             AS s_summary_submit,
    doc #>> '{fields,group_summary,s_note_person_details}'        AS s_note_person_details,
    doc #>> '{fields,group_summary,s_note_person_details_values}' AS s_note_person_details_values,
    doc #>> '{fields,group_summary,s_note_findings}'              AS s_note_findings,
    doc #>> '{fields,group_summary,s_note_sputum_collection}'     AS s_note_sputum_collection,
    doc #>> '{fields,group_summary,s_note_declined_to_give_sputum}' AS s_note_declined_to_give_sputum,
    doc #>> '{fields,group_summary,s_note_sputum_collected}'      AS s_note_sputum_collected,
    doc #>> '{fields,group_summary,s_note_sputum_not_available}'  AS s_note_sputum_not_available,
    doc #>> '{fields,group_summary,s_note_instructions}'          AS s_note_instructions,
    doc #>> '{fields,group_summary,s_note_please_sync}'           AS s_note_please_sync,


       --- reporting hierarchy
    doc #>> '{contact,_id}'                         AS chw_id,                   
    doc #>> '{contact,parent,_id}'                  AS chw_area_id,  
    doc #>> '{contact,parent,parent,_id}'           AS facility_id,                                    
    doc #>> '{contact,parent,parent,parent,_id}'    AS parish_id,              
    doc #>> '{contact,parent,parent,parent,parent,_id}'           AS district,                 
    doc #>> '{contact,parent,parent,parent,parent,parent,_id}'    AS region    

FROM dwh.cht_data AS couchdb
WHERE (doc ->> 'form') = 'sputum_collection_refusal'
  AND is_current
WITH DATA;

CREATE UNIQUE INDEX sputum_collection_refusal_uuid_idx
    ON report.mv_sputum_collection_refusal USING btree (uuid);

CREATE INDEX sputum_collection_refusal_reported_idx
    ON report.mv_sputum_collection_refusal USING btree (reported);
