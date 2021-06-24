ALTER TABLE clinics 
   ADD COLUMN chat_and_calls_status bool not null default false,
   ADD COLUMN ehr_status bool not null default false;