drop function get_guardians(uuid);

CREATE OR REPLACE FUNCTION public.get_guardians(user_id uuid)
  RETURNS TABLE
        (
        	id int,
			"relative" jsonb,
			relationship varchar,
			approve bool
		)
		as $$
begin
	return query
		select 
			g.id,
			json_build_object(
				'id', u.id,
				'firstName', u."firstName", 
				'lastName', u."lastName",
				'photo', u.photo
			)::jsonb,
			fr."name",
			g.second_user_approve
		from guardians g
		left join family_relations fr on (g.second_for_first_relation = fr.id)
		left join users u on (g.second_user_id = u.id)
		where g.first_user_id = user_id
		union
		select
			g.id,
			json_build_object(
				'id', u.id,
				'firstName', u."firstName", 
				'lastName', u."lastName",
				'photo', u.photo
			)::jsonb,
			fr."name",
			g.first_user_approve
		from guardians g
		left join family_relations fr on (g.first_for_second_relation = fr.id)
		left join users u on (g.first_user_id = u.id)
		where g.second_user_id = user_id;
END;
$$
  LANGUAGE plpgsql;

delete from guardians g where second_user_id is null;

alter table guardians
	alter column second_user_id set not null,
	DROP CONSTRAINT guardians_users_phonebook_fkey,
	drop column second_user_phonebook_id;

drop table users_phone_book;

CREATE OR REPLACE FUNCTION guardians_check_exist()
	RETURNS TRIGGER
AS $$
BEGIN
	IF (select exists(select 1 from guardians where first_user_id = NEW.first_user_id and second_user_id = NEW.second_user_id and id <> NEW.id))
		OR 
		(select exists(select 1 from guardians where first_user_id = NEW.second_user_id and second_user_id = NEW.first_user_id and id <> NEW.id))
	THEN
	   RAISE EXCEPTION 'A family relation between these people already exist';
	END IF;
	RETURN NEW;
END;
$$
LANGUAGE plpgsql;
