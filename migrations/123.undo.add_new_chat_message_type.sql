ALTER TABLE chat_message
  DROP COLUMN call_id;

create or replace function validate_create_chat_message() returns trigger
  language plpgsql
as
$$
BEGIN
  CASE WHEN (SELECT exists(SELECT * FROM chat_room WHERE id = NEW.room_id AND chat_room.deleted_at IS NULL))
    THEN
    ELSE RAISE EXCEPTION 'forbidden to post messages in deleted or not existing room';
    END CASE;
  CASE WHEN (
    SELECT (
               (NEW.type = 'text'
                 AND NEW.text IS NOT NULL
                 AND NEW.location IS NULL
                 AND NEW.shared_contact_id IS NULL
                 AND NEW.shared_attachment_id IS NULL)
               OR (
                   NEW.type = 'location_attachment'
                   AND NEW.text IS NULL
                   AND NEW.location IS NOT NULL
                   AND NEW.shared_contact_id IS NULL
                   AND NEW.shared_attachment_id IS NULL
                 )
               OR (
                   NEW.type = 'contact_attachment'
                   AND NEW.text IS NULL
                   AND NEW.location IS NULL
                   AND NEW.shared_contact_id IS NOT NULL
                   AND NEW.shared_attachment_id IS NULL
                 )
               OR (
                   NEW.type = 'file_attachment'
                   AND NEW.text IS NULL
                   AND NEW.location IS NULL
                   AND NEW.shared_contact_id IS NULL
                   AND NEW.shared_attachment_id IS NOT NULL
                 )
             )
  )
    THEN
    ELSE RAISE EXCEPTION 'mixed message payload is not supported, please specify 1';
    END CASE;

  CASE WHEN (SELECT exists(
                        (
                          SELECT *
                          FROM chat_participants
                          WHERE chat_participants.room_id = new.room_id
                            AND chat_participants.user_id = new.created_by
                            AND chat_participants.status = 'approved')
                      )
  )
    THEN
    ELSE RAISE EXCEPTION 'You can''t post messaged while your participation in room is not approved';
    END CASE;
  UPDATE chat_room SET updated_at = date_trunc('milliseconds', CURRENT_TIMESTAMP) WHERE id = NEW.room_id;
  RETURN NEW;
END
$$;
