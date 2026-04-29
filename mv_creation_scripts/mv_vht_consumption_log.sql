-- cht.mv_vht_consumption_log source
DROP MATERIALIZED VIEW cht.mv_vht_consumption_log;
CREATE MATERIALIZED VIEW cht.mv_vht_consumption_log
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
    doc #>> '{fields,inputs,source}'::text[] AS inputs_source,
    doc #>> '{fields,inputs,source_id}'::text[] AS inputs_source_id,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,act_item_received}'::text[] AS act_item_received,
    doc #>> '{fields,act_item_returned}'::text[] AS act_item_returned,
    doc #>> '{fields,zinc_item_received}'::text[] AS zinc_item_received,
    doc #>> '{fields,zinc_item_returned}'::text[] AS zinc_item_returned,
    doc #>> '{fields,amoxicillin_item_received}'::text[] AS amoxicillin_item_received,
    doc #>> '{fields,amoxicillin_item_returned}'::text[] AS amoxicillin_item_returned,
    doc #>> '{fields,malaria_rdts_item_received}'::text[] AS malaria_rdts_item_received,
    doc #>> '{fields,malaria_rdts_item_returned}'::text[] AS malaria_rdts_item_returned,
    doc #>> '{fields,pop_item_received}'::text[] AS pop_item_received,
    doc #>> '{fields,pop_item_returned}'::text[] AS pop_item_returned,
    doc #>> '{fields,dmpa_item_received}'::text[] AS dmpa_item_received,
    doc #>> '{fields,dmpa_item_returned}'::text[] AS dmpa_item_returned,
    doc #>> '{fields,misoprostol_item_received}'::text[] AS misoprostol_item_received,
    doc #>> '{fields,misoprostol_item_returned}'::text[] AS misoprostol_item_returned,
    doc #>> '{fields,coc_item_received}'::text[] AS coc_item_received,
    doc #>> '{fields,coc_item_returned}'::text[] AS coc_item_returned,
    doc #>> '{fields,condoms_item_received}'::text[] AS condoms_item_received,
    doc #>> '{fields,condoms_item_returned}'::text[] AS condoms_item_returned,
    doc #>> '{fields,contraceptives_item_received}'::text[] AS contraceptives_item_received,
    doc #>> '{fields,contraceptives_item_returned}'::text[] AS contraceptives_item_returned,
    doc #>> '{fields,rectal_item_received}'::text[] AS rectal_item_received,
    doc #>> '{fields,rectal_item_returned}'::text[] AS rectal_item_returned,
    doc #>> '{fields,sayana_item_received}'::text[] AS sayana_item_received,
    doc #>> '{fields,sayana_item_returned}'::text[] AS sayana_item_returned,
    doc #>> '{fields,gloves_item_received}'::text[] AS gloves_item_received,
    doc #>> '{fields,gloves_item_returned}'::text[] AS gloves_item_returned,
    doc #>> '{fields,is_mch_instance}'::text[] AS is_mch_instance,
    doc #>> '{fields,items,date}'::text[] AS items_date,
    doc #>> '{fields,items,reported_stock}'::text[] AS items_reported_stock,
    doc #>> '{fields,items,return_note}'::text[] AS items_return_note,
    doc #>> '{fields,items,receive_note}'::text[] AS items_receive_note,
    doc #>> '{fields,items_received,add_note}'::text[] AS items_received_add_note,
    doc #>> '{fields,items_received,act}'::text[] AS items_received_act,
    doc #>> '{fields,items_received,malaria_rdts}'::text[] AS items_received_malaria_rdts,
    doc #>> '{fields,items_received,rectal}'::text[] AS items_received_rectal,
    doc #>> '{fields,items_received,gloves}'::text[] AS items_received_gloves,
    doc #>> '{fields,items_received,zinc}'::text[] AS items_received_zinc,
    doc #>> '{fields,items_received,amoxicillin}'::text[] AS items_received_amoxicillin,
    doc #>> '{fields,items_received,pop}'::text[] AS items_received_pop,
    doc #>> '{fields,items_received,coc}'::text[] AS items_received_coc,
    doc #>> '{fields,items_received,contraceptives}'::text[] AS items_received_contraceptives,
    doc #>> '{fields,items_received,dmpa}'::text[] AS items_received_dmpa,
    doc #>> '{fields,items_received,condoms}'::text[] AS items_received_condoms,
    doc #>> '{fields,items_returned,return_note}'::text[] AS items_returned_return_note,
    doc #>> '{fields,items_returned,act_r}'::text[] AS items_returned_act_r,
    doc #>> '{fields,items_returned,malaria_rdts_r}'::text[] AS items_returned_malaria_rdts_r,
    doc #>> '{fields,items_returned,rectal_r}'::text[] AS items_returned_rectal_r,
    doc #>> '{fields,items_returned,gloves_r}'::text[] AS items_returned_gloves_r,
    doc #>> '{fields,items_returned,zinc_r}'::text[] AS items_returned_zinc_r,
    doc #>> '{fields,items_returned,amoxicillin_r}'::text[] AS items_returned_amoxicillin_r,
    doc #>> '{fields,items_returned,pop_r}'::text[] AS items_returned_pop_r,
    doc #>> '{fields,items_returned,coc_r}'::text[] AS items_returned_coc_r,
    doc #>> '{fields,items_returned,contraceptives_r}'::text[] AS items_returned_contraceptives_r,
    doc #>> '{fields,items_returned,dmpa_r}'::text[] AS items_returned_dmpa_r,
    doc #>> '{fields,items_returned,condoms_r}'::text[] AS items_returned_condoms_r,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
FROM dwh.cht_data d LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id
  WHERE (doc ->> 'form'::text) = 'vht_consumption_log'::text AND is_current
WITH DATA;

-- View indexes:
CREATE INDEX mv_vht_consumption_log_chw_id ON cht.mv_vht_consumption_log USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX mv_vht_consumption_log_reported ON cht.mv_vht_consumption_log USING btree (reported) tablespace ts_indexes;
CREATE INDEX mv_vht_consumption_log_date ON cht.mv_vht_consumption_log USING btree (date) tablespace ts_indexes;
CREATE INDEX mv_vht_consumption_log_year ON cht.mv_vht_consumption_log USING btree (year) tablespace ts_indexes;
CREATE INDEX mv_vht_consumption_log_month ON cht.mv_vht_consumption_log USING btree (month) tablespace ts_indexes;
CREATE INDEX mv_vht_consumption_log_monthname ON cht.mv_vht_consumption_log USING btree (monthname) tablespace ts_indexes;
CREATE INDEX mv_vht_consumption_log_district ON cht.mv_vht_consumption_log USING btree (district) tablespace ts_indexes;
CREATE INDEX mv_vht_consumption_log_region ON cht.mv_vht_consumption_log USING btree (region) tablespace ts_indexes;
CREATE INDEX mv_vht_consumption_log_facility ON cht.mv_vht_consumption_log USING btree (facility) tablespace ts_indexes;  
CREATE INDEX mv_vht_consumption_log_dhis2_facility_id ON cht.mv_vht_consumption_log USING btree (dhis2_facility_id) tablespace ts_indexes;
CREATE INDEX mv_vht_consumption_log_village ON cht.mv_vht_consumption_log USING btree (village) tablespace ts_indexes;