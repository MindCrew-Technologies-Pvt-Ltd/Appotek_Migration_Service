ALTER TABLE treatment_templates_folders
  DROP CONSTRAINT treatment_templates_folders_check,
  ADD CONSTRAINT treatment_templates_folders_check CHECK ( (owner_id IS NULL) != (clinic_id IS NULL));

ALTER TABLE treatment_templates
  DROP CONSTRAINT treatment_templates_check,
  ADD CONSTRAINT treatment_templates_check CHECK ( (owner_id IS NULL) != (clinic_id IS NULL) );
