-- cht.mv_pnc_follow_up source
DROP MATERIALIZED VIEW cht.mv_pnc_follow_up;
CREATE MATERIALIZED VIEW cht.mv_pnc_follow_up
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
    doc ->> 'form'::text AS form,
    doc ->> 'from'::text AS "from",
    doc #>> '{fields,inputs,source}'::text[] AS source,
    doc #>> '{fields,inputs,source_id}'::text[] AS source_id,
    doc #>> '{fields,inputs,task_name}'::text[] AS task_name,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    doc #>> '{fields,inputs,contact,date_of_birth}'::text[] AS inputs_contact_date_of_birth,
    doc #>> '{fields,inputs,contact,sex}'::text[] AS inputs_contact_sex,
    doc #>> '{fields,inputs,contact,parent,_id}'::text[] AS inputs_parent_id,
    doc #>> '{fields,is_of_child_bearing_age}'::text[] AS is_of_child_bearing_age,
    doc #>> '{fields,patient_age_in_years}'::text[] AS patient_age_in_years,
    doc #>> '{fields,patient_age_in_months}'::text[] AS patient_age_in_months,
    doc #>> '{fields,patient_age_in_days}'::text[] AS patient_age_in_days,
    doc #>> '{fields,patient_age_display}'::text[] AS patient_age_display,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,patient_name}'::text[] AS patient_name,
    doc #>> '{fields,patient_gender}'::text[] AS patient_gender,
    doc #>> '{fields,patient_name_with_s}'::text[] AS patient_name_with_s,
    doc #>> '{fields,nutrition_follow_up_date}'::text[] AS nutrition_follow_up_date,
    doc #>> '{fields,referred_for_nutrition_follow_up}'::text[] AS referred_for_nutrition_follow_up,
    doc #>> '{fields,group_label}'::text[] AS group_label,
    doc #>> '{fields,group_pnc_referral_follow_up,went_facility_as_referred}'::text[] AS went_facility_as_referred,
    doc #>> '{fields,group_missed_referral_details,missed_referral_reason}'::text[] AS missed_referral_reason,
    doc #>> '{fields,group_missed_referral_details,specify_other}'::text[] AS specify_other,
    doc #>> '{fields,group_missed_referral_details,missed_referral_actions}'::text[] AS missed_referral_actions,
    doc #>> '{fields,group_mother_condition,mother_condition}'::text[] AS mother_condition,
    doc #>> '{fields,group_mother_condition,date_of_death}'::text[] AS date_of_death,
    doc #>> '{fields,group_follow_up,is_available}'::text[] AS is_available,
    doc #>> '{fields,group_follow_up,follow_up_again_date}'::text[] AS follow_up_again_date,
    doc #>> '{fields,group_missed_pnc_visit,missed_visit_reason}'::text[] AS missed_visit_reason,
    doc #>> '{fields,group_missed_pnc_visit,missed_visit_reason_other}'::text[] AS missed_visit_reason_other,
    doc #>> '{fields,group_missed_pnc_visit,note_pnc_importance}'::text[] AS note_pnc_importance,
    doc #>> '{fields,group_missed_pnc_visit,agreed_to_go_for_pnc_visit}'::text[] AS agreed_to_go_for_pnc_visit,
    doc #>> '{fields,group_missed_pnc_visit,agreed_date_for_pnc_visit}'::text[] AS agreed_date_for_pnc_visit,
    doc #>> '{fields,group_pnc_visit,has_attended_pnc_facility}'::text[] AS has_attended_pnc_facility,
    doc #>> '{fields,group_pnc_visit,pnc_visit}'::text[] AS pnc_visit,
    doc #>> '{fields,group_pnc_visit,visit_date}'::text[] AS visit_date,
    doc #>> '{fields,group_woman_nutritional_status,note_nutrition_status}'::text[] AS note_nutrition_status,
    doc #>> '{fields,group_woman_nutritional_status,on_nutrition_follow_up}'::text[] AS on_nutrition_follow_up,
    doc #>> '{fields,group_woman_nutritional_status,note_use_muac_tape}'::text[] AS note_use_muac_tape,
    doc #>> '{fields,group_woman_nutritional_status,taken_muac}'::text[] AS taken_muac,
    doc #>> '{fields,group_woman_nutritional_status,muac_measurement}'::text[] AS muac_measurement,
    doc #>> '{fields,group_woman_nutritional_status,note_has_sam}'::text[] AS note_has_sam,
    doc #>> '{fields,group_woman_nutritional_status,note_has_mam}'::text[] AS note_has_mam,
    doc #>> '{fields,group_woman_nutritional_status,note_refer_to_health_facility}'::text[] AS note_refer_to_health_facility,
    doc #>> '{fields,group_woman_nutritional_status,referred_to_health_facility_nutrition}'::text[] AS referred_to_health_facility_nutrition,
    doc #>> '{fields,group_woman_nutritional_status,completed_last_nutrition_follow_up}'::text[] AS completed_last_nutrition_follow_up,
    doc #>> '{fields,group_woman_nutritional_status,next_nutrition_follow_up_date}'::text[] AS next_nutrition_follow_up_date,
    doc #>> '{fields,group_woman_nutritional_status,note_thank_you_nutrition_follow_up}'::text[] AS note_thank_you_nutrition_follow_up,
    doc #>> '{fields,group_woman_nutritional_status,note_refer_did_not_complete_follow_up}'::text[] AS note_refer_did_not_complete_follow_up,
    doc #>> '{fields,group_woman_nutritional_status,referred_to_health_facility_missed_nutrition_follow_up}'::text[] AS referred_to_health_facility_missed_nutrition_follow_up,
    doc #>> '{fields,group_safe_postnatal_practices,note_eat_well}'::text[] AS note_eat_well,
    doc #>> '{fields,group_safe_postnatal_practices,note_exclusive_breast_feeding}'::text[] AS note_exclusive_breast_feeding,
    doc #>> '{fields,group_safe_postnatal_practices,note_keep_baby_warm}'::text[] AS note_keep_baby_warm,
    doc #>> '{fields,group_safe_postnatal_practices,note_use_llin}'::text[] AS note_use_llin,
    doc #>> '{fields,group_safe_postnatal_practices,note_clean_dry_umbilical_cord}'::text[] AS note_clean_dry_umbilical_cord,
    doc #>> '{fields,group_safe_postnatal_practices,note_fp}'::text[] AS note_fp,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
