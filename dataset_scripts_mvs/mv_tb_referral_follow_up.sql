CREATE MATERIALIZED VIEW cht.mv_tb_referral_follow_up
TABLESPACE ts_report
AS
SELECT
    doc ->> '_id'                                           AS doc_id,
    doc ->> '_rev'                                          AS rev,                                  -- [NEW FIELD]
    doc ->> 'form'                                          AS form,
    to_timestamp(NULLIF(doc ->> 'reported_date','')::bigint / 1000.0) AS reported,
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
     doc ->> 'from'                                          AS from,                             -- [NEW FIELD]
     doc #>> '{fields,inputs,source}'                                    AS source,
     doc #>> '{fields,inputs,source_id}'                                 AS source_id,
     doc #>> '{fields,inputs,t_tb_result}'                               AS t_tb_result,
     doc #>> '{fields,inputs,user,contact_id}'                           AS user_contact_id,
     doc #>> '{fields,inputs,user,facility_id}'                          AS user_facility_id,
     doc #>> '{fields,inputs,contact,_id}'                               AS contact_id,
     doc #>> '{fields,inputs,contact,name}'                              AS contact_name,
     doc #>> '{fields,inputs,contact,date_of_birth}'                     AS contact_date_of_birth,
     doc #>> '{fields,inputs,contact,sex}'                               AS contact_sex,
     doc #>> '{fields,inputs,contact,parent,_id}'                        AS parent__id,
     doc #>> '{fields,inputs,contact,parent,name}'                       AS inputs_parent_name,
     doc #>> '{fields,inputs,contact,parent,parent,_id}'                 AS parent_parent__id,
     doc #>> '{fields,inputs,contact,parent,parent,name}'                AS parent_parent_name,
     doc #>> '{fields,inputs,contact,parent,parent,supervisor}'          AS supervisor,
     doc #>> '{fields,inputs,contact,parent,parent,phone}'               AS phone,
     doc #>> '{fields,inputs,contact,parent,parent,village}'             AS village,
     doc #>> '{fields,inputs,contact,parent,parent,contact,_id}'         AS contact__id,
     doc #>> '{fields,inputs,contact,parent,parent,contact,phone}'       AS contact_phone,
     doc #>> '{fields,inputs,contact,parent,parent,contact,name}'        AS inputs_contact_name,
     doc #>> '{fields,inputs,contact,parent,parent,parent,_id}'          AS parent_parent_parent__id,
    doc #>> '{fields,patient_id}'            AS patient_id,
    doc #>> '{fields,patient_name}'          AS patient_name,
    doc #>> '{fields,patient_gender}'        AS patient_gender,
    doc #>> '{fields,patient_age_in_years}'  AS patient_age_in_years,
    doc #>> '{fields,patient_age_in_months}' AS patient_age_in_months,
    doc #>> '{fields,patient_age_in_days}'   AS patient_age_in_days,
    doc #>> '{fields,patient_age_display}'   AS patient_age_display,
    doc #>> '{fields,patient_pronoun}'       AS patient_pronoun,
    doc #>> '{fields,place_name}'            AS place_name,
    doc #>> '{fields,needs_signoff}'         AS needs_signoff,

    doc #>> '{fields,treatment_information,patient_started_treatment}'  AS patient_started_treatment,
    doc #>> '{fields,treatment_information,treatment_date}'             AS treatment_date,
    doc #>> '{fields,referral_notification,encourage_to_to_facility}'       AS encourage_to_to_facility,
    doc #>> '{fields,referral_notification,referred_to_health_facility}'    AS referred_to_health_facility,
    doc #>> '{fields,referral_notification,went_to_facility_as_referred}'             AS went_to_facility_as_referred,

    doc #>> '{fields,group_summary,s_note_danger_sign}'             AS s_note_danger_sign,
    doc #>> '{fields,group_summary,s_summary_submit}'              AS s_summary_submit,
    doc #>> '{fields,group_summary,s_note_person_details}'         AS s_note_person_details,
    doc #>> '{fields,group_summary,s_note_person_details_values}'  AS s_note_person_details_values,
    doc #>> '{fields,group_summary,s_note_findings}'               AS s_note_findings,
    doc #>> '{fields,group_summary,s_note_referral_completed}'     AS s_note_referral_completed,
    doc #>> '{fields,group_summary,s_note_referral_not_completed}' AS s_note_referral_not_completed,
    doc #>> '{fields,group_summary,s_note_instructions}'           AS s_note_instructions,
    doc #>> '{fields,group_summary,s_note_please_sync}'            AS s_note_please_sync,
    doc #>> '{fields,group_summary,s_note_follow_up}'              AS s_note_follow_up,
    doc #>> '{fields,group_summary,s_note_follow_up_note}'         AS s_note_follow_up_note,
    doc #>> '{fields,group_summary,s_note_referral}'               AS s_note_referral,
    doc #>> '{fields,group_summary,s_note_refer_patient}'          AS s_note_refer_patient,

    doc #>> '{contact,_id}'                         AS chw_id,                   
    doc #>> '{contact,parent,parent,_id}'           AS chw_area_id,                                    
    doc #>> '{contact,parent,parent,parent,_id}'    AS facility_id,              
    doc #>> '{contact,parent,parent,parent,parent,_id}'           AS district,   
    doc #>> '{contact,parent,parent,parent,parent,parent,_id}'           AS region ,
    CURRENT_TIMESTAMP AS last_refresh_date                


FROM dwh.cht_data
WHERE (doc ->> 'form') = 'tb_referral_follow_up'
  AND is_current
WITH DATA;
CREATE INDEX tb_referral_follow_up_reported_idx
    ON cht.mv_tb_referral_follow_up USING btree (reported);
