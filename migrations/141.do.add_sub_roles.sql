CREATE TABLE sub_roles
(
  id         SERIAL PRIMARY KEY,
  name       VARCHAR NOT NULL,
  is_medical BOOLEAN DEFAULT false
);

INSERT INTO sub_roles (id, name, is_medical)
VALUES (1, 'doctor', true),
       (2, 'therapist', true),
       (3, 'nurse', true),
       (4, 'personal_trainers', false),
       (5, 'receptionists', true);

CREATE TABLE clinic_sub_roles
(
  clinic_id   UUID REFERENCES clinics (id) ON DELETE CASCADE ON UPDATE CASCADE,
  sub_role_id INT REFERENCES sub_roles (id) ON DELETE CASCADE ON UPDATE CASCADE,
  PRIMARY KEY (clinic_id, sub_role_id)
);

INSERT INTO clinic_sub_roles SELECT distinct clinic_id, 1 as sub_role_id from clinic_positions;

ALTER TABLE clinic_positions
  add column sub_role_id INT DEFAULT 1 REFERENCES sub_roles (id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE clinic_positions
  ADD FOREIGN KEY (clinic_id, sub_role_id) REFERENCES clinic_sub_roles (clinic_id, sub_role_id);
