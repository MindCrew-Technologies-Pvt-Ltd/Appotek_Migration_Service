CREATE OR REPLACE FUNCTION public.sharing_prescription_procedure_check_permissions(recipient_id uuid, prescription_procedures_ids int[])
  RETURNS TABLE
        (
			initiator_id uuid,
			initiator_firstName text,
			initiator_lastName text,
			initiator_photo text,
			applicant_id uuid,
			prescription_procedures_checked_ids int[]
		) as $$
  DECLARE
	applicant_id uuid;
begin
	IF (array_length(prescription_procedures_ids, 1) is null)
    THEN RAISE EXCEPTION 'Array with ids is empty';
	END IF;

	select tr.patient_id into applicant_id 
		from treatment_records tr
		inner join treatment_prescriptions tp on (tp.treatment_id = tr.id)
		inner join prescription_procedures pp on (pp.prescription_id = tp.id)
		where pp.id = prescription_procedures_ids[1]
		limit 1;
   
	IF (applicant_id is null)
	THEN RAISE EXCEPTION 'Treatment or prescription not found';
	END IF;

    IF (not exists (select true from get_user_permissions(recipient_id, applicant_id) where remind_tasks))
   	THEN RAISE EXCEPTION 'You are not given access to this section';
    END IF;
   
    RETURN QUERY
    select u.id, u."firstName", u."lastName", u.photo, applicant_id, ARRAY(
		select pp.id 
			from prescription_procedures pp
			inner join treatment_prescriptions tp on (tp.id = pp.prescription_id)
			inner join treatment_records tr on (tr.id = tp.treatment_id and tr.patient_id = applicant_id )
			where pp.id = any(prescription_procedures_ids) and now() > date_trunc('day', pp."date") + '00:00:00' and pp.completed = false
			ORDER BY pp."date"
    ) as prescription_procedures_checked_ids
    from users u
    where u.id = recipient_id;
END;
$$
  LANGUAGE plpgsql;