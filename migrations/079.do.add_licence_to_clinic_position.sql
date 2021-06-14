ALTER TABLE clinic_positions
  DROP COLUMN attachments;
ALTER TABLE clinic_positions
  ADD COLUMN certificate UUID REFERENCES attachments (id);
ALTER TABLE clinic_positions
  ADD COLUMN certificate_number VARCHAR;
