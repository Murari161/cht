-- cht.mv_chew_performance source
DROP MATERIALIZED VIEW cht.mv_chew_performance;
CREATE MATERIALIZED VIEW cht.mv_chew_performance
TABLESPACE ts_report
AS WITH form_performance AS (
         SELECT mh.region,
            mh.district,
            to_char(d.reported::date::timestamp with time zone, 'YYYY'::text)::integer AS year,
            to_char(d.reported::date::timestamp with time zone, 'YYYY-"Q"Q'::text) AS reported_quarter,
            to_char(d.reported::date::timestamp with time zone, 'YYYY-MM'::text) AS reported_month_year,
            to_char(d.reported::date::timestamp with time zone, 'Month'::text) AS reported_monthname,
            to_char(d.reported::date::timestamp with time zone, 'FMMM'::text)::integer AS month,
            EXTRACT(quarter FROM d.reported::date)::integer AS quarter,
            count(DISTINCT
                CASE
                    WHEN d.form_name IS NOT NULL AND d.reported IS NOT NULL THEN concat_ws('-'::text, mc.contact_id, mc.facility_id)
                    ELSE NULL::text
                END) AS chw_worked,
            count(DISTINCT
                CASE
                    WHEN mh.facility_id IS NOT NULL THEN concat_ws('-'::text, mh.chw_id, mh.parish_id, mh.facility_id)
                    ELSE NULL::text
                END) AS chw_tagged_facility,
            count(DISTINCT
                CASE
                    WHEN mh.facility_id IS NULL THEN concat_ws('-'::text, mh.chw_id, mh.parish_id, mh.facility_id)
                    ELSE NULL::text
                END) AS chw_nottagged_facility,
            count(DISTINCT
                CASE
                    WHEN mh.role = 'CHEW'::text AND d.reported IS NOT NULL THEN concat_ws('-'::text, mc.contact_id, mc.facility_id)
                    ELSE NULL::text
                END) AS role_chew_active,
            count(DISTINCT
                CASE
                    WHEN mh.role = 'SUPER CHEW'::text AND d.reported IS NOT NULL THEN concat_ws('-'::text, mc.contact_id, mc.facility_id)
                    ELSE NULL::text
                END) AS role_superchew_active,
            count(DISTINCT
                CASE
                    WHEN d.form_name IS NOT NULL THEN d.form_name
                    ELSE NULL::text
                END) AS total_forms_completed,
            string_agg(DISTINCT d.form_name, ', '::text) AS forms_list
           FROM cht.mv_form_meta d
             LEFT JOIN cht.mv_cht_users mc ON d.contact_id = mc.contact_id
             LEFT JOIN cht.mv_chw_hierarchy mh ON d.contact_id = mh.chw_id
          WHERE d.contact_id IS NOT NULL AND (mh.role = 'CHEW'::text OR mh.role = 'SUPER CHEW'::text)
          GROUP BY (to_char(d.reported::date::timestamp with time zone, 'YYYY'::text)), (to_char(d.reported::date::timestamp with time zone, 'YYYY-"Q"Q'::text)), (to_char(d.reported::date::timestamp with time zone, 'YYYY-MM'::text)), (to_char(d.reported::date::timestamp with time zone, 'Month'::text)), (to_char(d.reported::date::timestamp with time zone, 'FMMM'::text)), (EXTRACT(quarter FROM d.reported::date)), mh.district, mh.region
        ), patient_volume AS (
         SELECT to_char(mv.reported::date::timestamp with time zone, 'YYYY'::text)::integer AS reported_year,
            to_char(mv.reported::date::timestamp with time zone, 'YYYY-"Q"Q'::text) AS reported_quarter,
            to_char(mv.reported::date::timestamp with time zone, 'YYYY-MM'::text) AS reported_month_year,
            to_char(mv.reported::date::timestamp with time zone, 'Month'::text) AS reported_monthname,
            to_char(mv.reported::date::timestamp with time zone, 'FMMM'::text)::integer AS reported_month,
            mv.region,
            mv.district,
            count(DISTINCT
                CASE
                    WHEN mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS patients_seen_with_id,
            count(DISTINCT
                CASE
                    WHEN mv.patient_id IS NULL OR mv.patient_id = ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS patients_seen_no_id
           FROM cht.mv_form_meta mv
          GROUP BY mv.region, mv.district, (to_char(mv.reported::date::timestamp with time zone, 'YYYY'::text)), (to_char(mv.reported::date::timestamp with time zone, 'YYYY-"Q"Q'::text)), (to_char(mv.reported::date::timestamp with time zone, 'YYYY-MM'::text)), (to_char(mv.reported::date::timestamp with time zone, 'Month'::text)), (to_char(mv.reported::date::timestamp with time zone, 'FMMM'::text))
        ), clinical_details AS (
         SELECT to_char(mv.reported::date::timestamp with time zone, 'YYYY'::text)::integer AS reported_year,
            to_char(mv.reported::date::timestamp with time zone, 'YYYY-"Q"Q'::text) AS reported_quarter,
            to_char(mv.reported::date::timestamp with time zone, 'YYYY-MM'::text) AS reported_month_year,
            to_char(mv.reported::date::timestamp with time zone, 'Month'::text) AS reported_monthname,
            to_char(mv.reported::date::timestamp with time zone, 'FMMM'::text)::integer AS reported_month,
            mv.region,
            mv.district,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'screening'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_screening,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'wash_report'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_wash_report,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'assessment'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_assessment,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'prescription_summary'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS prescription_summary,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'referral_follow_up'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_referral_follow_up,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'anc_visit_follow_up'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_anc_visit_follow_up,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'treatment_follow_up'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_treatment_follow_up,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'household_model_follow_up'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_household_model_follow_up,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'fp_registration'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_fp_registration,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'anc_referral_follow_up'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_anc_referral_follow_up,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'maternal_nutrition_follow_up'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_maternal_nutrition_follow_up,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'mute'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_mute,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'unmute'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_unmute,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'fp_referral_follow_up'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_fp_referral_follow_up,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'pnc_baby_follow_up'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_pnc_baby_follow_up,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'vht_consumption_log'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_vht_consumption_log,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'household_model_notification'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_household_model_notification,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'vht_supervision'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_vht_supervision,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'death_report'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_death_report,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'stockout'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_stockout,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'delivery_check'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_delivery_check,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'copy_of_danger_signs_follow_up_report'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_copy_of_danger_signs_follow_up_report,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'maternal_health_education'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_maternal_health_education,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'pregnancy'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_pregnancy,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'pnc_danger_sign'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_pnc_danger_sign,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'stock_count'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_stock_count,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'fp_follow_up'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_fp_follow_up,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'anc_danger_sign'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_anc_danger_sign,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'pnc_follow_up'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_pnc_follow_up,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'delivery'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_delivery,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'death_notification'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_death_notification,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'drowning_workflow'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_drowning_workflow,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'copy_of_danger_signs_report'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_copy_of_danger_signs_report,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'copy_of_ha_danger_signs_follow_up_report'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_copy_of_ha_danger_signs_follow_up_report,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'health_education'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_health_education,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'newborn_danger_sign_follow_up'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_newborn_danger_sign_follow_up,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'tb_screening'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_tb_screening,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'training_evaluation'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_training_evaluation,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'ncd_screening'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_ncd_screening,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'ha_danger_signs_follow_up'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_ha_danger_signs_follow_up,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'child_health_escalation'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_child_health_escalation,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'vht_home_location'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_vht_home_location,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'support_supervision'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_support_supervision,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'tb_results_notification'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_tb_results_notification,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'pregnancy_danger_sign_follow_up'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_pregnancy_danger_sign_follow_up,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'sputum_collection'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_sputum_collection,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'tb_referral_follow_up'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_tb_referral_follow_up,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'sdx_results'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_sdx_results,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'uncompleted_referral'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_uncompleted_referral,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'undo_death_report'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_undo_death_report,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'child_health_notification'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_child_health_notification,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'child_nutrition_follow_up'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_child_nutrition_follow_up,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'tb_follow_up'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_tb_follow_up,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'community_death_notification'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_community_death_notification,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'pregnancy_facility_visit_reminder'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_pregnancy_facility_visit_reminder,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'pnc_danger_sign_follow_up_mother'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_pnc_danger_sign_follow_up_mother,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'anc_danger_sign_escalation'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_anc_danger_sign_escalation,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'sdx_trigger'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_sdx_trigger,
            count(DISTINCT
                CASE
                    WHEN mv.form_name = 'child_nutrition_referral_follow_up'::text AND mv.patient_id IS NOT NULL AND mv.patient_id <> ''::text THEN mv.patient_id
                    ELSE NULL::text
                END) AS recoded_child_nutrition_referral_follow_up
           FROM cht.mv_form_meta mv
          GROUP BY mv.region, mv.district, (to_char(mv.reported::date::timestamp with time zone, 'YYYY'::text)), (to_char(mv.reported::date::timestamp with time zone, 'YYYY-"Q"Q'::text)), (to_char(mv.reported::date::timestamp with time zone, 'YYYY-MM'::text)), (to_char(mv.reported::date::timestamp with time zone, 'Month'::text)), (to_char(mv.reported::date::timestamp with time zone, 'FMMM'::text))
        ), hierarchy_capacity AS (
         SELECT mv_chw_hierarchy.region,
            mv_chw_hierarchy.district,
            count(DISTINCT
                CASE
                    WHEN mv_chw_hierarchy.role = 'CHEW'::text THEN concat_ws('-'::text, mv_chw_hierarchy.chw_id, mv_chw_hierarchy.parish_id, mv_chw_hierarchy.facility_id)
                    ELSE NULL::text
                END) AS total_chews_registered,
            count(DISTINCT
                CASE
                    WHEN mv_chw_hierarchy.role = 'SUPER CHEW'::text THEN concat_ws('-'::text, mv_chw_hierarchy.chw_id, mv_chw_hierarchy.parish_id, mv_chw_hierarchy.facility_id)
                    ELSE NULL::text
                END) AS total_superchews_registered,
            count(DISTINCT
                CASE
                    WHEN mv_chw_hierarchy.role = ANY (ARRAY['CHEW'::text, 'SUPER CHEW'::text]) THEN concat_ws('-'::text, mv_chw_hierarchy.chw_id, mv_chw_hierarchy.parish_id, mv_chw_hierarchy.facility_id)
                    ELSE NULL::text
                END) AS total_capacity
           FROM cht.mv_chw_hierarchy
          WHERE mv_chw_hierarchy.region IS NOT NULL
          GROUP BY mv_chw_hierarchy.region, mv_chw_hierarchy.district
        )
 SELECT p.region,
    p.district,
    p.year,
    p.reported_quarter,
    p.reported_month_year,
    p.reported_monthname,
    p.month,
    p.quarter,
    p.chw_worked,
    p.chw_tagged_facility,
    p.chw_nottagged_facility,
    p.role_chew_active,
    p.role_superchew_active,
    p.total_forms_completed,
    p.forms_list,
    h.total_chews_registered,
    h.total_superchews_registered,
    h.total_capacity,
    v.patients_seen_with_id,
    v.patients_seen_no_id,
    c.recoded_screening,
    c.recoded_wash_report,
    c.recoded_assessment,
    c.prescription_summary,
    c.recoded_referral_follow_up,
    c.recoded_anc_visit_follow_up,
    c.recoded_treatment_follow_up,
    c.recoded_household_model_follow_up,
    c.recoded_fp_registration,
    c.recoded_anc_referral_follow_up,
    c.recoded_maternal_nutrition_follow_up,
    c.recoded_mute,
    c.recoded_unmute,
    c.recoded_fp_referral_follow_up,
    c.recoded_pnc_baby_follow_up,
    c.recoded_vht_consumption_log,
    c.recoded_household_model_notification,
    c.recoded_vht_supervision,
    c.recoded_death_report,
    c.recoded_stockout,
    c.recoded_delivery_check,
    c.recoded_copy_of_danger_signs_follow_up_report,
    c.recoded_maternal_health_education,
    c.recoded_pregnancy,
    c.recoded_pnc_danger_sign,
    c.recoded_stock_count,
    c.recoded_fp_follow_up,
    c.recoded_anc_danger_sign,
    c.recoded_pnc_follow_up,
    c.recoded_delivery,
    c.recoded_death_notification,
    c.recoded_drowning_workflow,
    c.recoded_copy_of_danger_signs_report,
    c.recoded_copy_of_ha_danger_signs_follow_up_report,
    c.recoded_health_education,
    c.recoded_newborn_danger_sign_follow_up,
    c.recoded_tb_screening,
    c.recoded_training_evaluation,
    c.recoded_ncd_screening,
    c.recoded_ha_danger_signs_follow_up,
    c.recoded_child_health_escalation,
    c.recoded_vht_home_location,
    c.recoded_support_supervision,
    c.recoded_tb_results_notification,
    c.recoded_pregnancy_danger_sign_follow_up,
    c.recoded_sputum_collection,
    c.recoded_tb_referral_follow_up,
    c.recoded_sdx_results,
    c.recoded_uncompleted_referral,
    c.recoded_undo_death_report,
    c.recoded_child_health_notification,
    c.recoded_child_nutrition_follow_up,
    c.recoded_tb_follow_up,
    c.recoded_community_death_notification,
    c.recoded_pregnancy_facility_visit_reminder,
    c.recoded_pnc_danger_sign_follow_up_mother,
    c.recoded_anc_danger_sign_escalation,
    c.recoded_sdx_trigger,
    c.recoded_child_nutrition_referral_follow_up
   FROM form_performance p
     LEFT JOIN patient_volume v ON p.region = v.region AND p.district = v.district AND p.reported_month_year = v.reported_month_year
     LEFT JOIN clinical_details c ON p.region = c.region AND p.district = c.district AND p.reported_month_year = c.reported_month_year
     LEFT JOIN hierarchy_capacity h ON p.region = h.region AND p.district = h.district
  ORDER BY p.region, p.district, p.year, p.reported_quarter, p.reported_month_year, p.reported_monthname, p.month
WITH DATA;

CREATE INDEX mv_chew_performance_region_idx ON cht.mv_chew_performance USING btree (region) TABLESPACE ts_indexes;
CREATE INDEX mv_chew_performance_district_idx ON cht.mv_chew_performance USING btree (district) TABLESPACE ts_indexes;
CREATE INDEX mv_chew_performance_reported_month_year_idx ON cht.mv_chew_performance USING btree (reported_month_year) TABLESPACE ts_indexes;    
CREATE INDEX mv_chew_performance_reported_quarter_idx ON cht.mv_chew_performance USING btree (reported_quarter) TABLESPACE ts_indexes;
CREATE INDEX mv_chew_performance_year_idx ON cht.mv_chew_performance USING btree (year) TABLESPACE ts_indexes;
CREATE INDEX mv_chew_performance_month_idx ON cht.mv_chew_performance USING btree (month) TABLESPACE ts_indexes;
CREATE INDEX mv_chew_performance_reported_monthname_idx ON cht.mv_chew_performance USING btree (reported_monthname) TABLESPACE ts_indexes;  