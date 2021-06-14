ALTER TABLE auto_booking_schedules 
    DROP CONSTRAINT clinic_position_schedule_user_id_fkey,
    DROP COLUMN clinic_id;