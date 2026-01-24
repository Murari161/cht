-- cht.contactview_vht source

CREATE MATERIALIZED VIEW cht.contactview_vht
TABLESPACE ts_report
AS SELECT c_person.doc ->> 'name'::text AS name,
    to_timestamp((NULLIF(c_area.doc ->> 'reported_date'::text, ''::text)::bigint / 1000)::double precision) AS reported,
    c_person.doc ->> '_id'::text AS uuid,
    NOT user_settings.roles @> '["deactivated"]'::jsonb AS active,
    user_settings.username,
    c_person.doc ->> 'phone'::text AS phone,
    c_person.doc ->> 'phone2'::text AS phone2,
    c_person.doc ->> 'date_of_birth'::text AS date_of_birth,
    c_person.doc ->> 'sex'::text AS sex,
    c_area.doc ->> 'contact_type'::text AS parent_type,
    c_area.doc ->> '_id'::text AS area_uuid,
    c_facility.doc ->> '_id'::text AS branch_uuid,
    c_facility.doc ->> 'name'::text AS branch_name,
    NULLIF((c_facility.doc -> 'contact'::text) ->> '_id'::text, ''::text) AS supervisor_uuid,
    c_district.doc ->> 'name'::text AS district,
    c_area.doc ->> 'sub_district'::text AS sub_district,
    c_area.doc ->> 'sub_county'::text AS sub_county,
    parish.doc ->> 'name'::text AS parish,
    c_facility.doc ->> 'name'::text AS facility,
    c_facility.doc ->> 'external_id'::text AS dhis2_facility_id,
    c_area.doc ->> 'village'::text AS village
   FROM dwh.cht_data c_area
     JOIN dwh.cht_data c_person ON (c_area.doc #>> '{contact,_id}'::text[]) = (c_person.doc ->> '_id'::text) AND (c_person.doc ->> 'type'::text) = 'person'::text
     JOIN dwh.cht_data parish ON (c_area.doc #>> '{parent,_id}'::text[]) = (parish.doc ->> '_id'::text) AND (parish.doc ->> 'contact_type'::text) = 'c40-parish'::text
     JOIN dwh.cht_data c_facility ON (c_area.doc #>> '{parent,parent,_id}'::text[]) = (c_facility.doc ->> '_id'::text) AND (c_facility.doc ->> 'contact_type'::text) = 'c30-district_hospital'::text
     JOIN dwh.cht_data c_district ON (c_facility.doc #>> '{parent,_id}'::text[]) = (c_district.doc ->> '_id'::text) AND (c_district.doc ->> 'type'::text) = 'contact'::text AND (c_district.doc ->> 'contact_type'::text) = 'c20-district'::text
     LEFT JOIN ( SELECT c.doc ->> 'contact_id'::text AS contact_id,
            (c.doc ->> 'roles'::text)::jsonb AS roles,
            string_agg(c.doc ->> 'name'::text, ', '::text) AS username
           FROM dwh.cht_data c
          WHERE (c.doc ->> 'type'::text) = 'user-settings'::text AND c.is_current = true
          GROUP BY (c.doc ->> 'contact_id'::text), (c.doc ->> 'roles'::text)) user_settings ON user_settings.contact_id = (c_person.doc ->> '_id'::text)
  WHERE (c_area.doc ->> 'contact_type'::text) = 'c50-health_center'::text AND c_area.is_current = true
WITH DATA;

-- View indexes:
CREATE INDEX contactview_vht_area_uuid ON cht.contactview_vht USING btree (area_uuid);
CREATE INDEX contactview_vht_branch_uuid ON cht.contactview_vht USING btree (branch_uuid);
CREATE INDEX contactview_vht_district ON cht.contactview_vht USING btree (district);
CREATE INDEX contactview_vht_facility ON cht.contactview_vht USING btree (facility);
CREATE INDEX contactview_vht_facility_dhis2_id ON cht.contactview_vht USING btree (dhis2_facility_id);
CREATE INDEX contactview_vht_parish ON cht.contactview_vht USING btree (parish);
CREATE INDEX contactview_vht_reported ON cht.contactview_vht USING btree (reported);
CREATE INDEX contactview_vht_sub_county ON cht.contactview_vht USING btree (sub_county);
CREATE INDEX contactview_vht_sub_district ON cht.contactview_vht USING btree (sub_district);
CREATE INDEX contactview_vht_supervisor_uuid ON cht.contactview_vht USING btree (supervisor_uuid);
CREATE INDEX contactview_vht_village ON cht.contactview_vht USING btree (village);