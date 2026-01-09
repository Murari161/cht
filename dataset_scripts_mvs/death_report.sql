CREATE MATERIALIZED VIEW cht.mv_death_report_new
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
    doc #>> '{fields,r_summary,submit}'::text[] AS r_summary_submit,
    doc #>> '{fields,r_summary,summary_h1}'::text[] AS r_summary_summary_h1,
    doc #>> '{fields,r_summary,s_person_details}'::text[] AS r_summary_s_person_details,
    doc #>> '{fields,r_summary,s_death_info}'::text[] AS r_summary_s_death_info,
    doc #>> '{fields,r_summary,s_death_date}'::text[] AS r_summary_s_death_date,
    doc #>> '{fields,r_summary,s_death_manner}'::text[] AS r_summary_s_death_manner,
    doc #>> '{fields,r_summary,s_instruction}'::text[] AS r_summary_s_instruction,
    doc #>> '{fields,r_summary,s_inform_super}'::text[] AS r_summary_s_inform_super,
    doc #>> '{fields,r_summary,s_followup}'::text[] AS r_summary_s_followup,
    doc #>> '{fields,r_summary,s_followup_note}'::text[] AS r_summary_s_followup_note,
    doc #>> '{fields,health_center_id}'::text[] AS health_center_id,

    -- New fields from death_report_submission/fields (added as requested)
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

    -- Last column for tracking refresh
    CURRENT_TIMESTAMP AS last_refresh_date

FROM dwh.cht_data
WHERE (doc ->> 'form'::text) = 'death_report'::text
  AND is_current
WITH DATA;

-- Indexes
CREATE INDEX mv_death_report_reported_new
    ON cht.mv_death_report_new USING btree (reported);

CREATE INDEX mv_death_report_chw_id
    ON cht.mv_death_report_new USING btree (chw_id);

ALTER TABLE cht.mv_death_report_new OWNER TO postgres;
GRANT ALL ON TABLE cht.mv_death_report_new TO postgres;
GRANT SELECT ON TABLE cht.mv_death_report_new TO rutayisire;
GRANT SELECT ON TABLE cht.mv_death_report_new TO ssevvume;
GRANT SELECT ON TABLE cht.mv_death_report_new TO ojacob;
GRANT SELECT ON TABLE cht.mv_death_report_new TO jasper_user;
GRANT SELECT ON TABLE cht.mv_death_report_new TO anibary_fellow;
GRANT SELECT ON TABLE cht.mv_death_report_new TO tom_fellow;
GRANT SELECT ON TABLE cht.mv_death_report_new TO albert_fellow;
GRANT SELECT ON TABLE cht.mv_death_report_new TO ssam;
GRANT ALL ON TABLE cht.mv_death_report_new TO baker;
GRANT SELECT ON TABLE cht.mv_death_report_new TO bkronnie;
GRANT SELECT ON TABLE cht.mv_death_report_new TO mkizito;
GRANT SELECT ON TABLE cht.mv_death_report_new TO nmadrine;
GRANT SELECT ON TABLE cht.mv_death_report_new TO frankm;
GRANT SELECT ON TABLE cht.mv_death_report_new TO sarinda;
GRANT SELECT ON TABLE cht.mv_death_report_new TO arindas;
GRANT ALL ON TABLE cht.mv_death_report_new TO jmurari;
GRANT ALL ON TABLE cht.mv_death_report_new TO rabila;
GRANT ALL ON TABLE cht.mv_death_report_new TO pkawuma;
GRANT SELECT ON TABLE cht.mv_death_report_new TO nolivea;