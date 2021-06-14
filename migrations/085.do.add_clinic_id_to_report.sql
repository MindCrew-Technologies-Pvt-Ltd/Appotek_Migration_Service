ALTER TABLE health_record_report
  ADD COLUMN clinic_id UUID REFERENCES clinics (id);
