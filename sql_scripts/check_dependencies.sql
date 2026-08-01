SELECT n.nspname AS schema_name, c.relname AS object_name, 
CASE c.relkind 
WHEN 'v' THEN 'view' 
WHEN 'm' THEN 'materialized view' 
WHEN 'r' THEN 'table' 
WHEN 'i' THEN 'index' 
ELSE c.relkind::text END AS object_type 
FROM pg_depend d 
JOIN pg_rewrite r ON d.objid = r.oid 
JOIN pg_class c ON r.ev_class = c.oid 
JOIN pg_namespace n ON c.relnamespace = n.oid 
WHERE d.refobjid = 'cht.mv_wash_report'::regclass;



--check status of long running query
SELECT pid, state, now() - query_start AS runtime, wait_event_type, wait_event 
FROM pg_stat_activity WHERE state != 'idle' ORDER BY query_start;

--check sequential scan reads
SELECT relname,
       seq_scan,
       seq_tup_read
FROM pg_stat_user_tables
ORDER BY seq_tup_read DESC
LIMIT 5;


SELECT DISTINCT
       n.nspname AS dep_schema,
       c.relname AS dep_object,
       CASE c.relkind
            WHEN 'v' THEN 'view'
            WHEN 'm' THEN 'materialized view'
            WHEN 'r' THEN 'table'
            WHEN 'i' THEN 'index'
            ELSE c.relkind::text
       END AS dep_type
FROM pg_depend     d
JOIN pg_rewrite    rw ON rw.oid = d.objid
JOIN pg_class      c  ON c.oid  = rw.ev_class
JOIN pg_namespace  n  ON n.oid  = c.relnamespace
WHERE d.refobjid = 'cht.mv_stock_count'::regclass   -- <-- change this
  AND d.deptype  = 'n'
  AND c.oid <> d.refobjid          -- exclude the MV's own internal rule
ORDER BY dep_schema, dep_object;




WITH RECURSIVE deps AS (
    SELECT rw.ev_class AS oid, 1 AS lvl
    FROM pg_depend d
    JOIN pg_rewrite rw ON rw.oid = d.objid
    WHERE d.refobjid = 'cht.mv_cebs_signal_report_vht'::regclass   -- <-- change this
      AND d.deptype = 'n' AND rw.ev_class <> d.refobjid
    UNION
    SELECT rw.ev_class, deps.lvl + 1
    FROM deps
    JOIN pg_depend d  ON d.refobjid = deps.oid AND d.deptype = 'n'
    JOIN pg_rewrite rw ON rw.oid = d.objid
    WHERE rw.ev_class <> deps.oid
)
SELECT max(lvl) AS depth,
       n.nspname AS dep_schema,
       c.relname AS dep_object,
       CASE c.relkind WHEN 'v' THEN 'view' WHEN 'm' THEN 'materialized view'
                      ELSE c.relkind::text END AS dep_type
FROM deps
JOIN pg_class c     ON c.oid = deps.oid
JOIN pg_namespace n ON n.oid = c.relnamespace
GROUP BY n.nspname, c.relname, c.relkind
ORDER BY depth;