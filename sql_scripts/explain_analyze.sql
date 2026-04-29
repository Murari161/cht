-- ============================================
-- 🔥 RUN THIS BEFORE DROP+CREATE (Record Times)
-- ============================================

-- 1. cht.mv_form_meta (MOST CRITICAL - 10+ queries)
EXPLAIN (ANALYZE, BUFFERS) 
SELECT COUNT(*) FROM cht.mv_form_meta 
WHERE role='VHT' AND year=2025 AND month=3;

-- 2. cht.mv_chw_hierarchy (VHT lookup)
EXPLAIN (ANALYZE, BUFFERS) 
SELECT COUNT(*) FROM cht.mv_chw_hierarchy 
WHERE role='VHT' AND district='Kampala';

-- 3. report.cht_form_097c_with_vhts (District 097c)
EXPLAIN (ANALYZE, BUFFERS) 
SELECT COUNT(*) FROM report.cht_form_097c_with_vhts 
WHERE district='Kampala' AND year=2025 AND month=3;

-- 4. cht.mv_vht_immunization (Immunization)
EXPLAIN (ANALYZE, BUFFERS) 
SELECT SUM(total_patients) FROM cht.mv_vht_immunization 
WHERE year=2025 AND month=3;

-- ============================================
-- 🚀 NOW RUN YOUR DROP+CREATE SCRIPT
-- ============================================

-- ============================================
-- 🔥 RUN THIS AFTER (Should be 10x FASTER!)
-- ============================================

-- 1. cht.mv_form_meta 
EXPLAIN (ANALYZE, BUFFERS) 
SELECT COUNT(*) FROM cht.mv_form_meta 
WHERE role='VHT' AND year=2025 AND month=3;

-- 2. cht.mv_chw_hierarchy
EXPLAIN (ANALYZE, BUFFERS) 
SELECT COUNT(*) FROM cht.mv_chw_hierarchy 
WHERE role='VHT' AND district='Kampala';

-- 3. report.cht_form_097c_with_vhts
EXPLAIN (ANALYZE, BUFFERS) 
SELECT COUNT(*) FROM report.cht_form_097c_with_vhts 
WHERE district='Kampala' AND year=2025 AND month=3;

-- 4. cht.mv_vht_immunization
EXPLAIN (ANALYZE, BUFFERS) 
SELECT SUM(total_patients) FROM cht.mv_vht_immunization 
WHERE year=2025 AND month=3;

-- BONUS: Real dashboard query simulation
EXPLAIN (ANALYZE, BUFFERS) 
SELECT COUNT(DISTINCT m.contact_id) 
FROM cht.mv_form_meta m 
INNER JOIN cht.mv_chw_hierarchy h ON m.contact_id = h.chw_id
WHERE m.role='VHT' AND h.role='VHT' AND m.year=2025 AND m.month=3;

--BEFORE
--result 1:
Finalize Aggregate  (cost=773661.56..773661.57 rows=1 width=8) (actual time=1324.275..1420.351 rows=1 loops=1)
  Buffers: shared hit=478069
  ->  Gather  (cost=773660.83..773661.54 rows=7 width=8) (actual time=1321.784..1420.336 rows=8 loops=1)
        Workers Planned: 7
        Workers Launched: 7
        Buffers: shared hit=478069
        ->  Partial Aggregate  (cost=772660.83..772660.84 rows=1 width=8) (actual time=1291.874..1291.875 rows=1 loops=8)
              Buffers: shared hit=478069
              ->  Parallel Bitmap Heap Scan on mv_form_meta  (cost=16542.36..772434.10 rows=90691 width=0) (actual time=547.442..1288.344 rows=49355 loops=8)
                    Recheck Cond: (month = 3)
                    Filter: ((role = 'VHT'::text) AND (year = 2025))
                    Rows Removed by Filter: 138120
                    Heap Blocks: exact=74924
                    Buffers: shared hit=478069
                    ->  Bitmap Index Scan on idx_form_meta_month  (cost=0.00..16383.65 rows=1505496 width=0) (actual time=242.735..242.735 rows=1499801 loops=1)
                          Index Cond: (month = 3)
                          Buffers: shared hit=1265
Planning Time: 0.211 ms
JIT:
  Functions: 58
  Options: Inlining true, Optimization true, Expressions true, Deforming true
  Timing: Generation 6.068 ms, Inlining 534.285 ms, Optimization 469.807 ms, Emission 283.543 ms, Total 1293.703 ms
Execution Time: 1421.765 ms


--result 2:
Aggregate  (cost=2677.34..2677.35 rows=1 width=8) (actual time=12.230..12.231 rows=1 loops=1)
  Buffers: shared hit=2048
  ->  Seq Scan on mv_chw_hierarchy  (cost=0.00..2677.34 rows=1 width=0) (actual time=12.224..12.225 rows=0 loops=1)
        Filter: ((role = 'VHT'::text) AND (district = 'Kampala'::text))
        Rows Removed by Filter: 41956
        Buffers: shared hit=2048
Planning:
  Buffers: shared hit=31
Planning Time: 0.280 ms
Execution Time: 12.258 ms


