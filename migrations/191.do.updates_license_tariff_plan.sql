DROP TRIGGER check_license_types ON license_custom_property_values;
DROP TRIGGER check_license_types ON license_property_values;
DROP FUNCTION check_license_types();
ALTER TABLE license_tarif_plans
	ALTER COLUMN license_type TYPE varchar;
UPDATE license_tarif_plans SET license_type = 'doctor' WHERE license_type = 'personal';
ALTER TABLE license_properties
	DROP COLUMN license_type;
DROP TYPE enum_license_type;
CREATE TYPE enum_license_type AS ENUM ('clinic', 'doctor', 'patient');
ALTER TABLE license_tarif_plans
	ALTER COLUMN license_type TYPE enum_license_type using(license_type::enum_license_type),
	ADD COLUMN actual_price_year numeric(12,2) NULL,
	ADD COLUMN active bool NOT NULL DEFAULT TRUE,
	ADD COLUMN contact_us bool NOT NULL DEFAULT FALSE,
	ADD COLUMN contact_email varchar NULL,
	ADD COLUMN valid_date timestamptz NOT NULL DEFAULT now(),
	ADD COLUMN end_date timestamptz NULL;
UPDATE license_tarif_plans SET contact_us = TRUE WHERE actual_price IS NULL;
ALTER TABLE license_tarif_plan_price_history 
	ADD COLUMN price_year numeric(12,2) NULL;
ALTER TABLE license_tarif_plan_to_user
	ADD COLUMN actual_price_year numeric(12,2) NULL;
ALTER TABLE license_custom_price_history
	ADD COLUMN price_year numeric(12,2) NULL;
CREATE OR REPLACE FUNCTION license_set_actual_price() RETURNS trigger AS $func$
    BEGIN
		IF (TG_OP = 'INSERT' OR NEW.actual_price IS DISTINCT FROM OLD.actual_price OR NEW.actual_price_year IS DISTINCT FROM OLD.actual_price_year)
		THEN
			IF (TG_TABLE_NAME = 'license_tarif_plan_to_user')
			THEN
				INSERT INTO license_custom_price_history (license_tarif_plan_to_user_id, price, price_year) VALUES (NEW.id, NEW.actual_price, NEW.actual_price_year);
			END IF;

			IF (TG_TABLE_NAME = 'license_tarif_plans')
			THEN
				INSERT INTO license_tarif_plan_price_history (tarif_plan_id, price, price_year) VALUES (NEW.id, NEW.actual_price, NEW.actual_price_year);
			END IF;
		END IF;
	
		return new;
    END;
$func$ LANGUAGE plpgsql;
