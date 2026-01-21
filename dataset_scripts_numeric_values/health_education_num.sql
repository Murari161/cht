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
    'he' AS theme,
    'health_education' AS dataset,
    unpivot.data_element,
    unpivot.value,
    date,
    chw_id,
    contact_facility_id AS facility_id,
    district_id AS district_id,
    region_id AS region,
    NULL AS patient_age_in_years,
    NULL AS patient_age_in_months,
    NULL AS patient_age_in_days,
    NULL AS patient_sex,
    NULL AS patient_dob,
    'cht' AS source_system,
    'health_education' AS source_form
FROM (
    SELECT
        uuid,
        date,
        chw_id,
        contact_facility_id,
        district_id,
        region_id,

        -- indicator columns (categorical and numeric)
        LOWER(TRIM(needs_signoff)) AS needs_signoff,
        LOWER(TRIM(selected_village_venue)) AS selected_village_venue,
        LOWER(TRIM(fields_geolocation_want_to_capture_gps)) AS fields_geolocation_want_to_capture_gps,
        LOWER(TRIM(fields_geolocation_gps_capture_checklist)) AS fields_geolocation_gps_capture_checklist,
        LOWER(TRIM(fields_geolocation_gps_capture_checklist_completed)) AS fields_geolocation_gps_capture_checklist_completed,
        LOWER(TRIM(he_topics_covered)) AS he_topics_covered,
        LOWER(TRIM(g_wash_topic_wash_priorities)) AS g_wash_topic_wash_priorities,
        LOWER(TRIM(g_nutrition_promotion_topic_nutrition_practices)) AS g_nutrition_promotion_topic_nutrition_practices,
        LOWER(TRIM(g_non_communicable_diseases_topic_non_communicable_diseases_facts)) AS g_non_communicable_diseases_topic_non_communicable_diseases_facts,
        LOWER(TRIM(g_leprosy_topic_leprosy_facts)) AS g_leprosy_topic_leprosy_facts,
        LOWER(TRIM(g_malaria_topic_malaria_facts)) AS g_malaria_topic_malaria_facts,
        LOWER(TRIM(g_hiv_aids_topic_hiv_aids_facts)) AS g_hiv_aids_topic_hiv_aids_facts,
        LOWER(TRIM(g_tb_topic_tb_facts)) AS g_tb_topic_tb_facts,
        LOWER(TRIM(g_maternal_health_topic_maternal_health_facts)) AS g_maternal_health_topic_maternal_health_facts,
        LOWER(TRIM(g_child_health_topic_child_health_facts)) AS g_child_health_topic_child_health_facts,
        g_wash_topic_nb_attendee_wash,
        g_nutrition_promotion_topic_nb_attendee_food_promotion,
        g_non_communicable_diseases_topic_nb_attendee_commun_diseases,
        g_leprosy_topic_nb_attendee_leprosy,
        g_malaria_topic_nb_attendee_malaria,
        g_hiv_aids_topic_nb_attendee_hiv,
        g_tb_topic_nb_attendee_tb,
        g_maternal_health_topic_nb_attendee_maternal_health,
        g_child_health_topic_nb_attendee_child_health,
        g_other_topic_nb_attendee_other_topic
    FROM cht.mv_health_education_new
) src
CROSS JOIN LATERAL (
    VALUES
        -- needs_signoff (true) - binary
        ('needs_signoff - True', CASE WHEN src.needs_signoff = 'true' THEN 1 ELSE 0 END),

        -- selected_village_venue (village/health_facility) - binary
        ('selected_village_venue - Village', CASE WHEN src.selected_village_venue LIKE '%village%' THEN 1 ELSE 0 END),
        ('selected_village_venue - Health_facility', CASE WHEN src.selected_village_venue LIKE '%health_facility%' THEN 1 ELSE 0 END),

        -- fields_geolocation_want_to_capture_gps (yes/no) - binary
        ('fields_geolocation_want_to_capture_gps - Yes', CASE WHEN src.fields_geolocation_want_to_capture_gps = 'yes' THEN 1 ELSE 0 END),
        ('fields_geolocation_want_to_capture_gps - No', CASE WHEN src.fields_geolocation_want_to_capture_gps = 'no' THEN 1 ELSE 0 END),

        -- fields_geolocation_gps_capture_checklist (enable_gps/clear_view_on_sky/at_household_village) - binary
        ('fields_geolocation_gps_capture_checklist - Enable_gps', CASE WHEN src.fields_geolocation_gps_capture_checklist LIKE '%enable_gps%' THEN 1 ELSE 0 END),
        ('fields_geolocation_gps_capture_checklist - Clear_view_on_sky', CASE WHEN src.fields_geolocation_gps_capture_checklist LIKE '%clear_view_on_sky%' THEN 1 ELSE 0 END),
        ('fields_geolocation_gps_capture_checklist - At_household_village', CASE WHEN src.fields_geolocation_gps_capture_checklist LIKE '%at_household_village%' THEN 1 ELSE 0 END),

        -- fields_geolocation_gps_capture_checklist_completed (true/false) - binary
        ('fields_geolocation_gps_capture_checklist_completed - True', CASE WHEN src.fields_geolocation_gps_capture_checklist_completed = 'true' THEN 1 ELSE 0 END),
        ('fields_geolocation_gps_capture_checklist_completed - False', CASE WHEN src.fields_geolocation_gps_capture_checklist_completed = 'false' THEN 1 ELSE 0 END),

        -- he_topics_covered (wash/food_good_nutrition_promotion/non_communicable_diseases/leprosy/malaria/hiv_aids/tb/maternal_health/child_health/others) - binary
        ('he_topics_covered - Wash', CASE WHEN src.he_topics_covered LIKE '%wash%' THEN 1 ELSE 0 END),
        ('he_topics_covered - Food_good_nutrition_promotion', CASE WHEN src.he_topics_covered LIKE '%food_good_nutrition_promotion%' THEN 1 ELSE 0 END),
        ('he_topics_covered - Non_communicable_diseases', CASE WHEN src.he_topics_covered LIKE '%non_communicable_diseases%' THEN 1 ELSE 0 END),
        ('he_topics_covered - Leprosy', CASE WHEN src.he_topics_covered LIKE '%leprosy%' THEN 1 ELSE 0 END),
        ('he_topics_covered - Malaria', CASE WHEN src.he_topics_covered LIKE '%malaria%' THEN 1 ELSE 0 END),
        ('he_topics_covered - Hiv_aids', CASE WHEN src.he_topics_covered LIKE '%hiv_aids%' THEN 1 ELSE 0 END),
        ('he_topics_covered - Tb', CASE WHEN src.he_topics_covered LIKE '%tb%' THEN 1 ELSE 0 END),
        ('he_topics_covered - Maternal_health', CASE WHEN src.he_topics_covered LIKE '%maternal_health%' THEN 1 ELSE 0 END),
        ('he_topics_covered - Child_health', CASE WHEN src.he_topics_covered LIKE '%child_health%' THEN 1 ELSE 0 END),
        ('he_topics_covered - Others', CASE WHEN src.he_topics_covered LIKE '%others%' THEN 1 ELSE 0 END),

        -- g_wash_topic_wash_priorities (keep_water_safe_clean/dispose_wastes_safety/wash_hands_stay_healthy/keep_utensils_clean_place/ensure_safe_environment) - binary
        ('g_wash_topic_wash_priorities - Keep_water_safe_clean', CASE WHEN src.g_wash_topic_wash_priorities LIKE '%keep_water_safe_clean%' THEN 1 ELSE 0 END),
        ('g_wash_topic_wash_priorities - Dispose_wastes_safety', CASE WHEN src.g_wash_topic_wash_priorities LIKE '%dispose_wastes_safety%' THEN 1 ELSE 0 END),
        ('g_wash_topic_wash_priorities - Wash_hands_stay_healthy', CASE WHEN src.g_wash_topic_wash_priorities LIKE '%wash_hands_stay_healthy%' THEN 1 ELSE 0 END),
        ('g_wash_topic_wash_priorities - Keep_utensils_clean_place', CASE WHEN src.g_wash_topic_wash_priorities LIKE '%keep_utensils_clean_place%' THEN 1 ELSE 0 END),
        ('g_wash_topic_wash_priorities - Ensure_safe_environment', CASE WHEN src.g_wash_topic_wash_priorities LIKE '%ensure_safe_environment%' THEN 1 ELSE 0 END),

        -- g_nutrition_promotion_topic_nutrition_practices (importance_good_nutrition/balanced_diet/nutrition_requirements/importance_back_yard_garden/safe_food_handling_and_preparation) - binary
        ('g_nutrition_promotion_topic_nutrition_practices - Importance_good_nutrition', CASE WHEN src.g_nutrition_promotion_topic_nutrition_practices LIKE '%importance_good_nutrition%' THEN 1 ELSE 0 END),
        ('g_nutrition_promotion_topic_nutrition_practices - Balanced_diet', CASE WHEN src.g_nutrition_promotion_topic_nutrition_practices LIKE '%balanced_diet%' THEN 1 ELSE 0 END),
        ('g_nutrition_promotion_topic_nutrition_practices - Nutrition_requirements', CASE WHEN src.g_nutrition_promotion_topic_nutrition_practices LIKE '%nutrition_requirements%' THEN 1 ELSE 0 END),
        ('g_nutrition_promotion_topic_nutrition_practices - Importance_back_yard_garden', CASE WHEN src.g_nutrition_promotion_topic_nutrition_practices LIKE '%importance_back_yard_garden%' THEN 1 ELSE 0 END),
        ('g_nutrition_promotion_topic_nutrition_practices - Safe_food_handling_and_preparation', CASE WHEN src.g_nutrition_promotion_topic_nutrition_practices LIKE '%safe_food_handling_and_preparation%' THEN 1 ELSE 0 END),

        -- g_non_communicable_diseases_topic_non_communicable_diseases_facts (cardio_disease_definition/cardio_symptoms/sudden_cardio_symptoms/cardio_prevention/high_bp_definition/high_bp_control/community_bp_control/hypertension_prevention/stroke_definition/stroke_risk_factors/stroke_symptoms/stroke_prevention/diabetes_definition/diabetes_symptoms/diabetes_risk_factors/diabetes_prevention/low_sugar_signs/diabetes_control/copd_definition/copd_symptoms/copd_causes/copd_prevention/asthma_definition/asthma_symptoms/asthma_management/sickle_cell_definition/sickle_cell_prevention/cervical_cancer_definition/cervical_cancer_risks/cervical_cancer_symptoms/cervical_cancer_prevention/breast_cancer_definition/breast_cancer_risks/breast_cancer_symptoms/breast_cancer_prevention/kaposi_sarcoma_definition/kaposi_sarcoma_symptoms/kaposi_sarcoma_prevention/prostate_cancer_definition/prostate_cancer_risks/prostate_cancer_symptoms/prostate_cancer_management/mental_health_definition/mental_health_signs/mental_health_causes/mental_health_care/mental_health_prevention/substance_disorder_definition/substance_disorder_causes/common_abused_substances/substance_abuse_prevention/substance_abuse_prevention_parents/oral_health_definition/oral_problem_signs/dental_problem_solution/road_injuries_definition/road_injury_prevention/snake_bite_symptoms/snake_bite_prevention/snake_bite_first_aid/dog_bite_prevention/dog_bite_aid/drowning_definition/drowning_prevention) - binary
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Cardio_disease_definition', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%cardio_disease_definition%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Cardio_symptoms', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%cardio_symptoms%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Sudden_cardio_symptoms', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%sudden_cardio_symptoms%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Cardio_prevention', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%cardio_prevention%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - High_bp_definition', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%high_bp_definition%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - High_bp_control', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%high_bp_control%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Community_bp_control', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%community_bp_control%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Hypertension_prevention', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%hypertension_prevention%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Stroke_definition', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%stroke_definition%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Stroke_risk_factors', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%stroke_risk_factors%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Stroke_symptoms', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%stroke_symptoms%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Stroke_prevention', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%stroke_prevention%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Diabetes_definition', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%diabetes_definition%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Diabetes_symptoms', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%diabetes_symptoms%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Diabetes_risk_factors', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%diabetes_risk_factors%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Diabetes_prevention', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%diabetes_prevention%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Low_sugar_signs', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%low_sugar_signs%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Diabetes_control', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%diabetes_control%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Copd_definition', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%copd_definition%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Copd_symptoms', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%copd_symptoms%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Copd_causes', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%copd_causes%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Copd_prevention', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%copd_prevention%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Asthma_definition', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%asthma_definition%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Asthma_symptoms', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%asthma_symptoms%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Asthma_management', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%asthma_management%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Sickle_cell_definition', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%sickle_cell_definition%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Sickle_cell_prevention', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%sickle_cell_prevention%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Cervical_cancer_definition', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%cervical_cancer_definition%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Cervical_cancer_risks', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%cervical_cancer_risks%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Cervical_cancer_symptoms', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%cervical_cancer_symptoms%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Cervical_cancer_prevention', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%cervical_cancer_prevention%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Breast_cancer_definition', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%breast_cancer_definition%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Breast_cancer_risks', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%breast_cancer_risks%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Breast_cancer_symptoms', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%breast_cancer_symptoms%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Breast_cancer_prevention', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%breast_cancer_prevention%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Kaposi_sarcoma_definition', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%kaposi_sarcoma_definition%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Kaposi_sarcoma_symptoms', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%kaposi_sarcoma_symptoms%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Kaposi_sarcoma_prevention', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%kaposi_sarcoma_prevention%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Prostate_cancer_definition', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%prostate_cancer_definition%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Prostate_cancer_risks', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%prostate_cancer_risks%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Prostate_cancer_symptoms', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%prostate_cancer_symptoms%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Prostate_cancer_management', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%prostate_cancer_management%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Mental_health_definition', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%mental_health_definition%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Mental_health_signs', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%mental_health_signs%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Mental_health_causes', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%mental_health_causes%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Mental_health_care', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%mental_health_care%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Mental_health_prevention', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%mental_health_prevention%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Substance_disorder_definition', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%substance_disorder_definition%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Substance_disorder_causes', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%substance_disorder_causes%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Common_abused_substances', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%common_abused_substances%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Substance_abuse_prevention', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%substance_abuse_prevention%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Substance_abuse_prevention_parents', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%substance_abuse_prevention_parents%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Oral_health_definition', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%oral_health_definition%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Oral_problem_signs', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%oral_problem_signs%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Dental_problem_solution', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%dental_problem_solution%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Road_injuries_definition', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%road_injuries_definition%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Road_injury_prevention', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%road_injury_prevention%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Snake_bite_symptoms', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%snake_bite_symptoms%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Snake_bite_prevention', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%snake_bite_prevention%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Snake_bite_first_aid', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%snake_bite_first_aid%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Dog_bite_prevention', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%dog_bite_prevention%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Dog_bite_aid', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%dog_bite_aid%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Drowning_definition', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%drowning_definition%' THEN 1 ELSE 0 END),
        ('g_non_communicable_diseases_topic_non_communicable_diseases_facts - Drowning_prevention', CASE WHEN src.g_non_communicable_diseases_topic_non_communicable_diseases_facts LIKE '%drowning_prevention%' THEN 1 ELSE 0 END),

        -- g_leprosy_topic_leprosy_facts (leprosy_definition/leprosy_symptoms/leprosy_transmission/leprosy_diagnosis/adherence_to_leprosy_treatment/leprosy_elimination) - binary
        ('g_leprosy_topic_leprosy_facts - Leprosy_definition', CASE WHEN src.g_leprosy_topic_leprosy_facts LIKE '%leprosy_definition%' THEN 1 ELSE 0 END),
        ('g_leprosy_topic_leprosy_facts - Leprosy_symptoms', CASE WHEN src.g_leprosy_topic_leprosy_facts LIKE '%leprosy_symptoms%' THEN 1 ELSE 0 END),
        ('g_leprosy_topic_leprosy_facts - Leprosy_transmission', CASE WHEN src.g_leprosy_topic_leprosy_facts LIKE '%leprosy_transmission%' THEN 1 ELSE 0 END),
        ('g_leprosy_topic_leprosy_facts - Leprosy_diagnosis', CASE WHEN src.g_leprosy_topic_leprosy_facts LIKE '%leprosy_diagnosis%' THEN 1 ELSE 0 END),
        ('g_leprosy_topic_leprosy_facts - Adherence_to_leprosy_treatment', CASE WHEN src.g_leprosy_topic_leprosy_facts LIKE '%adherence_to_leprosy_treatment%' THEN 1 ELSE 0 END),
        ('g_leprosy_topic_leprosy_facts - Leprosy_elimination', CASE WHEN src.g_leprosy_topic_leprosy_facts LIKE '%leprosy_elimination%' THEN 1 ELSE 0 END),

        -- g_malaria_topic_malaria_facts (malaria_definition/malaria_risk_transmission/malaria_symptoms/malaria_prevention/malaria_action_fever/myths_and_misconceptions/malaria_prevention_actions) - binary
        ('g_malaria_topic_malaria_facts - Malaria_definition', CASE WHEN src.g_malaria_topic_malaria_facts LIKE '%malaria_definition%' THEN 1 ELSE 0 END),
        ('g_malaria_topic_malaria_facts - Malaria_risk_transmission', CASE WHEN src.g_malaria_topic_malaria_facts LIKE '%malaria_risk_transmission%' THEN 1 ELSE 0 END),
        ('g_malaria_topic_malaria_facts - Malaria_symptoms', CASE WHEN src.g_malaria_topic_malaria_facts LIKE '%malaria_symptoms%' THEN 1 ELSE 0 END),
        ('g_malaria_topic_malaria_facts - Malaria_prevention', CASE WHEN src.g_malaria_topic_malaria_facts LIKE '%malaria_prevention%' THEN 1 ELSE 0 END),
        ('g_malaria_topic_malaria_facts - Malaria_action_fever', CASE WHEN src.g_malaria_topic_malaria_facts LIKE '%malaria_action_fever%' THEN 1 ELSE 0 END),
        ('g_malaria_topic_malaria_facts - Myths_and_misconceptions', CASE WHEN src.g_malaria_topic_malaria_facts LIKE '%myths_and_misconceptions%' THEN 1 ELSE 0 END),
        ('g_malaria_topic_malaria_facts - Malaria_prevention_actions', CASE WHEN src.g_malaria_topic_malaria_facts LIKE '%malaria_prevention_actions%' THEN 1 ELSE 0 END),

        -- g_hiv_aids_topic_hiv_aids_facts (hiv_aids_definition/hiv_infection_prevention/hiv_vertical_transmission/hiv_symptoms/hiv_management/myths_and_misconceptions_hiv/) - binary
        ('g_hiv_aids_topic_hiv_aids_facts - Hiv_aids_definition', CASE WHEN src.g_hiv_aids_topic_hiv_aids_facts LIKE '%hiv_aids_definition%' THEN 1 ELSE 0 END),
        ('g_hiv_aids_topic_hiv_aids_facts - Hiv_infection_prevention', CASE WHEN src.g_hiv_aids_topic_hiv_aids_facts LIKE '%hiv_infection_prevention%' THEN 1 ELSE 0 END),
        ('g_hiv_aids_topic_hiv_aids_facts - Hiv_vertical_transmission', CASE WHEN src.g_hiv_aids_topic_hiv_aids_facts LIKE '%hiv_vertical_transmission%' THEN 1 ELSE 0 END),
        ('g_hiv_aids_topic_hiv_aids_facts - Hiv_symptoms', CASE WHEN src.g_hiv_aids_topic_hiv_aids_facts LIKE '%hiv_symptoms%' THEN 1 ELSE 0 END),
        ('g_hiv_aids_topic_hiv_aids_facts - Hiv_management', CASE WHEN src.g_hiv_aids_topic_hiv_aids_facts LIKE '%hiv_management%' THEN 1 ELSE 0 END),
        ('g_hiv_aids_topic_hiv_aids_facts - Myths_and_misconceptions_hiv', CASE WHEN src.g_hiv_aids_topic_hiv_aids_facts LIKE '%myths_and_misconceptions_hiv%' THEN 1 ELSE 0 END),

        -- g_tb_topic_tb_facts (tb_definition/tb_transmission/tb_symptoms/tb_treatment/tb_prevention) - binary
        ('g_tb_topic_tb_facts - Tb_definition', CASE WHEN src.g_tb_topic_tb_facts LIKE '%tb_definition%' THEN 1 ELSE 0 END),
        ('g_tb_topic_tb_facts - Tb_transmission', CASE WHEN src.g_tb_topic_tb_facts LIKE '%tb_transmission%' THEN 1 ELSE 0 END),
        ('g_tb_topic_tb_facts - Tb_symptoms', CASE WHEN src.g_tb_topic_tb_facts LIKE '%tb_symptoms%' THEN 1 ELSE 0 END),
        ('g_tb_topic_tb_facts - Tb_treatment', CASE WHEN src.g_tb_topic_tb_facts LIKE '%tb_treatment%' THEN 1 ELSE 0 END),
        ('g_tb_topic_tb_facts - Tb_prevention', CASE WHEN src.g_tb_topic_tb_facts LIKE '%tb_prevention%' THEN 1 ELSE 0 END),

        -- g_maternal_health_topic_maternal_health_facts (pregnancy_signs/pregnancy_care/antenatal_visits/pregnancy_nutrition/high_risk_factors/pregnancy_common_problems/pregnancy_danger_signs/hiv_protection_for_babies/myths_and_misconceptions_pregnancy/birth_plan/labor_guidance/postpartum_care/postpartum_nutrition/breastfeeding_timing/postpartum_danger_signs/family_planning) - binary
        ('g_maternal_health_topic_maternal_health_facts - Pregnancy_signs', CASE WHEN src.g_maternal_health_topic_maternal_health_facts LIKE '%pregnancy_signs%' THEN 1 ELSE 0 END),
        ('g_maternal_health_topic_maternal_health_facts - Pregnancy_care', CASE WHEN src.g_maternal_health_topic_maternal_health_facts LIKE '%pregnancy_care%' THEN 1 ELSE 0 END),
        ('g_maternal_health_topic_maternal_health_facts - Antenatal_visits', CASE WHEN src.g_maternal_health_topic_maternal_health_facts LIKE '%antenatal_visits%' THEN 1 ELSE 0 END),
        ('g_maternal_health_topic_maternal_health_facts - Pregnancy_nutrition', CASE WHEN src.g_maternal_health_topic_maternal_health_facts LIKE '%pregnancy_nutrition%' THEN 1 ELSE 0 END),
        ('g_maternal_health_topic_maternal_health_facts - High_risk_factors', CASE WHEN src.g_maternal_health_topic_maternal_health_facts LIKE '%high_risk_factors%' THEN 1 ELSE 0 END),
        ('g_maternal_health_topic_maternal_health_facts - Pregnancy_common_problems', CASE WHEN src.g_maternal_health_topic_maternal_health_facts LIKE '%pregnancy_common_problems%' THEN 1 ELSE 0 END),
        ('g_maternal_health_topic_maternal_health_facts - Pregnancy_danger_signs', CASE WHEN src.g_maternal_health_topic_maternal_health_facts LIKE '%pregnancy_danger_signs%' THEN 1 ELSE 0 END),
        ('g_maternal_health_topic_maternal_health_facts - Hiv_protection_for_babies', CASE WHEN src.g_maternal_health_topic_maternal_health_facts LIKE '%hiv_protection_for_babies%' THEN 1 ELSE 0 END),
        ('g_maternal_health_topic_maternal_health_facts - Myths_and_misconceptions_pregnancy', CASE WHEN src.g_maternal_health_topic_maternal_health_facts LIKE '%myths_and_misconceptions_pregnancy%' THEN 1 ELSE 0 END),
        ('g_maternal_health_topic_maternal_health_facts - Birth_plan', CASE WHEN src.g_maternal_health_topic_maternal_health_facts LIKE '%birth_plan%' THEN 1 ELSE 0 END),
        ('g_maternal_health_topic_maternal_health_facts - Labor_guidance', CASE WHEN src.g_maternal_health_topic_maternal_health_facts LIKE '%labor_guidance%' THEN 1 ELSE 0 END),
        ('g_maternal_health_topic_maternal_health_facts - Postpartum_care', CASE WHEN src.g_maternal_health_topic_maternal_health_facts LIKE '%postpartum_care%' THEN 1 ELSE 0 END),
        ('g_maternal_health_topic_maternal_health_facts - Postpartum_nutrition', CASE WHEN src.g_maternal_health_topic_maternal_health_facts LIKE '%postpartum_nutrition%' THEN 1 ELSE 0 END),
        ('g_maternal_health_topic_maternal_health_facts - Breastfeeding_timing', CASE WHEN src.g_maternal_health_topic_maternal_health_facts LIKE '%breastfeeding_timing%' THEN 1 ELSE 0 END),
        ('g_maternal_health_topic_maternal_health_facts - Postpartum_danger_signs', CASE WHEN src.g_maternal_health_topic_maternal_health_facts LIKE '%postpartum_danger_signs%' THEN 1 ELSE 0 END),
        ('g_maternal_health_topic_maternal_health_facts - Family_planning', CASE WHEN src.g_maternal_health_topic_maternal_health_facts LIKE '%family_planning%' THEN 1 ELSE 0 END),

        -- g_child_health_topic_child_health_facts (newborn_care/birth_cleanliness/newborn_warmth/newborn_eye_care/newborn_danger_signs/breastfeeding_importance/immunization_def/immunization_schedule/myths_and_misconceptions_child_health) - binary
        ('g_child_health_topic_child_health_facts - Newborn_care', CASE WHEN src.g_child_health_topic_child_health_facts LIKE '%newborn_care%' THEN 1 ELSE 0 END),
        ('g_child_health_topic_child_health_facts - Birth_cleanliness', CASE WHEN src.g_child_health_topic_child_health_facts LIKE '%birth_cleanliness%' THEN 1 ELSE 0 END),
        ('g_child_health_topic_child_health_facts - Newborn_warmth', CASE WHEN src.g_child_health_topic_child_health_facts LIKE '%newborn_warmth%' THEN 1 ELSE 0 END),
        ('g_child_health_topic_child_health_facts - Newborn_eye_care', CASE WHEN src.g_child_health_topic_child_health_facts LIKE '%newborn_eye_care%' THEN 1 ELSE 0 END),
        ('g_child_health_topic_child_health_facts - Newborn_danger_signs', CASE WHEN src.g_child_health_topic_child_health_facts LIKE '%newborn_danger_signs%' THEN 1 ELSE 0 END),
        ('g_child_health_topic_child_health_facts - Breastfeeding_importance', CASE WHEN src.g_child_health_topic_child_health_facts LIKE '%breastfeeding_importance%' THEN 1 ELSE 0 END),
        ('g_child_health_topic_child_health_facts - Immunization_def', CASE WHEN src.g_child_health_topic_child_health_facts LIKE '%immunization_def%' THEN 1 ELSE 0 END),
        ('g_child_health_topic_child_health_facts - Immunization_schedule', CASE WHEN src.g_child_health_topic_child_health_facts LIKE '%immunization_schedule%' THEN 1 ELSE 0 END),
        ('g_child_health_topic_child_health_facts - Myths_and_misconceptions_child_health', CASE WHEN src.g_child_health_topic_child_health_facts LIKE '%myths_and_misconceptions_child_health%' THEN 1 ELSE 0 END),

        -- g_wash_topic_nb_attendee_wash (int) - numeric, null to 0
        ('g_wash_topic_nb_attendee_wash', COALESCE(src.g_wash_topic_nb_attendee_wash, 0)),

        -- g_nutrition_promotion_topic_nb_attendee_food_promotion (int) - numeric, null to 0
        ('g_nutrition_promotion_topic_nb_attendee_food_promotion', COALESCE(src.g_nutrition_promotion_topic_nb_attendee_food_promotion, 0)),

        -- g_non_communicable_diseases_topic_nb_attendee_commun_diseases (int) - numeric, null to 0
        ('g_non_communicable_diseases_topic_nb_attendee_commun_diseases', COALESCE(src.g_non_communicable_diseases_topic_nb_attendee_commun_diseases, 0)),

        -- g_leprosy_topic_nb_attendee_leprosy (int) - numeric, null to 0
        ('g_leprosy_topic_nb_attendee_leprosy', COALESCE(src.g_leprosy_topic_nb_attendee_leprosy, 0)),

        -- g_malaria_topic_nb_attendee_malaria (int) - numeric, null to 0
        ('g_malaria_topic_nb_attendee_malaria', COALESCE(src.g_malaria_topic_nb_attendee_malaria, 0)),

        -- g_hiv_aids_topic_nb_attendee_hiv (int) - numeric, null to 0
        ('g_hiv_aids_topic_nb_attendee_hiv', COALESCE(src.g_hiv_aids_topic_nb_attendee_hiv, 0)),

        -- g_tb_topic_nb_attendee_tb (int) - numeric, null to 0
        ('g_tb_topic_nb_attendee_tb', COALESCE(src.g_tb_topic_nb_attendee_tb, 0)),

        -- g_maternal_health_topic_nb_attendee_maternal_health (int) - numeric, null to 0
        ('g_maternal_health_topic_nb_attendee_maternal_health', COALESCE(src.g_maternal_health_topic_nb_attendee_maternal_health, 0)),

        -- g_child_health_topic_nb_attendee_child_health (int) - numeric, null to 0
        ('g_child_health_topic_nb_attendee_child_health', COALESCE(src.g_child_health_topic_nb_attendee_child_health, 0)),

        -- g_other_topic_nb_attendee_other_topic (int) - numeric, null to 0
        ('g_other_topic_nb_attendee_other_topic', COALESCE(src.g_other_topic_nb_attendee_other_topic, 0))
) AS unpivot(data_element, value)
WHERE value IS NOT NULL;