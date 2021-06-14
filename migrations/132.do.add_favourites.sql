CREATE TABLE user_favourites_clinic
(
  user_id    UUID references users (id) ON DELETE CASCADE ON UPDATE CASCADE,
  clinic_id  UUID references clinics (id) ON DELETE CASCADE ON UPDATE CASCADE,
  updated_at TIMESTAMPTZ default now(),
  PRIMARY KEY (user_id, clinic_id)
);

CREATE TABLE user_favourites_pharmacies(
  user_id    UUID references users (id) ON DELETE CASCADE ON UPDATE CASCADE,
  pharmacy_id  INT references pharmacies (id) ON DELETE CASCADE ON UPDATE CASCADE,
  updated_at TIMESTAMPTZ default now(),
  PRIMARY KEY (user_id, pharmacy_id)
)
