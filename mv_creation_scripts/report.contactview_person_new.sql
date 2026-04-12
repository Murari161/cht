CREATE MATERIALIZED VIEW report.contactview_person_new
TABLESPACE ts_report
AS SELECT doc ->> '_id'::text AS uuid,
    doc ->> 'name'::text AS name,
    COALESCE(doc ->> 'patient_id'::text, doc ->> '_id'::text) AS patient_id,
        CASE
            WHEN NULLIF(doc ->> 'date_of_birth'::text, ''::text) IS NULL THEN NULL::date

            -- Valid YYYY-MM-DD
            WHEN (doc ->> 'date_of_birth'::text) ~ '^\d{4}-\d{2}-\d{2}$'
                AND substring(doc ->> 'date_of_birth',6,2)::int <= 12
                AND substring(doc ->> 'date_of_birth',9,2)::int <= 31
            THEN to_date(doc ->> 'date_of_birth', 'YYYY-MM-DD')

            -- Valid MM/DD/YYYY
            WHEN (doc ->> 'date_of_birth') ~ '^\d{2}/\d{2}/\d{4}$'
            THEN to_date(doc ->> 'date_of_birth', 'MM/DD/YYYY')

            ELSE NULL::date
        END AS date_of_birth,
    COALESCE(doc ->> 'sex'::text, ''::text) AS sex,
    COALESCE(doc ->> 'phone'::text, ''::text) AS phone,
    date_part('year'::text, age(to_timestamp((NULLIF(doc ->> 'reported_date'::text, ''::text)::bigint / 1000)::double precision),
        CASE
            WHEN NULLIF(doc ->> 'date_of_birth'::text, ''::text) IS NULL THEN NULL::date
            
            -- Valid YYYY-MM-DD with validation (same as above)
            WHEN (doc ->> 'date_of_birth'::text) ~ '^\d{4}-\d{2}-\d{2}$'
                AND substring(doc ->> 'date_of_birth',6,2)::int <= 12
                AND substring(doc ->> 'date_of_birth',9,2)::int <= 31
            THEN to_date(doc ->> 'date_of_birth'::text, 'YYYY-MM-DD'::text)
            
            -- Valid MM/DD/YYYY
            WHEN (doc ->> 'date_of_birth'::text) ~ '^\d{2}/\d{2}/\d{4}$'
            THEN to_date(doc ->> 'date_of_birth'::text, 'MM/DD/YYYY'::text)

            ELSE NULL::date
        END::timestamp with time zone)) AS age_at_registration,
    COALESCE(doc #>> '{parent,_id}'::text[], ''::text) AS parent_uuid,
    COALESCE(doc #>> '{parent,parent,_id}'::text[], ''::text) AS parent_parent_uuid,
    COALESCE(doc #>> '{parent,parent,parent,_id}'::text[], ''::text) AS parent_parent_parent_uuid,
    to_timestamp((NULLIF(doc ->> 'reported_date'::text, ''::text)::bigint / 1000)::double precision) AS reported,
    doc #>> '{relationship_with_hh}'::text[] AS relationship_with_hh,
    COALESCE(doc ->> 'received_hpv'::text, ''::text) AS received_hpv,
    COALESCE(doc ->> 'received_tt_vaccine'::text, ''::text) AS received_tt_vaccine,
    COALESCE(doc ->> 'on_art_treatment'::text, ''::text) AS on_art_treatment,
    COALESCE(doc ->> 'has_tb'::text, ''::text) AS has_tb,
    COALESCE(doc ->> 'on_tb_treatment'::text, ''::text) AS on_tb_treatment,
    COALESCE(doc ->> 'hiv_test_result'::text, ''::text) AS hiv_test_result,
    COALESCE(doc ->> 'using_fp_method'::text, ''::text) AS using_fp_method,
    COALESCE(doc ->> 'sleep_under_llin'::text, ''::text) AS sleep_under_llin,
    COALESCE(doc ->> 'has_disability'::text, ''::text) AS has_disability,
    COALESCE(doc ->> 'disability'::text, ''::text) AS disability,
    COALESCE(doc ->> 'created_by_doc'::text, ''::text) AS created_by_doc
   FROM dwh.cht_data
  WHERE (doc ->> 'type'::text) = 'person'::text AND is_current = true
WITH DATA;