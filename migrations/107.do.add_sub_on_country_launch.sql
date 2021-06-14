CREATE TABLE sub_on_launch_records (
  phone VARCHAR,
  country_id INT REFERENCES countries(id) ON DELETE CASCADE ON UPDATE CASCADE,
  type VARCHAR,
  PRIMARY KEY (phone, country_id, type)
)
