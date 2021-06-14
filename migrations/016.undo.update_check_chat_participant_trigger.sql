CREATE OR REPLACE FUNCTION before_chat_participation_update() RETURNS TRIGGER AS
$BODY$
BEGIN
  CASE WHEN (OLD.status != NEW.status)
    THEN
      IF (NEW.status IN ('approved', 'rejected')) THEN
        IF (old.status NOT IN ('invited', 'leaved')) THEN
          RAISE EXCEPTION 'You can approve/reject participation only if you are invited';
        ELSE
        END IF;
      END IF;
      IF (NEW.status = 'invited')
      THEN
        IF (OLD.status = 'approved') THEN
          RAISE EXCEPTION 'participant has already approved invite.';
        END IF;
      END IF;
      ELSE
    END CASE;