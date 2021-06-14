ALTER TABLE health_record_report
  ADD COLUMN user_input_clinic VARCHAR;
ALTER TABLE health_record_report
  ADD COLUMN user_input_doctor VARCHAR;
ALTER TABLE health_record_report
  ADD COLUMN user_input_medical_specialization INT REFERENCES medical_specializations (id) ON DELETE CASCADE ON UPDATE CASCADE
