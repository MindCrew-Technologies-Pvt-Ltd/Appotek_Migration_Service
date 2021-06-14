create or replace function before_chat_participation_update() returns trigger
  language plpgsql
as
$$
BEGIN
  CASE WHEN (OLD.status != NEW.status)
    THEN
      IF (NEW.status = 'approved') THEN
        IF (old.status != 'invited')
        THEN
          IF (SELECT chat_room.type = 'dialog' FROM chat_room where chat_room.id = NEW.room_id)
          THEN
          ELSE
            RAISE EXCEPTION 'You can approve/reject participation only if you are invited';
          end if;
        ELSE
        END IF;
      END IF;
      IF (NEW.status IN ('invited', 'rejected'))
      THEN
        IF (OLD.status = 'approved') THEN
          RAISE EXCEPTION 'participant has already approved invite.';
        END IF;
      END IF;
    ELSE
    END CASE;

  IF (NEW.updated_at = OLD.updated_at) THEN NEW.updated_at = date_trunc('milliseconds', CURRENT_TIMESTAMP); END IF;

  UPDATE chat_room
  SET updated_at = date_trunc('milliseconds', CURRENT_TIMESTAMP)
  WHERE id = NEW.room_id;

  RETURN NEW;
END;
$$;