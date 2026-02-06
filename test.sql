CREATE MATERIALIZED VIEW cht.mv_maternal_health_education
TABLESPACE ts_report
AS
SELECT
   --- Identifiers 
      doc ->> '_id'::text                              AS uuid
    , doc ->> 'form'::text                             AS form
    , to_timestamp((NULLIF(doc ->> 'reported_date'::text, ''::text)::bigint / 1000)::double precision) AS reported
    , doc ->> 'from'::text                             AS submitter

   -- Top-level metadata 
    , doc ->> '_rev'::text                             AS rev                               
    , doc ->> 'content_type'::text                     AS top_content_type                      
    , to_timestamp(NULLIF(doc #>> '{form_version,time}', '')::bigint / 1000.0) AS form_version_time 
    , to_timestamp(NULLIF(doc #>> '{geolocation_log,0,timestamp}', '')::bigint / 1000.0) AS geolog_first_time 

    -- client details
    , doc #>> '{fields,current_pregnancy_age_in_weeks}'::text[] AS pregnancy_age_in_weeks
    , doc #>> '{fields,health_education,select_health_condition}'::text[] AS topic /*signs_of_pregnancy/
care_during_pregnancy/anc_attendance/nutrition_in_pregnancy/risk_factor_to_high_risk_pregnancy/
common_problems_in_pregnancy/danger_signs_in_pregnancy/protecting_babies_from_hiv/myths_and_misconceptions_pregnancy/
birth_plan/what_to_do_labour/care_after_child_birth/nutrition_after_birth/when_to_start_breastfeeding/
danger_signs_child_birth/family_planning*/

    , doc #>> '{fields,inputs,anc_visits}'::text[]               AS anc_visits
    , doc #>> '{fields,inputs,contact,date_of_birth}'::text[]    AS patient_date_of_birth
    , doc #>> '{fields,inputs,contact,has_hypertension}'::text[] AS has_hypertension
    , doc #>> '{fields,inputs,contact,hiv_test_result}'::text[]  AS hiv_test_result
    , doc #>> '{fields,inputs,contact,sex}'::text[]              AS sex
    , doc #>> '{fields,inputs,current_edd_std}'::text[]          AS current_edd_std
    , doc #>> '{fields,inputs,t_blurred_vision}'::text[]         AS t_blurred_vision
    , doc #>> '{fields,inputs,t_breathlessness}'::text[]         AS t_breathlessness
    , doc #>> '{fields,inputs,t_fever}'::text[]                  AS t_fever
    , doc #>> '{fields,inputs,t_has_hypertension}'::text[]       AS t_has_hypertension
    , doc #>> '{fields,inputs,t_hiv_test_result}'::text[]        AS t_hiv_test_result
    , doc #>> '{fields,inputs,t_lower_abdomen_pain}'::text[]     AS t_lower_abdomen_pain
    , doc #>> '{fields,inputs,t_patient_date_of_birth}'::text[]  AS t_patient_date_of_birth
    , doc #>> '{fields,inputs,t_patient_gender}'::text[]         AS t_patient_gender
    , doc #>> '{fields,inputs,t_patient_id}'::text[]             AS t_patient_id
    , doc #>> '{fields,inputs,t_patient_name}'::text[]           AS t_patient_name
    , doc #>> '{fields,inputs,t_reduced_or_no_feotal_movements}'::text[] AS t_reduced_or_no_feotal_movements
    , doc #>> '{fields,inputs,t_severe_headache}'::text[]        AS t_severe_headache
    , doc #>> '{fields,inputs,t_swelling}'::text[]               AS t_swelling
    , doc #>> '{fields,inputs,t_vaginal_bleeding}'::text[]       AS t_vaginal_bleeding
    , doc #>> '{fields,inputs,t_very_pale}'::text[]              AS t_very_pale
    , doc #>> '{fields,inputs,user,contact_id}'::text[]          AS chw_area_id
    , doc #>> '{fields,inputs,user,facility_id}'::text[]         AS facility_id
    , doc #>> '{fields,needs_signoff}'::text[]                   AS needs_signoff --(true)
    , doc #>> '{fields,no_pregnancy_danger_sign}'::text[]        AS no_pregnancy_danger_sign --(yes/no)
    , doc #>> '{fields,no_pregnancy_risk_factor}'::text[]        AS no_pregnancy_risk_factor --(true/false)
    , doc #>> '{fields,patient_age_display}'::text[]             AS patient_age_display
    , doc #>> '{fields,patient_age_in_days}'::text[]             AS patient_age_in_days
    , doc #>> '{fields,patient_age_in_months}'::text[]           AS patient_age_in_months
    , doc #>> '{fields,patient_age_in_years}'::text[]            AS patient_age_in_years
    , doc #>> '{fields,patient_gender}'::text[]                  AS patient_gender
    , doc #>> '{fields,pregnancy_details,is_pregnant}'::text[]   AS is_pregnant --(yes/no)
    , doc #>> '{fields,pregnancy_details,next_maternal_health_date}'::text[] AS next_maternal_health_date
    , doc #>> '{fields,pregnancy_details,pregnancy_outcome}'::text[] AS pregnancy_outcome --(woman_delivered/woman_had_miscarriage)

    --- pregnancy_details
    , doc #>> '{fields,pregnancy_details,pregnancy_risk_none}'      AS pregnancy_risk_none        
    , doc #>> '{fields,pregnancy_details,pregnancy_danger_signs}'   AS pregnancy_danger_signs       
    , doc #>> '{fields,pregnancy_details,pregnancy_risk_factors}'   AS pregnancy_risk_factors      
    , doc #>> '{fields,pregnancy_details,patient_pregnancy_details}' AS patient_pregnancy_details   
    , doc #>> '{fields,group_patient_summary,findings}'             AS findings                
    , doc #>> '{fields,group_patient_summary,education_given}'      AS education_given        
    , doc #>> '{fields,group_patient_summary,follow_up_tasks}'      AS follow_up_tasks          
    , doc #>> '{fields,group_patient_summary,follow_up_task_date}'  AS follow_up_task_date      
    , doc #>> '{fields,group_patient_summary,s_note_patient_details}' AS note_patient_details 
    , doc #>> '{fields,group_patient_summary,s_note_patient_details_values}' AS note_patient_details_values 

    --- reporting hierarchy              
    doc #>> '{contact,parent,parent,_id}'                  AS facility__id,              
    doc #>> '{contact,parent,parent,parent,_id}'           AS parish__id,                 
    doc #>> '{contact,parent,parent,parent,parent,_id}'    AS region__id  

FROM dwh.cht_data couchdb
WHERE (doc ->> 'form'::text) = 'maternal_health_education'::text
  AND is_current
WITH DATA;

-- Unique index
CREATE UNIQUE INDEX useview_maternal_health_education_uuid
    ON cht.mv_maternal_health_education USING btree (uuid);

-- Helpful additional indexes
CREATE INDEX useview_maternal_health_education_reported
    ON cht.mv_maternal_health_education USING btree (reported);
CREATE INDEX useview_maternal_health_education_patient
    ON cht.mv_maternal_health_education USING btree ((doc #>> '{fields,patient_id}'));
