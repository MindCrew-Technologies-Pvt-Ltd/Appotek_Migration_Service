CREATE TABLE waiting_room_schedules
(
  id              SERIAL PRIMARY KEY,
  waiting_room_id INT REFERENCES waiting_room (id) ON DELETE CASCADE ON UPDATE CASCADE,
  day_of_week     INT    NOT NULL,
  time_from       TIMETZ NOT NULL,
  time_to         TIMETZ NOT NULL
);
