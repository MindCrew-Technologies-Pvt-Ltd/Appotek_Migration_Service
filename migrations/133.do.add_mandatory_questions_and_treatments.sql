ALTER TABLE "questions"
    ADD "reminder_type" character varying(255) NULL,
    ADD "is_mandatory" smallint NOT NULL DEFAULT '0';

