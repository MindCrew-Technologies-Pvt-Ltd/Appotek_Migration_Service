CREATE TABLE waiting_room
(
  id         SERIAL PRIMARY KEY,
  clinic_id  UUID REFERENCES clinics (id) ON DELETE CASCADE ON UPDATE CASCADE,
  created_by UUID REFERENCES users (id) ON DELETE SET NULL ON UPDATE CASCADE,
  title      VARCHAR NOT NULL,
  avatar_id  UUID REFERENCES attachments (id) ON DELETE SET NULL ON UPDATE CASCADE,
  open_from  TIMETZ,
  open_to    TIMETZ
);

CREATE TABLE waiting_room_participant
(
  room_id    INT REFERENCES waiting_room (id) ON DELETE CASCADE ON UPDATE CASCADE,
  user_id    UUID REFERENCES users (id) ON DELETE CASCADE ON UPDATE CASCADE,
  symptoms   VARCHAR,
  created_at TIMESTAMPTZ default now(),
  picked_by  UUID REFERENCES users (id) ON DELETE CASCADE ON UPDATE CASCADE,
  PRIMARY KEY (room_id, user_id)
);

CREATE TABLE doctor_waiting_room
(
  user_id         UUID REFERENCES users (id) ON DELETE CASCADE ON UPDATE CASCADE UNIQUE,
  waiting_room_id INT REFERENCES waiting_room (id) ON DELETE CASCADE ON UPDATE CASCADE,
  PRIMARY KEY (user_id, waiting_room_id)
)
