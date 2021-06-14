ALTER TABLE clinics
	DROP COLUMN fhir_base_url,
	ADD COLUMN fhir_information JSON DEFAULT json_build_object();

ALTER TABLE users 
	ADD COLUMN external_id varchar NULL,
	ADD COLUMN additional_info jsonb NOT NULL DEFAULT json_build_object(),
	ADD CONSTRAINT ext_id_uniq UNIQUE (external_id);
	
ALTER TABLE health 
	ADD COLUMN external_id varchar NULL,
	ADD COLUMN additional_info jsonb NOT NULL DEFAULT json_build_object(),
	ADD CONSTRAINT health_ext_id_uniq UNIQUE (external_id);

CREATE TABLE goals
(
  id                SERIAL PRIMARY KEY,
  user_id           UUID     NOT NULL,
  external_id		varchar	NULL UNIQUE,
  status			varchar NOT NULL,
  "date"			TIMESTAMPTZ NOT NULL,
  description		varchar,
  categories		varchar[],
  recorder			jsonb NOT NULL DEFAULT json_build_object(),
  CONSTRAINT goals_to_user FOREIGN KEY (user_id)
    REFERENCES users (id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE conditions
(
  id                	SERIAL PRIMARY KEY,
  user_id       	    UUID     NOT NULL,
  external_id			varchar	NULL UNIQUE,
  status				varchar NOT NULL,
  "date"				TIMESTAMPTZ NOT NULL,
  description			varchar,
  category				varchar,
  verification_status 	varchar,
  severity				varchar,
  recorder				jsonb NOT NULL DEFAULT json_build_object(),
  CONSTRAINT conditions_to_user FOREIGN KEY (user_id)
    REFERENCES users (id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER TABLE care_plans 
	ADD COLUMN external_id varchar NULL,
	ADD COLUMN additional_info jsonb NOT NULL DEFAULT json_build_object();

CREATE TABLE fhir_medications
(
  id                	SERIAL PRIMARY KEY,
  user_id       	    UUID     NOT NULL,
  external_id			varchar	NULL UNIQUE,
  recorder				jsonb NOT NULL DEFAULT json_build_object(),
  recorded_date			TIMESTAMPTZ NULL,
  medication			jsonb NOT NULL DEFAULT json_build_object(),
  prior_prescription	jsonb NOT NULL DEFAULT json_build_object(),
  status				varchar NOT NULL,
  extention				varchar[],
  effective_period		jsonb NOT NULL DEFAULT json_build_object(),
  dispense_request		jsonb NOT NULL DEFAULT json_build_object(),
  dosage_instruction	jsonb[],
  CONSTRAINT conditions_to_user FOREIGN KEY (user_id)
    REFERENCES users (id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE fhir_procedures
(
  id                	SERIAL PRIMARY KEY,
  user_id       	    UUID     NOT NULL,
  external_id			varchar	NULL UNIQUE,
  status				varchar NOT NULL,
  "key"					varchar NOT NULL,
  reason				varchar,
  performed_period		jsonb NOT NULL DEFAULT json_build_object(),
  not_performed			bool,
  CONSTRAINT conditions_to_user FOREIGN KEY (user_id)
    REFERENCES users (id)
    ON DELETE CASCADE ON UPDATE CASCADE
);
