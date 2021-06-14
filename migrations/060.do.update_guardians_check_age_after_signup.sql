alter table users alter column gender type varchar;
drop type enum_users_gender;
create type enum_users_gender as enum('male', 'female', 'other');
alter table users alter column gender type enum_users_gender using(gender::enum_users_gender);


CREATE OR REPLACE FUNCTION after_user_created() RETURNS TRIGGER
AS
$func$
declare
	_phone_id uuid;
	_user_phone_book_id uuid;
BEGIN
	select u."telephoneId" into _phone_id from users u where u.id = NEW.id;
	select upb.id into _user_phone_book_id from users_phone_book upb where upb."telephoneId" = _phone_id;

	if (_user_phone_book_id is not null) then
		update guardians g set g.second_user_id = new.id, g.second_user_phonebook_id = null where g.second_user_phonebook_id = _user_phone_book_id;
		delete from users_phone_book upb where upb.id = _user_phone_book_id;
	end if;
	
	INSERT INTO user_settings (user_id) VALUES (NEW.id);
	RETURN NEW;

end;
$func$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.age_check_allow(_user_id uuid)
	returns bool
		as $func$
begin
	return not (select is_underage(_user_id) 
		and (select exists(select 1 from users u  left join roles r on (u."roleId" = r.id) where u.id = _user_id and r."name" = 'patient' ))
		and not (select exists(select 1 from guardians g where (g.first_user_id = _user_id and g.second_user_approve = true) or (g.second_user_id = _user_id and g.first_user_approve = true))));
END;
$func$
  LANGUAGE plpgsql;