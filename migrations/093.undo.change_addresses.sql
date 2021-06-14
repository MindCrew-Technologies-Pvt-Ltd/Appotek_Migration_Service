update addresses set postal = '' where postal is null;
update addresses set city = '' where city is null;
update addresses set "buildingNumber" = '' where "buildingNumber" is null;

alter table addresses 
  alter column postal set not null,
  alter column city set not null,
  alter column "buildingNumber" set not null;

