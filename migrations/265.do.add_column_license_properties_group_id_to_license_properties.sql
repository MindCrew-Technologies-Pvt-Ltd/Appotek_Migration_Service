ALTER TABLE license_properties
  ADD COLUMN license_properties_group_id int4,
  ADD COLUMN license_type enum_license_type;