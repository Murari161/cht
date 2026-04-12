SELECT n.nspname AS schema_name, c.relname AS object_name,
CASE c.relkind
WHEN 'v' THEN 'view'
WHEN 'm' THEN 'materialized view'
WHEN 'r' THEN 'table'
WHEN 'i' THEN 'index'
ELSE c.relkind::text END AS object_type FROM pg_depend d
JOIN pg_rewrite r ON d.objid = r.oid
JOIN pg_class c ON r.ev_class = c.oid
JOIN pg_namespace n ON c.relnamespace = n.oid
WHERE d.refobjid = 'cht.mv_assessment'::regclass;


SELECT dependent_ns.nspname AS schema,
       dependent_view.relname AS view_name
FROM pg_depend
JOIN pg_rewrite ON pg_depend.objid = pg_rewrite.oid
JOIN pg_class dependent_view ON pg_rewrite.ev_class = dependent_view.oid
JOIN pg_namespace dependent_ns ON dependent_view.relnamespace = dependent_ns.oid
WHERE pg_depend.refobjid = 'cht.mv_assessment'::regclass;
