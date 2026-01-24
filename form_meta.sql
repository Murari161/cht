-- cht.form_metadata source

CREATE MATERIALIZED VIEW cht.form_metadata
TABLESPACE ts_report
AS SELECT doc ->> '_id'::text AS uuid,
    doc #>> '{contact,_id}'::text[] AS reported_by,
    doc #>> '{contact,_id}'::text[] AS chw,
    sup_users.fullname AS supervisor_name,
    vht_users.fullname AS vht_name,
    contactview.facility AS facility_name,
    contactview.district AS district,
    to_timestamp((NULLIF(doc ->> 'reported_date'::text, ''::text)::bigint / 1000)::double precision) AS reported,
    doc #>> '{contact,parent,_id}'::text[] AS reported_by_parent,
    COALESCE(doc ->> 'patient_id'::text, doc #>> '{fields,patient_id}'::text[]) AS patient_id,
    doc ->> 'form'::text AS form,
    doc ->> 'form'::text AS formname,
    COALESCE(doc ->> 'errors'::text, '[]'::text) <> '[]'::text AS errors,
    CASE
            WHEN (doc -> 'roles'::text) = '["chew", "super_chew"]'::jsonb THEN 'SUPER CHEW'::text
            WHEN (doc -> 'roles'::text) = '["chew"]'::jsonb THEN 'CHEW'::text
            WHEN (EXISTS ( SELECT 1
               FROM jsonb_array_elements_text(form.doc -> 'roles'::text) r(role)
              WHERE r.role = 'chew'::text)) THEN 'CHEW'::text
            WHEN (EXISTS ( SELECT 1
               FROM jsonb_array_elements_text(form.doc -> 'roles'::text) r(role)
              WHERE r.role = 'vht'::text)) THEN 'VHT'::text
            ELSE 'OTHER'::text
        END AS role
   FROM dwh.cht_data form  
LEFT JOIN cht.mv_cht_users sup_users ON (form.doc #>> '{contact,_id}'::text[]) = sup_users.contact_id
     LEFT JOIN cht.contactview_vht contactview ON (form.doc #>> '{fields,inputs,contact,_id}'::text[]) = contactview.area_uuid
     LEFT JOIN cht.mv_cht_users vht_users ON contactview.uuid = vht_users.contact_id
WHERE ((doc ->> 'type'::text) = 'data_record'::text 
AND (doc #>> '{contact,_id}'::text[]) IS NOT NULL 
AND (doc ->> 'form'::text) IS NOT NULL
AND is_current = true) 
OR type = 'user-settings'::text
WITH DATA;

-- View indexes:
CREATE INDEX form_metadata_chw ON cht.form_metadata USING btree (chw);
CREATE INDEX form_metadata_form ON cht.form_metadata USING btree (form);
CREATE INDEX form_metadata_formname ON cht.form_metadata USING btree (formname);
CREATE INDEX form_metadata_patient_id ON cht.form_metadata USING btree (patient_id);
CREATE INDEX form_metadata_reported ON cht.form_metadata USING btree (reported);
CREATE INDEX form_metadata_reported_by ON cht.form_metadata USING btree (reported_by);
CREATE INDEX form_metadata_reported_by_parent ON cht.form_metadata USING btree (reported_by_parent);
CREATE UNIQUE INDEX form_metadata_uuid ON cht.form_metadata USING btree (uuid);