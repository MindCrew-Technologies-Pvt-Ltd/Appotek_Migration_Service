ALTER TABLE waiting_room
	DROP CONSTRAINT waiting_room_to_telephone_fkey,
	DROP COLUMN telephone_id,
	DROP COLUMN email;