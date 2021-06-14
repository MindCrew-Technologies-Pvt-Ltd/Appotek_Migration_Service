CREATE OR REPLACE FUNCTION public.get_treatment_interval(_treatment_id int)
  RETURNS TABLE
        (
			start_at timestamptz,
			end_at timestamptz
		)
		as $$
  DECLARE
	_start_at timestamptz;
	_end_at timestamptz;
BEGIN
	
  SELECT pp."date" INTO _start_at 
  	FROM prescription_procedures pp 
  	LEFT JOIN treatment_prescriptions tp ON tp.id = pp.prescription_id 
 	LEFT JOIN treatment_records tr ON tr.id = tp.treatment_id 
 	WHERE tr.id = _treatment_id
 	ORDER BY pp."date"
 	LIMIT 1;
	
  SELECT pp."date" INTO _end_at 
  	FROM prescription_procedures pp 
  	LEFT JOIN treatment_prescriptions tp ON tp.id = pp.prescription_id 
 	LEFT JOIN treatment_records tr ON tr.id = tp.treatment_id 
 	WHERE tr.id = _treatment_id
 	ORDER BY pp."date" DESC
 	LIMIT 1;

	return query
		SELECT
			_start_at,
			_end_at;
END;
$$
  LANGUAGE plpgsql;
 