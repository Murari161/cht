CREATE MATERIALIZED VIEW cht.mv_health_education_new
TABLESPACE ts_report
AS
SELECT
    -- Standard fields (appear in all forms)
    doc ->> '_id'::text AS uuid,
    doc ->> 'form'::text AS form,
    doc ->> 'from'::text AS submitter,
    to_timestamp((NULLIF(doc ->> 'reported_date'::text, ''::text)::bigint / 1000)::double precision) AS reported,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY-MM-DD'))::date AS date,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY'))::INT AS year,
    TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'FMMonth') AS month,
    doc ->'fields'->'meta'->>'instanceID' AS instanceID,
    doc ->'fields'->'inputs'->'meta'->>'deprecatedID' AS deprecatedID,
    doc ->'fields'->'inputs'->'meta'->'location'->>'lat' AS location_lat,
    doc ->'fields'->'inputs'->'meta'->'location'->>'long' AS location_long,
    doc ->'fields'->'inputs'->'meta'->'location'->>'error' AS location_error,
    doc ->'fields'->'inputs'->'meta'->'location'->>'message' AS location_message,
    doc ->'geolocation'->>'code' AS geolocation_code,
    doc ->'geolocation'->>'message' AS geolocation_message,
    doc #>> '{contact,_id}'::text[] AS chw_id,
    doc #>> '{contact,parent,_id}'::text[] AS contact_chw_area_id,
    doc #>> '{contact,parent,parent,_id}'::text[] AS contact_facility_id,
    doc #>> '{contact,parent,parent,parent,_id}'::text[] AS parish_id,
    doc #>> '{contact,parent,parent,parent,parent,_id}'::text[] AS district_id,
    doc #>> '{contact,parent,parent,parent,parent,parent,_id}'::text[] AS region_id,

    -- Form-specific fields (from the XML)
    doc #>> '{fields,inputs,source}'::text[] AS inputs_source,
    doc #>> '{fields,inputs,source_id}'::text[] AS inputs_source_id,
    doc #>> '{fields,inputs,user,contact_id}'::text[] AS inputs_user_contact_id,
    doc #>> '{fields,inputs,user,facility_id}'::text[] AS inputs_user_facility_id,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    doc #>> '{fields,inputs,contact,contact,_id}'::text[] AS inputs_contact_contact_id,
    doc #>> '{fields,inputs,contact,contact,name}'::text[] AS inputs_contact_contact_name,
    doc #>> '{fields,inputs,contact,contact,date_of_birth}'::text[] AS inputs_contact_contact_date_of_birth,
    doc #>> '{fields,patient_id}'::text[] AS patient_id,
    doc #>> '{fields,place_id}'::text[] AS place_id,
    doc #>> '{fields,chew_name}'::text[] AS chew_name,
    doc #>> '{fields,chew_date_of_birth}'::text[] AS chew_date_of_birth,
    doc #>> '{fields,chew_age_display}'::text[] AS chew_age_display,
    doc #>> '{fields,village_id}'::text[] AS village_id,
    doc #>> '{fields,village_name}'::text[] AS village_name,
    doc #>> '{fields,needs_signoff}'::text[] AS needs_signoff, --(true)
    doc #>> '{fields,selected_village,venue}'::text[] AS selected_village_venue, --(village/health_facility)
    doc #>> '{fields,geolocation,want_to_capture_gps}'::text[] AS fields_geolocation_want_to_capture_gps, --(yes/no)
    doc #>> '{fields,geolocation,gps_capture_checklist}'::text[] AS fields_geolocation_gps_capture_checklist, --(enable_gps/clear_view_on_sky/at_household_village)
    doc #>> '{fields,geolocation,gps}'::text[] AS fields_geolocation_gps, --(int of gps coordinates)
    doc #>> '{fields,geolocation,gps_capture_checklist_completed}'::text[] AS fields_geolocation_gps_capture_checklist_completed, --(true/false)
    doc #>> '{fields,geolocation,latitude}'::text[] AS fields_geolocation_latitude, --(int of lat)
    doc #>> '{fields,geolocation,longitude}'::text[] AS fields_geolocation_longitude, --(int of long)
    doc #>> '{fields,geolocation,altitude}'::text[] AS fields_geolocation_altitude, --(int of alt)
    doc #>> '{fields,geolocation,accuracy}'::text[] AS fields_geolocation_accuracy, --(int of accuracy)
    doc #>> '{fields,g_health_education_topics,topics_covered}'::text[] AS he_topics_covered, --(wash/food_good_nutrition_promotion/non_communicable_diseases/leprosy/malaria/hiv_aids/tb/maternal_health/child_health/others)
    doc #>> '{fields,g_wash_topic,wash_priorities}'::text[] AS g_wash_topic_wash_priorities, --(keep_water_safe_clean/dispose_wastes_safety/wash_hands_stay_healthy/keep_utensils_clean_place/ensure_safe_environment)
    doc #>> '{fields,g_wash_topic,nb_attendee_wash}'::text[] AS g_wash_topic_nb_attendee_wash, --(int)
    doc #>> '{fields,g_nutrition_promotion_topic,nutrition_practices}'::text[] AS g_nutrition_promotion_topic_nutrition_practices, --(importance_good_nutrition/balanced_diet/nutrition_requirements/importance_back_yard_garden/safe_food_handling_and_preparation)
    doc #>> '{fields,g_nutrition_promotion_topic,nb_attendee_food_promotion}'::text[] AS g_nutrition_promotion_topic_nb_attendee_food_promotion, --(int)
    doc #>> '{fields,g_non_communicable_diseases_topic,non_communicable_diseases_facts}'::text[] AS g_non_communicable_diseases_topic_non_communicable_diseases_facts, /*cardio_disease_definition
