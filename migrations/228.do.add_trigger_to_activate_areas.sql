CREATE OR REPLACE FUNCTION set_area_statuses() RETURNS trigger AS $func$
	DECLARE
		_area_records record;
		_permissions_records record;
		_area_column_name varchar;
    BEGIN
	    IF (NEW.clinic_id IS NOT NULL) THEN --TODO for user_id
		    IF (NEW.status = 'active' AND OLD.status <> 'active') THEN
		    	IF (NEW.license_tarif_plan_id IS NOT null) THEN
		    		FOR _area_records IN
	                   SELECT al.column_name
	                   FROM area_to_tariff_plan atp
	                   LEFT JOIN areas_list al ON (atp.area_id = al.id)
	                   WHERE atp.license_tarif_plan_id = NEW.license_tarif_plan_id
	           		LOOP
	              		EXECUTE 'UPDATE areas_activated SET ' || _area_records.column_name || ' = true WHERE clinic_id = $$' || NEW.clinic_id || '$$';
	        		END LOOP;
		    	END IF;
		    	IF (NEW.area_id IS NOT NULL) THEN
		    		SELECT column_name INTO _area_column_name FROM areas_list WHERE id = NEW.area_id;
		    		EXECUTE 'UPDATE areas_activated SET ' || _area_column_name || ' = true WHERE clinic_id = $$' || NEW.clinic_id || '$$';
		    	END IF;
		    END IF;
		    IF (NEW.status <> 'active' AND OLD.status = 'active') THEN
		    	DELETE FROM areas_activated WHERE clinic_id = NEW.clinic_id;
		    	INSERT INTO areas_activated (clinic_id) VALUES (NEW.clinic_id);
		    	FOR _permissions_records IN
		    		SELECT license_tarif_plan_id, area_id FROM license_tarif_plan_to_user WHERE clinic_id = NEW.clinic_id AND id <> NEW.id AND status = 'active'
		    	LOOP
			    	IF (_permissions_records.license_tarif_plan_id IS NOT null) THEN
			    		FOR _area_records IN
		                   SELECT al.column_name
		                   FROM area_to_tariff_plan atp
		                   LEFT JOIN areas_list al ON (atp.area_id = al.id)
		                   WHERE atp.license_tarif_plan_id = _permissions_records.license_tarif_plan_id
		           		LOOP
		              		EXECUTE 'UPDATE areas_activated SET ' || _area_records.column_name || ' = true WHERE clinic_id = $$' || NEW.clinic_id || '$$';
		        		END LOOP;
			    	END IF;
			    	IF (_permissions_records.area_id IS NOT NULL) THEN
			    		SELECT column_name INTO _area_column_name FROM areas_list WHERE id = _permissions_records.area_id;
			    		EXECUTE 'UPDATE areas_activated SET ' || _area_column_name || ' = true WHERE clinic_id = $$' || NEW.clinic_id || '$$';
			    	END IF;
		    	END LOOP;		    
		    END IF;
	    END IF;
		RETURN NEW;
    END;
$func$ LANGUAGE plpgsql;

CREATE TRIGGER set_area_statuses AFTER UPDATE ON license_tarif_plan_to_user
    FOR EACH ROW EXECUTE PROCEDURE set_area_statuses();