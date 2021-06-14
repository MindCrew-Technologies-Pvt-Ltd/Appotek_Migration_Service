UPDATE country_id_types SET regex_validation_rule = '^[A-CEGHJ-PR-TW-Z]{1}[A-CEGHJ-NPR-TW-Z]{1}[0-9]{6}[A-DFM]{0,1}$' WHERE regex_validation_rule = '/^[A-CEGHJ-PR-TW-Z]{1}[A-CEGHJ-NPR-TW-Z]{1}[0-9]{6}[A-DFM]{0,1}/';
UPDATE country_id_types SET regex_validation_rule = '^(?!000|666)[0-8][0-9]{2}-(?!00)[0-9]{2}-(?!0000)[0-9]{4}$' WHERE regex_validation_rule = '/^(?!000|666)[0-8][0-9]{2}-(?!00)[0-9]{2}-(?!0000)[0-9]{4}$/';
UPDATE country_id_types SET regex_validation_rule = '[0-9]{6}-[0-9]{4}' WHERE regex_validation_rule = '/[0-9]{6}-[0-9]{4}/';
UPDATE country_id_types SET regex_validation_rule = '756\.?[0-9]{4}\.?[0-9]{4}\.?[0-9]{2}' WHERE regex_validation_rule = '/756\.?[0-9]{4}\.?[0-9]{4}\.?[0-9]{2}/';
UPDATE country_id_types SET regex_validation_rule = '^(19|20)?(\d{6}(-|\s)\d{4}|(?!19|20)\d{10})$' WHERE regex_validation_rule = '/^(19|20)?(\d{6}(-|\s)\d{4}|(?!19|20)\d{10})$/';
