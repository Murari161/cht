

CREATE MATERIALIZED VIEW cht.mv_fp_registration
TABLESPACE ts_report
AS
SELECT
    -- Standard document fields (from doc root, not in XML)
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
     CURRENT_TIMESTAMP AS last_refresh_date
    -- Geolocation fields (from doc root, assumed relevant)

    doc #>> '{geolocation,latitude}'::text[] AS latitude,
    doc #>> '{geolocation,longitude}'::text[] AS longitude,
    doc #>> '{geolocation,altitude}'::text[] AS altitude,
    

    -- inputs/meta/location fields
    doc #>> '{fields,inputs,meta,location,lat}'::text[] AS inputs_location_lat,
    doc #>> '{fields,inputs,meta,location,long}'::text[] AS inputs_location_long,
    doc #>> '{fields,inputs,meta,location,error}'::text[] AS inputs_location_error,
    doc #>> '{fields,inputs,meta,location,message}'::text[] AS inputs_location_message,

    -- inputs fields
    doc #>> '{fields,inputs,source}'::text[] AS inputs_source,
    doc #>> '{fields,inputs,source_id}'::text[] AS inputs_source_id,

    -- inputs/contact fields
    doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    doc #>> '{fields,inputs,contact,patient_id}'::text[] AS inputs_contact_patient_id,
    doc #>> '{fields,inputs,contact,date_of_birth}'::text[] AS inputs_contact_date_of_birth,
    doc #>> '{fields,inputs,contact,sex}'::text[] AS inputs_contact_sex,

    -- inputs/contact/parent fields
    doc #>> '{fields,inputs,contact,parent,_id}'::text[] AS inputs_parent_id,
    doc #>> '{fields,inputs,contact,parent,name}'::text[] AS inputs_parent_name,

    -- inputs/contact/parent/parent fields
    doc #>> '{fields,inputs,contact,parent,parent,contact,name}'::text[] AS inputs_parent_contact_name,
    doc #>> '{fields,inputs,contact,parent,parent,contact,phone}'::text[] AS inputs_parent_contact_phone,
    doc #>> '{fields,inputs,contact,parent,parent,_id}'::text[] AS inputs_parent_parent_id,
    doc #>> '{fields,inputs,contact,parent,parent,supervisor}'::text[] AS inputs_parent_supervisor,

    -- inputs/contact/parent/parent/parent fields
    doc #>> '{fields,inputs,contact,parent,parent,parent,_id}'::text[] AS inputs_parent_parent_parent_id,

    -- Top-level fields (distinct from inputs)
    doc #>> '{fields,source}'::text[] AS fields_source,
    doc #>> '{fields,source_id}'::text[] AS fields_source_id,
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
    doc #>> '{fields,chw_area_id}'::text[] AS chw_area_id,
    doc #>> '{fields,supervisor_id}'::text[] AS supervisor_id,
    doc #>> '{fields,branch_id}'::text[] AS branch_id,
    doc #>> '{fields,fp_next_appt_date}'::text[] AS fp_next_appt_date,
    doc #>> '{fields,coc_given}'::text[] AS coc_given, --(int)
    doc #>> '{fields,condoms_given}'::text[] AS condoms_given, --(int)
    doc #>> '{fields,pop_given}'::text[] AS pop_given,--(int)
    doc #>> '{fields,dmpa_given}'::text[] AS dmpa_given,--(int)
    doc #>> '{fields,contraceptives_given}'::text[] AS contraceptives_given, --(int)
    -- fp_registration fields
    doc #>> '{fields,fp_registration,fp_method}'::text[] AS fp_method, --(combined_oral_contraceptives/progestreone_only_pills/dmpa/implant/iud/condoms/contraceptives/tubal_ligation/none)
    doc #>> '{fields,fp_registration,who_administered_dmpa}'::text[] AS who_administered_dmpa, --(provider_administered/self_injected)
    doc #>> '{fields,fp_registration,condoms_received}'::text[] AS condoms_received, --(int)
    doc #>> '{fields,fp_registration,enrol_on_fp_method}'::text[] AS enrol_on_fp_method, --(yes/no)
    doc #>> '{fields,fp_registration,continue_current_fp_method}'::text[] AS continue_current_fp_method, --(yes/no)
    doc #>> '{fields,fp_registration,patient_referred}'::text[] AS patient_referred, --(yes/no)
    doc #>> '{fields,fp_registration,can_supply_fp_commodities}'::text[] AS can_supply_fp_commodities, --(yes/no)
    doc #>> '{fields,fp_registration,supply_limit}'::text[] AS supply_limit, --(int)
    doc #>> '{fields,fp_registration,commodities_supplied_qty}'::text[] AS commodities_supplied_qty, --(int)
    CURRENT_TIMESTAMP AS last_refresh_date


FROM dwh.cht_data couchdb
WHERE (doc ->> 'form'::text) = 'fp_registration'::text
  AND is_current
WITH DATA;

-- Index to ensure uniqueness
CREATE INDEX mv_fp_registration_reported
    ON cht.mv_fp_registration USING btree (reported);