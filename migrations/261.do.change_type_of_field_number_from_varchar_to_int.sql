UPDATE health_record_report SET "number" = '0' where "number" ilike '1e+%';
UPDATE health_record_report SET "number" = substring("number" from 0 for 17) where length("number") > 17;
ALTER TABLE health_record_report
alter column "number" type bigint using number::bigint;
    