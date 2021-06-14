ALTER TABLE allergy_categories
  ADD COLUMN locale JSONB DEFAULT json_build_object() NOT NULL;
ALTER TABLE allergies
  ADD COLUMN locale JSONB DEFAULT json_build_object() NOT NULL;
