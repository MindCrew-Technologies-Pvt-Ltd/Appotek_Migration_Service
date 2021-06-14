ALTER TABLE stripe_connect 
	ADD CONSTRAINT stripe_connect_appotek_user_id_key UNIQUE (appotek_user_id);