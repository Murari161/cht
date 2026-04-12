#!/bin/bash

export PGPASSWORD='Phenominal2.0'
LOG_FILE="/home/jmurari/cht_counts/logs/mv_refresh.log"

echo "===== MV REFRESH START $(date) =====" >> "$LOG_FILE"

# Your MVS array (unchanged - perfect!)
MVS=("mv_chew_hierarchy_2" 
    "mv_cht_users" 
    "mv_community_death_notification_new" 
    "mv_community_death_notification_revised" 
    "mv_delivery" 
    "mv_health_education_new"
    "mv_pregnancy_new"
    "mv_vht_immunization"
    "mv_vht_supervision" 
    "mv_uncompleted_referral"
    "mv_sputum_collection_refusal"
    "mv_orgunit"
    "useview_death_notification"
    "mv_sdx_trigger"
    "mv_sdx_notify"
    "mv_child_health_notification"
    "mv_tb_follow_up"
    "mv_child_nutrition_follow_up_new"
    "mv_child_nutrition_referral_follow_up"
    "mv_tb_referral_follow_up"
    "mv_clinic"
    "mv_child_nutrition_follow_up"
    "mv_anc_danger_sign_escalation"
    "mv_sdx_follow_up"
    "mv_anc_danger_sign_follow_up"
    "mv_anc_danger_sign_notification"
    "mv_pregnancy_danger_sign_follow_up"
    "mv_afp_notification"
    "mv_sputum_collection"
    "mv_tb_results_notification"
    "mv_child_health_escalation"
    "mv_cebs_signal_report_chew"
    "mv_areas"
    "mv_drowning_workflow"
    "mv_death_notification"
    "mv_cebs_signal_verification_notification"
    "mv_vht_home_location"
    "mv_ha_danger_signs_follow_up"
    "mv_training_evaluation"
    "mv_cebs_signal_report_vht"
    "mv_chw_hierarchy"
    "mv_cebs_signal_verification"
    "mv_copy_of_danger_signs_follow_up_report"
    "mv_delivery_check"
    "mv_newborn_danger_sign_follow_up"
    "mv_ha_danger_signs_follow_up_new"
    "mv_delivery_report"
    "mv_pnc_danger_sign"
    "mv_household_model_follow_up"
    "mv_unmute"
    "mv_stockout"
    "mv_support_supervision"
    "mv_death_report_new"
    "mv_health_education"
    "mv_fp_referral_follow_up"
    "mv_mute"
    "mv_anc_danger_sign"
    "mv_tb_screening"
    "mv_vht_consumption_log"
    "mv_stock_count"
    "mv_maternal_nutrition_follow_up"
    "mv_anc_referral_follow_up"
    "mv_pnc_baby_follow_up"
    "mv_death_report"
    "mv_maternal_health_education_new"
    "mv_facilities"
    "mv_anc_referral_follow_up_new"
    "mv_pnc_follow_up"
    "mv_maternal_health_education"
    "mv_fp_registration"
    "mv_households"
    "mv_referral_follow_up"
    "mv_pregnancy"
    "mv_treatment_follow_up_new"
    "mv_useview_fp_follow_ups"
    "mv_household_model_follow_up_new"
    "mv_chew_performance"
    "mv_fp_follow_ups"
    "mv_fp_follow_up"
    "mv_screening"
    "mv_household_model_notification"
    "mv_wash_report"
    "mv_assessment"
    "mv_anc_visit_follow_up"
    "mv_wash"
    "mv_integrated_echis_performance"    
    "mv_form_meta"
    "mv_person"
    "mv_assessment_new"
)

for mv in "${MVS[@]}"; do
  echo "Refreshing $mv at $(date)" >> "$LOG_FILE"
  
  # FIXED: Single heredoc with proper if structure
  if psql -h 172.27.1.93 -U jmurari -d uganda_dwh <<EOF >> "$LOG_FILE" 2>&1
DO \$\$
DECLARE
    v_start_time TIMESTAMP := clock_timestamp();
    v_end_time TIMESTAMP;
BEGIN
    BEGIN
        RAISE NOTICE 'Refreshing %', '$mv';
        EXECUTE format('REFRESH MATERIALIZED VIEW cht.%I', '$mv');
        v_end_time := clock_timestamp();
        INSERT INTO logs.cht_mv_refresh (
            mv_name, start_time, end_time, duration, status
        ) VALUES ('$mv', v_start_time, v_end_time, v_end_time - v_start_time, 'SUCCESS');
    EXCEPTION
        WHEN OTHERS THEN
            v_end_time := clock_timestamp();
            INSERT INTO logs.cht_mv_refresh (
                mv_name, start_time, end_time, duration, status, error_message
            ) VALUES ('$mv', v_start_time, v_end_time, v_end_time - v_start_time, 'FAILED', SQLERRM);
            RAISE EXCEPTION 'Refresh failed: %', SQLERRM;
    END;
END \$\$;
EOF
  then
    echo "✅ SUCCESS: $mv ($(date))" >> "$LOG_FILE"
  else
    echo "❌ FAILED: $mv ($(date))" >> "$LOG_FILE"
  fi
done

echo "===== MV REFRESH END $(date) =====" >> "$LOG_FILE"