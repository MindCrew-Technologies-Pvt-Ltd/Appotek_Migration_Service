ALTER TABLE user_notifications
	DROP CONSTRAINT fk_user_notifications_created_by_to_user,
	DROP CONSTRAINT fk_user_notifications_clinic_id_to_clinic,
	DROP COLUMN clinic_id,
	DROP COLUMN created_by,
	DROP COLUMN is_accepted,
	DROP COLUMN decide_date;

