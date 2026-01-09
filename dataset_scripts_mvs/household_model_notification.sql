CREATE MATERIALIZED VIEW cht.mv_household_model_notification
TABLESPACE ts_report
AS
SELECT
    -- Standard fields (appear in all forms)
    doc ->> '_id'::text AS uuid,
    doc ->> 'form'::text AS form,
    doc ->> 'from'::text AS submitter,
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
    doc #>> '{contact,_id}'::text[] AS chw_id,
    doc #>> '{contact,parent,_id}'::text[] AS contact_chw_area_id,
    doc #>> '{contact,parent,parent,_id}'::text[] AS contact_facility_id,
    doc #>> '{contact,parent,parent,parent,_id}'::text[] AS parish_id,
    doc #>> '{contact,parent,parent,parent,parent,_id}'::text[] AS district_id,
    doc #>> '{contact,parent,parent,parent,parent,parent,_id}'::text[] AS region_id,

    -- Form-specific fields (from the XML)
    doc #>> '{fields,inputs,source}'::text[] AS inputs_source,
    doc #>> '{fields,inputs,source_id}'::text[] AS inputs_source_id,
    doc #>> '{fields,inputs,t_sanitary_dwelling_house}'::text[] AS t_sanitary_dwelling_house,
    doc #>> '{fields,inputs,t_sanitary_kitchen}'::text[] AS t_sanitary_kitchen,
    doc #>> '{fields,inputs,t_drying_rack}'::text[] AS t_drying_rack,
    doc #>> '{fields,inputs,t_bath_shelter_with_soak_pit}'::text[] AS t_bath_shelter_with_soak_pit,
    doc #>> '{fields,inputs,t_sanitation_facility}'::text[] AS t_sanitation_facility,
    doc #>> '{fields,inputs,t_hh_latrine_fly_proof}'::text[] AS t_hh_latrine_fly_proof,
    doc #>> '{fields,inputs,t_hh_is_odf}'::text[] AS t_hh_is_odf,
    doc #>> '{fields,inputs,t_handwashing_facility_running_water}'::text[] AS t_handwashing_facility_running_water,
    doc #>> '{fields,inputs,t_rubbish_pit}'::text[] AS t_rubbish_pit,
    doc #>> '{fields,inputs,t_access_to_safe_water}'::text[] AS t_access_to_safe_water,
    doc #>> '{fields,inputs,t_adequate_drying_lines}'::text[] AS t_adequate_drying_lines,
    doc #>> '{fields,inputs,t_animal_house}'::text[] AS t_animal_house,
    doc #>> '{fields,inputs,t_food_storage}'::text[] AS t_food_storage,
    doc #>> '{fields,inputs,t_well_maintained_compound}'::text[] AS t_well_maintained_compound,
    doc #>> '{fields,inputs,t_vector_and_vermin_control}'::text[] AS t_vector_and_vermin_control,
    doc #>> '{fields,inputs,t_hh_head_name}'::text[] AS t_hh_head_name,
    doc #>> '{fields,inputs,t_place_name}'::text[] AS t_place_name,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    doc #>> '{fields,inputs,contact,parent,village}'::text[] AS inputs_contact_parent_village,
    doc #>> '{fields,inputs,contact,contact,name}'::text[] AS inputs_contact_contact_name,
    doc #>> '{fields,visited_contact_uuid}'::text[] AS visited_contact_uuid,
    doc #>> '{fields,place_id}'::text[] AS place_id,
    doc #>> '{fields,place_name}'::text[] AS place_name,
    doc #>> '{fields,hh_head_name}'::text[] AS hh_head_name,
    doc #>> '{fields,chw_village}'::text[] AS chw_village,
    doc #>> '{fields,notification,header_notification}'::text[] AS header_notification,
    doc #>> '{fields,notification,note_sanaitary_dwelling_house}'::text[] AS note_sanaitary_dwelling_house,
    doc #>> '{fields,notification,note_sanitary_kitchen}'::text[] AS note_sanitary_kitchen,
    doc #>> '{fields,notification,note_drying_rack}'::text[] AS note_drying_rack,
    doc #>> '{fields,notification,note_bath_shelter_with_soak_pit}'::text[] AS note_bath_shelter_with_soak_pit,
    doc #>> '{fields,notification,note_sanitation_facility}'::text[] AS note_sanitation_facility,
    doc #>> '{fields,notification,note_handwashing_facility_running_water}'::text[] AS note_handwashing_facility_running_water,
    doc #>> '{fields,notification,note_rubbish_pit}'::text[] AS note_rubbish_pit,
    doc #>> '{fields,notification,note_access_to_safe_water}'::text[] AS note_access_to_safe_water,
    doc #>> '{fields,notification,note_adequate_drying_lines}'::text[] AS note_adequate_drying_lines,
    doc #>> '{fields,notification,note_animal_house}'::text[] AS note_animal_house,
    doc #>> '{fields,notification,note_food_storage}'::text[] AS note_food_storage,
    doc #>> '{fields,notification,note_well_maintained_compound}'::text[] AS note_well_maintained_compound,
    doc #>> '{fields,notification,note_vector_and_vermin_control}'::text[] AS note_vector_and_vermin_control,
    doc #>> '{fields,notification,household_follow_up_date}'::text[] AS household_follow_up_date,
    doc #>> '{fields,group_notification_summary,s_note_household_details}'::text[] AS s_note_household_details,
    doc #>> '{fields,group_notification_summary,s_note_patient_details_values}'::text[] AS s_note_patient_details_values,
    doc #>> '{fields,group_notification_summary,household_findings}'::text[] AS household_findings,
    doc #>> '{fields,group_notification_summary,household_model}'::text[] AS household_model,
    doc #>> '{fields,group_notification_summary,s_note_followup}'::text[] AS s_note_followup,
    doc #>> '{fields,group_notification_summary,note_follow_date}'::text[] AS note_follow_date,

    -- Last column for tracking refresh
    CURRENT_TIMESTAMP AS last_refresh_date

FROM dwh.cht_data couchdb
WHERE (doc ->> 'form'::text) = 'household_model_notification'::text
  AND is_current
WITH DATA;

-- Indexes
CREATE INDEX mv_household_model_notification_reported
    ON cht.mv_household_model_notification USING btree (reported);

CREATE INDEX mv_household_model_notificationn_chw_id
    ON cht.mv_household_model_notification USING btree (chw_id);