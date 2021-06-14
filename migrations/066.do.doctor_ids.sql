create table doctor_ids (
	id bigserial primary key,
	"userId" uuid not null,
	"doctorId" varchar not null,
	CONSTRAINT user_id_key UNIQUE ("userId"),
	CONSTRAINT doctor_id_key UNIQUE ("doctorId"),
	CONSTRAINT fk_doctor_id_to_user FOREIGN KEY ("userId") REFERENCES users(id) MATCH FULL ON DELETE cascade
);

CREATE OR REPLACE FUNCTION check_doctor_role() RETURNS trigger AS $func$
DECLARE
		_user_role varchar;
    begin
	    select r."name" into _user_role 
	    	from users u
	    	left join roles r on (u."roleId" = r.id)
	    	where u.id = new."userId";
		
	    if (_user_role <> 'doctor') then 
				RAISE EXCEPTION 'Role must be a Doctor';
	    end if;
	   
	    return new;
    END;
$func$ LANGUAGE plpgsql;

CREATE TRIGGER check_doctor_role BEFORE INSERT OR UPDATE ON doctor_ids
    FOR EACH ROW EXECUTE PROCEDURE check_doctor_role();