ALTER TABLE sign_up_tasks_statuses
	DROP CONSTRAINT sign_up_tasks_statuses_user_id_fkey,
	DROP COLUMN clinic_id,
	ADD CONSTRAINT sign_up_tasks_statuses_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE;

