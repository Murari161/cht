CREATE MATERIALIZED VIEW cht.mv_delivery_report TABLESPACE ts_report AS

with delivery_metrics as (

select
    INITCAP(d.region) AS Region,
    INITCAP(d.district) AS District,
    --UPPER(LEFT(d.region, 1)) || LOWER(SUBSTRING(d.region FROM 2)) as Region,
    --UPPER(LEFT(d.district, 1)) || LOWER(SUBSTRING(d.district FROM 2)) as District,
    t.total_district,
    TO_CHAR(d.delivery_date::date, 'YYYY')::integer as delivery_year,
    TO_CHAR(d.delivery_date::date, 'YYYY-"Q"Q') AS delivery_quarter,
    TO_CHAR(d.delivery_date::date, 'YYYY-MM') AS delivery_month_year,
    TO_CHAR(d.delivery_date::date, 'FMMM')::integer AS delivery_month,
    TO_CHAR(d.delivery_date::date, 'Month') AS delivery_month_name,
    EXTRACT(QUARTER FROM d.delivery_date::date)::integer AS quarter,
    
    COUNT(DISTINCT NULLIF(d.district, 'District not selected')) AS Number_of_Districts,
    COUNT(DISTINCT CONCAT_WS('-', d.mother_id, d.family_id)) AS total_deliveries,
    COUNT(DISTINCT CASE WHEN d.sex ILIKE 'female' THEN CONCAT_WS('-', d.mother_id, d.family_id) END) AS female_infants_count,
    COUNT(DISTINCT CASE WHEN d.sex ILIKE 'male' THEN CONCAT_WS('-', d.mother_id, d.family_id) END) AS male_infants_count,

    COUNT(DISTINCT CASE WHEN d.delivery_method = 'cesarean' AND d.patient_gender = 'female' THEN CONCAT_WS('-', d.mother_id, d.family_id) END) AS cesarean_patients,
    COUNT(DISTINCT CASE WHEN d.delivery_method = 'normal' AND d.patient_gender = 'female' THEN CONCAT_WS('-', d.mother_id, d.family_id) END) AS normal_patients,
	COUNT(DISTINCT CASE WHEN d.delivery_method IS NULL  AND d.patient_gender = 'female' THEN CONCAT_WS('-', d.mother_id, d.family_id) END) AS no_method_selected,
	
    COUNT(DISTINCT CASE WHEN d.woman_danger_sign_convulsions = 'yes' THEN CONCAT_WS('-', d.mother_id, d.family_id) END) AS mat_convulsions,
    COUNT(DISTINCT CASE WHEN d.woman_danger_sign_fever = 'yes' THEN CONCAT_WS('-', d.mother_id, d.family_id) END) AS mat_fever,
    COUNT(DISTINCT CASE WHEN d.woman_danger_sign_vaginal_bleeding = 'yes' THEN CONCAT_WS('-', d.mother_id, d.family_id) END) AS mat_vaginal_bleeding,
    COUNT(DISTINCT CASE WHEN d.woman_danger_sign_severe_headache = 'yes' THEN CONCAT_WS('-', d.mother_id, d.family_id) END) as mat_severe_headache,
    (
        COUNT(DISTINCT CASE WHEN d.woman_danger_sign_convulsions = 'yes' THEN CONCAT_WS('-', d.mother_id, d.family_id) END) +
        COUNT(DISTINCT CASE WHEN d.woman_danger_sign_fever = 'yes' THEN CONCAT_WS('-', d.mother_id, d.family_id) END) +
        COUNT(DISTINCT CASE WHEN d.woman_danger_sign_severe_headache = 'yes' THEN CONCAT_WS('-', d.mother_id, d.family_id) END) +
        COUNT(DISTINCT CASE WHEN d.woman_danger_sign_vaginal_bleeding = 'yes' THEN CONCAT_WS('-', d.mother_id, d.family_id) END)
    ) AS total_maternal_danger_signs,


    COUNT(DISTINCT CASE WHEN d.baby_danger_sign_blue_skin = 'yes' THEN CONCAT_WS('-', d.mother_id, d.family_id) END) AS baby_blue_skin,
    COUNT(DISTINCT CASE WHEN d.baby_danger_sign_body = 'yes' THEN CONCAT_WS('-', d.mother_id, d.family_id) END) AS baby_body_issue,
    COUNT(DISTINCT CASE WHEN d.baby_danger_sign_drowsy = 'yes' THEN CONCAT_WS('-', d.mother_id, d.family_id) END) AS baby_drowsy,
    COUNT(DISTINCT CASE WHEN d.baby_danger_sign_fever = 'yes' THEN CONCAT_WS('-', d.mother_id, d.family_id) END) AS baby_fever,
    COUNT(DISTINCT CASE WHEN d.baby_danger_sign_infected_convulsions = 'yes' THEN CONCAT_WS('-', d.mother_id, d.family_id) END) AS baby_inf_convulsions,
    COUNT(DISTINCT CASE WHEN d.baby_danger_sign_infected_feeding_difficulty = 'yes' THEN CONCAT_WS('-', d.mother_id, d.family_id) END) AS baby_feeding_diff,
    COUNT(DISTINCT CASE WHEN d.baby_danger_sign_infected_umbilical_cord = 'yes' THEN CONCAT_WS('-', d.mother_id, d.family_id) END) AS baby_umbilical_inf,
    COUNT(DISTINCT CASE WHEN d.baby_danger_sign_vomits_everything = 'yes' THEN CONCAT_WS('-', d.mother_id, d.family_id) END) AS baby_vomiting,
    COUNT(DISTINCT CASE WHEN d.baby_danger_sign_yellow_skin = 'yes' THEN CONCAT_WS('-', d.mother_id, d.family_id) END) AS baby_yellow_skin,

	COUNT(DISTINCT CASE WHEN d.breastfed_within_one_hour = 'yes' THEN CONCAT_WS('-', d.mother_id, d.family_id) END) AS bf_yes,
    COUNT(DISTINCT CASE WHEN d.breastfed_within_one_hour = 'no' THEN CONCAT_WS('-', d.mother_id, d.family_id) END) AS bf_no,

    COUNT(DISTINCT CASE WHEN d.baby_condition = 'alive_well' THEN CONCAT_WS('-', d.mother_id, d.family_id) END) AS baby_alive_well,
    COUNT(DISTINCT CASE WHEN d.baby_condition = 'alive_unwell' THEN CONCAT_WS('-', d.mother_id, d.family_id) END) AS baby_alive_unwell,
    COUNT(DISTINCT CASE WHEN d.baby_condition = 'premature' THEN CONCAT_WS('-', d.mother_id, d.family_id) END) AS baby_premature,
    COUNT(DISTINCT CASE WHEN d.baby_condition IS NULL THEN CONCAT_WS('-', d.mother_id, d.family_id) END) AS baby_cond_unknown,
    COUNT(DISTINCT CASE WHEN d.baby_condition in ('alive_well', 'alive_unwell', 'premature') THEN CONCAT_WS('-', d.mother_id, d.family_id) END) AS baby_alive,    
    
    COUNT(DISTINCT CASE WHEN d.delivery_place = 'home' THEN CONCAT_WS('-', d.mother_id, d.family_id) END) AS delivery_place_home,
    COUNT(DISTINCT CASE WHEN d.delivery_place = 'health_facility' THEN CONCAT_WS('-', d.mother_id, d.family_id) END) AS delivery_place_health_facility,
    COUNT(DISTINCT CASE WHEN d.delivery_place = 'other' THEN CONCAT_WS('-', d.mother_id, d.family_id) END) AS delivery_place_other,
    
    COUNT(DISTINCT CASE WHEN d.who_conducted_delivery = 'other' THEN CONCAT_WS('-', d.mother_id, d.family_id) END) AS conducted_delivery_other,
    COUNT(DISTINCT CASE WHEN d.who_conducted_delivery = 'skilled_health_care_provider' 
      OR (d.who_conducted_delivery IS NULL AND d.delivery_place = 'health_facility')
    THEN CONCAT_WS('-', d.mother_id, d.family_id) 
END) AS conducted_delivery_skilledHCP,
    COUNT(DISTINCT CASE WHEN d.who_conducted_delivery = 'traditional_birth_attendant' THEN CONCAT_WS('-', d.mother_id, d.family_id) END) AS conducted_delivery_TBA,
    COUNT(DISTINCT CASE 
    WHEN d.who_conducted_delivery IS NULL 
     AND d.delivery_place != 'health_facility'
    THEN CONCAT_WS('-', d.mother_id, d.family_id) 
END) AS conducted_delivery_unknown,


SUM(CASE 
    WHEN NULLIF(d.number_of_babies_delivered,'')::integer= 1 THEN 1 
    ELSE 0 
END) AS singleton_births,

SUM(CASE 
    WHEN NULLIF(d.number_of_babies_delivered,'')::integer = 2 THEN 1 
    ELSE 0 
END) AS Twin_births,

SUM(CASE 
    WHEN NULLIF(d.number_of_babies_delivered,'')::integer > 2 THEN 1 
    ELSE 0 
END) AS greater_than_two,

COUNT(DISTINCT CASE WHEN d.pregnancy_hiv_test_result = 'negative' THEN CONCAT_WS('-', d.mother_id, d.family_id) END) AS Preg_test_result_negative,
COUNT(DISTINCT CASE WHEN d.pregnancy_hiv_test_result = 'positive' THEN CONCAT_WS('-', d.mother_id, d.family_id) END) AS Preg_test_result_positive,
COUNT(DISTINCT CASE WHEN d.pregnancy_hiv_test_result = 'unknown' THEN CONCAT_WS('-', d.mother_id, d.family_id) END) AS Preg_test_result_unknown,
COUNT(DISTINCT CASE WHEN d.pregnancy_hiv_test_result IS NULL THEN CONCAT_WS('-', d.mother_id, d.family_id) END) AS Preg_test_result_Notcaptured,

COUNT(DISTINCT CASE WHEN d.pregnancy_hiv_test_result = 'positive' THEN CONCAT_WS('-', d.mother_id, d.family_id) 
END) * 100.0 / NULLIF(COUNT(DISTINCT CASE WHEN d.pregnancy_hiv_test_result IN ('positive','negative') THEN CONCAT_WS('-', d.mother_id, d.family_id) 
END), 0) AS Preg_test_pos_rate
,

COUNT(DISTINCT CASE WHEN d.woman_outcome = 'alive_well' THEN CONCAT_WS('-', d.mother_id, d.family_id) END) AS woman_alive_well,
COUNT(DISTINCT CASE WHEN d.woman_outcome = 'alive_unwell' THEN CONCAT_WS('-', d.mother_id, d.family_id) END) AS woman_alive_unwell,
COUNT(DISTINCT CASE WHEN d.woman_outcome IN ('alive_unwell','alive_well') THEN CONCAT_WS('-', d.mother_id, d.family_id) END) AS woman_alive,
COUNT(DISTINCT CASE 
    WHEN d.woman_outcome = 'dead' OR d.woman_date_of_death IS NOT NULL 
    THEN CONCAT_WS('-', d.mother_id, d.family_id) 
END) AS woman_died,
COUNT(DISTINCT CASE 
    WHEN (NULLIF(d.woman_outcome, '') IS NULL) 
     AND (d.woman_date_of_death IS NULL)
    THEN CONCAT_WS('-', d.mother_id, d.family_id) 
END) AS woman_outcome_not_recorded,

    COUNT(DISTINCT CASE WHEN d.still_birth = 'yes' THEN CONCAT_WS('-', d.mother_id, d.family_id) END) AS still_birth_yes,
    COUNT(DISTINCT CASE WHEN d.still_birth = 'no' THEN CONCAT_WS('-', d.mother_id, d.family_id) END) AS still_birth_no,
    
    COUNT(DISTINCT CASE 
    WHEN (d.baby_date_of_death IS NOT NULL OR d.baby_condition = 'dead')
     AND (d.still_birth IS NULL OR d.still_birth = 'no')
    THEN CONCAT_WS('-', d.mother_id, d.family_id) 
END) AS baby_died,
COUNT(DISTINCT CASE WHEN d.baby_place_of_death = 'health_facility' THEN CONCAT_WS('-', d.mother_id, d.family_id) END) AS baby_died_health_facility,
COUNT(DISTINCT CASE WHEN d.baby_place_of_death = 'home' THEN CONCAT_WS('-', d.mother_id, d.family_id) END) AS baby_died_home,
COUNT(DISTINCT CASE 
    WHEN d.baby_date_of_death IS NOT NULL 
     AND (NULLIF(d.baby_place_of_death, '') IS NULL OR d.baby_place_of_death ILIKE 'unknown')
     AND d.still_birth IS NOT NULL
    THEN CONCAT_WS('-', d.mother_id, d.family_id) 
END) AS baby_died_place_unknown,

COUNT(DISTINCT CASE WHEN d.pnc_visits = 'within_24_hours' THEN CONCAT_WS('-', d.mother_id, d.family_id) END) AS PNCvisit_within_24_hours,
COUNT(DISTINCT CASE WHEN d.pnc_visits = 'within_24_hours 7_days' THEN CONCAT_WS('-', d.mother_id, d.family_id) END) AS PNCvisit_within_24_hours_7_days,
COUNT(DISTINCT CASE WHEN d.pnc_visits = '7_days' THEN CONCAT_WS('-', d.mother_id, d.family_id) END) AS PNCvisit_7_days,
COUNT(DISTINCT CASE WHEN d.pnc_visits = 'none' THEN CONCAT_WS('-', d.mother_id, d.family_id) END) AS PNCvisit_none,
COUNT(DISTINCT CASE WHEN d.pnc_visits is null THEN CONCAT_WS('-', d.mother_id, d.family_id) END) AS PNCvisit_unknown,


COUNT(DISTINCT CASE 
    WHEN d.patient_age_in_years::integer >= 18 
     AND (UPPER(d.is_of_child_bearing_age) ='TRUE' OR d.is_of_child_bearing_age IS NULL)
    THEN CONCAT_WS('-', d.mother_id, d.family_id) 
END) AS is_child_bearing_age,

COUNT(DISTINCT CASE 
    WHEN d.patient_age_in_years::integer < 18 
     AND (UPPER(d.is_of_child_bearing_age) = 'FALSE' OR d.is_of_child_bearing_age IS null or UPPER(d.is_of_child_bearing_age) ='TRUE')
    THEN CONCAT_WS('-', d.mother_id, d.family_id) 
END) AS not_child_bearing_age,

COUNT(DISTINCT CASE 
    WHEN d.patient_age_in_years::integer < 18 
     AND (UPPER(d.is_of_child_bearing_age) = 'FALSE' OR d.is_of_child_bearing_age IS null or UPPER(d.is_of_child_bearing_age) ='TRUE')
     and (d.woman_outcome = 'dead' OR d.woman_date_of_death IS NOT NULL) 
    THEN CONCAT_WS('-', d.mother_id, d.family_id) 
END) AS not_child_bearing_age_died

FROM cht.mv_delivery d
LEFT JOIN cht.regions_district AS t ON UPPER(d.region) = UPPER(t.region)
WHERE d.patient_gender = 'female'
  AND d.delivery_date IS NOT NULL
GROUP by
    d.region,
    d.district, 
    t.total_district,
    TO_CHAR(d.delivery_date::date, 'YYYY'),
    TO_CHAR(d.delivery_date::date, 'YYYY-"Q"Q'),
    TO_CHAR(d.delivery_date::date, 'YYYY-MM'),
    TO_CHAR(d.delivery_date::date, 'FMMM'),
    TO_CHAR(d.delivery_date::date, 'Month'),
    EXTRACT(QUARTER FROM d.delivery_date::date)
ORDER BY 
    CASE WHEN d.region = 'Region not selected' THEN 1 ELSE 0 END,
    d.region,
    d.district,
    TO_CHAR(d.delivery_date::date, 'YYYY'),
    TO_CHAR(d.delivery_date::date, 'YYYY-"Q"Q'),
    TO_CHAR(d.delivery_date::date, 'YYYY-MM'),
	TO_CHAR(d.delivery_date::date, 'FMMM'),
	EXTRACT(QUARTER FROM d.delivery_date::date)

),
regional_summary as 
(
select
    
    INITCAP(d.region) AS Region_name,
    TO_CHAR(d.delivery_date::date, 'YYYY-MM') AS delivery_month_year,
   
    STRING_AGG(DISTINCT UPPER(LEFT(d.district, 1)) || LOWER(SUBSTRING(d.district FROM 2)), ', ') AS districts_list
    
FROM cht.mv_delivery d
WHERE d.patient_gender = 'female'
  AND d.delivery_date IS NOT null
  AND d.region IS NOT null
GROUP BY
    d.region,
    TO_CHAR(d.delivery_date::date, 'YYYY-MM')

ORDER BY 
    CASE WHEN d.region = 'Region not selected' THEN 1 ELSE 0 END,
    d.region,
    TO_CHAR(d.delivery_date::date, 'YYYY-MM')
    
),

