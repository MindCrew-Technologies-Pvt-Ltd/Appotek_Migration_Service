ALTER TABLE treatment_prescriptions
  ADD COLUMN is_active BOOLEAN DEFAULT TRUE;
ALTER TABLE treatment_prescriptions
  ADD COLUMN remind_at TIMESTAMPTZ DEFAULT NULL;
