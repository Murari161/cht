-- cht.mv_integrated_echis_performance source

CREATE MATERIALIZED VIEW cht.mv_integrated_echis_performance
TABLESPACE ts_report
AS WITH registration_totals AS (
         SELECT mv_chew_hierarchy_2.region,
            mv_chew_hierarchy_2.district,
            COALESCE(count(DISTINCT
                CASE
                    WHEN mv_chew_hierarchy_2.role = ANY (ARRAY['VHT'::text, 'SUPER CHEW'::text]) THEN mv_chew_hierarchy_2.chw_id
                    ELSE NULL::text
                END), 0::bigint) AS number_vhts_registered,
            COALESCE(count(DISTINCT
                CASE
                    WHEN mv_chew_hierarchy_2.role = ANY (ARRAY['CHEW'::text, 'SUPER CHEW'::text]) THEN mv_chew_hierarchy_2.chw_id
                    ELSE NULL::text
                END), 0::bigint) AS number_chews_registered
           FROM cht.mv_chew_hierarchy_2
          GROUP BY mv_chew_hierarchy_2.region, mv_chew_hierarchy_2.district
        ), reporting_activity AS (
         SELECT hh.region,
            hh.district,
            mv_form_meta.year,
            mv_form_meta.monthname,
            mv_form_meta.month,
            COALESCE(count(DISTINCT
                CASE
                    WHEN hh.role = ANY (ARRAY['VHT'::text, 'SUPER CHEW'::text]) THEN mv_form_meta.contact_id
                    ELSE NULL::text
                END), 0::bigint) AS number_vhts_reported,
            COALESCE(count(DISTINCT
                CASE
                    WHEN hh.role = ANY (ARRAY['CHEW'::text, 'SUPER CHEW'::text]) THEN mv_form_meta.contact_id
                    ELSE NULL::text
                END), 0::bigint) AS number_chews_reported
           FROM cht.mv_form_meta
             LEFT JOIN cht.mv_chew_hierarchy_2 hh ON mv_form_meta.contact_id = hh.chw_id
          WHERE hh.region IS NOT NULL OR hh.district IS NOT NULL
          GROUP BY hh.region, hh.district, mv_form_meta.year, mv_form_meta.monthname, mv_form_meta.month
        ), hh_reg_visit AS (
         WITH hh_registration AS (
                 SELECT initcap(replace(mv_households.region, '_'::text, ' '::text)) AS region,
                        CASE
                            WHEN replace(mv_households.district, '_'::text, ' '::text) ~~* '%city%'::text THEN initcap(replace(mv_households.district, '_'::text, ' '::text))
                            ELSE concat(initcap(replace(mv_households.district, '_'::text, ' '::text)), ' District')
                        END AS district,
                    EXTRACT(year FROM mv_households.reported_at::date)::integer AS year,
                    TRIM(BOTH FROM to_char(mv_households.reported_at::date::timestamp with time zone, 'Month'::text)) AS monthname,
                    EXTRACT(month FROM mv_households.reported_at::date)::integer AS month,
                    count(DISTINCT mv_households.contact_id) AS number_hh_registered
                   FROM cht.mv_households
                  WHERE mv_households.region IS NOT NULL OR mv_households.district IS NOT NULL
                  GROUP BY (initcap(replace(mv_households.region, '_'::text, ' '::text))), (
                        CASE
                            WHEN replace(mv_households.district, '_'::text, ' '::text) ~~* '%city%'::text THEN initcap(replace(mv_households.district, '_'::text, ' '::text))
                            ELSE concat(initcap(replace(mv_households.district, '_'::text, ' '::text)), ' District')
                        END), (EXTRACT(year FROM mv_households.reported_at::date)::integer), (TRIM(BOTH FROM to_char(mv_households.reported_at::date::timestamp with time zone, 'Month'::text))), (EXTRACT(month FROM mv_households.reported_at::date)::integer)
                ), hh_visited AS (
                 SELECT initcap(replace(
                        CASE
                            WHEN mv_household_model_follow_up_new.region_id IS NULL THEN mv_household_model_follow_up_new.district_id
                            ELSE mv_household_model_follow_up_new.region_id
                        END, '_'::text, ' '::text)) AS region,
                        CASE
                            WHEN replace(
                            CASE
                                WHEN mv_household_model_follow_up_new.region_id IS NULL THEN mv_household_model_follow_up_new.parish_id
                                ELSE mv_household_model_follow_up_new.district_id
                            END, '_'::text, ' '::text) ~~* '%city%'::text THEN initcap(replace(
                            CASE
                                WHEN mv_household_model_follow_up_new.region_id IS NULL THEN mv_household_model_follow_up_new.parish_id
                                ELSE mv_household_model_follow_up_new.district_id
                            END, '_'::text, ' '::text))
                            ELSE concat(initcap(replace(
                            CASE
                                WHEN mv_household_model_follow_up_new.region_id IS NULL THEN mv_household_model_follow_up_new.parish_id
                                ELSE mv_household_model_follow_up_new.district_id
                            END, '_'::text, ' '::text)), ' District')
                        END AS district,
                    mv_household_model_follow_up_new.year,
                    mv_household_model_follow_up_new.month AS monthname,
                    EXTRACT(month FROM mv_household_model_follow_up_new.reported::date)::integer AS month,
                    count(DISTINCT mv_household_model_follow_up_new.inputs_contact_id) AS number_hh_visited
                   FROM cht.mv_household_model_follow_up_new
                  GROUP BY (initcap(replace(
                        CASE
                            WHEN mv_household_model_follow_up_new.region_id IS NULL THEN mv_household_model_follow_up_new.district_id
                            ELSE mv_household_model_follow_up_new.region_id
                        END, '_'::text, ' '::text))), (
                        CASE
                            WHEN replace(
                            CASE
                                WHEN mv_household_model_follow_up_new.region_id IS NULL THEN mv_household_model_follow_up_new.parish_id
                                ELSE mv_household_model_follow_up_new.district_id
                            END, '_'::text, ' '::text) ~~* '%city%'::text THEN initcap(replace(
                            CASE
                                WHEN mv_household_model_follow_up_new.region_id IS NULL THEN mv_household_model_follow_up_new.parish_id
                                ELSE mv_household_model_follow_up_new.district_id
                            END, '_'::text, ' '::text))
                            ELSE concat(initcap(replace(
                            CASE
                                WHEN mv_household_model_follow_up_new.region_id IS NULL THEN mv_household_model_follow_up_new.parish_id
                                ELSE mv_household_model_follow_up_new.district_id
                            END, '_'::text, ' '::text)), ' District')
                        END), mv_household_model_follow_up_new.year, mv_household_model_follow_up_new.month, (EXTRACT(month FROM mv_household_model_follow_up_new.reported::date)::integer)
                )
         SELECT COALESCE(hr.region, hv.region) AS region,
            COALESCE(hr.district, hv.district) AS district,
            COALESCE(hr.year, hv.year) AS year,
            COALESCE(hr.monthname, hv.monthname) AS monthname,
            COALESCE(hr.month, hv.month) AS month,
            COALESCE(hr.number_hh_registered, 0::bigint) AS number_hh_registered,
            COALESCE(hv.number_hh_visited, 0::bigint) AS number_hh_visited
           FROM hh_registration hr
             FULL JOIN hh_visited hv ON hr.region = hv.region AND hr.district = hv.district AND hr.year = hv.year AND hr.month = hv.month
          ORDER BY (COALESCE(hr.year, hv.year)), (COALESCE(hr.month, hv.month)), (COALESCE(hr.district, hv.district)), (COALESCE(hr.region, hv.region))
        ), individual_registration AS (
         SELECT initcap(replace(
                CASE
                    WHEN mv_person.region IS NULL THEN mv_person.district
                    WHEN mv_person.region IS NULL AND mv_person.district IS NULL THEN mv_person.facility_id
                    WHEN mv_person.region IS NULL AND mv_person.district IS NULL AND mv_person.facility_id IS NULL THEN mv_person.vht_area_id
                    WHEN mv_person.region IS NULL AND mv_person.district IS NULL AND mv_person.facility_id IS NULL AND mv_person.vht_area_id IS NULL THEN mv_person.vht_id
                    ELSE mv_person.region
                END, '_'::text, ' '::text)) AS region,
                CASE
                    WHEN replace(
                    CASE
                        WHEN mv_person.region IS NULL AND mv_person.district IS NULL THEN mv_person.vht_area_id
                        WHEN mv_person.region IS NULL AND mv_person.district IS NULL AND mv_person.facility_id IS NULL THEN mv_person.vht_id
                        WHEN mv_person.region IS NULL AND mv_person.district IS NULL AND mv_person.facility_id IS NULL AND mv_person.vht_area_id IS NULL THEN mv_person.household_id_2
                        ELSE mv_person.district
                    END, '_'::text, ' '::text) ~~* '%city%'::text THEN initcap(replace(
                    CASE
                        WHEN mv_person.region IS NULL AND mv_person.district IS NULL THEN mv_person.vht_area_id
                        WHEN mv_person.region IS NULL AND mv_person.district IS NULL AND mv_person.facility_id IS NULL THEN mv_person.vht_id
                        WHEN mv_person.region IS NULL AND mv_person.district IS NULL AND mv_person.facility_id IS NULL AND mv_person.vht_area_id IS NULL THEN mv_person.household_id_2
                        ELSE mv_person.district
                    END, '_'::text, ' '::text))
                    ELSE concat(initcap(replace(
                    CASE
                        WHEN mv_person.region IS NULL AND mv_person.district IS NULL THEN mv_person.vht_area_id
                        WHEN mv_person.region IS NULL AND mv_person.district IS NULL AND mv_person.facility_id IS NULL THEN mv_person.vht_id
                        WHEN mv_person.region IS NULL AND mv_person.district IS NULL AND mv_person.facility_id IS NULL AND mv_person.vht_area_id IS NULL THEN mv_person.household_id_2
                        ELSE mv_person.district
                    END, '_'::text, ' '::text)), ' District')
                END AS district,
            mv_person.year,
            mv_person.month AS monthname,
            EXTRACT(month FROM mv_person.reported::date)::integer AS month,
            COALESCE(count(DISTINCT mv_person.name), 0::bigint) AS number_individuals_registered,
            COALESCE(count(DISTINCT
                CASE
                    WHEN COALESCE(mv_person.age_years::numeric, mv_person.current_age::numeric) < 6::numeric THEN mv_person.name
                    ELSE NULL::text
                END), 0::bigint) AS number_children_registered
           FROM cht.mv_person
          WHERE mv_person.region IS NOT NULL AND mv_person.district IS NOT NULL AND mv_person.facility_id IS NOT NULL AND mv_person.vht_area_id IS NOT NULL
          GROUP BY (initcap(replace(
                CASE
                    WHEN mv_person.region IS NULL THEN mv_person.district
                    WHEN mv_person.region IS NULL AND mv_person.district IS NULL THEN mv_person.facility_id
                    WHEN mv_person.region IS NULL AND mv_person.district IS NULL AND mv_person.facility_id IS NULL THEN mv_person.vht_area_id
                    WHEN mv_person.region IS NULL AND mv_person.district IS NULL AND mv_person.facility_id IS NULL AND mv_person.vht_area_id IS NULL THEN mv_person.vht_id
                    ELSE mv_person.region
                END, '_'::text, ' '::text))), (
                CASE
                    WHEN replace(
                    CASE
                        WHEN mv_person.region IS NULL AND mv_person.district IS NULL THEN mv_person.vht_area_id
                        WHEN mv_person.region IS NULL AND mv_person.district IS NULL AND mv_person.facility_id IS NULL THEN mv_person.vht_id
                        WHEN mv_person.region IS NULL AND mv_person.district IS NULL AND mv_person.facility_id IS NULL AND mv_person.vht_area_id IS NULL THEN mv_person.household_id_2
                        ELSE mv_person.district
                    END, '_'::text, ' '::text) ~~* '%city%'::text THEN initcap(replace(
                    CASE
                        WHEN mv_person.region IS NULL AND mv_person.district IS NULL THEN mv_person.vht_area_id
                        WHEN mv_person.region IS NULL AND mv_person.district IS NULL AND mv_person.facility_id IS NULL THEN mv_person.vht_id
                        WHEN mv_person.region IS NULL AND mv_person.district IS NULL AND mv_person.facility_id IS NULL AND mv_person.vht_area_id IS NULL THEN mv_person.household_id_2
                        ELSE mv_person.district
                    END, '_'::text, ' '::text))
                    ELSE concat(initcap(replace(
                    CASE
                        WHEN mv_person.region IS NULL AND mv_person.district IS NULL THEN mv_person.vht_area_id
                        WHEN mv_person.region IS NULL AND mv_person.district IS NULL AND mv_person.facility_id IS NULL THEN mv_person.vht_id
                        WHEN mv_person.region IS NULL AND mv_person.district IS NULL AND mv_person.facility_id IS NULL AND mv_person.vht_area_id IS NULL THEN mv_person.household_id_2
                        ELSE mv_person.district
                    END, '_'::text, ' '::text)), ' District')
                END), mv_person.year, mv_person.month, (EXTRACT(month FROM mv_person.reported::date)::integer)
        ), child_engagement AS (
         SELECT initcap(replace(
                CASE
                    WHEN mv_assessment_new.region_id IS NULL THEN mv_assessment_new.district_id
                    ELSE mv_assessment_new.region_id
                END, '_'::text, ' '::text)) AS region,
                CASE
                    WHEN replace(
                    CASE
                        WHEN mv_assessment_new.region_id IS NULL THEN mv_assessment_new.parish_id
                        ELSE mv_assessment_new.district_id
                    END, '_'::text, ' '::text) ~~* '%city%'::text THEN initcap(replace(
                    CASE
                        WHEN mv_assessment_new.region_id IS NULL THEN mv_assessment_new.parish_id
                        ELSE mv_assessment_new.district_id
                    END, '_'::text, ' '::text))
                    ELSE concat(initcap(replace(
                    CASE
                        WHEN mv_assessment_new.region_id IS NULL THEN mv_assessment_new.parish_id
                        ELSE mv_assessment_new.district_id
                    END, '_'::text, ' '::text)), ' District')
                END AS district,
            mv_assessment_new.year,
            mv_assessment_new.month AS monthname,
            EXTRACT(month FROM mv_assessment_new.reported::date)::integer AS month,
            COALESCE(count(DISTINCT mv_assessment_new.patient_id), 0::bigint) AS number_children_engaged
           FROM cht.mv_assessment_new
          WHERE
                CASE
                    WHEN mv_assessment_new.patient_age_in_years ~ '^[0-9]+$'::text THEN mv_assessment_new.patient_age_in_years::integer
                    ELSE 0
                END < 6 AND
                CASE
                    WHEN mv_assessment_new.region_id IS NULL THEN mv_assessment_new.district_id
                    ELSE mv_assessment_new.region_id
                END IS NOT NULL
          GROUP BY (initcap(replace(
                CASE
                    WHEN mv_assessment_new.region_id IS NULL THEN mv_assessment_new.district_id
                    ELSE mv_assessment_new.region_id
                END, '_'::text, ' '::text))), (
                CASE
                    WHEN replace(
                    CASE
                        WHEN mv_assessment_new.region_id IS NULL THEN mv_assessment_new.parish_id
                        ELSE mv_assessment_new.district_id
                    END, '_'::text, ' '::text) ~~* '%city%'::text THEN initcap(replace(
                    CASE
                        WHEN mv_assessment_new.region_id IS NULL THEN mv_assessment_new.parish_id
                        ELSE mv_assessment_new.district_id
                    END, '_'::text, ' '::text))
                    ELSE concat(initcap(replace(
                    CASE
                        WHEN mv_assessment_new.region_id IS NULL THEN mv_assessment_new.parish_id
                        ELSE mv_assessment_new.district_id
                    END, '_'::text, ' '::text)), ' District')
                END), mv_assessment_new.year, mv_assessment_new.month, (EXTRACT(month FROM mv_assessment_new.reported::date)::integer)
        ), all_screened AS (
         SELECT initcap(replace(
                CASE
                    WHEN mv_screening.region_id IS NULL THEN mv_screening.district_id
                    ELSE mv_screening.region_id
                END, '_'::text, ' '::text)) AS region,
                CASE
                    WHEN replace(
                    CASE
                        WHEN mv_screening.region_id IS NULL THEN mv_screening.parish_id
                        ELSE mv_screening.district_id
                    END, '_'::text, ' '::text) ~~* '%city%'::text THEN initcap(replace(
                    CASE
                        WHEN mv_screening.region_id IS NULL THEN mv_screening.parish_id
                        ELSE mv_screening.district_id
                    END, '_'::text, ' '::text))
                    ELSE concat(initcap(replace(
                    CASE
                        WHEN mv_screening.region_id IS NULL THEN mv_screening.parish_id
                        ELSE mv_screening.district_id
                    END, '_'::text, ' '::text)), ' District')
                END AS district,
            mv_screening.year,
            mv_screening.month AS monthname,
            EXTRACT(month FROM mv_screening.reported::date)::integer AS month,
            COALESCE(count(DISTINCT mv_screening.patient_id), 0::bigint) AS number_individuals_screened,
            COALESCE(count(DISTINCT
                CASE
                    WHEN mv_screening.p_referred_to_health_facility_anc = 'yes'::text OR mv_screening.referred_for_fp_services = 'yes'::text OR mv_screening.referred_for_pregnancy_test = 'yes'::text THEN mv_screening.patient_id
                    ELSE NULL::text
                END), 0::bigint) AS number_individuals_referred,
            count(DISTINCT
                CASE
                    WHEN mv_screening.counseled_on_fp_methods = 'yes'::text THEN mv_screening.patient_id
                    ELSE NULL::text
                END) AS number_individuals_counselled_for_fp
           FROM cht.mv_screening
          GROUP BY (initcap(replace(
                CASE
                    WHEN mv_screening.region_id IS NULL THEN mv_screening.district_id
                    ELSE mv_screening.region_id
                END, '_'::text, ' '::text))), (
                CASE
                    WHEN replace(
                    CASE
                        WHEN mv_screening.region_id IS NULL THEN mv_screening.parish_id
                        ELSE mv_screening.district_id
                    END, '_'::text, ' '::text) ~~* '%city%'::text THEN initcap(replace(
                    CASE
                        WHEN mv_screening.region_id IS NULL THEN mv_screening.parish_id
                        ELSE mv_screening.district_id
                    END, '_'::text, ' '::text))
                    ELSE concat(initcap(replace(
                    CASE
                        WHEN mv_screening.region_id IS NULL THEN mv_screening.parish_id
                        ELSE mv_screening.district_id
                    END, '_'::text, ' '::text)), ' District')
                END), mv_screening.year, mv_screening.month, (EXTRACT(month FROM mv_screening.reported::date)::integer)
        )
 SELECT ra.region,
    ra.district,
    ra.year,
    ra.monthname,
    ra.month,
    reg.number_vhts_registered,
    ra.number_vhts_reported,
    COALESCE(round(ra.number_vhts_reported::numeric / NULLIF(reg.number_vhts_registered, 0)::numeric * 100::numeric, 2), 0::numeric) AS vht_reporting_rate,
    reg.number_chews_registered,
    ra.number_chews_reported,
    COALESCE(round(ra.number_chews_reported::numeric / NULLIF(reg.number_chews_registered, 0)::numeric * 100::numeric, 2), 0::numeric) AS chews_reporting_rate,
    COALESCE(hhreg.number_hh_registered, 0::bigint) AS number_hh_registered,
    COALESCE(hhreg.number_hh_visited, 0::bigint) AS number_hh_visited,
    COALESCE(ireg.number_children_registered, 0::bigint) AS number_children_registered,
    COALESCE(ce.number_children_engaged, 0::bigint) AS number_children_engaged,
    COALESCE(ireg.number_individuals_registered, 0::bigint) AS number_individuals_registered,
    COALESCE(scn.number_individuals_screened, 0::bigint) AS number_individuals_screened,
    COALESCE(scn.number_individuals_referred, 0::bigint) AS number_individuals_referred,
    COALESCE(scn.number_individuals_counselled_for_fp, 0::bigint) AS number_individuals_counselled_for_fp
   FROM reporting_activity ra
     LEFT JOIN registration_totals reg ON ra.region = reg.region AND ra.district = reg.district
     LEFT JOIN hh_reg_visit hhreg ON ra.region = hhreg.region AND ra.district = hhreg.district AND ra.year = hhreg.year AND ra.month = hhreg.month
     LEFT JOIN individual_registration ireg ON ra.region = ireg.region AND ra.district = ireg.district AND ra.year = ireg.year AND ra.month = ireg.month
     LEFT JOIN child_engagement ce ON ra.region = ce.region AND ra.district = ce.district AND ra.year = ce.year AND ra.month = ce.month
     LEFT JOIN all_screened scn ON ra.region = scn.region AND ra.district = scn.district AND ra.year = scn.year AND ra.month = scn.month
  ORDER BY ra.year, ra.month
WITH DATA;