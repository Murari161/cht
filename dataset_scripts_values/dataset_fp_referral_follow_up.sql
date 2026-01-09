INSERT INTO cht.fact_cht_values (
    uuid,
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
    'fp_referral_follow_up' AS dataset,
    unpivot.data_element,
    unpivot.value,
    date,
    chw_id,
    contact_facility_id AS facility_id,
    district_id AS district_id,
    region_id AS region,
    patient_age_in_years,
    NULL AS patient_age_in_months,
    NULL AS patient_age_in_days,
    inputs_contact_sex AS patient_sex,
    inputs_contact_date_of_birth AS patient_dob,
    'cht' AS source_system,
    'fp_referral_follow_up' AS source_form
FROM (
    SELECT
        uuid,
        date,
        chw_id,
        contact_facility_id,
        district_id,
        region_id,
        patient_age_in_years,
        inputs_contact_sex,
        inputs_contact_date_of_birth,

        -- indicator columns from MV
        visited_facility,
        enrolled_fp,
        n_fp_registration,
        reason_not_enrolled_fp,
        n_pregnancy_registration,
        group_review_n_summary_title,
        group_review_n_submit,
        group_review_n_patient_details_title,
        group_review_n_patient_details,
        group_review_n_findings_title,
        group_review_n_fp_method
    FROM cht.mv_fp_referral_follow_up
) src
CROSS JOIN LATERAL (
    VALUES
        ('visited_facility', src.visited_facility),
        ('enrolled_fp', src.enrolled_fp),
        ('n_fp_registration', src.n_fp_registration),
        ('reason_not_enrolled_fp', src.reason_not_enrolled_fp),
        ('n_pregnancy_registration', src.n_pregnancy_registration),
        ('group_review_n_summary_title', src.group_review_n_summary_title),
        ('group_review_n_submit', src.group_review_n_submit),
        ('group_review_n_patient_details_title', src.group_review_n_patient_details_title),
        ('group_review_n_patient_details', src.group_review_n_patient_details),
        ('group_review_n_findings_title', src.group_review_n_findings_title),
        ('group_review_n_fp_method', src.group_review_n_fp_method)
) AS unpivot(data_element, value)
WHERE unpivot.value IS NOT NULL
  AND TRIM(unpivot.value) <> '';