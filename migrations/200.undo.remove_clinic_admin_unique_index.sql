CREATE UNIQUE INDEX clinic_id_is_admin_unique ON clinic_positions (clinic_id, is_admin) WHERE is_admin IS TRUE;
