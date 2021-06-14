CREATE TABLE health_record_referrals
(
  id                        BIGSERIAL PRIMARY KEY,
  health_record_id          BIGINT UNIQUE REFERENCES health_record_report (id) ON DELETE CASCADE ON UPDATE CASCADE,
  patient_id                UUID NOT NULL REFERENCES users (id) ON DELETE CASCADE ON UPDATE CASCADE,
  clinic_id                 UUID REFERENCES clinics (id) ON DELETE SET NULL ON UPDATE CASCADE,
  medical_specialization_id BIGINT REFERENCES medical_specializations (id) ON DELETE SET NULL ON UPDATE CASCADE,
  description               VARCHAR(256),
  referrals                 integer[]   DEFAULT '{}',
  created_at                TIMESTAMPTZ DEFAULT current_timestamp,
  created_by                UUID REFERENCES users (id) ON DELETE SET NULL ON UPDATE CASCADE
);
