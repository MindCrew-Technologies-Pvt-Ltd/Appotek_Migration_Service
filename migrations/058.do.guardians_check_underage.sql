create table country_parameters (
	id int primary key,
	"majority_age" smallint not null default 18,
	CONSTRAINT country_parameters_countries_fkey FOREIGN KEY (id)
      REFERENCES countries (id) MATCH FULL
	  ON UPDATE cascade ON DELETE cascade
);

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

CREATE OR REPLACE FUNCTION public.guardians_insert(_first_user_id uuid, _second_user_id uuid, _first_for_second_relation int, _second_for_first_relation int, _created_by uuid)
	returns bool
		as $func$
	DECLARE
		_first_approve bool;
		_second_approve bool;
begin
	_first_approve = false;
	_second_approve = false;
	if (_first_user_id = _created_by) then
		_first_approve = true;
	else
		select is_underage(_first_user_id) into _first_approve;
	end if;

	select is_underage(_second_user_id) into _second_approve;

    insert into 
    	guardians(first_user_id, second_user_id, first_for_second_relation, second_for_first_relation, first_user_approve, second_user_approve, created_by)
	select
		_first_user_id, _second_user_id, _first_for_second_relation, _second_for_first_relation, _first_approve, _second_approve, _created_by;
 
	return true;
END;
$func$
  LANGUAGE plpgsql;
