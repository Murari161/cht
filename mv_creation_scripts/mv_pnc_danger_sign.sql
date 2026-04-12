CREATE MATERIALIZED VIEW cht.mv_pnc_danger_sign
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
     doc ->> 'form'::text                             AS  form,
     doc ->> 'from'::text                             AS  from,
   
      doc #>> '{fields,inputs,source}'                      AS source,
      doc #>> '{fields,inputs,source_id}'                   AS source_id,
      doc #>> '{fields,inputs,is_follow_up}'                AS is_follow_up,
      doc #>> '{fields,inputs,contact,_id}'                 AS contact_id,
      doc #>> '{fields,inputs,contact,name}'                AS contact_name,
      doc #>> '{fields,inputs,contact,date_of_birth}'       AS contact_date_of_birth,
      doc #>> '{fields,inputs,contact,sex}'                 AS contact_sex,
      doc #>> '{fields,inputs,contact,parent,_id}'          AS parent_id,
      doc #>> '{fields,is_of_child_bearing_age}'            AS is_of_child_bearing_age,
      doc #>> '{fields,visited_contact_uuid}'               AS visited_contact_uuid,
      doc #>> '{fields,patient_age_in_years}'               AS patient_age_in_years,
      doc #>> '{fields,patient_age_in_months}'              AS patient_age_in_months,
      doc #>> '{fields,patient_age_in_days}'                AS patient_age_in_days,
      doc #>> '{fields,patient_age_display}'                AS patient_age_display,
      doc #>> '{fields,patient_id}'                         AS patient_id,
      doc #>> '{fields,patient_name}'                       AS patient_name,
      doc #>> '{fields,patient_name_with_s}'                AS patient_name_with_s,
      doc #>> '{fields,patient_gender}'                     AS patient_gender,

      doc #>> '{fields,group_danger_sign,visited_health_facility}'         AS visited_health_facility,
      doc #>> '{fields,group_danger_sign,still_experiencing_danger_signs}' AS still_experiencing_danger_signs,
      doc #>> '{fields,group_danger_sign,note_monitor_till_next_pnc_check_up}' AS note_monitor_till_next_pnc_check_up,
      doc #>> '{fields,group_danger_sign,note_still_experiencing_danger_signs}' AS note_still_experiencing_danger_signs,
      doc #>> '{fields,group_danger_sign,note_danger_signs}'               AS note_danger_signs,
      doc #>> '{fields,group_danger_sign,excessive_bleeding}'              AS excessive_bleeding,
      doc #>> '{fields,group_danger_sign,vaginal_discharge}'               AS vaginal_discharge,
      doc #>> '{fields,group_danger_sign,severe_abdominal_pain}'           AS severe_abdominal_pain,
      doc #>> '{fields,group_danger_sign,swelling}'                        AS swelling,
      doc #>> '{fields,group_danger_sign,blurred_vision}'                  AS blurred_vision,
      doc #>> '{fields,group_danger_sign,fever}'                           AS fever,
      doc #>> '{fields,group_danger_sign,excessive_tiredness}'             AS excessive_tiredness,
      doc #>> '{fields,group_danger_sign,breathlessness}'                  AS breathlessness,
      doc #>> '{fields,group_danger_sign,has_danger_signs}'                AS has_danger_signs,
      doc #>> '{fields,group_danger_sign,has_no_danger_signs}'             AS has_no_danger_signs,
      doc #>> '{fields,group_danger_sign,note_refer}'                      AS note_refer,
      doc #>> '{fields,group_danger_sign,referred_to_facility}'            AS referred_to_facility,

      doc #>> '{fields,group_summary,summary_title_label}'           AS summary_title_label,
      doc #>> '{fields,group_summary,s_note_danger_sign}'            AS s_note_danger_sign,
      doc #>> '{fields,group_summary,s_summary_submit}'              AS s_summary_submit,
      doc #>> '{fields,group_summary,s_note_person_details}'         AS s_note_person_details,
      doc #>> '{fields,group_summary,s_note_person_details_values}'  AS s_note_person_details_values,
      doc #>> '{fields,group_summary,s_note_referrals}'              AS s_note_referrals,
      doc #>> '{fields,group_summary,s_note_refer_for_review}'       AS s_note_refer_for_review,
      doc #>> '{fields,group_summary,s_note_refer_immediately_for}'  AS s_note_refer_immediately_for,
      doc #>> '{fields,group_summary,s_note_excessive_bleeding}'     AS s_note_excessive_bleeding,
      doc #>> '{fields,group_summary,s_note_vaginal_discharge}'      AS s_note_vaginal_discharge,
      doc #>> '{fields,group_summary,s_note_severe_abdominal_pain}'  AS s_note_severe_abdominal_pain,
      doc #>> '{fields,group_summary,s_note_swelling}'               AS s_note_swelling,
      doc #>> '{fields,group_summary,s_note_blurred_vision}'         AS s_note_blurred_vision,
      doc #>> '{fields,group_summary,s_note_fever}'                  AS s_note_fever,
      doc #>> '{fields,group_summary,s_note_excessive_tiredness}'    AS s_note_excessive_tiredness,
      doc #>> '{fields,group_summary,s_note_breathlessness}'         AS s_note_breathlessness,
      doc #>> '{fields,group_summary,s_note_follow_up_task}'         AS s_note_follow_up_task,
      doc #>> '{fields,group_summary,s_note_please_follow_up}'       AS s_note_please_follow_up,



  --- reporting hierarchy
      doc #>> '{contact,_id}'                         AS chw_id,                   
      doc #>> '{contact,parent,_id}'                  AS chw_area_id,  
      doc #>> '{contact,parent,parent,_id}'           AS facility_id,                                    
      doc #>> '{contact,parent,parent,parent,_id}'    AS parish,              
      doc #>> '{contact,parent,parent,parent,parent,_id}'           AS district,   
      doc #>> '{contact,parent,parent,parent,parent,parent,_id}'           AS region,
      CURRENT_TIMESTAMP AS last_refresh_date                 

FROM dwh.cht_data
WHERE (doc ->> 'form') = 'pnc_danger_sign'
  AND is_current
WITH DATA;


CREATE INDEX pnc_danger_sign_reported_idx
    ON cht.mv_pnc_danger_sign USING btree (reported);
