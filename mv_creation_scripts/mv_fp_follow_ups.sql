DROP MATERIALIZED VIEW IF EXISTS cht.mv_useview_fp_follow_ups;
CREATE MATERIALIZED VIEW cht.mv_useview_fp_follow_ups AS
SELECT
  doc ->> '_id' AS uuid,
  doc ->> 'form' AS form,
  to_timestamp((nullif(doc ->> 'reported_date'::text, ''::text)::bigint / 1000)::double precision) AS reported,
  doc #>> '{contact,_id}'::text[] AS reported_by,
  doc #>> '{contact,parent,_id}'::text[] AS reported_by_parent,
  doc #>> '{fields,inputs,source}'::text[] AS source,
  doc #>> '{fields,inputs,source_id}'::text[] AS source_id,
  doc #>> '{fields,inputs,contact,_id}'::text[] AS patient_id,
  doc #>> '{fields,inputs,contact,name}'::text[] AS patient_name,
  doc #>> '{fields,inputs,contact,sex}'::text[] AS sex,
  doc #>> '{fields,patient_date_of_birth}'::text[] AS date_of_birth,
  doc #>> '{fields,patient_age_in_years}'::text[] AS age_in_years,
  doc #>> '{fields,fp_follow_up,not_on_fp_reason}'::text[] AS not_on_fp_reason,
  doc #>> '{fields,fp_follow_up,not_on_fp_reason_other}'::text[] AS not_on_fp_reason_other,
  doc #>> '{fields,fp_follow_up,referred_patient_not_on_fp}'::text[] AS referred_patient_not_on_fp,
  doc #>> '{fields,fp_follow_up,continue_current_fp_method}'::text[] AS continue_current_fp_method,
  doc #>> '{fields,fp_follow_up,can_supply_fp_commodities}'::text[] AS can_supply_fp_commodities,
  doc #>> '{fields,fp_follow_up,supply_item_units}'::text[] AS supply_item_units,
  doc #>> '{fields,fp_follow_up,supply_limit}'::text[] AS supply_limit,
  doc #>> '{fields,fp_follow_up,commodities_supplied_qty}'::text[] AS commodities_supplied_qty,
  doc #>> '{fields,fp_follow_up,referred_patient_change_fp}'::text[] AS referred_patient_change_fp,
  doc #>> '{fields,fp_follow_up,next_appt_date}' AS next_appt_date,
  doc #>> '{fields,fp_ref_follow_up,visited_facility}'::text[] AS visited_facility,
  doc #>> '{fields,fp_ref_follow_up,enrolled_fp}'::text[] AS enrolled_fp,
  doc #>> '{fields,fp_ref_follow_up,reason_not_enrolled_fp}'::text[] AS reason_not_enrolled_fp,
  CURRENT_TIMESTAMP AS last_refresh_date
FROM
  dwh.cht_data
WHERE
  doc ->> 'form' IN ('fp_follow_up', 'fp_referral_follow_up')
  WITH DATA;