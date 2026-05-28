# org_hierarchy

Materialized-view DDLs and sample contact documents for the CHT organizational hierarchy.

Each `mv_*.sql` script creates a materialized view in the `cht` schema by filtering `dwh.cht_data` on `contact_type` and `is_current`, flattening the nested `doc` JSON into typed columns, and indexing the common lookup keys. Each `cXX-*.json` file is a representative source document for the corresponding contact type, kept alongside the DDL as a reference for the JSON shape the view parses.

## Hierarchy

The CHT data model nests org units through the `parent` field. Levels, from top to bottom:

| Level | `contact_type`        | Sample doc                                              | Materialized view                  |
| ----- | --------------------- | ------------------------------------------------------- | ---------------------------------- |
| 1     | `c10-region`          | [c10-region.json](c10-region.json)                      | [mv_region.sql](mv_region.sql)             |
| 2     | `c20-district`        | [c20-district.json](c20-district.json)                  | [mv_district.sql](mv_district.sql)         |
| 3     | `c30-district_hospital` | [c30-district_hospital.json](c30-district_hospital.json) | [mv_facility.sql](mv_facility.sql)         |
| 4     | `c40-parish`          | [c40-parish.json](c40-parish.json)                      | [mv_parish.sql](mv_parish.sql)             |
| 5     | `c50-health_center`   | [c50-health_center.json](c50-health_center.json)        | [mv_health_center.sql](mv_health_center.sql) |
| 6     | `c60-clinic`          | [c60-clinic.json](c60-clinic.json)                      | [mv_household.sql](mv_household.sql)       |

Note the naming offset at the bottom two levels: `c30-district_hospital` documents back `mv_facility`, and `c60-clinic` documents back `mv_household`.

## View conventions

Every view exposes the same base set of columns derived from the source doc:

- `uuid` — `doc->>'_id'`
- `<level>_name` — `doc->>'name'` (e.g. `region_name`, `district_name`, `household_name`)
- `contact_type`, `type`
- `reported`, `date`, `year`, `month`, `monthname` — derived from `reported_date` (epoch ms)
- `imported_date`
- `meta_created_by`, `meta_created_by_place_uuid`, `meta_created_by_person_uuid` — from `doc->'meta'`
- `last_refresh_date` — `CURRENT_TIMESTAMP` at the time of refresh

Ancestor IDs are walked out of the nested `parent` chain via `#>>` paths. For example, `mv_household` carries `health_center_id`, `parish_id`, `facility_id`, `district_id`, and `region_id` so joins to higher levels do not require recursive lookups.

Level-specific extras:

- `mv_facility` — `dhis2_facility_id` from `external_id`
- `mv_health_center` — denormalized geo strings (`county`, `sub_county`, `village`, `parish`, `district`) plus `contact_id`
- `mv_household` — `muted`, `geolocation`, `contact_id`
- `mv_parish` — `notes`, `form_version_time`, `form_version_sha256`

## Storage and indexes

All views are created in tablespace `ts_report` with indexes in `ts_indexes`. Each view is indexed on `uuid`, its name column, every ancestor id it exposes, `reported`, and `(year, month)`.

## Refreshing

These views are refreshed by the project-level refresh script (`cht_mv_refresh.sh` at the repo root). To rebuild a single view from scratch, run its `mv_*.sql` directly — each script begins with `DROP MATERIALIZED VIEW IF EXISTS` so it is safe to re-run.
