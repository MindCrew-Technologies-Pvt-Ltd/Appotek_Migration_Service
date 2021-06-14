CREATE OR REPLACE FUNCTION public.clinic_type_set_seq(start_interval int)
	returns int
as $func$
	DECLARE
		_current_id int;
begin
	SELECT max(id) into _current_id from "clinic-types" ct WHERE ct.id BETWEEN start_interval and start_interval + 99999;
	if (_current_id is null) then
		_current_id = start_interval;
	end if;
	select setval('clinic-types_id_seq', _current_id) into _current_id;
	return _current_id;
END;
$func$
  LANGUAGE plpgsql;

alter table clinics alter column org_code type varchar(255);