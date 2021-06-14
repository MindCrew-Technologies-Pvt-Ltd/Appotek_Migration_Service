ALTER TABLE user_illnesses DROP CONSTRAINT user_illnesses_pkey;
ALTER TABLE user_illnesses ADD COLUMN id;
ALTER TABLE user_illnesses ADD PRIMARY KEY (user_id, illness_id);
