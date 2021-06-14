ALTER TABLE user_settings DROP COLUMN default_interval;
ALTER TABLE user_settings ADD COLUMN default_interval integer not null default 0;