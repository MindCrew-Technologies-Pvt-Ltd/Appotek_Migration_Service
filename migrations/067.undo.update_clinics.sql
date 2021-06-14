DROP INDEX clinic_id_user_id;

CREATE UNIQUE INDEX clinic_id_1_is_admin_1_unique ON "clinics-to-users" ("clinicId", is_admin) WHERE "deletedAt" IS NULL;
CREATE UNIQUE INDEX userId_1_active_1_unique ON "clinics-to-users" ("userId", active) WHERE "deletedAt" IS NULL AND active IS TRUE;
ALTER TABLE clinic_positions
  DROP COLUMN is_active;
ALTER TABLE clinic_positions
  DROP COLUMN is_admin;

CREATE OR REPLACE FUNCTION after_clinic_position_create_or_update() RETURNS TRIGGER AS
$BODY$
BEGIN
  INSERT INTO "clinics-to-users"("clinicId", "userId", "deletedAt")
  VALUES (NEW.clinic_id, NEW.user_id, NULL)
  ON CONFLICT (
     "clinicId",
     "userId")
     DO NOTHING;
  RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql;
 CREATE OR REPLACE FUNCTION set_first_clinic_status_active() RETURNS TRIGGER AS
$BODY$
BEGIN
  IF (
    SELECT (
             SELECT count(*) = 0
             FROM "clinics-to-users" ctu
             WHERE ctu."userId" = NEW."userId"
               AND ctu."deletedAt" IS NULL
           )
  ) THEN
    NEW.active = TRUE;
  ELSE
  END IF;
  IF (
    SELECT (
             SELECT count(*) = 0
             FROM "clinics-to-users" ctu
             WHERE ctu."clinicId" = NEW."clinicId"
               AND ctu."deletedAt" IS NULL
           )
  )
  THEN
    NEW.is_admin = TRUE;
  ELSE
  END IF;
  RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql;

 CREATE TRIGGER before_insert_set_first_clinic_status_active
  BEFORE INSERT
  ON "clinics-to-users"
  FOR EACH ROW
EXECUTE PROCEDURE set_first_clinic_status_active();
CREATE TRIGGER after_clinic_position_create_or_update_trigger
  AFTER INSERT
  ON clinic_positions
  FOR EACH ROW
EXECUTE PROCEDURE after_clinic_position_create_or_update();
drop trigger before_clinic_position_created_trigger ON clinic_positions;
ALTER TABLE clinics
  drop COLUMN clinic_tz;
 drop function get_time_slots(UUID, UUID, TIMESTAMP, TIMESTAMP, interval)

 ALTER TABLE clinic_position_schedule
  DROP CONSTRAINT consultation_time_slot_check;
ALTER TABLE clinic_position_schedule
  DROP CONSTRAINT home_visit_time_slot_check;
ALTER TABLE clinic_position_schedule
  DROP CONSTRAINT online_time_slot_check;

 ALTER TABLE clinic_position_schedule
  DROP COLUMN consultation_slot_from;
ALTER TABLE clinic_position_schedule
  DROP COLUMN consultation_slot_to;
ALTER TABLE clinic_position_schedule
  DROP COLUMN consultation_slot_interval;
ALTER TABLE clinic_position_schedule
  DROP COLUMN home_visit_slot_from;
ALTER TABLE clinic_position_schedule
  DROP COLUMN home_visit_slot_to;
ALTER TABLE clinic_position_schedule
  DROP COLUMN home_visit_slot_interval;
ALTER TABLE clinic_position_schedule
  DROP COLUMN online_slot_from;
ALTER TABLE clinic_position_schedule
  DROP COLUMN online_slot_to;
ALTER TABLE clinic_position_schedule
  DROP COLUMN online_slot_interval;
