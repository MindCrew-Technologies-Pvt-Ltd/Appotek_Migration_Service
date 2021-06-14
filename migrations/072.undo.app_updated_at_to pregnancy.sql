alter table user_pregnancy drop column updated_at;

drop function user_pregnancy_status(uuid);

CREATE OR REPLACE FUNCTION public.user_pregnancy_status(_user_id uuid)
  returns table ( 
  		"status" boolean,
  		user_pregnancy_id integer,
  		"date" timestamptz,
      created_at timestamptz
  	)
	as $$
  DECLARE
	_user_pregnancy_id integer;
	_status boolean;
	_date timestamptz;
  _created_at timestamptz;
BEGIN
	select up.start_at, up.id, up.created_at into _date, _user_pregnancy_id, _created_at 
	from user_pregnancy up
	where up.user_id = _user_id and end_at is null
	order by id desc
	limit 1;

	_status := _user_pregnancy_id is not null;
	
	return query
		select 
			_status,
			_user_pregnancy_id,
		  _date,
      _created_at;
END;
$$
  LANGUAGE plpgsql;
