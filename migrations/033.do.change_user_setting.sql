ALTER TABLE user_settings
	ALTER COLUMN default_interval SET DEFAULT 30,
	ADD COLUMN email_summary_tz_id VARCHAR;

ALTER TABLE user_settings
	RENAME email_summary_tz TO email_summary_tz_offset;