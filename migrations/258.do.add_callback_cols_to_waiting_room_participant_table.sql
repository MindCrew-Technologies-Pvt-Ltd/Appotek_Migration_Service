ALTER TABLE waiting_room_participant
    ADD COLUMN requires_callback boolean NOT NULL DEFAULT false,
    ADD COLUMN requires_callback_at timestamptz NULL DEFAULT null;
    