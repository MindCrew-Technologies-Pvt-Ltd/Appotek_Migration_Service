ALTER TABLE user_notifications
    ADD COLUMN created_by_other varchar(150) NULL DEFAULT null;
    