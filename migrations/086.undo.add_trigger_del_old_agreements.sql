drop trigger user_to_agreements_after_insert on user_to_agreements;
drop function delete_old_user_agreements();
alter table user_to_agreements drop column created_at;

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