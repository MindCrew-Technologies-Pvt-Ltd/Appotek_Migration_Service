ALTER TABLE chat_room
	DROP CONSTRAINT chat_room_to_clinic_fkey,
	DROP COLUMN tag,
	DROP COLUMN clinic_id;
