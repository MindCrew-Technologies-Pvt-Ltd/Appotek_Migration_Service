CREATE TABLE tags
(
  id    BIGSERIAL PRIMARY KEY,
  title VARCHAR
);

CREATE TABLE user_tags
(
  user_id        UUID REFERENCES users (id),
  tagged_user_id UUID REFERENCES users (id),
  tag_id         BIGINT REFERENCES tags (id),
  PRIMARY KEY (user_id, tagged_user_id, tag_id),
  CHECK ( tagged_user_id != user_id )
);

CREATE TABLE permissions_sharing
(
  user_id          UUID REFERENCES users (id),
  tag_to_share_id  BIGINT REFERENCES tags (id),
  user_to_share_id UUID REFERENCES users (id),
  medical_history  BOOLEAN DEFAULT FALSE,
  remind_tasks     BOOLEAN DEFAULT FALSE,
  pick_up_medicine BOOLEAN DEFAULT FALSE,
  tasks            BOOLEAN DEFAULT FALSE,
  activity         BOOLEAN DEFAULT FALSE,
  attached_files   UUID[],
  PRIMARY KEY (user_id, tag_to_share_id, user_to_share_id),
  CHECK (
      (user_id != user_to_share_id)
      AND (
            (tag_to_share_id IS NULL)::INTEGER +
            (user_to_share_id IS NULL)::INTEGER
          = 1
        )
    )
);