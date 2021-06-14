alter table permissions_sharing 
	add column user_to_share_phonebook_id uuid,
	add CONSTRAINT fk_permission_sharing_phonebook FOREIGN KEY ("user_to_share_phonebook_id") REFERENCES users_phone_book(id),
	DROP CONSTRAINT permissions_sharing_check,
	ADD CONSTRAINT permissions_sharing_check CHECK ((user_id <> user_to_share_id) AND (((tag_to_share_id IS not NULL)::integer + (user_to_share_id IS not NULL)::integer + (user_to_share_phonebook_id IS not NULL)::integer) = 1));
DROP INDEX dist_tag_to_share_id_uni_user_to_share_id;
DROP INDEX dist_user_to_share_id_uni_tag_to_share_id;
CREATE UNIQUE INDEX dist_tag_to_share_id_uni_user_to_share_id ON permissions_sharing (user_id, tag_to_share_id) WHERE user_to_share_id IS null and user_to_share_phonebook_id is null;
CREATE UNIQUE INDEX dist_user_to_share_id_uni_tag_to_share_id ON permissions_sharing (user_id, user_to_share_id) WHERE tag_to_share_id IS NULL and user_to_share_phonebook_id is null;
CREATE UNIQUE INDEX dist_user_to_share_phonebook_id_uni ON permissions_sharing (user_id, user_to_share_phonebook_id) WHERE tag_to_share_id IS NULL and user_to_share_id is null;

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
		update guardians set second_user_id = new.id, second_user_phonebook_id = null where second_user_phonebook_id = _user_phone_book_id;
		update permissions_sharing set user_to_share_id = new.id, user_to_share_phonebook_id = null where user_to_share_phonebook_id = _user_phone_book_id;
		delete from users_phone_book upb where upb.id = _user_phone_book_id;
	end if;
	
	INSERT INTO user_settings (user_id) VALUES (NEW.id);
	RETURN NEW;

end;
$func$
LANGUAGE plpgsql;
