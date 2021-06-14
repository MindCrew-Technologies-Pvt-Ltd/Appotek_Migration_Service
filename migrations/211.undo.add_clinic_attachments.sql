DROP TRIGGER set_approve_clinic_attachments ON clinics;   
DROP FUNCTION set_approve_clinic_attachments();

DROP TABLE clinic_to_attachments;

ALTER TABLE clinics 
	DROP CONSTRAINT fk_c_approved_by_to_user,
	DROP COLUMN approved_at,
	DROP COLUMN approved_by;
