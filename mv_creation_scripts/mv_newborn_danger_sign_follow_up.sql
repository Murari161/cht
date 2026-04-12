
WITH preprocessed AS (
    SELECT
        couchdb.*,
        -- Count how many times "parent" appears in the JSONB text
        ( length(doc::text) - length(replace(doc::text, '"parent"', '')) ) / length('"parent"') AS parent_count
    FROM dwh.cht_data couchdb
    WHERE (doc ->> 'form') = 'newborn_danger_sign_follow_up'
      AND is_current
)
SELECT
      doc ->> '_id'                                                AS uuid,
      doc ->> '_rev'                                               AS rev,
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
     
     doc #>> '{contact,_id}' AS chw_id,
    doc #>> '{contact,parent,_id}' AS contact_chw_area_id,

    CASE
        WHEN parent_count = 5 THEN doc #>> '{contact,parent,parent,_id}'
        ELSE NULL
    END AS contact_facility_id,

    CASE
        WHEN parent_count = 5 THEN doc #>> '{contact,parent,parent,parent,_id}'
        ELSE doc #>> '{contact,parent,parent,_id}'
    END AS parish_id,

    CASE
        WHEN parent_count = 5 THEN doc #>> '{contact,parent,parent,parent,parent,_id}'
        ELSE doc #>> '{contact,parent,parent,parent,_id}'
    END AS district_id,

    CASE
        WHEN parent_count = 5 THEN doc #>> '{contact,parent,parent,parent,parent,parent,_id}'
        ELSE doc #>> '{contact,parent,parent,parent,parent,_id}'
    END AS region_id,

    CASE
        WHEN parent_count = 5 THEN 'new'
        ELSE 'old'
    END AS hierarchy_type,
    doc #>> '{fields,inputs,source}'::text[]                     AS source,
    doc #>> '{fields,inputs,source,source_id}'::text[]          AS source_id,
    doc #>> '{fields,inputs,t_place_name}'::text[]       AS t_place_name,
    doc #>> '{fields,inputs,t_vht_name}'::text[]         AS t_vht_name,
    doc #>> '{fields,inputs,t_vht_phone}'::text[]        AS t_vht_phone,
    doc #>> '{fields,inputs,user,contact_id}'::text[]    AS user_contact_id,
    doc #>> '{fields,inputs,user,facility_id}'::text[]   AS user_facility_id,
    doc #>> '{fields,inputs,contact,_id}'::text[]        AS contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[]       AS contact_name,
    doc #>> '{fields,inputs,contact,date_of_birth}'::text[] AS contact_date_of_birth,
    doc #>> '{fields,inputs,contact,sex}'::text[]        AS contact_sex,
    doc #>> '{fields,patient_age_in_years}'::text[]        AS patient_age_in_years,
    doc #>> '{fields,patient_age_in_months}'::text[]       AS patient_age_in_months,
    doc #>> '{fields,patient_age_in_days}'::text[]         AS patient_age_in_days,
    doc #>> '{fields,patient_age_display}'::text[]         AS patient_age_display,
    doc #>> '{fields,patient_id}'::text[]                  AS patient_id,
    doc #>> '{fields,patient_name}'::text[]                AS patient_name,
    doc #>> '{fields,patient_gender}'::text[]              AS patient_gender,
    doc #>> '{fields,chw_name}'::text[]                    AS chw_name,
    doc #>> '{fields,chw_phone}'::text[]                   AS chw_phone,
    doc #>> '{fields,chw_village}'::text[]                 AS chw_village,
    doc #>> '{fields,needs_signoff}'::text[]               AS needs_signoff,
   
    doc #>> '{fields,group_danger_sign_follow_up,taken_to_health_facility}'::text[]           AS taken_to_health_facility,
    doc #>> '{fields,group_danger_sign_follow_up,still_experiencing_danger_signs}'::text[]   AS still_experiencing_danger_signs,
    doc #>> '{fields,group_danger_sign_follow_up,note_great_news}'::text[]                  AS note_great_news,
    doc #>> '{fields,group_danger_sign_follow_up,note_still_experiencing_danger_signs}'::text[] AS note_still_experiencing_danger_signs,
    doc #>> '{fields,group_danger_sign_follow_up,breathing_difficulty}'::text[]             AS breathing_difficulty,
    doc #>> '{fields,group_danger_sign_follow_up,not_breastfeeding_Well}'::text[]           AS not_breastfeeding_Well,
    doc #>> '{fields,group_danger_sign_follow_up,feels_hot_or_cold}'::text[]                AS feels_hot_or_cold,
    doc #>> '{fields,group_danger_sign_follow_up,less_active}'::text[]                       AS less_active,
    doc #>> '{fields,group_danger_sign_follow_up,yellow_body}'::text[]                       AS yellow_body,
    doc #>> '{fields,group_danger_sign_follow_up,has_danger_signs}'::text[]                  AS has_danger_signs,

    doc #>> '{fields,group_summary,s_note_danger_sign}'::text[]             AS s_note_danger_sign,
    doc #>> '{fields,group_summary,s_summary_submit}'::text[]              AS s_summary_submit,
    doc #>> '{fields,group_summary,s_note_person_details}'::text[]         AS s_note_person_details,
    doc #>> '{fields,group_summary,s_note_person_details_values}'::text[]  AS s_note_person_details_values,
    doc #>> '{fields,group_summary,s_note_referrals}'::text[]               AS s_note_referrals,
    doc #>> '{fields,group_summary,s_note_refer_for_review}'::text[]        AS s_note_refer_for_review,
    doc #>> '{fields,group_summary,s_note_danger_signs}'::text[]            AS s_note_danger_signs,
    doc #>> '{fields,group_summary,s_note_breathing_difficulty}'::text[]    AS s_note_breathing_difficulty,
    doc #>> '{fields,group_summary,s_note_not_breastfeeding_Well}'::text[]  AS s_note_not_breastfeeding_Well,
    doc #>> '{fields,group_summary,s_note_feels_hot_or_cold}'::text[]       AS s_note_feels_hot_or_cold,
    doc #>> '{fields,group_summary,s_note_less_active}'::text[]             AS s_note_less_active,
    doc #>> '{fields,group_summary,s_note_yellow_body}'::text[]             AS s_note_yellow_body,
    CURRENT_TIMESTAMP                                             AS last_refresh_date
                

FROM preprocessed AS couchdb
WHERE (doc ->> 'form') = 'newborn_danger_sign_follow_up'
  AND is_current