ALTER TABLE treatment_prescriptions
  ADD COLUMN frequency JSONB;
ALTER TABLE treatment_prescriptions
  ADD COLUMN interval JSONB;