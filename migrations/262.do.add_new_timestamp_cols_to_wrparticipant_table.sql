ALTER TABLE waiting_room_participant
    ADD COLUMN forty_five_mins_timestamp timestamptz NULL DEFAULT NULL,
    ADD COLUMN post_five_mins_timestamp timestamptz NULL DEFAULT NULL;