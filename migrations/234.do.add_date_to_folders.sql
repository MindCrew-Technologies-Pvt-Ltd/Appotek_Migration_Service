ALTER TABLE treatment_templates_folders 
	ADD COLUMN created_at timestamptz NOT NULL default now(),
	ADD COLUMN updated_at timestamptz NOT NULL default now();
