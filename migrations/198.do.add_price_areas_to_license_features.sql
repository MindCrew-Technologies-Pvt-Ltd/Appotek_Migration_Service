ALTER TABLE areas_activated 
	ADD COLUMN mobile_apps bool NOT NULL DEFAULT FALSE;

CREATE TABLE areas_list (
	id serial NOT NULL PRIMARY KEY,
	title varchar NOT NULL,
	description varchar NULL,
	info_popup varchar NULL,
	actual_price numeric(12,2) NOT NULL DEFAULT 0,
	column_name varchar NOT null
);

CREATE TABLE public.license_area_price_over_plan_history (
	id serial NOT NULL PRIMARY KEY,
	area_id int4 NOT NULL,
	created_at timestamptz NOT NULL DEFAULT now(),
	price numeric(12,2) NULL,
	CONSTRAINT area_price_history_to_properties_fkey FOREIGN KEY (area_id) REFERENCES areas_list(id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE public.license_property_price_over_plan_history (
	id serial NOT NULL PRIMARY KEY,
	property_id int4 NOT NULL,
	created_at timestamptz NOT NULL DEFAULT now(),
	price numeric(12,2) NULL,
	CONSTRAINT property_price_history_to_properties_fkey FOREIGN KEY (property_id) REFERENCES license_properties(id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE
);

ALTER TABLE license_properties 
	ADD COLUMN actual_price numeric(12,2) NULL,
	ADD COLUMN area_id int NULL,
	ADD CONSTRAINT license_properties_to_areas FOREIGN KEY (area_id) REFERENCES areas_list(id) MATCH FULL ON UPDATE CASCADE;

CREATE OR REPLACE FUNCTION license_set_actual_price() RETURNS trigger AS $func$
    BEGIN
		IF (TG_TABLE_NAME = 'license_properties' OR TG_TABLE_NAME = 'areas_list')
		THEN 
		    IF (TG_OP = 'INSERT' OR NEW.actual_price IS DISTINCT FROM OLD.actual_price)
		    THEN
				IF (TG_TABLE_NAME = 'license_properties')
				THEN
					INSERT INTO license_property_price_over_plan_history (property_id, price) VALUES (NEW.id, NEW.actual_price);
				END IF;

				IF (TG_TABLE_NAME = 'areas_list')
				THEN
					INSERT INTO license_area_price_over_plan_history (area_id, price) VALUES (NEW.id, NEW.actual_price);
				END IF;
			END IF;
		 ELSE
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
		 END IF;
	
		return new;
    END;
$func$ LANGUAGE plpgsql;

CREATE TRIGGER license_set_actual_price AFTER INSERT OR UPDATE ON license_properties
    FOR EACH ROW EXECUTE PROCEDURE license_set_actual_price();
CREATE TRIGGER license_set_actual_price AFTER INSERT OR UPDATE ON areas_list
    FOR EACH ROW EXECUTE PROCEDURE license_set_actual_price();

CREATE TABLE area_to_tariff_plan (
	id serial PRIMARY KEY,
	license_tarif_plan_id int NOT NULL,
	area_id int NOT NULL,
	CONSTRAINT area_tariff_plan_ids_uniq UNIQUE (license_tarif_plan_id, area_id),
	CONSTRAINT license_propertiy_value_to_tarif_plans FOREIGN KEY (license_tarif_plan_id) REFERENCES license_tarif_plans(id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE,	
	CONSTRAINT license_propertiy_value_to_area FOREIGN KEY (area_id) REFERENCES areas_list(id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE
);

ALTER TABLE areas_activated ADD CONSTRAINT areas_activated_pkey PRIMARY KEY (clinic_id);
