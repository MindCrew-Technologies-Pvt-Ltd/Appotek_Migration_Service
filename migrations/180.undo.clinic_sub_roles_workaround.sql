ALTER TABLE clinic_positions
    ADD CONSTRAINT clinic_positions_clinic_id_sub_role_id_fkey FOREIGN KEY (clinic_id, sub_role_id) REFERENCES clinic_sub_roles (clinic_id, sub_role_id) ON DELETE SET NULL ON UPDATE CASCADE;
