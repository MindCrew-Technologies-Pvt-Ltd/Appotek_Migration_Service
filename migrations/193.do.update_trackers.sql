ALTER TABLE trackers add column default_description varchar;
ALTER TABLE trackers add column default_body_part int references body_parts(id) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE trackers add column default_attachment_ids UUID[];
