ALTER TABLE license_properties
	ADD COLUMN required_type varchar NULL;

ALTER TABLE clinic_positions 
	ADD COLUMN in_clinic_license bool NOT NULL DEFAULT FALSE;
	
INSERT INTO license_properties
	SELECT 
		999999 AS id,
		id AS property_type_id, 
		'number' AS value_type, 
		'Free team members' AS title,
		NULL AS description ,
		'The number of people who have access to the account and can hold corporate cards. Extend access to your account to additional users (e.g. accountant) and have the option of giving corporate cards to your staff. If your team grows, you can pay a fee per additional team member per month once you exceed the allowance in your plan or upgrade to a higher plan.' AS info_popup,
		NULL AS actual_price,
		NULL AS area_id,
		'staff_count' AS required_type 
	FROM license_properties_type 
	WHERE title = 'Free monthly allowance';

CREATE OR REPLACE FUNCTION license_properties_check_before_delete() RETURNS TRIGGER
AS
$$
BEGIN
    IF (OLD.required_type IS NOT NULL)
    THEN
    	RAISE EXCEPTION 'This property is required. Removal is not possible.';
    END IF;

    RETURN OLD;
end;
$$
    LANGUAGE plpgsql;

CREATE TRIGGER license_properties_check_before_delete
    BEFORE DELETE
    ON license_properties
    FOR EACH ROW
EXECUTE PROCEDURE license_properties_check_before_delete();

CREATE OR REPLACE FUNCTION license_tarif_plan_to_user_check_after_insert() RETURNS TRIGGER
AS
$$
BEGIN
    IF (NEW.clinic_id IS NOT NULL AND NEW.license_tarif_plan_id IS NOT NULL)
    THEN
    	UPDATE clinic_positions SET in_clinic_license = FALSE WHERE clinic_id = NEW.clinic_id;
    END IF;

    RETURN NEW;
end;
$$
    LANGUAGE plpgsql;

CREATE TRIGGER license_tarif_plan_to_user_check_after_insert
    AFTER INSERT
    ON license_tarif_plan_to_user
    FOR EACH ROW
EXECUTE PROCEDURE license_tarif_plan_to_user_check_after_insert();

CREATE OR REPLACE FUNCTION public.get_license_staff_count(_clinic_id uuid)
  RETURNS TABLE
        (
        	clinic_id uuid,
			license_count integer,
			current_count integer
		)
		as $$
  DECLARE
  	_property_id integer;
	_license_count integer;
	_current_count integer;
BEGIN
	SELECT lp.id INTO _property_id FROM license_properties lp WHERE lp.required_type = 'staff_count';
	
	SELECT CASE WHEN lv.value~E'^\\d+$' THEN lv.value::integer ELSE 0 END INTO _license_count
	FROM license_tarif_plan_to_user lu
	INNER JOIN license_property_values lv ON (lv.license_tarif_plan_id = lu.license_tarif_plan_id AND lv.license_property_id = _property_id)
	WHERE lu.clinic_id = _clinic_id AND lu.license_tarif_plan_id IS NOT NULL AND status = 'active' AND deleted_at IS NULL;
	
	IF (_license_count IS NULL) THEN _license_count = 0; END IF;

	SELECT count(1) INTO _current_count
	FROM clinic_positions cp
	INNER JOIN users u ON (cp.user_id = u.id AND u."deletedAt" IS NULL)
	WHERE cp.clinic_id = _clinic_id AND cp.in_clinic_license = TRUE;
	
	return query
		SELECT
			_clinic_id,
			_license_count,
			_current_count;
END;
$$
  LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION clinic_positions_check_before_insert() RETURNS TRIGGER
AS
$$
  DECLARE
	_license_count integer;
	_current_count integer;
BEGIN
    IF (OLD.in_clinic_license = FALSE AND NEW.in_clinic_license = TRUE)
    THEN
    	SELECT license_count, current_count INTO _license_count, _current_count FROM get_license_staff_count(NEW.clinic_id);
    	IF (_current_count >= _license_count)
	    THEN
	    	RAISE EXCEPTION 'The team limit has been reached.';
	    END IF;
    END IF;

    RETURN NEW;
end;
$$
    LANGUAGE plpgsql;

CREATE TRIGGER clinic_positions_check_before_insert
    BEFORE UPDATE
    ON clinic_positions
    FOR EACH ROW
EXECUTE PROCEDURE clinic_positions_check_before_insert();
