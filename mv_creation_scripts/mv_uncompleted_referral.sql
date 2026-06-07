-- cht.mv_uncompleted_referral source
DROP MATERIALIZED VIEW cht.mv_uncompleted_referral;
CREATE MATERIALIZED VIEW cht.mv_uncompleted_referral
TABLESPACE ts_report
AS SELECT doc ->> '_id'::text AS doc_id,
    doc ->> '_rev'::text AS rev,
    to_timestamp((NULLIF(doc ->> 'reported_date'::text, ''::text)::bigint / 1000)::double precision) AS reported,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY-MM-DD'))::date AS date,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY'))::INT AS year,
    to_char(to_timestamp((((doc ->>'reported_date'::text)::bigint) / 1000)::double precision), 'MM'::text)::integer AS month,
    TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'FMMonth') AS monthname,
    ((doc -> 'fields'::text) -> 'meta'::text) ->> 'instanceID'::text AS instanceid,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) ->> 'deprecatedID'::text AS deprecatedid,
    ((((doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) -> 'location'::text) ->> 'lat'::text AS location_lat,
    ((((doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) -> 'location'::text) ->> 'long'::text AS location_long,
    ((((doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) -> 'location'::text) ->> 'error'::text AS location_error,
    ((((doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) -> 'location'::text) ->> 'message'::text AS location_message,
    (doc -> 'geolocation'::text) ->> 'code'::text AS geolocation_code,
    (doc -> 'geolocation'::text) ->> 'message'::text AS geolocation_message,
    (NULLIF((doc -> 'geolocation'::text) ->> 'latitude'::text, ''::text))::double precision AS geolocation_latitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'longitude'::text, ''::text))::double precision AS geolocation_longitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'accuracy'::text, ''::text))::double precision AS geolocation_accuracy,
    (NULLIF((doc -> 'geolocation'::text) ->> 'altitude'::text, ''::text))::double precision AS geolocation_altitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'altitudeAccuracy'::text, ''::text))::double precision AS geolocation_altitude_accuracy,
    (NULLIF((doc -> 'geolocation'::text) ->> 'speed'::text, ''::text))::double precision AS geolocation_speed,
    (NULLIF((doc -> 'geolocation'::text) ->> 'heading'::text, ''::text))::double precision AS geolocation_heading,
    doc ->> 'from'::text AS "from",
    doc #>> '{fields,inputs,source}'::text[] AS source,
    doc #>> '{fields,inputs,source_id}'::text[] AS source_id,
    doc #>> '{fields,inputs,t_tb_result}'::text[] AS t_tb_result,
    doc #>> '{fields,inputs,t_place_name}'::text[] AS t_place_name,
    doc #>> '{fields,inputs,t_patient_name}'::text[] AS t_patient_name,
    doc #>> '{fields,inputs,user,contact_id}'::text[] AS user_contact_id,
    doc #>> '{fields,inputs,user,facility_id}'::text[] AS user_facility_id,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    doc #>> '{fields,inputs,contact,date_of_birth}'::text[] AS inputs_contact_date_of_birth,
    doc #>> '{fields,inputs,contact,sex}'::text[] AS inputs_contact_sex,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,patient_name}'::text[] AS patient_name,
    doc #>> '{fields,tb_result}'::text[] AS tb_result,
    doc #>> '{fields,place_name}'::text[] AS place_name,
    doc #>> '{fields,needs_signoff}'::text[] AS needs_signoff,
    doc #>> '{fields,referral_notification,generated_note_name_25}'::text[] AS generated_note_name_25,
    doc #>> '{fields,referral_notification,referred_to_health_facility}'::text[] AS referred_to_health_facility,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
FROM dwh.cht_data d LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id
  WHERE (doc ->> 'form'::text) = 'tb_uncompleted_referral'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX uncompleted_referral_reported_idx ON cht.mv_uncompleted_referral USING btree (reported);
CREATE INDEX uncompleted_referral_date_idx ON cht.mv_uncompleted_referral USING btree (date);
CREATE INDEX uncompleted_referral_monthname_idx ON cht.mv_uncompleted_referral USING btree (monthname);
CREATE INDEX mv_uncompleted_referral_year_month_district ON cht.mv_uncompleted_referral USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX uncompleted_referral_district_idx ON cht.mv_uncompleted_referral USING btree (district);
CREATE INDEX uncompleted_referral_region_idx ON cht.mv_uncompleted_referral USING btree (region);
CREATE INDEX uncompleted_referral_chw_id_idx ON cht.mv_uncompleted_referral USING btree (chw_id);
CREATE INDEX uncompleted_referral_facility_idx ON cht.mv_uncompleted_referral USING btree (facility);
CREATE INDEX uncompleted_referral_dhis2_facility_id_idx ON cht.mv_uncompleted_referral USING btree (dhis2_facility_id);
CREATE INDEX uncompleted_referral_village_idx ON cht.mv_uncompleted_referral USING btree (village);