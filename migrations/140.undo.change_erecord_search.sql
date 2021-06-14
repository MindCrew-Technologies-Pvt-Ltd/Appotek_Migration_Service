DROP FUNCTION public.erecord_search(uuid, varchar);

CREATE OR REPLACE FUNCTION public.global_search(_clinic_id uuid, _search_text varchar)
  RETURNS TABLE
        (
        	"date" timestamptz,
			created_by jsonb,
			info jsonb
		)
		as $$
begin
	return query
		SELECT sel.* FROM
				((SELECT 
					tr.updated_at AS "date",
					jsonb_build_object('id', tr.created_by , 'first_name', u."firstName", 'last_name', u."lastName", 'role', r."name") AS created_by,
					jsonb_build_object(
						'type',
						'Treatment',
						'treatment_id', 
						tr.id,
						'search_result', 
						CASE
							WHEN lower(tr.title) LIKE lower('%'||_search_text||'%') THEN tr.title
							WHEN lower(tr.symptoms) LIKE lower('%'||_search_text||'%') THEN tr.symptoms
					    	ELSE ''
						END
					) AS info
				FROM treatment_records tr
				LEFT JOIN users u ON (tr.created_by = u.id)
				LEFT JOIN roles r ON (u."roleId" = r.id)
				WHERE ((lower(tr.title) LIKE lower('%'||_search_text||'%')) OR (lower(tr.symptoms) LIKE lower('%'||_search_text||'%'))) AND (tr.clinic_id = _clinic_id)
				)
			UNION
				(SELECT 
					tr.updated_at AS "date",
					jsonb_build_object('id', tr.created_by , 'first_name', u."firstName", 'last_name', u."lastName", 'role', r."name") AS created_by,
					jsonb_build_object(
						'type',
						CASE
							WHEN lower(tr.title)='medicine' THEN 'Medicine prescribed'
					    	ELSE 'Treatment prescribed'
						END,
						'treatment_id', 
						tr.id,
						'prescription_id',
						tp.id,
						'search_result', 
						CASE
							WHEN lower(tp.title) LIKE lower('%'||_search_text||'%') THEN tp.title
							WHEN lower("data"->>'description') LIKE lower('%'||_search_text||'%') THEN "data"->>'description'
					    	ELSE ''
						END
					) AS info
				FROM treatment_prescriptions tp 
				INNER JOIN treatment_records tr ON (tp.treatment_id = tr.id)
				LEFT JOIN users u ON (tr.created_by = u.id)
				LEFT JOIN roles r ON (u."roleId" = r.id)
				WHERE ((lower(tp.title) LIKE lower('%'||_search_text||'%')) OR (lower("data"->>'description') LIKE lower('%'||_search_text||'%'))) AND (tr.clinic_id = _clinic_id)
				)
			UNION All
				(SELECT 
					tr.updated_at AS "date",
					jsonb_build_object('id', tr.created_by , 'first_name', u."firstName", 'last_name', u."lastName", 'role', r."name") AS created_by,
					jsonb_build_object(
						'type',
						CASE
							WHEN lower(tr.title)='medicine' THEN 'Medicine prescribed'
					    	ELSE 'Treatment prescribed'
						END,
						'treatment_id', 
						tr.id,
						'prescription_id',
						tp.id,
						'search_result',
						s."name" 
					) AS info
				FROM treatment_prescriptions tp
				INNER JOIN treatment_records tr ON (tp.treatment_id = tr.id)
				LEFT JOIN users u ON (tr.created_by = u.id)
				LEFT JOIN roles r ON (u."roleId" = r.id)
				INNER JOIN prescription_to_event pte ON (pte.prescription_id = tp.id)
				INNER JOIN "event" e ON (e.id = pte.event_id)
				INNER JOIN event_symptoms es ON (es.event_id = e.id)
				INNER JOIN symptoms s ON (s.id = es.symptom_id)
				WHERE lower(s."name") LIKE lower('%'||_search_text||'%') AND tr.clinic_id = _clinic_id
				)
			UNION
				(SELECT
					hrr.start_at AS "date",
					jsonb_build_object('id', hrr.created_by , 'first_name', u."firstName", 'last_name', u."lastName", 'role', r."name") AS created_by,
					jsonb_build_object(
						'type',
						'Consultation Report',
						'health_record_report_id', 
						hrr.id,
						'search_result',
						CASE
							WHEN lower(hrr.title) LIKE lower('%'||_search_text||'%') THEN hrr.title
							WHEN lower(hrr.symptoms) LIKE lower('%'||_search_text||'%') THEN hrr.symptoms
							WHEN lower(hrr.conclusion) LIKE lower('%'||_search_text||'%') THEN hrr.conclusion
							WHEN lower(hrr.description) LIKE lower('%'||_search_text||'%') THEN hrr.description
					    	ELSE ''
						END,
						'clinic',
						jsonb_build_object('id', hrr.clinic_id , 'name', c."name"),
				       'diagnostics_count',
			           (SELECT count(id)
			            FROM diagnostic_records dr
			            WHERE dr.id = ANY (hrrdr.referrals)
			            )
					) AS info
				FROM health_record_report hrr 
				LEFT JOIN users u ON (hrr.created_by = u.id)
				LEFT JOIN roles r ON (u."roleId" = r.id)
				LEFT JOIN clinics c ON (hrr.clinic_id = c.id)
				LEFT JOIN health_record_referrals hrrdr ON hrr.id = hrrdr.health_record_id
				WHERE (lower(hrr.title) LIKE lower('%'||_search_text||'%') OR lower(hrr.symptoms) LIKE lower('%'||_search_text||'%') OR lower(hrr.conclusion) LIKE lower('%'||_search_text||'%') OR lower(hrr.description) LIKE lower('%'||_search_text||'%')) AND hrr.clinic_id = _clinic_id AND hrr.type = 'c'
				))	sel
			ORDER BY sel."date" DESC;
END;
$$
  LANGUAGE plpgsql;
