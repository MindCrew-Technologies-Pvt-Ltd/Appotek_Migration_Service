CREATE TABLE fhir_servers (
	id serial PRIMARY KEY,
	clinic_id uuid NOT NULL,
	base_url varchar NOT NULL,
	username varchar NULL,
	"authorization" varchar NULL,
	"type" varchar NULL,
	"access" varchar NOT NULL,
	status varchar NULL,
	last_sync_start timestamptz null,
	CONSTRAINT fk_fhir_server_clinic_id_to_clinic FOREIGN KEY ("clinic_id") REFERENCES clinics(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE fhir_servers_logs (
	id bigserial PRIMARY KEY,
	fhir_server_id int NOT NULL,
	created_at timestamptz NOT NULL DEFAULT now(),
	operation varchar NOT NULL,
	success boolean NOT NULL,
	description varchar NULL,	
	CONSTRAINT fk_fhir_servers_log_to_fhir_server FOREIGN KEY ("fhir_server_id") REFERENCES fhir_servers(id) ON DELETE CASCADE ON UPDATE CASCADE
);
ALTER TABLE users
	DROP COLUMN external_id;
ALTER TABLE user_to_clinics
	ADD COLUMN fhir_server_id int NULL,
	ADD COLUMN external_id varchar NULL,
	ADD CONSTRAINT fk_user_to_clinic_to_fhir_server FOREIGN KEY ("fhir_server_id") REFERENCES fhir_servers(id) ON DELETE SET NULL;
ALTER TABLE clinics
	DROP COLUMN fhir_information;