anc_summary as 
(

select
INITCAP(anc.region) AS region_name,
INITCAP(anc.district) AS district_name,
TO_CHAR(anc.reported::date, 'YYYY')::integer as chwancvist_year,
TO_CHAR(anc.reported::date, 'YYYY-"Q"Q') AS chwancvisit_quarter,
TO_CHAR(anc.reported::date, 'YYYY-MM') AS chwancvisit_month_year,
TO_CHAR(anc.reported::date, 'FMMM')::integer AS chwancvisit_month,
TO_CHAR(anc.reported::date, 'Month') AS chwancvisit_month_name,
EXTRACT(QUARTER FROM anc.reported::date)::integer AS nochwancvisit_quarter,
t.total_district as total_anc_districts,

COUNT(DISTINCT NULLIF(anc.district, 'District not selected')) AS number_of_districts,
COUNT(DISTINCT CASE WHEN anc.patient_gender ILIKE 'female' THEN CONCAT_WS('-',anc.patient_id, anc.patient_name) END) AS anc_count,
COUNT(DISTINCT CASE WHEN anc.using_llin ILIKE 'yes' THEN CONCAT_WS('-',anc.patient_id, anc.patient_name) END) AS using_llin_nets,
COUNT(DISTINCT CASE WHEN anc.using_llin ILIKE 'no' THEN CONCAT_WS('-',anc.patient_id, anc.patient_name) END) AS not_using_llin_nets,
COUNT(DISTINCT CASE WHEN anc.refer_client_to_health_facility ILIKE 'yes' AND  anc.using_llin ILIKE 'no' THEN CONCAT_WS('-',anc.patient_id, anc.patient_name) END) AS reffered_for_using_llin,

COUNT(DISTINCT CASE WHEN anc.has_upcoming_anc_visits ILIKE 'yes' THEN CONCAT_WS('-',anc.patient_id, anc.patient_name) END) AS upcoming_anc_visit,
COUNT(DISTINCT CASE WHEN anc.has_upcoming_anc_visits ILIKE 'no' THEN CONCAT_WS('-',anc.patient_id, anc.patient_name) END) AS noupcoming_anc_visit,
COUNT(DISTINCT CASE WHEN anc.has_upcoming_anc_visits ILIKE 'yes' AND anc_appointment_date IS NOT null THEN CONCAT_WS('-', anc.patient_id, anc.patient_name) END) AS appoint_anc_visit,

COUNT(DISTINCT CASE WHEN CAST(NULLIF(anc.number_of_anc_visits, 'none') AS INTEGER) = 1 THEN CONCAT_WS('-', anc.patient_id, anc.patient_name) end ) AS first_anc_visit,
COUNT(DISTINCT CASE WHEN CAST(NULLIF(anc.number_of_anc_visits, 'none') AS INTEGER) >= 2 AND CAST(NULLIF(anc.number_of_anc_visits, 'none') AS INTEGER) < 4 THEN CONCAT_WS('-', anc.patient_id, anc.patient_name) END) AS second_to_third_anc_visit,
COUNT(DISTINCT CASE WHEN CAST(NULLIF(anc.number_of_anc_visits, 'none') AS INTEGER) = 4 THEN CONCAT_WS('-', anc.patient_id, anc.patient_name) end ) AS fourth_anc_visit,
COUNT(DISTINCT CASE WHEN CAST(NULLIF(anc.number_of_anc_visits, 'none') AS INTEGER) >= 4 AND CAST(NULLIF(anc.number_of_anc_visits, 'none') AS INTEGER) < 8 THEN CONCAT_WS('-', anc.patient_id, anc.patient_name) END) AS fifth_to_seventh_anc_visit,
COUNT(DISTINCT CASE WHEN CAST(NULLIF(anc.number_of_anc_visits, 'none') AS INTEGER) >= 8 THEN CONCAT_WS('-', anc.patient_id, anc.patient_name) end ) AS eighth_and_above_anc_visit,

COUNT(DISTINCT CASE WHEN anc.hiv_test_done ILIKE 'yes' AND anc.number_of_anc_visits IS NOT Null THEN CONCAT_WS('-', anc.patient_id, anc.patient_name) end ) AS hivtestdone_anc_visit,
COUNT(DISTINCT CASE WHEN anc.hiv_test_done ILIKE 'no' AND anc.number_of_anc_visits IS NOT Null THEN CONCAT_WS('-', anc.patient_id, anc.patient_name) end ) AS no_hivtestdone_anc_visit,
COUNT(DISTINCT CASE WHEN anc.hiv_test_done is Null AND anc.number_of_anc_visits IS NOT Null THEN CONCAT_WS('-', anc.patient_id, anc.patient_name) end ) AS unknown_hivtestdone_anc_visit,

COUNT(DISTINCT CASE WHEN anc.hiv_test_result ILIKE 'negative' AND anc.hiv_test_done IS NOT Null THEN CONCAT_WS('-', anc.patient_id, anc.patient_name) end ) AS hivtestresult_negative,
COUNT(DISTINCT CASE WHEN anc.hiv_test_result ILIKE 'positive' AND anc.hiv_test_done IS NOT Null THEN CONCAT_WS('-', anc.patient_id, anc.patient_name) end ) AS hivtestresult_positive,
COUNT(DISTINCT CASE WHEN anc.hiv_test_result IS Null AND anc.hiv_test_done IS NOT Null THEN CONCAT_WS('-', anc.patient_id, anc.patient_name) end ) AS hivtestresult_unknown

from cht.mv_pregnancy anc
LEFT JOIN cht.regions_district AS t ON UPPER(anc.region) = UPPER(t.region)
WHERE anc.patient_gender = 'female'
AND anc.region IS NOT null
GROUP BY
    anc.region,
    anc.district,
    t.total_district,
    TO_CHAR(anc.reported::date, 'YYYY'),
    TO_CHAR(anc.reported::date, 'YYYY-"Q"Q'),
    TO_CHAR(anc.reported::date, 'YYYY-MM'),
    TO_CHAR(anc.reported::date, 'FMMM'),
    TO_CHAR(anc.reported::date, 'Month'),
    EXTRACT(QUARTER FROM anc.reported::date)
ORDER BY 
    anc.region,
    anc.district,
    TO_CHAR(anc.reported::date, 'YYYY'),
    TO_CHAR(anc.reported::date, 'YYYY-"Q"Q'),
    TO_CHAR(anc.reported::date, 'YYYY-MM'),
	TO_CHAR(anc.reported::date, 'FMMM'),
	TO_CHAR(anc.reported::date, 'Month'),
	EXTRACT(QUARTER FROM anc.reported::date)
),

