ALTER TABLE clinic_positions
  DROP COLUMN verified;

CREATE OR REPLACE FUNCTION before_clinic_position_created()
    RETURNS TRIGGER
  AS
  $BODY$
  BEGIN
    IF (
      SELECT (
               SELECT count(*) = 0
               FROM clinic_positions cp
               WHERE cp.user_id = new.user_id
             )
    )
    THEN
      NEW.is_active = TRUE;
    ELSE
    END IF;

    IF (
      SELECT (
               SELECT count(*) = 0
               FROM clinic_positions cp2
               WHERE cp2.clinic_id = NEW.clinic_id
             )
    )
    THEN
      NEW.is_admin = TRUE;
    ELSE
    end if;

    RETURN NEW;
  end;
  $BODY$
    LANGUAGE plpgsql;

ALTER TABLE doctor_ids
  ALTER COLUMN "doctorId" SET not null;

ALTER TABLE doctor_ids
  DROP COLUMN attachment_id;
