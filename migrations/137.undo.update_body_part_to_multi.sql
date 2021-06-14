ALTER TABLE waiting_room_participant
  ADD column body_part_id INT;
ALTER TABLE waiting_room_participant
  DROP COLUMN body_parts;
