CREATE TABLE sign_up_tasks
(
    id            SERIAL PRIMARY KEY,
    type          varchar not null unique,
    sub_roles_ids int[]   default '{}',
    for_admin     boolean default false
);

CREATE TABLE sign_up_tasks_statuses
(
    user_id         UUID REFERENCES users (id) ON DELETE CASCADE ON UPDATE CASCADE,
    sign_up_task_id INT REFERENCES sign_up_tasks (id) ON DELETE CASCADE ON UPDATE CASCADE,
    is_read         boolean default false,
    is_done         boolean default false,
    PRIMARY KEY (user_id, sign_up_task_id)
);

INSERT INTO sign_up_tasks(type, sub_roles_ids, for_admin)
VALUES ('fill_clinic_id', '{}', true),
       ('fill_billing_info', '{}', true),
       ('fill_password_recovery', '{1,2,3}', true),
       ('fill_clinic_info', '{}', true),
       ('fill_clinic_cert', '{1,2,3}', false),
       ('fill_personal_info', '{1,2,3}', false),
       ('add_departments', '{}', true),
       ('auto_bookings', '{}', true),
       ('add_personal_schedule', '{1,2,3}', false),
       ('add_prices', '{}', true),
       ('set_notifications', '{1,2,3}', false);
