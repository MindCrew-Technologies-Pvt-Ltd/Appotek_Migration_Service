ALTER TABLE areas_activated DROP CONSTRAINT areas_activated_pkey;

DROP TRIGGER license_set_actual_price ON license_properties;

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

ALTER TABLE areas_activated 
	DROP COLUMN mobile_apps;
ALTER TABLE license_properties 
	DROP COLUMN actual_price,
	DROP COLUMN area_id;
DROP TABLE public.license_property_price_over_plan_history;
DROP TABLE license_area_price_over_plan_history;
DROP TABLE area_to_tariff_plan;
DROP TABLE public.areas_list;
