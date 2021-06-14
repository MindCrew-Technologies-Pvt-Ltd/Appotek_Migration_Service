drop function sharing_tasks_set_accept(UUID, int);
CREATE OR REPLACE FUNCTION sharing_tasks_set_accept(applicant_id UUID, task_id int)
  returns uuid
as $$
DECLARE 
	return_count int;
	recipient_id uuid;
begin
	select count(*) into return_count  
		from sharing_get_allowed_tasks(applicant_id) p
		where p.id = task_id and p.accepted_at is null;
	if return_count > 0 
	then
		update sharing_tasks set accepted_by = applicant_id, accepted_date = current_timestamp, updated_at = current_timestamp where id = task_id returning owner_id into recipient_id;
	else
		RAISE EXCEPTION 'ACCESS DENIED OR TASK IS ALREADY ACCEPTABLE';
	end if;

	return recipient_id;
end;
$$
  LANGUAGE plpgsql;

DROP FUNCTION sharing_get_allowed_tasks(UUID);
CREATE OR REPLACE FUNCTION sharing_get_allowed_tasks(applicant_id UUID)
  RETURNS TABLE
          (
			id integer,
			owner_id uuid,
			created_at timestamptz,
			accepted_at timestamptz,
			description varchar(256)
		) AS
$$
DECLARE
	immediate_ids uuid[];
begin
	immediate_ids := ARRAY(
		SELECT ps.user_id
			FROM permissions_sharing ps
			WHERE ps.user_to_share_id = applicant_id
	);
	
	RETURN QUERY
		select st.id, st.owner_id, st.created_at, st.accepted_date as accepted_at, st.description 
			from sharing_tasks st
			inner join permissions_sharing ps on (st.owner_id = ps.user_id)
			where  ps.user_to_share_id = applicant_id and ps.tasks = true and (st.accepted_by is null or st.accepted_by = applicant_id) and st.deleted_at is null
		union
		select st.id, st.owner_id, st.created_at, st.accepted_date as accepted_at, st.description 
			from sharing_tasks st
			inner join permissions_sharing ps on (st.owner_id = ps.user_id)
			inner join user_tags ut on (ps.tag_to_share_id = ut.tag_id and ps.user_id = ut.user_id)
			where 
				ut.tagged_user_id = applicant_id 
				and ps.tasks = true 
				and (st.accepted_by is null or st.accepted_by = applicant_id)
				and st.deleted_at is null 
				and not (ut.user_id = any (immediate_ids));
END;
$$
  LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sharing_get_users_for_task(task_id integer)
  RETURNS TABLE
          (
			user_id uuid,
			initiator uuid,
			"firstName" text,
			"lastName" text,
			photo text
		) AS
$$
declare 
	own_id uuid; 
	immediate_ids uuid[];

begin
	select st.owner_id into own_id from sharing_tasks st where id = task_id limit 1;
	immediate_ids := ARRAY(
		SELECT ps.user_to_share_id
			FROM permissions_sharing ps
			WHERE ps.user_id = own_id and ps.user_to_share_id is not null
	);
	
	RETURN QUERY
		select ps.user_to_share_id as user_id, u.id as initiator, u."firstName", u."lastName", u.photo
			from sharing_tasks st
			inner join permissions_sharing ps on (st.owner_id = ps.user_id)
			inner join users u on (st.owner_id = u.id)
			where  st.id = task_id and ps.tasks = true and ps.user_to_share_id is not null
		union
		select ut.tagged_user_id as user_id, u.id as initiator, u."firstName", u."lastName", u.photo
			from sharing_tasks st
			inner join permissions_sharing ps on (st.owner_id = ps.user_id)
			inner join user_tags ut on (ps.tag_to_share_id = ut.tag_id and ps.user_id = ut.user_id)
			left join users u on (st.owner_id = u.id)
			where st.id = task_id and ps.tasks = true and not (ut.tagged_user_id = any (immediate_ids)) and ps.tag_to_share_id is not null;
END;
$$
  LANGUAGE plpgsql;