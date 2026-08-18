-- cht.mv_chew_family_planning source
-- Form: chew_family_planning (CHEWs FP Form) — place-context (c40-parish), mayuge/namayingo/iganga
DROP MATERIALIZED VIEW IF EXISTS cht.mv_chew_family_planning;
CREATE MATERIALIZED VIEW cht.mv_chew_family_planning
TABLESPACE ts_report
AS SELECT doc ->> '_id'::text AS uuid,
    doc ->> 'form'::text AS form,
    doc ->> 'from'::text AS submitter,
    to_timestamp((NULLIF(doc ->> 'reported_date'::text, ''::text)::bigint / 1000)::double precision) AS reported,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY-MM-DD'))::date AS date,
    (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY'))::INT AS year,
    to_char(to_timestamp((((doc ->>'reported_date'::text)::bigint) / 1000)::double precision), 'MM'::text)::integer AS month,
    TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'FMMonth') AS monthname,
    ((doc -> 'fields'::text) -> 'meta'::text) ->> 'instanceID'::text AS instanceid,
    (((doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) ->> 'deprecatedID'::text AS deprecatedid,
    ((((doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) -> 'location'::text) ->> 'lat'::text AS location_lat,
    ((((doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) -> 'location'::text) ->> 'long'::text AS location_long,
    ((((doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) -> 'location'::text) ->> 'error'::text AS location_error,
    ((((doc -> 'fields'::text) -> 'inputs'::text) -> 'meta'::text) -> 'location'::text) ->> 'message'::text AS location_message,
    (doc -> 'geolocation'::text) ->> 'code'::text AS geolocation_code,
    (doc -> 'geolocation'::text) ->> 'message'::text AS geolocation_message,
    (NULLIF((doc -> 'geolocation'::text) ->> 'latitude'::text, ''::text))::double precision AS geolocation_latitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'longitude'::text, ''::text))::double precision AS geolocation_longitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'altitude'::text, ''::text))::double precision AS geolocation_altitude,
    (NULLIF((doc -> 'geolocation'::text) ->> 'accuracy'::text, ''::text))::double precision AS geolocation_accuracy,
    (NULLIF((doc -> 'geolocation'::text) ->> 'altitudeAccuracy'::text, ''::text))::double precision AS geolocation_altitude_accuracy,
    (NULLIF((doc -> 'geolocation'::text) ->> 'speed'::text, ''::text))::double precision AS geolocation_speed,
    (NULLIF((doc -> 'geolocation'::text) ->> 'heading'::text, ''::text))::double precision AS geolocation_heading,
    doc #>> '{fields,inputs,meta,location,lat}'::text[] AS inputs_location_lat,
    doc #>> '{fields,inputs,meta,location,long}'::text[] AS inputs_location_long,
    doc #>> '{fields,inputs,meta,location,error}'::text[] AS inputs_location_error,
    doc #>> '{fields,inputs,meta,location,message}'::text[] AS inputs_location_message,
    doc #>> '{fields,inputs,source}'::text[] AS inputs_source,
    doc #>> '{fields,inputs,source_id}'::text[] AS inputs_source_id,
    doc #>> '{fields,inputs,user,contact_id}'::text[] AS inputs_user_contact_id,
    doc #>> '{fields,inputs,user,facility_id}'::text[] AS inputs_user_facility_id,
    doc #>> '{fields,inputs,contact,_id}'::text[] AS inputs_contact_id,
    doc #>> '{fields,inputs,contact,name}'::text[] AS inputs_contact_name,
    doc #>> '{fields,inputs,contact,contact,_id}'::text[] AS inputs_contact_contact_id,
    doc #>> '{fields,inputs,contact,contact,name}'::text[] AS inputs_contact_contact_name,
    doc #>> '{fields,inputs,contact,contact,date_of_birth}'::text[] AS inputs_contact_contact_date_of_birth,
    doc #>> '{fields,inputs,contact,contact,phone}'::text[] AS inputs_contact_contact_phone,
    -- Form-specific fields (from chew_family_planning.xml; display-only notes excluded)
    doc #>> '{fields,chew_name}'::text[] AS chew_name,
    doc #>> '{fields,chew_phone}'::text[] AS chew_phone,
    doc #>> '{fields,place_id}'::text[] AS place_id,
    doc #>> '{fields,place_name}'::text[] AS place_name,
    doc #>> '{fields,start_time}'::text[] AS start_time,
    doc #>> '{fields,visit_grp,visit_date}'::text[] AS visit_date,
    doc #>> '{fields,visit_grp,age}'::text[] AS age,
    doc #>> '{fields,visit_grp,client_type}'::text[] AS client_type,
    doc #>> '{fields,visit_grp,service_today}'::text[] AS service_today,
    doc #>> '{fields,screen_grp,eligible}'::text[] AS eligible,
    doc #>> '{fields,screen_grp,not_eligible_reason}'::text[] AS not_eligible_reason,
    doc #>> '{fields,insert_grp,insert_arm}'::text[] AS insert_arm,
    doc #>> '{fields,insert_grp,insertion_outcome}'::text[] AS insertion_outcome,
    doc #>> '{fields,insert_grp,insertion_issue}'::text[] AS insertion_issue,
    doc #>> '{fields,insert_grp,removal_due_date}'::text[] AS removal_due_date,
    doc #>> '{fields,fu_grp,side_effects_reported}'::text[] AS side_effects_reported,
    doc #>> '{fields,fu_grp,side_effects}'::text[] AS side_effects,
    doc #>> '{fields,fu_grp,followup_plan}'::text[] AS followup_plan,
    doc #>> '{fields,fu_grp,followup_date}'::text[] AS followup_date,
    doc #>> '{fields,fu_grp,notes}'::text[] AS notes,
    doc #>> '{contact,_id}'                         AS chw_id,
      h.facility,
      h.dhis2_facility_id,
      h.village,
      h.parish,
      h.district,
      h.region,
      CURRENT_TIMESTAMP                                 AS last_refresh_date
   FROM dwh.cht_data couchdb
LEFT JOIN cht.mv_chw_hierarchy h ON (couchdb.doc #>> '{contact,_id}') = h.chw_id
  WHERE (doc ->> 'form'::text) = 'chew_family_planning'::text AND is_current
WITH NO DATA;

-- Indexes for cht.mv_chew_family_planning
CREATE INDEX idx_mv_chew_family_planning_chw_year_month
  ON cht.mv_chew_family_planning (chw_id, year, month) tablespace ts_indexes;
CREATE INDEX idx_mv_chew_family_planning_chw_date
  ON cht.mv_chew_family_planning (chw_id, date) tablespace ts_indexes;
CREATE INDEX idx_mv_chew_family_planning_chw_reported
  ON cht.mv_chew_family_planning (chw_id, reported) tablespace ts_indexes;
CREATE INDEX idx_mv_chew_family_planning_place_id
  ON cht.mv_chew_family_planning (place_id) tablespace ts_indexes;
CREATE INDEX idx_mv_chew_family_planning_year_month_district
  ON cht.mv_chew_family_planning USING btree (year, month, district) TABLESPACE ts_indexes;
