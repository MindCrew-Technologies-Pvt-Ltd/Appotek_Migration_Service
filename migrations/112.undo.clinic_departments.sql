
ALTER TABLE clinic_positions
  DROP COLUMN department_id;

DROP TABLE clinic_department;

ALTER TABLE waiting_room
  DROP column booking_only;

ALTER TABLE waiting_room
  DROP column per_invitation_only;

ALTER TABLE waiting_room
  DROP column medical_specializations_id;
