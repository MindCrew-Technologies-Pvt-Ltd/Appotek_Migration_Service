ALTER TABLE drug_records
    ALTER COLUMN mt_id type varchar(5), 
    ALTER COLUMN strength set not null;