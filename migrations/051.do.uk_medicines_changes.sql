CREATE OR REPLACE FUNCTION get_countryId_by_isoCode(iso_code bpchar(2)) RETURNS int LANGUAGE SQL AS
$$ SELECT id FROM countries c WHERE c."isoCode" = iso_code; $$;

CREATE SEQUENCE drug_records_seq MINVALUE 1;

alter table drug_records
	alter column drug_code type varchar(25),
	add column country_id integer not null default get_countryId_by_isoCode('DK'),
	alter column id SET DEFAULT nextval('drug_records_seq'),
	alter column mt_id drop not null,
	alter column atc_code drop not null,
	alter column atc_code type varchar(10),
	alter column registration_year drop not null;
	
ALTER SEQUENCE drug_records_seq OWNED BY drug_records.id;

ALTER TABLE drugs_to_active_components
	DROP CONSTRAINT fk_drug_to_drugs_record,
	ADD CONSTRAINT fk_drug_to_drugs_record FOREIGN KEY (drug_id) REFERENCES drug_records(id) MATCH FULL ON DELETE CASCADE ON UPDATE CASCADE;

alter table medicines_to_dosages
		drop CONSTRAINT medicine_to_medicine_id,
		add CONSTRAINT medicine_to_medicine_id FOREIGN KEY (medicine_id) REFERENCES drug_records(id) ON DELETE cascade on update cascade;

update drug_records set id = nextval('drug_records_seq');
