ALTER TABLE care_plans
  ADD COLUMN family_ties JSON;

DROP TABLE care_plans_to_participant;
