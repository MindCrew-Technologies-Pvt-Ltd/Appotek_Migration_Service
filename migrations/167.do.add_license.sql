CREATE TABLE "areas_activated"
(
    "clinic_id"     uuid                  NOT NULL,
    "patients"      boolean DEFAULT false NOT NULL,
    "calendar"      boolean DEFAULT false NOT NULL,
    "treatments"    boolean DEFAULT false NOT NULL,
    "waiting_rooms" boolean DEFAULT false NOT NULL,
    "monitoring"    boolean DEFAULT false NOT NULL,
    "ehr"           boolean DEFAULT false NOT NULL,
    "wearables"     boolean DEFAULT false NOT NULL,
    "chat"          boolean DEFAULT false NOT NULL
);

CREATE SEQUENCE requested_areas_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;

CREATE TABLE "areas_requested"
(
    "id"           integer DEFAULT nextval('requested_areas_id_seq') NOT NULL,
    "doctor_id"    uuid                                              NOT NULL,
    "permissions"  text                                              NOT NULL,
    "requested_at" timestamp                                         NOT NULL,
    "clinic_id"    uuid                                              NOT NULL
);

