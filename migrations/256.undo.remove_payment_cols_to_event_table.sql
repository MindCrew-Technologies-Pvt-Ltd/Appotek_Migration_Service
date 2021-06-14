ALTER TABLE event
    DROP COLUMN payment_method,
    DROP COLUMN slot_price,
    DROP COLUMN payment_intent_id,
    DROP COLUMN is_captured,
    DROP COLUMN refund_id,
    DROP COLUMN is_cancelled,
    DROP COLUMN charge_id;
