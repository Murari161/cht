
---check dependencies

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
WHERE d.refobjid = 'public.useview_population_demographics'::regclass;



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
