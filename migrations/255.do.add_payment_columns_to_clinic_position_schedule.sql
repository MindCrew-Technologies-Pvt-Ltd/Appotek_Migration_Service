ALTER TABLE clinic_position_schedule
    ADD COLUMN consultation_payment_mode int NOT NULL DEFAULT 0,
    ADD COLUMN consultation_price numeric(12,2) NOT NULL DEFAULT 0,
    ADD COLUMN home_visit_payment_mode int NOT NULL DEFAULT 0,
    ADD COLUMN home_visit_price numeric(12,2) NOT NULL DEFAULT 0,
    ADD COLUMN online_payment_mode int NOT NULL DEFAULT 0,
    ADD COLUMN online_price numeric(12,2) NOT NULL DEFAULT 0;