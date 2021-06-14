DROP TRIGGER set_delete_for_subscription ON payments;
DROP FUNCTION set_delete_for_subscription();

ALTER TABLE payments
	DROP CONSTRAINT payment_to_license_tarif_plan_to_user_fkey,
	DROP COLUMN payment_relation_id;

DELETE FROM packages;
ALTER TABLE packages
	DROP CONSTRAINT packages_to_tariff_plan_fkey,
	DROP CONSTRAINT packages_to_area_list_fkey,
	DROP CONSTRAINT packages_to_custom_tariff_plan_fkey,
	DROP CONSTRAINT packages_check,
	DROP COLUMN area_id,
	DROP COLUMN custom_plan_id,
	ADD COLUMN stripe_plan_id varchar(255) NOT NULL,
	DROP COLUMN monthly_strype_plan_id,
	DROP COLUMN yearly_strype_plan_id,
	ALTER COLUMN appotek_plan_id SET NOT NULL,
	ALTER COLUMN appotek_plan_id TYPE varchar(255);

DELETE FROM license_tarif_plan_to_user WHERE license_tarif_plan_id IS NULL;
DROP INDEX license_tarif_plan_unique_user_area;
DROP INDEX license_tarif_plan_unique_clinic_area;
DROP INDEX license_tarif_plan_unique_user_plan;
DROP INDEX license_tarif_plan_unique_clinic_plan;
ALTER TABLE license_tarif_plan_to_user
	DROP CONSTRAINT license_tarif_plan_to_areas_fkey,
	DROP CONSTRAINT tariff_plan_area_check,
	ALTER COLUMN license_tarif_plan_id SET NOT NULL,
	DROP COLUMN area_id,
	ADD COLUMN active bool NOT NULL DEFAULT true,
	DROP COLUMN status,
	DROP COLUMN "period",
	DROP COLUMN deleted_at,
	DROP COLUMN current_period_start,
	DROP COLUMN current_period_end;

CREATE OR REPLACE FUNCTION set_license_actice_false() RETURNS trigger AS $func$
    BEGIN
		UPDATE license_tarif_plan_to_user SET active = FALSE WHERE (user_id = NEW.user_id OR clinic_id = NEW.clinic_id) AND id <> NEW.id;
		return new;
    END;
$func$ LANGUAGE plpgsql;

CREATE TRIGGER set_license_actice_false AFTER INSERT ON license_tarif_plan_to_user
    FOR EACH ROW EXECUTE PROCEDURE set_license_actice_false();
