ALTER TABLE auto_booking_schedules
    DROP column start_time,
    DROP column end_time,
    ADD COLUMN time_from TIMETZ,
    ADD COLUMN time_to TIMETZ;