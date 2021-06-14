DROP FUNCTION get_time_slots;
CREATE OR REPLACE FUNCTION get_time_slots(target_user_id UUID,
                                          target_clinic_id UUID,
                                          start_ts TIMESTAMP,
                                          end_ts TIMESTAMP,
                                          shift interval = '15m')
  RETURNS TABLE
          (
            time_slot_from VARCHAR(5),
            time_slot_to   VARCHAR(5),
            start          TIMESTAMPTZ,
            finish         TIMESTAMPTZ,
            available      BOOLEAN
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

    time_slot_from := to_char(start_ts::TIME, 'HH24:MI');
    time_slot_to := to_char((start_ts + shift)::TIME, 'HH24:MI');
    start := start_ts::TIMESTAMPTZ AT TIME ZONE 'UTC' AT TIME ZONE tz;
    finish := start_ts::TIMESTAMPTZ AT TIME ZONE 'UTC' AT TIME ZONE tz + shift;
    available := (SELECT not exists(
        SELECT e.id
        from event e
        WHERE e.owner_id = target_user_id
          AND e.clinic_id = target_clinic_id
          AND (e.start_at, e.end_at) OVERLAPS
              (start_ts::TIMESTAMPTZ AT TIME ZONE 'UTC' AT TIME ZONE tz,
               (start_ts::TIMESTAMPTZ AT TIME ZONE 'UTC' AT TIME ZONE tz + shift))
        LIMIT 1
      )
    );
    start_ts := start_ts + shift;
    RETURN NEXT;
  end loop;
END;
$$
  LANGUAGE plpgsql;
