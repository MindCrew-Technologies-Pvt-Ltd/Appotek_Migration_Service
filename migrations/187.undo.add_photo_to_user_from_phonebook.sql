CREATE OR REPLACE FUNCTION public.get_guardians(user_id uuid)
  RETURNS TABLE
        (
        	id int,
			"relative" jsonb,
			relationship varchar,
			not_approved uuid[],
			created_at timestamptz
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
			array_remove(ARRAY[g1.first_user_id, g2.second_user_id], null) as not_approved,
			g.created_at
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
			array_remove(ARRAY[g1.first_user_id, g2.second_user_id], null) as not_approved,
			g.created_at
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
			array_remove(ARRAY[g1.first_user_id, g2.second_user_phonebook_id], null) as not_approved,
			g.created_at
		from guardians g
		left join family_relations fr on (g.second_for_first_relation = fr.id)
		left join users_phone_book u on (g.second_user_phonebook_id = u.id)
		left join guardians g1 on (g1.id = g.id and g1.first_user_approve = false)
		left join guardians g2 on (g2.id = g.id and g2.second_user_approve = false)		
		where g.first_user_id = user_id and g.second_user_phonebook_id is not null;
END;
$$
  LANGUAGE plpgsql;

ALTER TABLE users_phone_book
	DROP COLUMN attachment_id;
