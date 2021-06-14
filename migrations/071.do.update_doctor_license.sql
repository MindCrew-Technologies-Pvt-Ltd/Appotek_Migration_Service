ALTER TABLE doctor_ids
  ADD COLUMN medical_specialization_id BIGINT REFERENCES medical_specializations (id) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE doctor_ids
  ADD COLUMN medical_level_id BIGINT REFERENCES medical_levels (id) ON DELETE SET NULL ON UPDATE CASCADE
