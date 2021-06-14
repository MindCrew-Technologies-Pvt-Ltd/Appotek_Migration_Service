CREATE TYPE event_participant_status AS ENUM ('invited', 'approved', 'rejected');

ALTER TABLE event_participant
  ADD COLUMN status event_participant_status DEFAULT 'invited'