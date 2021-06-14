
ALTER TABLE user_settings
  RENAME COLUMN push_mobile TO notify_calendar_event;
ALTER TABLE user_settings
  RENAME COLUMN email_calendar_event TO email_summary_event;
ALTER TABLE user_settings
  ADD COLUMN email_summary_newsletter BOOLEAN DEFAULT FALSE;
ALTER TABLE user_settings
  ADD COLUMN email_summary_requests BOOLEAN DEFAULT FALSE;
ALTER TABLE user_settings
  ADD COLUMN email_summary_feedback BOOLEAN DEFAULT FALSE;
ALTER TABLE user_settings
  ADD COLUMN notify_patient_request BOOLEAN DEFAULT TRUE;
ALTER TABLE user_settings
  ADD COLUMN notify_patient_feedback BOOLEAN DEFAULT TRUE;
ALTER TABLE user_settings
  ALTER COLUMN notify_calendar_event SET DEFAULT TRUE;

CREATE OR REPLACE FUNCTION after_user_created() RETURNS TRIGGER
AS
$$
BEGIN
  INSERT INTO user_settings (user_id) VALUES (NEW.id);
  RETURN NEW;
end;
$$
LANGUAGE plpgsql;

CREATE TRIGGER after_user_created_trigger
  AFTER INSERT
  ON users
  FOR EACH ROW
EXECUTE PROCEDURE after_user_created();
