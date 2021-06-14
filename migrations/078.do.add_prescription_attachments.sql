CREATE TABLE prescription_attachment
(
  id              BIGSERIAL PRIMARY KEY,
  prescription_id INTEGER REFERENCES treatment_prescriptions (id) ON DELETE CASCADE ON UPDATE CASCADE,
  attachment_id   UUID REFERENCES attachments (id) ON DELETE CASCADE ON UPDATE CASCADE,
  description     VARCHAR(512),
  CHECK ((attachment_id IS NULL) != (description IS NULL))
);
