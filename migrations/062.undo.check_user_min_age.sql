CREATE OR REPLACE FUNCTION public.is_underage(_user_id uuid)
	returns bool
		as $func$
	DECLARE
		_user_country int;
		_user_dob date;
		_majority_age int;
begin
	select u."countryId", u.dob into _user_country, _user_dob from users u where u.id = _user_id;
	if (_user_dob is null)
	then
		return false;
	end if;

	_majority_age = 18;
	IF (select exists(select 1 from country_parameters cp where cp.id = _user_country))
	THEN
		select cp.majority_age into _majority_age from country_parameters cp where cp.id = _user_country;
	END IF;

	if (_user_dob + (_majority_age * interval '1' year) > current_date)
	then
		return true;
	else
		return false;
	end if;
END;
$func$
  LANGUAGE plpgsql;
   
drop function get_country_parameters (int);

DROP TRIGGER check_min_age ON users;
DROP FUNCTION check_min_age();
alter table country_parameters drop column min_age;
