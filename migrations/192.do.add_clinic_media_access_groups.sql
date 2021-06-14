ALTER TABLE clinic_media_access_group
    add column avatar_id UUID REFERENCES attachments (id) on delete cascade on update cascade;
ALTER TABLE clinic_media_access_group
    add column type varchar;
ALTER TABLE clinic_media_folder
    add column access_type varchar default 'public';
ALTER TABLE clinic_media_folder
    add column access_group_id INT REFERENCES clinic_media_access_group (id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE clinic_media_folder
    add column allowed_user_ids uuid[];
