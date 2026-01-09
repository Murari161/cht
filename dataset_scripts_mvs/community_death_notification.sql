CREATE MATERIALIZED VIEW cht.mv_community_death_notification
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
    doc #>> '{fields,inputs,user,facility_id}'::text[] AS inputs_user_facility_id,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    doc #>> '{fields,inputs,contact,date_of_birth}'::text[] AS inputs_contact_date_of_birth,
    doc #>> '{fields,reporter_info,head_household_name}'::text[] AS head_household_name,
    doc #>> '{fields,reporter_info,head_household_contact}'::text[] AS head_household_contact,
    doc #>> '{fields,reporter_info,death_category}'::text[] AS death_category,
    doc #>> '{fields,mothers_details,mother_name}'::text[] AS mother_name,
    doc #>> '{fields,mothers_details,mother_age}'::text[] AS mother_age,
    doc #>> '{fields,mothers_details,mother_village}'::text[] AS mother_village,
    doc #>> '{fields,mothers_details,mother_date_of_death}'::text[] AS mother_date_of_death,
    doc #>> '{fields,mothers_details,mother_time_of_death}'::text[] AS mother_time_of_death,
    doc #>> '{fields,mothers_details,mother_place_of_death}'::text[] AS mother_place_of_death,
    doc #>> '{fields,mothers_details,mother_death_timing}'::text[] AS mother_death_timing,
    doc #>> '{fields,mothers_details,mother_days_after_delivery}'::text[] AS mother_days_after_delivery,
    doc #>> '{fields,mothers_details,mother_cause_of_death}'::text[] AS mother_cause_of_death,
    doc #>> '{fields,mothers_details,mother_death_registered}'::text[] AS mother_death_registered,
    doc #>> '{fields,baby_details,baby_mother_nok_name}'::text[] AS baby_mother_nok_name,
    doc #>> '{fields,baby_details,baby_sex}'::text[] AS baby_sex,
    doc #>> '{fields,baby_details,baby_birth_date}'::text[] AS baby_birth_date,
    doc #>> '{fields,baby_details,baby_birth_time}'::text[] AS baby_birth_time,
    doc #>> '{fields,baby_details,baby_death_date}'::text[] AS baby_death_date,
    doc #>> '{fields,baby_details,baby_death_time}'::text[] AS baby_death_time,
    doc #>> '{fields,baby_details,baby_place_of_birth}'::text[] AS baby_place_of_birth,
    doc #>> '{fields,baby_details,baby_birth_attendant}'::text[] AS baby_birth_attendant,
    doc #>> '{fields,baby_details,baby_place_of_death}'::text[] AS baby_place_of_death,
    doc #>> '{fields,baby_details,baby_pregnancy_age_months}'::text[] AS baby_pregnancy_age_months,
    doc #>> '{fields,baby_details,baby_multiple_pregnancy}'::text[] AS baby_multiple_pregnancy,
    doc #>> '{fields,baby_details,baby_multiple_howmany}'::text[] AS baby_multiple_howmany,
    doc #>> '{fields,baby_details,other_babies_alive}'::text[] AS other_babies_alive,
    doc #>> '{fields,baby_details,baby_death_registered}'::text[] AS baby_death_registered,
    doc #>> '{fields,finder_info,finder_name}'::text[] AS finder_name,
    doc #>> '{fields,finder_info,finder_address}'::text[] AS finder_address,
    doc #>> '{fields,finder_info,finder_circumstances}'::text[] AS finder_circumstances,

    -- Last column for tracking refresh
    CURRENT_TIMESTAMP AS last_refresh_date

FROM dwh.cht_data couchdb
WHERE (doc ->> 'form'::text) = 'community_death_notification'::text
  AND is_current
WITH DATA;

-- Indexes
CREATE INDEX mv_community_death_notification_eported
    ON cht.mv_community_death_notification USING btree (reported);

CREATE INDEX mv_community_death_notification_chw_is
    ON cht.mv_community_death_notification USING btree (chw_id);