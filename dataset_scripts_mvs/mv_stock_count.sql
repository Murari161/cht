CREATE MATERIALIZED VIEW cht.mv_stock_count
TABLESPACE ts_report
AS
SELECT
    doc ->> '_id'::text                              AS doc_id,
    doc ->> '_rev'::text                             AS rev,                                 -- [NEW FIELD]
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
    doc ->> 'from'::text                             AS  from,

    doc #>> '{fields,inputs,source}'::text[]                          AS source,
    doc #>> '{fields,inputs,source_id}'::text[]                       AS source_id,
    doc #>> '{fields,inputs,contact,_id}'::text[]                     AS contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[]                    AS contact_name,
    doc #>> '{fields,patient_id}'::text[]                              AS patient_id,
    doc #>> '{fields,act_item_received}'::text[]                       AS act_item_received,
    doc #>> '{fields,zinc_item_received}'::text[]                      AS zinc_item_received,
    doc #>> '{fields,amoxicillin_item_received}'::text[]               AS amoxicillin_item_received,
    doc #>> '{fields,malaria_rdts_item_received}'::text[]              AS malaria_rdts_item_received,
    doc #>> '{fields,pop_item_received}'::text[]                        AS pop_item_received,
    doc #>> '{fields,dmpa_item_received}'::text[]                       AS dmpa_item_received,
    doc #>> '{fields,misoprostol_item_received}'::text[]               AS misoprostol_item_received,
    doc #>> '{fields,coc_item_received}'::text[]                        AS coc_item_received,
    doc #>> '{fields,condoms_item_received}'::text[]                    AS condoms_item_received,
    doc #>> '{fields,contraceptives_item_received}'::text[]             AS contraceptives_item_received,
    doc #>> '{fields,rectal_item_received}'::text[]                      AS rectal_item_received,
    doc #>> '{fields,sayana_item_received}'::text[]                      AS sayana_item_received,
    doc #>> '{fields,gloves_item_received}'::text[]                      AS gloves_item_received,
    doc #>> '{fields,is_mch_instance}'::text[]                           AS is_mch_instance,

    doc #>> '{fields,items,commodities_note}'::text[]        AS commodities_note,
    doc #>> '{fields,items,act}'::text[]                      AS act,
    doc #>> '{fields,items,malaria_rdts}'::text[]             AS malaria_rdts,
    doc #>> '{fields,items,rectal}'::text[]                   AS rectal,
    doc #>> '{fields,items,gloves}'::text[]                   AS gloves,
    doc #>> '{fields,items,zinc}'::text[]                     AS zinc,
    doc #>> '{fields,items,amoxicillin}'::text[]              AS amoxicillin,
    doc #>> '{fields,items,pop}'::text[]                      AS pop,
    doc #>> '{fields,items,coc}'::text[]                      AS coc,
    doc #>> '{fields,items,contraceptives}'::text[]           AS contraceptives,
    doc #>> '{fields,items,dmpa}'::text[]                     AS dmpa,
    doc #>> '{fields,items,condoms}'::text[]                  AS condoms,

    doc #>> '{fields,summary,s_submit}'::text[]               AS s_submit,
    doc #>> '{fields,summary,r_summary}'::text[]             AS r_summary,
    doc #>> '{fields,summary,s_act}'::text[]                 AS s_act,
    doc #>> '{fields,summary,s_malaria_rdts}'::text[]        AS s_malaria_rdts,
    doc #>> '{fields,summary,s_rectal}'::text[]              AS s_rectal,
    doc #>> '{fields,summary,s_gloves}'::text[]              AS s_gloves,
    doc #>> '{fields,summary,s_zinc}'::text[]                AS s_zinc,
    doc #>> '{fields,summary,s_amoxicillin}'::text[]         AS s_amoxicillin,
    doc #>> '{fields,summary,s_pop}'::text[]                 AS s_pop,
    doc #>> '{fields,summary,s_coc}'::text[]                 AS s_coc,
    doc #>> '{fields,summary,s_contraceptives}'::text[]      AS s_contraceptives,
    doc #>> '{fields,summary,s_dmpa}'::text[]                AS s_dmpa,
    doc #>> '{fields,summary,s_condoms}'::text[]             AS s_condoms,

    --- reporting hierarchy
    doc #>> '{contact,_id}'                         AS chw_id,                   
    doc #>> '{contact,parent,_id}'                  AS chw_area_id,  
    doc #>> '{contact,parent,parent,_id}'           AS facility_id,                                    
    doc #>> '{contact,parent,parent,parent,_id}'    AS parish_id,              
    doc #>> '{contact,parent,parent,parent,parent,_id}'           AS district,                 
    doc #>> '{contact,parent,parent,parent,parent,parent,_id}'    AS region,
    CURRENT_TIMESTAMP                                 AS last_refresh_date


FROM dwh.cht_data AS couchdb
WHERE (doc ->> 'form') = 'stock_count'
  AND is_current
WITH DATA;

CREATE INDEX mv_stock_count_reported_idx
    ON cht.mv_stock_count USING btree (reported);
