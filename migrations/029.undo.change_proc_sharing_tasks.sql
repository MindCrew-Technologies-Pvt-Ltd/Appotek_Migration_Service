DROP FUNCTION sharing_tasks_set_accept(UUID, int);
DROP FUNCTION sharing_get_allowed_tasks(UUID);

CREATE OR REPLACE FUNCTION sharing_get_allowed_tasks(applicant_id UUID)
  RETURNS TABLE
          (
			id integer,
			owner_id uuid,
			created_at timestamptz,
			updated_at timestamptz,
			description varchar(256)
		) AS
$$
begin
	RETURN QUERY
		select st.id, st.owner_id, st.created_at, st.updated_at, st.description 
			from sharing_tasks st
			inner join permissions_sharing ps on (st.owner_id = ps.user_id)
			where  ps.user_to_share_id = applicant_id and ps.tasks = true and st.accepted_date is null and st.deleted_at is null
		union
		select st.id, st.owner_id, st.created_at, st.updated_at, st.description 
			from sharing_tasks st
			inner join permissions_sharing ps on (st.owner_id = ps.user_id)
			inner join user_tags ut on (ps.tag_to_share_id = ut.tag_id and ps.user_id = ut.user_id)
			where ut.tagged_user_id = applicant_id and ps.tasks = true and st.accepted_date is null and st.deleted_at is null;
END;
$$
  LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sharing_tasks_set_accept(applicant_id UUID, task_id int)
  returns bool
as $$
DECLARE 
	return_count int;
begin
	select count(*) into return_count  
		from sharing_get_allowed_tasks(applicant_id) p
		where p.id = task_id;
	if return_count > 0 
	then
		update sharing_tasks set accepted_by = applicant_id, accepted_date = current_timestamp where id = task_id;
	else
		RAISE EXCEPTION 'ACCESS DENIED OR TASK IS ALREADY ACCEPTABLE';
	end if;
	return(true);
end;
$$
  LANGUAGE plpgsql;