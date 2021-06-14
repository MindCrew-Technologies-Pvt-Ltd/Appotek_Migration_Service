ALTER TABLE treatment_records
  DROP column symptoms;


ALTER TABLE health_record_report
DROP COLUMN problems_history;

ALTER TABLE health_record_report
DROP COLUMN procedures;

ALTER TABLE health_record_report
DROP COLUMN complication;

ALTER TABLE health_record_report
DROP COLUMN outcomes;
