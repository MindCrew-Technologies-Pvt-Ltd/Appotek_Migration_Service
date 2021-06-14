create or replace function before_clinic_position_created() returns trigger
  language plpgsql
as
$$
BEGIN
    IF (
      SELECT (
               SELECT count(*) = 0
               FROM clinic_positions cp
               WHERE cp.user_id = new.user_id AND cp.is_active IS TRUE
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
               WHERE cp2.clinic_id = NEW.clinic_id AND cp2.is_admin IS FALSE
             )
    )
    THEN
      NEW.is_admin = TRUE;
      NEW.verified = TRUE;
    ELSE
    end if;

    RETURN NEW;
  end;
$$;

