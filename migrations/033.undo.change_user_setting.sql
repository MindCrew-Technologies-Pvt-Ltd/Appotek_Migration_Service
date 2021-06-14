ALTER TABLE user_settings
	ALTER COLUMN default_interval SET DEFAULT 0,
	DROP COLUMN email_summary_tz_id;

ALTER TABLE user_settings
	RENAME email_summary_tz_offset TO email_summary_tz;
