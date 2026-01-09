CREATE MATERIALIZED VIEW report.useview_referral_follow_up
TABLESPACE ts_report
AS
SELECT
      doc ->> '_id'                                                AS uuid,
      doc ->> '_rev'                                               AS rev,
      doc ->> 'form'                                               AS form,
      to_timestamp(NULLIF(doc ->> 'reported_date','')::bigint / 1000.0) AS reported,
      doc ->> 'from'                                               AS submitter,
      doc ->> 'content_type'                                       AS top_content_type,
      to_timestamp(NULLIF(doc #>> '{form_version,time}','')::bigint / 1000.0) AS form_version_time,
      doc #>> '{form_version,sha256}'                              AS form_version_sha256,
      (doc -> 'hidden_fields')::text                               AS hidden_fields_json,
    , doc #>> '{fields,inputs,source}'                                    AS source,
    , doc #>> '{fields,inputs,source_id}'                                 AS source_id,
    , doc #>> '{fields,inputs,follow_up_type}'                            AS follow_up_type,
    , doc #>> '{fields,inputs,t_place_name}'                              AS t_place_name,
    , doc #>> '{fields,inputs,t_vht_name}'                                AS t_vht_name,
    , doc #>> '{fields,inputs,t_vht_phone}'                               AS t_vht_phone,
    , doc #>> '{fields,inputs,contact,_id}'                               AS _id,
    , doc #>> '{fields,inputs,contact,name}'                              AS name,
    , doc #>> '{fields,inputs,contact,date_of_birth}'                     AS date_of_birth,
    , doc #>> '{fields,inputs,contact,sex}'                               AS sex,
    , doc #>> '{fields,inputs,contact,parent,_id}'                        AS parent__id,
    , doc #>> '{fields,inputs,contact,parent,parent,_id}'                 AS parent_parent__id,
    , doc #>> '{fields,inputs,contact,parent,parent,name}'                AS parent_name,
    , doc #>> '{fields,inputs,contact,parent,parent,supervisor}'          AS supervisor,
    , doc #>> '{fields,inputs,contact,parent,parent,phone}'               AS phone,
    , doc #>> '{fields,inputs,contact,parent,parent,contact,_id}'         AS contact__id,
    , doc #>> '{fields,inputs,contact,parent,parent,contact,phone}'       AS contact_phone,
    , doc #>> '{fields,inputs,contact,parent,parent,contact,name}'        AS contact_name,
    , doc #>> '{fields,patient_age_in_years}'                             AS patient_age_in_years,
    , doc #>> '{fields,patient_age_in_months}'                            AS patient_age_in_months,
    , doc #>> '{fields,patient_age_in_days}'                              AS patient_age_in_days,
    , doc #>> '{fields,patient_age_display}'                              AS patient_age_display,
    , doc #>> '{fields,patient_id}'                                       AS patient_id,
    , doc #>> '{fields,patient_name}'                                     AS patient_name,
    , doc #>> '{fields,patient_gender}'                                   AS patient_gender,
    , doc #>> '{fields,referral_follow_up_again}'                         AS referral_follow_up_again,
    , doc #>> '{fields,chw_name}'                                         AS chw_name,
    , doc #>> '{fields,chw_phone}'                                        AS chw_phone,
    , doc #>> '{fields,chw_village}'                                      AS chw_village,
    , doc #>> '{fields,needs_signoff}'                                    AS needs_signoff,
    , doc #>> '{fields,group_follow_up,follow_up_date}'                   AS follow_up_date,
    , doc #>> '{fields,group_follow_up,follow_up_method}'                 AS follow_up_method,
    , doc #>> '{fields,group_person_condition,patient_condition}'         AS patient_condition,
    , doc #>> '{fields,group_referral_information,went_to_health_facility}'  AS went_to_health_facility,
    , doc #>> '{fields,group_referral_information,interact_with_healthcare}'  AS interact_with_healthcare,
    , doc #>> '{fields,group_referral_information,hc_visit_date}'         AS hc_visit_date,
    , doc #>> '{fields,group_referral_information,hc_attendant}'          AS hc_attendant,
    , doc #>> '{fields,group_referral_information,hc_attendant_other}'    AS hc_attendant_other,
    , doc #>> '{fields,group_referral_information,hc_name}'               AS hc_name,
    , doc #>> '{fields,group_referral_information,action_taken}'          AS action_taken,
    , doc #>> '{fields,group_referral_information,instructions_for_vht}'  AS instructions_for_vht
FROM dwh.cht_data AS couchdb
WHERE (doc ->> 'form') = 'referral_follow_up'
  AND is_current
WITH DATA;

CREATE UNIQUE INDEX referral_follow_up_uuid_idx
    ON report.useview_referral_follow_up USING btree (uuid);

CREATE INDEX referral_follow_up_reported_idx
    ON report.useview_referral_follow_up USING btree (reported);
