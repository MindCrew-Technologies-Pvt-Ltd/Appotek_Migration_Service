 UPDATE auto_booking_schedules SET clinic_consultation_duration = '00:15:00' WHERE clinic_consultation_duration IS NULL;
 UPDATE auto_booking_schedules SET clinic_consultation_price = 00.00 WHERE clinic_consultation_price IS NULL;
 UPDATE auto_booking_schedules SET clinic_consultation_payment_mode = 0 WHERE clinic_consultation_payment_mode IS NULL;
 UPDATE auto_booking_schedules SET home_visit_duration = '00:15:00' WHERE home_visit_duration IS NULL;
 UPDATE auto_booking_schedules SET home_visit_price = 00.00 WHERE home_visit_price IS NULL;
 UPDATE auto_booking_schedules SET home_visit_payment_mode = 0 WHERE home_visit_payment_mode IS NULL;
 UPDATE auto_booking_schedules SET online_consultation_duration = '00:15:00' WHERE online_consultation_duration IS NULL;
 UPDATE auto_booking_schedules SET online_consultation_price = 00.00 WHERE online_consultation_price IS NULL;
 UPDATE auto_booking_schedules SET online_consultation_payment_mode = 0 WHERE online_consultation_payment_mode IS NULL;
 ALTER TABLE auto_booking_schedules
    ADD COLUMN user_id uuid NULL DEFAULT NULL,
    ADD CONSTRAINT automatic_booking_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE,
    ALTER COLUMN clinic_consultation_duration SET NOT NULL,
    ALTER COLUMN clinic_consultation_duration SET DEFAULT '00:15:00',
    ALTER COLUMN clinic_consultation_price SET NOT NULL,
    ALTER COLUMN clinic_consultation_price SET DEFAULT 00.00,
    ALTER COLUMN clinic_consultation_payment_mode SET NOT NULL,
    ALTER COLUMN clinic_consultation_payment_mode SET DEFAULT 0,
    ALTER COLUMN home_visit_duration SET NOT NULL, 
    ALTER COLUMN home_visit_duration SET DEFAULT '00:15:00',
    ALTER COLUMN home_visit_price SET NOT NULL, 
    ALTER COLUMN home_visit_price SET DEFAULT 00.00,
    ALTER COLUMN home_visit_payment_mode SET NOT NULL,
    ALTER COLUMN home_visit_payment_mode SET DEFAULT 0,
    ALTER COLUMN online_consultation_duration SET NOT NULL,
    ALTER COLUMN online_consultation_duration SET DEFAULT '00:15:00',
    ALTER COLUMN online_consultation_price SET NOT NULL,
    ALTER COLUMN online_consultation_price SET DEFAULT 00.00,
    ALTER COLUMN online_consultation_payment_mode SET NOT NULL,
    ALTER COLUMN online_consultation_payment_mode SET DEFAULT 0;