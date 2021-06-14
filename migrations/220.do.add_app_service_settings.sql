CREATE TABLE app_service_settings
(
    user_id      UUID REFERENCES users (id) ON DELETE CASCADE ON UPDATE CASCADE primary key,
    data_format  varchar,
    clock_format int,
    start_week   varchar
);