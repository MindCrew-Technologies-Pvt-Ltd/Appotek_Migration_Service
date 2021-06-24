ALTER TABLE license_property_values
  ADD COLUMN currency varchar,
  ADD COLUMN value_type property_value_type;