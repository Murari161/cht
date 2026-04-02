DO $$
DECLARE
    mv_name TEXT;
    mv_list TEXT[] := ARRAY[
    'mv_chew_hierarchy_2', 
    'mv_cht_users', 
    'mv_community_death_notification_new', 
    'mv_community_death_notification_revised', 
    'mv_delivery', 
    'mv_health_education_new',
    'mv_integrated_echis_performance',
    'mv_pregnancy_new',
    'mv_vht_immunization',
    'mv_vht_supervision', 
    'mv_uncompleted_referral',
    'mv_sputum_collection_refusal',
    'mv_orgunit',
    'useview_death_notification',
    'mv_sdx_trigger',
    'mv_sdx_notify',
    'mv_child_health_notification',
    'mv_tb_follow_up',
    'mv_child_nutrition_follow_up_new',
    'mv_child_nutrition_referral_follow_up',
    'mv_tb_referral_follow_up',
    'mv_clinic',
    'mv_child_nutrition_follow_up',
    'mv_anc_danger_sign_escalation',
    'mv_sdx_follow_up',
    'mv_anc_danger_sign_follow_up',
    'mv_anc_danger_sign_notification',
    'mv_pregnancy_danger_sign_follow_up',
    'mv_afp_notification',
    'mv_sputum_collection',
    'mv_tb_results_notification',
    'mv_child_health_escalation',
    'mv_cebs_signal_report_chew',
    'mv_areas',
    'mv_drowning_workflow',
    'mv_death_notification',
    'mv_cebs_signal_verification_notification',
    'mv_vht_home_location',
    'mv_ha_danger_signs_follow_up',
    'mv_training_evaluation',
    'mv_cebs_signal_report_vht',
    'mv_chw_hierarchy',
    'mv_cebs_signal_verification',
    'mv_copy_of_danger_signs_follow_up_report',
    'mv_delivery_check',
    'mv_newborn_danger_sign_follow_up',
    'mv_ha_danger_signs_follow_up_new',
    'mv_delivery_report',
    'mv_pnc_danger_sign',
    'mv_household_model_follow_up',
    'mv_unmute',
    'mv_stockout',
    'mv_support_supervision',
    'mv_death_report_new',
    'mv_health_education',
    'mv_fp_referral_follow_up',
    'mv_mute',
    'mv_anc_danger_sign',
    'mv_tb_screening',
    'mv_vht_consumption_log',
    'mv_stock_count',
    'mv_maternal_nutrition_follow_up',
    'mv_anc_referral_follow_up',
    'mv_pnc_baby_follow_up',
    'mv_death_report',
    'mv_maternal_health_education_new',
    'mv_facilities',
    'mv_anc_referral_follow_up_new',
    'mv_pnc_follow_up',
    'mv_maternal_health_education',
    'mv_fp_registration',
    'mv_households',
    'mv_referral_follow_up',
    'mv_pregnancy',
    'mv_treatment_follow_up_new',
    'mv_useview_fp_follow_ups',
    'mv_household_model_follow_up_new',
    'mv_chew_performance',
    'mv_fp_follow_ups',
    'mv_fp_follow_up',
    'mv_screening',
    'mv_household_model_notification',
    'mv_wash_report',
    'mv_assessment',
    'mv_anc_visit_follow_up',
    'mv_wash',--
    'mv_form_meta',
    --*'mv_population_demographics',
    --*'contactview_vht',
    'mv_person',
    --*'mv_cht_users_new',
    'mv_assessment_new'
];
    v_start_time TIMESTAMP;
    v_end_time TIMESTAMP;
BEGIN
    FOREACH mv_name IN ARRAY mv_list
    LOOP
        v_start_time := clock_timestamp();

        BEGIN
            RAISE NOTICE 'Refreshing %', mv_name;

            EXECUTE format('REFRESH MATERIALIZED VIEW %I', mv_name);

            v_end_time := clock_timestamp();

            INSERT INTO logs.cht_mv_refresh (
                mv_name,
                start_time,
                end_time,
                duration,
                status,
                error_message
            )
            VALUES (
                mv_name,
                v_start_time,
                v_end_time,
                v_end_time - v_start_time,
                'SUCCESS',
                NULL
            );

        EXCEPTION
            WHEN OTHERS THEN
                v_end_time := clock_timestamp();

                INSERT INTO logs.cht_mv_refresh (
                    mv_name,
                    start_time,
                    end_time,
                    duration,
                    status,
                    error_message
                )
                VALUES (
                    mv_name,
                    v_start_time,
                    v_end_time,
                    v_end_time - v_start_time,
                    'FAILED',
                    SQLERRM
                );

                RAISE WARNING 'Failed to refresh %: %', mv_name, SQLERRM;
        END;
    END LOOP;
END $$;
