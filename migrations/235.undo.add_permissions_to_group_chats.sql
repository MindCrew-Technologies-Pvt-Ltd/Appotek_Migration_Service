ALTER TABLE chat_room 
	DROP CONSTRAINT chat_room_to_waiting_room_fkey,
	DROP CONSTRAINT chat_room_to_clinic_department_fkey,
	DROP CONSTRAINT chat_room_to_roles_fkey,
	DROP COLUMN allow_waiting_room_id,
	DROP COLUMN allow_department_id,
	DROP COLUMN allow_role_id,
	DROP COLUMN allow_user_ids;
	