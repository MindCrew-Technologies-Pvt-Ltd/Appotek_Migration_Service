
ALTER TABLE "clinics-to-users"
  RENAME COLUMN verified TO active;

ALTER TABLE "clinics-to-users"
  ADD COLUMN is_admin BOOLEAN;

CREATE UNIQUE INDEX clinic_id_1_is_admin_1_unique ON "clinics-to-users" ("clinicId", is_admin) WHERE "deletedAt" IS NULL;

CREATE UNIQUE INDEX userId_1_active_1_unique ON "clinics-to-users" ("userId", active) WHERE "deletedAt" IS NULL AND active IS TRUE;
ALTER TABLE "clinics-to-users"
  DROP CONSTRAINT "clinics-to-users_pkey";
ALTER TABLE "clinics-to-users"
  DROP COLUMN id;
ALTER TABLE "clinics-to-users"
  ADD PRIMARY KEY ("userId", "clinicId");

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
