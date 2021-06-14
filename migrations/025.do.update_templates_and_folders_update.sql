ALTER TABLE treatment_templates_folders
  DROP CONSTRAINT treatment_templates_folders_check,
  ADD CONSTRAINT treatment_templates_folders_check CHECK ( (owner_id IS NOT NULL OR clinic_id IS NOT NULL) AND (id != parent_id) );

ALTER TABLE treatment_templates
  DROP CONSTRAINT treatment_templates_check,
  ADD CONSTRAINT treatment_templates_check CHECK ( (owner_id IS NOT NULL OR clinic_id IS NOT NULL));
