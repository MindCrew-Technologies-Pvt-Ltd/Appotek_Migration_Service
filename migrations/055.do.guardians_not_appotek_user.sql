create table users_phone_book (
	id uuid primary key,
	"telephoneId" uuid not null unique,
	"firstName" varchar,
	"lastName" varchar,
	CONSTRAINT users_phone_book_telephones_fkey FOREIGN KEY ("telephoneId")
      REFERENCES telephones (id) MATCH FULL
	  ON UPDATE cascade ON DELETE cascade,
 	CONSTRAINT users_check CHECK (not("firstName" is null and "lastName" is null ))
);

alter table guardians
	alter column second_user_id drop not null,
	add column second_user_phonebook_id uuid null,
	ADD CONSTRAINT guardians_users_phonebook_fkey FOREIGN KEY (second_user_phonebook_id) REFERENCES users_phone_book(id) MATCH FULL ON UPDATE CASCADE;

CREATE OR REPLACE FUNCTION guardians_check_exist()
	RETURNS TRIGGER
AS $$
BEGIN
	IF (select exists(select 1 from guardians where first_user_id = NEW.first_user_id and second_user_id = NEW.second_user_id and id <> NEW.id))
		OR 
		(select exists(select 1 from guardians where first_user_id = NEW.second_user_id and second_user_id = NEW.first_user_id and id <> NEW.id))
		OR 
		(select exists(select 1 from guardians where first_user_id = NEW.first_user_id and second_user_phonebook_id = NEW.second_user_phonebook_id and id <> NEW.id))
	THEN
	   RAISE EXCEPTION 'A family relation between these people already exist';
	END IF;
	IF (NEW.second_user_id is not null and NEW.second_user_phonebook_id is not null)
	THEN
	   RAISE EXCEPTION 'Error creating family relation';
	END IF;
	RETURN NEW;
END;
$$
LANGUAGE plpgsql;

drop function get_guardians(uuid);

CREATE OR REPLACE FUNCTION public.get_guardians(user_id uuid)
  RETURNS TABLE
        (
        	id int,
			"relative" jsonb,
			relationship varchar,
			not_approved uuid[]
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
				'photo', u.photo,
				'localUser', true
			)::jsonb,
			fr."name",
			array_remove(ARRAY[g1.first_user_id, g2.second_user_id], null) as not_approved
		from guardians g
		left join family_relations fr on (g.second_for_first_relation = fr.id)
		left join users u on (g.second_user_id = u.id)
		left join guardians g1 on (g1.id = g.id and g1.first_user_approve = false)
		left join guardians g2 on (g2.id = g.id and g2.second_user_approve = false)		
		where g.first_user_id = user_id and g.second_user_id is not null
		union
		select
			g.id,
			json_build_object(
				'id', u.id,
				'firstName', u."firstName", 
				'lastName', u."lastName",
				'photo', u.photo,
				'localUser', true
			)::jsonb,
			fr."name",
			array_remove(ARRAY[g1.first_user_id, g2.second_user_id], null) as not_approved
		from guardians g
		left join family_relations fr on (g.first_for_second_relation = fr.id)
		left join users u on (g.first_user_id = u.id)
		left join guardians g1 on (g1.id = g.id and g1.first_user_approve = false)
		left join guardians g2 on (g2.id = g.id and g2.second_user_approve = false)		
		where g.second_user_id = user_id
		union
		select 
			g.id,
			json_build_object(
				'id', u.id,
				'firstName', u."firstName", 
				'lastName', u."lastName",
				'photo', null,
				'localUser', false
			)::jsonb,
			fr."name",
			array_remove(ARRAY[g1.first_user_id, g2.second_user_phonebook_id], null) as not_approved
		from guardians g
		left join family_relations fr on (g.second_for_first_relation = fr.id)
		left join users_phone_book u on (g.second_user_phonebook_id = u.id)
		left join guardians g1 on (g1.id = g.id and g1.first_user_approve = false)
		left join guardians g2 on (g2.id = g.id and g2.second_user_approve = false)		
		where g.first_user_id = user_id and g.second_user_phonebook_id is not null;
END;
$$
  LANGUAGE plpgsql;
