DROP TABLE clinic_department_schedules
(
    id                   SERIAL PRIMARY KEY,
    clinic_department_id INT REFERENCES clinic_department (id) ON DELETE CASCADE ON UPDATE CASCADE,
    day_of_week          INT    NOT NULL,
    time_from            TIMETZ NOT NULL,
    time_to              TIMETZ NOT NULL
);

ALTER TABLE clinic_department
    drop column medical_specialization_id;
ALTER TABLE clinic_department
    drop column telephone_id;
ALTER TABLE clinic_department
    drop column email;
ALTER TABLE clinic_department
    drop column attachment_id;
