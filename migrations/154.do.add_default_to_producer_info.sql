UPDATE drug_records SET producer_info = '{}'::json WHERE producer_info IS NULL;
ALTER TABLE drug_records ALTER COLUMN producer_info SET DEFAULT '{}'::json; 
