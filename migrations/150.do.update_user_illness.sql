ALTER TABLE user_illnesses
  ADD COLUMN symptoms VARCHAR;
ALTER TABLE user_illnesses
  ADD COLUMN history VARCHAR;
ALTER TABLE user_illnesses
  ADD COLUMN created_at TIMESTAMPTZ DEFAULT now();
