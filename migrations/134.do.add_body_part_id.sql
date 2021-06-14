ALTER TABLE waiting_room_participant ADD COLUMN body_part_id INT REFERENCES body_parts(id) ON DELETE SET NULL ON UPDATE CASCADE;
