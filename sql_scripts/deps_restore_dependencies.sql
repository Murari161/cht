CREATE OR REPLACE FUNCTION cht.deps_restore_dependencies(p_view_schema name, p_view_name name)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare
  v_curr record;
begin
for v_curr in 
(
  select deps_ddl_to_run 
  from cht.deps_saved_ddl_temp
  where deps_view_schema = p_view_schema and deps_view_name = p_view_name
  order by deps_id desc
) loop
  execute v_curr.deps_ddl_to_run;
end loop;
delete from cht.deps_saved_ddl_temp
where deps_view_schema = p_view_schema and deps_view_name = p_view_name;
end;
$function$
;
