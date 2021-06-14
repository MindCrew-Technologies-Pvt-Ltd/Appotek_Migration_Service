delete from drug_records where length(drug_code) > 4; 

alter table drug_records
	alter column drug_code type varchar(4),
	drop column country_id,
	alter column id drop default,
	alter column mt_id set not null,
	alter column atc_code set not null,
	alter column atc_code type varchar(4),
	alter column registration_year set not null;

drop function get_countryId_by_isoCode(bpchar);

DROP SEQUENCE drug_records_seq;

update drug_records set id = CONCAT(drug_code::text, mt_id::text, registration_year::text)::bigint;

ALTER TABLE drugs_to_active_components
	DROP CONSTRAINT fk_drug_to_drugs_record,
	ADD CONSTRAINT fk_drug_to_drugs_record FOREIGN KEY (drug_id) REFERENCES drug_records(id) MATCH FULL ON DELETE CASCADE;

alter table medicines_to_dosages
		drop CONSTRAINT medicine_to_medicine_id,
		add CONSTRAINT medicine_to_medicine_id FOREIGN KEY (medicine_id) REFERENCES drug_records(id) ON DELETE cascade;