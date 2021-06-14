CREATE OR REPLACE FUNCTION public.age_check_allow(_user_id uuid)
	returns bool
		as $func$
begin
	return not (select is_underage(_user_id) 
		and (select exists(select 1 from users u  left join roles r on (u."roleId" = r.id) where u.id = _user_id and r."name" = 'patient' ))
		and not (select exists(select 1 from guardians g where (g.first_user_id = _user_id or g.second_user_id = _user_id) and g.first_user_approve = true and g.second_user_approve = true)));
END;
$func$
  LANGUAGE plpgsql;