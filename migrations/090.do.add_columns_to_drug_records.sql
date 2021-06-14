alter table drug_records 
	add column name_locale json null default '{}'::json,
	add column type_locale json null default '{}'::json,
	add column strength_locale json null default '{}'::json,
	add column package_locale json null default '{}'::json,
	add column leaflet_locale json null default '{}'::json;