cardio_symptoms/sudden_cardio_symptoms/cardio_prevention/high_bp_definition/high_bp_control/community_bp_control/hypertension_prevention/stroke_definition/
stroke_risk_factors/stroke_symptoms/stroke_prevention/diabetes_definition/diabetes_symptoms/diabetes_risk_factors/diabetes_prevention/low_sugar_signs/
diabetes_control/copd_definition/copd_symptoms/copd_causes/copd_prevention/asthma_definition/asthma_symptoms/asthma_management/
sickle_cell_definition/sickle_cell_prevention/cervical_cancer_definition/cervical_cancer_risks/cervical_cancer_symptoms/cervical_cancer_prevention/breast_cancer_definition/breast_cancer_risks/
breast_cancer_symptoms/breast_cancer_prevention/kaposi_sarcoma_definition/kaposi_sarcoma_symptoms/kaposi_sarcoma_prevention/prostate_cancer_definition/prostate_cancer_risks/prostate_cancer_symptoms/
prostate_cancer_management/mental_health_definition/mental_health_signs/mental_health_causes/mental_health_care/mental_health_prevention/substance_disorder_definition/substance_disorder_causes/
common_abused_substances/substance_abuse_prevention/substance_abuse_prevention_parents/oral_health_definition/oral_problem_signs/dental_problem_solution/
road_injuries_definition/road_injury_prevention/snake_bite_symptoms/snake_bite_prevention/snake_bite_first_aid/dog_bite_prevention/dog_bite_aid/drowning_definition/drowning_prevention*/
    doc #>> '{fields,g_non_communicable_diseases_topic,nb_attendee_commun_diseases}'::text[] AS g_non_communicable_diseases_topic_nb_attendee_commun_diseases, --(int)
    doc #>> '{fields,g_leprosy_topic,leprosy_facts}'::text[] AS g_leprosy_topic_leprosy_facts, --(leprosy_definition/leprosy_symptoms/leprosy_transmission/leprosy_diagnosis/adherence_to_leprosy_treatment/leprosy_elimination)
    doc #>> '{fields,g_leprosy_topic,nb_attendee_leprosy}'::text[] AS g_leprosy_topic_nb_attendee_leprosy, --(int)
    doc #>> '{fields,g_malaria_topic,malaria_facts}'::text[] AS g_malaria_topic_malaria_facts, --(malaria_definition/malaria_risk_transmission/malaria_symptoms/malaria_prevention/malaria_action_fever/myths_and_misconceptions/malaria_prevention_actions)
    doc #>> '{fields,g_malaria_topic,nb_attendee_malaria}'::text[] AS g_malaria_topic_nb_attendee_malaria, --(int)
    doc #>> '{fields,g_hiv_aids_topic,hiv_aids_facts}'::text[] AS g_hiv_aids_topic_hiv_aids_facts, --(hiv_aids_definition/hiv_infection_prevention/hiv_vertical_transmission/hiv_symptoms/hiv_management/myths_and_misconceptions_hiv/)
    doc #>> '{fields,g_hiv_aids_topic,nb_attendee_hiv}'::text[] AS g_hiv_aids_topic_nb_attendee_hiv, --(int)
    doc #>> '{fields,g_tb_topic,tb_facts}'::text[] AS g_tb_topic_tb_facts, --(tb_definition/tb_transmission/tb_symptoms/tb_treatment/tb_prevention)
    doc #>> '{fields,g_tb_topic,nb_attendee_tb}'::text[] AS g_tb_topic_nb_attendee_tb, --(int)
    doc #>> '{fields,g_maternal_health_topic,maternal_health_facts}'::text[] AS g_maternal_health_topic_maternal_health_facts, /*pregnancy_signs
pregnancy_care/antenatal_visits/pregnancy_nutrition/high_risk_factors/
pregnancy_common_problems/pregnancy_danger_signs/
hiv_protection_for_babies/myths_and_misconceptions_pregnancy/
birth_plan/labor_guidance/postpartum_care/postpartum_nutrition/
breastfeeding_timing/postpartum_danger_signs/family_planning */
    doc #>> '{fields,g_maternal_health_topic,nb_attendee_maternal_health}'::text[] AS g_maternal_health_topic_nb_attendee_maternal_health, --(int)
    doc #>> '{fields,g_child_health_topic,child_health_facts}'::text[] AS g_child_health_topic_child_health_facts, /*newborn_care
birth_cleanliness/newborn_warmth/newborn_eye_care/newborn_danger_signs/
breastfeeding_importance/immunization_def/immunization_schedule/myths_and_misconceptions_child_health*/
    doc #>> '{fields,g_child_health_topic,nb_attendee_child_health}'::text[] AS g_child_health_topic_nb_attendee_child_health, --(int)
    doc #>> '{fields,g_other_topic,nb_attendee_other_topic}'::text[] AS g_other_topic_nb_attendee_other_topic, --(int)

    -- Last column for tracking refresh
    CURRENT_TIMESTAMP AS last_refresh_date

FROM dwh.cht_data couchdb
WHERE (doc ->> 'form'::text) = 'health_education'::text
  AND is_current
WITH DATA;

-- Indexes
CREATE INDEX mv_health_education_new_reported
    ON cht.mv_health_education_new USING btree (reported);

CREATE INDEX mv_health_education_new_chw_id
    ON cht.mv_health_education_new USING btree (chw_id);