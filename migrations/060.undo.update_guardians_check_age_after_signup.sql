drop function public.age_check_allow(uuid);

update users set gender=null where gender = 'other';
alter table users alter column gender type varchar;
drop type enum_users_gender;
create type enum_users_gender as enum('male', 'female');
alter table users alter column gender type enum_users_gender using(gender::enum_users_gender);

CREATE OR REPLACE FUNCTION after_user_created() RETURNS TRIGGER
AS
$$
BEGIN
  INSERT INTO user_settings (user_id) VALUES (NEW.id);
  RETURN NEW;
end;
$$
LANGUAGE plpgsql;