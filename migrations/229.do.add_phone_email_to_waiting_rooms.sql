ALTER TABLE waiting_room
	ADD COLUMN telephone_id uuid NULL,
	ADD COLUMN email varchar NULL,
	ADD CONSTRAINT waiting_room_to_telephone_fkey FOREIGN KEY (telephone_id) REFERENCES telephones(id) MATCH FULL ON UPDATE CASCADE;
