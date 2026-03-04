-- cht.mv_vht_immunization source

CREATE MATERIALIZED VIEW cht.mv_vht_immunization
TABLESPACE pg_default
AS WITH params AS (
         SELECT '2024-01-01'::date AS start_date,
            '2025-10-15'::date AS end_date,
            'Ntungamo District'::text AS target_district
        ), vht AS (
         SELECT v.branch_uuid,
            v.branch_name,
            v.username,
            v.supervisor_uuid,
            v.area_uuid,
            v.uuid,
            v.name,
            v.phone,
            v.sex,
            v.date_of_birth,
            COALESCE(v.district, 'Undefined'::text) AS district,
            COALESCE(v.sub_district, 'Undefined'::text) AS sub_district,
            COALESCE(v.sub_county, 'Undefined'::text) AS sub_county,
            COALESCE(v.parish, 'Undefined'::text) AS parish,
            COALESCE(lower(TRIM(BOTH FROM v.village)), 'Undefined'::text) AS village,
            COALESCE(v.facility, 'Undefined'::text) AS facility,
            COALESCE(v.dhis2_facility_id, 'Undefined'::text) AS dhis2_facility_id,
            generate_series(date_trunc('month'::text, (( SELECT params.start_date
                   FROM params))::timestamp with time zone), date_trunc('month'::text, (( SELECT params.end_date
                   FROM params))::timestamp with time zone), '1 mon'::interval)::date AS period_date
           FROM report.contactview_vht v
             LEFT JOIN report.vht_latest_report vlr ON vlr.reported_by = v.uuid
          WHERE (v.active OR vlr.latest_reported_date >= (( SELECT params.start_date
                   FROM params))) AND v.reported > (( SELECT params.start_date
                   FROM params)) AND v.district = (( SELECT params.target_district
                   FROM params))
          GROUP BY v.branch_uuid, v.branch_name, v.supervisor_uuid, v.area_uuid, v.uuid, v.name, v.username, v.sex, v.date_of_birth, v.phone, v.district, v.sub_district, v.sub_county, v.parish, v.village, v.facility, v.dhis2_facility_id
        )
 SELECT CURRENT_TIMESTAMP AS last_refresh_date,
    vht.district,
    vht.sub_district,
    vht.sub_county,
    vht.parish,
    vht.facility,
    vht.village,
    vht.uuid,
    vht.username,
    vht.name,
    vht.period_date,
    count(DISTINCT imm.patient_id) AS total_patients,
    count(DISTINCT imm.patient_id) FILTER (WHERE imm.immunization_received ~~* '%dpt1%'::text) AS dpt1,
    count(DISTINCT imm.patient_id) FILTER (WHERE imm.immunization_received ~~* '%dpt3%'::text) AS dpt3,
    count(DISTINCT imm.patient_id) FILTER (WHERE imm.immunization_received ~~* '%mr1%'::text) AS mr1,
    count(DISTINCT imm.patient_id) FILTER (WHERE imm.immunization_received ~~* '%mr2%'::text) AS mr2,
    count(DISTINCT imm.patient_id) FILTER (WHERE imm.immunization_received = 'none'::text) AS "none",
    count(DISTINCT imm.patient_id) FILTER (WHERE imm.immunization_uptodate = 'yes'::text) AS immunizations_upto_date,
    count(DISTINCT imm.patient_id) FILTER (WHERE imm.immunization_uptodate = 'no'::text) AS immunizations_not_upto_date
   FROM report.useview_assessment imm
     JOIN vht ON vht.uuid = imm.reported_by AND imm.reported >= vht.period_date AND imm.reported < (vht.period_date + '1 mon'::interval)
  WHERE imm.immunization_received IS NOT NULL
  GROUP BY vht.district, vht.sub_district, vht.sub_county, vht.parish, vht.facility, vht.village, vht.period_date, vht.dhis2_facility_id, vht.name, vht.uuid, vht.username
WITH DATA;