ALTER TABLE health_record_report_doctor_referrals
  DROP COLUMN share_from_date;

ALTER TABLE health_record_report_doctor_referrals
  DROP COLUMN share_all_records;

ALTER TABLE health_record_report_doctor_referrals
  ADD COLUMN clinic_id UUID REFERENCES clinics (id);
