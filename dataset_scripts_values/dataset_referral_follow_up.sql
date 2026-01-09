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
    doc_id AS uuid,
    'referral_follow_up' AS dataset,
    unpivot.data_element,
    unpivot.value,
    date,
    chw_id,
    facility_id,
    district AS district_id,
    region,
    patient_age_in_years,
    patient_age_in_months,
    patient_age_in_days,
    patient_gender AS patient_sex,
    contact_date_of_birth AS patient_dob,
    'cht' AS source_system,
    'referral_follow_up' AS source_form
FROM (
    SELECT
        doc_id,
        date,
        chw_id,
        facility_id,
        district,
        region,
        patient_age_in_years,
        patient_age_in_months,
        patient_age_in_days,
        patient_gender,
        contact_date_of_birth,

        -- indicator columns from MV
        needs_signoff,
        referral_follow_up_again,
        follow_up_date,
        follow_up_method,
        patient_condition,
        went_to_health_facility,
        interact_with_healthcare,
        note_encourage_to_visit_health_facility,
        hc_visit_date,
        hc_attendant,
        hc_attendant_other,
        hc_name,
        action_taken,
        instructions_for_vht
    FROM cht.mv_referral_follow_up
) src
CROSS JOIN LATERAL (
    VALUES
        ('needs_signoff', src.needs_signoff),
        ('referral_follow_up_again', src.referral_follow_up_again),
        ('follow_up_date', src.follow_up_date),
        ('follow_up_method', src.follow_up_method),
        ('patient_condition', src.patient_condition),
        ('went_to_health_facility', src.went_to_health_facility),
        ('interact_with_healthcare', src.interact_with_healthcare),
        ('note_encourage_to_visit_health_facility', src.note_encourage_to_visit_health_facility),
        ('hc_visit_date', src.hc_visit_date),
        ('hc_attendant', src.hc_attendant),
        ('hc_attendant_other', src.hc_attendant_other),
        ('hc_name', src.hc_name),
        ('action_taken', src.action_taken),
        ('instructions_for_vht', src.instructions_for_vht)
) AS unpivot(data_element, value)
WHERE unpivot.value IS NOT NULL
  AND TRIM(unpivot.value) <> '';