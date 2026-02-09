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
    'tb' AS theme,
    'tb_screening' AS dataset,
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
    'tb_screening' AS source_form
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

        -- indicator columns
        LOWER(TRIM(is_currently_on_tb_treatment)) AS is_currently_on_tb_treatment,
        LOWER(TRIM(is_still_on_tb_treatment)) AS is_still_on_tb_treatment,
        LOWER(TRIM(have_all_members_been_screened)) AS have_all_members_been_screened,
        LOWER(TRIM(benefits_of_tb_treatment)) AS benefits_of_tb_treatment,
        LOWER(TRIM(who_risk_contracting_tb)) AS who_risk_contracting_tb,
        LOWER(TRIM(select_tb_risk_factors)) AS select_tb_risk_factors,
        LOWER(TRIM(cough_sign)) AS cough_sign,
        LOWER(TRIM(cough_duration)) AS cough_duration,
        LOWER(TRIM(blood_in_cough)) AS blood_in_cough,
        LOWER(TRIM(fever_symptom)) AS fever_symptom,
        LOWER(TRIM(fever_duration)) AS fever_duration,
        LOWER(TRIM(weight_loss_sign)) AS weight_loss_sign,
        LOWER(TRIM(excessive_night_sweat_sign)) AS excessive_night_sweat_sign,
        LOWER(TRIM(loss_of_appetite)) AS loss_of_appetite,
        LOWER(TRIM(chest_pain)) AS chest_pain,
        LOWER(TRIM(poor_weight_gain_sign)) AS poor_weight_gain_sign,
        LOWER(TRIM(had_contact_with_tb_person)) AS had_contact_with_tb_person,
        LOWER(TRIM(note_educate_patient)) AS note_educate_patient,
        LOWER(TRIM(confirms_referral)) AS confirms_referral,
        LOWER(TRIM(consented_sputum_sample)) AS consented_sputum_sample,
        LOWER(TRIM(receive_results_on_same_phonenumber)) AS receive_results_on_same_phonenumber,
        LOWER(TRIM(has_patient_produced_sputum)) AS has_patient_produced_sputum,
        LOWER(TRIM(confirm_send_sample_for_testing)) AS confirm_send_sample_for_testing,
        LOWER(TRIM(has_left_sputum_bottle_with_client)) AS has_left_sputum_bottle_with_client
    FROM cht.mv_tb_screening
) src
CROSS JOIN LATERAL (
    VALUES
        -- is_currently_on_tb_treatment (yes/no) - binary
        ('is_currently_on_tb_treatment - Yes', CASE WHEN src.is_currently_on_tb_treatment = 'yes' THEN 1 ELSE 0 END),
        ('is_currently_on_tb_treatment - No', CASE WHEN src.is_currently_on_tb_treatment = 'no' THEN 1 ELSE 0 END),

        -- is_still_on_tb_treatment (yes/no) - binary
        ('is_still_on_tb_treatment - Yes', CASE WHEN src.is_still_on_tb_treatment = 'yes' THEN 1 ELSE 0 END),
        ('is_still_on_tb_treatment - No', CASE WHEN src.is_still_on_tb_treatment = 'no' THEN 1 ELSE 0 END),

        -- have_all_members_been_screened (yes/no) - binary
        ('have_all_members_been_screened - Yes', CASE WHEN src.have_all_members_been_screened = 'yes' THEN 1 ELSE 0 END),
        ('have_all_members_been_screened - No', CASE WHEN src.have_all_members_been_screened = 'no' THEN 1 ELSE 0 END),

        -- benefits_of_tb_treatment (cures_patient/prevent_drug_resistant_tb/prevent_complications/prevents_tb_relapse/prevent_death_from_tb/reduce_tb_transmission/reduce_incidences) - binary
        ('benefits_of_tb_treatment - Cures_patient', CASE WHEN src.benefits_of_tb_treatment LIKE '%cures_patient%' THEN 1 ELSE 0 END),
        ('benefits_of_tb_treatment - Prevent_drug_resistant_tb', CASE WHEN src.benefits_of_tb_treatment LIKE '%prevent_drug_resistant_tb%' THEN 1 ELSE 0 END),
        ('benefits_of_tb_treatment - Prevent_complications', CASE WHEN src.benefits_of_tb_treatment LIKE '%prevent_complications%' THEN 1 ELSE 0 END),
        ('benefits_of_tb_treatment - Prevents_tb_relapse', CASE WHEN src.benefits_of_tb_treatment LIKE '%prevents_tb_relapse%' THEN 1 ELSE 0 END),
        ('benefits_of_tb_treatment - Prevent_death_from_tb', CASE WHEN src.benefits_of_tb_treatment LIKE '%prevent_death_from_tb%' THEN 1 ELSE 0 END),
        ('benefits_of_tb_treatment - Reduce_tb_transmission', CASE WHEN src.benefits_of_tb_treatment LIKE '%reduce_tb_transmission%' THEN 1 ELSE 0 END),
        ('benefits_of_tb_treatment - Reduce_incidences', CASE WHEN src.benefits_of_tb_treatment LIKE '%reduce_incidences%' THEN 1 ELSE 0 END),

        -- who_risk_contracting_tb (children_u5/elderly_g65/people_in_contact/hiv_infected_persons/malnourished_people/diabetic_persons/alcholics/smokers/drug_abusers/prisoners/health_workers/miners) - binary
        ('who_risk_contracting_tb - Children_u5', CASE WHEN src.who_risk_contracting_tb LIKE '%children_u5%' THEN 1 ELSE 0 END),
        ('who_risk_contracting_tb - Elderly_g65', CASE WHEN src.who_risk_contracting_tb LIKE '%elderly_g65%' THEN 1 ELSE 0 END),
        ('who_risk_contracting_tb - People_in_contact', CASE WHEN src.who_risk_contracting_tb LIKE '%people_in_contact%' THEN 1 ELSE 0 END),
        ('who_risk_contracting_tb - Hiv_infected_persons', CASE WHEN src.who_risk_contracting_tb LIKE '%hiv_infected_persons%' THEN 1 ELSE 0 END),
        ('who_risk_contracting_tb - Malnourished_people', CASE WHEN src.who_risk_contracting_tb LIKE '%malnourished_people%' THEN 1 ELSE 0 END),
        ('who_risk_contracting_tb - Diabetic_persons', CASE WHEN src.who_risk_contracting_tb LIKE '%diabetic_persons%' THEN 1 ELSE 0 END),
        ('who_risk_contracting_tb - Alcholics', CASE WHEN src.who_risk_contracting_tb LIKE '%alcholics%' THEN 1 ELSE 0 END),
        ('who_risk_contracting_tb - Smokers', CASE WHEN src.who_risk_contracting_tb LIKE '%smokers%' THEN 1 ELSE 0 END),
        ('who_risk_contracting_tb - Drug_abusers', CASE WHEN src.who_risk_contracting_tb LIKE '%drug_abusers%' THEN 1 ELSE 0 END),
        ('who_risk_contracting_tb - Prisoners', CASE WHEN src.who_risk_contracting_tb LIKE '%prisoners%' THEN 1 ELSE 0 END),
        ('who_risk_contracting_tb - Health_workers', CASE WHEN src.who_risk_contracting_tb LIKE '%health_workers%' THEN 1 ELSE 0 END),
        ('who_risk_contracting_tb - Miners', CASE WHEN src.who_risk_contracting_tb LIKE '%miners%' THEN 1 ELSE 0 END),

        -- select_tb_risk_factors (has_diabetes/miner/been_in_prison/smoker/drug_abuse/none) - binary
        ('select_tb_risk_factors - Has_diabetes', CASE WHEN src.select_tb_risk_factors LIKE '%has_diabetes%' THEN 1 ELSE 0 END),
        ('select_tb_risk_factors - Miner', CASE WHEN src.select_tb_risk_factors LIKE '%miner%' THEN 1 ELSE 0 END),
        ('select_tb_risk_factors - Been_in_prison', CASE WHEN src.select_tb_risk_factors LIKE '%been_in_prison%' THEN 1 ELSE 0 END),
        ('select_tb_risk_factors - Smoker', CASE WHEN src.select_tb_risk_factors LIKE '%smoker%' THEN 1 ELSE 0 END),
        ('select_tb_risk_factors - Drug_abuse', CASE WHEN src.select_tb_risk_factors LIKE '%drug_abuse%' THEN 1 ELSE 0 END),
        ('select_tb_risk_factors - None', CASE WHEN src.select_tb_risk_factors LIKE '%none%' THEN 1 ELSE 0 END),

        -- cough_sign (yes/no) - binary
        ('cough_sign - Yes', CASE WHEN src.cough_sign = 'yes' THEN 1 ELSE 0 END),
        ('cough_sign - No', CASE WHEN src.cough_sign = 'no' THEN 1 ELSE 0 END),

        -- cough_duration (less_than_14/14_days_or_more) - binary
        ('cough_duration - Less_than_14', CASE WHEN src.cough_duration LIKE '%less_than_14%' THEN 1 ELSE 0 END),
        ('cough_duration - 14_days_or_more', CASE WHEN src.cough_duration LIKE '%14_days_or_more%' THEN 1 ELSE 0 END),

        -- blood_in_cough (yes/no) - binary
        ('blood_in_cough - Yes', CASE WHEN src.blood_in_cough = 'yes' THEN 1 ELSE 0 END),
        ('blood_in_cough - No', CASE WHEN src.blood_in_cough = 'no' THEN 1 ELSE 0 END),

        -- fever_symptom (yes/no) - binary
        ('fever_symptom - Yes', CASE WHEN src.fever_symptom = 'yes' THEN 1 ELSE 0 END),
        ('fever_symptom - No', CASE WHEN src.fever_symptom = 'no' THEN 1 ELSE 0 END),

        -- fever_duration (less_than_14/14_days_or_more) - binary
        ('fever_duration - Less_than_14', CASE WHEN src.fever_duration LIKE '%less_than_14%' THEN 1 ELSE 0 END),
        ('fever_duration - 14_days_or_more', CASE WHEN src.fever_duration LIKE '%14_days_or_more%' THEN 1 ELSE 0 END),

        -- weight_loss_sign (yes/no) - binary
        ('weight_loss_sign - Yes', CASE WHEN src.weight_loss_sign = 'yes' THEN 1 ELSE 0 END),
        ('weight_loss_sign - No', CASE WHEN src.weight_loss_sign = 'no' THEN 1 ELSE 0 END),

        -- excessive_night_sweat_sign (yes/no) - binary
        ('excessive_night_sweat_sign - Yes', CASE WHEN src.excessive_night_sweat_sign = 'yes' THEN 1 ELSE 0 END),
        ('excessive_night_sweat_sign - No', CASE WHEN src.excessive_night_sweat_sign = 'no' THEN 1 ELSE 0 END),

        -- loss_of_appetite (yes/no) - binary
        ('loss_of_appetite - Yes', CASE WHEN src.loss_of_appetite = 'yes' THEN 1 ELSE 0 END),
        ('loss_of_appetite - No', CASE WHEN src.loss_of_appetite = 'no' THEN 1 ELSE 0 END),

        -- chest_pain (yes/no) - binary
        ('chest_pain - Yes', CASE WHEN src.chest_pain = 'yes' THEN 1 ELSE 0 END),
        ('chest_pain - No', CASE WHEN src.chest_pain = 'no' THEN 1 ELSE 0 END),

        -- poor_weight_gain_sign (yes/no) - binary
        ('poor_weight_gain_sign - Yes', CASE WHEN src.poor_weight_gain_sign = 'yes' THEN 1 ELSE 0 END),
        ('poor_weight_gain_sign - No', CASE WHEN src.poor_weight_gain_sign = 'no' THEN 1 ELSE 0 END),

        -- had_contact_with_tb_person (yes/no) - binary
        ('had_contact_with_tb_person - Yes', CASE WHEN src.had_contact_with_tb_person = 'yes' THEN 1 ELSE 0 END),
        ('had_contact_with_tb_person - No', CASE WHEN src.had_contact_with_tb_person = 'no' THEN 1 ELSE 0 END),

        -- note_educate_patient (cover_mouth_when_coughing/open_windows/encourage_family_members_testing/bcg_vaccination/tb_case_finding/tb_preventive_therapy/tb_infection_control/tb_contact_tracing) - binary
        ('note_educate_patient - Cover_mouth_when_coughing', CASE WHEN src.note_educate_patient LIKE '%cover_mouth_when_coughing%' THEN 1 ELSE 0 END),
        ('note_educate_patient - Open_windows', CASE WHEN src.note_educate_patient LIKE '%open_windows%' THEN 1 ELSE 0 END),
        ('note_educate_patient - Encourage_family_members_testing', CASE WHEN src.note_educate_patient LIKE '%encourage_family_members_testing%' THEN 1 ELSE 0 END),
        ('note_educate_patient - Bcg_vaccination', CASE WHEN src.note_educate_patient LIKE '%bcg_vaccination%' THEN 1 ELSE 0 END),
        ('note_educate_patient - Tb_case_finding', CASE WHEN src.note_educate_patient LIKE '%tb_case_finding%' THEN 1 ELSE 0 END),
        ('note_educate_patient - Tb_preventive_therapy', CASE WHEN src.note_educate_patient LIKE '%tb_preventive_therapy%' THEN 1 ELSE 0 END),
        ('note_educate_patient - Tb_infection_control', CASE WHEN src.note_educate_patient LIKE '%tb_infection_control%' THEN 1 ELSE 0 END),
        ('note_educate_patient - Tb_contact_tracing', CASE WHEN src.note_educate_patient LIKE '%tb_contact_tracing%' THEN 1 ELSE 0 END),

        -- confirms_referral (yes) - binary
        ('confirms_referral - Yes', CASE WHEN src.confirms_referral = 'yes' THEN 1 ELSE 0 END),

        -- consented_sputum_sample (yes/no) - binary
        ('consented_sputum_sample - Yes', CASE WHEN src.consented_sputum_sample = 'yes' THEN 1 ELSE 0 END),
        ('consented_sputum_sample - No', CASE WHEN src.consented_sputum_sample = 'no' THEN 1 ELSE 0 END),

        -- receive_results_on_same_phonenumber (yes/no) - binary
        ('receive_results_on_same_phonenumber - Yes', CASE WHEN src.receive_results_on_same_phonenumber = 'yes' THEN 1 ELSE 0 END),
        ('receive_results_on_same_phonenumber - No', CASE WHEN src.receive_results_on_same_phonenumber = 'no' THEN 1 ELSE 0 END),

        -- has_patient_produced_sputum (yes/no) - binary
        ('has_patient_produced_sputum - Yes', CASE WHEN src.has_patient_produced_sputum = 'yes' THEN 1 ELSE 0 END),
        ('has_patient_produced_sputum - No', CASE WHEN src.has_patient_produced_sputum = 'no' THEN 1 ELSE 0 END),

        -- confirm_send_sample_for_testing (yes) - binary
        ('confirm_send_sample_for_testing - Yes', CASE WHEN src.confirm_send_sample_for_testing = 'yes' THEN 1 ELSE 0 END),

        -- has_left_sputum_bottle_with_client (yes/no) - binary
        ('has_left_sputum_bottle_with_client - Yes', CASE WHEN src.has_left_sputum_bottle_with_client = 'yes' THEN 1 ELSE 0 END),
        ('has_left_sputum_bottle_with_client - No', CASE WHEN src.has_left_sputum_bottle_with_client = 'no' THEN 1 ELSE 0 END)
) AS unpivot(data_element, value)
WHERE value = 1;