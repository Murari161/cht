CREATE MATERIALIZED VIEW cht.mv_ha_danger_signs_follow_up_new
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

    doc #>> '{fields,inputs,source}'::text[]                 AS source,
    doc #>> '{fields,inputs,source_id}'::text[]              AS source_id,
    doc #>> '{fields,inputs,t_place_name}'::text[]           AS t_place_name,
    doc #>> '{fields,inputs,t_created_by_doc}'::text[]       AS t_created_by_doc,
    doc #>> '{fields,inputs,t_place_id}'::text[]             AS t_place_id,
    doc #>> '{fields,inputs,t_patient_name}'::text[]         AS t_patient_name,
    doc #>> '{fields,inputs,t_patient_id}'::text[]           AS t_patient_id,
    doc #>> '{fields,inputs,t_vht_name}'::text[]             AS t_vht_name,
    doc #>> '{fields,inputs,t_vht_phone}'::text[]            AS t_vht_phone,
    doc #>> '{fields,inputs,t_patient_age_in_years}'::text[] AS t_patient_age_in_years,
    doc #>> '{fields,inputs,t_patient_age_in_months}'::text[] AS t_patient_age_in_months,
    doc #>> '{fields,inputs,t_patient_age_in_days}'::text[]   AS t_patient_age_in_days,
    doc #>> '{fields,inputs,t_patient_age_display}'::text[]  AS t_patient_age_display,
    doc #>> '{fields,inputs,t_patient_sex}'::text[]          AS t_patient_sex,
    doc #>> '{fields,inputs,t_source}'::text[]               AS t_source,
    doc #>> '{fields,inputs,t_source_id}'::text[]            AS t_source_id,
    doc #>> '{fields,inputs,t_danger_signs}'::text[]         AS t_danger_signs,
    doc #>> '{fields,inputs,user,contact_id}'::text[]        AS user_contact_id,
    doc #>> '{fields,inputs,user,facility_id}'::text[]       AS user_facility_id,
    doc #>> '{fields,place_id}'::text[]                       AS place_id,
    doc #>> '{fields,place_name}'::text[]                     AS place_name,
    doc #>> '{fields,needs_signoff}'::text[]                  AS needs_signoff, --(true)
    doc #>> '{fields,group_danger,danger_signs}'::text[]                     AS danger_signs, /*(vaginal_bleeding
lower_abdomen_pain/severe_headache/very_pale/fever/reduced_or_no_feotal_movements/blurred_vision/
swelling/breathlessness/woman_danger_sign_fever/woman_danger_sign_severe_headache/
woman_danger_sign_vaginal_bleeding/woman_danger_sign_foul_vaginal_discharge/
woman_danger_sign_convulsions/child_vomits_everything/child_has_convulsions/child_cannot_drink_breastfeed/
child_unconscious/child_has_low_temp/child_has_yellow_eyes_or_palms/child_has_infected_umbilical_cord/
child_has_chest_in_drawing/child_vomiting_everything/child_has_difficulty_feeding/child_has_body_stiffness/
child_has_fever/child_has_yellow_skin) */
    doc #>> '{fields,group_danger,action}'::text[]                                    AS action, --(completed/to_follow_up/other)

    --- reporting hierarchy
    doc #>> '{contact,_id}'                         AS chw_id,                   
    doc #>> '{contact,parent,_id}'                  AS chw_area_id,  
    doc #>> '{contact,parent,parent,_id}'           AS facility_id,                                    
    doc #>> '{contact,parent,parent,parent,_id}'    AS parish_id,              
    doc #>> '{contact,parent,parent,parent,parent,_id}'           AS district,                 
    doc #>> '{contact,parent,parent,parent,parent,parent,_id}'    AS region    


FROM dwh.cht_data
WHERE (doc ->> 'form') = 'ha_danger_signs_follow_up'
  AND is_current
WITH DATA;

CREATE INDEX screening_reported_new_idx
    ON cht.mv_ha_danger_signs_follow_up_new USING btree (reported);
