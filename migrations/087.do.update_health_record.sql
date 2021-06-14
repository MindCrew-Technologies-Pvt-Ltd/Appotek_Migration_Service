ALTER TABLE health_record_report
  ALTER COLUMN type TYPE VARCHAR(255);

DROP TYPE IF EXISTS health_record_report_enum;

create type health_record_report_enum as enum ('a', 'i', 'c', 'd', 'p', 'o', 'other');

ALTER TABLE health_record_report
  ALTER COLUMN type TYPE health_record_report_enum USING (type :: health_record_report_enum);

ALTER TABLE health_record_report ADD COLUMN description VARCHAR;
