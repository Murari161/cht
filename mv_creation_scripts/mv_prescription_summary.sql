-- =============================================================================
-- cht.mv_cht_prescription_summary
-- CHT DISPENSING LEDGER — the "Quantity Dispensed" the CHT arm was missing.
--
-- *** THIS FILE MATCHES WHAT IS DEPLOYED. Keep them in sync. ***
--
-- prescription_summary is a CHILD doc (type = data_record) emitted by three parent
-- forms when a commodity is actually handed to a client:
--     assessment       1,299,775   (iCCM)
--     fp_registration    491,119   (FP)
--     fp_follow_up       319,204   (FP)
--     unresolved              90
--                     ----------
--                      2,110,188
--
-- Grain: ONE ROW PER DISPENSING EVENT.
--
-- ----------------------------------------------------------------------------
-- HOW THE PATIENT IS RESOLVED
--   The child doc carries NO patient — its contact._id is the CHW AREA (a place).
--   The only route is through the parent submission:
--
--     prescription_summary.created_by_doc  ->  parent doc _id
--                                          ->  parent.fields.patient_id  (a person)
--
--   created_by_doc resolves for 2,110,098 / 2,110,188 docs (99.996%), and sampled
--   patient_id values resolve to `type = person` 5,000/5,000. Genuine patient-level
--   linkage — unlike vht_consumption_log, where the same-named field is the VHT area.
--
--   CAVEAT: 81 fp_follow_up records point patient_id at a PLACE (62 c60-clinic,
--   19 c50-health_center) — forms filled against a facility. Exclude these before
--   publishing patient counts.
--
-- ----------------------------------------------------------------------------
-- GEOGRAPHY — two join paths, recorded in geo_join_path
--     'parent_chw' : parent.contact._id -> mv_chw_hierarchy.chw_id   (primary)
--     'child_area' : child.contact._id  -> mv_chw_hierarchy.vht_area_id (fallback)
--   Verified against sample data: the hierarchy resolves well.
--   NOTE the doc ALSO nests its own place chain, available without any join:
--     contact.parent.parent.parent._id        -> district  e.g. "mayuge"
--     contact.parent.parent.parent.parent._id -> region    e.g. "busoga"
--   Not currently selected, but it is the cheapest fallback if the joins ever miss.
--
-- ----------------------------------------------------------------------------
-- [P1] DO NOT REGRESS
--   Dispensing is NOT in vht_consumption_log. There, `patient_id` is a calculate of
--   inputs/contact/_id resolving to contact_type 'c50-health_center' (the VHT AREA)
--   for 100% of 89,599 rows; and the flat `*_item_received` fields are calculates of
--   the nested `items_received.*` inputs — the same number twice. Treating those as
--   two flows gave a perfect 1.00 dispensed/received ratio for every commodity,
--   which is how the error surfaced.
--
-- [P2] FORM VERSIONS — absent fields stay NULL, never 0.
--     act / amoxicillin / malaria_rdts   1,299,833
--     zinc / gloves / rectal             1,290,961   (8,872 fewer)
--     ors                                    8,880   (~= that gap)
--     coc / condoms / pop                  810,355
--     contraceptives / dmpa                806,210   (4,145 fewer)
--   Coalescing to 0 would fabricate zero-dispensing records on older versions.
--
-- [P3] QUANTITIES CAN BE FRACTIONAL — a real doc holds
--   "amoxicillin_given_iccm": "0.2". Unit of measure UNCONFIRMED (fraction of a
--   pack/tin?). Resolve with the programme team before comparing against OpenSRP
--   quantities or computing aAMC.
--
-- [P4] NOT DISPENSED IN CHT: misoprostol and sayana are hardcoded to 0 in every CHT
--   form. ORS is dispensed here but has NO receipt field in vht_consumption_log.
--
-- [P5] TEST-DATA CUTOFF: date >= 2023-01-01, consistent with the other CHT MVs.
--
-- [P6] PERFORMANCE: the parent lookup is a self-join on dwh.cht_data. Acceptable at
--   current volumes. If refresh time becomes a problem, cht.mv_cht_dispensing_parent_link
--   (slim, uniquely indexed bridge of the three parent forms) is a drop-in replacement
--   for the `p` join.
--
-- [P7] JOIN FAN-OUT — FIXED 2026-07-24. DO NOT JOIN mv_chw_hierarchy DIRECTLY.
--   mv_chw_hierarchy is keyed one-row-per-USER, so neither chw_id nor vht_area_id is
--   unique in it: 321 duplicate chw_id keys, 679 duplicate vht_area_id keys (several
--   CHWs share an area). Joining it raw inflated this MV from 2,030,326 distinct docs
--   to 2,150,189 rows — 119,863 duplicates (5.9%) — which double-counted every
--   dispensed quantity. Both joins now go through DISTINCT ON CTEs that collapse to
--   one row per key, preferring the most complete geography.
--
-- [P8] PLACE-PATIENTS — 81 live records (2025-2026, NOT 2022 test data) have
--   fp_follow_up.patient_id pointing at a place: 62 c60-clinic, 19 c50-health_center.
--   The date cutoff does NOT remove them and the count will grow. EXCLUDE them from
--   any patient count — a clinic is not a patient.
-- =============================================================================
DROP MATERIALIZED VIEW IF EXISTS cht.mv_cht_prescription_summary;
CREATE MATERIALIZED VIEW cht.mv_cht_prescription_summary
TABLESPACE ts_report
AS
WITH hier_chw AS (
    -- one row per chw_id                                                    [P7]
    SELECT DISTINCT ON (chw_id)
        chw_id, chw_name, role, county, sub_county, village,
        parish, facility, dhis2_facility_id, district, region
    FROM cht.mv_chw_hierarchy
    WHERE chw_id IS NOT NULL
    ORDER BY chw_id,
             (region IS NOT NULL) DESC, (district IS NOT NULL) DESC,
             (facility IS NOT NULL) DESC, (village IS NOT NULL) DESC,
             chw_name NULLS LAST
), hier_area AS (
    -- one row per vht_area_id                                               [P7]
    SELECT DISTINCT ON (vht_area_id)
        vht_area_id, chw_name, role, county, sub_county, village,
        parish, facility, dhis2_facility_id, district, region
    FROM cht.mv_chw_hierarchy
    WHERE vht_area_id IS NOT NULL
    ORDER BY vht_area_id,
             (region IS NOT NULL) DESC, (district IS NOT NULL) DESC,
             (facility IS NOT NULL) DESC, (village IS NOT NULL) DESC,
             chw_name NULLS LAST
)
SELECT d.doc ->> '_id'::text AS uuid,
    d.doc ->> 'form'::text AS form,
    d.doc ->> 'from'::text AS submitter,
    d.doc ->> 'created_by_doc'::text AS created_by_doc,
    d.doc ->> 'content_type'::text AS content_type,
    d.doc ->> 'supervisor'::text AS supervisor_id,
    d.doc ->> 'place_id'::text AS place_id,
    d.doc #>> '{contact,_id}'::text[] AS contact_id,
    d.doc #>> '{parent,_id}'::text[] AS branch_id,
    to_timestamp((NULLIF(d.doc ->> 'reported_date'::text, ''::text)::bigint / 1000)::double precision) AS reported,
    to_char(to_timestamp((((d.doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'YYYY-MM-DD'::text)::date AS date,
    to_char(to_timestamp((((d.doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'YYYY'::text)::integer AS year,
    to_char(to_timestamp((((d.doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'Q'::text)::integer AS quarter,
    to_char(to_timestamp((((d.doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'MM'::text)::integer AS month,
    to_char(to_timestamp((((d.doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'FMMonth'::text) AS monthname,
    to_char(to_timestamp((((d.doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'IW'::text)::integer AS week,
    p.doc ->> 'form'::text AS parent_form,
    p.doc #>> '{fields,patient_id}'::text[] AS patient_id,
    p.doc #>> '{contact,_id}'::text[] AS chw_id,
        CASE
            WHEN (d.doc #> '{fields}'::text[]) ? 'act_given_iccm'::text THEN 'iccm'::text
            WHEN (d.doc #> '{fields}'::text[]) ? 'coc_given_fp'::text THEN 'fp'::text
            ELSE 'other'::text
        END AS dispensing_context,
    cht.safe_numeric(d.doc #>> '{fields,act_given_iccm}'::text[]) AS act_given,
    cht.safe_numeric(d.doc #>> '{fields,amoxicillin_given_iccm}'::text[]) AS amoxicillin_given,
    cht.safe_numeric(d.doc #>> '{fields,malaria_rdts_given_iccm}'::text[]) AS malaria_rdts_given,
    cht.safe_numeric(d.doc #>> '{fields,zinc_given_iccm}'::text[]) AS zinc_given,
    cht.safe_numeric(d.doc #>> '{fields,gloves_given_iccm}'::text[]) AS gloves_given,
    cht.safe_numeric(d.doc #>> '{fields,rectal_given_iccm}'::text[]) AS rectal_given,
    cht.safe_numeric(d.doc #>> '{fields,ors_given_iccm}'::text[]) AS ors_given,
    cht.safe_numeric(d.doc #>> '{fields,coc_given_fp}'::text[]) AS coc_given,
    cht.safe_numeric(d.doc #>> '{fields,condoms_given_fp}'::text[]) AS condoms_given,
    cht.safe_numeric(d.doc #>> '{fields,pop_given_fp}'::text[]) AS pop_given,
    cht.safe_numeric(d.doc #>> '{fields,contraceptives_given_fp}'::text[]) AS contraceptives_given,
    cht.safe_numeric(d.doc #>> '{fields,dmpa_given_fp}'::text[]) AS dmpa_given,
    COALESCE(h.chw_name, hf.chw_name) AS chw_name,
    COALESCE(h.role, hf.role) AS role,
    COALESCE(h.region, hf.region) AS region,
    COALESCE(h.district, hf.district) AS district,
    COALESCE(h.county, hf.county) AS county,
    COALESCE(h.sub_county, hf.sub_county) AS sub_county,
    COALESCE(h.parish, hf.parish) AS parish,
    COALESCE(h.facility, hf.facility) AS facility,
    COALESCE(h.dhis2_facility_id, hf.dhis2_facility_id) AS dhis2_facility_id,
    COALESCE(h.village, hf.village) AS village,
        CASE
            WHEN h.chw_id IS NOT NULL THEN 'parent_chw'::text
            WHEN hf.vht_area_id IS NOT NULL THEN 'child_area'::text
            ELSE 'unresolved'::text
        END AS geo_join_path,
    'cht'::text AS source_system,
    CURRENT_TIMESTAMP AS last_refresh_date
   FROM dwh.cht_data d
     LEFT JOIN dwh.cht_data p ON (p.doc ->> '_id'::text) = (d.doc ->> 'created_by_doc'::text) AND p.is_current
     -- DISTINCT ON CTEs, never mv_chw_hierarchy directly — see [P7]
     LEFT JOIN hier_chw  h  ON h.chw_id = (p.doc #>> '{contact,_id}'::text[])
     LEFT JOIN hier_area hf ON hf.vht_area_id = (d.doc #>> '{contact,_id}'::text[])
  WHERE (d.doc ->> 'form'::text) = 'prescription_summary'::text AND d.is_current AND to_char(to_timestamp((((d.doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'YYYY-MM-DD'::text)::date >= '2023-01-01'::date
WITH DATA;

-- View indexes:
CREATE INDEX mv_cht_presc_summary_chw_idx ON cht.mv_cht_prescription_summary USING btree (chw_id);
CREATE INDEX mv_cht_presc_summary_date_idx ON cht.mv_cht_prescription_summary USING btree (date);
CREATE INDEX mv_cht_presc_summary_geo_idx ON cht.mv_cht_prescription_summary USING btree (district, sub_county, parish, village);
CREATE INDEX mv_cht_presc_summary_parent_idx ON cht.mv_cht_prescription_summary USING btree (parent_form);
CREATE INDEX mv_cht_presc_summary_patient_idx ON cht.mv_cht_prescription_summary USING btree (patient_id);
CREATE INDEX mv_cht_presc_summary_ym_dist_idx ON cht.mv_cht_prescription_summary USING btree (year, month, district);

-- =============================================================================
-- POST-BUILD VERIFICATION
--
-- V0. *** RUN FIRST *** No duplicates. GOOD: duplicates = 0.
--     Before the [P7] fix this returned 119,863.
--     SELECT COUNT(*) AS rows, COUNT(DISTINCT uuid) AS distinct_docs,
--            COUNT(*) - COUNT(DISTINCT uuid) AS duplicates
--     FROM cht.mv_cht_prescription_summary;
--
-- V1. Join hit-rates.
--     SELECT geo_join_path, COUNT(*) FROM cht.mv_cht_prescription_summary GROUP BY 1;
--     SELECT COUNT(*) AS rows, COUNT(patient_id) AS with_patient,
--            COUNT(DISTINCT patient_id) AS distinct_patients
--     FROM cht.mv_cht_prescription_summary;
--
-- V2. Parent mix (post-cutoff, so below the raw totals).
--     SELECT parent_form, dispensing_context, COUNT(*)
--     FROM cht.mv_cht_prescription_summary GROUP BY 1,2 ORDER BY 3 DESC;
--
-- V3. Commodity volumes — must NOT equal receipts exactly. Identical totals mean
--     the [P1] duplicate-field bug has returned.
--     SELECT SUM(act_given) act, SUM(amoxicillin_given) amox, SUM(zinc_given) zinc,
--            SUM(malaria_rdts_given) rdt, SUM(ors_given) ors, SUM(coc_given) coc
--     FROM cht.mv_cht_prescription_summary;
--
-- V4. How widespread is the [P3] fractional-unit question?
--     SELECT COUNT(*) FILTER (WHERE act_given         % 1 <> 0) AS act_frac,
--            COUNT(*) FILTER (WHERE amoxicillin_given % 1 <> 0) AS amox_frac,
--            COUNT(*) FILTER (WHERE zinc_given        % 1 <> 0) AS zinc_frac
--     FROM cht.mv_cht_prescription_summary;
-- =============================================================================
