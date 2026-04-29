-- cht.mv_referral_follow_up source
DROP MATERIALIZED VIEW cht.mv_referral_follow_up;
CREATE MATERIALIZED VIEW cht.mv_referral_follow_up
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
    doc #>> '{fields,inputs,follow_up_type}'::text[] AS follow_up_type,
    doc #>> '{fields,inputs,t_place_name}'::text[] AS t_place_name,
    doc #>> '{fields,inputs,t_vht_name}'::text[] AS t_vht_name,
    doc #>> '{fields,inputs,t_vht_phone}'::text[] AS t_vht_phone,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    doc #>> '{fields,inputs,contact,date_of_birth}'::text[] AS inputs_contact_date_of_birth,
    doc #>> '{fields,inputs,contact,sex}'::text[] AS inputs_contact_sex,
    doc #>> '{fields,inputs,contact,parent,_id}'::text[] AS parent_id,
    doc #>> '{fields,inputs,contact,parent,parent,name}'::text[] AS parent_name,
    doc #>> '{fields,inputs,contact,parent,parent,supervisor}'::text[] AS supervisor,
    doc #>> '{fields,inputs,contact,parent,parent,phone}'::text[] AS phone,
    doc #>> '{fields,patient_age_in_years}'::text[] AS patient_age_in_years,
    doc #>> '{fields,patient_age_in_months}'::text[] AS patient_age_in_months,
    doc #>> '{fields,patient_age_in_days}'::text[] AS patient_age_in_days,
    doc #>> '{fields,patient_age_display}'::text[] AS patient_age_display,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,patient_name}'::text[] AS patient_name,
    doc #>> '{fields,patient_gender}'::text[] AS patient_gender,
    doc #>> '{fields,referral_follow_up_again}'::text[] AS referral_follow_up_again,
    doc #>> '{fields,chw_name}'::text[] AS chw_name,
    doc #>> '{fields,chw_phone}'::text[] AS chw_phone,
    doc #>> '{fields,chw_village}'::text[] AS chw_village,
    doc #>> '{fields,needs_signoff}'::text[] AS needs_signoff,
    doc #>> '{fields,group_follow_up,follow_up_date}'::text[] AS follow_up_date,
    doc #>> '{fields,group_follow_up,follow_up_method}'::text[] AS follow_up_method,
    doc #>> '{fields,group_person_condition,patient_condition}'::text[] AS patient_condition,
    doc #>> '{fields,group_referral_information,went_to_health_facility}'::text[] AS went_to_health_facility,
    doc #>> '{fields,group_referral_information,interact_with_healthcare}'::text[] AS interact_with_healthcare,
    doc #>> '{fields,group_referral_information,note_encourage_to_visit_health_facility}'::text[] AS note_encourage_to_visit_health_facility,
    doc #>> '{fields,group_referral_information,hc_visit_date}'::text[] AS hc_visit_date,
    doc #>> '{fields,group_referral_information,hc_attendant}'::text[] AS hc_attendant,
    doc #>> '{fields,group_referral_information,hc_attendant_other}'::text[] AS hc_attendant_other,
    doc #>> '{fields,group_referral_information,hc_name}'::text[] AS hc_name,
    doc #>> '{fields,group_referral_information,action_taken}'::text[] AS action_taken,
    doc #>> '{fields,group_referral_information,instructions_for_vht}'::text[] AS instructions_for_vht,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
FROM dwh.cht_data d
LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id
  WHERE (doc ->> 'form'::text) = 'referral_follow_up'::text AND is_current
WITH DATA;

-- View indexes:
CREATE INDEX referral_follow_up_reported_idx ON cht.mv_referral_follow_up USING btree (reported) tablespace ts_indexes;
CREATE INDEX referral_follow_up_date_idx ON cht.mv_referral_follow_up USING btree (date) tablespace ts_indexes;
CREATE INDEX referral_follow_up_year_idx ON cht.mv_referral_follow_up USING btree (year) tablespace ts_indexes;
CREATE INDEX referral_follow_up_month_idx ON cht.mv_referral_follow_up USING btree (month) tablespace ts_indexes;
CREATE INDEX referral_follow_up_monthname_idx ON cht.mv_referral_follow_up USING btree (monthname) tablespace ts_indexes;
CREATE INDEX referral_follow_up_district_idx ON cht.mv_referral_follow_up USING btree (district) tablespace ts_indexes;
CREATE INDEX referral_follow_up_region_idx ON cht.mv_referral_follow_up USING btree (region) tablespace ts_indexes;
CREATE INDEX referral_follow_up_chw_id_idx ON cht.mv_referral_follow_up USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX referral_follow_up_facility_idx ON cht.mv_referral_follow_up USING btree (facility) tablespace ts_indexes;
CREATE INDEX referral_follow_up_dhis2_facility_id_idx ON cht.mv_referral_follow_up USING btree (dhis2_facility_id) tablespace ts_indexes;
CREATE INDEX referral_follow_up_village_idx ON cht.mv_referral_follow_up USING btree (village) tablespace ts_indexes;
CREATE INDEX referral_follow_up_patient_id_idx ON cht.mv_referral_follow_up USING btree (patient_id) tablespace ts_indexes;