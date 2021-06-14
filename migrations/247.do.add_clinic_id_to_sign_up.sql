ALTER TABLE sign_up_tasks_statuses
	ADD COLUMN clinic_id uuid,
	DROP CONSTRAINT sign_up_tasks_statuses_user_id_fkey,
	ADD CONSTRAINT sign_up_tasks_statuses_user_id_fkey FOREIGN KEY (user_id, clinic_id) REFERENCES clinic_positions (user_id, clinic_id) ON UPDATE CASCADE ON DELETE CASCADE;
