DROP TRIGGER clinic_positions_check_before_insert
    ON clinic_positions;
DROP FUNCTION clinic_positions_check_before_insert();

DROP FUNCTION public.get_license_staff_count(uuid);
 
DROP TRIGGER license_tarif_plan_to_user_check_after_insert
    ON license_tarif_plan_to_user;
DROP FUNCTION license_tarif_plan_to_user_check_after_insert();

DROP TRIGGER license_properties_check_before_delete
    ON license_properties;
DROP FUNCTION license_properties_check_before_delete();

DELETE FROM license_properties WHERE id = 999999;

ALTER TABLE clinic_positions 
	DROP COLUMN in_clinic_license;

ALTER TABLE license_properties
	DROP COLUMN required_type;
