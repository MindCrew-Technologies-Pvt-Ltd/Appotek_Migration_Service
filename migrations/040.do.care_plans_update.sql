ALTER TABLE care_plans
  DROP COLUMN family_ties;

CREATE TABLE care_plans_to_participant
(
  care_plan_id INT REFERENCES care_plans (id),
  user_id      UUID REFERENCES users (id),
  PRIMARY KEY (care_plan_id, user_id)
);
