ALTER TABLE clinic_positions
  ADD  COLUMN attachments UUID[];
ALTER TABLE clinic_positions
  DROP COLUMN certificate;
ALTER TABLE clinic_positions
  DROP COLUMN certificate_number;
