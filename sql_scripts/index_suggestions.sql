-- Index suggestions for Community eCHIS / CHEWs dashboards
-- (community/echis-monthly-report, community/chews-performance-report)
--
-- Hand off to DBA / dev team. Validate against actual table definitions (column names,
-- data types) before applying. On production, prefer CREATE INDEX CONCURRENTLY and run
-- outside a transaction block.
--
-- Prerequisites:
--   PostgreSQL >= 11 required for the INCLUDE (covering index) syntax.
--   Run \d <table> to confirm column names before applying any block.
--
-- Rationale summary:
-- 1) mv_form_meta: time-filtered joins to hierarchy on contact_id + role; also
--    direct district filter (echis-monthly-report line ~132 applies district_filter
--    to mv_form_meta directly, not via join)
-- 2) mv_chew_hierarchy_2: district/role filters and DISTINCT ON (chw_id); covering
--    index eliminates heap fetches on the vht_base CTE which runs 6-7x per page load
-- 3) Form fact tables (assessment, screening, etc.): year/month filters + GROUP BY chw_id
-- 4) UNION / last-form-date paths: (chw_id, date) for aggregating max date per CHW
-- 5) report.cht_form_097c_with_vhts: ~10 components use this table; two filter patterns
--    exist (district+year+month for raw SQL, period_date for structured query path)
-- 6) report.cht_form_097c: used by Family Planning bar_line component

-- ---------------------------------------------------------------------------
-- cht.mv_form_meta — reporting joins and period filters
-- ---------------------------------------------------------------------------
-- Typical predicates: year, month, role = 'VHT' or IN ('CHEW','SUPER CHEW'), contact_id = ...
CREATE INDEX IF NOT EXISTS idx_mv_form_meta_contact_year_month_role
  ON cht.mv_form_meta (contact_id, year, month, role);

CREATE INDEX IF NOT EXISTS idx_mv_form_meta_year_month_role
  ON cht.mv_form_meta (year, month, role);

-- Direct district filter on mv_form_meta (e.g. "Work & interactions logged" KPI applies
-- district_filter directly to this table rather than via a join).
CREATE INDEX IF NOT EXISTS idx_mv_form_meta_district_year_month_role
  ON cht.mv_form_meta (district, year, month, role);

-- ---------------------------------------------------------------------------
-- cht.mv_chew_hierarchy_2 — denominators, DISTINCT ON (chw_id), district filter
-- ---------------------------------------------------------------------------
-- The vht_base CTE pattern runs in 6-7 parallel component queries per page load:
--   SELECT DISTINCT ON (chw_id) chw_id, facility_name, dhis2_facility_id, district
--   FROM cht.mv_chew_hierarchy_2
--   WHERE role = 'VHT' AND district = $1
--   ORDER BY chw_id, role
--
-- The covering index (INCLUDE) eliminates heap fetches for facility_name and
-- dhis2_facility_id. Drop the old non-covering index below once this is confirmed.
-- Requires PostgreSQL >= 11.
CREATE INDEX IF NOT EXISTS idx_mv_chew_hierarchy_2_role_district_chw_covering
  ON cht.mv_chew_hierarchy_2 (role, district, chw_id)
  INCLUDE (facility_name, dhis2_facility_id);

-- DROP the superseded non-covering index after verifying the covering one is used:
-- DROP INDEX CONCURRENTLY cht.idx_mv_chew_hierarchy_2_role_district_chw;

-- Keep this narrower index for queries that only need chw_id (no facility columns).
CREATE INDEX IF NOT EXISTS idx_mv_chew_hierarchy_2_chw_role
  ON cht.mv_chew_hierarchy_2 (chw_id, role);

-- ---------------------------------------------------------------------------
-- CHEW line list + inactive "last form date" sources
-- Adjust "month" if a table uses a different period column name.
-- ---------------------------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_mv_assessment_new_chw_year_month
  ON cht.mv_assessment_new (chw_id, year, month);

CREATE INDEX IF NOT EXISTS idx_mv_assessment_new_chw_date
  ON cht.mv_assessment_new (chw_id, date)
  WHERE date IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_mv_screening_chw_year_month
  ON cht.mv_screening (chw_id, year, month);

CREATE INDEX IF NOT EXISTS idx_mv_screening_chw_date
  ON cht.mv_screening (chw_id, date)
  WHERE date IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_mv_health_education_new_chw_year_month
  ON cht.mv_health_education_new (chw_id, year, month);

CREATE INDEX IF NOT EXISTS idx_mv_health_education_new_chw_date
  ON cht.mv_health_education_new (chw_id, date)
  WHERE date IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_mv_pregnancy_new_chw_year_month
  ON cht.mv_pregnancy_new (chw_id, year, month);

CREATE INDEX IF NOT EXISTS idx_mv_pregnancy_new_chw_date
  ON cht.mv_pregnancy_new (chw_id, date)
  WHERE date IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_mv_referral_follow_up_chw_year_month
  ON cht.mv_referral_follow_up (chw_id, year, month);

CREATE INDEX IF NOT EXISTS idx_mv_referral_follow_up_chw_date
  ON cht.mv_referral_follow_up (chw_id, date)
  WHERE date IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_mv_household_model_notification_chw_year_month
  ON cht.mv_household_model_notification (chw_id, year, month);

CREATE INDEX IF NOT EXISTS idx_mv_household_model_notification_chw_date
  ON cht.mv_household_model_notification (chw_id, date)
  WHERE date IS NOT NULL;

-- ---------------------------------------------------------------------------
-- cht.mv_chew_performance — district scorecards and choropleth
-- ---------------------------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_mv_chew_performance_district_year_month
  ON cht.mv_chew_performance (district, year, month);

-- ---------------------------------------------------------------------------
-- report.cht_form_097c_with_vhts — ~10 components in echis-monthly-report
-- ---------------------------------------------------------------------------
-- Confirm column names with: \d report.cht_form_097c_with_vhts
--
-- Two access patterns are present:
--   a) Raw SQL components (district overview, ICCM detail, nutrition choropleth,
--      maternal mortality): WHERE district = $1 AND year = $2 AND month = $3
--   b) Structured query components (RMNCH, mortality charts, FP bar_line):
--      WHERE period_date >= ... GROUP BY period_date or district
CREATE INDEX IF NOT EXISTS idx_cht_form_097c_vhts_district_year_month
  ON report.cht_form_097c_with_vhts (district, year, month);

CREATE INDEX IF NOT EXISTS idx_cht_form_097c_vhts_period_date_district
  ON report.cht_form_097c_with_vhts (period_date, district);

-- ---------------------------------------------------------------------------
-- report.cht_form_097c — Family Planning bar_line component
-- ---------------------------------------------------------------------------
-- Confirm column names with: \d report.cht_form_097c
CREATE INDEX IF NOT EXISTS idx_cht_form_097c_period_date_district
  ON report.cht_form_097c (period_date, district);

-- ---------------------------------------------------------------------------
-- cht.mv_vht_immunization — eCHIS monthly immunisation sections
-- ---------------------------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_mv_vht_immunization_district_period
  ON cht.mv_vht_immunization (district, period_date);

-- ---------------------------------------------------------------------------
-- MV refresh note for the DBA
-- ---------------------------------------------------------------------------
-- PostgreSQL rebuilds all indexes after each REFRESH MATERIALIZED VIEW. If mv_form_meta
-- or mv_chew_hierarchy_2 refreshes are slow after applying these indexes, profile with
-- EXPLAIN (ANALYZE, BUFFERS) on the refresh query and consider whether any of the
-- narrower indexes above can be dropped in favour of the covering ones.
