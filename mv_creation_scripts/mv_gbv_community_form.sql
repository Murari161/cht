CREATE MATERIALIZED VIEW cht.mv_gbv_community_form
TABLESPACE ts_report
AS SELECT 
    doc ->> '_id' AS uuid,
    doc ->> 'form' AS form,
    doc ->> '_rev' AS rev,
    
    -- Date derivations
    to_timestamp((NULLIF(doc ->> 'reported_date'::text, ''::text)::bigint / 1000)::double precision) AS reported,
    to_char(to_timestamp((((doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'YYYY-MM-DD'::text)::date AS date,
    to_char(to_timestamp((((doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'YYYY'::text)::integer AS year,
    to_char(to_timestamp((((doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'MM'::text)::integer AS month,
    to_char(to_timestamp((((doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'FMMonth'::text) AS monthname,
    
    -- Meta
    (doc -> 'fields' -> 'meta') ->> 'instanceID' AS instanceid,
    
    -- Inputs/Meta/Location
    (((doc -> 'fields' -> 'inputs' -> 'meta') -> 'location')) ->> 'lat' AS "Location Lat",
    (((doc -> 'fields' -> 'inputs' -> 'meta') -> 'location')) ->> 'long' AS "Location Long",
    (((doc -> 'fields' -> 'inputs' -> 'meta') -> 'location')) ->> 'error' AS "Location Error",
    (((doc -> 'fields' -> 'inputs' -> 'meta') -> 'location')) ->> 'message' AS "Location Message",
    
    -- Inputs
    (doc -> 'fields' -> 'inputs') ->> 'source' AS "Source",
    (doc -> 'fields' -> 'inputs') ->> 'source_id' AS "Source ID",
    
    -- User
    ((doc -> 'fields' -> 'inputs' -> 'user')) ->> 'contact_id' AS "User Contact ID",
    ((doc -> 'fields' -> 'inputs' -> 'user')) ->> 'facility_id' AS "User Facility ID",
    
    -- Contact
    ((doc -> 'fields' -> 'inputs' -> 'contact')) ->> '_id' AS "CHEW Area Id",
    ((doc -> 'fields' -> 'inputs' -> 'contact')) ->> 'name' AS "CHEW Area Name",
    
    -- Contact/Contact (nested)
    (((doc -> 'fields' -> 'inputs' -> 'contact') -> 'contact')) ->> '_id' AS "CHEW ID",
    (((doc -> 'fields' -> 'inputs' -> 'contact') -> 'contact')) ->> 'name' AS "CHEW Name",
    (((doc -> 'fields' -> 'inputs' -> 'contact') -> 'contact')) ->> 'date_of_birth' AS "CHEW Date of Birth",
    (((doc -> 'fields' -> 'inputs' -> 'contact') -> 'contact')) ->> 'phone' AS "Phone",
    
    -- Calculates
    (doc -> 'fields') ->> 'chew_name' AS "CHEW Name (calculated)",
    (doc -> 'fields') ->> 'chew_phone' AS "CHEW Phone (calculated)",
    (doc -> 'fields') ->> 'place_id' AS "ID",
    (doc -> 'fields') ->> 'place_name' AS "Name",
    (doc -> 'fields') ->> 'start_time' AS "Time interview starts (system)",
    
    -- Opening Group
    ((doc -> 'fields' -> 'opening')) ->> 'note1_1' AS "Opening Note 1-1",
    ((doc -> 'fields' -> 'opening')) ->> 'tool' AS "Please select an interview to be conducted",
    ((doc -> 'fields' -> 'opening')) ->> 'consent' AS "Has the respondent agreed to be interviewed?",
    
    (doc -> 'fields') ->> 'tool_label' AS "Tool Label (calculated)",
    (doc -> 'fields') ->> 'interview_date' AS "Interview Date (calculated)",
    (doc -> 'fields') ->> 'interviewer' AS "Interviewer (calculated)",
    
    -- LC1 Group - Local council (chairperson or designee)
    ((doc -> 'fields' -> 'lc1_group')) ->> 'note1_lc' AS "LC1 Note 1-LC",
    ((doc -> 'fields' -> 'lc1_group')) ->> 'lc1' AS "LC1: Aware of physical violence in past 3 months?",
    ((doc -> 'fields' -> 'lc1_group')) ->> 'lc2' AS "LC2: Heard of sexual violence in past 3 months?",
    ((doc -> 'fields' -> 'lc1_group')) ->> 'lc4' AS "LC4: Total cases of violence/child abuse (past 3 months)",
    ((doc -> 'fields' -> 'lc1_group')) ->> 'lc4_calc' AS "LC4 Calculated",
    ((doc -> 'fields' -> 'lc1_group')) ->> 'lc15' AS "LC15: Risky households/locations/circumstances?",
    ((doc -> 'fields' -> 'lc1_group')) ->> 'lc15b' AS "LC15B: Which kind of households?",
    ((doc -> 'fields' -> 'lc1_group')) ->> 'lc16' AS "LC16: How are survivors helped?",
    ((doc -> 'fields' -> 'lc1_group')) ->> 'lccases_repeat_count' AS "LCCases Repeat Count",
    
    -- HM Group - School (head teacher or designee)
    ((doc -> 'fields' -> 'hm_group')) ->> 'note1_hm' AS "HM Note 1-HM",
    ((doc -> 'fields' -> 'hm_group')) ->> 'hm1' AS "HM1: Learners reported sexual touching/force?",
    ((doc -> 'fields' -> 'hm_group')) ->> 'hm2' AS "HM2: How many learners reported?",
    ((doc -> 'fields' -> 'hm_group')) ->> 'hm2_calc' AS "HM2 Calculated",
    ((doc -> 'fields' -> 'hm_group')) ->> 'hm11' AS "HM11: Unsafe places/situations at school?",
    ((doc -> 'fields' -> 'hm_group')) ->> 'hm12' AS "HM12: When/where do concerns occur?",
    ((doc -> 'fields' -> 'hm_group')) ->> 'hm12oth' AS "HM12 Other",
    ((doc -> 'fields' -> 'hm_group')) ->> 'hm13' AS "HM13: Gifts for sexual acts?",
    ((doc -> 'fields' -> 'hm_group')) ->> 'hm14' AS "HM14: Were they linked to care?",
    ((doc -> 'fields' -> 'hm_group')) ->> 'hm14b' AS "HM14B: Where linked?",
    ((doc -> 'fields' -> 'hm_group')) ->> 'hm14both' AS "HM14 Both",
    ((doc -> 'fields' -> 'hm_group')) ->> 'hm15' AS "HM15: Who gives gifts?",
    ((doc -> 'fields' -> 'hm_group')) ->> 'hm16' AS "HM16: Coerced/promised help?",
    ((doc -> 'fields' -> 'hm_group')) ->> 'hm17' AS "HM17: How were they helped?",
    ((doc -> 'fields' -> 'hm_group')) ->> 'hm17oth' AS "HM17 Other",
    ((doc -> 'fields' -> 'hm_group')) ->> 'schcases_repeat_count' AS "School Cases Repeat Count",
    
    -- HH Group - Household member
    ((doc -> 'fields' -> 'hh_group')) ->> 'note1_hh' AS "HH Note 1-HH",
    ((doc -> 'fields' -> 'hh_group')) ->> 'hh1' AS "HH1: Household member physically/sexually harmed?",
    ((doc -> 'fields' -> 'hh_group')) ->> 'hh2' AS "HH2: Who was harmed (age)?",
    ((doc -> 'fields' -> 'hh_group')) ->> 'hh3' AS "HH3: Who was harmed (sex)?",
    ((doc -> 'fields' -> 'hh_group')) ->> 'hh4' AS "HH4: By who?",
    ((doc -> 'fields' -> 'hh_group')) ->> 'hh5' AS "HH5: Did survivors report/seek help?",
    ((doc -> 'fields' -> 'hh_group')) ->> 'hh6' AS "HH6: Where reported?",
    ((doc -> 'fields' -> 'hh_group')) ->> 'hh6oth' AS "HH6 Other",
    ((doc -> 'fields' -> 'hh_group')) ->> 'hh7' AS "HH7: Report barriers?",
    ((doc -> 'fields' -> 'hh_group')) ->> 'hh7oth' AS "HH7 Other",
    ((doc -> 'fields' -> 'hh_group')) ->> 'hh9' AS "HH9: Need immediate assistance?",
    ((doc -> 'fields' -> 'hh_group')) ->> 'hh10' AS "HH10: Victim has disability?",
    ((doc -> 'fields' -> 'hh_group')) ->> 'hh10b' AS "HH10B: Type of case",
    ((doc -> 'fields' -> 'hh_group')) ->> 'hh10c' AS "HH10C: Intimate-partner violence?",
    ((doc -> 'fields' -> 'hh_group')) ->> 'hh1note' AS "HH1 Note",
    
    -- PC Group - Case reported to CHW
    ((doc -> 'fields' -> 'pc_group')) ->> 'note1_pc' AS "PC Note 1-PC",
    ((doc -> 'fields' -> 'pc_group')) ->> 'pc1' AS "PC1: Who was harmed (age)?",
    ((doc -> 'fields' -> 'pc_group')) ->> 'pc2' AS "PC2: Who was harmed (sex)?",
    ((doc -> 'fields' -> 'pc_group')) ->> 'pc3' AS "PC3: By who?",
    ((doc -> 'fields' -> 'pc_group')) ->> 'pc4' AS "PC4: Type of violence?",
    ((doc -> 'fields' -> 'pc_group')) ->> 'pc5' AS "PC5: Where did it happen?",
    ((doc -> 'fields' -> 'pc_group')) ->> 'pc5oth' AS "PC5 Other",
    ((doc -> 'fields' -> 'pc_group')) ->> 'pc6a' AS "PC6A: Case referred?",
    ((doc -> 'fields' -> 'pc_group')) ->> 'pc6b' AS "PC6B: Where referred?",
    ((doc -> 'fields' -> 'pc_group')) ->> 'pc6both' AS "PC6 Both",
    ((doc -> 'fields' -> 'pc_group')) ->> 'pc7' AS "PC7: Victim has disability?",
    ((doc -> 'fields' -> 'pc_group')) ->> 'pc7b' AS "PC7B: Type of case",
    ((doc -> 'fields' -> 'pc_group')) ->> 'pc7c' AS "PC7C: Intimate-partner violence?",
    ((doc -> 'fields' -> 'pc_group')) ->> 'pc8' AS "PC8: Brief description",
    
    -- Closing
    (doc -> 'fields') ->> 'consenta' AS "If no consent, reason for refusal",
    (doc -> 'fields') ->> 'obs' AS "Record any helpful observation/comment",
    (doc -> 'fields') ->> 'end_time' AS "End Time (system)",
    
    -- Hierarchy
    doc #>> '{contact,_id}' AS chw_id,
    h.facility_name,
    h.village,
    h.district,
    h.region,
    
    CURRENT_TIMESTAMP AS last_refresh_date

FROM dwh.cht_data d
LEFT JOIN cht.mv_chew_hierarchy_3 h ON (doc #>> '{contact,_id}') = h.chw_id
WHERE (doc ->> 'form') = 'gbv_community_form'
  AND is_current
WITH DATA;

-- Indexes
CREATE INDEX mv_gbv_community_reported_idx ON cht.mv_gbv_community_form (reported);
CREATE INDEX mv_gbv_community_chw_idx ON cht.mv_gbv_community_form (chw_id);