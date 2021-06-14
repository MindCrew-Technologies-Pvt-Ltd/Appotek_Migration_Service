ALTER TABLE drug_records
    ALTER COLUMN mt_id type varchar(10), 
    ALTER COLUMN strength drop not null;
