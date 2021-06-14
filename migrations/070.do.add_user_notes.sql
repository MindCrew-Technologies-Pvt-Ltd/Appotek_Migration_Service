CREATE TYPE user_notes_types AS ENUM ('practice', 'approach', 'about');

CREATE TABLE user_notes
(
  id          BIGSERIAL PRIMARY KEY,
  type        user_notes_types           NOT NULL,
  user_id     UUID REFERENCES users (id),
  description VARCHAR(256) default ''    NOT NULL,
  created_at  TIMESTAMPTZ  default now() NOT NULL,
  updated_at  TIMESTAMPTZ  default now() NOT NULL
)
