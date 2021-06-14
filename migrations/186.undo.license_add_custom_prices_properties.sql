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
DROP TABLE license_custom_property_values;	
DROP TRIGGER license_set_actual_price ON license_tarif_plan_to_user;
DROP TABLE license_custom_price_history;
ALTER TABLE license_tarif_plan_to_user 
	DROP COLUMN actual_price;
DROP TABLE license_tarif_plan_price_history;
DROP TRIGGER license_set_actual_price ON license_tarif_plans;
DROP FUNCTION license_set_actual_price();
ALTER TABLE license_tarif_plans 
	RENAME COLUMN actual_price TO price; 