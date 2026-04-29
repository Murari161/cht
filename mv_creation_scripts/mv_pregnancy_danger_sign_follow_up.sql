-- cht.mv_pregnancy_danger_sign_follow_up source
DROP MATERIALIZED VIEW cht.mv_pregnancy_danger_sign_follow_up;
CREATE MATERIALIZED VIEW cht.mv_pregnancy_danger_sign_follow_up
TABLESPACE ts_report
AS SELECT doc_id,
    rev_id,
    ((doc -> 'fields'::text) -> 'meta'::text) ->> 'instanceID'::text AS instanceid,
    ((doc -> 'fields'::text) -> 'meta'::text) ->> 'deprecatedID'::text AS deprecatedid,
    (doc -> 'geolocation'::text) ->> 'code'::text AS code,
    (doc -> 'geolocation'::text) ->> 'message'::text AS message,
    to_timestamp((NULLIF(doc ->> 'reported_date'::text, ''::text)::bigint / 1000)::double precision) AS reported,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY-MM-DD'))::date AS date,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY'))::INT AS year,
    to_char(to_timestamp((((doc ->>'reported_date'::text)::bigint) / 1000)::double precision), 'MM'::text)::integer AS month,
    TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'FMMonth') AS monthname,

    doc ->> 'form'::text AS form,
    doc ->> 'from'::text AS "from",
    doc ->> 'type'::text AS type,
    ((doc -> 'fields'::text) -> 'data'::text) ->> '__fits'::text AS fits,
    ((doc -> 'fields'::text) -> 'data'::text) ->> '__fever'::text AS fever,
    ((doc -> 'fields'::text) -> 'data'::text) ->> '__very_pale'::text AS very_pale,
    ((doc -> 'fields'::text) -> 'data'::text) ->> '__visited_hf'::text AS visited_hf,
    ((doc -> 'fields'::text) -> 'data'::text) ->> '__easily_tired'::text AS easily_tired,
    ((doc -> 'fields'::text) -> 'data'::text) ->> '__breaking_water'::text AS breaking_water,
    ((doc -> 'fields'::text) -> 'data'::text) ->> '__breathlessness'::text AS breathlessness,
    ((doc -> 'fields'::text) -> 'data'::text) ->> '__has_danger_sign'::text AS has_danger_sign,
    ((doc -> 'fields'::text) -> 'data'::text) ->> '__severe_headache'::text AS severe_headache,
    ((doc -> 'fields'::text) -> 'data'::text) ->> '__vaginal_bleeding'::text AS vaginal_bleeding,
    ((doc -> 'fields'::text) -> 'data'::text) ->> '__face_hand_swelling'::text AS face_hand_swelling,
    ((doc -> 'fields'::text) -> 'data'::text) ->> '__severe_abdominal_pain'::text AS severe_abdominal_pain,
    ((doc -> 'fields'::text) -> 'data'::text) ->> '__reduced_or_no_fetal_movements'::text AS reduced_or_no_fetal_movements,
    ((doc -> 'fields'::text) -> 'data'::text) ->> '__still_experiencing_danger_sign'::text AS still_experiencing_danger_sign,
    (((doc -> 'fields'::text) -> 'data'::text) -> 'meta'::text) ->> '__source_id'::text AS source_id,
    ((doc -> 'fields'::text) -> 'inputs'::text) ->> 'source'::text AS source,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> '_id'::text AS inputs_contact_id,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> 'sex'::text AS inputs_contact_sex,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> 'name'::text AS inputs_contact_name,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'parent'::text) ->> '_id'::text AS parent_id,
    ((((((doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) -> 'parent'::text) -> 'parent'::text) -> 'contact'::text) ->> 'phone'::text AS phone,
    ((((((doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) -> 'parent'::text) -> 'parent'::text) -> 'contact'::text) ->> 'chw_name'::text AS chw_name,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> 'patient_id'::text AS patient_id,
    (doc -> 'fields'::text) ->> 'patient_uuid'::text AS patient_uuid,
    (doc -> 'fields'::text) ->> 'pregnancy_uuid_ctx'::text AS pregnancy_uuid_ctx,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'contact'::text) ->> 'date_of_birth'::text AS date_of_birth,
    (doc -> 'fields'::text) ->> 'patient_name'::text AS patient_name,
    (doc -> 'fields'::text) ->> 'patient_short_name'::text AS patient_short_name,
    (doc -> 'fields'::text) ->> 'patient_age_in_years'::text AS patient_age_in_years,
    (doc -> 'fields'::text) ->> 'patient_short_name_start'::text AS patient_short_name_start,
    (doc -> 'fields'::text) ->> 't_danger_signs_referral_follow_up'::text AS t_danger_signs_referral_follow_up,
    (doc -> 'fields'::text) ->> 't_danger_signs_referral_follow_up_date'::text AS t_danger_signs_referral_follow_up_date,
    ((doc -> 'fields'::text) -> 'danger_signs'::text) ->> 'visit_confirm'::text AS visit_confirm,
    (((doc -> 'fields'::text) -> 'danger_signs'::text) -> 'custom_translations'::text) ->> 'custom_woman_label'::text AS custom_woman_label,
    (((doc -> 'fields'::text) -> 'danger_signs'::text) -> 'custom_translations'::text) ->> 'custom_woman_start_label'::text AS custom_woman_start_label,
    (((doc -> 'fields'::text) -> 'danger_signs'::text) -> 'custom_translations'::text) ->> 'custom_woman_label_translator'::text AS custom_woman_label_translator,
    (((doc -> 'fields'::text) -> 'danger_signs'::text) -> 'custom_translations'::text) ->> 'custom_woman_start_label_translator'::text AS custom_woman_start_label_translator,
    ((doc -> 'fields'::text) -> 'danger_signs'::text) ->> 'danger_sign_present'::text AS danger_sign_present,
    ((doc -> 'fields'::text) -> 'danger_signs'::text) ->> 'r_danger_sign_present'::text AS r_danger_sign_present,
    ((doc -> 'fields'::text) -> 'danger_signs'::text) ->> 'congratulate_no_ds_note'::text AS congratulate_no_ds_note,
   doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
FROM dwh.cht_data d
LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id
  WHERE type = 'data_record'::text AND (doc ->> 'form'::text) = 'pregnancy_danger_sign_follow_up'::text AND is_current IS TRUE
WITH DATA;

CREATE INDEX pregnancy_danger_sign_follow_up_reported_idx ON cht.mv_pregnancy_danger_sign_follow_up USING btree (reported) tablespace ts_indexes;
CREATE INDEX pregnancy_danger_sign_follow_up_date_idx ON cht.mv_pregnancy_danger_sign_follow_up USING btree (date) tablespace ts_indexes;
CREATE INDEX pregnancy_danger_sign_follow_up_year_idx ON cht.mv_pregnancy_danger_sign_follow_up USING btree (year) tablespace ts_indexes;
CREATE INDEX pregnancy_danger_sign_follow_up_month_idx ON cht.mv_pregnancy_danger_sign_follow_up USING btree (month) tablespace ts_indexes;
CREATE INDEX pregnancy_danger_sign_follow_up_monthname_idx ON cht.mv_pregnancy_danger_sign_follow_up USING btree (monthname) tablespace ts_indexes;
CREATE INDEX pregnancy_danger_sign_follow_up_village_idx ON cht.mv_pregnancy_danger_sign_follow_up USING btree (village) tablespace ts_indexes;
CREATE INDEX pregnancy_danger_sign_follow_up_district_idx ON cht.mv_pregnancy_danger_sign_follow_up USING btree (district) tablespace ts_indexes;
CREATE INDEX pregnancy_danger_sign_follow_up_region_idx ON cht.mv_pregnancy_danger_sign_follow_up USING btree (region) tablespace ts_indexes;