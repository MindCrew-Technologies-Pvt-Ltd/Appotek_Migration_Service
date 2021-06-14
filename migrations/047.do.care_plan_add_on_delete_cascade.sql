
ALTER TABLE care_plans_to_participant
  DROP CONSTRAINT care_plans_to_participant_care_plan_id_fkey,
  ADD CONSTRAINT care_plans_to_participant_care_plan_id_fkey FOREIGN KEY (care_plan_id) REFERENCES care_plans (id) ON DELETE CASCADE ON UPDATE CASCADE;
