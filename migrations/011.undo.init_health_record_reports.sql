ALTER TABLE treatment_records
   DROP COLUMN based_on_health_report_id;

DROP TABLE health_record_report_doctor_referrals;
DROP TABLE heath_report_diagnostic_referrals;
DROP TABLE diagnostic_records;
DROP TABLE health_record_report_to_attachment;
DROP TABLE health_record_report;
DROP TYPE health_record_report_enum;