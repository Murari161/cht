CREATE OR REPLACE FUNCTION cht.deps_save_ddl_for_objects(
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
    
    -- 3. INDEXES (uses tablename)
    insert into cht.deps_saved_ddl(deps_view_schema, deps_view_name, deps_ddl_to_run)
    select distinct v_schema, v_name, indexdef
    from pg_indexes
    where schemaname = v_schema and tablename = v_name;
    
    -- 4. RULES (uses tablename)
    insert into cht.deps_saved_ddl(deps_view_schema, deps_view_name, deps_ddl_to_run)
    select distinct v_schema, v_name, definition
    from pg_rules
    where schemaname = v_schema and tablename = v_name;
    
    -- 5. OBJECT COMMENTS
    insert into cht.deps_saved_ddl(deps_view_schema, deps_view_name, deps_ddl_to_run)
    select v_schema, v_name, 'COMMENT ON ' ||
    case c.relkind
      when 'r' then 'TABLE'
      when 'm' then 'MATERIALIZED VIEW'
      when 'v' then 'VIEW'
    end
    || ' ' || quote_ident(n.nspname) || '.' || quote_ident(c.relname) || ' IS ''' || replace(d.description, '''', '''''') || ''';'
    from pg_class c
    join pg_namespace n on n.oid = c.relnamespace
    join pg_description d on d.objoid = c.oid and d.objsubid = 0
    where n.nspname = v_schema and c.relname = v_name and d.description is not null;
    
    -- 6. COLUMN COMMENTS
    insert into cht.deps_saved_ddl(deps_view_schema, deps_view_name, deps_ddl_to_run)
    select v_schema, v_name, 'COMMENT ON COLUMN ' || quote_ident(n.nspname) || '.' || quote_ident(c.relname) || '.' || quote_ident(a.attname) || ' IS ''' || replace(d.description, '''', '''''') || ''';'
    from pg_class c
    join pg_attribute a on c.oid = a.attrelid
    join pg_namespace n on n.oid = c.relnamespace
    join pg_description d on d.objoid = c.oid and d.objsubid = a.attnum
    where n.nspname = v_schema and c.relname = v_name and d.description is not null;
    
    -- 7. GRANTS
    insert into cht.deps_saved_ddl(deps_view_schema, deps_view_name, deps_ddl_to_run)
    select v_schema, v_name, 'GRANT ' || privilege_type || ' ON ' || table_schema || '.' || quote_ident(table_name) || ' TO ' || grantee
    from information_schema.role_table_grants
    where table_schema = v_schema and table_name = v_name;
    
end loop;

RAISE NOTICE '✅ COMPLETED: Saved DDL for % objects', array_length(p_object_list, 1);
end;
$function$;