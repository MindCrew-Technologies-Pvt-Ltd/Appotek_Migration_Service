ALTER TABLE user_settings 
  ADD COLUMN send_email_summary BOOLEAN NOT NULL DEFAULT FALSE,
  ADD COLUMN email_summary_time time,
  ADD COLUMN email_summary_tz INTERVAL,
  ADD COLUMN email_calendar_event BOOLEAN NOT NULL DEFAULT FALSE
