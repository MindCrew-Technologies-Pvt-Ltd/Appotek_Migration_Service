CREATE TABLE user_reminder_settings
(
  id                SERIAL PRIMARY KEY,
  user_id           UUID     NOT NULL UNIQUE,
  default_interval  integer, 
  push_mobile		BOOLEAN not null DEFAULT false,
  push_desktop      BOOLEAN not null DEFAULT false,
  send_email		BOOLEAN not null DEFAULT false,
  CONSTRAINT user_reminder_settings_to_user FOREIGN KEY (user_id)
    REFERENCES users (id)
    ON DELETE CASCADE ON UPDATE CASCADE
);