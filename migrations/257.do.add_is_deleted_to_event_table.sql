ALTER TABLE event
    ADD COLUMN is_deleted boolean NOT NULL DEFAULT false;
    