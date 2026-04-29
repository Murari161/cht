-- cht.mv_pnc_danger_sign source
DROP MATERIALIZED VIEW cht.mv_pnc_danger_sign;
CREATE MATERIALIZED VIEW cht.mv_pnc_danger_sign
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
    doc #>> '{fields,inputs,source}'::text[] AS source,
    doc #>> '{fields,inputs,source_id}'::text[] AS source_id,
    doc #>> '{fields,inputs,is_follow_up}'::text[] AS is_follow_up,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    doc #>> '{fields,inputs,contact,date_of_birth}'::text[] AS inputs_contact_date_of_birth,
    doc #>> '{fields,inputs,contact,sex}'::text[] AS inputs_contact_sex,
    doc #>> '{fields,inputs,contact,parent,_id}'::text[] AS inputs_parent_id,
    doc #>> '{fields,is_of_child_bearing_age}'::text[] AS is_of_child_bearing_age,
    doc #>> '{fields,visited_contact_uuid}'::text[] AS visited_contact_uuid,
    doc #>> '{fields,patient_age_in_years}'::text[] AS patient_age_in_years,
    doc #>> '{fields,patient_age_in_months}'::text[] AS patient_age_in_months,
    doc #>> '{fields,patient_age_in_days}'::text[] AS patient_age_in_days,
    doc #>> '{fields,patient_age_display}'::text[] AS patient_age_display,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,patient_name}'::text[] AS patient_name,
    doc #>> '{fields,patient_name_with_s}'::text[] AS patient_name_with_s,
    doc #>> '{fields,patient_gender}'::text[] AS patient_gender,
    doc #>> '{fields,group_danger_sign,visited_health_facility}'::text[] AS visited_health_facility,
    doc #>> '{fields,group_danger_sign,still_experiencing_danger_signs}'::text[] AS still_experiencing_danger_signs,
    doc #>> '{fields,group_danger_sign,note_monitor_till_next_pnc_check_up}'::text[] AS note_monitor_till_next_pnc_check_up,
    doc #>> '{fields,group_danger_sign,note_still_experiencing_danger_signs}'::text[] AS note_still_experiencing_danger_signs,
    doc #>> '{fields,group_danger_sign,note_danger_signs}'::text[] AS note_danger_signs,
    doc #>> '{fields,group_danger_sign,excessive_bleeding}'::text[] AS excessive_bleeding,
    doc #>> '{fields,group_danger_sign,vaginal_discharge}'::text[] AS vaginal_discharge,
    doc #>> '{fields,group_danger_sign,severe_abdominal_pain}'::text[] AS severe_abdominal_pain,
    doc #>> '{fields,group_danger_sign,swelling}'::text[] AS swelling,
    doc #>> '{fields,group_danger_sign,blurred_vision}'::text[] AS blurred_vision,
    doc #>> '{fields,group_danger_sign,fever}'::text[] AS fever,
    doc #>> '{fields,group_danger_sign,excessive_tiredness}'::text[] AS excessive_tiredness,
    doc #>> '{fields,group_danger_sign,breathlessness}'::text[] AS breathlessness,
    doc #>> '{fields,group_danger_sign,has_danger_signs}'::text[] AS has_danger_signs,
    doc #>> '{fields,group_danger_sign,has_no_danger_signs}'::text[] AS has_no_danger_signs,
    doc #>> '{fields,group_danger_sign,note_refer}'::text[] AS note_refer,
    doc #>> '{fields,group_danger_sign,referred_to_facility}'::text[] AS referred_to_facility,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
FROM dwh.cht_data d
LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id 
  WHERE (doc ->> 'form'::text) = 'pnc_danger_sign'::text AND is_current
WITH DATA;

-- View indexes:
CREATE INDEX pnc_danger_sign_reported_idx ON cht.mv_pnc_danger_sign USING btree (reported) tablespace ts_indexes;
CREATE INDEX pnc_danger_sign_date_idx ON cht.mv_pnc_danger_sign USING btree (date) tablespace ts_indexes;
CREATE INDEX pnc_danger_sign_year_idx ON cht.mv_pnc_danger_sign USING btree (year) tablespace ts_indexes;
CREATE INDEX pnc_danger_sign_month_idx ON cht.mv_pnc_danger_sign USING btree (month) tablespace ts_indexes;
CREATE INDEX pnc_danger_sign_monthname_idx ON cht.mv_pnc_danger_sign USING btree (monthname) tablespace ts_indexes;
CREATE INDEX pnc_danger_sign_chw_id_idx ON cht.mv_pnc_danger_sign USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX pnc_danger_sign_facility_idx ON cht.mv_pnc_danger_sign USING btree (facility) tablespace ts_indexes;
CREATE INDEX pnc_danger_sign_dhis2_facility_id_idx ON cht.mv_pnc_danger_sign USING btree (dhis2_facility_id) tablespace ts_indexes;
CREATE INDEX pnc_danger_sign_village_idx ON cht.mv_pnc_danger_sign USING btree (village) tablespace ts_indexes;
CREATE INDEX pnc_danger_sign_district_idx ON cht.mv_pnc_danger_sign USING btree (district) tablespace ts_indexes;
CREATE INDEX pnc_danger_sign_region_idx ON cht.mv_pnc_danger_sign USING btree (region) tablespace ts_indexes;