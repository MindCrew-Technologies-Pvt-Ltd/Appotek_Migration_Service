DELETE FROM "event" WHERE owner_id IS NULL;
ALTER TABLE public."event" 
    ALTER COLUMN owner_id DROP DEFAULT,
    ALTER COLUMN owner_id SET NOT null;
