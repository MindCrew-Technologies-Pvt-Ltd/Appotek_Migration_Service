CREATE TYPE enum_license_type AS ENUM ('personal', 'clinic');

CREATE TABLE license_tarif_plans (
	id serial PRIMARY KEY,
	title varchar NOT NULL,
	license_type enum_license_type NOT NULL,
	most_popular bool NOT NULL DEFAULT FALSE,
	price decimal(12,2)
);

INSERT INTO license_tarif_plans(title, license_type, most_popular, price) VALUES
	('Free', 'clinic', FALSE, 0),
	('Grow', 'clinic', TRUE, 25),
	('Scale', 'clinic', FALSE, 100),
	('Enterprise', 'clinic', FALSE, null),
	('Free', 'personal', FALSE, 0),
	('Professional', 'personal', TRUE, 7);

CREATE OR REPLACE FUNCTION delete_most_popular_licenses() RETURNS trigger AS $func$
    BEGIN
		IF (NEW.most_popular = true)
		THEN
			UPDATE license_tarif_plans SET most_popular = FALSE WHERE "type" = NEW.license_type AND id <> NEW.id;
		END IF;
	
		return new;
	
    END;
$func$ LANGUAGE plpgsql;

CREATE TRIGGER delete_most_popular_licenses AFTER INSERT OR UPDATE ON license_tarif_plans
    FOR EACH ROW EXECUTE PROCEDURE delete_most_popular_licenses();

CREATE TABLE license_properties_type (
	id serial PRIMARY KEY,
	title varchar NOT NULL,
	enabled bool NOT NULL DEFAULT TRUE
);

INSERT INTO license_properties_type(title, enabled) VALUES
	('Free monthly allowance', TRUE),
	('Features included', TRUE),
	('Features coming soon', FALSE);

CREATE TYPE property_value_type AS ENUM ('number', 'string', 'boolean', 'currency');

CREATE TABLE license_properties (
	id serial PRIMARY KEY,
	license_type enum_license_type NOT NULL,
	property_type_id int NOT NULL,
	value_type property_value_type NOT NULL DEFAULT 'string',
	title varchar NOT NULL,
	description varchar,
	info_popup varchar,
	CONSTRAINT license_properties_to_types FOREIGN KEY (property_type_id) REFERENCES license_properties_type(id) MATCH FULL ON UPDATE CASCADE
);

CREATE TABLE license_property_values (
	id serial PRIMARY KEY,
	license_tarif_plan_id int NOT NULL,
	license_property_id int NOT NULL,
	value varchar NOT NULL,
	CONSTRAINT license_ids_uniq UNIQUE (license_tarif_plan_id, license_property_id),
	CONSTRAINT license_propertiy_value_to_tarif_plans FOREIGN KEY (license_tarif_plan_id) REFERENCES license_tarif_plans(id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE,	
	CONSTRAINT license_propertiy_value_to_properties FOREIGN KEY (license_property_id) REFERENCES license_properties(id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE OR REPLACE FUNCTION check_license_types() RETURNS trigger AS $func$
DECLARE 
	_tarif_plan_type enum_license_type;
	_property_type enum_license_type;
BEGIN
	SELECT ltp.license_type INTO _tarif_plan_type FROM license_tarif_plans ltp WHERE ltp.id = NEW.license_tarif_plan_id;
	SELECT lp.license_type INTO _property_type FROM license_properties lp WHERE lp.id = NEW.license_property_id;
	IF (_tarif_plan_type <> _property_type) THEN 
		RETURN NULL;
	END IF;
	RETURN NEW;
END;
$func$ LANGUAGE plpgsql;

CREATE TRIGGER check_license_types BEFORE INSERT OR UPDATE ON license_property_values
    FOR EACH ROW EXECUTE PROCEDURE check_license_types();

CREATE TABLE license_tarif_plan_to_user(
	id serial PRIMARY KEY,
	user_id uuid,
	clinic_id uuid,
	license_tarif_plan_id int NOT NULL,
	created_at timestamptz NOT NULL DEFAULT now(),
	active bool NOT NULL DEFAULT TRUE,
	CONSTRAINT license_tarif_plan_to_user_users_fkey FOREIGN KEY (user_id) REFERENCES users(id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE,	
	CONSTRAINT license_tarif_plan_to_user_clinics_fkey FOREIGN KEY (clinic_id) REFERENCES clinics(id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE,	
	CONSTRAINT license_tarif_plan_to_user_plans_fkey FOREIGN KEY (license_tarif_plan_id) REFERENCES license_tarif_plans(id) MATCH FULL ON UPDATE CASCADE,
	CHECK (
    	(user_id IS NULL)::INTEGER + (clinic_id IS NULL)::INTEGER = 1
	)
);
		
CREATE OR REPLACE FUNCTION set_license_actice_false() RETURNS trigger AS $func$
    BEGIN
		UPDATE license_tarif_plan_to_user SET active = FALSE WHERE (user_id = NEW.user_id OR clinic_id = NEW.clinic_id) AND id <> NEW.id;
		return new;
    END;
$func$ LANGUAGE plpgsql;

CREATE TRIGGER set_license_actice_false AFTER INSERT ON license_tarif_plan_to_user
    FOR EACH ROW EXECUTE PROCEDURE set_license_actice_false();