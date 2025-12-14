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
    'treatment_follow_up' AS dataset,
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
    'treatment_follow_up' AS source_form
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
        referral_follow_up,
        trigger_referral_follow_up,
        follow_up_date,
        follow_up_method,
        note_look_for_danger_signs_in_person,
        note_ask_for_danger_signs_on_phone,
        any_danger_signs,
        note_refer_urgently,
        how_is_child,
        note_if_better,
        child_referred,
        note_refer_to_health_facility,
        note_cured,
        feeding_advice
    FROM cht.mv_treatment_follow_up_new
) src
CROSS JOIN LATERAL (
    VALUES
        ('referral_follow_up', src.referral_follow_up),
        ('trigger_referral_follow_up', src.trigger_referral_follow_up),
        ('follow_up_date', src.follow_up_date),
        ('follow_up_method', src.follow_up_method),
        ('note_look_for_danger_signs_in_person', src.note_look_for_danger_signs_in_person),
        ('note_ask_for_danger_signs_on_phone', src.note_ask_for_danger_signs_on_phone),
        ('any_danger_signs', src.any_danger_signs),
        ('note_refer_urgently', src.note_refer_urgently),
        ('how_is_child', src.how_is_child),
        ('note_if_better', src.note_if_better),
        ('child_referred', src.child_referred),
        ('note_refer_to_health_facility', src.note_refer_to_health_facility),
        ('note_cured', src.note_cured),
        ('feeding_advice', src.feeding_advice)
) AS unpivot(data_element, value)
WHERE unpivot.value IS NOT NULL
  AND TRIM(unpivot.value) <> '';