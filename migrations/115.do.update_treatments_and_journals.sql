ALTER TABLE treatment_records
  add column symptoms varchar;
ALTER TABLE treatment_records
  alter column diagnosis_id drop not null;

ALTER TABLE health_record_report
ADD COLUMN problems_history VARCHAR;

ALTER TABLE health_record_report
ADD COLUMN procedures VARCHAR;

ALTER TABLE health_record_report
ADD COLUMN complication VARCHAR;

ALTER TABLE health_record_report
ADD COLUMN outcomes VARCHAR;
