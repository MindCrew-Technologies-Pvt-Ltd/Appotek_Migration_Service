CREATE TABLE monitoring_area_schedules
(
  id              SERIAL PRIMARY KEY,
  monitoring_area_id INT REFERENCES clinic_monitoring_area (id) ON DELETE CASCADE ON UPDATE CASCADE,
  day_of_week     INT    NOT NULL,
  time_from       TIMETZ NOT NULL,
  time_to         TIMETZ NOT NULL
);

ALTER TABLE clinic_monitoring_area ADD column medical_specialization_id INT REFERENCES medical_specializations(id) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE clinic_monitoring_area ADD column telephone_id UUID references telephones(id) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE clinic_monitoring_area ADD column email VARCHAR;
ALTER TABLE clinic_monitoring_area DROP CONSTRAINT clinic_monitoring_area_clinic_id_key;
