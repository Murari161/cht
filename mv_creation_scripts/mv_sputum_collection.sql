REATE MATERIALIZED VIEW report.mv_sputum_collection
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
    doc #>> '{fields,inputs,source}'                          AS source,
    doc #>> '{fields,inputs,source_id}'                       AS source_id,
    doc #>> '{fields,inputs,t_barcode_scanner_result}'        AS t_barcode_scanner_result,
    doc #>> '{fields,inputs,t_results_phone_number}'          AS t_results_phone_number,
    doc #>> '{fields,inputs,t_cough}'                         AS t_cough,
    doc #>> '{fields,inputs,t_fever}'                         AS t_fever,
    doc #>> '{fields,inputs,t_weight_loss}'                  AS t_weight_loss,
    doc #>> '{fields,inputs,t_excessive_night_sweat}'        AS t_excessive_night_sweat,
    doc #>> '{fields,inputs,t_poor_weight_gain}'             AS t_poor_weight_gain,
    doc #>> '{fields,inputs,t_is_on_tb_treatment}'           AS t_is_on_tb_treatment,
    doc #>> '{fields,inputs,contact,_id}'                    AS contact_id,
    doc #>> '{fields,inputs,contact,name}'                   AS contact_name,
    doc #>> '{fields,inputs,contact,date_of_birth}'          AS contact_date_of_birth,
    doc #>> '{fields,inputs,contact,sex}'                    AS contact_sex,
    doc #>> '{fields,inputs,contact,national_identification_number}' AS national_identification_number,
    doc #>> '{fields,inputs,contact,client_category}'        AS client_category,
    doc #>> '{fields,inputs,contact,parent,_id}'             AS parent__id,

    doc #>> '{fields,patient_age_in_years}'                  AS patient_age_in_years,
    doc #>> '{fields,patient_age_in_months}'                 AS patient_age_in_months,
    doc #>> '{fields,patient_age_in_days}'                   AS patient_age_in_days,
    doc #>> '{fields,patient_age_display}'                   AS patient_age_display,
    doc #>> '{fields,patient_id}'                             AS patient_id,
    doc #>> '{fields,patient_name}'                           AS patient_name,
    doc #>> '{fields,patient_gender}'                         AS patient_gender,
    doc #>> '{fields,patient_pronoun}'                        AS patient_pronoun,
    doc #>> '{fields,barcode_scanner_result}'                 AS barcode_scanner_result,
    doc #>> '{fields,cough}'                                   AS cough,
    doc #>> '{fields,fever}'                                   AS fever,
    doc #>> '{fields,weight_loss}'                             AS weight_loss,
    doc #>> '{fields,excessive_night_sweat}'                  AS excessive_night_sweat,
    doc #>> '{fields,poor_weight_gain}'                        AS poor_weight_gain,
    doc #>> '{fields,is_on_tb_treatment}'                      AS is_on_tb_treatment,
    doc #>> '{fields,national_identification_number}'          AS national_identification_number,
    doc #>> '{fields,client_category}'                         AS client_category,
    doc #>> '{fields,patient_sputum_collection_date}'          AS patient_sputum_collection_date,
   
    doc #>> '{fields,sputum_collection,is_patient_available}'               AS is_patient_available,
    doc #>> '{fields,sputum_collection,patient_availability_date}'         AS patient_availability_date,
    doc #>> '{fields,sputum_collection,has_produced_sputum}'                AS has_produced_sputum,
    doc #>> '{fields,sputum_collection,confirm_bottle_is_tightly_closed}'   AS confirm_bottle_is_tightly_closed,
    doc #>> '{fields,sputum_collection,confirm_send_sample_for_testing}'    AS confirm_send_sample_for_testing,
    doc #>> '{fields,sputum_collection,inform_on_importance_of_testing}'    AS inform_on_importance_of_testing,
    doc #>> '{fields,sputum_collection_consent,results_phone_number}'   AS results_phone_number,
    doc #>> '{fields,group_summary,s_note_sputum_collection}'       AS s_note_sputum_collection,
    doc #>> '{fields,group_summary,s_summary_submit}'              AS s_summary_submit,
    doc #>> '{fields,group_summary,s_note_person_details}'         AS s_note_person_details,
    doc #>> '{fields,group_summary,s_note_person_details_values}'  AS s_note_person_details_values,
    doc #>> '{fields,group_summary,s_note_findings}'               AS s_note_findings,
    doc #>> '{fields,group_summary,s_note_sputum_collected}'       AS s_note_sputum_collected,
    doc #>> '{fields,group_summary,s_note_client_not_available}'   AS s_note_client_not_available,
    doc #>> '{fields,group_summary,s_note_sputum_not_available}'   AS s_note_sputum_not_available,
    doc #>> '{fields,group_summary,s_note_instructions}'           AS s_note_instructions,
    doc #>> '{fields,group_summary,s_note_please_sync}'            AS s_note_please_sync,
    doc #>> '{fields,group_summary,s_note_follow_up_task}'         AS s_note_follow_up_task,
    doc #>> '{fields,group_summary,s_note_availability_date}'      AS s_note_availability_date,
    doc #>> '{fields,group_summary,s_note_referral}'               AS s_note_referral,
    doc #>> '{fields,group_summary,refer_patient_to_facility}'     AS refer_patient_to_facility,

       --- reporting hierarchy
    doc #>> '{contact,_id}'                         AS chw_id,                   
    doc #>> '{contact,parent,_id}'                  AS chw_area_id,  
    doc #>> '{contact,parent,parent,_id}'           AS facility_id,                                    
    doc #>> '{contact,parent,parent,parent,_id}'    AS parish_id,              
    doc #>> '{contact,parent,parent,parent,parent,_id}'           AS district,                 
    doc #>> '{contact,parent,parent,parent,parent,parent,_id}'    AS region    

FROM dwh.cht_data AS couchdb
WHERE (doc ->> 'form') = 'sputum_collection'
  AND is_current
WITH DATA;

CREATE UNIQUE INDEX sputum_collection_uuid_idx
    ON report.mv_sputum_collection USING btree (uuid);

CREATE INDEX sputum_collection_reported_idx
    ON report.mv_sputum_collection USING btree (reported);
