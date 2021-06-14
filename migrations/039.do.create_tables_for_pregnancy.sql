 CREATE TABLE user_pregnancy (
 	id bigserial not null,
	user_id uuid NOT NULL,
	created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
	created_by uuid not null,
	start_at timestamptz NOT null,
	CONSTRAINT user_pregnancy_pkey PRIMARY KEY (id),
	CONSTRAINT user_pregnancy_user_id_fkey FOREIGN KEY (user_id)
      REFERENCES users (id) MATCH FULL
	  ON UPDATE NO ACTION ON DELETE cascade,
	CONSTRAINT user_pregnancy_created_by_fkey FOREIGN KEY (created_by)
      REFERENCES users (id) MATCH FULL
	  ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE user_pregnancy_ultrasound (
 	id serial not null,
	user_pregnancy_id int NOT NULL,
	created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
	created_by uuid not null,
	scan_file uuid not null,
	above_brim varchar(3),
	heart_rate smallint,
	movements smallint,
	conclusion varchar(255),
	CONSTRAINT user_pregnancy_ultrasound_pkey PRIMARY KEY (id),
	CONSTRAINT user_pregnancy_ultrasound_user_pregnancy_id_fkey FOREIGN KEY (user_pregnancy_id)
      REFERENCES user_pregnancy (id) MATCH FULL
	  ON UPDATE NO ACTION ON DELETE cascade,
	CONSTRAINT user_pregnancy_ultrasound_created_by_fkey FOREIGN KEY (created_by)
      REFERENCES users (id) MATCH FULL
	  ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT user_pregnancy_ultrasound_scan_file_fkey FOREIGN KEY (scan_file)
      REFERENCES attachments (id) MATCH FULL
	  ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE OR REPLACE FUNCTION public.user_pregnancy_get_list_ultrasound(pregnancy_user_id int, user_id uuid default null)
  RETURNS TABLE
        (
			created_at timestamptz,
			created_by json,
			scan_file json,
			above_brim varchar(3),
			heart_rate smallint,
			movements smallint,
			conclusion varchar(255)
		)
		as $$
  DECLARE
	owner_id uuid;
begin

	if (user_id is not null)
	then 
		select up.user_id into owner_id 
			from user_pregnancy up
			where up.id = pregnancy_user_id
			limit 1;

		IF (owner_id != user_id)
		THEN RAISE EXCEPTION 'Access denied';
		END IF;
	end if;

	return query
		select 
			upu.created_at,
			json_build_object(
			    'id', u.id, 
			    'firstName', u."firstName", 
			    'lastName', u."lastName", 
			    'photo',  u."photo") as created_by,
			json_build_object(
			    'id', a.id, 
			    'storage_key', a.storage_key, 
			    'type',  a."type",
			    'subtype', a.subtype,
			    'visibility', a.visibility,
			    'source_url', a.source_url) as scan_file,
			upu.above_brim,
			upu.heart_rate,
			upu.movements,
			upu.conclusion
		from user_pregnancy_ultrasound upu
		left join users u on (u.id = upu.created_by)
		left join attachments a on (a.id = upu.scan_file)
		where upu.user_pregnancy_id = pregnancy_user_id;
END;
$$
  LANGUAGE plpgsql;
