CREATE OR REPLACE FUNCTION delete_old_user_agreements() RETURNS trigger AS $$
declare
	_country_id int;
	_agreement_type user_agreement_type;
    begin
	    select ua.country_id, ua.agreement_type into _country_id, _agreement_type
	    	from user_agreements ua
	    	where ua.id = new.agreement_id;
	    
		delete from user_to_agreements where user_id=new.user_id and agreement_id in (
			select uta.agreement_id 
				from user_to_agreements uta 
				left join user_agreements ua on (uta.agreement_id = ua.id)
				where uta.user_id=new.user_id and ua.country_id = _country_id and ua.agreement_type = _agreement_type and ua.id <> new.agreement_id
		);
	
		return new;
	
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER user_to_agreements_after_insert AFTER INSERT ON user_to_agreements
    FOR EACH ROW EXECUTE PROCEDURE delete_old_user_agreements();
   
alter table user_to_agreements add column created_at timestamptz not null default CURRENT_TIMESTAMP;

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
		_agreement_type user_agreement_type;
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
		  	where uta.user_id = _user_id and ua.agreement_type = _agreement_type and (ua.country_id = _user_country_id or ua.country_id is null)
		  	order by ua.country_id, ua.id desc
		  	limit 1;
	  	
	  	select (ua.id = _user_agreement_id), ua.id, ua.agreement_type, ua."version", ua.url into status, agreement_id, agreement_type, agreement_version, url
	  		from user_agreements ua
		  	where ua.agreement_type = _agreement_type and (ua.country_id = _user_country_id or ua.country_id is null)
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