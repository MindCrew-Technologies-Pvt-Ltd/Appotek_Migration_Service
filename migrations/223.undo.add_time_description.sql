ALTER TABLE user_to_clinics 
	DROP CONSTRAINT fk_user_to_clinic_to_fhir_server,
	DROP COLUMN fhir_server_id,
	DROP COLUMN external_id;
DROP TABLE fhir_servers_logs;
DROP TABLE fhir_servers;
ALTER TABLE users
	ADD COLUMN external_id varchar null;
ALTER TABLE clinics
	ADD COLUMN fhir_information JSON DEFAULT json_build_object();
