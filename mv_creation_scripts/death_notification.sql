CREATE MATERIALIZED VIEW cht.mv_death_notification
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
    doc #>> '{fields,inputs,t_client_death_date}'::text[] AS inputs_t_client_death_date,
    doc #>> '{fields,inputs,t_client_birth_date}'::text[] AS inputs_t_client_birth_date,
    doc #>> '{fields,inputs,t_client_name}'::text[] AS inputs_t_client_name,
    doc #>> '{fields,inputs,t_client_id}'::text[] AS inputs_t_client_id,
    doc #>> '{fields,inputs,t_client_national_identification_number}'::text[] AS inputs_t_client_national_identification_number,
    doc #>> '{fields,inputs,t_client_sex}'::text[] AS inputs_t_client_sex,
    doc #>> '{fields,inputs,t_client_age}'::text[] AS inputs_t_client_age,
    doc #>> '{fields,inputs,t_client_death_report_date}'::text[] AS inputs_t_client_death_report_date,
    doc #>> '{fields,inputs,t_client_place_of_death}'::text[] AS inputs_t_client_place_of_death,
    doc #>> '{fields,inputs,t_client_place_of_death_other}'::text[] AS inputs_t_client_place_of_death_other,
    doc #>> '{fields,inputs,t_client_cause_of_death}'::text[] AS inputs_t_client_cause_of_death,
    doc #>> '{fields,inputs,t_user_contact_id}'::text[] AS inputs_t_user_contact_id,
    doc #>> '{fields,inputs,t_user_name}'::text[] AS inputs_t_user_name,
    doc #>> '{fields,inputs,t_user_phone}'::text[] AS inputs_t_user_phone,
    doc #>> '{fields,inputs,user,contact_id}'::text[] AS inputs_user_contact_id,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    doc #>> '{fields,inputs,contact,date_of_birth}'::text[] AS inputs_contact_date_of_birth,
    doc #>> '{fields,inputs,contact,sex}'::text[] AS inputs_contact_sex,
    doc #>> '{fields,inputs,contact,parent,_id}'::text[] AS inputs_contact_parent_id,
    doc #>> '{fields,inputs,contact,parent,parent,_id}'::text[] AS inputs_contact_parent_parent_id,
    doc #>> '{fields,health_center_id}'::text[] AS health_center_id,
    doc #>> '{fields,supervisor_id}'::text[] AS supervisor_id,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,needs_signoff}'::text[] AS needs_signoff,
    doc #>> '{fields,date_of_death}'::text[] AS date_of_death,
    doc #>> '{fields,notification_details,user_details}'::text[] AS notification_details_user_details,
    doc #>> '{fields,notification_details,client_details}'::text[] AS notification_details_client_details,
    doc #>> '{fields,notification_details,death_details}'::text[] AS notification_details_death_details,
    doc #>> '{fields,notification_details,note_call_vht}'::text[] AS notification_details_note_call_vht,
    doc #>> '{fields,notification_details,call_button}'::text[] AS notification_details_call_button,
    doc #>> '{fields,notification_details,call_summary}'::text[] AS notification_details_call_summary,
    doc #>> '{fields,notification_details,verification_status}'::text[] AS notification_details_verification_status,
    doc #>> '{fields,notification_details,death_not_verified_reason}'::text[] AS notification_details_death_not_verified_reason,
    doc #>> '{fields,notification_details,not_verified_vht_note}'::text[] AS notification_details_not_verified_vht_note,
    doc #>> '{fields,notification_details,actions}'::text[] AS notification_details_actions,
    doc #>> '{fields,notification_details,action_others}'::text[] AS notification_details_action_others,
    doc #>> '{fields,notification_details,action_note}'::text[] AS notification_details_action_note,
    doc #>> '{fields,r_summary,submit}'::text[] AS r_summary_submit,
    doc #>> '{fields,r_summary,summary_h1}'::text[] AS r_summary_summary_h1,
    doc #>> '{fields,r_summary,s_person_details}'::text[] AS r_summary_s_person_details,
    doc #>> '{fields,r_summary,s_death_verification_status}'::text[] AS r_summary_s_death_verification_status,
    doc #>> '{fields,r_summary,verification_status_label}'::text[] AS r_summary_verification_status_label,
    doc #>> '{fields,r_summary,s_verification_status}'::text[] AS r_summary_s_verification_status,
    doc #>> '{fields,r_summary,actions_labels_en}'::text[] AS r_summary_actions_labels_en,
    doc #>> '{fields,r_summary,actions_labels_lg}'::text[] AS r_summary_actions_labels_lg,
    doc #>> '{fields,r_summary,s_actions_taken}'::text[] AS r_summary_s_actions_taken,
    doc #>> '{fields,r_summary,s_findings}'::text[] AS r_summary_s_findings,
    doc #>> '{fields,r_summary,s_instruction}'::text[] AS r_summary_s_instruction,
    doc #>> '{fields,r_summary,s_inform_super}'::text[] AS r_summary_s_inform_super,
    doc #>> '{fields,r_summary,s_followup}'::text[] AS r_summary_s_followup,
    doc #>> '{fields,r_summary,s_followup_note}'::text[] AS r_summary_s_followup_note,

    -- New fields from death_notification_submission/fields (added for consistency)
    doc #>> '{fields,status}'::text[] AS submission_status,
    doc #>> '{fields,death_report}'::text[] AS submission_death_report,
    doc #>> '{fields,place_id}'::text[] AS submission_place_id,
    doc #>> '{fields,needs_signoff}'::text[] AS submission_needs_signoff,
    doc #>> '{fields,date_of_death}'::text[] AS submission_date_of_death,
    doc #>> '{fields,d_client_death_date}'::text[] AS submission_d_client_death_date,
    doc #>> '{fields,d_client_birth_date}'::text[] AS submission_d_client_birth_date,
    doc #>> '{fields,d_client_name}'::text[] AS submission_d_client_name,
    doc #>> '{fields,d_client_id}'::text[] AS submission_d_client_id,
    doc #>> '{fields,d_client_national_identification_number}'::text[] AS submission_d_client_national_identification_number,
    doc #>> '{fields,d_client_sex}'::text[] AS submission_d_client_sex,
    doc #>> '{fields,d_client_age}'::text[] AS submission_d_client_age,
    doc #>> '{fields,d_client_death_report_date}'::text[] AS submission_d_client_death_report_date,
    doc #>> '{fields,d_client_place_of_death}'::text[] AS submission_d_client_place_of_death,
    doc #>> '{fields,d_client_place_of_death_other}'::text[] AS submission_d_client_place_of_death_other,
    doc #>> '{fields,d_client_cause_of_death}'::text[] AS submission_d_client_cause_of_death,
    doc #>> '{fields,d_user_contact_id}'::text[] AS submission_d_user_contact_id,
    doc #>> '{fields,d_user_name}'::text[] AS submission_d_user_name,
    doc #>> '{fields,d_user_phone}'::text[] AS submission_d_user_phone,

    -- Last column for tracking refresh
    CURRENT_TIMESTAMP AS last_refresh_date

FROM dwh.cht_data couchdb
WHERE (doc ->> 'form'::text) = 'death_notification'::text
  AND is_current
WITH DATA;

-- Indexes
CREATE INDEX mv_death_notification_reported
    ON cht.mv_death_notification USING btree (reported);

CREATE INDEX mv_death_notification_chw_id
    ON cht.mv_death_notification USING btree (chw_id);