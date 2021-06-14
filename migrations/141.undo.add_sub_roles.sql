ALTER TABLE clinic_positions
  drop column sub_role_id INT DEFAULT 1 REFERENCES sub_roles (id) ON DELETE CASCADE ON UPDATE CASCADE;


DROP TABLE clinic_sub_roles
(
  clinic_id   UUID REFERENCES clinics (id) ON DELETE CASCADE ON UPDATE CASCADE,
  sub_role_id INT REFERENCES sub_roles (id) ON DELETE CASCADE ON UPDATE CASCADE,
  PRIMARY KEY (clinic_id, sub_role_id)
);
DROP TABLE sub_roles
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
