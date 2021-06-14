ALTER TABLE invites
    add column country_id_type INT REFERENCES country_id_types(id) ON DELETE SET NULL ON UPDATE CASCADE ;
ALTER TABLE invites
    add column id_number varchar;
ALTER TABLE invites
    add column sub_role_id INT REFERENCES sub_roles (id) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE invites
    add column department_id INT REFERENCES clinic_department (id) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE invites
    add column waiting_room_id INT REFERENCES waiting_room (id) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE invites
    add column avatar_id UUID REFERENCES attachments (id) ON DELETE SET NULL ON UPDATE CASCADE;
