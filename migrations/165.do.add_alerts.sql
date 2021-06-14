ALTER TABLE clinic_monitoring_area
  add column timeout_m INT default 15;

CREATE TABLE alerts
(
  id                 SERIAL PRIMARY KEY,
  type               VARCHAR                                                                        NOT NULL,
  level              VARCHAR     DEFAULT 'warning',
  monitoring_area_id INT REFERENCES clinic_monitoring_area (id) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
  patient_id         UUID REFERENCES users (id) ON DELETE CASCADE ON UPDATE CASCADE                 NOT NULL,
  created_at         TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE alert_reviews
(
  alert_id   int references alerts (id) ON DELETE CASCADE ON UPDATE CASCADE,
  user_id    UUID REFERENCES users (id) ON DELETE CASCADE ON UPDATE CASCADE,
  created_at TIMESTAMPTZ DEFAULT now(),
  PRIMARY KEY (alert_id, user_id)
);
