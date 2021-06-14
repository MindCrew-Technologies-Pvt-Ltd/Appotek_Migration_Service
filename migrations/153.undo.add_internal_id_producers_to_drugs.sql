ALTER TABLE drug_records 
	DROP CONSTRAINT drug_record_internal_id_unique,
	DROP COLUMN producer_info,
	DROP COLUMN internal_id;