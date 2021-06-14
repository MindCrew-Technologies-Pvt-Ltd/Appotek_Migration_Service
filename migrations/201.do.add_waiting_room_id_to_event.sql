ALTER TABLE event DROP column department_id;
ALTER TABLE event add column waiting_room_id INT REFERENCES waiting_room(id) ON DELETE CASCADE ON UPDATE cascade;
