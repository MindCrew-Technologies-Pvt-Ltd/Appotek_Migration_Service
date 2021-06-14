CREATE TABLE sharing_tasks (
	id serial NOT NULL,
	owner_id uuid NOT NULL,
	created_at timestamptz not null default current_timestamp,
	updated_at timestamptz,
	deleted_at timestamptz,
	description varchar(256),
	accepted_by uuid,
	accepted_date timestamptz,
	CONSTRAINT sharing_tasks_pkey PRIMARY KEY (id)
);
ALTER TABLE sharing_tasks ADD CONSTRAINT fk_sharing_task_owner_to_user FOREIGN KEY ("owner_id") REFERENCES users(id) MATCH FULL ON DELETE CASCADE;
ALTER TABLE sharing_tasks ADD CONSTRAINT fk_sharing_task_accepted_to_user FOREIGN KEY ("accepted_by") REFERENCES users(id) MATCH FULL;