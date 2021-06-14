 CREATE TABLE care_plans (
 	id serial not null,
	user_id uuid NOT NULL,
	created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at timestamptz NULL,
	title varchar(256) not null,
	description varchar null,
	attached_files uuid[] NULL,
	family_ties json[] null,
	CONSTRAINT care_plans_pkey PRIMARY KEY (id),
	CONSTRAINT car_plans_user_id_fkey FOREIGN KEY (user_id)
      REFERENCES users (id) MATCH FULL
	  ON UPDATE NO ACTION ON DELETE CASCADE
);