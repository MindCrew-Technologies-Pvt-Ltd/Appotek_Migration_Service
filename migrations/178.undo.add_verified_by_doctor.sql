ALTER TABLE health_record_report drop COLUMN verified_by_doctor;
ALTER TABLE treatment_records drop COLUMN verified_by_doctor;
ALTER TABLE health_record_referrals drop COLUMN verified_by_doctor;

ALTER table user_notifications
    drop column referral_id;
ALTER table user_notifications
    drop column health_record_id;
ALTER table user_notifications
    drop column treatment_id;
