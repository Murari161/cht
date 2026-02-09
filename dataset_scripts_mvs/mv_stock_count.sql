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
    (doc #>> '{fields,act_item_received}')::int                       AS act_item_received, --(int)
    (doc #>> '{fields,zinc_item_received}')::int                       AS zinc_item_received, --(int)
    (doc #>> '{fields,amoxicillin_item_received}')::int                  AS amoxicillin_item_received, --(int)
    (doc #>> '{fields,malaria_rdts_item_received}')::int                 AS malaria_rdts_item_received, --(int)
    (doc #>> '{fields,pop_item_received}')::int                           AS pop_item_received, --(int)
    (doc #>> '{fields,dmpa_item_received}')::int                          AS dmpa_item_received, --(int)
    (doc #>> '{fields,misoprostol_item_received}')::int                  AS misoprostol_item_received, --(int)
    (doc #>> '{fields,coc_item_received}')::int                           AS coc_item_received, --(int)
    (doc #>> '{fields,condoms_item_received}')::int                       AS condoms_item_received, --(int)
    (doc #>> '{fields,contraceptives_item_received}')::int                AS contraceptives_item_received, --(int)
    (doc #>> '{fields,rectal_item_received}')::int                         AS rectal_item_received, --(int)
    (doc #>> '{fields,sayana_item_received}')::int                         AS sayana_item_received, --(int)
    (doc #>> '{fields,gloves_item_received}')::int                         AS gloves_item_received, --(int)
    doc #>> '{fields,is_mch_instance}'::text[]                           AS is_mch_instance, --(true/false)

    doc #>> '{fields,items,commodities_note}'::text[]        AS commodities_note,
    (doc #>> '{fields,items,act}')::int                      AS act,
    (doc #>> '{fields,items,malaria_rdts}')::int              AS malaria_rdts,
    (doc #>> '{fields,items,rectal}')::int                    AS rectal,
    (doc #>> '{fields,items,gloves}')::int                    AS gloves,
    (doc #>> '{fields,items,zinc}')::int                      AS zinc,
    (doc #>> '{fields,items,amoxicillin}')::int               AS amoxicillin,
    (doc #>> '{fields,items,pop}')::int                      AS pop,
    (doc #>> '{fields,items,coc}')::int                      AS coc,
    (doc #>> '{fields,items,contraceptives}')::int            AS contraceptives,
    (doc #>> '{fields,items,dmpa}')::int                      AS dmpa,
    (doc #>> '{fields,items,condoms}')::int                   AS condoms,

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
