CREATE TABLE monitoring_area_notes
(
    id                 serial primary key,
    note               varchar not null,
    monitoring_area_id int references clinic_monitoring_area (id) ON DELETE CASCADE ON UPDATE CASCADE,
    user_id            UUID REFERENCES users (id) ON DELETE CASCADE ON UPDATE CASCADE,
    created_by         UUID REFERENCES users (id) ON DELETE CASCADE ON UPDATE CASCADE,
    created_at         timestamptz default now()
);
