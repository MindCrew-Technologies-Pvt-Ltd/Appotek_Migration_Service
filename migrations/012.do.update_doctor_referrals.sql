ALTER TABLE health_record_report_doctor_referrals
  DROP COLUMN shared_interval;
ALTER TABLE health_record_report_doctor_referrals
  ADD COLUMN share_from_date TIMESTAMP WITH TIME ZONE;