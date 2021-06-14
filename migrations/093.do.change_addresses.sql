alter table addresses 
  alter column postal drop not null,
  alter column city drop not null,
  alter column "buildingNumber" drop not null;

update addresses set postal = null where postal = '';
update addresses set city = null where city = '';
update addresses set "buildingNumber" = null where "buildingNumber" = '';
