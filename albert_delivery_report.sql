create materialized view delivery_report
TABLESPACE ts_report
as
SELECT
    UPPER(LEFT(d.region, 1)) || LOWER(SUBSTRING(d.region FROM 2)) as Region_name,
    UPPER(LEFT(d.district, 1)) || LOWER(SUBSTRING(d.district FROM 2)) as District_name,
    d.delivery_date,
    d."month",
    d."year",
    t.total_district,
    TO_CHAR(d.delivery_date::date, 'YYYY-MM') AS delivery_month_year,
    TO_CHAR(d.delivery_date::date, 'YYYY-"Q"Q') AS delivery_quarter,
    TO_CHAR(d.delivery_date::date, 'MM') AS delivery_month,

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

    COUNT(DISTINCT CASE WHEN d.is_of_child_bearing_age = 'false' THEN CONCAT_WS('-', d.mother_id, d.family_id) END) AS isnot_child_bearing_age,
    
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
    WHEN d.number_of_babies_delivered::integer= 1 THEN 1 
    ELSE 0 
END) AS singleton_births,

SUM(CASE 
    WHEN d.number_of_babies_delivered::integer = 2 THEN 1 
    ELSE 0 
END) AS Twin_births,

SUM(CASE 
    WHEN d.number_of_babies_delivered::integer > 2 THEN 1 
    ELSE 0 
END) AS greater_than_two,

COUNT(DISTINCT CASE WHEN d.pregnancy_hiv_test_result = 'negative' THEN CONCAT_WS('-', d.mother_id, d.family_id) END) AS Preg_test_result_negative,
COUNT(DISTINCT CASE WHEN d.pregnancy_hiv_test_result = 'positive' THEN CONCAT_WS('-', d.mother_id, d.family_id) END) AS Preg_test_result_positive,
COUNT(DISTINCT CASE WHEN d.pregnancy_hiv_test_result = 'unknown' THEN CONCAT_WS('-', d.mother_id, d.family_id) END) AS Preg_test_result_unknown,
COUNT(DISTINCT CASE WHEN d.pregnancy_hiv_test_result IS NULL THEN CONCAT_WS('-', d.mother_id, d.family_id) END) AS Preg_test_result_Notcaptured,

COUNT(DISTINCT CASE WHEN d.woman_outcome = 'alive_well' THEN CONCAT_WS('-', d.mother_id, d.family_id) END) AS woman_alive_well,
COUNT(DISTINCT CASE WHEN d.woman_outcome = 'alive_unwell' THEN CONCAT_WS('-', d.mother_id, d.family_id) END) AS woman_alive_unwell,
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
END) AS not_child_bearing_age


FROM cht.mv_delivery d
LEFT JOIN cht.regions_district AS t ON UPPER(d.region) = UPPER(t.region)
WHERE d.patient_gender = 'female'
  AND d.delivery_date IS NOT NULL
GROUP BY
    d.region,
    d.district, 
    d."month",
    d.delivery_date, 
    d."year", 
    t.total_district,
    TO_CHAR(d.delivery_date::date, 'YYYY-MM')
ORDER BY 
    CASE WHEN d.region = 'Region not selected' THEN 1 ELSE 0 END,
    d.region,
    d.district,
 	d.delivery_date
    with data;