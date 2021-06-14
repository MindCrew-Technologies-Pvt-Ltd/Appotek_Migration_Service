ALTER TABLE user_notifications 
	ADD COLUMN created_by uuid NULL,
	ADD COLUMN is_accepted boolean NULL,
	ADD COLUMN decide_date timestamptz NULL,
	ADD COLUMN clinic_id uuid NULL,
	ADD CONSTRAINT fk_user_notifications_clinic_id_to_clinic FOREIGN KEY ("clinic_id") REFERENCES clinics(id) MATCH FULL,
	ADD CONSTRAINT fk_user_notifications_created_by_to_user FOREIGN KEY ("created_by") REFERENCES users(id) MATCH FULL;
	