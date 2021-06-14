CREATE TYPE pharmacies_sub_types AS ENUM ('Community Pharmacy', 'Appliance Pharmacy');
CREATE TYPE pharmacies_status AS ENUM ('Visible');

create table pharmacies (
	id bigserial primary key,
	"internalID" bigint,
	"organisationCode" varchar not null,
	"organisationType" varchar,
	"subType" pharmacies_sub_types,
	"organisationStatus" pharmacies_status,
	"isPimsManaged" bool,
	"isEPSEnabled" bool,
	"organisationName" varchar,
	"countryId" int4 NOT NULL,
	"addressId" int4 NOT NULL,
	"telephoneId" uuid,
	"parentODSCode" varchar,
	"parentName" varchar,
	"email" varchar,
	"website" varchar,
	CONSTRAINT pharmacy_code_key UNIQUE ("organisationCode"),
	CONSTRAINT fk_pharmacy_to_address FOREIGN KEY ("addressId") REFERENCES addresses(id) MATCH FULL ON DELETE SET NULL,
	CONSTRAINT fk_pharmacy_to_country FOREIGN KEY ("countryId") REFERENCES countries(id) MATCH FULL,
	CONSTRAINT fk_pharmacy_to_telephone FOREIGN KEY ("telephoneId") REFERENCES telephones(id) MATCH FULL ON DELETE SET NULL
);