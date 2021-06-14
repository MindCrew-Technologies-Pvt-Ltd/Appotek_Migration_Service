create table country_id_types (
	id serial primary key,
	"country_id" int not null,
	"value" varchar not null,
	regex_validation_rule varchar,
	is_ssn bool not null default false,
	is_visible_value bool not null default true,
	CONSTRAINT country_value_key UNIQUE ("country_id", "value"),
	CONSTRAINT fk_id_types_to_country FOREIGN KEY ("country_id") REFERENCES countries(id) MATCH FULL
);

insert into country_id_types ("country_id", "value", "regex_validation_rule", "is_ssn", "is_visible_value" )
	values
		(239, 'National Insurance number', '/^[A-CEGHJ-PR-TW-Z]{1}[A-CEGHJ-NPR-TW-Z]{1}[0-9]{6}[A-DFM]{0,1}/', true, true),
		(239, 'Drive license', null, false, true),
		(239, 'BankID', null, false, false),
		(237, 'Tax Identification number', '^\d{10}$', true, true),
		(237, 'Drive license', null, false, true),
		(237, 'BankID', null, false, false),
		(240, 'Social Security Number', '/^(?!000|666)[0-8][0-9]{2}-(?!00)[0-9]{2}-(?!0000)[0-9]{4}$/', true, true),
		(63, 'Civil Personal Registration', '/[0-9]{6}-[0-9]{4}/', true, true),
		(220, 'Social Security Number', '/756\.?[0-9]{4}\.?[0-9]{4}\.?[0-9]{2}/', true, true),
		(219, 'Personal identity number', '/^(19|20)?(\d{6}(-|\s)\d{4}|(?!19|20)\d{10})$/', true, true);
		
alter table users 
	add column "id_type" int,
	add column "middleName" varchar,
	add column organization varchar,
	add column department varchar,
	add CONSTRAINT fk_users_to_country_id_types FOREIGN KEY ("id_type") REFERENCES country_id_types(id) MATCH full;

CREATE OR REPLACE FUNCTION get_countryId_by_isoCode(iso_code bpchar(3)) RETURNS int LANGUAGE SQL AS
$$ SELECT id FROM countries c WHERE c."isoCode" = iso_code or c."iso3Code" = iso_code; $$;
