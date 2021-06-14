CREATE OR REPLACE FUNCTION public.user_pregnancy_get_list_parameters(pregnancy_user_id int, user_id uuid default null)
  RETURNS TABLE
        (
			"date" timestamptz,
			weight float8,
			systolic float8,
			diastolic float8
		)
		as $$
  DECLARE
	start_at timestamptz;
	end_at timestamptz;
	owner_id uuid;
begin

	select up.user_id, up.start_at, up.end_at into owner_id, start_at, end_at
	from user_pregnancy up
	where up.id = pregnancy_user_id;

	IF (owner_id is null)
	THEN RAISE EXCEPTION 'Pregnancy not found';
	END IF;

	IF (user_id is not null and owner_id != user_id)
	THEN RAISE EXCEPTION 'Access denied';
	END IF;

	IF (end_at is null)
	THEN 
		return query
		select 
			h."date",
			h.weight,
			h.systolic,
			h.diastolic
		from health h
		where h."date" >= start_at and h."userId" = owner_id and deleted = false;	
	END IF;

	return query
		select 
			h."date",
			h.weight,
			h.systolic,
			h.diastolic
		from health h
		where h."date" between start_at and end_at and h."userId" = owner_id and deleted = false;
END;
$$
  LANGUAGE plpgsql;
