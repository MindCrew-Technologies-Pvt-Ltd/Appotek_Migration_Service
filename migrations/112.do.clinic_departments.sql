CREATE TABLE clinic_department
(
  id         SERIAL PRIMARY KEY,
  clinic_id  UUID REFERENCES clinics (id) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
  title      VARCHAR                                                          NOT NULL,
  created_by UUID REFERENCES users (id) ON DELETE CASCADE ON UPDATE CASCADE,
  created_at TIMESTAMPTZ default now()
);

ALTER TABLE clinic_positions
  ADD COLUMN department_id INT REFERENCES clinic_department (id);

ALTER TABLE waiting_room
  add column booking_only BOOLEAN DEFAULT false;

ALTER TABLE waiting_room
  add column per_invitation_only BOOLEAN DEFAULT false;

ALTER TABLE waiting_room
  add column medical_specializations_id INT REFERENCES medical_specializations (id) ON DELETE SET NULL ON UPDATE CASCADE;
