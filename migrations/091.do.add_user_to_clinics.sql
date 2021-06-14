CREATE TABLE user_to_clinics
(
  user_id   UUID REFERENCES users (id),
  clinic_id UUID REFERENCES clinics (id),
  PRIMARY KEY (user_id, clinic_id)
);

CREATE OR REPLACE FUNCTION after_contacts_updated() RETURNS TRIGGER
AS
$$
BEGIN
  IF (
    NEW.clinic_id IS NOT NULL AND (NEW.state & 130 = 130)
    )
  THEN
    IF (SELECT exists(
                   SELECT
                   FROM users
                          INNER JOIN roles r on r.id = users."roleId" AND r.name = 'patient'
                   where users.id = NEW.user_id
                 )
    )
    THEN
      INSERT INTO user_to_clinics(user_id, clinic_id)
      VALUES (NEW.user_id, NEW.clinic_id)
      ON CONFLICT (
         user_id,
         clinic_id)
         DO NOTHING;
    end if;
  end if;

  RETURN NEW;
END;
$$
  language plpgsql;

CREATE TRIGGER after_contacts_updated_trigger
  AFTER UPDATE
  ON contacts
  FOR EACH ROW
EXECUTE PROCEDURE after_contacts_updated();

UPDATE contacts SET state = state;
