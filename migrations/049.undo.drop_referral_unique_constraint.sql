ALTER TABLE health_record_referrals ADD CONSTRAINT health_record_referrals_health_record_id_key UNIQUE(health_record_id);

ALTER TABLE background_record ALTER COLUMN body TYPE VARCHAR(2048)
