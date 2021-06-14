ALTER TABLE event
    ADD COLUMN payment_method varchar(150) NULL DEFAULT NULL,
    ADD COLUMN slot_price numeric(12,2) NOT NULL DEFAULT 0,
    ADD COLUMN payment_intent_id varchar(150) NULL DEFAULT NULL,
    ADD COLUMN is_captured boolean NOT NULL DEFAULT false,
    ADD COLUMN is_cancelled boolean NOT NULL DEFAULT false,
    ADD COLUMN refund_id varchar(150) NULL DEFAULT NULL,
    ADD COLUMN charge_id varchar(150) NULL DEFAULT NULL;