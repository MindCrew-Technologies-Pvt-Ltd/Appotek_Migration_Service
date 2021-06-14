ALTER TABLE waiting_room
    ADD COLUMN consultation_duration interval(0) NULL DEFAULT null,
    ADD COLUMN price numeric(12,2) NULL DEFAULT null,
    ADD COLUMN payment_mode int NOT NULL DEFAULT 0;