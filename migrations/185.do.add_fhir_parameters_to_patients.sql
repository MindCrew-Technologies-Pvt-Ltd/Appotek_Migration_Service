ALTER TABLE user_to_clinics 
	ADD COLUMN 	fhir_information json NULL DEFAULT json_build_object();
UPDATE user_to_clinics SET fhir_information = json_build_object();
