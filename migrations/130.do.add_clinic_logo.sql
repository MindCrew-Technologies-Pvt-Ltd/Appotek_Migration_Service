ALTER TABLE clinics
	ADD COLUMN logo_id uuid,
	ADD CONSTRAINT logo_attachment_fkey FOREIGN KEY (logo_id)
  	REFERENCES attachments(id) 
  	MATCH FULL ON DELETE CASCADE