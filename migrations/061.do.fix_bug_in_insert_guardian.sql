drop function guardians_insert(uuid, uuid, int, int, uuid);

CREATE OR REPLACE FUNCTION public.guardians_insert(_first_user_id uuid, _second_user_id uuid, _first_for_second_relation int, _second_for_first_relation int, _created_by uuid)
	returns int
		as $func$
	DECLARE
		_first_approve bool;
		_second_approve bool;
		_new_id int;
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
		_first_user_id, _second_user_id, _first_for_second_relation, _second_for_first_relation, _first_approve, _second_approve, _created_by
	returning id into _new_id;
 
	return _new_id;
END;
$func$
  LANGUAGE plpgsql;
