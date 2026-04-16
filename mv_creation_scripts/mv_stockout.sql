-- cht.mv_stockout source
DROP MATERIALIZED VIEW cht.mv_stockout;
CREATE MATERIALIZED VIEW cht.mv_stockout
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
    doc ->> 'from'::text AS "from",
    doc #>> '{fields,inputs,source}'::text[] AS source,
    doc #>> '{fields,inputs,source_id}'::text[] AS source_id,
    doc #>> '{fields,inputs,act_stock_value}'::text[] AS act_stock_value,
    doc #>> '{fields,inputs,gloves_stock_value}'::text[] AS gloves_stock_value,
    doc #>> '{fields,inputs,zinc_stock_value}'::text[] AS zinc_stock_value,
    doc #>> '{fields,inputs,amoxicillin_stock_value}'::text[] AS amoxicillin_stock_value,
    doc #>> '{fields,inputs,malaria_rdts_stock_value}'::text[] AS malaria_rdts_stock_value,
    doc #>> '{fields,inputs,pop_stock_value}'::text[] AS pop_stock_value,
    doc #>> '{fields,inputs,dmpa_stock_value}'::text[] AS dmpa_stock_value,
    doc #>> '{fields,inputs,misoprostol_stock_value}'::text[] AS misoprostol_stock_value,
    doc #>> '{fields,inputs,coc_stock_value}'::text[] AS coc_stock_value,
    doc #>> '{fields,inputs,condoms_stock_value}'::text[] AS condoms_stock_value,
    doc #>> '{fields,inputs,contraceptives_stock_value}'::text[] AS contraceptives_stock_value,
    doc #>> '{fields,inputs,rectal_stock_value}'::text[] AS rectal_stock_value,
    doc #>> '{fields,inputs,sayana_stock_value}'::text[] AS sayana_stock_value,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    doc #>> '{fields,inputs,contact,contact,name}'::text[] AS nested_contact_name,
    doc #>> '{fields,place_id}'::text[] AS place_id,
    doc #>> '{fields,private}'::text[] AS private,
    doc #>> '{fields,place_name}'::text[] AS place_name,
    doc #>> '{fields,vht_name}'::text[] AS vht_name,
    doc #>> '{fields,act_low}'::text[] AS act_low,
    doc #>> '{fields,amoxicillin_low}'::text[] AS amoxicillin_low,
    doc #>> '{fields,zinc_low}'::text[] AS zinc_low,
    doc #>> '{fields,condoms_low}'::text[] AS condoms_low,
    doc #>> '{fields,rdts_low}'::text[] AS rdts_low,
    doc #>> '{fields,coc_low}'::text[] AS coc_low,
    doc #>> '{fields,pop_low}'::text[] AS pop_low,
    doc #>> '{fields,contraceptives_low}'::text[] AS contraceptives_low,
    doc #>> '{fields,dmpa_low}'::text[] AS dmpa_low,
    doc #>> '{fields,rectal_low}'::text[] AS rectal_low,
    doc #>> '{fields,gloves_low}'::text[] AS gloves_low,
    doc #>> '{fields,vht_stock_details,note_low_stock}'::text[] AS note_low_stock,
    doc #>> '{fields,vht_stock_details,act_at_hand}'::text[] AS act_at_hand,
    doc #>> '{fields,vht_stock_details,mrdt_at_hand}'::text[] AS mrdt_at_hand,
    doc #>> '{fields,vht_stock_details,rectal_at_hand}'::text[] AS rectal_at_hand,
    doc #>> '{fields,vht_stock_details,gloves_at_hand}'::text[] AS gloves_at_hand,
    doc #>> '{fields,vht_stock_details,zinc_at_hand}'::text[] AS zinc_at_hand,
    doc #>> '{fields,vht_stock_details,amoxicillin_at_hand}'::text[] AS amoxicillin_at_hand,
    doc #>> '{fields,vht_stock_details,pop_at_hand}'::text[] AS pop_at_hand,
    doc #>> '{fields,vht_stock_details,coc_at_hand}'::text[] AS coc_at_hand,
    doc #>> '{fields,vht_stock_details,contraceptives_at_hand}'::text[] AS contraceptives_at_hand,
    doc #>> '{fields,vht_stock_details,dmpa_at_hand}'::text[] AS dmpa_at_hand,
    doc #>> '{fields,vht_stock_details,condom_at_hand}'::text[] AS condom_at_hand,
    doc #>> '{fields,vht_stock_details,action,note_replenish_stock}'::text[] AS action_note_replenish_stock,
    doc #>> '{fields,vht_stock_details,action,action_taken}'::text[] AS action_taken,
    doc #>> '{fields,vht_stock_details,action,other_action_taken}'::text[] AS action_other_action_taken,
    doc #>> '{fields,vht_stock_details,action,issued_stock_note}'::text[] AS action_issued_stock_note,
    doc #>> '{fields,inputs,contact,_id}'                         AS vht_area_id,
      h.facility_name,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
FROM dwh.cht_data d LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{fields,inputs,contact,_id}') = h.vht_area_id 
  WHERE (doc ->> 'form'::text) = 'stockout'::text AND is_current
WITH DATA;

-- View indexes:
CREATE INDEX mv_stockout_reported_idx ON cht.mv_stockout USING btree (reported) tablespace ts_indexes;
CREATE INDEX mv_stockout_date_idx ON cht.mv_stockout USING btree (date) tablespace ts_indexes;
CREATE INDEX mv_stockout_year_idx ON cht.mv_stockout USING btree (year) tablespace ts_indexes;
CREATE INDEX mv_stockout_month_idx ON cht.mv_stockout USING btree (month) tablespace ts_indexes;
CREATE INDEX mv_stockout_monthname_idx ON cht.mv_stockout USING btree (monthname) tablespace ts_indexes;
CREATE INDEX mv_stockout_vht_area_id_idx ON cht.mv_stockout USING btree (vht_area_id) tablespace ts_indexes;
CREATE INDEX mv_stockout_facility_name_idx ON cht.mv_stockout USING btree (facility_name) tablespace ts_indexes;
CREATE INDEX mv_stockout_dhis2_facility_id_idx ON cht.mv_stockout USING btree (dhis2_facility_id) tablespace ts_indexes;