CREATE MATERIALIZED VIEW cht.mv_cebs_signal_report_chew
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
        doc -> 'contact' -> 'parent'->'parent' ->> '_id'                              AS chw_area_id,
        doc -> 'contact' -> 'parent' ->'parent' ->'parent'->> '_id'                              AS parish_id,
        doc -> 'contact' -> 'parent' ->'parent' ->'parent'->'parent'->> '_id'                              AS district,
        doc -> 'contact' -> 'parent' ->'parent' ->'parent'->'parent'->'parent'->> '_id'                              AS region,
        doc -> 'fields' -> 'inputs' ->> 'source'                             AS source,
        doc -> 'fields' -> 'inputs' ->> 'source_id'                 AS source_id,
        doc -> 'fields' -> 'inputs' -> 'user' ->> 'contact_id'      AS user_contact_id,
        doc -> 'fields' -> 'inputs' -> 'user' ->> 'facility_id'     AS user_facility_id,
        doc -> 'fields' -> 'inputs' -> 'contact' ->> '_id'          AS contact_id,
        doc -> 'fields' -> 'inputs' -> 'contact' ->> 'name'         AS contact_name,
        doc -> 'fields' -> 'inputs' -> 'contact' ->> 'village'      AS contact_village,
        doc -> 'fields' -> 'inputs' -> 'contact' -> 'contact' ->> '_id'           AS cont_contact_id,
        doc -> 'fields' -> 'inputs' -> 'contact' -> 'contact' ->> 'name'          AS cont_contact_name,
        doc -> 'fields' -> 'inputs' -> 'contact' -> 'contact' ->> 'date_of_birth' AS cont_contact_date_of_birth,
        doc -> 'fields' -> 'inputs' -> 'contact' -> 'contact' ->> 'phone'         AS cont_contact_phone,
        doc -> 'fields' ->> 'needs_signoff'                          AS needs_signoff,
        doc -> 'fields' -> 'inputs' ->> 'chw_name'      AS chw_name,
        doc -> 'fields' -> 'inputs' ->> 'chw_phone'     AS chw_phone,
        doc -> 'fields' -> 'inputs' ->> 'place_id'      AS place_id,
        doc -> 'fields' -> 'inputs' ->> 'place_name'    AS place_name,
        doc -> 'fields' -> 'inputs' ->> 'chw_village'   AS chw_village,
        doc -> 'fields'->'unusual_health_event'->>'experienced_unusual_health_event'  AS experienced_unusual_health_event,
        doc -> 'fields'-> 'signal_type'->>'signal_reported'  AS signal_reported,
        doc -> 'fields'-> 'signal_type'->>'additional_information'  AS additional_information,
        doc -> 'fields'-> 'signal_type'->>'person_under_vht_area'  AS person_under_vht_area,
        doc -> 'fields'-> 'signal_type'->>'brief_description'  AS brief_description,
        doc -> 'fields' -> 'group_summary' ->> 's_note_signal_report_summary_page' AS s_note_signal_report_summary_page,
        doc -> 'fields' -> 'group_summary' ->> 's_note_be_sure_to_submit' AS s_note_be_sure_to_submit,
        doc -> 'fields' -> 'group_summary' ->> 's_note_signal_details' AS s_note_signal_details,
        doc -> 'fields' -> 'group_summary' ->> 'no_signal_reported' AS no_signal_reported,
        doc -> 'fields' -> 'group_summary' ->> 's_note_fever_and_bleeding' AS s_note_fever_and_bleeding,
        doc -> 'fields' -> 'group_summary' ->> 's_note_unexplained_rash' AS s_note_unexplained_rash,
        doc -> 'fields' -> 'group_summary' ->> 's_note_sudden_or_unexplained_death' AS s_note_sudden_or_unexplained_death,
        doc -> 'fields' -> 'group_summary' ->> 's_note_bitten_by_dog_or_animal' AS s_note_bitten_by_dog_or_animal,
        doc -> 'fields' -> 'group_summary' ->> 's_note_abnormal_change_in_drinking_water'    AS s_note_abnormal_change_in_drinking_water,
        doc -> 'fields' -> 'group_summary' ->> 's_note_public_health_threat'   AS s_note_public_health_threat,
        doc -> 'fields' -> 'group_summary' ->> 's_note_key_instruction'  AS s_note_key_instruction,
        doc -> 'fields' -> 'group_summary' ->> 'switch_on_data'  AS switch_on_data,

        CURRENT_TIMESTAMP as last_refresh_date
   
FROM dwh.cht_data 
WHERE (doc ->> 'form'::text) = 'cebs_signal_report_chew'::text
  AND is_current
WITH DATA;
CREATE INDEX mv_cebs_signal_report_chewchw_is ON cht.mv_cebs_signal_report_chew USING btree (chw_id);
CREATE INDEX mv_cebs_signal_report_chew_eported ON cht.mv_cebs_signal_report_chew USING btree (reported);
