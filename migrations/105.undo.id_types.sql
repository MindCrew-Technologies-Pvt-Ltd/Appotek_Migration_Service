alter table users 
	drop CONSTRAINT fk_users_to_country_id_types,
	drop column "id_type",
	drop column "middleName",
	drop column organization,
	drop column department;

drop table country_id_types;

CREATE OR REPLACE FUNCTION get_countryId_by_isoCode(iso_code bpchar(2)) RETURNS int LANGUAGE SQL AS
$$ SELECT id FROM countries c WHERE c."isoCode" = iso_code; $$;