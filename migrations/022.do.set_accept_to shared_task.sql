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
  LANGUAGE plpgsql