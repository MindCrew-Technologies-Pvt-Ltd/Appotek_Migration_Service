CREATE TYPE user_agreement_type AS ENUM ('privacy_policy', 'terms_of_service');

CREATE TABLE public.user_agreements (
	id serial PRIMARY KEY,
	agreement_type user_agreement_type not null,
	country_id int null,
	"version" varchar not null,
	url varchar not null,
	created_at timestamptz not null default CURRENT_TIMESTAMP,
	created_by varchar null,
	CONSTRAINT fk_private_policy_countries FOREIGN KEY (country_id)
      REFERENCES countries (id) MATCH FULL
	  ON UPDATE cascade ON DELETE cascade,
	unique (country_id, agreement_type, "version")
);	

 insert into user_agreements (agreement_type, country_id, "version", url) values ('privacy_policy', null, '0.1', 'http://www.nerdpeople.com/');
 insert into user_agreements (agreement_type, country_id, "version", url) values ('terms_of_service', null, '0.1', 'http://www.nerdpeople.com/');


CREATE TABLE public.user_to_agreements (
	user_id uuid not null,
	agreement_id int not null,
	CONSTRAINT fk_user_agreements_users FOREIGN KEY (user_id)
      REFERENCES users (id) MATCH FULL
	  ON UPDATE cascade ON DELETE cascade,
	CONSTRAINT fk_user_agreements_agreements FOREIGN KEY (agreement_id)
      REFERENCES user_agreements (id) MATCH FULL
	  ON UPDATE cascade ON DELETE cascade,
	unique (user_id, agreement_id)
);

CREATE OR REPLACE FUNCTION public.check_user_agreements(_user_id uuid)
	  RETURNS TABLE
        (
        	status bool,
        	agreement_id int,
        	agreement_type user_agreement_type,
        	agreement_version varchar,
        	url varchar
		)
as $$
	declare 
		_agreement_type varchar;
		_user_agreement_id int;
		_user_country_id int;
begin
    select u."countryId" into _user_country_id
    	from users u
    	where u.id = _user_id;
    
	foreach _agreement_type in array (select enum_range(NULL::user_agreement_type))
	  loop
	  	select ua.id into _user_agreement_id
		  	from user_to_agreements uta 
		  	left join user_agreements ua on (uta.agreement_id = ua.id)
		  	where uta.user_id = _user_id and ua.agreement_type = _agreement_type::user_agreement_type and (ua.country_id = _user_country_id or ua.country_id is null)
		  	order by ua.country_id, ua.id desc
		  	limit 1;
	  	
	  	select (ua.id = _user_agreement_id), ua.id, ua.agreement_type, ua."version", ua.url into status, agreement_id, agreement_type, agreement_version, url
	  		from user_agreements ua
		  	where ua.agreement_type = _agreement_type::user_agreement_type and (ua.country_id = _user_country_id or ua.country_id is null)
		  	order by ua.country_id, ua.id desc
		  	limit 1;
	  	if (status is null) then
	  		status := false;
	  	end if;
	  	if (agreement_type is null) then
		  	agreement_type := _agreement_type;
		end if;
		  
		  return next;
	  end loop;		
END;
$$
  LANGUAGE plpgsql;