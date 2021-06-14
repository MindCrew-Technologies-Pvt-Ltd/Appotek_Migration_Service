CREATE OR REPLACE FUNCTION license_set_actual_price() RETURNS trigger AS $func$
    BEGIN
		IF (TG_OP = 'INSERT' OR NEW.actual_price IS DISTINCT FROM OLD.actual_price)
		THEN
			IF (TG_TABLE_NAME = 'license_tarif_plan_to_user')
			THEN
				INSERT INTO license_custom_price_history (license_tarif_plan_to_user_id, price) VALUES (NEW.id, NEW.actual_price);
			END IF;

			IF (TG_TABLE_NAME = 'license_tarif_plans')
			THEN
				INSERT INTO license_tarif_plan_price_history (tarif_plan_id, price) VALUES (NEW.id, NEW.actual_price);
			END IF;
		END IF;
	
		return new;
    END;
$func$ LANGUAGE plpgsql;
ALTER TABLE license_tarif_plan_price_history 
	DROP COLUMN price_year;
ALTER TABLE license_tarif_plan_to_user
	DROP COLUMN actual_price_year;
ALTER TABLE license_custom_price_history
	DROP COLUMN price_year;   
ALTER TABLE license_tarif_plans
	DROP COLUMN actual_price_year,
	DROP COLUMN active,
	DROP COLUMN contact_us,
	DROP COLUMN contact_email,
	DROP COLUMN valid_date,
	DROP COLUMN end_date,
	ALTER COLUMN license_type TYPE varchar;
UPDATE license_tarif_plans SET license_type = 'personal' WHERE license_type <> 'clinic';
DROP TYPE enum_license_type;
CREATE TYPE enum_license_type AS ENUM ('clinic', 'personal');
ALTER TABLE license_tarif_plans
	ALTER COLUMN license_type TYPE enum_license_type using(license_type::enum_license_type);
ALTER TABLE license_properties
	ADD COLUMN license_type enum_license_type;
CREATE OR REPLACE FUNCTION check_license_types() RETURNS trigger AS $func$
DECLARE 
	_tarif_plan_type enum_license_type;
	_property_type enum_license_type;
BEGIN
	IF (TG_TABLE_NAME = 'license_property_values')
	THEN
		SELECT ltp.license_type INTO _tarif_plan_type FROM license_tarif_plans ltp WHERE ltp.id = NEW.license_tarif_plan_id;
	END IF;

	IF (TG_TABLE_NAME = 'license_custom_property_values')
	THEN
		SELECT ltp.license_type INTO _tarif_plan_type
		FROM license_tarif_plan_to_user ltptu 
		LEFT JOIN license_tarif_plans ltp ON (ltptu.license_tarif_plan_id = ltp.id)
		WHERE ltptu.id = NEW.license_tarif_plan_to_user_id;
	END IF;
	
	SELECT lp.license_type INTO _property_type FROM license_properties lp WHERE lp.id = NEW.license_property_id;

	IF (_tarif_plan_type <> _property_type) THEN 
		RETURN NULL;
	END IF;
	RETURN NEW;
END;
$func$ LANGUAGE plpgsql;
CREATE TRIGGER check_license_types BEFORE INSERT OR UPDATE ON license_custom_property_values
    FOR EACH ROW EXECUTE PROCEDURE check_license_types();
CREATE TRIGGER check_license_types BEFORE INSERT OR UPDATE ON license_property_values
    FOR EACH ROW EXECUTE PROCEDURE check_license_types();
