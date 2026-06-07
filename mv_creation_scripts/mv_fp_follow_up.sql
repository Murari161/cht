-- cht.mv_fp_follow_up source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_fp_follow_up;
CREATE MATERIALIZED VIEW cht.mv_fp_follow_up
TABLESPACE ts_report
AS SELECT doc ->> '_id'::text AS uuid,
    doc ->> 'form'::text AS form,
    doc ->> 'from'::text AS submitter,
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
    doc #>> '{fields,inputs,source}'::text[] AS inputs_source,
    doc #>> '{fields,inputs,source_id}'::text[] AS inputs_source_id,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    doc #>> '{fields,inputs,contact,patient_id}'::text[] AS inputs_contact_patient_id,
    doc #>> '{fields,inputs,contact,date_of_birth}'::text[] AS inputs_contact_date_of_birth,
    doc #>> '{fields,inputs,contact,sex}'::text[] AS inputs_contact_sex,
    doc #>> '{fields,inputs,contact,parent,parent,_id}'::text[] AS inputs_parent_parent_id,
    doc #>> '{fields,inputs,contact,parent,parent,supervisor}'::text[] AS inputs_parent_supervisor,
    doc #>> '{fields,inputs,contact,parent,parent,contact,name}'::text[] AS inputs_parent_contact_name,
    doc #>> '{fields,inputs,contact,parent,parent,contact,phone}'::text[] AS inputs_parent_contact_phone,
    doc #>> '{fields,inputs,contact,parent,parent,contact,_id}'::text[] AS inputs_parent_contact_id,
    doc #>> '{fields,inputs,contact,parent,parent,parent,_id}'::text[] AS inputs_parent_parent_parent_id,
    doc #>> '{fields,source}'::text[] AS source,
    doc #>> '{fields,source_id}'::text[] AS source_id,
    doc #>> '{fields,patient_uuid}'::text[] AS patient_uuid,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,patient_name}'::text[] AS patient_name,
    doc #>> '{fields,patient_date_of_birth}'::text[] AS patient_date_of_birth,
    doc #>> '{fields,patient_age_in_years}'::text[] AS patient_age_in_years,
    doc #>> '{fields,age}'::text[] AS age,
    doc #>> '{fields,date_of_birth}'::text[] AS date_of_birth,
    doc #>> '{fields,chw_name}'::text[] AS chw_name,
    doc #>> '{fields,chw_phone}'::text[] AS chw_phone,
    doc #>> '{fields,current_fp_method_label}'::text[] AS current_fp_method_label,
    doc #>> '{fields,current_fp_method}'::text[] AS current_fp_method,
    doc #>> '{fields,fp_next_appt_date}'::text[] AS fp_next_appt_date,
    doc #>> '{fields,wants_or_is_pregnant}'::text[] AS wants_or_is_pregnant,
    doc #>> '{fields,needs_method_change}'::text[] AS needs_method_change,
    doc #>> '{fields,has_been_referred}'::text[] AS has_been_referred,
    doc #>> '{fields,chw_area_id}'::text[] AS chw_area_id,
    doc #>> '{fields,branch_id}'::text[] AS branch_id,
    (doc #>> '{fields,coc_given}'::text[])::integer AS coc_given,
    (doc #>> '{fields,condoms_given}'::text[])::integer AS condoms_given,
    (doc #>> '{fields,pop_given}'::text[])::integer AS pop_given,
    (doc #>> '{fields,dmpa_given}'::text[])::integer AS dmpa_given,
    (doc #>> '{fields,contraceptives_given}'::text[])::integer AS contraceptives_given,
    doc #>> '{fields,fp_follow_up,on_fp}'::text[] AS on_fp,
    doc #>> '{fields,fp_follow_up,not_on_fp_reason}'::text[] AS not_on_fp_reason,
    doc #>> '{fields,fp_follow_up,not_on_fp_reason_other}'::text[] AS not_on_fp_reason_other,
    doc #>> '{fields,fp_follow_up,n_thank_patient}'::text[] AS n_thank_patient,
    doc #>> '{fields,fp_follow_up,n_refer_change_fp}'::text[] AS n_refer_change_fp,
    doc #>> '{fields,fp_follow_up,referred_patient_not_on_fp}'::text[] AS referred_patient_not_on_fp,
    doc #>> '{fields,fp_follow_up,n_enroll_pregnancy}'::text[] AS n_enroll_pregnancy,
    doc #>> '{fields,fp_follow_up,n_counsel_woman}'::text[] AS n_counsel_woman,
    doc #>> '{fields,fp_follow_up,n_fp_method}'::text[] AS n_fp_method,
    doc #>> '{fields,fp_follow_up,continue_current_fp_method}'::text[] AS continue_current_fp_method,
    doc #>> '{fields,fp_follow_up,n_refer_patient_change_fp}'::text[] AS n_refer_patient_change_fp,
    doc #>> '{fields,fp_follow_up,can_supply_fp_commodities}'::text[] AS can_supply_fp_commodities,
    doc #>> '{fields,fp_follow_up,supply_item_units}'::text[] AS supply_item_units,
    doc #>> '{fields,fp_follow_up,supply_limit}'::text[] AS supply_limit,
    (doc #>> '{fields,fp_follow_up,commodities_supplied_qty}'::text[])::integer AS commodities_supplied_qty,
    doc #>> '{fields,fp_follow_up,referred_patient_change_fp}'::text[] AS referred_patient_change_fp,
    doc #>> '{fields,fp_follow_up,next_appt_date}'::text[] AS next_appt_date,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date 
   FROM dwh.cht_data couchdb
LEFT JOIN cht.mv_chw_hierarchy h ON (couchdb.doc #>> '{contact,_id}') = h.chw_id
  WHERE (doc ->> 'form'::text) = 'fp_follow_up'::text AND is_current
WITH NO DATA;

-- Indexes for cht.mv_fp_follow_up
-- Adjust "month" if a table uses a different period column name.
CREATE INDEX idx_mv_fp_follow_up_chw_year_month
  ON cht.mv_fp_follow_up (chw_id, year, month) tablespace ts_indexes;
CREATE INDEX idx_mv_fp_follow_up_chw_date
  ON cht.mv_fp_follow_up (chw_id, date)tablespace ts_indexes;
CREATE INDEX idx_mv_fp_follow_up_chw_reported
  ON cht.mv_fp_follow_up (chw_id, reported) tablespace ts_indexes;
  --WHERE reported IS NOT NULL;
CREATE INDEX idx_mv_fp_follow_up_chw_current_fp_method
  ON cht.mv_fp_follow_up (chw_id, current_fp_method) tablespace ts_indexes;
CREATE INDEX idx_mv_fp_follow_up_year_month_district
  ON cht.mv_fp_follow_up USING btree (year, month, district) TABLESPACE ts_indexes;