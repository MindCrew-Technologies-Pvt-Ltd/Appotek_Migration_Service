
ALTER TABLE user_settings
  RENAME COLUMN notify_calendar_event TO push_mobile;
ALTER TABLE user_settings
  RENAME COLUMN email_summary_event TO email_calendar_event;
ALTER TABLE user_settings
  DROP COLUMN email_summary_newsletter;
ALTER TABLE user_settings
  DROP COLUMN email_summary_requests;
ALTER TABLE user_settings
  DROP COLUMN email_summary_feedback;
ALTER TABLE user_settings
  DROP COLUMN notify_patient_request;
ALTER TABLE user_settings
  DROP COLUMN notify_patient_feedback;
ALTER TABLE user_settings
  ALTER COLUMN notify_calendar_event SET DEFAULT FALSE

DROP TRIGGER after_user_created_trigger ON users;

DROP FUNCTION after_user_created;
