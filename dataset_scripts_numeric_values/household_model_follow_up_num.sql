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
    uuid AS uuid,
    'household' AS theme,
    'household_model_follow_up' AS dataset,
    unpivot.data_element,
    unpivot.value,
    date,
    chw_id,
    contact_facility_id AS facility_id,
    district_id AS district_id,
    region_id AS region,
    NULL AS patient_age_in_years,
    NULL AS patient_age_in_months,
    NULL AS patient_age_in_days,
    NULL AS patient_sex,
    NULL AS patient_dob,
    'cht' AS source_system,
    'household_model_follow_up' AS source_form
FROM (
    SELECT
        uuid,
        date,
        chw_id,
        contact_facility_id,
        district_id,
        region_id,

        -- indicator columns
        LOWER(TRIM(geolocation_want_to_capture_gps)) AS geolocation_want_to_capture_gps,
        LOWER(TRIM(geolocation_ensure_gps)) AS geolocation_ensure_gps,
        LOWER(TRIM(hh_in_sanitary_dwelling_house)) AS hh_in_sanitary_dwelling_house,
        LOWER(TRIM(hh_access_safe_water_source)) AS hh_access_safe_water_source,
        LOWER(TRIM(hh_have_safe_drinking_water)) AS hh_have_safe_drinking_water,
        LOWER(TRIM(hh_have_sanitary_kitchen)) AS hh_have_sanitary_kitchen,
        LOWER(TRIM(hh_have_drying_rack)) AS hh_have_drying_rack,
        LOWER(TRIM(hh_have_backyard_garden)) AS hh_have_backyard_garden,
        LOWER(TRIM(hh_have_rubbish_pit)) AS hh_have_rubbish_pit,
        LOWER(TRIM(hh_have_bath_shelter)) AS hh_have_bath_shelter,
        LOWER(TRIM(hh_sanitary_facility)) AS hh_sanitary_facility,
        LOWER(TRIM(hh_sharing_sanitary_facility)) AS hh_sharing_sanitary_facility,
        LOWER(TRIM(hh_kind_of_public_toilet)) AS hh_kind_of_public_toilet,
        LOWER(TRIM(hh_latrine_fly_proof)) AS hh_latrine_fly_proof,
        LOWER(TRIM(hh_floor_of_toilet_or_latrine)) AS hh_floor_of_toilet_or_latrine,
        LOWER(TRIM(hh_toilet_conected_to_sewer)) AS hh_toilet_conected_to_sewer,
        LOWER(TRIM(hh_sanitary_facility_filled_up)) AS hh_sanitary_facility_filled_up,
        LOWER(TRIM(hh_empited_pit_latrine_or_septic_tank)) AS hh_empited_pit_latrine_or_septic_tank,
        LOWER(TRIM(hh_emptying_services)) AS hh_emptying_services,
        LOWER(TRIM(hh_emptied_contents_location)) AS hh_emptied_contents_location,
        LOWER(TRIM(hh_handwashing_near_toilet_latrine)) AS hh_handwashing_near_toilet_latrine,
        LOWER(TRIM(hh_handwashing_facility_status)) AS hh_handwashing_facility_status,
        LOWER(TRIM(hh_is_odf)) AS hh_is_odf,
        LOWER(TRIM(hh_have_drying_lines)) AS hh_have_drying_lines,
        LOWER(TRIM(hh_have_animal_house)) AS hh_have_animal_house,
        LOWER(TRIM(hh_have_food_storage_access)) AS hh_have_food_storage_access,
        LOWER(TRIM(hh_compound_well_maintained)) AS hh_compound_well_maintained,
        LOWER(TRIM(hh_have_vermin_rodent)) AS hh_have_vermin_rodent,
        LOWER(TRIM(follow_household)) AS follow_household,
        LOWER(TRIM(is_model_household)) AS is_model_household
    FROM cht.mv_household_model_follow_up_new
) src
CROSS JOIN LATERAL (
    VALUES
        -- geolocation_want_to_capture_gps (yes/no) - binary
        ('geolocation_want_to_capture_gps - Yes', CASE WHEN src.geolocation_want_to_capture_gps = 'yes' THEN 1 ELSE 0 END),
        ('geolocation_want_to_capture_gps - No', CASE WHEN src.geolocation_want_to_capture_gps = 'no' THEN 1 ELSE 0 END),

        -- geolocation_ensure_gps (gps_enabled/clear_sky/at_hh) - binary
        ('geolocation_ensure_gps - Gps_enabled', CASE WHEN src.geolocation_ensure_gps LIKE '%gps_enabled%' THEN 1 ELSE 0 END),
        ('geolocation_ensure_gps - Clear_sky', CASE WHEN src.geolocation_ensure_gps LIKE '%clear_sky%' THEN 1 ELSE 0 END),
        ('geolocation_ensure_gps - At_hh', CASE WHEN src.geolocation_ensure_gps LIKE '%at_hh%' THEN 1 ELSE 0 END),

        -- hh_in_sanitary_dwelling_house (yes/no) - binary
        ('hh_in_sanitary_dwelling_house - Yes', CASE WHEN src.hh_in_sanitary_dwelling_house = 'yes' THEN 1 ELSE 0 END),
        ('hh_in_sanitary_dwelling_house - No', CASE WHEN src.hh_in_sanitary_dwelling_house = 'no' THEN 1 ELSE 0 END),

        -- hh_access_safe_water_source (yes/no) - binary
        ('hh_access_safe_water_source - Yes', CASE WHEN src.hh_access_safe_water_source = 'yes' THEN 1 ELSE 0 END),
        ('hh_access_safe_water_source - No', CASE WHEN src.hh_access_safe_water_source = 'no' THEN 1 ELSE 0 END),

        -- hh_have_safe_drinking_water (yes/no) - binary
        ('hh_have_safe_drinking_water - Yes', CASE WHEN src.hh_have_safe_drinking_water = 'yes' THEN 1 ELSE 0 END),
        ('hh_have_safe_drinking_water - No', CASE WHEN src.hh_have_safe_drinking_water = 'no' THEN 1 ELSE 0 END),

        -- hh_have_sanitary_kitchen (yes/no) - binary
        ('hh_have_sanitary_kitchen - Yes', CASE WHEN src.hh_have_sanitary_kitchen = 'yes' THEN 1 ELSE 0 END),
        ('hh_have_sanitary_kitchen - No', CASE WHEN src.hh_have_sanitary_kitchen = 'no' THEN 1 ELSE 0 END),

        -- hh_have_drying_rack (yes/no) - binary
        ('hh_have_drying_rack - Yes', CASE WHEN src.hh_have_drying_rack = 'yes' THEN 1 ELSE 0 END),
        ('hh_have_drying_rack - No', CASE WHEN src.hh_have_drying_rack = 'no' THEN 1 ELSE 0 END),

        -- hh_have_backyard_garden (yes/no) - binary
        ('hh_have_backyard_garden - Yes', CASE WHEN src.hh_have_backyard_garden = 'yes' THEN 1 ELSE 0 END),
        ('hh_have_backyard_garden - No', CASE WHEN src.hh_have_backyard_garden = 'no' THEN 1 ELSE 0 END),

        -- hh_have_rubbish_pit (yes/no) - binary
        ('hh_have_rubbish_pit - Yes', CASE WHEN src.hh_have_rubbish_pit = 'yes' THEN 1 ELSE 0 END),
        ('hh_have_rubbish_pit - No', CASE WHEN src.hh_have_rubbish_pit = 'no' THEN 1 ELSE 0 END),

        -- hh_have_bath_shelter (yes/no) - binary
        ('hh_have_bath_shelter - Yes', CASE WHEN src.hh_have_bath_shelter = 'yes' THEN 1 ELSE 0 END),
        ('hh_have_bath_shelter - No', CASE WHEN src.hh_have_bath_shelter = 'no' THEN 1 ELSE 0 END),

        -- hh_sanitary_facility (flush/pit_latrine/composting_toilets/ventilated_improved_pit_latrine/unimproved_pit_latrine/public_toilet/no_facility) - binary
        ('hh_sanitary_facility - Flush', CASE WHEN src.hh_sanitary_facility LIKE '%flush%' THEN 1 ELSE 0 END),
        ('hh_sanitary_facility - Pit_latrine', CASE WHEN src.hh_sanitary_facility LIKE '%pit_latrine%' THEN 1 ELSE 0 END),
        ('hh_sanitary_facility - Composting_toilets', CASE WHEN src.hh_sanitary_facility LIKE '%composting_toilets%' THEN 1 ELSE 0 END),
        ('hh_sanitary_facility - Ventilated_improved_pit_latrine', CASE WHEN src.hh_sanitary_facility LIKE '%ventilated_improved_pit_latrine%' THEN 1 ELSE 0 END),
        ('hh_sanitary_facility - Unimproved_pit_latrine', CASE WHEN src.hh_sanitary_facility LIKE '%unimproved_pit_latrine%' THEN 1 ELSE 0 END),
        ('hh_sanitary_facility - Public_toilet', CASE WHEN src.hh_sanitary_facility LIKE '%public_toilet%' THEN 1 ELSE 0 END),
        ('hh_sanitary_facility - No_facility', CASE WHEN src.hh_sanitary_facility LIKE '%no_facility%' THEN 1 ELSE 0 END),

        -- hh_sharing_sanitary_facility (yes/no) - binary
        ('hh_sharing_sanitary_facility - Yes', CASE WHEN src.hh_sharing_sanitary_facility = 'yes' THEN 1 ELSE 0 END),
        ('hh_sharing_sanitary_facility - No', CASE WHEN src.hh_sharing_sanitary_facility = 'no' THEN 1 ELSE 0 END),

        -- hh_kind_of_public_toilet (flush/pit_latrine/composting_toilets/ventilated_improved_pit_latrine/unimproved_pit_latrine/public_toilet/no_facility) - binary
        ('hh_kind_of_public_toilet - Flush', CASE WHEN src.hh_kind_of_public_toilet LIKE '%flush%' THEN 1 ELSE 0 END),
        ('hh_kind_of_public_toilet - Pit_latrine', CASE WHEN src.hh_kind_of_public_toilet LIKE '%pit_latrine%' THEN 1 ELSE 0 END),
        ('hh_kind_of_public_toilet - Composting_toilets', CASE WHEN src.hh_kind_of_public_toilet LIKE '%composting_toilets%' THEN 1 ELSE 0 END),
        ('hh_kind_of_public_toilet - Ventilated_improved_pit_latrine', CASE WHEN src.hh_kind_of_public_toilet LIKE '%ventilated_improved_pit_latrine%' THEN 1 ELSE 0 END),
        ('hh_kind_of_public_toilet - Unimproved_pit_latrine', CASE WHEN src.hh_kind_of_public_toilet LIKE '%unimproved_pit_latrine%' THEN 1 ELSE 0 END),
        ('hh_kind_of_public_toilet - Public_toilet', CASE WHEN src.hh_kind_of_public_toilet LIKE '%public_toilet%' THEN 1 ELSE 0 END),
        ('hh_kind_of_public_toilet - No_facility', CASE WHEN src.hh_kind_of_public_toilet LIKE '%no_facility%' THEN 1 ELSE 0 END),

        -- hh_latrine_fly_proof (yes/no) - binary
        ('hh_latrine_fly_proof - Yes', CASE WHEN src.hh_latrine_fly_proof = 'yes' THEN 1 ELSE 0 END),
        ('hh_latrine_fly_proof - No', CASE WHEN src.hh_latrine_fly_proof = 'no' THEN 1 ELSE 0 END),

        -- hh_floor_of_toilet_or_latrine (tile/mud/cement_or_concrete/timber/plastic/logs) - binary
        ('hh_floor_of_toilet_or_latrine - Tile', CASE WHEN src.hh_floor_of_toilet_or_latrine LIKE '%tile%' THEN 1 ELSE 0 END),
        ('hh_floor_of_toilet_or_latrine - Mud', CASE WHEN src.hh_floor_of_toilet_or_latrine LIKE '%mud%' THEN 1 ELSE 0 END),
        ('hh_floor_of_toilet_or_latrine - Cement_or_concrete', CASE WHEN src.hh_floor_of_toilet_or_latrine LIKE '%cement_or_concrete%' THEN 1 ELSE 0 END),
        ('hh_floor_of_toilet_or_latrine - Timber', CASE WHEN src.hh_floor_of_toilet_or_latrine LIKE '%timber%' THEN 1 ELSE 0 END),
        ('hh_floor_of_toilet_or_latrine - Plastic', CASE WHEN src.hh_floor_of_toilet_or_latrine LIKE '%plastic%' THEN 1 ELSE 0 END),
        ('hh_floor_of_toilet_or_latrine - Logs', CASE WHEN src.hh_floor_of_toilet_or_latrine LIKE '%logs%' THEN 1 ELSE 0 END),

        -- hh_toilet_conected_to_sewer (yes_connected_to_sewer/no_connected_to_septic_tank/no_connected_to_biodigester/dont_know) - binary
        ('hh_toilet_conected_to_sewer - Yes_connected_to_sewer', CASE WHEN src.hh_toilet_conected_to_sewer LIKE '%yes_connected_to_sewer%' THEN 1 ELSE 0 END),
        ('hh_toilet_conected_to_sewer - No_connected_to_septic_tank', CASE WHEN src.hh_toilet_conected_to_sewer LIKE '%no_connected_to_septic_tank%' THEN 1 ELSE 0 END),
        ('hh_toilet_conected_to_sewer - No_connected_to_biodigester', CASE WHEN src.hh_toilet_conected_to_sewer LIKE '%no_connected_to_biodigester%' THEN 1 ELSE 0 END),
        ('hh_toilet_conected_to_sewer - Dont_know', CASE WHEN src.hh_toilet_conected_to_sewer LIKE '%dont_know%' THEN 1 ELSE 0 END),

        -- hh_sanitary_facility_filled_up (yes/no) - binary
        ('hh_sanitary_facility_filled_up - Yes', CASE WHEN src.hh_sanitary_facility_filled_up = 'yes' THEN 1 ELSE 0 END),
        ('hh_sanitary_facility_filled_up - No', CASE WHEN src.hh_sanitary_facility_filled_up = 'no' THEN 1 ELSE 0 END),

        -- hh_empited_pit_latrine_or_septic_tank (yes_emptied/no_not_emptied/dont_know) - binary
        ('hh_empited_pit_latrine_or_septic_tank - Yes_emptied', CASE WHEN src.hh_empited_pit_latrine_or_septic_tank LIKE '%yes_emptied%' THEN 1 ELSE 0 END),
        ('hh_empited_pit_latrine_or_septic_tank - No_not_emptied', CASE WHEN src.hh_empited_pit_latrine_or_septic_tank LIKE '%no_not_emptied%' THEN 1 ELSE 0 END),
        ('hh_empited_pit_latrine_or_septic_tank - Dont_know', CASE WHEN src.hh_empited_pit_latrine_or_septic_tank LIKE '%dont_know%' THEN 1 ELSE 0 END),

        -- hh_emptying_services (cesspool_emptier/gulper/casual_labourers) - binary
        ('hh_emptying_services - Cesspool_emptier', CASE WHEN src.hh_emptying_services LIKE '%cesspool_emptier%' THEN 1 ELSE 0 END),
        ('hh_emptying_services - Gulper', CASE WHEN src.hh_emptying_services LIKE '%gulper%' THEN 1 ELSE 0 END),
        ('hh_emptying_services - Casual_labourers', CASE WHEN src.hh_emptying_services LIKE '%casual_labourers%' THEN 1 ELSE 0 END),

        -- hh_emptied_contents_location (treatment_facility/buried_in_covered_pit/poured_in_environment/dont_know) - binary
        ('hh_emptied_contents_location - Treatment_facility', CASE WHEN src.hh_emptied_contents_location LIKE '%treatment_facility%' THEN 1 ELSE 0 END),
        ('hh_emptied_contents_location - Buried_in_covered_pit', CASE WHEN src.hh_emptied_contents_location LIKE '%buried_in_covered_pit%' THEN 1 ELSE 0 END),
        ('hh_emptied_contents_location - Poured_in_environment', CASE WHEN src.hh_emptied_contents_location LIKE '%poured_in_environment%' THEN 1 ELSE 0 END),
        ('hh_emptied_contents_location - Dont_know', CASE WHEN src.hh_emptied_contents_location LIKE '%dont_know%' THEN 1 ELSE 0 END),

        -- hh_handwashing_near_toilet_latrine (yes/no) - binary
        ('hh_handwashing_near_toilet_latrine - Yes', CASE WHEN src.hh_handwashing_near_toilet_latrine = 'yes' THEN 1 ELSE 0 END),
        ('hh_handwashing_near_toilet_latrine - No', CASE WHEN src.hh_handwashing_near_toilet_latrine = 'no' THEN 1 ELSE 0 END),

        -- hh_handwashing_facility_status (water_soap_available/only_water_available/only_soap_available/water_soap_not_available) - binary
        ('hh_handwashing_facility_status - Water_soap_available', CASE WHEN src.hh_handwashing_facility_status LIKE '%water_soap_available%' THEN 1 ELSE 0 END)
        ('hh_handwashing_facility_status - Only_water_available', CASE WHEN src.hh_handwashing_facility_status LIKE '%only_water_available%' THEN 1 ELSE 0 END),
        ('hh_handwashing_facility_status - Only_soap_available', CASE WHEN src.hh_handwashing_facility_status LIKE '%only_soap_available%' THEN 1 ELSE 0 END),
        ('hh_handwashing_facility_status - Water_soap_not_available', CASE WHEN src.hh_handwashing_facility_status LIKE '%water_soap_not_available%' THEN 1 ELSE 0 END),

        -- hh_is_odf (yes/no) - binary
        ('hh_is_odf - Yes', CASE WHEN src.hh_is_odf = 'yes' THEN 1 ELSE 0 END),
        ('hh_is_odf - No', CASE WHEN src.hh_is_odf = 'no' THEN 1 ELSE 0 END),

        -- hh_have_drying_lines (yes/no) - binary
        ('hh_have_drying_lines - Yes', CASE WHEN src.hh_have_drying_lines = 'yes' THEN 1 ELSE 0 END),
        ('hh_have_drying_lines - No', CASE WHEN src.hh_have_drying_lines = 'no' THEN 1 ELSE 0 END),

        -- hh_have_animal_house (yes/no) - binary
        ('hh_have_animal_house - Yes', CASE WHEN src.hh_have_animal_house = 'yes' THEN 1 ELSE 0 END),
        ('hh_have_animal_house - No', CASE WHEN src.hh_have_animal_house = 'no' THEN 1 ELSE 0 END),

        -- hh_have_food_storage_access (yes/no) - binary
        ('hh_have_food_storage_access - Yes', CASE WHEN src.hh_have_food_storage_access = 'yes' THEN 1 ELSE 0 END),
        ('hh_have_food_storage_access - No', CASE WHEN src.hh_have_food_storage_access = 'no' THEN 1 ELSE 0 END),

        -- hh_compound_well_maintained (yes/no) - binary
        ('hh_compound_well_maintained - Yes', CASE WHEN src.hh_compound_well_maintained = 'yes' THEN 1 ELSE 0 END),
        ('hh_compound_well_maintained - No', CASE WHEN src.hh_compound_well_maintained = 'no' THEN 1 ELSE 0 END),

        -- hh_have_vermin_rodent (yes/no) - binary
        ('hh_have_vermin_rodent - Yes', CASE WHEN src.hh_have_vermin_rodent = 'yes' THEN 1 ELSE 0 END),
        ('hh_have_vermin_rodent - No', CASE WHEN src.hh_have_vermin_rodent = 'no' THEN 1 ELSE 0 END),

        -- follow_household (yes/no) - binary
        ('follow_household - Yes', CASE WHEN src.follow_household = 'yes' THEN 1 ELSE 0 END),
        ('follow_household - No', CASE WHEN src.follow_household = 'no' THEN 1 ELSE 0 END),

        -- is_model_household (true/false) - binary
        ('is_model_household - True', CASE WHEN src.is_model_household = 'true' THEN 1 ELSE 0 END),
        ('is_model_household - False', CASE WHEN src.is_model_household = 'false' THEN 1 ELSE 0 END)
) AS unpivot(data_element, value)
WHERE value = 1;