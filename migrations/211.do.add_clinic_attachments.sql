CREATE TABLE clinic_to_attachments (
	attachment_id uuid PRIMARY KEY,
	clinic_id uuid NOT NULL,
	created_at timestamptz NOT NULL DEFAULT now(),
	created_by uuid NOT NULL,
	is_approve bool NOT NULL DEFAULT FALSE,
	decide_date timestamptz,
	decide_by uuid,
	support_comment varchar,
	CONSTRAINT fk_cta_attachment_id_to_attachments FOREIGN KEY (attachment_id) REFERENCES attachments(id) MATCH FULL,
	CONSTRAINT fk_cta_clinic_id_to_clinicss FOREIGN KEY (clinic_id) REFERENCES clinics(id) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT fk_cta_created_by_to_user FOREIGN KEY (created_by) REFERENCES users(id) MATCH FULL,
	CONSTRAINT fk_cta_decide_by_to_user FOREIGN KEY (decide_by) REFERENCES users(id) MATCH FULL
);

ALTER TABLE clinics 
	ADD COLUMN approved_at timestamptz,
	ADD COLUMN approved_by uuid,
	ADD CONSTRAINT fk_c_approved_by_to_user FOREIGN KEY (approved_by) REFERENCES users(id) MATCH FULL;

CREATE OR REPLACE FUNCTION set_approve_clinic_attachments() RETURNS trigger AS $func$
    BEGIN
	    IF (NEW.approved_at IS NOT NULL AND (OLD.approved_at IS NULL OR NEW.approved_at <> OLD.approved_at))
	    THEN
	    	UPDATE clinic_to_attachments SET 
	    		is_approve = 'true',
	    		decide_by = NEW.approved_by,
	    		decide_date = now()
	    	WHERE clinic_id = NEW.id;
		END IF;
	
		return new;
    END;
$func$ LANGUAGE plpgsql;

CREATE TRIGGER set_approve_clinic_attachments AFTER INSERT OR UPDATE ON clinics
    FOR EACH ROW EXECUTE PROCEDURE set_approve_clinic_attachments();