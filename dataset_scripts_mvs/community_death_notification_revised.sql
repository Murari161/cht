CREATE MATERIALIZED VIEW cht.mv_community_death_notification_revised
TABLESPACE ts_report
AS 
SELECT 
        doc ->> '_id'::text AS uuid,
        doc ->> 'form'::text AS form,
        doc ->> 'from'::text AS submitter,
        to_timestamp((NULLIF(doc ->> 'reported_date'::text, ''::text)::bigint / 1000)::double precision) AS reported,
        to_char(to_timestamp((((doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'YYYY-MM-DD'::text)::date AS date,
        to_char(to_timestamp((((doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'YYYY'::text)::integer AS year,
        to_char(to_timestamp((((doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'FMMonth'::text) AS month,
        ((doc -> 'fields'::text) -> 'meta'::text) ->> 'instanceID'::text AS instanceid,
        (((doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) ->> 'deprecatedID'::text AS deprecatedid,
        ((((doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) -> 'location'::text) ->> 'lat'::text AS location_lat,
        ((((doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) -> 'location'::text) ->> 'long'::text AS location_long,
        ((((doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) -> 'location'::text) ->> 'error'::text AS location_error,
        ((((doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) -> 'location'::text) ->> 'message'::text AS location_message,
        (doc -> 'geolocation'::text) ->> 'code'::text AS geolocation_code,
        (doc -> 'geolocation'::text) ->> 'message'::text AS geolocation_message,
        doc -> 'contact' ->> '_id'                                           AS chw_id,
        doc -> 'contact' -> 'parent' ->> '_id'                              AS contact_chw_area_id,
        doc -> 'contact' -> 'parent' -> 'parent' ->> '_id'                  AS facility_id,
        doc -> 'contact' -> 'parent' -> 'parent' -> 'parent' ->> '_id'      AS district,
        doc -> 'contact' -> 'parent' -> 'parent' -> 'parent' -> 'parent' ->> '_id' AS region,

        doc -> 'fields' -> 'inputs' ->> 'source'                             AS source,
        doc -> 'fields' -> 'inputs' ->> 'source_id'                          AS source_id,
        doc -> 'fields' -> 'inputs' -> 'contact' ->> '_id'             AS contact_id,
        doc -> 'fields' -> 'inputs' -> 'contact' ->> 'name'            AS contact_name,
        doc -> 'fields' -> 'inputs' -> 'contact' ->> 'date_of_birth'   AS contact_date_of_birth,
        doc -> 'fields' -> 'reporter_info' ->> 'head_household_name'        AS head_household_name,
        doc -> 'fields' -> 'reporter_info' ->> 'head_household_contact'     AS head_household_contact,

        doc -> 'fields' -> 'reporter_info' ->> 'mother_name'                AS mother_name,
        doc -> 'fields' -> 'reporter_info' ->> 'mother_dob'                 AS mother_dob,
        doc -> 'fields' -> 'reporter_info' ->> 'mother_age'                 AS mother_age,
        doc -> 'fields' -> 'reporter_info' ->> 'mother_pregnanies'          AS mother_pregnanies,
        doc -> 'fields' -> 'reporter_info' ->> 'mother_village'             AS mother_village,

        doc -> 'fields' -> 'reporter_info' ->> 'Woman_parish'               AS woman_parish,
        doc -> 'fields' -> 'reporter_info' ->> 'Woman_subcounty'            AS woman_subcounty,
        doc -> 'fields' -> 'reporter_info' ->> 'Woman_district'             AS woman_district,
        doc -> 'fields' -> 'reporter_info' ->> 'Woman_Usual_Res'             AS woman_usual_residence,

        doc -> 'fields' -> 'reporter_info' ->> 'Woman_Temp_village'         AS woman_temporary_village,
        doc -> 'fields' -> 'reporter_info' ->> 'Woman_Temp_Parish'          AS woman_temporary_parish,
        doc -> 'fields' -> 'reporter_info' ->> 'Woman_Temp_subcounty'       AS woman_temporary_subcounty,
        doc -> 'fields' -> 'reporter_info' ->> 'Woman_Temp_District'        AS woman_temporary_district,

        doc -> 'fields' -> 'reporter_info' ->> 'Informer_name'              AS informer_name,
        doc -> 'fields' -> 'reporter_info' ->> 'Informer_contact'           AS informer_contact,
        doc -> 'fields' -> 'death_type' ->> 'death_category'   AS death_category,
       doc -> 'fields' -> 'mothers_details' ->> 'mother_death_timing'        AS mother_death_timing,
        doc -> 'fields' -> 'mothers_details' ->> 'Woman_Nationality'         AS woman_nationality,
        doc -> 'fields' -> 'mothers_details' ->> 'mother_date_of_death'      AS mother_date_of_death,
        doc -> 'fields' -> 'mothers_details' ->> 'mother_time_of_death'      AS mother_time_of_death,
        doc -> 'fields' -> 'mothers_details' ->> 'MD_Weeks'                  AS maternal_death_weeks,
        doc -> 'fields' -> 'mothers_details' ->> 'mother_days_after_delivery' AS mother_days_after_delivery,
        doc -> 'fields' -> 'mothers_details' ->> 'mother_place_of_death'     AS mother_place_of_death,
        doc -> 'fields' -> 'mothers_details' ->> 'MD_Place_Spec'             AS maternal_death_place,
        doc -> 'fields' -> 'mothers_details' ->> 'mother_cause_of_death'     AS mother_cause_of_death,
        doc -> 'fields' -> 'mothers_details' ->> 'MD_Carer'                  AS carer_for_mother_before_death,
        doc -> 'fields' -> 'mothers_details' ->> 'MD_Carer_Rel'              AS carer_relationship_to_mother,
        doc -> 'fields' -> 'mothers_details' ->> 'MD_Carer_Contact'          AS carer_contact,

        doc -> 'fields' -> 'baby_details' ->> 'baby_place_of_birth'          AS baby_place_of_birth,
        doc -> 'fields' -> 'baby_details' ->> 'baby_sex'                    AS baby_sex,
        doc -> 'fields' -> 'baby_details' ->> 'baby_birth_date'             AS baby_birth_date,
        doc -> 'fields' -> 'baby_details' ->> 'baby_birth_time'             AS baby_birth_time,
        doc -> 'fields' -> 'baby_details' ->> 'baby_death_date'             AS baby_death_date,
        doc -> 'fields' -> 'baby_details' ->> 'baby_death_time'             AS baby_death_time,
        doc -> 'fields' -> 'baby_details' ->> 'NND_24'                      AS neonatal_death_24,
        doc -> 'fields' -> 'baby_details' ->> 'NND_age_H'                   AS neonatal_age_hours,
        doc -> 'fields' -> 'baby_details' ->> 'NND_age_days'                AS neonatal_death_age_days,
        doc -> 'fields' -> 'baby_details' ->> 'baby_place_of_death'         AS baby_place_of_death,
        doc -> 'fields' -> 'baby_details' ->> 'NND_place_Spec'              AS neonatal_death_place,
        doc -> 'fields' -> 'baby_details' ->> 'NND_Cause'                   AS neonatal_death_cause,
        doc -> 'fields' -> 'baby_details' ->> 'NND_Mother'                  AS neonate_with_mother,
        doc -> 'fields' -> 'baby_details' ->> 'NND_carer'                   AS neonate_with_carer,
        doc -> 'fields' -> 'baby_details' ->> 'NND_carer_contact'           AS neonate_with_carer_contact,
        doc -> 'fields' -> 'baby_details' ->> 'baby_multiple_pregnancy'     AS baby_multiple_pregnancy,
        doc -> 'fields' -> 'baby_details' ->> 'baby_multiple_howmany'       AS baby_multiple_howmany,
        doc -> 'fields' -> 'baby_details' ->> 'NND_other_death'             AS neonatal_other_death,
        doc -> 'fields' -> 'baby_details' ->> 'other_babies_alive'          AS other_babies_alive,

        doc -> 'fields' -> 'baby_details_stillbirth' ->> 'SB_date'        AS still_birth_date,
        doc -> 'fields' -> 'baby_details_stillbirth' ->> 'SB_time'        AS still_birth_time,
        doc -> 'fields' -> 'baby_details_stillbirth' ->> 'SB_sex'         AS still_birth_sex,
        doc -> 'fields' -> 'baby_details_stillbirth' ->> 'SB_place'       AS still_birth_place,
        doc -> 'fields' -> 'baby_details_stillbirth' ->> 'SB_place_spec'  AS still_birth_place_spec,
        doc -> 'fields' -> 'baby_details_stillbirth' ->> 'Comment'        AS comment,

        CURRENT_TIMESTAMP as last_refresh_date

FROM dwh.cht_data 
WHERE (doc ->> 'form'::text) = 'community_death_notification'::text
  AND is_current
WITH DATA;

CREATE INDEX mv_community_death_notification_chw_is_revised ON cht.mv_community_death_notification_revised USING btree (chw_id);
CREATE INDEX mv_community_death_notification_eported_revised ON cht.mv_community_death_notification_revised USING btree (reported);