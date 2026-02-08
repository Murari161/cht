CREATE OR REPLACE PROCEDURE refresh_materialized_views()
LANGUAGE plpgsql
AS $$
BEGIN
    -- =========================
    -- MV 1
    -- =========================
    BEGIN
        RAISE NOTICE 'Refreshing MV: mv_example_1';
        REFRESH MATERIALIZED VIEW dwh.mv_example_1;
        COMMIT;
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        RAISE WARNING 'Failed to refresh mv_example_1: %', SQLERRM;
    END;

    -- =========================
    -- MV 2
    -- =========================
    BEGIN
        RAISE NOTICE 'Refreshing MV: mv_example_2';
        REFRESH MATERIALIZED VIEW dwh.mv_example_2;
        COMMIT;
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        RAISE WARNING 'Failed to refresh mv_example_2: %', SQLERRM;
    END;

    -- =========================
    -- MV 3
    -- =========================
    BEGIN
        RAISE NOTICE 'Refreshing MV: mv_example_3';
        REFRESH MATERIALIZED VIEW dwh.mv_example_3;
        COMMIT;
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        RAISE WARNING 'Failed to refresh mv_example_3: %', SQLERRM;
    END;

END;
$$;
