ALTER TABLE clinics
	DROP COLUMN fhir_information,
	ADD COLUMN fhir_base_url VARCHAR;

ALTER TABLE users
	DROP COLUMN external_id,
	DROP COLUMN additional_info;

ALTER TABLE health
	DROP COLUMN external_id,
	DROP COLUMN additional_info;

DROP TABLE goals;

DROP TABLE conditions;

ALTER TABLE care_plans 
	DROP COLUMN external_id,
	DROP COLUMN additional_info;

DROP TABLE fhir_medications;

DROP TABLE fhir_procedures;
