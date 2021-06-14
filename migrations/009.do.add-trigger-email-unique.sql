CREATE FUNCTION check_email() RETURNS trigger AS $check_email$
DECLARE
    count_email	INTEGER;
    BEGIN
	    select count(emails.id) into count_email from emails
	    	where emails."userId" = new."userId" and emails.email = new.email and emails.verified = true and emails.id <> new.id;
	    	
	    if count_email > 0 then
            RAISE EXCEPTION 'email % is already in use', new.email;
        end if;

       RETURN NEW;
    END;
$check_email$ LANGUAGE plpgsql;

CREATE TRIGGER check_email BEFORE INSERT OR UPDATE ON emails
    FOR EACH ROW EXECUTE PROCEDURE check_email();