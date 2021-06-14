ALTER TABLE clinic_positions
  ADD COLUMN verified BOOLEAN DEFAULT FALSE;

UPDATE clinic_positions
SET verified = CASE
                 WHEN clinic_positions.is_admin THEN TRUE
                 ELSE FALSE
  END;

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
      NEW.verified = TRUE;
    ELSE
    end if;

    RETURN NEW;
  end;
  $BODY$
    LANGUAGE plpgsql;

ALTER TABLE doctor_ids
  ALTER COLUMN "doctorId" DROP not null;

ALTER TABLE doctor_ids
  ADD COLUMN attachment_id UUID REFERENCES attachments (id) ON DELETE SET NULL ON UPDATE CASCADE;
