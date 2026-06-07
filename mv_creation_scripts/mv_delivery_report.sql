-- cht.mv_delivery_report source

CREATE MATERIALIZED VIEW cht.mv_delivery_report
TABLESPACE ts_report
AS WITH delivery_metrics AS (
         SELECT initcap(d.region) AS region,
            initcap(d.district) AS district,
            t.total_district,
            to_char(d.delivery_date::date::timestamp with time zone, 'YYYY'::text)::integer AS delivery_year,
            to_char(d.delivery_date::date::timestamp with time zone, 'YYYY-"Q"Q'::text) AS delivery_quarter,
            to_char(d.delivery_date::date::timestamp with time zone, 'YYYY-MM'::text) AS delivery_month_year,
            to_char(d.delivery_date::date::timestamp with time zone, 'FMMM'::text)::integer AS delivery_month,
            to_char(d.delivery_date::date::timestamp with time zone, 'Month'::text) AS delivery_month_name,
            EXTRACT(quarter FROM d.delivery_date::date)::integer AS quarter,
            count(DISTINCT NULLIF(d.district, 'District not selected'::text)) AS number_of_districts,
            count(DISTINCT concat_ws('-'::text, d.mother_id, d.family_id)) AS total_deliveries,
            count(DISTINCT
                CASE
                    WHEN d.sex ~~* 'female'::text THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS female_infants_count,
            count(DISTINCT
                CASE
                    WHEN d.sex ~~* 'male'::text THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS male_infants_count,
            count(DISTINCT
                CASE
                    WHEN d.delivery_method = 'cesarean'::text AND d.patient_gender = 'female'::text THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS cesarean_patients,
            count(DISTINCT
                CASE
                    WHEN d.delivery_method = 'normal'::text AND d.patient_gender = 'female'::text THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS normal_patients,
            count(DISTINCT
                CASE
                    WHEN d.delivery_method IS NULL AND d.patient_gender = 'female'::text THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS no_method_selected,
            count(DISTINCT
                CASE
                    WHEN d.woman_danger_sign_convulsions = 'yes'::text THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS mat_convulsions,
            count(DISTINCT
                CASE
                    WHEN d.woman_danger_sign_fever = 'yes'::text THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS mat_fever,
            count(DISTINCT
                CASE
                    WHEN d.woman_danger_sign_vaginal_bleeding = 'yes'::text THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS mat_vaginal_bleeding,
            count(DISTINCT
                CASE
                    WHEN d.woman_danger_sign_severe_headache = 'yes'::text THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS mat_severe_headache,
            count(DISTINCT
                CASE
                    WHEN d.woman_danger_sign_convulsions = 'yes'::text THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) + count(DISTINCT
                CASE
                    WHEN d.woman_danger_sign_fever = 'yes'::text THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) + count(DISTINCT
                CASE
                    WHEN d.woman_danger_sign_severe_headache = 'yes'::text THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) + count(DISTINCT
                CASE
                    WHEN d.woman_danger_sign_vaginal_bleeding = 'yes'::text THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS total_maternal_danger_signs,
            count(DISTINCT
                CASE
                    WHEN d.baby_danger_sign_blue_skin = 'yes'::text THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS baby_blue_skin,
            count(DISTINCT
                CASE
                    WHEN d.baby_danger_sign_body = 'yes'::text THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS baby_body_issue,
            count(DISTINCT
                CASE
                    WHEN d.baby_danger_sign_drowsy = 'yes'::text THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS baby_drowsy,
            count(DISTINCT
                CASE
                    WHEN d.baby_danger_sign_fever = 'yes'::text THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS baby_fever,
            count(DISTINCT
                CASE
                    WHEN d.baby_danger_sign_infected_convulsions = 'yes'::text THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS baby_inf_convulsions,
            count(DISTINCT
                CASE
                    WHEN d.baby_danger_sign_infected_feeding_difficulty = 'yes'::text THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS baby_feeding_diff,
            count(DISTINCT
                CASE
                    WHEN d.baby_danger_sign_infected_umbilical_cord = 'yes'::text THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS baby_umbilical_inf,
            count(DISTINCT
                CASE
                    WHEN d.baby_danger_sign_vomits_everything = 'yes'::text THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS baby_vomiting,
            count(DISTINCT
                CASE
                    WHEN d.baby_danger_sign_yellow_skin = 'yes'::text THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS baby_yellow_skin,
            count(DISTINCT
                CASE
                    WHEN d.breastfed_within_one_hour = 'yes'::text THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS bf_yes,
            count(DISTINCT
                CASE
                    WHEN d.breastfed_within_one_hour = 'no'::text THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS bf_no,
            count(DISTINCT
                CASE
                    WHEN d.baby_condition = 'alive_well'::text THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS baby_alive_well,
            count(DISTINCT
                CASE
                    WHEN d.baby_condition = 'alive_unwell'::text THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS baby_alive_unwell,
            count(DISTINCT
                CASE
                    WHEN d.baby_condition = 'premature'::text THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS baby_premature,
            count(DISTINCT
                CASE
                    WHEN d.baby_condition IS NULL THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS baby_cond_unknown,
            count(DISTINCT
                CASE
                    WHEN d.baby_condition = ANY (ARRAY['alive_well'::text, 'alive_unwell'::text, 'premature'::text]) THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS baby_alive,
            count(DISTINCT
                CASE
                    WHEN d.delivery_place = 'home'::text THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS delivery_place_home,
            count(DISTINCT
                CASE
                    WHEN d.delivery_place = 'health_facility'::text THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS delivery_place_health_facility,
            count(DISTINCT
                CASE
                    WHEN d.delivery_place = 'other'::text THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS delivery_place_other,
            count(DISTINCT
                CASE
                    WHEN d.who_conducted_delivery = 'other'::text THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS conducted_delivery_other,
            count(DISTINCT
                CASE
                    WHEN d.who_conducted_delivery = 'skilled_health_care_provider'::text OR d.who_conducted_delivery IS NULL AND d.delivery_place = 'health_facility'::text THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS conducted_delivery_skilledhcp,
            count(DISTINCT
                CASE
                    WHEN d.who_conducted_delivery = 'traditional_birth_attendant'::text THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS conducted_delivery_tba,
            count(DISTINCT
                CASE
                    WHEN d.who_conducted_delivery IS NULL AND d.delivery_place <> 'health_facility'::text THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS conducted_delivery_unknown,
            sum(
                CASE
                    WHEN NULLIF(d.number_of_babies_delivered, ''::text)::integer = 1 THEN 1
                    ELSE 0
                END) AS singleton_births,
            sum(
                CASE
                    WHEN NULLIF(d.number_of_babies_delivered, ''::text)::integer = 2 THEN 1
                    ELSE 0
                END) AS twin_births,
            sum(
                CASE
                    WHEN NULLIF(d.number_of_babies_delivered, ''::text)::integer > 2 THEN 1
                    ELSE 0
                END) AS greater_than_two,
            count(DISTINCT
                CASE
                    WHEN d.pregnancy_hiv_test_result = 'negative'::text THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS preg_test_result_negative,
            count(DISTINCT
                CASE
                    WHEN d.pregnancy_hiv_test_result = 'positive'::text THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS preg_test_result_positive,
            count(DISTINCT
                CASE
                    WHEN d.pregnancy_hiv_test_result = 'unknown'::text THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS preg_test_result_unknown,
            count(DISTINCT
                CASE
                    WHEN d.pregnancy_hiv_test_result IS NULL THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS preg_test_result_notcaptured,
            count(DISTINCT
                CASE
                    WHEN d.pregnancy_hiv_test_result = 'positive'::text THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END)::numeric * 100.0 / NULLIF(count(DISTINCT
                CASE
                    WHEN d.pregnancy_hiv_test_result = ANY (ARRAY['positive'::text, 'negative'::text]) THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END), 0)::numeric AS preg_test_pos_rate,
            count(DISTINCT
                CASE
                    WHEN d.woman_outcome = 'alive_well'::text THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS woman_alive_well,
            count(DISTINCT
                CASE
                    WHEN d.woman_outcome = 'alive_unwell'::text THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS woman_alive_unwell,
            count(DISTINCT
                CASE
                    WHEN d.woman_outcome = ANY (ARRAY['alive_unwell'::text, 'alive_well'::text]) THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS woman_alive,
            count(DISTINCT
                CASE
                    WHEN d.woman_outcome = 'dead'::text OR d.woman_date_of_death IS NOT NULL THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS woman_died,
            count(DISTINCT
                CASE
                    WHEN NULLIF(d.woman_outcome, ''::text) IS NULL AND d.woman_date_of_death IS NULL THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS woman_outcome_not_recorded,
            count(DISTINCT
                CASE
                    WHEN d.still_birth = 'yes'::text THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS still_birth_yes,
            count(DISTINCT
                CASE
                    WHEN d.still_birth = 'no'::text THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS still_birth_no,
            count(DISTINCT
                CASE
                    WHEN (d.baby_date_of_death IS NOT NULL OR d.baby_condition = 'dead'::text) AND (d.still_birth IS NULL OR d.still_birth = 'no'::text) THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS baby_died,
            count(DISTINCT
                CASE
                    WHEN d.baby_place_of_death = 'health_facility'::text THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS baby_died_health_facility,
            count(DISTINCT
                CASE
                    WHEN d.baby_place_of_death = 'home'::text THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS baby_died_home,
            count(DISTINCT
                CASE
                    WHEN d.baby_date_of_death IS NOT NULL AND (NULLIF(d.baby_place_of_death, ''::text) IS NULL OR d.baby_place_of_death ~~* 'unknown'::text) AND d.still_birth IS NOT NULL THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS baby_died_place_unknown,
            count(DISTINCT
                CASE
                    WHEN d.pnc_visits = 'within_24_hours'::text THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS pncvisit_within_24_hours,
            count(DISTINCT
                CASE
                    WHEN d.pnc_visits = 'within_24_hours 7_days'::text THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS pncvisit_within_24_hours_7_days,
            count(DISTINCT
                CASE
                    WHEN d.pnc_visits = '7_days'::text THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS pncvisit_7_days,
            count(DISTINCT
                CASE
                    WHEN d.pnc_visits = 'none'::text THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS pncvisit_none,
            count(DISTINCT
                CASE
                    WHEN d.pnc_visits IS NULL THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS pncvisit_unknown,
            count(DISTINCT
                CASE
                    WHEN d.patient_age_in_years::integer >= 18 AND (upper(d.is_of_child_bearing_age) = 'TRUE'::text OR d.is_of_child_bearing_age IS NULL) THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS is_child_bearing_age,
            count(DISTINCT
                CASE
                    WHEN d.patient_age_in_years::integer < 18 AND (upper(d.is_of_child_bearing_age) = 'FALSE'::text OR d.is_of_child_bearing_age IS NULL OR upper(d.is_of_child_bearing_age) = 'TRUE'::text) THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS not_child_bearing_age,
            count(DISTINCT
                CASE
                    WHEN d.patient_age_in_years::integer < 18 AND (upper(d.is_of_child_bearing_age) = 'FALSE'::text OR d.is_of_child_bearing_age IS NULL OR upper(d.is_of_child_bearing_age) = 'TRUE'::text) AND (d.woman_outcome = 'dead'::text OR d.woman_date_of_death IS NOT NULL) THEN concat_ws('-'::text, d.mother_id, d.family_id)
                    ELSE NULL::text
                END) AS not_child_bearing_age_died
           FROM cht.mv_delivery d
             LEFT JOIN cht.regions_district t ON upper(d.region) = upper(t.region::text)
          WHERE d.patient_gender = 'female'::text AND d.delivery_date IS NOT NULL
          GROUP BY d.region, d.district, t.total_district, (to_char(d.delivery_date::date::timestamp with time zone, 'YYYY'::text)), (to_char(d.delivery_date::date::timestamp with time zone, 'YYYY-"Q"Q'::text)), (to_char(d.delivery_date::date::timestamp with time zone, 'YYYY-MM'::text)), (to_char(d.delivery_date::date::timestamp with time zone, 'FMMM'::text)), (to_char(d.delivery_date::date::timestamp with time zone, 'Month'::text)), (EXTRACT(quarter FROM d.delivery_date::date))
          ORDER BY (
                CASE
                    WHEN d.region = 'Region not selected'::text THEN 1
                    ELSE 0
                END), d.region, d.district, (to_char(d.delivery_date::date::timestamp with time zone, 'YYYY'::text)), (to_char(d.delivery_date::date::timestamp with time zone, 'YYYY-"Q"Q'::text)), (to_char(d.delivery_date::date::timestamp with time zone, 'YYYY-MM'::text)), (to_char(d.delivery_date::date::timestamp with time zone, 'FMMM'::text)), (EXTRACT(quarter FROM d.delivery_date::date))
        ), regional_summary AS (
         SELECT initcap(d.region) AS region_name,
            to_char(d.delivery_date::date::timestamp with time zone, 'YYYY-MM'::text) AS delivery_month_year,
            string_agg(DISTINCT upper("left"(d.district, 1)) || lower(SUBSTRING(d.district FROM 2)), ', '::text) AS districts_list
           FROM cht.mv_delivery d
          WHERE d.patient_gender = 'female'::text AND d.delivery_date IS NOT NULL AND d.region IS NOT NULL
          GROUP BY d.region, (to_char(d.delivery_date::date::timestamp with time zone, 'YYYY-MM'::text))
          ORDER BY (
                CASE
                    WHEN d.region = 'Region not selected'::text THEN 1
                    ELSE 0
                END), d.region, (to_char(d.delivery_date::date::timestamp with time zone, 'YYYY-MM'::text))
        ), anc_summary AS (
         SELECT initcap(anc_1.region) AS region_name,
            initcap(anc_1.district) AS district_name,
            to_char(anc_1.reported::date::timestamp with time zone, 'YYYY'::text)::integer AS chwancvist_year,
            to_char(anc_1.reported::date::timestamp with time zone, 'YYYY-"Q"Q'::text) AS chwancvisit_quarter,
            to_char(anc_1.reported::date::timestamp with time zone, 'YYYY-MM'::text) AS chwancvisit_month_year,
            to_char(anc_1.reported::date::timestamp with time zone, 'FMMM'::text)::integer AS chwancvisit_month,
            to_char(anc_1.reported::date::timestamp with time zone, 'Month'::text) AS chwancvisit_month_name,
            EXTRACT(quarter FROM anc_1.reported::date)::integer AS nochwancvisit_quarter,
            t.total_district AS total_anc_districts,
            count(DISTINCT NULLIF(anc_1.district, 'District not selected'::text)) AS number_of_districts,
            count(DISTINCT
                CASE
                    WHEN anc_1.patient_gender ~~* 'female'::text THEN concat_ws('-'::text, anc_1.patient_id, anc_1.patient_name)
                    ELSE NULL::text
                END) AS anc_count,
            count(DISTINCT
                CASE
                    WHEN anc_1.using_llin ~~* 'yes'::text THEN concat_ws('-'::text, anc_1.patient_id, anc_1.patient_name)
                    ELSE NULL::text
                END) AS using_llin_nets,
            count(DISTINCT
                CASE
                    WHEN anc_1.using_llin ~~* 'no'::text THEN concat_ws('-'::text, anc_1.patient_id, anc_1.patient_name)
                    ELSE NULL::text
                END) AS not_using_llin_nets,
            count(DISTINCT
                CASE
                    WHEN anc_1.refer_client_to_health_facility ~~* 'yes'::text AND anc_1.using_llin ~~* 'no'::text THEN concat_ws('-'::text, anc_1.patient_id, anc_1.patient_name)
                    ELSE NULL::text
                END) AS reffered_for_using_llin,
            count(DISTINCT
                CASE
                    WHEN anc_1.has_upcoming_anc_visits ~~* 'yes'::text THEN concat_ws('-'::text, anc_1.patient_id, anc_1.patient_name)
                    ELSE NULL::text
                END) AS upcoming_anc_visit,
            count(DISTINCT
                CASE
                    WHEN anc_1.has_upcoming_anc_visits ~~* 'no'::text THEN concat_ws('-'::text, anc_1.patient_id, anc_1.patient_name)
                    ELSE NULL::text
                END) AS noupcoming_anc_visit,
            count(DISTINCT
                CASE
                    WHEN anc_1.has_upcoming_anc_visits ~~* 'yes'::text AND anc_1.anc_appointment_date IS NOT NULL THEN concat_ws('-'::text, anc_1.patient_id, anc_1.patient_name)
                    ELSE NULL::text
                END) AS appoint_anc_visit,
            count(DISTINCT
                CASE
                    WHEN NULLIF(anc_1.number_of_anc_visits, 'none'::text)::integer = 1 THEN concat_ws('-'::text, anc_1.patient_id, anc_1.patient_name)
                    ELSE NULL::text
                END) AS first_anc_visit,
            count(DISTINCT
                CASE
                    WHEN NULLIF(anc_1.number_of_anc_visits, 'none'::text)::integer >= 2 AND NULLIF(anc_1.number_of_anc_visits, 'none'::text)::integer < 4 THEN concat_ws('-'::text, anc_1.patient_id, anc_1.patient_name)
                    ELSE NULL::text
                END) AS second_to_third_anc_visit,
            count(DISTINCT
                CASE
                    WHEN NULLIF(anc_1.number_of_anc_visits, 'none'::text)::integer = 4 THEN concat_ws('-'::text, anc_1.patient_id, anc_1.patient_name)
                    ELSE NULL::text
                END) AS fourth_anc_visit,
            count(DISTINCT
                CASE
                    WHEN NULLIF(anc_1.number_of_anc_visits, 'none'::text)::integer >= 4 AND NULLIF(anc_1.number_of_anc_visits, 'none'::text)::integer < 8 THEN concat_ws('-'::text, anc_1.patient_id, anc_1.patient_name)
                    ELSE NULL::text
                END) AS fifth_to_seventh_anc_visit,
            count(DISTINCT
                CASE
                    WHEN NULLIF(anc_1.number_of_anc_visits, 'none'::text)::integer >= 8 THEN concat_ws('-'::text, anc_1.patient_id, anc_1.patient_name)
                    ELSE NULL::text
                END) AS eighth_and_above_anc_visit,
            count(DISTINCT
                CASE
                    WHEN anc_1.hiv_test_done ~~* 'yes'::text AND anc_1.number_of_anc_visits IS NOT NULL THEN concat_ws('-'::text, anc_1.patient_id, anc_1.patient_name)
                    ELSE NULL::text
                END) AS hivtestdone_anc_visit,
            count(DISTINCT
                CASE
                    WHEN anc_1.hiv_test_done ~~* 'no'::text AND anc_1.number_of_anc_visits IS NOT NULL THEN concat_ws('-'::text, anc_1.patient_id, anc_1.patient_name)
                    ELSE NULL::text
                END) AS no_hivtestdone_anc_visit,
            count(DISTINCT
                CASE
                    WHEN anc_1.hiv_test_done IS NULL AND anc_1.number_of_anc_visits IS NOT NULL THEN concat_ws('-'::text, anc_1.patient_id, anc_1.patient_name)
                    ELSE NULL::text
                END) AS unknown_hivtestdone_anc_visit,
            count(DISTINCT
                CASE
                    WHEN anc_1.hiv_test_result ~~* 'negative'::text AND anc_1.hiv_test_done IS NOT NULL THEN concat_ws('-'::text, anc_1.patient_id, anc_1.patient_name)
                    ELSE NULL::text
                END) AS hivtestresult_negative,
            count(DISTINCT
                CASE
                    WHEN anc_1.hiv_test_result ~~* 'positive'::text AND anc_1.hiv_test_done IS NOT NULL THEN concat_ws('-'::text, anc_1.patient_id, anc_1.patient_name)
                    ELSE NULL::text
                END) AS hivtestresult_positive,
            count(DISTINCT
                CASE
                    WHEN anc_1.hiv_test_result IS NULL AND anc_1.hiv_test_done IS NOT NULL THEN concat_ws('-'::text, anc_1.patient_id, anc_1.patient_name)
                    ELSE NULL::text
                END) AS hivtestresult_unknown
           FROM cht.mv_pregnancy anc_1
             LEFT JOIN cht.regions_district t ON upper(anc_1.region) = upper(t.region::text)
          WHERE anc_1.patient_gender = 'female'::text AND anc_1.region IS NOT NULL
          GROUP BY anc_1.region, anc_1.district, t.total_district, (to_char(anc_1.reported::date::timestamp with time zone, 'YYYY'::text)), (to_char(anc_1.reported::date::timestamp with time zone, 'YYYY-"Q"Q'::text)), (to_char(anc_1.reported::date::timestamp with time zone, 'YYYY-MM'::text)), (to_char(anc_1.reported::date::timestamp with time zone, 'FMMM'::text)), (to_char(anc_1.reported::date::timestamp with time zone, 'Month'::text)), (EXTRACT(quarter FROM anc_1.reported::date))
          ORDER BY anc_1.region, anc_1.district, (to_char(anc_1.reported::date::timestamp with time zone, 'YYYY'::text)), (to_char(anc_1.reported::date::timestamp with time zone, 'YYYY-"Q"Q'::text)), (to_char(anc_1.reported::date::timestamp with time zone, 'YYYY-MM'::text)), (to_char(anc_1.reported::date::timestamp with time zone, 'FMMM'::text)), (to_char(anc_1.reported::date::timestamp with time zone, 'Month'::text)), (EXTRACT(quarter FROM anc_1.reported::date))
        ), regional_summary_anc AS (
         SELECT initcap(anc_1.region) AS region_name,
            to_char(anc_1.reported::date::timestamp with time zone, 'YYYY-MM'::text) AS chwancvisit_month_year_ranc,
            string_agg(DISTINCT upper("left"(anc_1.district, 1)) || lower(SUBSTRING(anc_1.district FROM 2)), ', '::text) AS districts_anc_list
           FROM cht.mv_pregnancy anc_1
          WHERE anc_1.patient_gender = 'female'::text AND anc_1.region IS NOT NULL
          GROUP BY anc_1.region, anc_1.district, (to_char(anc_1.reported::date::timestamp with time zone, 'YYYY-MM'::text))
          ORDER BY anc_1.region, anc_1.district, (to_char(anc_1.reported::date::timestamp with time zone, 'YYYY-MM'::text))
        )
 SELECT COALESCE(dm.region, anc.region_name) AS region,
    COALESCE(dm.district, anc.district_name) AS district,
    COALESCE(dm.delivery_year, anc.chwancvist_year) AS year,
    COALESCE(dm.delivery_quarter, anc.chwancvisit_quarter) AS delivery_quarter,
    COALESCE(dm.delivery_month_year, anc.chwancvisit_month_year) AS delivery_month_year,
    COALESCE(dm.delivery_month, anc.chwancvisit_month) AS month,
    COALESCE(dm.delivery_month_name, anc.chwancvisit_month_name) AS month_name,
    COALESCE(dm.quarter, anc.nochwancvisit_quarter) AS quarter,
    COALESCE(dm.total_district, anc.total_anc_districts) AS total_district,
    COALESCE(dm.number_of_districts, anc.number_of_districts) AS number_of_districts,
    dm.total_deliveries,
    dm.female_infants_count,
    dm.male_infants_count,
    dm.cesarean_patients,
    dm.normal_patients,
    dm.no_method_selected,
    dm.mat_convulsions,
    dm.mat_fever,
    dm.mat_vaginal_bleeding,
    dm.mat_severe_headache,
    dm.total_maternal_danger_signs,
    dm.baby_blue_skin,
    dm.baby_body_issue,
    dm.baby_drowsy,
    dm.baby_fever,
    dm.baby_inf_convulsions,
    dm.baby_feeding_diff,
    dm.baby_umbilical_inf,
    dm.baby_vomiting,
    dm.baby_yellow_skin,
    dm.bf_yes,
    dm.bf_no,
    dm.baby_alive_well,
    dm.baby_alive_unwell,
    dm.baby_premature,
    dm.baby_cond_unknown,
    dm.baby_alive,
    dm.delivery_place_home,
    dm.delivery_place_health_facility,
    dm.delivery_place_other,
    dm.conducted_delivery_other,
    dm.conducted_delivery_skilledhcp,
    dm.conducted_delivery_tba,
    dm.conducted_delivery_unknown,
    dm.singleton_births,
    dm.twin_births,
    dm.greater_than_two,
    dm.preg_test_result_negative,
    dm.preg_test_result_positive,
    dm.preg_test_result_unknown,
    dm.preg_test_result_notcaptured,
    dm.preg_test_pos_rate,
    dm.woman_alive_well,
    dm.woman_alive_unwell,
    dm.woman_alive,
    dm.woman_died,
    dm.woman_outcome_not_recorded,
    dm.still_birth_yes,
    dm.still_birth_no,
    dm.baby_died,
    dm.baby_died_health_facility,
    dm.baby_died_home,
    dm.baby_died_place_unknown,
    dm.pncvisit_within_24_hours,
    dm.pncvisit_within_24_hours_7_days,
    dm.pncvisit_7_days,
    dm.pncvisit_none,
    dm.pncvisit_unknown,
    dm.is_child_bearing_age,
    dm.not_child_bearing_age,
    dm.not_child_bearing_age_died,
    COALESCE(rs.districts_list, ranc.districts_anc_list) AS districts_list,
    anc.anc_count,
    anc.using_llin_nets,
    anc.not_using_llin_nets,
    anc.reffered_for_using_llin,
    anc.upcoming_anc_visit,
    anc.noupcoming_anc_visit,
    anc.appoint_anc_visit,
    anc.first_anc_visit,
    anc.second_to_third_anc_visit,
    anc.fourth_anc_visit,
    anc.fifth_to_seventh_anc_visit,
    anc.eighth_and_above_anc_visit,
    anc.hivtestdone_anc_visit,
    anc.no_hivtestdone_anc_visit,
    anc.unknown_hivtestdone_anc_visit,
    anc.hivtestresult_negative,
    anc.hivtestresult_positive,
    anc.hivtestresult_unknown
   FROM delivery_metrics dm
     FULL JOIN regional_summary rs ON dm.region = rs.region_name AND dm.delivery_month_year = rs.delivery_month_year
     FULL JOIN anc_summary anc ON COALESCE(dm.region, rs.region_name) = anc.region_name AND dm.district = anc.district_name AND COALESCE(dm.delivery_month_year, rs.delivery_month_year) = anc.chwancvisit_month_year
     FULL JOIN regional_summary_anc ranc ON anc.region_name = ranc.region_name AND anc.chwancvisit_month_year = ranc.chwancvisit_month_year_ranc
  WHERE COALESCE(dm.region, anc.region_name) IS NOT NULL
  ORDER BY dm.delivery_month_year DESC, dm.region
WITH NO DATA;