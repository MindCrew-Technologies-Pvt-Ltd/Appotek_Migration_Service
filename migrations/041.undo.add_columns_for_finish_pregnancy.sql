 alter table user_pregnancy 
	drop column end_at,
	drop conclusion;
 
   alter table health
	drop CONSTRAINT heath_created_by_fkey,
	drop column created_by;
