ALTER TABLE clinics
    ADD COLUMN set_own_schedule bool NOT NULL DEFAULT false,
    ADD COLUMN receive_payments_directly bool NOT NULL DEFAULT false,
    ADD COLUMN set_own_price bool NOT NULL DEFAULT false;
