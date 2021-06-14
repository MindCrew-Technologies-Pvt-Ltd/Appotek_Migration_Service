ALTER TABLE trackers
    drop column default_description;
ALTER TABLE trackers
    drop column default_attachment_ids;

ALTER TABLE trackers
    add column can_track varchar[];
ALTER TABLE trackers
    add column connection_options varchar[];

CREATE TABLE tracker_attachment
(
    id            SERIAL PRIMARY KEY,
    tracker_id    INT references trackers (id) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
    attachment_id UUID references attachments (id) ON DELETE CASCADE ON UPDATE CASCADE,
    description   varchar,
    index         INT
);
