ALTER TABLE event DROP column waiting_room_id;
ALTER TABLE event add column department_id INT REFERENCES clinic_department(id) ON DELETE CASCADE ON UPDATE cascade;
