CREATE OR REPLACE FUNCTION cht.deps_save_ddl_for_objects_2(
    p_object_list text[]  
)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare
  v_schema name;
  v_name name;
  v_obj_fullname text;
begin
foreach v_obj_fullname in array p_object_list loop
    
    v_schema := split_part(v_obj_fullname, '.', 1)::name;
    v_name := split_part(v_obj_fullname, '.', 2)::name;
    
    if v_schema = '' or v_name = '' or split_part(v_obj_fullname, '.', 3) != '' then
        continue;
    end if;
    
    RAISE NOTICE 'Processing: %.%', v_schema, v_name;
    
    -- 1. MATERIALIZED VIEWS
    insert into cht.deps_saved_ddl(deps_view_schema, deps_view_name, deps_ddl_to_run)
    select v_schema, v_name, 
        'CREATE MATERIALIZED VIEW ' || quote_ident(schemaname) || '.' || quote_ident(matviewname) || ' AS ' || definition
    from pg_matviews
    where schemaname = v_schema and matviewname = v_name;
    
    -- 2. TABLES  
    insert into cht.deps_saved_ddl(deps_view_schema, deps_view_name, deps_ddl_to_run)
    select v_schema, v_name,
        'CREATE TABLE ' || quote_ident(table_schema) || '.' || quote_ident(table_name) || ' (' ||
        string_agg(
            quote_ident(column_name) || ' ' || data_type ||
            CASE 
                WHEN character_maximum_length IS NOT NULL THEN '(' || character_maximum_length || ')'
                WHEN numeric_precision IS NOT NULL THEN 
                    '(' || numeric_precision || 
                    CASE WHEN numeric_scale IS NOT NULL THEN ',' || numeric_scale ELSE '' END || ')'
                ELSE ''
            END ||
            CASE WHEN is_nullable = 'NO' THEN ' NOT NULL' ELSE '' END,
            ', '
            ORDER BY ordinal_position
        ) || ');'
    from information_schema.columns
    where table_schema = v_schema and table_name = v_name
    group by table_schema, table_name;
    
end loop;

RAISE NOTICE '✅ COMPLETED: Saved DDL for % objects', array_length(p_object_list, 1);
end;
$function$;