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
    doc_id AS uuid,
    'training' AS theme,
    'training_evaluation' AS dataset,
    unpivot.data_element,
    unpivot.value,
    date,
    chw_id,
    facility_id,
    disrict AS district_id,
    region,
    NULL AS patient_age_in_years,
    NULL AS patient_age_in_months,
    NULL AS patient_age_in_days,
    NULL AS patient_sex,
    NULL AS patient_dob,
    'cht' AS source_system,
    'training_evaluation' AS source_form
FROM (
    SELECT
        doc_id,
        date,
        chw_id,
        facility_id,
        disrict,
        region,

        -- indicator columns
        LOWER(TRIM(form_for_child_in_household_score)) AS form_for_child_in_household_score,
        LOWER(TRIM(option_for_reminder_score)) AS option_for_reminder_score,
        LOWER(TRIM(form_available_to_all_score)) AS form_available_to_all_score,
        LOWER(TRIM(responsible_for_hh_registration_score)) AS responsible_for_hh_registration_score,
        LOWER(TRIM(true_false_score)) AS true_false_score,
        LOWER(TRIM(tab_for_graphical_representation_score)) AS tab_for_graphical_representation_score,
        LOWER(TRIM(menu_for_reporting_issues_score)) AS menu_for_reporting_issues_score,
        LOWER(TRIM(option_facilitates_data_upload_score)) AS option_facilitates_data_upload_score,
        LOWER(TRIM(form_for_collecting_symptoms_score)) AS form_for_collecting_symptoms_score,
        LOWER(TRIM(option_for_completing_form_score)) AS option_for_completing_form_score,
        LOWER(TRIM(your_score)) AS your_score,
        LOWER(TRIM(form_for_child_in_household)) AS form_for_child_in_household,
        LOWER(TRIM(option_for_reminder)) AS option_for_reminder,
        LOWER(TRIM(form_available_to_all)) AS form_available_to_all,
        LOWER(TRIM(responsible_for_hh_registration)) AS responsible_for_hh_registration,
        LOWER(TRIM(true_false)) AS true_false,
        LOWER(TRIM(tab_for_graphical_representation)) AS tab_for_graphical_representation,
        LOWER(TRIM(menu_for_reporting_issues)) AS menu_for_reporting_issues,
        LOWER(TRIM(option_facilitates_data_upload)) AS option_facilitates_data_upload,
        LOWER(TRIM(form_for_collecting_symptoms)) AS form_for_collecting_symptoms,
        LOWER(TRIM(option_for_completing_form)) AS option_for_completing_form
    FROM cht.mv_training_evaluation
) src
CROSS JOIN LATERAL (
    VALUES
        -- form_for_child_in_household_score (1/0) - binary
        ('form_for_child_in_household_score - 1', CASE WHEN src.form_for_child_in_household_score = '1' THEN 1 ELSE 0 END),
        ('form_for_child_in_household_score - 0', CASE WHEN src.form_for_child_in_household_score = '0' THEN 1 ELSE 0 END),

        -- option_for_reminder_score (1/0) - binary
        ('option_for_reminder_score - 1', CASE WHEN src.option_for_reminder_score = '1' THEN 1 ELSE 0 END),
        ('option_for_reminder_score - 0', CASE WHEN src.option_for_reminder_score = '0' THEN 1 ELSE 0 END),

        -- form_available_to_all_score (1/0) - binary
        ('form_available_to_all_score - 1', CASE WHEN src.form_available_to_all_score = '1' THEN 1 ELSE 0 END),
        ('form_available_to_all_score - 0', CASE WHEN src.form_available_to_all_score = '0' THEN 1 ELSE 0 END),

        -- responsible_for_hh_registration_score (1/0) - binary
        ('responsible_for_hh_registration_score - 1', CASE WHEN src.responsible_for_hh_registration_score = '1' THEN 1 ELSE 0 END),
        ('responsible_for_hh_registration_score - 0', CASE WHEN src.responsible_for_hh_registration_score = '0' THEN 1 ELSE 0 END),

        -- true_false_score (1/0) - binary
        ('true_false_score - 1', CASE WHEN src.true_false_score = '1' THEN 1 ELSE 0 END),
        ('true_false_score - 0', CASE WHEN src.true_false_score = '0' THEN 1 ELSE 0 END),

        -- tab_for_graphical_representation_score (1/0) - binary
        ('tab_for_graphical_representation_score - 1', CASE WHEN src.tab_for_graphical_representation_score = '1' THEN 1 ELSE 0 END),
        ('tab_for_graphical_representation_score - 0', CASE WHEN src.tab_for_graphical_representation_score = '0' THEN 1 ELSE 0 END),

        -- menu_for_reporting_issues_score (1/0) - binary
        ('menu_for_reporting_issues_score - 1', CASE WHEN src.menu_for_reporting_issues_score = '1' THEN 1 ELSE 0 END),
        ('menu_for_reporting_issues_score - 0', CASE WHEN src.menu_for_reporting_issues_score = '0' THEN 1 ELSE 0 END),

        -- option_facilitates_data_upload_score (1/0) - binary
        ('option_facilitates_data_upload_score - 1', CASE WHEN src.option_facilitates_data_upload_score = '1' THEN 1 ELSE 0 END),
        ('option_facilitates_data_upload_score - 0', CASE WHEN src.option_facilitates_data_upload_score = '0' THEN 1 ELSE 0 END),

        -- form_for_collecting_symptoms_score (1/0) - binary
        ('form_for_collecting_symptoms_score - 1', CASE WHEN src.form_for_collecting_symptoms_score = '1' THEN 1 ELSE 0 END),
        ('form_for_collecting_symptoms_score - 0', CASE WHEN src.form_for_collecting_symptoms_score = '0' THEN 1 ELSE 0 END),

        -- option_for_completing_form_score (1/0) - binary
        ('option_for_completing_form_score - 1', CASE WHEN src.option_for_completing_form_score = '1' THEN 1 ELSE 0 END),
        ('option_for_completing_form_score - 0', CASE WHEN src.option_for_completing_form_score = '0' THEN 1 ELSE 0 END),

        -- your_score (1/0) - binary
        ('your_score - 1', CASE WHEN src.your_score = '1' THEN 1 ELSE 0 END),
        ('your_score - 0', CASE WHEN src.your_score = '0' THEN 1 ELSE 0 END),

        -- form_for_child_in_household (new_action/new_hh/new_person/edit) - binary
        ('form_for_child_in_household - New_action', CASE WHEN src.form_for_child_in_household LIKE '%new_action%' THEN 1 ELSE 0 END),
        ('form_for_child_in_household - New_hh', CASE WHEN src.form_for_child_in_household LIKE '%new_hh%' THEN 1 ELSE 0 END),
        ('form_for_child_in_household - New_person', CASE WHEN src.form_for_child_in_household LIKE '%new_person%' THEN 1 ELSE 0 END),
        ('form_for_child_in_household - Edit', CASE WHEN src.form_for_child_in_household LIKE '%edit%' THEN 1 ELSE 0 END),

        -- option_for_reminder (message/task/people/history) - binary
        ('option_for_reminder - Message', CASE WHEN src.option_for_reminder LIKE '%message%' THEN 1 ELSE 0 END),
        ('option_for_reminder - Task', CASE WHEN src.option_for_reminder LIKE '%task%' THEN 1 ELSE 0 END),
        ('option_for_reminder - People', CASE WHEN src.option_for_reminder LIKE '%people%' THEN 1 ELSE 0 END),
        ('option_for_reminder - History', CASE WHEN src.option_for_reminder LIKE '%history%' THEN 1 ELSE 0 END),

        -- form_available_to_all (family_planning/death_report/delivery_form/all) - binary
        ('form_available_to_all - Family_planning', CASE WHEN src.form_available_to_all LIKE '%family_planning%' THEN 1 ELSE 0 END),
        ('form_available_to_all - Death_report', CASE WHEN src.form_available_to_all LIKE '%death_report%' THEN 1 ELSE 0 END),
        ('form_available_to_all - Delivery_form', CASE WHEN src.form_available_to_all LIKE '%delivery_form%' THEN 1 ELSE 0 END),
        ('form_available_to_all - All', CASE WHEN src.form_available_to_all LIKE '%all%' THEN 1 ELSE 0 END),

        -- responsible_for_hh_registration (vht/facility_cha/field_cha/schmt) - binary
        ('responsible_for_hh_registration - Vht', CASE WHEN src.responsible_for_hh_registration LIKE '%vht%' THEN 1 ELSE 0 END),
        ('responsible_for_hh_registration - Facility_cha', CASE WHEN src.responsible_for_hh_registration LIKE '%facility_cha%' THEN 1 ELSE 0 END),
        ('responsible_for_hh_registration - Field_cha', CASE WHEN src.responsible_for_hh_registration LIKE '%field_cha%' THEN 1 ELSE 0 END),
        ('responsible_for_hh_registration - Schmt', CASE WHEN src.responsible_for_hh_registration LIKE '%schmt%' THEN 1 ELSE 0 END),

        -- true_false (true/false) - binary
        ('true_false - True', CASE WHEN src.true_false = 'true' THEN 1 ELSE 0 END),
        ('true_false - False', CASE WHEN src.true_false = 'false' THEN 1 ELSE 0 END),

        -- tab_for_graphical_representation (message/task/target/report) - binary
        ('tab_for_graphical_representation - Message', CASE WHEN src.tab_for_graphical_representation LIKE '%message%' THEN 1 ELSE 0 END),
        ('tab_for_graphical_representation - Task', CASE WHEN src.tab_for_graphical_representation LIKE '%task%' THEN 1 ELSE 0 END),
        ('tab_for_graphical_representation - Target', CASE WHEN src.tab_for_graphical_representation LIKE '%target%' THEN 1 ELSE 0 END),
        ('tab_for_graphical_representation - Report', CASE WHEN src.tab_for_graphical_representation LIKE '%report%' THEN 1 ELSE 0 END),

        -- menu_for_reporting_issues (about/report_problem/user_settings/guided_tour) - binary
        ('menu_for_reporting_issues - About', CASE WHEN src.menu_for_reporting_issues LIKE '%about%' THEN 1 ELSE 0 END),
        ('menu_for_reporting_issues - Report_problem', CASE WHEN src.menu_for_reporting_issues LIKE '%report_problem%' THEN 1 ELSE 0 END),
        ('menu_for_reporting_issues - User_settings', CASE WHEN src.menu_for_reporting_issues LIKE '%user_settings%' THEN 1 ELSE 0 END),
        ('menu_for_reporting_issues - Guided_tour', CASE WHEN src.menu_for_reporting_issues LIKE '%guided_tour%' THEN 1 ELSE 0 END),

        -- option_facilitates_data_upload (data_option_on/have_data_bundles/sync/all) - binary
        ('option_facilitates_data_upload - Data_option_on', CASE WHEN src.option_facilitates_data_upload LIKE '%data_option_on%' THEN 1 ELSE 0 END),
        ('option_facilitates_data_upload - Have_data_bundles', CASE WHEN src.option_facilitates_data_upload LIKE '%have_data_bundles%' THEN 1 ELSE 0 END),
        ('option_facilitates_data_upload - Sync', CASE WHEN src.option_facilitates_data_upload LIKE '%sync%' THEN 1 ELSE 0 END),
        ('option_facilitates_data_upload - All', CASE WHEN src.option_facilitates_data_upload LIKE '%all%' THEN 1 ELSE 0 END),

        -- form_for_collecting_symptoms (assessment_form/death_report/pregnancy_form/immunization_form) - binary
        ('form_for_collecting_symptoms - Assessment_form', CASE WHEN src.form_for_collecting_symptoms LIKE '%assessment_form%' THEN 1 ELSE 0 END),
        ('form_for_collecting_symptoms - Death_report', CASE WHEN src.form_for_collecting_symptoms LIKE '%death_report%' THEN 1 ELSE 0 END),
        ('form_for_collecting_symptoms - Pregnancy_form', CASE WHEN src.form_for_collecting_symptoms LIKE '%pregnancy_form%' THEN 1 ELSE 0 END),
        ('form_for_collecting_symptoms - Immunization_form', CASE WHEN src.form_for_collecting_symptoms LIKE '%immunization_form%' THEN 1 ELSE 0 END),

        -- option_for_completing_form (action_button/tasks_list/report_bug_menu/all) - binary
        ('option_for_completing_form - Action_button', CASE WHEN src.option_for_completing_form LIKE '%action_button%' THEN 1 ELSE 0 END),
        ('option_for_completing_form - Tasks_list', CASE WHEN src.option_for_completing_form LIKE '%tasks_list%' THEN 1 ELSE 0 END),
        ('option_for_completing_form - Report_bug_menu', CASE WHEN src.option_for_completing_form LIKE '%report_bug_menu%' THEN 1 ELSE 0 END),
        ('option_for_completing_form - All', CASE WHEN src.option_for_completing_form LIKE '%all%' THEN 1 ELSE 0 END)
) AS unpivot(data_element, value)
WHERE value = 1;