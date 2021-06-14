alter table user_pregnancy add column updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP;

drop function user_pregnancy_status(uuid);

CREATE OR REPLACE FUNCTION public.user_pregnancy_status(_user_id uuid)
  returns table ( 
  		"status" boolean,
  		user_pregnancy_id integer,
  		"date" timestamptz,
        updated_at timestamptz
  	)
	as $$
  DECLARE
	_user_pregnancy_id integer;
	_status boolean;
	_date timestamptz;
    _updated_at timestamptz;
BEGIN
	select up.start_at, up.id, up.updated_at into _date, _user_pregnancy_id, _updated_at 
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
            _updated_at;
END;
$$
  LANGUAGE plpgsql;
