CREATE OR REPLACE PROCEDURE deploy_all_cht_materialized_views()
LANGUAGE plpgsql
AS $$
BEGIN
    -- =========================
    -- MV 1
    -- =========================
    BEGIN
        RAISE NOTICE 'Creating MV: mv_example_1';

        EXECUTE $sql$
            CREATE MATERIALIZED VIEW IF NOT EXISTS dwh.mv_example_1
            AS
            SELECT ...
            WITH NO DATA
        $sql$;

        COMMIT;
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        RAISE WARNING 'Failed to create mv_example_1: %', SQLERRM;
    END;

    -- =========================
    -- MV 2
    -- =========================
    BEGIN
        RAISE NOTICE 'Creating MV: mv_example_2';

        EXECUTE $sql$
            CREATE MATERIALIZED VIEW IF NOT EXISTS dwh.mv_example_2
            AS
            SELECT ...
            WITH NO DATA
        $sql$;

        COMMIT;
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        RAISE WARNING 'Failed to create mv_example_2: %', SQLERRM;
    END;

    -- =========================
    -- MV 3
    -- =========================
    BEGIN
        RAISE NOTICE 'Creating MV: mv_example_3';

        EXECUTE $sql$
            CREATE MATERIALIZED VIEW IF NOT EXISTS dwh.mv_example_3
            AS
            SELECT ...
            WITH NO DATA
        $sql$;

        COMMIT;
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        RAISE WARNING 'Failed to create mv_example_3: %', SQLERRM;
    END;

    -- repeat for all 40+ MVs

END;
$$;
