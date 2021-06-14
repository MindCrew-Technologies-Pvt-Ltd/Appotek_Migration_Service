ALTER TABLE contacts
  ADD COLUMN clinic_id UUID REFERENCES clinics (id);
