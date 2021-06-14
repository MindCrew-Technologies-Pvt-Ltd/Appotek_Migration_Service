
ALTER TABLE "clinics-to-users"
  RENAME COLUMN active TO verified;

ALTER TABLE "clinics-to-users"
  DROP COLUMN is_admin;

DROP UNIQUE INDEX clinic_id_1_is_admin_1_unique ON "clinics-to-users";
DROP  INDEX userId_1_active_1_unique ON "clinics-to-users";
ALTER TABLE "clinics-to-users"
  DROP CONSTRAINT "clinics-to-users_pkey";
ALTER TABLE "clinics-to-users"
  ADD COLUMN id UUID;
ALTER TABLE "clinics-to-users"
  ADD PRIMARY KEY (id);


DROP TRIGGER before_insert_set_first_clinic_status_active
  ON "clinics-to-users";

DROP TRIGGER after_clinic_position_create_or_update_trigger
  ON clinic_positions;
