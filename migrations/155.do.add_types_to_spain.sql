INSERT INTO country_id_types (country_id, value, regex_validation_rule, is_ssn, is_visible_value) VALUES 
	(get_countryid_by_isocode('ES'::bpchar), 'Numero de Identificación Fiscal', '^[0-9]{8}[TRWAGMYFPDXBNJZSQVHLCKE]$', true, true),
	(get_countryid_by_isocode('ES'::bpchar), 'Numero de Identificación de Extranjeros', '^[XYZ][0-9]{7}[TRWAGMYFPDXBNJZSQVHLCKE]$', false, true),
	(get_countryid_by_isocode('ES'::bpchar), 'Pasaporte', '^[A-Z]{3}[0-9]{6}[A-Z]?$', false, true)
