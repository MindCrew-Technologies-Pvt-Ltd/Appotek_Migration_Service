create or replace function check_schedule_overlaps() returns trigger
  language plpgsql
as
$$
BEGIN
  IF (SELECT (
               SELECT count(src) > 0
               FROM medical_specializations_schedule src
               WHERE NEW.id != src.id
                 AND NEW.user_id = src.user_id
                 AND (src.start, src.finish) OVERLAPS (NEW.start, NEW.finish)
             )
  )
  THEN
    RAISE EXCEPTION 'schedule overlaps';
  ELSE

  END IF;

  RETURN NEW;
END;
$$;

