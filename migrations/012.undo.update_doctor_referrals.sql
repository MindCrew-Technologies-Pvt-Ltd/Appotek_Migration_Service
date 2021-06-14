ALTER TABLE health_record_report_doctor_referrals
  ADD COLUMN shared_interval INTERVAL;
ALTER TABLE health_record_report_doctor_referrals
  DROP COLUMN share_from_date;