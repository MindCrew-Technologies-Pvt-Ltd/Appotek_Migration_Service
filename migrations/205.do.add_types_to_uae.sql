INSERT INTO country_id_types (country_id, value, regex_validation_rule, is_ssn, is_visible_value) VALUES 
	(
		get_countryid_by_isocode('AE'::bpchar),
		'هيئة الإمارات للهوية',
		'^784-?[0-9]{4}-?[0-9]{7}-?[0-9]{1}$',
		true,
		true
	);
