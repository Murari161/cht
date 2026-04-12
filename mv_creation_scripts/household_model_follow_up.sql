
CREATE MATERIALIZED VIEW cht.mv_household_model_follow_up_new
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
    doc #>> '{fields,inputs,t_hh_head_name}'::text[] AS inputs_t_hh_head_name,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    doc #>> '{fields,inputs,contact,parent,village}'::text[] AS inputs_contact_parent_village,
    doc #>> '{fields,inputs,contact,contact,name}'::text[] AS inputs_contact_contact_name,
    doc #>> '{fields,visited_contact_uuid}'::text[] AS visited_contact_uuid,
    doc #>> '{fields,place_id}'::text[] AS place_id,
    doc #>> '{fields,place_name}'::text[] AS place_name,
    doc #>> '{fields,hh_head_name}'::text[] AS hh_head_name,
    doc #>> '{fields,chw_village}'::text[] AS chw_village,
    doc #>> '{fields,current_gps}'::text[] AS current_gps,
    doc #>> '{fields,needs_signoff}'::text[] AS needs_signoff,
    doc #>> '{fields,hh_head}'::text[] AS hh_head,
    doc #>> '{fields,geolocation,latitude}'::text[] AS geolocation_latitude,
    doc #>> '{fields,geolocation,longitude}'::text[] AS geolocation_longitude,
    doc #>> '{fields,geolocation,altitude}'::text[] AS geolocation_altitude,
    doc #>> '{fields,geolocation,accuracy}'::text[] AS geolocation_accuracy,
    doc #>> '{fields,geolocation,note_no_hh_gps}'::text[] AS geolocation_note_no_hh_gps,
    doc #>> '{fields,geolocation,want_to_capture_gps}'::text[] AS geolocation_want_to_capture_gps,
    doc #>> '{fields,geolocation,ensure_gps}'::text[] AS geolocation_ensure_gps,
    doc #>> '{fields,geolocation,gps}'::text[] AS geolocation_gps,
    doc #>> '{fields,geolocation,coordinates}'::text[] AS geolocation_coordinates,
    doc #>> '{fields,geolocation,additional_comments}'::text[] AS geolocation_additional_comments,
    doc #>> '{fields,group_wash,hh_in_sanitary_dwelling_house}'::text[] AS hh_in_sanitary_dwelling_house,
    doc #>> '{fields,group_wash,hh_access_safe_water_source}'::text[] AS hh_access_safe_water_source,
    doc #>> '{fields,group_wash,hh_have_safe_drinking_water}'::text[] AS hh_have_safe_drinking_water,
    doc #>> '{fields,group_wash,hh_have_sanitary_kitchen}'::text[] AS hh_have_sanitary_kitchen,
    doc #>> '{fields,group_wash,hh_have_drying_rack}'::text[] AS hh_have_drying_rack,
    doc #>> '{fields,group_wash,hh_have_backyard_garden}'::text[] AS hh_have_backyard_garden,
    doc #>> '{fields,group_wash,hh_have_rubbish_pit}'::text[] AS hh_have_rubbish_pit,
    doc #>> '{fields,group_wash,hh_have_bath_shelter}'::text[] AS hh_have_bath_shelter,
    doc #>> '{fields,group_wash,hh_sanitary_facility}'::text[] AS hh_sanitary_facility,
    doc #>> '{fields,group_wash,hh_sharing_sanitary_facility}'::text[] AS hh_sharing_sanitary_facility,
    doc #>> '{fields,group_wash,verify_hh_sharing_sanitary_facility}'::text[] AS verify_hh_sharing_sanitary_facility,
    doc #>> '{fields,group_wash,hh_kind_of_public_toilet}'::text[] AS hh_kind_of_public_toilet,
    doc #>> '{fields,group_wash,hh_latrine_fly_proof}'::text[] AS hh_latrine_fly_proof,
    doc #>> '{fields,group_wash,hh_floor_of_toilet_or_latrine}'::text[] AS hh_floor_of_toilet_or_latrine,
    doc #>> '{fields,group_wash,hh_toilet_conected_to_sewer}'::text[] AS hh_toilet_conected_to_sewer,
    doc #>> '{fields,group_wash,hh_sanitary_facility_filled_up}'::text[] AS hh_sanitary_facility_filled_up,
    doc #>> '{fields,group_wash,hh_empited_pit_latrine_or_septic_tank}'::text[] AS hh_empited_pit_latrine_or_septic_tank,
    doc #>> '{fields,group_wash,hh_emptying_services}'::text[] AS hh_emptying_services,
    doc #>> '{fields,group_wash,hh_emptied_contents_location}'::text[] AS hh_emptied_contents_location,
    doc #>> '{fields,group_wash,hh_handwashing_near_toilet_latrine}'::text[] AS hh_handwashing_near_toilet_latrine,
    doc #>> '{fields,group_wash,hh_handwashing_facility_status}'::text[] AS hh_handwashing_facility_status,
    doc #>> '{fields,group_wash,hh_is_odf}'::text[] AS hh_is_odf,
    doc #>> '{fields,hh_model_assessment,hh_have_drying_lines}'::text[] AS hh_have_drying_lines,
    doc #>> '{fields,hh_model_assessment,hh_have_animal_house}'::text[] AS hh_have_animal_house,
    doc #>> '{fields,hh_model_assessment,hh_have_food_storage_access}'::text[] AS hh_have_food_storage_access,
    doc #>> '{fields,hh_model_assessment,hh_compound_well_maintained}'::text[] AS hh_compound_well_maintained,
    doc #>> '{fields,hh_model_assessment,hh_have_vermin_rodent}'::text[] AS hh_have_vermin_rodent,
    doc #>> '{fields,hh_model_assessment,n_train_on_missing_indicators}'::text[] AS n_train_on_missing_indicators,
    doc #>> '{fields,hh_model_assessment,n_animal_house_indicator}'::text[] AS n_animal_house_indicator,
    doc #>> '{fields,hh_model_assessment,n_adequate_drying_lines_indicator}'::text[] AS n_adequate_drying_lines_indicator,
    doc #>> '{fields,hh_model_assessment,n_food_storage_indicator}'::text[] AS n_food_storage_indicator,
    doc #>> '{fields,hh_model_assessment,n_well_maintained_compound_indicator}'::text[] AS n_well_maintained_compound_indicator,
    doc #>> '{fields,hh_model_assessment,n_vermin_rodent_control_indicator}'::text[] AS n_vermin_rodent_control_indicator,
    doc #>> '{fields,hh_model_assessment,follow_household}'::text[] AS follow_household,
    doc #>> '{fields,hh_model_assessment,next_household_follow_up_date}'::text[] AS next_household_follow_up_date,
    doc #>> '{fields,is_model_household}'::text[] AS is_model_household,
    doc #>> '{fields,next_wash_report_task_date}'::text[] AS next_wash_report_task_date,
    doc #>> '{fields,group_summary,s_note_household_model_follow_up}'::text[] AS s_note_household_model_follow_up,
    doc #>> '{fields,group_summary,s_note_be_sure_to_submit}'::text[] AS s_note_be_sure_to_submit,
    doc #>> '{fields,group_summary,s_note_household_details}'::text[] AS s_note_household_details,
    doc #>> '{fields,group_summary,s_note_hh_head_details}'::text[] AS s_note_hh_head_details,
    doc #>> '{fields,group_summary,s_note_findings}'::text[] AS s_note_findings,
    doc #>> '{fields,group_summary,s_note_model_household}'::text[] AS s_note_model_household,
    doc #>> '{fields,group_summary,s_note_not_a_model_household}'::text[] AS s_note_not_a_model_household,
    doc #>> '{fields,group_summary,s_note_follow_up}'::text[] AS s_note_follow_up,
    doc #>> '{fields,group_summary,s_note_wash_follow_up}'::text[] AS s_note_wash_follow_up,
    doc #>> '{fields,group_summary,s_note_no_wash_follow_up}'::text[] AS s_note_no_wash_follow_up,

    -- Last column for tracking refresh
    CURRENT_TIMESTAMP AS last_refresh_date

FROM dwh.cht_data
WHERE (doc ->> 'form'::text) = 'household_model_follow_up'::text
  AND is_current
WITH DATA;

-- Indexes
CREATE INDEX mv_household_model_follow_up_new_reported
    ON cht.mv_household_model_follow_up_new USING btree (reported);

CREATE INDEX mv_household_model_follow_up_new_chw_id
    ON cht.mv_household_model_follow_up_new USING btree (chw_id);