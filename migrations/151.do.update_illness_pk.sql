ALTER TABLE user_illnesses DROP CONSTRAINT user_illnesses_pkey;
ALTER TABLE user_illnesses ADD COLUMN id SERIAL PRIMARY KEY;
