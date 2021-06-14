ALTER TABLE auto_booking_schedules
    DROP column time_from,
    DROP column time_to,
    ADD COLUMN start_time timestamptz NOT NULL default now(),
    ADD COLUMN end_time timestamptz NOT NULL default now();