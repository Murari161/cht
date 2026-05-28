#!/bin/bash

export PGPASSWORD='Phenominal2.0'
LOG_FILE="/home/jmurari/cht_counts/logs/mv_refresh.log"

echo "===== MV REFRESH START $(date) =====" >> "$LOG_FILE"

# Your MVS array (unchanged - perfect!)
MVS=(
    "cht.mv_gbv_community_form"
    "cht.mv_health_education"
    "cht.mv_form_meta"
    "cht.mv_person"
    "cht.mv_sputum_collection"
    "cht.mv_community_death_notification"
    "cht.mv_fp_follow_up"
    "cht.mv_stock_count"
    "cht.mv_fp_referral_follow_up"
    #"contactview_vht"
    "cht.mv_maternal_health_education"
    "cht.mv_chw_hierarchy"
    "cht.mv_treatment_follow_up"
    "cht.mv_delivery_check"
    "cht.mv_tb_follow_up"
    "cht.mv_fp_registration"
    "cht.mv_drowning_workflow"
    "cht.mv_pregnancy_danger_sign_follow_up"
    "cht.mv_cebs_signal_report_vht"
    "cht.mv_tb_referral_follow_up"
    "cht.mv_tb_screening"
    "cht.mv_ha_danger_signs_follow_up"
    "cht.mv_delivery"
    "cht.mv_cebs_signal_verification_notification"
    "cht.mv_delivery_report"
    "cht.mv_support_supervision"
    "cht.mv_training_evaluation"
    "cht.mv_cebs_signal_verification"
    "cht.mv_household_model_follow_up"
    "cht.mv_uncompleted_referral"
    "cht.mv_newborn_danger_sign_follow_up"
    "cht.mv_child_health_notification"
    "cht.mv_household_model_notification"
    "cht.mv_clinic"
    "cht.mv_anc_danger_sign_escalation"
    "cht.mv_unmute"
    "cht.mv_anc_danger_sign_notification"
    "cht.mv_vht_consumption_log"
    "cht.mv_child_health_escalation"
    "cht.mv_cebs_signal_report_chew"
    "cht.mv_stockout"
    "cht.mv_death_notification"
    "cht.mv_mute"
    "cht.mv_sputum_collection_refusal"
    "cht.mv_anc_danger_sign"
    "cht.mv_sdx_trigger"
    "cht.mv_sdx_notify"
    "cht.mv_maternal_nutrition_follow_up"
    "cht.mv_pnc_danger_sign"
    "cht.mv_chew_performance"
    "cht.mv_pnc_baby_follow_up"
    "cht.mv_sdx_follow_up"
    "cht.mv_pnc_follow_up"
    "cht.mv_vht_home_location"
    "cht.mv_wash_report"
    "cht.mv_referral_follow_up"
    "cht.mv_anc_visit_follow_up"
    "cht.mv_tb_results_notification"
    "cht.mv_afp_notification"
    "cht.mv_screening"
    "cht.mv_vht_supervision"
    "cht.mv_vht_immunization"
    "cht.mv_assessment"
    "cht.mv_child_nutrition_follow_up"
    "cht.mv_anc_referral_follow_up"
    "cht.mv_child_nutrition_referral_follow_up"
    "cht.mv_copy_of_danger_signs_follow_up_report"
    "cht.mv_death_report"
    "cht.mv_pregnancy"
    "cht.mv_areas"
    "cht.mv_facilities"
    #"cht.mv_fp_follow_ups"
    "cht.mv_cht_users"
    "cht.mv_health_education_new"
    "cht.mv_households"
    "cht.mv_orgunit"
    #"cht.mv_useview_fp_follow_ups"
    #"useview_death_notification"
    #"cht.mv_population_demographics"
    "cht.mv_useview_mrdt_mismtach"
    "cht.mv_useview_missing_mrdt_photo"
    "cht.mv_useview_ai_image_assessment"
    "cht.mv_user_roles"
    "report.mv_amr_prescription_audit"
    "report.mv_pps_facility_ward_overview"
    "report.mv_pps_indication"
    "report.mv_pps_specimen"
    "report.mv_pps_antibiotic"
    "report.mv_pps_patient"

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
        EXECUTE format('REFRESH MATERIALIZED VIEW %s', '$mv');
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