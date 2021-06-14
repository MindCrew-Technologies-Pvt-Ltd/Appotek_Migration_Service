ALTER TABLE drug_records 
	ADD COLUMN producer_info json NULL,
	ADD COLUMN internal_id varchar NULL,
	ADD CONSTRAINT drug_record_internal_id_unique UNIQUE(country_id, internal_id);
UPDATE drug_records SET internal_id = rtrim(substring(leaflet_url FROM position('pil.' in leaflet_url)+4), '.pdf') WHERE country_id = 239;
