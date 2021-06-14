ALTER TABLE chat_room
	ADD COLUMN tag varchar,
	ADD COLUMN clinic_id uuid,
	ADD CONSTRAINT chat_room_to_clinic_fkey FOREIGN KEY (clinic_id) REFERENCES clinics(id) ON UPDATE CASCADE ON DELETE CASCADE;
