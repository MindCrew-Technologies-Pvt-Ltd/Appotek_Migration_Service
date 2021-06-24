ALTER TABLE waiting_room 
   ADD COLUMN consultation_duration interval NOT NULL DEFAULT '00:00:00',
   ADD COLUMN price numeric(12, 2) NOT NULL DEFAULT 0,
   ADD COLUMN payment_mode int NOT NULL DEFAULT 0,
   ADD COLUMN day_of_week int NULL DEFAULT null;