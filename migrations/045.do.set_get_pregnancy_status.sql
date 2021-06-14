CREATE OR REPLACE FUNCTION public.user_pregnancy_status(_user_id uuid)
  returns table ( 
  		"status" boolean,
  		user_pregnancy_id integer,
  		"date" timestamptz
  	)
	as $$
  DECLARE
	_user_pregnancy_id integer;
	_status boolean;
	_date timestamptz;
BEGIN
	select up.start_at, up.id into _date, _user_pregnancy_id 
	from user_pregnancy up
	where up.user_id = _user_id and end_at is null
	order by id desc
	limit 1;

	_status := _user_pregnancy_id is not null;
	
	return query
		select 
			_status,
			_user_pregnancy_id,
		    _date;
END;
$$
  LANGUAGE plpgsql;
 
CREATE OR REPLACE FUNCTION public.user_pregnancy_start(_user_id uuid, _created_by uuid, _start_at timestamptz)
  returns integer
	as $$
  DECLARE
	_status boolean;
	_gender varchar;
	_user_pregnancy_id integer;
BEGIN
	select s.status into _status
	from user_pregnancy_status(_user_id) s;
	
	if (_status)
	then RAISE EXCEPTION 'User status is "Pregnant"';
	end if;

	select u.gender into _gender
	from users u
	where u.id = _user_id;

	if (_gender = 'male')
	then RAISE EXCEPTION 'User gender is "Male"';
	end if;

	insert into user_pregnancy(created_by, user_id, start_at)
	values(_created_by, _user_id, _start_at)
	returning id
	into _user_pregnancy_id;

	return _user_pregnancy_id;
END;
$$
  LANGUAGE plpgsql;
 
CREATE OR REPLACE FUNCTION public.user_pregnancy_stop(_user_id uuid, _end_at timestamptz, _conclusion varchar)
  returns integer
	as $$
  DECLARE
	_status boolean;
	_user_pregnancy_id integer;
BEGIN
	select s.status into _status
	from user_pregnancy_status(_user_id) s;
	
	if (_status = false)
	then RAISE EXCEPTION 'User status is not "Pregnant"';
	end if;

	update user_pregnancy set
	end_at = _end_at,
	conclusion = _conclusion
	where user_id = _user_id and end_at is null
	returning id
	into _user_pregnancy_id;

	return _user_pregnancy_id;
END;
$$
  LANGUAGE plpgsql;
