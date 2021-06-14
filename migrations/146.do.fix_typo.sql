DROP FUNCTION public.erecord_search;
CREATE OR REPLACE FUNCTION public.erecord_search(_clinic_id uuid, _search_text varchar)
  RETURNS TABLE
        (
        	"date" timestamptz,
			created_by jsonb,
			patient jsonb,
			recort_type text,
			info jsonb
		)
		as $$
begin
	return query
		SELECT sel.*
        FROM (
               (SELECT tr.updated_at                         AS "date",
                       jsonb_build_object('id', tr.created_by, 'first_name', ud."firstName", 'last_name', ud."lastName",
                                          'role', r."name")  AS created_by,
                       jsonb_build_object('id', tr.patient_id, 'first_name', up."firstName", 'last_name', up."lastName",
                                          'photo', up.photo) AS patient,
                       (SELECT CASE
                                     WHEN (count(*) = count(*) filter ( where type = 'medicine' )) then 'medicine'
                                     ELSE 'treatment' END
                            from treatment_prescriptions
                            where treatment_prescriptions.treatment_id = tr.id) as recort_type,
                       jsonb_build_object(
                           'treatment_id',
                           tr.id,
                           'symptoms',
                           tr.symptoms,
                           'title',
                           tr.title,
                           'search_result',
                           CASE
                             WHEN lower(tr.title) LIKE lower('%' || _search_text || '%') THEN tr.title
                             WHEN lower(tr.symptoms) LIKE lower('%' || _search_text || '%') THEN tr.symptoms
                             ELSE ''
                             END
                         )                                   AS info
                FROM treatment_records tr
                       LEFT JOIN users ud ON (tr.created_by = ud.id)
                       LEFT JOIN roles r ON (ud."roleId" = r.id)
                       LEFT JOIN users up ON (tr.patient_id = up.id)
                WHERE ((lower(tr.title) LIKE lower('%' || _search_text || '%')) OR
                       (lower(tr.symptoms) LIKE lower('%' || _search_text || '%')))
                  AND (tr.clinic_id = _clinic_id)
               )
               UNION ALL
               (SELECT hrr.start_at                          AS "date",
                       jsonb_build_object('id', hrr.created_by, 'first_name', ud."firstName", 'last_name', ud."lastName",
                                          'role',
                                          r."name")          AS created_by,
                       jsonb_build_object('id', hrr.patient_id, 'first_name', up."firstName", 'last_name', up."lastName",
                                          'photo', up.photo) AS patient,
                       'health_record' as recort_type,
                       jsonb_build_object(
                           'report_type',
                           hrr.type,
                           'health_record_report_id',
                           hrr.id,
                           'search_result',
                           CASE
                             WHEN lower(hrr.title) LIKE lower('%' || _search_text || '%') THEN hrr.title
                             WHEN lower(hrr.symptoms) LIKE lower('%' || _search_text || '%') THEN hrr.symptoms
                             WHEN lower(hrr.conclusion) LIKE lower('%' || _search_text || '%') THEN hrr.conclusion
                             WHEN lower(hrr.description) LIKE lower('%' || _search_text || '%') THEN hrr.description
                             ELSE ''
                             END,
                           'diagnostics_count',
                           (SELECT count(id)
                            FROM diagnostic_records dr
                            WHERE dr.id = ANY (hrrdr.referrals)
                           )
                         )                                   AS info
                FROM health_record_report hrr
                       LEFT JOIN users ud ON (hrr.created_by = ud.id)
                       LEFT JOIN roles r ON (ud."roleId" = r.id)
                       LEFT JOIN users up ON (hrr.patient_id = up.id)
                       LEFT JOIN health_record_referrals hrrdr ON hrr.id = hrrdr.health_record_id
                WHERE (lower(hrr.title) LIKE lower('%' || _search_text || '%') OR
                       lower(hrr.symptoms) LIKE lower('%' || _search_text || '%') OR
                       lower(hrr.conclusion) LIKE lower('%' || _search_text || '%') OR
                       lower(hrr.description) LIKE lower('%' || _search_text || '%'))
                  AND hrr.clinic_id = _clinic_id
               )) sel
        ORDER BY sel."date" DESC;
END;
$$
  LANGUAGE plpgsql;
