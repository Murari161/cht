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
    'supervision' AS theme,
    'support_supervision' AS dataset,
    unpivot.data_element,
    unpivot.value,
    date,
    chw_id,
    facility_id,
    district AS district_id,
    region,
    NULL AS patient_age_in_years,
    NULL AS patient_age_in_months,
    NULL AS patient_age_in_days,
    NULL AS patient_sex,
    NULL AS patient_dob,
    'cht' AS source_system,
    'support_supervision' AS source_form
FROM (
    SELECT
        doc_id,
        date,
        chw_id,
        facility_id,
        district,
        region,

        -- indicator columns (numeric and categorical)
        LOWER(TRIM(vht_education)) AS vht_education,
        LOWER(TRIM(supervision_type)) AS supervision_type,
        LOWER(TRIM(supervision_facility)) AS supervision_facility,
        LOWER(TRIM(supervision_feedback)) AS supervision_feedback,
        LOWER(TRIM(services_offered)) AS services_offered,
        LOWER(TRIM(vht_training)) AS vht_training,
        LOWER(TRIM(echis_training)) AS echis_training,
        LOWER(TRIM(tools)) AS tools,
        LOWER(TRIM(iccm_tools)) AS iccm_tools,
        LOWER(TRIM(paper)) AS paper,
        LOWER(TRIM(vht_challenges)) AS vht_challenges,
        LOWER(TRIM(illness)) AS illness,
        LOWER(TRIM(vht_guidelines)) AS vht_guidelines,
        LOWER(TRIM(job_aids)) AS job_aids,
        LOWER(TRIM(alerts)) AS alerts,
        LOWER(TRIM(bundles)) AS bundles,
        bundles_received,
        LOWER(TRIM(facilitation)) AS facilitation,
        LOWER(TRIM(dialogues)) AS dialogues,
        LOWER(TRIM(issues)) AS issues
    FROM cht.mv_support_supervision
) src
CROSS JOIN LATERAL (
    VALUES
        -- vht_education (ple/a_level/o_level/none) - binary
        ('vht_education - Ple', CASE WHEN src.vht_education LIKE '%ple%' THEN 1 ELSE 0 END),
        ('vht_education - A_level', CASE WHEN src.vht_education LIKE '%a_level%' THEN 1 ELSE 0 END),
        ('vht_education - O_level', CASE WHEN src.vht_education LIKE '%o_level%' THEN 1 ELSE 0 END),
        ('vht_education - None', CASE WHEN src.vht_education LIKE '%none%' THEN 1 ELSE 0 END),

        -- supervision_type (scheduled/spot_check) - binary
        ('supervision_type - Scheduled', CASE WHEN src.supervision_type LIKE '%scheduled%' THEN 1 ELSE 0 END),
        ('supervision_type - Spot_check', CASE WHEN src.supervision_type LIKE '%spot_check%' THEN 1 ELSE 0 END),

        -- supervision_facility (yes/no) - binary
        ('supervision_facility - Yes', CASE WHEN src.supervision_facility = 'yes' THEN 1 ELSE 0 END),
        ('supervision_facility - No', CASE WHEN src.supervision_facility = 'no' THEN 1 ELSE 0 END),

        -- supervision_feedback (yes/no) - binary
        ('supervision_feedback - Yes', CASE WHEN src.supervision_feedback = 'yes' THEN 1 ELSE 0 END),
        ('supervision_feedback - No', CASE WHEN src.supervision_feedback = 'no' THEN 1 ELSE 0 END),

        -- services_offered (mgmt_child_illness/maternal_child_health/hiv/disease_prevention/immunization/reproductive_health/nutrition/essential_care/information_systems/sanitation/disaster_preparedness/school_health/other) - binary
        ('services_offered - Mgmt_child_illness', CASE WHEN src.services_offered LIKE '%mgmt_child_illness%' THEN 1 ELSE 0 END),
        ('services_offered - Maternal_child_health', CASE WHEN src.services_offered LIKE '%maternal_child_health%' THEN 1 ELSE 0 END),
        ('services_offered - Hiv', CASE WHEN src.services_offered LIKE '%hiv%' THEN 1 ELSE 0 END),
        ('services_offered - Disease_prevention', CASE WHEN src.services_offered LIKE '%disease_prevention%' THEN 1 ELSE 0 END),
        ('services_offered - Immunization', CASE WHEN src.services_offered LIKE '%immunization%' THEN 1 ELSE 0 END),
        ('services_offered - Reproductive_health', CASE WHEN src.services_offered LIKE '%reproductive_health%' THEN 1 ELSE 0 END),
        ('services_offered - Nutrition', CASE WHEN src.services_offered LIKE '%nutrition%' THEN 1 ELSE 0 END),
        ('services_offered - Essential_care', CASE WHEN src.services_offered LIKE '%essential_care%' THEN 1 ELSE 0 END),
        ('services_offered - Information_systems', CASE WHEN src.services_offered LIKE '%information_systems%' THEN 1 ELSE 0 END),
        ('services_offered - Sanitation', CASE WHEN src.services_offered LIKE '%sanitation%' THEN 1 ELSE 0 END),
        ('services_offered - Disaster_preparedness', CASE WHEN src.services_offered LIKE '%disaster_preparedness%' THEN 1 ELSE 0 END),
        ('services_offered - School_health', CASE WHEN src.services_offered LIKE '%school_health%' THEN 1 ELSE 0 END),
        ('services_offered - Other', CASE WHEN src.services_offered LIKE '%other%' THEN 1 ELSE 0 END),

        -- vht_training (mgmt_child_illness/maternal_child_health/hiv/disease_prevention/immunization/reproductive_health/nutrition/essential_care/information_systems/sanitation/disaster_preparedness/school_health/other) - binary
        ('vht_training - Mgmt_child_illness', CASE WHEN src.vht_training LIKE '%mgmt_child_illness%' THEN 1 ELSE 0 END),
        ('vht_training - Maternal_child_health', CASE WHEN src.vht_training LIKE '%maternal_child_health%' THEN 1 ELSE 0 END),
        ('vht_training - Hiv', CASE WHEN src.vht_training LIKE '%hiv%' THEN 1 ELSE 0 END),
        ('vht_training - Disease_prevention', CASE WHEN src.vht_training LIKE '%disease_prevention%' THEN 1 ELSE 0 END),
        ('vht_training - Immunization', CASE WHEN src.vht_training LIKE '%immunization%' THEN 1 ELSE 0 END),
        ('vht_training - Reproductive_health', CASE WHEN src.vht_training LIKE '%reproductive_health%' THEN 1 ELSE 0 END),
        ('vht_training - Nutrition', CASE WHEN src.vht_training LIKE '%nutrition%' THEN 1 ELSE 0 END),
        ('vht_training - Essential_care', CASE WHEN src.vht_training LIKE '%essential_care%' THEN 1 ELSE 0 END),
        ('vht_training - Information_systems', CASE WHEN src.vht_training LIKE '%information_systems%' THEN 1 ELSE 0 END),
        ('vht_training - Sanitation', CASE WHEN src.vht_training LIKE '%sanitation%' THEN 1 ELSE 0 END),
        ('vht_training - Disaster_preparedness', CASE WHEN src.vht_training LIKE '%disaster_preparedness%' THEN 1 ELSE 0 END),
        ('vht_training - School_health', CASE WHEN src.vht_training LIKE '%school_health%' THEN 1 ELSE 0 END),
        ('vht_training - Other', CASE WHEN src.vht_training LIKE '%other%' THEN 1 ELSE 0 END),

        -- echis_training (yes/no) - binary
        ('echis_training - Yes', CASE WHEN src.echis_training = 'yes' THEN 1 ELSE 0 END),
        ('echis_training - No', CASE WHEN src.echis_training = 'no' THEN 1 ELSE 0 END),

        -- tools (job/health/card/ras/supply/others/none) - binary
        ('tools - Job', CASE WHEN src.tools LIKE '%job%' THEN 1 ELSE 0 END),
        ('tools - Health', CASE WHEN src.tools LIKE '%health%' THEN 1 ELSE 0 END),
        ('tools - Card', CASE WHEN src.tools LIKE '%card%' THEN 1 ELSE 0 END),
        ('tools - Ras', CASE WHEN src.tools LIKE '%ras%' THEN 1 ELSE 0 END),
        ('tools - Supply', CASE WHEN src.tools LIKE '%supply%' THEN 1 ELSE 0 END),
        ('tools - Others', CASE WHEN src.tools LIKE '%others%' THEN 1 ELSE 0 END),
        ('tools - None', CASE WHEN src.tools LIKE '%none%' THEN 1 ELSE 0 END),

        -- iccm_tools (register/forms/logs/others/none) - binary
        ('iccm_tools - Register', CASE WHEN src.iccm_tools LIKE '%register%' THEN 1 ELSE 0 END),
        ('iccm_tools - Forms', CASE WHEN src.iccm_tools LIKE '%forms%' THEN 1 ELSE 0 END),
        ('iccm_tools - Logs', CASE WHEN src.iccm_tools LIKE '%logs%' THEN 1 ELSE 0 END),
        ('iccm_tools - Others', CASE WHEN src.iccm_tools LIKE '%others%' THEN 1 ELSE 0 END),
        ('iccm_tools - None', CASE WHEN src.iccm_tools LIKE '%none%' THEN 1 ELSE 0 END),

        -- paper (yes/no) - binary
        ('paper - Yes', CASE WHEN src.paper = 'yes' THEN 1 ELSE 0 END),
        ('paper - No', CASE WHEN src.paper = 'no' THEN 1 ELSE 0 END),

        -- vht_challenges (yes/no) - binary
        ('vht_challenges - Yes', CASE WHEN src.vht_challenges = 'yes' THEN 1 ELSE 0 END),
        ('vht_challenges - No', CASE WHEN src.vht_challenges = 'no' THEN 1 ELSE 0 END),

        -- illness (yes/no) - binary
        ('illness - Yes', CASE WHEN src.illness = 'yes' THEN 1 ELSE 0 END),
        ('illness - No', CASE WHEN src.illness = 'no' THEN 1 ELSE 0 END),

        -- vht_guidelines (yes/no) - binary
        ('vht_guidelines - Yes', CASE WHEN src.vht_guidelines = 'yes' THEN 1 ELSE 0 END),
        ('vht_guidelines - No', CASE WHEN src.vht_guidelines = 'no' THEN 1 ELSE 0 END),

        -- job_aids (yes/no) - binary
        ('job_aids - Yes', CASE WHEN src.job_aids = 'yes' THEN 1 ELSE 0 END),
        ('job_aids - No', CASE WHEN src.job_aids = 'no' THEN 1 ELSE 0 END),

        -- alerts (yes/no) - binary
        ('alerts - Yes', CASE WHEN src.alerts = 'yes' THEN 1 ELSE 0 END),
        ('alerts - No', CASE WHEN src.alerts = 'no' THEN 1 ELSE 0 END),

        -- bundles (yes/no) - binary
        ('bundles - Yes', CASE WHEN src.bundles = 'yes' THEN 1 ELSE 0 END),
        ('bundles - No', CASE WHEN src.bundles = 'no' THEN 1 ELSE 0 END),

        -- bundles_received (int) - numeric, null to 0
        ('bundles_received', COALESCE(src.bundles_received, 0)),

        -- facilitation (yes/no) - binary
        ('facilitation - Yes', CASE WHEN src.facilitation = 'yes' THEN 1 ELSE 0 END),
        ('facilitation - No', CASE WHEN src.facilitation = 'no' THEN 1 ELSE 0 END),

        -- dialogues (yes/no) - binary
        ('dialogues - Yes', CASE WHEN src.dialogues = 'yes' THEN 1 ELSE 0 END),
        ('dialogues - No', CASE WHEN src.dialogues = 'no' THEN 1 ELSE 0 END),

        -- issues (yes/no) - binary
        ('issues - Yes', CASE WHEN src.issues = 'yes' THEN 1 ELSE 0 END),
        ('issues - No', CASE WHEN src.issues = 'no' THEN 1 ELSE 0 END)
) AS unpivot(data_element, value)
WHERE value IS NOT NULL;