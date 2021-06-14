CREATE TYPE health_record_report_enum AS ENUM ('a','i','c','d','p','o');

CREATE TABLE health_record_report
(
  id                 BIGSERIAL PRIMARY KEY,
  patient_id         UUID                      NOT NULL REFERENCES users (id) ON DELETE CASCADE,
  created_by         UUID                      NOT NULL REFERENCES users (id) ON DELETE CASCADE,
  type               health_record_report_enum NOT NULL,
  start_at           TIMESTAMP WITH TIME ZONE  NOT NULL,
  end_at             TIMESTAMP WITH TIME ZONE,
  based_on_report_id BIGINT                    REFERENCES health_record_report (id) ON DELETE SET NULL,
  diagnosis_id       UUID                      REFERENCES medical_icd11 (id) ON DELETE SET NULL,
  symptoms           VARCHAR,
  title              VARCHAR,
  number             VARCHAR,
  gross_description  VARCHAR,
  micro_description  VARCHAR,
  conclusion         VARCHAR,
  cancer_details     JSONB
);

CREATE TABLE health_record_report_to_attachment
(
  report_id     BIGINT REFERENCES health_record_report (id) ON DELETE CASCADE,
  attachment_id UUID REFERENCES attachments (id) ON DELETE CASCADE
);

CREATE TABLE diagnostic_records
(
  id       SERIAL PRIMARY KEY,
  title    VARCHAR NOT NULL UNIQUE,
  category VARCHAR
);

CREATE TABLE heath_report_diagnostic_referrals
(
  health_record_id       BIGINT REFERENCES health_record_report (id) ON DELETE CASCADE,
  diagnostic_referral_id INT REFERENCES diagnostic_records (id) ON DELETE CASCADE,
  PRIMARY KEY (health_record_id, diagnostic_referral_id)
);

CREATE TABLE health_record_report_doctor_referrals
(
  health_record_id   BIGINT REFERENCES health_record_report (id) ON DELETE CASCADE,
  doctor_to_refer_id UUID NOT NULL REFERENCES users (id) ON DELETE CASCADE,
  shared_interval    INTERVAL,
  share_all_records  BOOLEAN,
  description        VARCHAR,
  PRIMARY KEY (health_record_id, doctor_to_refer_id)
);

ALTER TABLE treatment_records
  ADD COLUMN based_on_health_report_id BIGINT REFERENCES health_record_report (id) ON DELETE SET NULL;