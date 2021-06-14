ALTER TABLE license_tarif_plan_to_user
	ALTER COLUMN license_tarif_plan_id DROP NOT NULL,
	ADD COLUMN area_id int NULL,
	DROP COLUMN active,
	ADD COLUMN deleted_at timestamptz,
	ADD COLUMN status varchar NOT NULL DEFAULT 'waiting for payment',
	ADD COLUMN "period" varchar NOT NULL DEFAULT 'monthly',
	ADD COLUMN current_period_start timestamptz,
	ADD COLUMN current_period_end timestamptz,
	ADD CONSTRAINT license_tarif_plan_to_areas_fkey FOREIGN KEY (area_id) REFERENCES areas_list(id) MATCH FULL ON UPDATE CASCADE,
	ADD CONSTRAINT tariff_plan_area_check CHECK ((license_tarif_plan_id IS NULL)::integer + (area_id IS NULL)::integer = 1);
CREATE UNIQUE INDEX license_tarif_plan_unique_user_area ON license_tarif_plan_to_user (user_id, area_id) WHERE deleted_at IS NULL;
CREATE UNIQUE INDEX license_tarif_plan_unique_clinic_area ON license_tarif_plan_to_user (clinic_id, area_id) WHERE deleted_at IS NULL;
CREATE UNIQUE INDEX license_tarif_plan_unique_user_plan ON license_tarif_plan_to_user (user_id) WHERE license_tarif_plan_id IS NOT NULL AND deleted_at IS NULL;
CREATE UNIQUE INDEX license_tarif_plan_unique_clinic_plan ON license_tarif_plan_to_user (clinic_id) WHERE license_tarif_plan_id IS NOT NULL AND deleted_at IS NULL;

DELETE FROM packages;
ALTER TABLE packages
	ADD COLUMN area_id int NULL UNIQUE,
	ADD COLUMN custom_plan_id int NULL UNIQUE,
	DROP COLUMN stripe_plan_id,
	ADD COLUMN monthly_strype_plan_id varchar(255) NOT NULL UNIQUE,
	ADD COLUMN yearly_strype_plan_id varchar(255) NOT NULL UNIQUE,
	ALTER COLUMN appotek_plan_id DROP NOT NULL,
	ALTER COLUMN appotek_plan_id TYPE int USING (appotek_plan_id::integer),
	ADD CONSTRAINT packages_to_tariff_plan_fkey FOREIGN KEY (appotek_plan_id) REFERENCES license_tarif_plans(id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE,
	ADD CONSTRAINT packages_to_area_list_fkey FOREIGN KEY (area_id) REFERENCES areas_list(id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE,
	ADD CONSTRAINT packages_to_custom_tariff_plan_fkey FOREIGN KEY (custom_plan_id) REFERENCES license_tarif_plan_to_user(id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE,
	ADD CONSTRAINT packages_check CHECK ((area_id IS not NULL)::integer + (appotek_plan_id IS not NULL)::integer + (custom_plan_id IS not NULL)::integer = 1);

DROP TRIGGER set_license_actice_false ON license_tarif_plan_to_user;
DROP FUNCTION set_license_actice_false();

ALTER TABLE payments
	ADD COLUMN payment_relation_id int NULL UNIQUE,
	ADD CONSTRAINT payment_to_license_tarif_plan_to_user_fkey FOREIGN KEY (payment_relation_id) REFERENCES license_tarif_plan_to_user(id) MATCH FULL ON UPDATE CASCADE;

CREATE OR REPLACE FUNCTION set_delete_for_subscription() RETURNS TRIGGER AS $func$
DECLARE
	BEGIN
		IF (OLD.payment_relation_id IS NOT NULL) THEN
			UPDATE license_tarif_plan_to_user SET deleted_at = now() WHERE id = OLD.payment_relation_id;
		END IF;

	RETURN OLD;
	END;
$func$ LANGUAGE plpgsql;

CREATE TRIGGER set_delete_for_subscription AFTER DELETE ON payments
FOR EACH ROW EXECUTE PROCEDURE set_delete_for_subscription();