--result 3:
Aggregate  (cost=8.45..8.46 rows=1 width=8) (actual time=0.676..0.677 rows=1 loops=1)
  Buffers: shared hit=2 read=1
  ->  Index Scan using cht_form_097c_with_vhts_district_idx on cht_form_097c_with_vhts  (cost=0.42..8.44 rows=1 width=0) (actual time=0.674..0.674 rows=0 loops=1)
        Index Cond: (district = 'Kampala'::text)
        Filter: ((year = 2025) AND (month = 3))
        Buffers: shared hit=2 read=1
Planning:
  Buffers: shared hit=138
Planning Time: 0.563 ms
Execution Time: 0.737 ms

--result 4:
Finalize Aggregate  (cost=14683.33..14683.34 rows=1 width=32) (actual time=57.306..69.671 rows=1 loops=1)
  Buffers: shared hit=12416
  ->  Gather  (cost=14683.00..14683.31 rows=3 width=32) (actual time=57.217..69.661 rows=4 loops=1)
        Workers Planned: 3
        Workers Launched: 3
        Buffers: shared hit=12416
        ->  Partial Aggregate  (cost=13683.00..13683.01 rows=1 width=32) (actual time=37.840..37.841 rows=1 loops=4)
              Buffers: shared hit=12416
              ->  Parallel Seq Scan on mv_vht_immunization  (cost=0.00..13674.26 rows=3494 width=8) (actual time=0.134..37.643 rows=2307 loops=4)
                    Filter: ((year = '2025'::numeric) AND (month = '3'::numeric))
                    Rows Removed by Filter: 62703
                    Buffers: shared hit=12416
Planning:
  Buffers: shared hit=38
Planning Time: 0.168 ms
Execution Time: 69.698 ms


--AFTER
--result 1:
Finalize Aggregate  (cost=14229.52..14229.53 rows=1 width=8) (actual time=40.019..45.864 rows=1 loops=1)
  Buffers: shared hit=88251
  ->  Gather  (cost=14229.20..14229.51 rows=3 width=8) (actual time=39.944..45.854 rows=4 loops=1)
        Workers Planned: 3
        Workers Launched: 3
        Buffers: shared hit=88251
        ->  Partial Aggregate  (cost=13229.20..13229.21 rows=1 width=8) (actual time=20.705..20.706 rows=1 loops=4)
              Buffers: shared hit=88251
              ->  Parallel Index Only Scan using idx_mv_form_meta_vht_period on mv_form_meta  (cost=0.56..12727.04 rows=200865 width=0) (actual time=0.090..15.678 rows=98710 loops=4)
                    Index Cond: ((role = 'VHT'::text) AND (year = 2025) AND (month = 3))
                    Heap Fetches: 0
                    Buffers: shared hit=88251
Planning:
  Buffers: shared hit=79
Planning Time: 0.444 ms
Execution Time: 45.907 ms


--result 2:
Aggregate  (cost=6.89..6.90 rows=1 width=8) (actual time=0.051..0.052 rows=1 loops=1)
  Buffers: shared hit=3
  ->  Index Only Scan using idx_mv_chw_hierarchy_vht_lookup on mv_chw_hierarchy  (cost=0.41..6.89 rows=1 width=0) (actual time=0.050..0.050 rows=0 loops=1)
        Index Cond: ((role = 'VHT'::text) AND (district = 'Kampala'::text))
        Heap Fetches: 0
        Buffers: shared hit=3
Planning:
  Buffers: shared hit=66
Planning Time: 0.306 ms
Execution Time: 0.072 ms


--result 3:
Aggregate  (cost=8.45..8.46 rows=1 width=8) (actual time=0.017..0.018 rows=1 loops=1)
  Buffers: shared hit=3
  ->  Index Scan using cht_form_097c_with_vhts_district_idx on cht_form_097c_with_vhts  (cost=0.42..8.44 rows=1 width=0) (actual time=0.016..0.016 rows=0 loops=1)
        Index Cond: (district = 'Kampala'::text)
        Filter: ((year = 2025) AND (month = 3))
        Buffers: shared hit=3
Planning Time: 0.091 ms
Execution Time: 0.040 ms


--result 4:
Finalize Aggregate  (cost=14683.36..14683.37 rows=1 width=32) (actual time=54.887..67.791 rows=1 loops=1)
  Buffers: shared hit=12416
  ->  Gather  (cost=14683.03..14683.34 rows=3 width=32) (actual time=54.783..67.779 rows=4 loops=1)
        Workers Planned: 3
        Workers Launched: 3
        Buffers: shared hit=12416
        ->  Partial Aggregate  (cost=13683.03..13683.04 rows=1 width=32) (actual time=37.392..37.393 rows=1 loops=4)
              Buffers: shared hit=12416
              ->  Parallel Seq Scan on mv_vht_immunization  (cost=0.00..13674.26 rows=3507 width=8) (actual time=0.160..37.167 rows=2307 loops=4)
                    Filter: ((year = '2025'::numeric) AND (month = '3'::numeric))
                    Rows Removed by Filter: 62703
                    Buffers: shared hit=12416
Planning:
  Buffers: shared hit=47
Planning Time: 0.205 ms
Execution Time: 67.820 ms