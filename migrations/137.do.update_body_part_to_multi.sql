ALTER TABLE waiting_room_participant
  DROP column body_part_id;
ALTER TABLE waiting_room_participant
  ADD COLUMN body_parts INT[];
