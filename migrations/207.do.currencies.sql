CREATE TABLE currencies (
	id serial NOT NULL PRIMARY KEY,
	code varchar(3) NOT NULL UNIQUE,
	"name" varchar NOT NULL,
	symbol varchar NULL
);

CREATE TABLE currency_to_country (
	country_id int,
	currency_id int,
	CONSTRAINT currency_ro_country_pkey PRIMARY KEY (country_id, currency_id),
	CONSTRAINT country_id_to_countries FOREIGN KEY (country_id) REFERENCES countries(id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT currency_id_to_currencies FOREIGN KEY (currency_id) REFERENCES currencies(id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE
);