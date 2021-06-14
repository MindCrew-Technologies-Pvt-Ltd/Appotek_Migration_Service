create table public.family_relations (
	id int PRIMARY KEY,
	"name" varchar not null,
	associations int[]
);

CREATE TABLE public.guardians (
	id serial PRIMARY KEY,
	first_user_id uuid not null,
	second_user_id uuid not null,
	first_for_second_relation int not null,
	second_for_first_relation int not null,
	first_user_approve bool not null default false,
	second_user_approve bool not null default false,
	created_by uuid not null,
	created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
	modify_at timestamptz null,
	CONSTRAINT guardians_first_user_fkey FOREIGN KEY (first_user_id)
      REFERENCES users (id) MATCH FULL
	  ON UPDATE cascade ON DELETE cascade,
	CONSTRAINT guardians_second_user_fkey FOREIGN KEY (second_user_id)
      REFERENCES users (id) MATCH FULL
	  ON UPDATE cascade ON DELETE cascade,
	CONSTRAINT guardians_created_by_fkey FOREIGN KEY (created_by)
      REFERENCES users (id) MATCH FULL
	  ON UPDATE cascade,
	CONSTRAINT guardians_first_for_second_relation_fkey FOREIGN KEY (first_for_second_relation)
      REFERENCES family_relations (id) MATCH FULL
	  ON UPDATE cascade,
	CONSTRAINT guardians_second_for_first_relation_fkey FOREIGN KEY (second_for_first_relation)
      REFERENCES family_relations (id) MATCH FULL
	  ON UPDATE cascade,
	CONSTRAINT users_check CHECK ((first_user_id <> second_user_id))
);


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

CREATE TRIGGER guardians_check_trigger BEFORE INSERT OR UPDATE
	ON guardians
FOR EACH ROW EXECUTE PROCEDURE guardians_check_exist();

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

CREATE OR REPLACE FUNCTION public.set_guardians_approve(_id int, _user_id uuid)
	returns bool
		as $$
begin
	IF (select exists(select 1 from guardians g where 
		g.id = _id and 
		((g.first_user_id = _user_id and g.first_user_approve = false) or 
		(g.second_user_id = _user_id and g.second_user_approve = false))))
	THEN
		update guardians g set first_user_approve = true where g.id = _id and g.first_user_id = _user_id;
		update guardians g set second_user_approve = true where g.id = _id and g.second_user_id = _user_id;
		return true;
	END IF;
	return false;
END;
$$
  LANGUAGE plpgsql;
