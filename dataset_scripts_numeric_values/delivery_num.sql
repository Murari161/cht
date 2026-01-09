INSERT INTO cht.fact_cht_numeric_values (
    uuid,
    theme,
    dataset,
    data_element,
    value,
    date,
    chw_id,
    facility_id,
    district_id,
    region,
    patient_age_in_years,
    patient_age_in_months,
    patient_age_in_days,
    patient_sex,
    patient_dob,
    source_system,
    source_form
)
SELECT
    uuid AS uuid,
    'maternal' AS theme,
    'delivery' AS dataset,
    unpivot.data_element,
    unpivot.value,
    date,
    chw_id,
    contact_facility_id AS facility_id,
    district AS district_id,
    region,
    patient_age_in_years,
    patient_age_in_months,
    patient_age_in_days,
    patient_gender AS patient_sex,
    contact_date_of_birth AS patient_dob,
    'cht' AS source_system,
    'delivery' AS source_form
FROM (
    SELECT
        uuid,
        date,
        chw_id,
        contact_facility_id,
        district,
        region,
        patient_age_in_years,
        patient_age_in_months,
        patient_age_in_days,
        patient_gender,
        contact_date_of_birth,

        -- indicator columns
        LOWER(TRIM(referred_for_nutrition_follow_up)) AS referred_for_nutrition_follow_up,
        LOWER(TRIM(woman_outcome)) AS woman_outcome,
        LOWER(TRIM(number_of_babies_delivered)) AS number_of_babies_delivered,
        LOWER(TRIM(number_of_babies_alive)) AS number_of_babies_alive,
        LOWER(TRIM(woman_danger_sign_fever)) AS woman_danger_sign_fever,
        LOWER(TRIM(woman_danger_sign_severe_headache)) AS woman_danger_sign_severe_headache,
        LOWER(TRIM(woman_danger_sign_vaginal_bleeding)) AS woman_danger_sign_vaginal_bleeding,
        LOWER(TRIM(woman_danger_sign_foul_vaginal_discharge)) AS woman_danger_sign_foul_vaginal_discharge,
        LOWER(TRIM(woman_danger_sign_convulsions)) AS woman_danger_sign_convulsions,
        LOWER(TRIM(has_danger_signs_woman)) AS has_danger_signs_woman,
        LOWER(TRIM(referred_woman_danger_signs)) AS referred_woman_danger_signs,
        LOWER(TRIM(woman_place_of_death)) AS woman_place_of_death,
        LOWER(TRIM(delivered_babies_before_dying)) AS delivered_babies_before_dying,
        LOWER(TRIM(has_danger_signs_baby)) AS has_danger_signs_baby,
        LOWER(TRIM(baby_danger_sign_fever)) AS baby_danger_sign_fever,
        LOWER(TRIM(baby_danger_sign_drowsy)) AS baby_danger_sign_drowsy,
        LOWER(TRIM(breastfed_within_one_hour)) AS breastfed_within_one_hour,
        LOWER(TRIM(baby_danger_sign_blue_skin)) AS baby_danger_sign_blue_skin,
        LOWER(TRIM(baby_danger_sign_yellow_skin)) AS baby_danger_sign_yellow_skin,
        LOWER(TRIM(is_exclusively_breast_feeding)) AS is_exclusively_breast_feeding,
        LOWER(TRIM(baby_danger_sign_body_stiffness)) AS baby_danger_sign_body_stiffness,
        LOWER(TRIM(baby_danger_sign_vomits_everything)) AS baby_danger_sign_vomits_everything,
        LOWER(TRIM(baby_danger_sign_infected_convulsions)) AS baby_danger_sign_infected_convulsions,
        LOWER(TRIM(baby_danger_sign_infected_umbilical_cord)) AS baby_danger_sign_infected_umbilical_cord,
        LOWER(TRIM(baby_danger_sign_infected_feeding_difficulty)) AS baby_danger_sign_infected_feeding_difficulty,
        LOWER(TRIM(delivery_place)) AS delivery_place,
        LOWER(TRIM(delivery_method)) AS delivery_method,
        LOWER(TRIM(who_conducted_delivery)) AS who_conducted_delivery,
        LOWER(TRIM(referred_to_health_facility_home_delivery)) AS referred_to_health_facility_home_delivery,
        LOWER(TRIM(baby_place_of_death)) AS baby_place_of_death,
        LOWER(TRIM(still_birth)) AS still_birth,
        LOWER(TRIM(taken_muac)) AS taken_muac,
        LOWER(TRIM(muac_measurement)) AS muac_measurement,
        LOWER(TRIM(referred_to_health_facility_nutrition)) AS referred_to_health_facility_nutrition,
        LOWER(TRIM(micro_nutrient_supplementation_received)) AS micro_nutrient_supplementation_received,
        LOWER(TRIM(referred_to_health_facility_no_micro_nutrient_supplementation)) AS referred_to_health_facility_no_micro_nutrient_supplementation,
        LOWER(TRIM(pnc_visits)) AS pnc_visits
    FROM cht.mv_delivery
) src
CROSS JOIN LATERAL (
    VALUES
        -- referred_for_nutrition_follow_up (yes/no)
        ('referred_for_nutrition_follow_up - Yes', CASE WHEN src.referred_for_nutrition_follow_up = 'yes' THEN 1 ELSE 0 END),
        ('referred_for_nutrition_follow_up - No', CASE WHEN src.referred_for_nutrition_follow_up = 'no' THEN 1 ELSE 0 END),

        -- woman_outcome (alive_well/dead)
        ('woman_outcome - Alive_well', CASE WHEN src.woman_outcome LIKE '%alive_well%' THEN 1 ELSE 0 END),
        ('woman_outcome - Dead', CASE WHEN src.woman_outcome LIKE '%dead%' THEN 1 ELSE 0 END),

        -- number_of_babies_delivered (0/1/2/3/4/5)
        ('number_of_babies_delivered - 0', CASE WHEN src.number_of_babies_delivered = '0' THEN 1 ELSE 0 END),
        ('number_of_babies_delivered - 1', CASE WHEN src.number_of_babies_delivered = '1' THEN 1 ELSE 0 END),
        ('number_of_babies_delivered - 2', CASE WHEN src.number_of_babies_delivered = '2' THEN 1 ELSE 0 END),
        ('number_of_babies_delivered - 3', CASE WHEN src.number_of_babies_delivered = '3' THEN 1 ELSE 0 END),
        ('number_of_babies_delivered - 4', CASE WHEN src.number_of_babies_delivered = '4' THEN 1 ELSE 0 END),
        ('number_of_babies_delivered - 5', CASE WHEN src.number_of_babies_delivered = '5' THEN 1 ELSE 0 END),

        -- number_of_babies_alive (0/1/2/3/4/5)
        ('number_of_babies_alive - 0', CASE WHEN src.number_of_babies_alive = '0' THEN 1 ELSE 0 END),
        ('number_of_babies_alive - 1', CASE WHEN src.number_of_babies_alive = '1' THEN 1 ELSE 0 END),
        ('number_of_babies_alive - 2', CASE WHEN src.number_of_babies_alive = '2' THEN 1 ELSE 0 END),
        ('number_of_babies_alive - 3', CASE WHEN src.number_of_babies_alive = '3' THEN 1 ELSE 0 END),
        ('number_of_babies_alive - 4', CASE WHEN src.number_of_babies_alive = '4' THEN 1 ELSE 0 END),
        ('number_of_babies_alive - 5', CASE WHEN src.number_of_babies_alive = '5' THEN 1 ELSE 0 END),

        -- woman_danger_sign_fever (yes/no)
        ('woman_danger_sign_fever - Yes', CASE WHEN src.woman_danger_sign_fever = 'yes' THEN 1 ELSE 0 END),
        ('woman_danger_sign_fever - No', CASE WHEN src.woman_danger_sign_fever = 'no' THEN 1 ELSE 0 END),

        -- woman_danger_sign_severe_headache (yes/no)
        ('woman_danger_sign_severe_headache - Yes', CASE WHEN src.woman_danger_sign_severe_headache = 'yes' THEN 1 ELSE 0 END),
        ('woman_danger_sign_severe_headache - No', CASE WHEN src.woman_danger_sign_severe_headache = 'no' THEN 1 ELSE 0 END),

        -- woman_danger_sign_vaginal_bleeding (yes/no)
        ('woman_danger_sign_vaginal_bleeding - Yes', CASE WHEN src.woman_danger_sign_vaginal_bleeding = 'yes' THEN 1 ELSE 0 END),
        ('woman_danger_sign_vaginal_bleeding - No', CASE WHEN src.woman_danger_sign_vaginal_bleeding = 'no' THEN 1 ELSE 0 END),

        -- woman_danger_sign_foul_vaginal_discharge (yes/no)
        ('woman_danger_sign_foul_vaginal_discharge - Yes', CASE WHEN src.woman_danger_sign_foul_vaginal_discharge = 'yes' THEN 1 ELSE 0 END),
        ('woman_danger_sign_foul_vaginal_discharge - No', CASE WHEN src.woman_danger_sign_foul_vaginal_discharge = 'no' THEN 1 ELSE 0 END),

        -- woman_danger_sign_convulsions (yes/no)
        ('woman_danger_sign_convulsions - Yes', CASE WHEN src.woman_danger_sign_convulsions = 'yes' THEN 1 ELSE 0 END),
        ('woman_danger_sign_convulsions - No', CASE WHEN src.woman_danger_sign_convulsions = 'no' THEN 1 ELSE 0 END),

        -- has_danger_signs_woman (yes/no)
        ('has_danger_signs_woman - Yes', CASE WHEN src.has_danger_signs_woman = 'yes' THEN 1 ELSE 0 END),
        ('has_danger_signs_woman - No', CASE WHEN src.has_danger_signs_woman = 'no' THEN 1 ELSE 0 END),

        -- referred_woman_danger_signs (yes)
        ('referred_woman_danger_signs - Yes', CASE WHEN src.referred_woman_danger_signs = 'yes' THEN 1 ELSE 0 END),

        -- woman_place_of_death (health_facility/home/other)
        ('woman_place_of_death - Health_facility', CASE WHEN src.woman_place_of_death LIKE '%health_facility%' THEN 1 ELSE 0 END),
        ('woman_place_of_death - Home', CASE WHEN src.woman_place_of_death LIKE '%home%' THEN 1 ELSE 0 END),
        ('woman_place_of_death - Other', CASE WHEN src.woman_place_of_death LIKE '%other%' THEN 1 ELSE 0 END),

        -- delivered_babies_before_dying (yes/no)
        ('delivered_babies_before_dying - Yes', CASE WHEN src.delivered_babies_before_dying = 'yes' THEN 1 ELSE 0 END),
        ('delivered_babies_before_dying - No', CASE WHEN src.delivered_babies_before_dying = 'no' THEN 1 ELSE 0 END),

        -- has_danger_signs_baby (assumed yes/no)
        ('has_danger_signs_baby - Yes', CASE WHEN src.has_danger_signs_baby = 'yes' THEN 1 ELSE 0 END),
        ('has_danger_signs_baby - No', CASE WHEN src.has_danger_signs_baby = 'no' THEN 1 ELSE 0 END),

        -- baby_danger_sign_fever (yes/no)
        ('baby_danger_sign_fever - Yes', CASE WHEN src.baby_danger_sign_fever = 'yes' THEN 1 ELSE 0 END),
        ('baby_danger_sign_fever - No', CASE WHEN src.baby_danger_sign_fever = 'no' THEN 1 ELSE 0 END),

        -- baby_danger_sign_drowsy (yes/no)
        ('baby_danger_sign_drowsy - Yes', CASE WHEN src.baby_danger_sign_drowsy = 'yes' THEN 1 ELSE 0 END),
        ('baby_danger_sign_drowsy - No', CASE WHEN src.baby_danger_sign_drowsy = 'no' THEN 1 ELSE 0 END),

        -- breastfed_within_one_hour (yes/no)
        ('breastfed_within_one_hour - Yes', CASE WHEN src.breastfed_within_one_hour = 'yes' THEN 1 ELSE 0 END),
        ('breastfed_within_one_hour - No', CASE WHEN src.breastfed_within_one_hour = 'no' THEN 1 ELSE 0 END),

        -- baby_danger_sign_blue_skin (yes/no)
        ('baby_danger_sign_blue_skin - Yes', CASE WHEN src.baby_danger_sign_blue_skin = 'yes' THEN 1 ELSE 0 END),
        ('baby_danger_sign_blue_skin - No', CASE WHEN src.baby_danger_sign_blue_skin = 'no' THEN 1 ELSE 0 END),

        -- baby_danger_sign_yellow_skin (yes/no)
        ('baby_danger_sign_yellow_skin - Yes', CASE WHEN src.baby_danger_sign_yellow_skin = 'yes' THEN 1 ELSE 0 END),
        ('baby_danger_sign_yellow_skin - No', CASE WHEN src.baby_danger_sign_yellow_skin = 'no' THEN 1 ELSE 0 END),

        -- is_exclusively_breast_feeding (yes/no)
        ('is_exclusively_breast_feeding - Yes', CASE WHEN src.is_exclusively_breast_feeding = 'yes' THEN 1 ELSE 0 END),
        ('is_exclusively_breast_feeding - No', CASE WHEN src.is_exclusively_breast_feeding = 'no' THEN 1 ELSE 0 END),

        -- baby_danger_sign_body_stiffness (yes/no)
        ('baby_danger_sign_body_stiffness - Yes', CASE WHEN src.baby_danger_sign_body_stiffness = 'yes' THEN 1 ELSE 0 END),
        ('baby_danger_sign_body_stiffness - No', CASE WHEN src.baby_danger_sign_body_stiffness = 'no' THEN 1 ELSE 0 END),

        -- baby_danger_sign_vomits_everything (yes/no)
        ('baby_danger_sign_vomits_everything - Yes', CASE WHEN src.baby_danger_sign_vomits_everything = 'yes' THEN 1 ELSE 0 END),
        ('baby_danger_sign_vomits_everything - No', CASE WHEN src.baby_danger_sign_vomits_everything = 'no' THEN 1 ELSE 0 END),

        -- baby_danger_sign_infected_convulsions (yes/no)
        ('baby_danger_sign_infected_convulsions - Yes', CASE WHEN src.baby_danger_sign_infected_convulsions = 'yes' THEN 1 ELSE 0 END),
        ('baby_danger_sign_infected_convulsions - No', CASE WHEN src.baby_danger_sign_infected_convulsions = 'no' THEN 1 ELSE 0 END),

        -- baby_danger_sign_infected_umbilical_cord (yes/no)
        ('baby_danger_sign_infected_umbilical_cord - Yes', CASE WHEN src.baby_danger_sign_infected_umbilical_cord = 'yes' THEN 1 ELSE 0 END),
        ('baby_danger_sign_infected_umbilical_cord - No', CASE WHEN src.baby_danger_sign_infected_umbilical_cord = 'no' THEN 1 ELSE 0 END),

        -- baby_danger_sign_infected_feeding_difficulty (yes/no)
        ('baby_danger_sign_infected_feeding_difficulty - Yes', CASE WHEN src.baby_danger_sign_infected_feeding_difficulty = 'yes' THEN 1 ELSE 0 END),
        ('baby_danger_sign_infected_feeding_difficulty - No', CASE WHEN src.baby_danger_sign_infected_feeding_difficulty = 'no' THEN 1 ELSE 0 END),

        -- delivery_place (health_facility/home/other)
        ('delivery_place - Health_facility', CASE WHEN src.delivery_place LIKE '%health_facility%' THEN 1 ELSE 0 END),
        ('delivery_place - Home', CASE WHEN src.delivery_place LIKE '%home%' THEN 1 ELSE 0 END),
        ('delivery_place - Other', CASE WHEN src.delivery_place LIKE '%other%' THEN 1 ELSE 0 END),

        -- delivery_method (normal/cesarean)
        ('delivery_method - Normal', CASE WHEN src.delivery_method LIKE '%normal%' THEN 1 ELSE 0 END),
        ('delivery_method - Cesarean', CASE WHEN src.delivery_method LIKE '%cesarean%' THEN 1 ELSE 0 END),

        -- who_conducted_delivery (skilled_health_care_provider/traditional_birth_attendant/other)
        ('who_conducted_delivery - Skilled_health_care_provider', CASE WHEN src.who_conducted_delivery LIKE '%skilled_health_care_provider%' THEN 1 ELSE 0 END),
        ('who_conducted_delivery - Traditional_birth_attendant', CASE WHEN src.who_conducted_delivery LIKE '%traditional_birth_attendant%' THEN 1 ELSE 0 END),
        ('who_conducted_delivery - Other', CASE WHEN src.who_conducted_delivery LIKE '%other%' THEN 1 ELSE 0 END),

        -- referred_to_health_facility_home_delivery (yes)
        ('referred_to_health_facility_home_delivery - Yes', CASE WHEN src.referred_to_health_facility_home_delivery = 'yes' THEN 1 ELSE 0 END),

        -- baby_place_of_death (health_facility/home/other)
        ('baby_place_of_death - Health_facility', CASE WHEN src.baby_place_of_death LIKE '%health_facility%' THEN 1 ELSE 0 END),
        ('baby_place_of_death - Home', CASE WHEN src.baby_place_of_death LIKE '%home%' THEN 1 ELSE 0 END),
        ('baby_place_of_death - Other', CASE WHEN src.baby_place_of_death LIKE '%other%' THEN 1 ELSE 0 END),

        -- still_birth (yes/no)
        ('still_birth - Yes', CASE WHEN src.still_birth = 'yes' THEN 1 ELSE 0 END),
        ('still_birth - No', CASE WHEN src.still_birth = 'no' THEN 1 ELSE 0 END),

        -- taken_muac (yes/no)
        ('taken_muac - Yes', CASE WHEN src.taken_muac = 'yes' THEN 1 ELSE 0 END),
        ('taken_muac - No', CASE WHEN src.taken_muac = 'no' THEN 1 ELSE 0 END),

        -- muac_measurement (red/yellow/green)
        ('muac_measurement - Red', CASE WHEN src.muac_measurement LIKE '%red%' THEN 1 ELSE 0 END),
        ('muac_measurement - Yellow', CASE WHEN src.muac_measurement LIKE '%yellow%' THEN 1 ELSE 0 END),
        ('muac_measurement - Green', CASE WHEN src.muac_measurement LIKE '%green%' THEN 1 ELSE 0 END),

        -- referred_to_health_facility_nutrition (yes)
        ('referred_to_health_facility_nutrition - Yes', CASE WHEN src.referred_to_health_facility_nutrition = 'yes' THEN 1 ELSE 0 END),

        -- micro_nutrient_supplementation_received (yes/no)
        ('micro_nutrient_supplementation_received - Yes', CASE WHEN src.micro_nutrient_supplementation_received = 'yes' THEN 1 ELSE 0 END),
        ('micro_nutrient_supplementation_received - No', CASE WHEN src.micro_nutrient_supplementation_received = 'no' THEN 1 ELSE 0 END),

        -- referred_to_health_facility_no_micro_nutrient_supplementation (yes)
        ('referred_to_health_facility_no_micro_nutrient_supplementation - Yes', CASE WHEN src.referred_to_health_facility_no_micro_nutrient_supplementation = 'yes' THEN 1 ELSE 0 END),

        -- pnc_visits (within_24_hours/7_days/6_weeks/none/within_24_hours 7_days/within_24_hours 7_days 6_weeks)
        ('pnc_visits - Within_24_hours', CASE WHEN src.pnc_visits LIKE '%within_24_hours%' THEN 1 ELSE 0 END),
        ('pnc_visits - 7_days', CASE WHEN src.pnc_visits LIKE '%7_days%' THEN 1 ELSE 0 END),
        ('pnc_visits - 6_weeks', CASE WHEN src.pnc_visits LIKE '%6_weeks%' THEN 1 ELSE 0 END),
        ('pnc_visits - None', CASE WHEN src.pnc_visits LIKE '%none%' THEN 1 ELSE 0 END),
        ('pnc_visits - Within_24_hours and 7_days', CASE WHEN src.pnc_visits = 'within_24_hours 7_days' THEN 1 ELSE 0 END),
        ('pnc_visits - Within_24_hours and 7_daysand 6_weeks', CASE WHEN src.pnc_visits = 'within_24_hours 7_days 6_weeks' THEN 1 ELSE 0 END)
) AS unpivot(data_element, value)
WHERE value = 1;