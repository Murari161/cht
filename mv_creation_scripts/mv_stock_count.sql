-- cht.mv_stock_count source
DROP MATERIALIZED VIEW cht.mv_stock_count;
CREATE MATERIALIZED VIEW cht.mv_stock_count
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
    doc ->> 'from'::text AS "from",
    doc #>> '{fields,inputs,source}'::text[] AS source,
    doc #>> '{fields,inputs,source_id}'::text[] AS source_id,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS contact_name,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,act_item_received}'::text[] AS act_item_received,
    doc #>> '{fields,zinc_item_received}'::text[] AS zinc_item_received,
    doc #>> '{fields,amoxicillin_item_received}'::text[] AS amoxicillin_item_received,
    doc #>> '{fields,malaria_rdts_item_received}'::text[] AS malaria_rdts_item_received,
    doc #>> '{fields,pop_item_received}'::text[] AS pop_item_received,
    doc #>> '{fields,dmpa_item_received}'::text[] AS dmpa_item_received,
    doc #>> '{fields,misoprostol_item_received}'::text[] AS misoprostol_item_received,
    doc #>> '{fields,coc_item_received}'::text[] AS coc_item_received,
    doc #>> '{fields,condoms_item_received}'::text[] AS condoms_item_received,
    doc #>> '{fields,contraceptives_item_received}'::text[] AS contraceptives_item_received,
    doc #>> '{fields,rectal_item_received}'::text[] AS rectal_item_received,
    doc #>> '{fields,sayana_item_received}'::text[] AS sayana_item_received,
    doc #>> '{fields,gloves_item_received}'::text[] AS gloves_item_received,
    doc #>> '{fields,is_mch_instance}'::text[] AS is_mch_instance,
    doc #>> '{fields,items,commodities_note}'::text[] AS commodities_note,
    doc #>> '{fields,items,act}'::text[] AS act,
    doc #>> '{fields,items,malaria_rdts}'::text[] AS malaria_rdts,
    doc #>> '{fields,items,rectal}'::text[] AS rectal,
    doc #>> '{fields,items,gloves}'::text[] AS gloves,
    doc #>> '{fields,items,zinc}'::text[] AS zinc,
    doc #>> '{fields,items,amoxicillin}'::text[] AS amoxicillin,
    doc #>> '{fields,items,pop}'::text[] AS pop,
    doc #>> '{fields,items,coc}'::text[] AS coc,
    doc #>> '{fields,items,contraceptives}'::text[] AS contraceptives,
    doc #>> '{fields,items,dmpa}'::text[] AS dmpa,
    doc #>> '{fields,items,condoms}'::text[] AS condoms,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.parish,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
FROM dwh.cht_data d LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id 
  WHERE (doc ->> 'form'::text) = 'stock_count'::text AND is_current
WITH NO DATA;

-- View indexes:
CREATE INDEX mv_stock_count_reported_idx ON cht.mv_stock_count USING btree (reported) tablespace ts_indexes;
CREATE INDEX mv_stock_count_date_idx ON cht.mv_stock_count USING btree (date) tablespace ts_indexes;
CREATE INDEX mv_stock_count_monthname_idx ON cht.mv_stock_count USING btree (monthname) tablespace ts_indexes;
CREATE INDEX mv_stock_count_year_month_district ON cht.mv_stock_count USING btree (year, month, district) TABLESPACE ts_indexes;
CREATE INDEX mv_stock_count_chw_id_idx ON cht.mv_stock_count USING btree (chw_id) tablespace ts_indexes;
CREATE INDEX mv_stock_count_facility_idx ON cht.mv_stock_count USING btree (facility) tablespace ts_indexes;
CREATE INDEX mv_stock_count_dhis2_facility_id_idx ON cht.mv_stock_count USING btree (dhis2_facility_id) tablespace ts_indexes;
CREATE INDEX mv_stock_count_village_idx ON cht.mv_stock_count USING btree (village) tablespace ts_indexes;
CREATE INDEX mv_stock_count_district_idx ON cht.mv_stock_count USING btree (district) tablespace ts_indexes;
CREATE INDEX mv_stock_count_region_idx ON cht.mv_stock_count USING btree (region) tablespace ts_indexes;
