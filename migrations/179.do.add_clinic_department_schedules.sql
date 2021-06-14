CREATE TABLE clinic_department_schedules
(
    id                   SERIAL PRIMARY KEY,
    clinic_department_id INT REFERENCES clinic_department (id) ON DELETE CASCADE ON UPDATE CASCADE,
    day_of_week          INT    NOT NULL,
    time_from            TIMETZ NOT NULL,
    time_to              TIMETZ NOT NULL
);

ALTER TABLE clinic_department
    ADD column medical_specialization_id INT REFERENCES medical_specializations (id) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE clinic_department
    ADD column telephone_id UUID references telephones (id) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE clinic_department
    ADD column email VARCHAR;
ALTER TABLE clinic_department
    ADD column attachment_id UUID REFERENCES attachments (id) ON DELETE CASCADE ON UPDATE CASCADE;
