CREATE OR REPLACE FUNCTION check_if_message_author_blacklisted_via_interlocutor() RETURNS TRIGGER AS
$BODY$
BEGIN
  CASE WHEN (
    SELECT EXISTS(
               SELECT true
               FROM chat_room
               WHERE chat_room.id = NEW.room_id
                 AND chat_room.type = 'dialog'
             )
  )
    THEN
      CASE
        WHEN (
          SELECT EXISTS(
                     SELECT *
                     FROM contacts
                     WHERE contacts.user_id = NEW.created_by
                       AND state & 1024 = 1024
                       AND contacts.contact_id = (
                       SELECT cp.user_id
                       FROM chat_participants cp
                       WHERE cp.room_id = NEW.room_id
                         AND cp.user_id != NEW.created_by
                       LIMIT 1
                     )
                   )
        )
          THEN RAISE EXCEPTION 'you are blacklisted';
        ELSE
        END CASE;
    ELSE
    END CASE;
  RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql;

CREATE TRIGGER check_if_message_author_blacklisted_via_interlocutor_before_insert
  BEFORE INSERT
  ON chat_message
  FOR EACH ROW
EXECUTE PROCEDURE check_if_message_author_blacklisted_via_interlocutor();