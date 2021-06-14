
DELETE
FROM clinic_positions;

CREATE UNIQUE INDEX clinic_id_user_id ON clinic_positions (clinic_id, user_id);

DROP INDEX clinic_id_1_is_admin_1_unique;
DROP INDEX userId_1_active_1_unique;
ALTER TABLE clinic_positions
  ADD COLUMN is_active BOOLEAN DEFAULT FALSE;
ALTER TABLE clinic_positions
  ADD COLUMN is_admin BOOLEAN DEFAULT FALSE;

CREATE UNIQUE INDEX user_id_is_active_unique ON clinic_positions (user_id, is_active) WHERE is_active IS TRUE;
CREATE UNIQUE INDEX clinic_id_is_admin_unique ON clinic_positions (clinic_id, is_admin) WHERE is_admin IS TRUE;

DROP TRIGGER before_insert_set_first_clinic_status_active ON "clinics-to-users";
DROP FUNCTION set_first_clinic_status_active;
DROP TRIGGER after_clinic_position_create_or_update_trigger ON clinic_positions;
DROP FUNCTION after_clinic_position_create_or_update;

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


CREATE TRIGGER before_clinic_position_created_trigger
  BEFORE INSERT
  ON clinic_positions
  FOR EACH ROW
EXECUTE PROCEDURE before_clinic_position_created();

ALTER TABLE clinics
  add COLUMN clinic_tz VARCHAR DEFAULT '0';

UPDATE clinics
SET clinic_tz = 'EET'
FROM countries
where clinics."countryId" = countries.id
  AND countries."iso3Code" = 'UKR';

UPDATE clinics
SET clinic_tz = 'CET'
FROM countries
where clinics."countryId" = countries.id
  AND countries."iso3Code" = 'DNK';

CREATE OR REPLACE FUNCTION get_time_slots(target_user_id UUID,
                                          target_clinic_id UUID,
                                          start_ts TIMESTAMP,
                                          end_ts TIMESTAMP,
                                          shift interval = '15m')
  RETURNS TABLE
          (
            start  TIMESTAMPTZ,
            finish    TIMESTAMPTZ,
            time_slot_from     TIME,
            time_slot_to    TIME,
            available BOOLEAN
          ) AS
$$
DECLARE
  tz VARCHAR;
BEGIN

  SELECT clinic_tz INTO tz
  FROM clinics
  where id = target_clinic_id;

  LOOP
    EXIT WHEN (start_ts + shift) > end_ts;

    time_slot_from := start_ts::TIME;
    time_slot_to := (start_ts + shift)::TIME;
    start := (start_ts::TIMESTAMPTZ AT TIME ZONE tz);
    finish := (start_ts::TIMESTAMPTZ AT TIME ZONE tz) + shift;
    available := (SELECT not exists(
        SELECT e.id
        from event e
        WHERE e.owner_id = target_user_id
          AND e.clinic_id = target_clinic_id
          AND (e.start_at, e.end_at) OVERLAPS
              (start_ts::TIMESTAMPTZ AT TIME ZONE tz,
               (start_ts::TIMESTAMPTZ AT TIME ZONE tz + shift))
        LIMIT 1
      )
    );
    start_ts := start_ts + shift;
    RETURN NEXT;
  end loop;
END;
$$
  LANGUAGE plpgsql;


ALTER TABLE clinic_position_schedule
  ADD COLUMN consultation_slot_from TIMESTAMPTZ;

ALTER TABLE clinic_position_schedule
  ADD COLUMN consultation_slot_to TIMESTAMPTZ;

ALTER TABLE clinic_position_schedule
  ADD COLUMN consultation_slot_interval INTERVAL DEFAULT INTERVAL '15m';

ALTER TABLE clinic_position_schedule
  ADD COLUMN home_visit_slot_from TIMESTAMPTZ;

ALTER TABLE clinic_position_schedule
  ADD COLUMN home_visit_slot_to TIMESTAMPTZ;

ALTER TABLE clinic_position_schedule
  ADD COLUMN home_visit_slot_interval INTERVAL DEFAULT INTERVAL '15m';

ALTER TABLE clinic_position_schedule
  ADD COLUMN online_slot_from TIMESTAMPTZ;

ALTER TABLE clinic_position_schedule
  ADD COLUMN online_slot_to TIMESTAMPTZ;

ALTER TABLE clinic_position_schedule
  ADD COLUMN online_slot_interval INTERVAL DEFAULT INTERVAL '15m';

ALTER TABLE clinic_position_schedule
  ADD CONSTRAINT consultation_time_slot_check CHECK (
      (NOT consultation_slot_from IS NULL = NOT consultation_slot_to IS NULL) AND
      (consultation_slot_from IS NULL OR consultation_slot_from >= start) AND
      (consultation_slot_to IS NULL OR consultation_slot_to <= finish)
    );

ALTER TABLE clinic_position_schedule
  ADD CONSTRAINT home_visit_time_slot_check CHECK (
      (NOT home_visit_slot_from IS NULL = NOT home_visit_slot_to IS NULL)
      AND (home_visit_slot_from IS NULL OR home_visit_slot_from >= start)
      AND (home_visit_slot_to IS NULL OR home_visit_slot_to <= finish)
    );

ALTER TABLE clinic_position_schedule
  ADD CONSTRAINT online_time_slot_check CHECK (
      (NOT online_slot_from IS NULL = NOT online_slot_to IS NULL)
      AND (online_slot_from IS NULL OR online_slot_from >= start)
      AND (online_slot_to IS NULL OR online_slot_to <= finish)
    );
