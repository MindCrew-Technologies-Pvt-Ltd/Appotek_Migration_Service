CREATE OR REPLACE FUNCTION public.get_user_active_medicines(_user_id uuid)
  RETURNS TABLE
        (
        	medicine_id bigint
		)
		as $func$
begin
	return query
		select distinct pm.medicine_id
			from treatment_records tr  
			left join treatment_prescriptions tp on (tp.treatment_id  = tr.id)
			left join prescription_medicine pm on (pm.prescription_id = tp.id)
			left join 
				(select pp.prescription_id, max(pp."date") "date" from prescription_procedures pp group by pp.prescription_id) spp on (spp.prescription_id = tp.id)
			where tr.patient_id = $1 
				and tr.deleted_at is null
				and pm.medicine_id is not null
				and spp."date" > date_trunc('day', now());
END;
$func$
  LANGUAGE plpgsql;