FROM dwh.cht_data d
LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id
  WHERE (doc ->> 'form'::text) = 'pnc_follow_up'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX pnc_follow_up_reported_idx ON cht.mv_pnc_follow_up USING btree (reported) tablespace ts_indexes;
CREATE INDEX pnc_follow_up_date_idx ON cht.mv_pnc_follow_up USING btree (date) tablespace ts_indexes;
CREATE INDEX mv_pnc_follow_up_year_month_district ON cht.mv_pnc_follow_up USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX pnc_follow_up_monthname_idx ON cht.mv_pnc_follow_up USING btree (monthname) tablespace ts_indexes;
CREATE INDEX pnc_follow_up_village_idx ON cht.mv_pnc_follow_up USING btree (village) tablespace ts_indexes;
CREATE INDEX pnc_follow_up_district_idx ON cht.mv_pnc_follow_up USING btree (district) tablespace ts_indexes;
CREATE INDEX pnc_follow_up_region_idx ON cht.mv_pnc_follow_up USING btree (region) tablespace ts_indexes;
CREATE INDEX pnc_follow_up_chw_id_idx ON cht.mv_pnc_follow_up USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX pnc_follow_up_facility_idx ON cht.mv_pnc_follow_up USING btree (facility) tablespace ts_indexes;
CREATE INDEX pnc_follow_up_dhis2_facility_id_idx ON cht.mv_pnc_follow_up USING btree (dhis2_facility_id) tablespace ts_indexes;