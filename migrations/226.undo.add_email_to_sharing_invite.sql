DROP TRIGGER after_email_created_trigger ON emails;

DROP FUNCTION after_email_created;

DELETE FROM users_phone_book WHERE "telephoneId" IS NULL;
ALTER TABLE users_phone_book
	DROP CONSTRAINT endpoint_check,
	DROP COLUMN "email",
	ALTER COLUMN "telephoneId" SET NOT NULL;