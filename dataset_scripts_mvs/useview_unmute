CREATE MATERIALIZED VIEW cht.mv_unmute
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
    doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,contact_name}'::text[] AS contact_name,
    doc #>> '{fields,unmute_reason}'::text[] AS unmute_reason,
    doc #>> '{fields,unmute_reason_other}'::text[] AS unmute_reason_other,
    doc #>> '{fields,person_unmuting,g_unmute_reason}'::text[] AS g_unmute_reason,
    doc #>> '{fields,person_unmuting,g_unmute_reason_other}'::text[] AS g_unmute_reason_other,
    doc #>> '{fields,unmuting_summary,r_summary}'::text[] AS r_summary,
    doc #>> '{fields,unmuting_summary,r_contact_info}'::text[] AS r_contact_info,
    doc #>> '{fields,unmuting_summary,r_unmute_reasons_label}'::text[] AS r_unmute_reasons_label,
    doc #>> '{fields,unmuting_summary,r_unmute_reason0}'::text[] AS r_unmute_reason0,
    doc #>> '{fields,unmuting_summary,r_unmute_reason1}'::text[] AS r_unmute_reason1,
    doc #>> '{fields,unmuting_summary,r_unmute_reasons_other}'::text[] AS r_unmute_reasons_other,
    doc #>> '{fields,unmuting_summary,r_followup}'::text[] AS r_followup,
    doc #>> '{fields,unmuting_summary,r_followup_instructions}'::text[] AS r_followup_instructions,

    -- Last column for tracking refresh
    CURRENT_TIMESTAMP AS last_refresh_date

FROM dwh.cht_data couchdb
WHERE (doc ->> 'form'::text) = 'unmute'::text
  AND is_current
WITH DATA;

-- Indexes
CREATE INDEX mv_unmute_reported
    ON cht.mv_unmute USING btree (reported);

CREATE INDEX mv_unmute_chw_id
    ON cht.mv_unmute USING btree (chw_id);