regional_summary_anc as 
(
select
    
    INITCAP(anc.region) AS region_name,
    TO_CHAR(anc.reported::date, 'YYYY-MM') AS chwancvisit_month_year_ranc,
   
    STRING_AGG(DISTINCT UPPER(LEFT(anc.district, 1)) || LOWER(SUBSTRING(anc.district FROM 2)), ', ') AS districts_anc_list
from cht.mv_pregnancy anc
WHERE anc.patient_gender = 'female'
AND anc.region IS NOT null
GROUP BY
    anc.region,
    anc.district,
    TO_CHAR(anc.reported::date, 'YYYY-MM')
ORDER BY 
    anc.region,
    anc.district,
    TO_CHAR(anc.reported::date, 'YYYY-MM')
    
)

SELECT 
	COALESCE(dm.Region, anc.region_name) AS region,
	COALESCE(dm.District, anc.district_name) AS district,
	COALESCE(dm.delivery_year, anc.chwancvist_year) AS year,
	COALESCE(dm.delivery_quarter, anc.chwancvisit_quarter) AS delivery_quarter,
	COALESCE(dm.delivery_month_year, anc.chwancvisit_month_year) AS delivery_month_year,
	COALESCE(dm.delivery_month, anc.chwancvisit_month) AS month,
	COALESCE(dm.delivery_month_name, anc.chwancvisit_month_name) AS month_name,
	COALESCE(dm.quarter, anc.nochwancvisit_quarter) AS quarter,
	COALESCE(dm.total_district, anc.total_anc_districts) AS total_district,
	COALESCE(dm.Number_of_Districts, anc.number_of_districts) AS number_of_districts,
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
	dm.conducted_delivery_skilledHCP,
	dm.conducted_delivery_TBA,
	dm.conducted_delivery_unknown,
	dm.singleton_births,
	dm.Twin_births,
	dm.greater_than_two,
	dm.Preg_test_result_negative,
	dm.Preg_test_result_positive,
	dm.Preg_test_result_unknown,
	dm.Preg_test_result_Notcaptured,
	dm.Preg_test_pos_rate,
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
	dm.PNCvisit_within_24_hours,
	dm.PNCvisit_within_24_hours_7_days,
	dm.PNCvisit_7_days,
	dm.PNCvisit_none,
	dm.PNCvisit_unknown,
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
FULL OUTER JOIN regional_summary rs 
    ON dm.region = rs.region_name
    AND dm.delivery_month_year = rs.delivery_month_year
 FULL OUTER JOIN anc_summary anc
    ON COALESCE(dm.Region, rs.Region_name) = anc.region_name
    AND dm.district = anc.district_name
    AND COALESCE(dm.delivery_month_year, rs.delivery_month_year) = anc.chwancvisit_month_year
