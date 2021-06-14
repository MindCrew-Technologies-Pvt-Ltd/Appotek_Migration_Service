DROP FUNCTION get_time_slots;

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
