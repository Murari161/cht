---period selector-----
    to_timestamp((NULLIF(doc ->> 'reported_date'::text, ''::text)::bigint / 1000)::double precision) AS reported,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY-MM-DD'))::date AS date,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY'))::INT AS year,
    to_char(to_timestamp((((doc ->>'reported_date'::text)::bigint) / 1000)::double precision), 'MM'::text)::integer AS month,
    TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'FMMonth') AS monthname,




----hierarchy selector---
 -- Last column for tracking refresh
      doc #>> '{contact,_id}'                         AS chw_id,
      h.facility_name,
      h.dhis2_facility_id,
      h.village,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date  
FROM dwh.cht_data d LEFT JOIN cht.mv_chw_hierarchy h ON (d.doc #>> '{contact,_id}') = h.chw_id 



--grant permissions------
GRANT UPDATE, TRUNCATE, TRIGGER, REFERENCES, INSERT, DELETE, SELECT ON TABLE cht.mv_delivery_report TO albert_fellow; 
GRANT UPDATE, TRUNCATE, TRIGGER, REFERENCES, INSERT, DELETE, SELECT ON TABLE cht.mv_delivery_report TO baker; 
GRANT UPDATE, TRUNCATE, TRIGGER, REFERENCES, INSERT, DELETE, SELECT ON TABLE cht.mv_delivery_report TO mkizito; 
GRANT UPDATE, TRUNCATE, TRIGGER, REFERENCES, INSERT, DELETE, SELECT ON TABLE cht.mv_delivery_report TO mpaul; 
GRANT UPDATE, TRUNCATE, TRIGGER, REFERENCES, INSERT, DELETE, SELECT ON TABLE cht.mv_delivery_report TO nmadrine; 
GRANT UPDATE, TRUNCATE, TRIGGER, REFERENCES, INSERT, DELETE, SELECT ON TABLE cht.mv_delivery_report TO rutayisire; 
GRANT UPDATE, TRUNCATE, TRIGGER, REFERENCES, INSERT, DELETE, SELECT ON TABLE cht.mv_delivery_report TO tom_fellow;