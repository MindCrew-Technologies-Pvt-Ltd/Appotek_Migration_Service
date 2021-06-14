alter table country_parameters add column min_age smallint not null default 13;

CREATE OR REPLACE FUNCTION public.get_country_parameters(_country_id int)
	RETURNS TABLE
        (
        	country_id int,
        	min_age smallint,
        	majority_age smallint
		)
	as $func$
	declare
		_min_age smallint;
		_majority_age smallint;
BEGIN

	_min_age = 13; _majority_age = 18;
	IF (select exists(select 1 from country_parameters cp where cp.id = _country_id))
	THEN
		select cp.min_age, cp.majority_age into _min_age, _majority_age from country_parameters cp where cp.id = _country_id;
	END IF;

	return query
		select 
			_country_id,
		    _min_age,
		   _majority_age;
	
END;
$func$
  LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION check_min_age() RETURNS trigger AS $func$
DECLARE
		_min_age int;
    BEGIN
		if (new.dob is not null)
		then
			select cp.min_age into _min_age from get_country_parameters(new."countryId") cp;
		
			if (new.dob + (_min_age * interval '1' year) > current_date)
			then
				RAISE EXCEPTION 'The age is too small to continue working in the application';
			end if;
		end if;
	
		return new;
	
    END;
$func$ LANGUAGE plpgsql;

CREATE TRIGGER check_min_age BEFORE INSERT OR UPDATE ON users
    FOR EACH ROW EXECUTE PROCEDURE check_min_age();

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

	select cp.majority_age into _majority_age from get_country_parameters(_user_country) cp;

	if (_user_dob + (_majority_age * interval '1' year) > current_date)
	then
		return true;
	else
		return false;
	end if;
END;
$func$
  LANGUAGE plpgsql;
