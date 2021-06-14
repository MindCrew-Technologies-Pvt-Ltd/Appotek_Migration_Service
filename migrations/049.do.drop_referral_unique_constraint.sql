ALTER TABLE health_record_referrals DROP CONSTRAINT health_record_referrals_health_record_id_key;

ALTER TABLE background_record ALTER COLUMN body TYPE VARCHAR(2048)
