CREATE OR REPLACE FUNCTION after_treatment_templates_folder_moved() RETURNS TRIGGER
AS
$$
BEGIN
    IF new.clinic_id is distinct from old.clinic_id
    THEN
        UPDATE treatment_templates_folders
        SET clinic_id = new.clinic_id
        where treatment_templates_folders.parent_id = old.id;
    end if;

    return new;
end;
$$
    LANGUAGE plpgsql;

CREATE TRIGGER after_treatment_templates_folder_moved_trigger
    AFTER UPDATE
    ON treatment_templates_folders
    FOR EACH ROW
EXECUTE PROCEDURE after_treatment_templates_folder_moved();
