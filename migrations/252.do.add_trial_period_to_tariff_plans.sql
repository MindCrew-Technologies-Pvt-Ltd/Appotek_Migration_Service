CREATE TABLE system_settings (
	tariff_plan_trial_period int NOT NULL
);
INSERT INTO system_settings (tariff_plan_trial_period) VALUES (14);

CREATE TABLE license_trial_periods (
	id serial PRIMARY KEY,
	clinic_id uuid NULL,
	user_id uuid NULL,
	license_tarif_plan_id int NOT NULL,
	created_by uuid NOT NULL,
	created_at timestamptz NOT NULL DEFAULT now(),
	CONSTRAINT license_trial_periods_check CHECK (((((user_id IS NULL))::integer + ((clinic_id IS NULL))::integer) = 1)),
	CONSTRAINT license_trial_periods_clinics_fkey FOREIGN KEY (clinic_id) REFERENCES clinics(id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT license_trial_periods_plans_fkey FOREIGN KEY (license_tarif_plan_id) REFERENCES license_tarif_plans(id) MATCH FULL ON UPDATE CASCADE,
	CONSTRAINT license_trial_periods_users_fkey FOREIGN KEY (user_id) REFERENCES users(id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT license_trial_periods_created_by_fkey FOREIGN KEY (created_by) REFERENCES users(id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE UNIQUE INDEX license_trial_periods_unique_user_tariff ON license_trial_periods (user_id, license_tarif_plan_id);
CREATE UNIQUE INDEX license_trial_periods_unique_clinic_tariff ON license_trial_periods (clinic_id, license_tarif_plan_id);

CREATE OR REPLACE FUNCTION public.set_trial_period(_payment_relation_id integer, _created_by uuid) RETURNS void
	as $$
  DECLARE
  	_trial_period integer;
  	_clinic_id uuid;
  	_user_id uuid;
  	_license_tarif_plan_id integer;
  	_trial_record_id integer;
BEGIN
	SELECT lu.clinic_id, lu.user_id, lu.license_tarif_plan_id INTO _clinic_id, _user_id, _license_tarif_plan_id FROM license_tarif_plan_to_user lu WHERE id = _payment_relation_id;
	
	IF (_license_tarif_plan_id IS NULL) THEN 
		RAISE EXCEPTION 'Tariff plan not found';
	END IF;

	INSERT INTO license_trial_periods(clinic_id, user_id, license_tarif_plan_id, created_by) 
		VALUES (_clinic_id, _user_id, _license_tarif_plan_id, _created_by)
		ON CONFLICT DO NOTHING
		RETURNING id INTO _trial_record_id;

	IF (_trial_record_id IS NULL) THEN 
		RAISE EXCEPTION 'The trial period has already been used';
	END IF;
	
	SELECT st.tariff_plan_trial_period INTO _trial_period FROM system_settings st;

	UPDATE license_tarif_plan_to_user SET status = 'active', current_period_start = now(), current_period_end = now() + (_trial_period || ' DAYS')::interval WHERE id = _payment_relation_id;

END;
$$
  LANGUAGE plpgsql;
