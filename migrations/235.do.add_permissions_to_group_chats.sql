ALTER TABLE chat_room 
	ADD COLUMN allow_waiting_room_id int,
	ADD COLUMN allow_department_id int,
	ADD COLUMN allow_role_id int,
	ADD COLUMN allow_user_ids uuid[],
	ADD CONSTRAINT chat_room_to_waiting_room_fkey FOREIGN KEY (allow_waiting_room_id) REFERENCES waiting_room(id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE,
	ADD CONSTRAINT chat_room_to_clinic_department_fkey FOREIGN KEY (allow_department_id) REFERENCES clinic_department(id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE,
	ADD CONSTRAINT chat_room_to_roles_fkey FOREIGN KEY (allow_role_id) REFERENCES roles(id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;	
