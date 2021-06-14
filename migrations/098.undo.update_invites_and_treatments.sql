ALTER TABLE invites DROP COLUMN address_id;
ALTER TABLE treatment_records ALTER COLUMN title TYPE VARCHAR(64);


DROP TABLE symptoms_to_telephones;
