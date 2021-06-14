CREATE TABLE invites
(
  id         SERIAL PRIMARY KEY,
  code       VARCHAR NOT NULL CHECK ( length(code) = 6 ) DEFAULT substring(md5(random()::text) from 1 for 6),
  role_id    INT REFERENCES roles (id) ON DELETE CASCADE ON UPDATE CASCADE,
  first_name VARCHAR NOT NULL,
  last_name  VARCHAR NOT NULL,
  telephone  VARCHAR,
  email      VARCHAR,
  country_id INT REFERENCES countries (id) ON DELETE CASCADE ON UPDATE CASCADE,
  gender     enum_users_gender,
  dob        DATE,
  created_by UUID REFERENCES users (id) ON DELETE CASCADE ON UPDATE CASCADE,
  clinic_id  UUID REFERENCES clinics (id) ON DELETE CASCADE ON UPDATE CASCADE
);
