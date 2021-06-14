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
