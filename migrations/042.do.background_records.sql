CREATE TABLE background_record
(
  id         SERIAL PRIMARY KEY,
  title      VARCHAR(128)               NOT NULL,
  body       VARCHAR(256)               NOT NULL,
  patient_id UUID REFERENCES users (id) NOT NULL,
  created_by UUID REFERENCES users (id) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
