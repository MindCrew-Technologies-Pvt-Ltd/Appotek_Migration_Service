CREATE TABLE clinic_media_folder
(
    id               SERIAL PRIMARY KEY,
    section          varchar not null,
    display_name     varchar not null,
    parent_folder_id INT REFERENCES clinic_media_folder (id) ON DELETE CASCADE ON UPDATE CASCADE,
    clinic_id        UUID REFERENCES clinics (id) ON DELETE CASCADE ON UPDATE CASCADE,
    created_by       UUID REFERENCES users (id) ON DELETE SET NULL ON UPDATE CASCADE,
    created_at       timestamptz default now()
);

CREATE TABLE clinic_media_record
(
    id            SERIAL PRIMARY KEY,
    attachment_id UUID REFERENCES attachments (id) ON DELETE CASCADE ON UPDATE CASCADE,
    section       varchar not null,
    display_name  varchar not null,
    folder_id     INT REFERENCES clinic_media_folder (id) ON DELETE CASCADE ON UPDATE CASCADE,
    clinic_id     UUID REFERENCES clinics (id) ON DELETE CASCADE ON UPDATE CASCADE,
    created_by    UUID REFERENCES users (id) ON DELETE SET NULL ON UPDATE CASCADE,
    created_at    timestamptz default now()
);

CREATE TABLE clinic_media_access_group
(
    id           SERIAL PRIMARY KEY,
    display_name varchar not null,
    created_by   UUID REFERENCES users (id) ON DELETE SET NULL ON UPDATE CASCADE,
    created_at   timestamptz default now()
);

CREATE TABLE clinic_media_access_group_participant
(
    user_id  UUID REFERENCES users (id) ON DELETE CASCADE ON UPDATE CASCADE,
    group_id INT REFERENCES clinic_media_access_group (id) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (user_id, group_id)
);

CREATE TABLE clinic_media_access_group_to_folder
(
    folder_id INT REFERENCES clinic_media_folder (id) ON DELETE CASCADE ON UPDATE CASCADE,
    group_id  INT REFERENCES clinic_media_access_group (id) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (folder_id, group_id)
);
