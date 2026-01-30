CREATE MATERIALIZED VIEW cht.mv_afp_notification
TABLESPACE ts_report
AS
SELECT
        doc ->> '_id'::text AS uuid,
        doc ->> 'form'::text AS form,

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
        doc -> 'contact' ->> '_id'                                           AS chw_id,
        doc -> 'contact' -> 'parent' ->> '_id'                              AS facility_id,
        doc -> 'contact' -> 'parent' -> 'parent' ->> '_id'                  AS district,
        doc -> 'contact' -> 'parent' -> 'parent' -> 'parent' ->> '_id'      AS region,
        doc -> 'fields' -> 'inputs' ->> 'source'                             AS source,
        doc -> 'fields' -> 'inputs' ->> 'source_id'                          AS source_id,
        doc -> 'fields' -> 'inputs' ->> 't_patient_condition'        AS t_patient_condition,
        doc -> 'fields' -> 'inputs' ->> 't_place_name'               AS t_place_name,
        doc -> 'fields' -> 'inputs' ->> 't_vht_name'                 AS t_vht_name,
        doc -> 'fields' -> 'inputs' ->> 't_vht_phone'                AS t_vht_phone,
        doc -> 'fields' -> 'inputs' ->> 't_patient_name'             AS t_patient_name,
        doc -> 'fields' -> 'inputs' ->> 't_patient_gender'           AS t_patient_gender,
        doc -> 'fields' -> 'inputs' ->> 't_patient_date_of_birth'   AS t_patient_date_of_birth,
        doc -> 'fields' -> 'inputs' ->> 't_patient_id'               AS t_patient_id,

        doc -> 'fields' -> 'inputs' -> 'user' ->> 'contact_id'       AS user_contact_id,
        doc -> 'fields' -> 'inputs' -> 'user' ->> 'facility_id'      AS user_facility_id,

        doc -> 'fields' -> 'inputs' -> 'contact' ->> '_id'           AS contact_id,
        doc -> 'fields' -> 'inputs' -> 'contact' ->> 'name'          AS contact_name,
        doc -> 'fields' -> 'inputs' -> 'contact' ->> 'date_of_birth' AS contact_date_of_birth,
        doc -> 'fields' -> 'inputs' -> 'contact' ->> 'sex'           AS contact_sex,
       doc -> 'fields' ->> 'dob'                              AS dob,
        doc -> 'fields' ->> 'patient_age_in_years'             AS patient_age_in_years,
        doc -> 'fields' ->> 'patient_age_in_months'            AS patient_age_in_months,
        doc -> 'fields' ->> 'patient_age_in_days'              AS patient_age_in_days,
        doc -> 'fields' ->> 'patient_age_display'              AS patient_age_display,
        doc -> 'fields' ->> 'patient_id'                       AS patient_id,
        doc -> 'fields' ->> 'patient_name'                     AS patient_name,
        doc -> 'fields' ->> 'patient_gender'                   AS patient_gender,
        doc -> 'fields' ->> 'vht_name'                          AS vht_name,
        doc -> 'fields' ->> 'vht_phone'                         AS vht_phone,
        doc -> 'fields' ->> 'needs_signoff'                     AS needs_signoff,

        doc -> 'fields' -> 'afp_confirmation' ->> 'n_confirmation_note'                  AS n_confirmation_note,
        doc -> 'fields' -> 'afp_confirmation' ->> 'n_follow_up'                           AS n_follow_up,
        doc -> 'fields' -> 'afp_confirmation' ->> 'has_sudden_weakness_in_legs_and_arms'   AS has_sudden_weakness_in_legs_and_arms,

        doc -> 'fields' -> 'group_patient_summary' ->> 's_note_patient_details'           AS s_note_patient_details,
        doc -> 'fields' -> 'group_patient_summary' ->> 's_note_patient_details_values'    AS s_note_patient_details_values,
        doc -> 'fields' -> 'group_patient_summary' ->> 's_findings'                       AS s_findings,
        doc -> 'fields' -> 'group_patient_summary' ->> 's_afp_present'                    AS s_afp_present,
        doc -> 'fields' -> 'group_patient_summary' ->> 's_afp_not_present'                AS s_afp_not_present,

        CURRENT_TIMESTAMP as last_refresh_date
   
FROM dwh.cht_data 
WHERE (doc ->> 'form'::text) = 'afp_notification'::text
  AND is_current
WITH DATA;
CREATE INDEX mv_afp_notification_chw_is ON cht.mv_afp_notification USING btree (chw_id);
CREATE INDEX mv_afp_notification_eported ON cht.mv_afp_notification USING btree (reported);
