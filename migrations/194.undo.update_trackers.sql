ALTER TABLE trackers
    add column default_description varchar;
ALTER TABLE trackers
    add  column default_attachment_ids uuid[];

ALTER TABLE trackers
    drop column can_track;
ALTER TABLE trackers
    drop column connection_options;

DROP TABLE tracker_attachment;
