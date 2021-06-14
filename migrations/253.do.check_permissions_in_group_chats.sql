CREATE OR REPLACE FUNCTION chat_participants_before_insert() RETURNS TRIGGER
AS
$$
  DECLARE
	_allow_waiting_room_id integer;
	_allow_department_id integer;
	_allow_role_id integer;
	_allow_user_ids _uuid;
	_role_id integer;
	_role_name TEXT;
	_waiting_room_id integer;
	_department_id integer;
BEGIN
	SELECT allow_waiting_room_id, allow_department_id, allow_role_id, allow_user_ids INTO _allow_waiting_room_id, _allow_department_id, _allow_role_id, _allow_user_ids FROM chat_room WHERE id = NEW.room_id;
	
	IF (_allow_waiting_room_id IS NOT NULL OR _allow_department_id IS NOT NULL OR _allow_role_id IS NOT NULL)
	THEN
		SELECT r.id, r."name" INTO _role_id, _role_name 
		FROM users u
		LEFT JOIN roles r ON (u."roleId" = r.id)
		WHERE u.id = NEW.user_id;
	END IF;

	IF (_allow_role_id IS NOT NULL AND _allow_role_id <> _role_id)
	THEN
		RAISE EXCEPTION 'The user does not have access to this room.';		
	END IF;
	
	IF (_allow_waiting_room_id IS NOT NULL)
	THEN
		IF (_role_name = 'patient')
		THEN
			SELECT wrp.room_id INTO _waiting_room_id FROM waiting_room_participant wrp WHERE wrp.user_id = NEW.user_id AND wrp.room_id = _allow_waiting_room_id;
		ELSE
			SELECT dwr.waiting_room_id INTO _waiting_room_id FROM doctor_waiting_room dwr WHERE dwr.user_id = NEW.user_id AND dwr.waiting_room_id = _allow_waiting_room_id;
		END IF;
	
		IF (_waiting_room_id IS NULL)
		THEN
			RAISE EXCEPTION 'The user does not have access to this room.';		
		END IF;
	END IF;

	IF (_allow_department_id IS NOT NULL)
	THEN
		IF (_role_name = 'patient')
		THEN
			RAISE EXCEPTION 'The user does not have access to this room.';		
		ELSE
			SELECT cp.department_id INTO _department_id FROM clinic_positions cp WHERE cp.user_id = NEW.user_id AND cp.department_id = _allow_department_id;
		END IF;

		IF (_department_id IS NULL)
		THEN
			RAISE EXCEPTION 'The user does not have access to this room.';		
		END IF;
	END IF;

	IF (_allow_user_ids IS NOT NULL AND NEW.user_id <> ANY(_allow_user_ids))
	THEN
		RAISE EXCEPTION 'The user does not have access to this room.';		
	END IF;
	
    RETURN NEW;
end;
$$
    LANGUAGE plpgsql;

CREATE TRIGGER chat_participants_before_insert
    BEFORE INSERT
    ON chat_participants
    FOR EACH ROW
EXECUTE PROCEDURE chat_participants_before_insert();
