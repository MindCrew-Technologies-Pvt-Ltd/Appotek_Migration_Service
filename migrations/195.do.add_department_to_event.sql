ALTER TABLE event
    ADD COLUMN department_id INT REFERENCES clinic_department (id) ON DELETE SET NULL ON UPDATE CASCADE;
