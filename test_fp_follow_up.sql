CREATE MATERIALIZED VIEW cht.mv_fp_follow_up
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
    doc #>> '{fields,coc_given}'::text[] AS coc_given, --(int)
    doc #>> '{fields,condoms_given}'::text[] AS condoms_given, --(int)
    doc #>> '{fields,pop_given}'::text[] AS pop_given, --(int)
    doc #>> '{fields,dmpa_given}'::text[] AS dmpa_given, --(int)
    doc #>> '{fields,contraceptives_given}'::text[] AS contraceptives_given, --(int)
    doc #>> '{fields,fp_follow_up,on_fp}'::text[] AS on_fp, --(yes/no)
    doc #>> '{fields,fp_follow_up,not_on_fp_reason}'::text[] AS not_on_fp_reason, --(wants_baby/wants_change_fp/is_pregnant/side_effects/spouse_refused/other)
    doc #>> '{fields,fp_follow_up,n_refer_change_fp}'::text[] AS n_refer_change_fp,
    doc #>> '{fields,fp_follow_up,referred_patient_not_on_fp}'::text[] AS referred_patient_not_on_fp,--(yes)
    doc #>> '{fields,fp_follow_up,continue_current_fp_method}'::text[] AS continue_current_fp_method, --(yes/no)
    doc #>> '{fields,fp_follow_up,can_supply_fp_commodities}'::text[] AS can_supply_fp_commodities, --(yes/no)
    doc #>> '{fields,fp_follow_up,supply_item_units}'::text[] AS supply_item_units,
    doc #>> '{fields,fp_follow_up,supply_limit}'::text[] AS supply_limit,
    doc #>> '{fields,fp_follow_up,commodities_supplied_qty}'::text[] AS commodities_supplied_qty, --(int)
    doc #>> '{fields,fp_follow_up,referred_patient_change_fp}'::text[] AS referred_patient_change_fp, --(yes/no)

    -- Last column for tracking refresh
    CURRENT_TIMESTAMP AS last_refresh_date

FROM dwh.cht_data couchdb
WHERE (doc ->> 'form'::text) = 'fp_follow_up'::text
  AND is_current
WITH DATA;

-- Index on reported and chw_id
CREATE INDEX mv_fp_follow_up_reported_chw_id
    ON report.mv_fp_follow_up USING btree (reported, chw_id);