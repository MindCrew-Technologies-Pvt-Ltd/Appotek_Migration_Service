CREATE OR REPLACE FUNCTION after_email_created() RETURNS TRIGGER
AS
$func$
declare
	_email text;
	_user_phone_book_id uuid;
BEGIN
	select upb.id into _user_phone_book_id from users_phone_book upb where upb.email = NEW.email;

	if (_user_phone_book_id is not null) then
		update guardians set second_user_id = new."userId", second_user_phonebook_id = null where second_user_phonebook_id = _user_phone_book_id;
		update permissions_sharing set user_to_share_id = new."userId", user_to_share_phonebook_id = null where user_to_share_phonebook_id = _user_phone_book_id;
		delete from users_phone_book upb where upb.id = _user_phone_book_id;
	end if;
	
	INSERT INTO user_settings (user_id) VALUES (NEW."userId");
	RETURN NEW;

end;
$func$
LANGUAGE plpgsql;