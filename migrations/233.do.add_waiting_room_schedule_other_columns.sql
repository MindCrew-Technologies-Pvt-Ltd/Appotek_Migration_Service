ALTER TABLE waiting_room_schedules
	ADD COLUMN clinic_consultation boolean DEFAULT false,
	ADD COLUMN clinic_consultation_duration interval(6) DEFAULT null,
    ADD COLUMN clinic_consultation_price numeric(12,2) DEFAULT null,
    ADD COLUMN clinic_consultation_payment_mode int DEFAULT null,
    ADD COLUMN clinic_consultation_clinic_approved boolean DEFAULT false,
    ADD COLUMN home_visit boolean DEFAULT false,
	ADD COLUMN home_visit_duration interval(6) DEFAULT null,
    ADD COLUMN home_visit_price numeric(12,2) DEFAULT null,
    ADD COLUMN home_visit_payment_mode int DEFAULT null,
    ADD COLUMN home_visit_clinic_approved boolean DEFAULT false,
    ADD COLUMN online_consultation boolean DEFAULT false,
	ADD COLUMN online_consultation_duration interval(6) DEFAULT null,
    ADD COLUMN online_consultation_price numeric(12,2) DEFAULT null,
    ADD COLUMN online_consultation_payment_mode int DEFAULT null,
    ADD COLUMN online_consultation_clinic_approved boolean DEFAULT false;

COMMENT ON COLUMN waiting_room_schedules.clinic_consultation IS '0=No, 1=Yes';
COMMENT ON COLUMN waiting_room_schedules.clinic_consultation_payment_mode IS '1=OnlinePay, 2=InClinicPay';
COMMENT ON COLUMN waiting_room_schedules.clinic_consultation_clinic_approved IS '0=No, 1=Yes';
COMMENT ON COLUMN waiting_room_schedules.home_visit IS '0=No, 1=Yes';
COMMENT ON COLUMN waiting_room_schedules.home_visit_payment_mode IS '1=OnlinePay, 2=InClinicPay';
COMMENT ON COLUMN waiting_room_schedules.home_visit_clinic_approved IS '0=No, 1=Yes';
COMMENT ON COLUMN waiting_room_schedules.online_consultation IS '0=No, 1=Yes';
COMMENT ON COLUMN waiting_room_schedules.online_consultation_payment_mode IS '1=OnlinePay, 2=InClinicPay';
COMMENT ON COLUMN waiting_room_schedules.online_consultation_clinic_approved IS '0=No, 1=Yes';
