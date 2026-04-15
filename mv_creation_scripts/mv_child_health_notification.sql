-- cht.mv_child_health_notification source
DROP MATERIALIZED VIEW IF EXISTS cht.mv_child_health_notification;
CREATE MATERIALIZED VIEW cht.mv_child_health_notification
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
    doc ->> 'form'::text AS form,
    doc ->> 'from'::text AS "from",
    doc #>> '{fields,dob}'::text[] AS dob,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS contact_id,
    doc #>> '{fields,inputs,contact,date_of_birth}'::text[] AS contact_date_of_birth,
    doc #>> '{fields,inputs,contact,name}'::text[] AS contact_name,
    doc #>> '{fields,inputs,contact,sex}'::text[] AS contact_sex,
    doc #>> '{fields,inputs,source}'::text[] AS source,
    doc #>> '{fields,inputs,source_id}'::text[] AS source_id,
    doc #>> '{fields,inputs,t_patient_condition}'::text[] AS t_patient_condition,
    doc #>> '{fields,inputs,t_patient_date_of_birth}'::text[] AS t_patient_date_of_birth,
    doc #>> '{fields,inputs,t_patient_gender}'::text[] AS t_patient_gender,
    doc #>> '{fields,inputs,t_patient_id}'::text[] AS t_patient_id,
    doc #>> '{fields,inputs,t_patient_name}'::text[] AS t_patient_name,
    doc #>> '{fields,inputs,t_place_name}'::text[] AS t_place_name,
    doc #>> '{fields,inputs,t_vht_name}'::text[] AS t_vht_name,
    doc #>> '{fields,inputs,t_vht_phone}'::text[] AS t_vht_phone,
    doc #>> '{fields,inputs,user,contact_id}'::text[] AS user_contact_id,
    doc #>> '{fields,inputs,user,facility_id}'::text[] AS user_facility_id,
    doc #>> '{fields,needs_signoff}'::text[] AS needs_signoff,
    doc #>> '{fields,patient_age_display}'::text[] AS patient_age_display,
    doc #>> '{fields,patient_age_in_days}'::text[] AS patient_age_in_days,
    doc #>> '{fields,patient_age_in_months}'::text[] AS patient_age_in_months,
    doc #>> '{fields,patient_age_in_years}'::text[] AS patient_age_in_years,
    doc #>> '{fields,patient_gender}'::text[] AS patient_gender,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,patient_name}'::text[] AS patient_name,
    doc #>> '{fields,referral_details_note}'::text[] AS referral_details_note,
    doc #>> '{fields,referral_details,health_note}'::text[] AS health_note,
    doc #>> '{fields,danger_sign_check,follow_up_child}'::text[] AS follow_up_child,
    doc #>> '{fields,danger_sign_check,client_condition}'::text[] AS client_condition,
    doc #>> '{fields,referral,taken_to_facility}'::text[] AS taken_to_facility,
    doc #>> '{fields,referral,refer_to_facility}'::text[] AS refer_to_facility,
    doc #>> '{fields,referral,confirm_refer_to_facility}'::text[] AS confirm_refer_to_facility,
    doc #>> '{fields,health_education,select_health_condition}'::text[] AS select_health_condition,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility_name,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date 
   FROM dwh.cht_data couchdb
LEFT JOIN cht.mv_chw_hierarchy h ON (couchdb.doc #>> '{contact,_id}') = h.chw_id
  WHERE (doc ->> 'form'::text) = 'child_health_notification'::text AND is_current
WITH DATA;

-- View indexes:
CREATE INDEX mv_child_health_notification_reported ON cht.mv_child_health_notification USING btree (reported) tablespace ts_indexes;
CREATE INDEX mv_child_health_notification_date ON cht.mv_child_health_notification USING btree (date) tablespace ts_indexes;
CREATE INDEX mv_child_health_notification_year ON cht.mv_child_health_notification USING btree (year) tablespace ts_indexes;
CREATE INDEX mv_child_health_notification_month ON cht.mv_child_health_notification USING btree (month) tablespace ts_indexes;
CREATE INDEX mv_child_health_notification_chw_id ON cht.mv_child_health_notification USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX mv_child_health_notification_district ON cht.mv_child_health_notification USING btree (district) tablespace ts_indexes;
CREATE INDEX mv_child_health_notification_region ON cht.mv_child_health_notification USING btree (region) tablespace ts_indexes;
CREATE INDEX mv_child_health_notification_facility_name ON cht.mv_child_health_notification USING btree (facility_name) tablespace ts_indexes;
CREATE INDEX mv_child_health_notification_dhis2_facility_id ON cht.mv_child_health_notification USING btree (dhis2_facility_id) tablespace ts_indexes;  