FULL OUTER JOIN regional_summary_anc ranc 
    ON anc.region_name = ranc.region_name
    AND anc.chwancvisit_month_year = ranc.chwancvisit_month_year_ranc
WHERE COALESCE(dm.Region, anc.region_name) IS NOT NULL
ORDER BY dm.delivery_month_year DESC, dm.region ASC

WITH data;
--grant permissions
GRANT UPDATE, TRUNCATE, TRIGGER, REFERENCES, INSERT, DELETE, SELECT ON TABLE cht.mv_delivery_report TO albert_fellow; 
GRANT UPDATE, TRUNCATE, TRIGGER, REFERENCES, INSERT, DELETE, SELECT ON TABLE cht.mv_delivery_report TO baker; 
GRANT UPDATE, TRUNCATE, TRIGGER, REFERENCES, INSERT, DELETE, SELECT ON TABLE cht.mv_delivery_report TO mkizito; 
GRANT UPDATE, TRUNCATE, TRIGGER, REFERENCES, INSERT, DELETE, SELECT ON TABLE cht.mv_delivery_report TO mpaul; 
GRANT UPDATE, TRUNCATE, TRIGGER, REFERENCES, INSERT, DELETE, SELECT ON TABLE cht.mv_delivery_report TO nmadrine; 
GRANT UPDATE, TRUNCATE, TRIGGER, REFERENCES, INSERT, DELETE, SELECT ON TABLE cht.mv_delivery_report TO rutayisire; 
GRANT UPDATE, TRUNCATE, TRIGGER, REFERENCES, INSERT, DELETE, SELECT ON TABLE cht.mv_delivery_report TO tom_fellow;