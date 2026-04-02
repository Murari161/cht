-- cht.mv_vht_supervision source

CREATE MATERIALIZED VIEW cht.mv_vht_supervision
TABLESPACE ts_report
AS SELECT couchdb.doc ->> '_id'::text AS uuid,
    couchdb.doc ->> 'form'::text AS form,
    couchdb.doc ->> 'from'::text AS submitter,
    to_timestamp((NULLIF(couchdb.doc ->> 'reported_date'::text, ''::text)::bigint / 1000)::double precision) AS reported,
    to_char(to_timestamp((((couchdb.doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'YYYY-MM-DD'::text)::date AS date,
    to_char(to_timestamp((((couchdb.doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'YYYY'::text)::integer AS year,
    to_char(to_timestamp((((couchdb.doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'MM'::text)::integer AS month,
    to_char(to_timestamp((((couchdb.doc ->> 'reported_date'::text)::bigint) / 1000)::double precision), 'FMMonth'::text) AS monthname,
    ((couchdb.doc -> 'fields'::text) -> 'meta'::text) ->> 'instanceID'::text AS instanceid,
    (((couchdb.doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) ->> 'deprecatedID'::text AS deprecatedid,
    ((((couchdb.doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) -> 'location'::text) ->> 'lat'::text AS location_lat,
    ((((couchdb.doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) -> 'location'::text) ->> 'long'::text AS location_long,
    ((((couchdb.doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) -> 'location'::text) ->> 'error'::text AS location_error,
    ((((couchdb.doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) -> 'location'::text) ->> 'message'::text AS location_message,
    (couchdb.doc -> 'geolocation'::text) ->> 'code'::text AS geolocation_code,
    (couchdb.doc -> 'geolocation'::text) ->> 'message'::text AS geolocation_message,
    couchdb.doc #>> '{contact,_id}'::text[] AS vht_supervisor_id,
    sup_users.fullname AS supervisor_name,
    vht_users.fullname AS vht_name,
    couchdb.doc #>> '{contact,parent,_id}'::text[] AS facility_id,
    contactview.facility AS facility_name,
    couchdb.doc #>> '{contact,parent,parent,_id}'::text[] AS district_check,
    contactview.district AS district,
    couchdb.doc #>> '{contact,parent,parent,parent,_id}'::text[] AS region,
    couchdb.doc #>> '{fields,inputs,source}'::text[] AS inputs_source,
    couchdb.doc #>> '{fields,inputs,contact,_id}'::text[] AS vht_area_uuid,
    couchdb.doc #>> '{fields,inputs,contact,name}'::text[] AS vht_name_encrypted,
    couchdb.doc #>> '{fields,inputs,contact,contact,name}'::text[] AS inputs_contact_contact_name,
    couchdb.doc #>> '{fields,private}'::text[] AS private,
    couchdb.doc #>> '{fields,place_name}'::text[] AS place_name,
    couchdb.doc #>> '{fields,vht_supervised}'::text[] AS vht_supervised,
    couchdb.doc #>> '{fields,group_vht_supervision_status,vht_supervision_status}'::text[] AS vht_supervision_status,
    CURRENT_TIMESTAMP AS last_refresh_date
   FROM dwh.cht_data couchdb
     LEFT JOIN cht.mv_cht_users sup_users ON (couchdb.doc #>> '{contact,_id}'::text[]) = sup_users.contact_id
     LEFT JOIN report.contactview_vht contactview ON (couchdb.doc #>> '{fields,inputs,contact,_id}'::text[]) = contactview.area_uuid
     LEFT JOIN cht.mv_cht_users vht_users ON contactview.uuid = vht_users.contact_id
  WHERE (couchdb.doc ->> 'form'::text) = 'vht_supervision'::text AND couchdb.is_current
WITH DATA;

-- View indexes:
CREATE INDEX mv_vht_supervision_chw_id ON cht.mv_vht_supervision USING btree (vht_supervisor_id);
CREATE INDEX mv_vht_supervision_reported ON cht.mv_vht_supervision USING btree (reported);