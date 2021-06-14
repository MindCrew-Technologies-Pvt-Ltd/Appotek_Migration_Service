CREATE OR REPLACE FUNCTION public.user_pregnancy_get_summary_parameters(_user_id uuid, pregnancy_id int default NULL)
  RETURNS TABLE
        (
        	user_pregnancy_id int,
        	start_at timestamptz,
        	end_at timestamptz, 
			blood_pressure_first json,
			blood_pressure_last json,
			weight_first json,
			weight_last json,
			ultrasound_count smallint,
			ultrasound_last json
		)
		as $$
  DECLARE
	checked_pregnancy_id int;
	temp_user_id uuid;
    _start_at timestamptz;
    _end_at timestamptz;
	_bloodPressure_first json;
	_bloodPressure_last json;
	_weight_first json;
	_weight_last json;
	_ultrasound_count smallint;
	_ultrasound_last json;
begin
		
	if (pregnancy_id is null)
	then 
		select up.id, up.start_at, up.end_at into checked_pregnancy_id, _start_at, _end_at 
		from user_pregnancy up
		where up.user_id = _user_id
		order by id desc
		limit 1;
	else
		select up.user_id, up.start_at, up.end_at into temp_user_id, _start_at, _end_at
		from user_pregnancy up
		where up.id = pregnancy_id;

		IF (temp_user_id is null)
		THEN RAISE EXCEPTION 'Pregnancy not found';
		END IF;

		if (temp_user_id = _user_id)
		then checked_pregnancy_id := pregnancy_id;
		else RAISE EXCEPTION 'Access denied';
		end if;
	end if;

	select json_build_object(
		'date', lp."date", 
		'weight', round(lp.weight::numeric, 2)
	) into _weight_first
	from public.user_pregnancy_get_list_parameters(checked_pregnancy_id) lp
	where lp.weight is not null
	order by lp."date"
	limit 1;

	select json_build_object(
		'date', lp."date", 
		'weight', round(lp.weight::numeric, 2)
	) into _weight_last
	from public.user_pregnancy_get_list_parameters(checked_pregnancy_id) lp
	where lp.weight is not null
	order by lp."date" desc
	limit 1;

	select json_build_object(
		'date', lp."date", 
		'systolic', lp.systolic,
		'diastolic', lp.diastolic
	) into _bloodPressure_first
	from public.user_pregnancy_get_list_parameters(checked_pregnancy_id) lp
	where lp.systolic is not null or lp.diastolic is not null
	order by lp."date"
	limit 1;

	select json_build_object(
		'date', lp."date", 
		'systolic', lp.systolic,
		'diastolic', lp.diastolic
	) into _bloodPressure_last
	from public.user_pregnancy_get_list_parameters(checked_pregnancy_id) lp
	where lp.systolic is not null or lp.diastolic is not null
	order by lp."date" desc
	limit 1;

	select count(*) into _ultrasound_count
	from user_pregnancy_ultrasound upu
	where upu.user_pregnancy_id = checked_pregnancy_id;

	select json_build_object(
		'above_brim', upu.above_brim, 
		'heart_rate', upu.heart_rate,
		'movements', upu.movements
	) into _ultrasound_last
	from user_pregnancy_ultrasound upu
	where upu.user_pregnancy_id = checked_pregnancy_id
	order by upu.id
	limit 1;

	return query
		select 
			checked_pregnancy_id,
		    _start_at,
		    _end_at, 
			_bloodPressure_first,
			_bloodPressure_last,
			_weight_first,
			_weight_last,
			_ultrasound_count,
			_ultrasound_last;
END;
$$
  LANGUAGE plpgsql;
