ALTER TABLE auto_booking_schedules 
	ADD clinic_id uuid NULL DEFAULT NULL,
	ADD CONSTRAINT clinic_position_schedule_user_id_fkey FOREIGN KEY (user_id, clinic_id) REFERENCES clinic_positions(user_id, clinic_id) ON UPDATE CASCADE ON DELETE CASCADE;
