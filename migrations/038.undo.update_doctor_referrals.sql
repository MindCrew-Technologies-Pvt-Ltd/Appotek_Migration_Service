ALTER TABLE health_record_report_doctor_referrals
  ADD COLUMN share_from_date TIMESTAMP;

ALTER TABLE health_record_report_doctor_referrals
  ADD COLUMN share_all_records BOOLEAN;

ALTER TABLE health_record_report_doctor_referrals
  DROP COLUMN clinic_id;
