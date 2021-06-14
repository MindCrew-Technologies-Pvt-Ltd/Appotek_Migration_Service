UPDATE attachments SET subtype = '*' WHERE length(subtype) > 32;
ALTER TABLE attachments 
	ALTER COLUMN subtype TYPE varchar(32);