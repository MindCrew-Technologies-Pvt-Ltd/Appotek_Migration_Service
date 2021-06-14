ALTER TABLE health_record_report ADD COLUMN verified_by_doctor BOOLEAN DEFAULT true;
ALTER TABLE treatment_records ADD COLUMN verified_by_doctor BOOLEAN DEFAULT true;
ALTER TABLE health_record_referrals ADD COLUMN verified_by_doctor BOOLEAN DEFAULT true;

ALTER table user_notifications
    add column referral_id INT REFERENCES health_record_referrals (id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER table user_notifications
    add column health_record_id INT REFERENCES health_record_report (id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER table user_notifications
    add column treatment_id INT REFERENCES treatment_records (id) ON DELETE CASCADE ON UPDATE CASCADE;
