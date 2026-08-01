--SELECT deps_save_and_drop_dependencies('public', 'mv_useview_mrdt_mismatch');
DROP MATERIALIZED VIEW IF EXISTS cht.mv_useview_mrdt_mismatch;
CREATE MATERIALIZED VIEW cht.mv_useview_mrdt_mismatch
tablespace ts_report AS
SELECT
  doc #>> '{_id}' AS uuid,
  to_timestamp((nullif(doc ->> 'reported_date'::text, ''::text)::bigint / 1000)::double precision) AS reported,
  (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY-MM-DD'))::date AS date,
  (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'YYYY'))::INT AS year,
  (TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'MM'))::INT AS month,
    TO_CHAR(TO_TIMESTAMP((doc->>'reported_date')::BIGINT / 1000), 'FMMonth') AS monthname,
  doc #>> '{contact,_id}'::text[] AS reported_by,
  doc #>> '{contact,parent,_id}'::text[] AS reported_by_parent,
  doc #>> '{fields,inputs,source}'::text[] AS source,
  doc #>> '{fields,inputs,source_id}'::text[] AS source_id,
  doc #>> '{fields,inputs,t_vht_name}'::text[] AS t_vht_name,
  doc #>> '{fields,inputs,t_vht_phone}'::text[] AS t_vht_phone,
  doc #>> '{fields,inputs,t_patient_name}'::text[] AS t_patient_name,
  doc #>> '{fields,inputs,t_vht_test_results}'::text[] AS t_vht_test_results,
  doc #>> '{fields,inputs,t_scanned_test_results}'::text[] AS t_scanned_test_results,
  doc #>> '{fields,inputs,user,contact_id}'::text[] AS contact_id,
  doc #>> '{fields,inputs,user,facility_id}'::text[] AS facility_id,
  doc #>> '{fields,inputs,contact,_id}'::text[] AS _id,
  doc #>> '{fields,inputs,contact,name}'::text[] AS name,
  doc #>> '{fields,inputs,contact,date_of_birth}'::text[] AS date_of_birth,
  doc #>> '{fields,inputs,contact,sex}'::text[] AS sex,
  doc #>> '{fields,patient_id}'::text[] AS patient_id,
  doc #>> '{fields,patient_name}'::text[] AS patient_name,
  doc #>> '{fields,needs_signoff}'::text[] AS needs_signoff,
  doc #>> '{fields,mrdt_discrepancy,vht_photo}'::text[] AS vht_photo,
  doc #>> '{fields,mrdt_discrepancy,confirm_mentorship}'::text[] AS confirm_mentorship,
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

WHERE
  doc ->> 'form' = 'mrdt_mismatch'
  AND is_current = true 
  WITH DATA;

--SELECT deps_restore_dependencies('public', 'mv_useview_mrdt_mismatch');

/* adding indexes */
CREATE INDEX mv_useview_mrdt_mismatch_uuid ON cht.mv_useview_mrdt_mismatch USING btree(uuid) tablespace ts_indexes;

/* permissions */
--ALTER MATERIALIZED VIEW cht.mv_useview_mrdt_mismatch OWNER TO vhtapp_access;
--GRANT SELECT ON cht.mv_useview_mrdt_mismatch TO analytics;
