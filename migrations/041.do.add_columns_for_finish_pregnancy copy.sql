 alter table user_pregnancy 
	add column end_at timestamptz,
	add column conclusion varchar;
 
  alter table health
	add column created_by uuid,
	add CONSTRAINT heath_created_by_fkey FOREIGN KEY (created_by)
      REFERENCES users (id) MATCH FULL
	  ON UPDATE NO ACTION ON DELETE NO ACTION;
