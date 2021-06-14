ALTER TABLE waiting_room_participant ADD COLUMN description VARCHAR;

ALTER TABLE waiting_room_schedules DROP COLUMN description;
