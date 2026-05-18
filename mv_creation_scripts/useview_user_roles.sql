DROP MATERIALIZED VIEW IF EXISTS mv_user_roles;
CREATE MATERIALIZED VIEW mv_user_roles AS
SELECT
  doc ->>'contact_id' AS chw_id,
  doc ->>'name' AS username,
  jsonb_array_elements_text(doc ->'roles') AS "role"
FROM couchdb
WHERE
  doc ->>'type' = 'user-settings'
  AND doc ->>'contact_id' IS NOT null;

CREATE INDEX idx_mv_user_roles_chw_id ON mv_user_roles (chw_id);