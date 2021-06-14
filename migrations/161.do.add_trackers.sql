CREATE TABLE trackers
(
  id        SERIAL PRIMARY KEY,
  category  INT     NOT NULL,
  name      VARCHAR NOT NULL,
  avatar_id UUID REFERENCES attachments (id) ON DELETE SET NULL ON UPDATE CASCADE
);
