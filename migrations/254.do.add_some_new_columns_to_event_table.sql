ALTER TABLE "event" 
	ADD COLUMN paid_slot bool NOT NULL DEFAULT false,
	ADD COLUMN payment_mode int NOT NULL DEFAULT 0,
	ADD COLUMN clinic_approved bool NOT NULL DEFAULT false;
    