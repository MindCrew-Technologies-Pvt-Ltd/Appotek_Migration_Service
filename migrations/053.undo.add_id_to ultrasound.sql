drop function public.user_pregnancy_get_list_ultrasound(int, uuid);

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
