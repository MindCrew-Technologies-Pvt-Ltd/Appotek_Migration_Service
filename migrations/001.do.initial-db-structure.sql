--initial for central
CREATE TABLE "SequelizeData" (
	"name" varchar(255) NOT NULL,
	CONSTRAINT "SequelizeData_pkey" PRIMARY KEY (name)
);

CREATE TABLE "SequelizeMeta" (
	"name" varchar(255) NOT NULL,
	CONSTRAINT "SequelizeMeta_pkey" PRIMARY KEY (name)
);

CREATE TABLE countries (
	id serial NOT NULL,
	"name" text NOT NULL,
	"isoCode" bpchar(2) NOT NULL,
	"iso3Code" bpchar(3) NOT NULL,
	"phoneCodes" text[] NOT NULL,
	capital text NULL,
	region text NULL,
	launched bool NOT NULL DEFAULT false,
	"deletedAt" timestamptz NULL,
	"createdAt" timestamptz NOT NULL DEFAULT now(),
	"updatedAt" timestamptz NOT NULL DEFAULT now(),
	"version" int4 NOT NULL DEFAULT 0,
	CONSTRAINT "countries_iso3Code_key" UNIQUE ("iso3Code"),
	CONSTRAINT "countries_isoCode_key" UNIQUE ("isoCode"),
	CONSTRAINT countries_name_key UNIQUE (name),
	CONSTRAINT countries_pkey PRIMARY KEY (id)
);

CREATE TABLE addresses (
	id serial NOT NULL,
	"countryId" int4 NULL,
	postal text NOT NULL,
	state text NULL,
	city text NOT NULL,
	street text NOT NULL,
	"buildingNumber" text NOT NULL,
	"buildingName" text NULL,
	apartment text NULL,
	latitude float8 NOT NULL,
	longitude float8 NOT NULL,
	"deletedAt" timestamptz NULL,
	"createdAt" timestamptz NOT NULL DEFAULT now(),
	"updatedAt" timestamptz NOT NULL DEFAULT now(),
	"version" int4 NOT NULL DEFAULT 0,
 	CONSTRAINT addresses_pkey PRIMARY KEY (id),
  CONSTRAINT fk_addresses_to_country FOREIGN KEY ("countryId")
    REFERENCES "countries" (id) MATCH FULL
);

CREATE TABLE telephones (
	id uuid NOT NULL,
	"countryId" int4 NULL,
	telephone text NOT NULL,
	verified bool NOT NULL DEFAULT false,
	"deletedAt" timestamptz NULL,
	"createdAt" timestamptz NOT NULL DEFAULT now(),
	"updatedAt" timestamptz NOT NULL DEFAULT now(),
	"version" int4 NOT NULL DEFAULT 0,
	"countryCode" varchar(255) NULL,
	"number" varchar(255) NULL,
	CONSTRAINT telephones_pkey PRIMARY KEY (id),
  CONSTRAINT fk_telephone_to_country FOREIGN KEY ("countryId")
    REFERENCES "countries" (id) MATCH FULL
);
CREATE UNIQUE INDEX "telephone-1-unique" ON telephones USING btree (telephone);

CREATE TABLE roles (
	id serial NOT NULL,
	"name" text NOT NULL,
	"deletedAt" timestamptz NULL,
	"createdAt" timestamptz NOT NULL DEFAULT now(),
	"updatedAt" timestamptz NOT NULL DEFAULT now(),
	"version" int4 NOT NULL DEFAULT 0,
	CONSTRAINT roles_name_key UNIQUE (name),
	CONSTRAINT roles_pkey PRIMARY KEY (id)
);

CREATE TYPE enum_users_gender AS ENUM ('male', 'female');

CREATE TABLE users (
	id uuid NOT NULL,
	"roleId" int4 NOT NULL,
	"countryId" int4 NOT NULL,
	"firstName" text NOT NULL,
	"lastName" text NOT NULL,
	gender enum_users_gender NULL,
	"addressId" int4 NULL,
	dob date NULL,
	photo text NULL,
	"appIconBadge" int4 NOT NULL DEFAULT 0,
	"deletedAt" timestamptz NULL,
	"createdAt" timestamptz NOT NULL DEFAULT now(),
	"updatedAt" timestamptz NOT NULL DEFAULT now(),
	"version" int4 NOT NULL DEFAULT 0,
	"telephoneId" uuid NOT NULL,
	"suspendedAt" timestamptz NULL,
	last_heartbeat_at timestamptz NULL,
	is_online bool NULL DEFAULT false,
	CONSTRAINT users_pkey PRIMARY KEY (id),
  CONSTRAINT fk_users_to_role FOREIGN KEY ("roleId")
    REFERENCES "roles" (id) MATCH FULL,
  CONSTRAINT fk_users_to_country FOREIGN KEY ("countryId")
    REFERENCES "countries" (id) MATCH FULL,
  CONSTRAINT fk_users_to_address FOREIGN KEY ("addressId")
    REFERENCES "addresses" (id) MATCH FULL ON DELETE SET NULL,
  CONSTRAINT fk_users_to_telephone FOREIGN KEY ("telephoneId")
    REFERENCES "telephones" (id) MATCH FULL ON DELETE SET NULL
);
CREATE UNIQUE INDEX "role-1-telephone-1-deletedAt-1-unique" ON users USING btree ("telephoneId", "roleId") WHERE ("deletedAt" IS NULL);

CREATE TABLE emails (
	id serial NOT NULL,
	"userId" uuid NOT NULL,
	email text NOT NULL,
	"verificationCode" bpchar(6) NOT NULL,
	verified bool NOT NULL DEFAULT false,
	"deletedAt" timestamptz NULL,
	"createdAt" timestamptz NOT NULL DEFAULT now(),
	"updatedAt" timestamptz NOT NULL DEFAULT now(),
	"version" int4 NOT NULL DEFAULT 0,
	CONSTRAINT emails_pkey PRIMARY KEY (id),
  CONSTRAINT fk_email_to_user FOREIGN KEY ("userId")
    REFERENCES "users" (id) MATCH FULL
    ON UPDATE NO ACTION ON DELETE CASCADE
);

CREATE TABLE recovery_questions (
	id serial NOT NULL,
	title varchar(255) NOT NULL,
	"deletedAt" timestamptz NULL,
	"createdAt" timestamptz NOT NULL DEFAULT now(),
	"updatedAt" timestamptz NOT NULL DEFAULT now(),
	"version" int4 NOT NULL DEFAULT 0,
	CONSTRAINT recovery_questions_pkey PRIMARY KEY (id)
);

CREATE TABLE user_to_recovery_questions (
	id serial NOT NULL,
	"userId" uuid NOT NULL,
	"questionId" int4 NOT NULL,
	answer text NOT NULL,
	"deletedAt" timestamptz NULL,
	"createdAt" timestamptz NOT NULL DEFAULT now(),
	"updatedAt" timestamptz NOT NULL DEFAULT now(),
	"version" int4 NOT NULL DEFAULT 0,
	CONSTRAINT user_to_recovery_questions_pkey PRIMARY KEY (id),
  CONSTRAINT fk_user_answer_to_user FOREIGN KEY ("userId")
    REFERENCES "users" (id) MATCH FULL
    ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT fk_user_answer_to_question FOREIGN KEY ("questionId")
    REFERENCES "recovery_questions" (id) MATCH FULL
);
CREATE UNIQUE INDEX "userId-1-unique" ON public.user_to_recovery_questions USING btree ("userId", "deletedAt");

CREATE TYPE attachment_visibility_levels AS ENUM ('public', 'private', 'restricted');

CREATE TABLE attachments (
	id uuid NOT NULL,
	storage_key varchar(255) NOT NULL,
	owner_id uuid NOT NULL,
	"type" varchar(32) NOT NULL,
	subtype varchar(32) NOT NULL,
	visibility attachment_visibility_levels NOT NULL DEFAULT 'public'::attachment_visibility_levels,
	source_url varchar(255) NOT NULL,
	uploaded_at timestamp NULL DEFAULT now(),
	CONSTRAINT attachments_pkey PRIMARY KEY (id),
	CONSTRAINT fk_attachment_owner_to_user FOREIGN KEY (owner_id) REFERENCES users(id) MATCH FULL
);

CREATE TABLE allergy_categories (
	id serial NOT NULL,
	"name" varchar(255) NOT NULL,
	"deletedAt" timestamptz NULL,
	"createdAt" timestamptz NOT NULL DEFAULT now(),
	"updatedAt" timestamptz NOT NULL DEFAULT now(),
	"version" int4 NOT NULL DEFAULT 0,
	CONSTRAINT allergy_categories_pkey PRIMARY KEY (id)
);

CREATE TABLE allergies (
	id serial NOT NULL,
	"allergy_categoryId" int4 NOT NULL,
	"name" varchar(255) NOT NULL,
	"deletedAt" timestamptz NULL,
	"createdAt" timestamptz NOT NULL DEFAULT now(),
	"updatedAt" timestamptz NOT NULL DEFAULT now(),
	"version" int4 NOT NULL DEFAULT 0,
	CONSTRAINT allergies_pkey PRIMARY KEY (id),
  CONSTRAINT fk_allergies_to_categories FOREIGN KEY ("allergy_categoryId")
    REFERENCES "allergy_categories" (id) MATCH FULL
);

CREATE TABLE health (
	id serial NOT NULL,
	"userId" uuid NOT NULL,
	height float8 NULL,
	weight float8 NULL,
	systolic float8 NULL,
	diastolic float8 NULL,
	temperature float8 NULL,
	"allergyId" int4 NULL,
	illness varchar(255) NULL DEFAULT NULL::character varying,
	"date" timestamptz NOT NULL,
	"deletedAt" timestamptz NULL,
	"createdAt" timestamptz NOT NULL DEFAULT now(),
	"updatedAt" timestamptz NOT NULL DEFAULT now(),
	"version" int4 NOT NULL DEFAULT 0,
	deleted bool NULL DEFAULT false,
	pregnancy timestamptz NULL,
	CONSTRAINT healthes_pkey PRIMARY KEY (id),
  CONSTRAINT fk_health_to_users FOREIGN KEY ("userId")
    REFERENCES "users" (id) MATCH FULL
    ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT fk_health_allergyId FOREIGN KEY ("allergyId")
    REFERENCES "allergies" (id) MATCH FULL
);

CREATE TYPE enum_calls_status AS ENUM ('pending', 'ignored', 'cancelled', 'in progress', 'ended');
CREATE TYPE enum_calls_call_type AS ENUM ('video', 'audio', 'mixed');

CREATE TABLE calls (
	id uuid NOT NULL,
	caller jsonb NOT NULL,
	participants jsonb NOT NULL,
	call_type enum_calls_call_type NOT NULL,
	"start" timestamptz NOT NULL,
	"end" timestamptz NULL,
	duration int8 NULL,
	status enum_calls_status NOT NULL,
	"createdAt" timestamptz NOT NULL,
	"updatedAt" timestamptz NOT NULL,
	CONSTRAINT calls_pkey PRIMARY KEY (id)
);

CREATE TABLE "clinic-types" (
	id serial NOT NULL,
	"name" text NOT NULL,
	"deletedAt" timestamptz NULL,
	"createdAt" timestamptz NOT NULL DEFAULT now(),
	"updatedAt" timestamptz NOT NULL DEFAULT now(),
	"version" int4 NOT NULL DEFAULT 0,
	CONSTRAINT "clinic-types_name_key" UNIQUE (name),
	CONSTRAINT "clinic-types_pkey" PRIMARY KEY (id)
);

CREATE TABLE clinics (
	id uuid NOT NULL,
	"name" varchar(255) NOT NULL,
	"countryId" int4 NOT NULL,
	"addressId" int4 NOT NULL,
	"telephoneId" uuid NOT NULL,
	"clinicTypeId" int4 NOT NULL,
	verified bool NOT NULL DEFAULT false,
	"deletedAt" timestamptz NULL,
	"createdAt" timestamptz NOT NULL DEFAULT now(),
	"updatedAt" timestamptz NOT NULL DEFAULT now(),
	"version" int4 NOT NULL DEFAULT 0,
	CONSTRAINT clinics_pkey PRIMARY KEY (id),
  CONSTRAINT fk_clinics_to_country FOREIGN KEY ("countryId")
    REFERENCES "countries" (id) MATCH FULL,
  CONSTRAINT fk_clinics_to_address FOREIGN KEY ("addressId")
    REFERENCES "addresses" (id) MATCH FULL ON DELETE SET NULL,
  CONSTRAINT fk_clinics_to_telephone FOREIGN KEY ("telephoneId")
    REFERENCES "telephones" (id) MATCH FULL ON DELETE SET NULL,
  CONSTRAINT fk_clinics_to_type FOREIGN KEY ("clinicTypeId")
    REFERENCES "clinic-types" (id) MATCH FULL
);

CREATE TABLE "clinic-emails" (
	id serial NOT NULL,
	"clinicId" uuid NOT NULL,
	email text NOT NULL,
	"deletedAt" timestamptz NULL,
	"createdAt" timestamptz NOT NULL DEFAULT now(),
	"updatedAt" timestamptz NOT NULL DEFAULT now(),
	"version" int4 NOT NULL DEFAULT 0,
	CONSTRAINT "clinic-emails_pkey" PRIMARY KEY (id),
  CONSTRAINT fk_clinic_email_to_clinic FOREIGN KEY ("clinicId")
    REFERENCES "clinics" (id) MATCH FULL
    ON UPDATE NO ACTION ON DELETE CASCADE
);

CREATE TABLE "clinics-to-users" (
	id uuid NOT NULL,
	"clinicId" uuid NOT NULL,
	"userId" uuid NOT NULL,
	verified bool NOT NULL DEFAULT false,
	"deletedAt" timestamptz NULL,
	"createdAt" timestamptz NOT NULL DEFAULT now(),
	"updatedAt" timestamptz NOT NULL DEFAULT now(),
	"version" int4 NOT NULL DEFAULT 0,
	CONSTRAINT "clinics-to-users_pkey" PRIMARY KEY (id),
  CONSTRAINT fk_clinic_user_to_user FOREIGN KEY ("userId")
    REFERENCES "users" (id) MATCH FULL
    ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT fk_clinic_user_to_clinic FOREIGN KEY ("clinicId")
    REFERENCES "clinics" (id) MATCH FULL
    ON UPDATE NO ACTION ON DELETE CASCADE
);
CREATE UNIQUE INDEX "clinic-1-user-1-unique" ON "clinics-to-users" USING btree ("clinicId", "userId") WHERE ("deletedAt" IS NULL);

CREATE TABLE credentials (
	id uuid NOT NULL,
	"userId" uuid NOT NULL,
	"passwordHash" text NOT NULL,
	"deletedAt" timestamptz NULL,
	"createdAt" timestamptz NOT NULL DEFAULT now(),
	"updatedAt" timestamptz NOT NULL DEFAULT now(),
	"version" int4 NOT NULL DEFAULT 0,
	CONSTRAINT credentials_pkey PRIMARY KEY (id),
	CONSTRAINT "credentials_userId_key" UNIQUE ("userId"),
  CONSTRAINT fk_credentials_to_user FOREIGN KEY ("userId")
    REFERENCES "users" (id) MATCH FULL
    ON UPDATE NO ACTION ON DELETE CASCADE
);

CREATE TYPE apps AS ENUM ('patient', 'doctor', 'admin');

CREATE TABLE devices (
	id varchar(255) NOT NULL,
	user_id uuid NOT NULL,
	app apps NOT NULL,
	is_active bool NOT NULL DEFAULT true,
	fcm_token varchar(255) NOT NULL DEFAULT ''::character varying,
	voip_token varchar(255) NULL DEFAULT ''::character varying,
	last_active timestamp NULL DEFAULT now(),
	created_at timestamp NULL DEFAULT now(),
	updated_at timestamp NULL DEFAULT now(),
	CONSTRAINT devices_pkey PRIMARY KEY (id, user_id, app),
	CONSTRAINT fk_device_user_to_user FOREIGN KEY (user_id) REFERENCES users(id) MATCH FULL ON DELETE CASCADE
);

CREATE OR REPLACE FUNCTION check_and_deactivate_devices() RETURNS trigger
  AS $function$
BEGIN
  IF NEW.is_active IS TRUE AND NEW.voip_token != ''
  THEN
    UPDATE devices
    SET is_active = FALSE
    WHERE (id = NEW.id
      AND user_id = NEW.user_id
      AND app = NEW.app) IS FALSE
      AND voip_token = NEW.voip_token;
  ELSE
  END IF;
  RETURN NEW;
END;
$function$
  LANGUAGE plpgsql;

create trigger check_and_deactivate_devices_before_devices_insert_and_update 
  before 
  insert or update
  on
    devices for each row execute procedure check_and_deactivate_devices();

CREATE TABLE medical_icd11 (
	id uuid NOT NULL,
	"releaseURI" text NOT NULL,
	code varchar(255) NULL,
	title text NOT NULL,
	"type" varchar(255) NOT NULL,
	parent uuid NULL,
	definition text NULL,
	inclusions json NULL,
	exclusions json NULL,
	"indexTerms" json NULL,
	"version" int4 NULL DEFAULT 0,
	CONSTRAINT medical_icd11_pkey PRIMARY KEY (id)
);

CREATE TABLE my_day_tasks (
	id serial NOT NULL,
	priority int4 NOT NULL DEFAULT 1,
	"read" bool NOT NULL DEFAULT false,
	eternal bool NOT NULL DEFAULT false,
	pending bool NOT NULL DEFAULT true,
	category varchar(256) NULL DEFAULT NULL::character varying,
	title varchar(256) NOT NULL,
	message varchar(256) NULL DEFAULT NULL::character varying,
	owner_id uuid NOT NULL,
	updated_at timestamptz NULL DEFAULT now(),
	created_at timestamptz NULL DEFAULT now(),
	CONSTRAINT my_day_tasks_pkey PRIMARY KEY (id),
	CONSTRAINT fk_my_day_task_to_user FOREIGN KEY (owner_id) REFERENCES users(id) MATCH FULL ON DELETE CASCADE
);

CREATE TABLE "registrationSessions" (
	id uuid NOT NULL,
	"roleId" int4 NOT NULL,
	"countryId" int4 NOT NULL,
	"telephoneId" uuid NOT NULL,
	code int4 NOT NULL,
	"deletedAt" timestamptz NULL,
	"createdAt" timestamptz NOT NULL DEFAULT now(),
	"updatedAt" timestamptz NOT NULL DEFAULT now(),
	"version" int4 NOT NULL DEFAULT 0,
	"lastNotifiedAt" timestamptz NULL,
	CONSTRAINT "registrationSessions_pkey" PRIMARY KEY (id),
  CONSTRAINT fk_registrationSessions_to_role FOREIGN KEY ("roleId")
    REFERENCES "roles" (id) MATCH FULL,
  CONSTRAINT fk_registrationSessions_to_country FOREIGN KEY ("countryId")
    REFERENCES "countries" (id) MATCH FULL,
  CONSTRAINT fk_registrationSessions_to_telephone FOREIGN KEY ("telephoneId")
    REFERENCES "telephones" (id) MATCH FULL ON DELETE SET NULL
);

CREATE TABLE securities (
	id uuid NOT NULL,
	"userId" uuid NOT NULL,
	"askBiometricSecurity" bool NOT NULL DEFAULT true,
	"askSecurityOnAppOpen" bool NOT NULL DEFAULT true,
	"deletedAt" timestamptz NULL,
	"createdAt" timestamptz NOT NULL DEFAULT now(),
	"updatedAt" timestamptz NOT NULL DEFAULT now(),
	"version" int4 NOT NULL DEFAULT 0,
	share_medical_history bool NOT NULL DEFAULT true,
	CONSTRAINT securities_pkey PRIMARY KEY (id),
  CONSTRAINT fk_sequrities_to_user FOREIGN KEY ("userId")
    REFERENCES "users" (id) MATCH FULL
    ON UPDATE NO ACTION ON DELETE CASCADE

);
CREATE UNIQUE INDEX "securities-userId-unique" ON securities USING btree ("userId");

CREATE TABLE tokens (
	id uuid NOT NULL,
	"userId" uuid NOT NULL,
	"access" text NOT NULL,
	"refresh" text NOT NULL,
	"deletedAt" timestamptz NULL,
	"createdAt" timestamptz NOT NULL DEFAULT now(),
	"updatedAt" timestamptz NOT NULL DEFAULT now(),
	"version" int4 NOT NULL DEFAULT 0,
	CONSTRAINT tokens_access_key UNIQUE (access),
	CONSTRAINT tokens_pkey PRIMARY KEY (id),
	CONSTRAINT tokens_refresh_key UNIQUE (refresh),
  CONSTRAINT fk_tokens_to_user FOREIGN KEY ("userId")
    REFERENCES "users" (id) MATCH FULL
    ON UPDATE NO ACTION ON DELETE CASCADE
);

--initial for contacts
CREATE TABLE contacts
(
  user_id     UUID NOT NULL,
  contact_id  UUID NOT NULL,
  from_device VARCHAR(255)  DEFAULT NULL,
  state       INT  NOT NULL DEFAULT 0,
  state_data  JSONB,
  PRIMARY KEY (user_id, contact_id),
  CHECK (user_id != contact_id),
  CONSTRAINT fk_contact_user FOREIGN KEY (user_id)
    REFERENCES "users" (id) MATCH FULL
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_contact_to_user FOREIGN KEY (contact_id)
    REFERENCES "users" (id) MATCH FULL
    ON UPDATE NO ACTION ON DELETE SET NULL
);

CREATE TABLE qr_codes
(
  id          SERIAL PRIMARY KEY,
  literal     VARCHAR                  UNIQUE DEFAULT md5(random()::text),
  created_at  TIMESTAMP WITH TIME ZONE DEFAULT current_timestamp,
  created_by  UUID NOT NULL,
  valid_until TIMESTAMP WITH TIME ZONE DEFAULT current_timestamp + INTERVAL '15 minutes',
  CONSTRAINT fk_created_by_to_user FOREIGN KEY (created_by)
    REFERENCES "users" (id) MATCH FULL
    ON UPDATE CASCADE ON DELETE CASCADE
);

--initial for chat / messenger
CREATE TABLE user_chat_settings
(
  id               SERIAL PRIMARY KEY,
  user_id          UUID     NOT NULL UNIQUE,
  unavailable_from TIME     NOT NULL,
  unavailable_to   TIME     NOT NULL,
  tz_offset        INTERVAL NOT NULL,
  is_active        BOOLEAN DEFAULT TRUE,
  CONSTRAINT user_chat_settings_to_user FOREIGN KEY (user_id)
    REFERENCES users (id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TYPE chat_room_types AS ENUM ('dialog', 'group');

CREATE TABLE chat_room
(
  id         BIGSERIAL PRIMARY KEY,
  type       chat_room_types                                                                NOT NULL,
  title       VARCHAR(128),
  description VARCHAR,
  photo       VARCHAR,
  last_read_message_id  BIGINT,
  created_by UUID,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT date_trunc('milliseconds', CURRENT_TIMESTAMP) NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT date_trunc('milliseconds', CURRENT_TIMESTAMP) NOT NULL,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT chat_room_creator_to_user FOREIGN KEY (created_by)
    REFERENCES users (id)
    ON DELETE SET NULL
);

CREATE TYPE chat_message_type AS ENUM ('text', 'file_attachment', 'location_attachment', 'contact_attachment');

CREATE TABLE chat_message
(
  id                   BIGSERIAL PRIMARY KEY,
  type                 chat_message_type                                                              NOT NULL,
  room_id              BIGINT                                                                         NOT NULL,
  text                 VARCHAR(256),
  location             POINT,
  shared_contact_id    UUID,
  shared_attachment_id UUID,
  correlation_id       VARCHAR,
  loc_title            VARCHAR,
  loc_description      VARCHAR,
  created_by           UUID,
  created_at           TIMESTAMP WITH TIME ZONE DEFAULT date_trunc('milliseconds', CURRENT_TIMESTAMP) NOT NULL,
  updated_at           TIMESTAMP WITH TIME ZONE DEFAULT date_trunc('milliseconds', CURRENT_TIMESTAMP) NOT NULL,
  UNIQUE(id, room_id),
  deleted_at           TIMESTAMP WITH TIME ZONE,
  CONSTRAINT chat_room_creator_to_user FOREIGN KEY (created_by)
    REFERENCES users (id)
    ON DELETE SET NULL,
  CONSTRAINT char_message_room_to_chat_room FOREIGN KEY (room_id)
    REFERENCES chat_room (id)
    ON DELETE CASCADE,
  CONSTRAINT shared_contact_to_user FOREIGN KEY (shared_contact_id)
    REFERENCES users (id)
    ON DELETE SET NULL,
  CONSTRAINT shared_attachment_to_attachment FOREIGN KEY (shared_attachment_id)
    REFERENCES attachments (id)
    ON DELETE CASCADE
);

ALTER TABLE chat_room ADD
  CONSTRAINT last_read_message_to_chat_room_messages FOREIGN KEY (id, last_read_message_id)
      REFERENCES chat_message (room_id, id)
      ON DELETE SET null;

CREATE TYPE chat_participants_status AS ENUM ('invited','approved', 'rejected', 'kicked', 'leaved');

CREATE TABLE chat_participants
(
  room_id    BIGINT                                                                         NOT NULL,
  user_id    UUID                                                                           NOT NULL,
  status     chat_participants_status,
  last_read_message_id  BIGINT,
  created_by UUID,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT date_trunc('milliseconds', CURRENT_TIMESTAMP) NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT date_trunc('milliseconds', CURRENT_TIMESTAMP) NOT NULL,
  PRIMARY KEY(room_id,user_id),
  CONSTRAINT chat_participant_to_users FOREIGN KEY (user_id)
    REFERENCES users (id) MATCH FULL
    ON DELETE CASCADE,
  CONSTRAINT chat_participant_initiator_to_users FOREIGN KEY (user_id)
    REFERENCES users (id)
    ON DELETE CASCADE,
  CONSTRAINT chat_room_to_rooms FOREIGN KEY (room_id)
    REFERENCES chat_room (id)
    ON DELETE CASCADE,
  CONSTRAINT last_participant_read_message_to_chat_room_messages FOREIGN KEY (room_id, last_read_message_id)
        REFERENCES chat_message (room_id, id)
        ON DELETE SET NULL
);

CREATE OR REPLACE FUNCTION add_creator_as_participant() RETURNS TRIGGER AS
$BODY$
BEGIN
  INSERT INTO chat_participants(room_id, user_id, status)
  VALUES (NEW.id, NEW.created_by, 'approved');
  RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql;

CREATE TRIGGER add_creator_as_participant_t
  AFTER INSERT
  ON chat_room
  FOR EACH ROW
EXECUTE PROCEDURE add_creator_as_participant();

CREATE OR REPLACE FUNCTION check_room_participants_count() RETURNS TRIGGER AS
$BODY$
BEGIN
  CASE WHEN ((SELECT "type" = 'dialog' FROM chat_room WHERE id = NEW.room_id))
    THEN
      CASE WHEN (SELECT count(*) >= 2 FROM chat_participants WHERE room_id = NEW.room_id)
        THEN RAISE EXCEPTION 'dialog could not have more that 2 participants';
        ELSE
        END CASE;
    ELSE
    END CASE;
  RETURN NEW;
END
$BODY$
  LANGUAGE plpgsql;

CREATE TRIGGER check_room_participants_count_t
  BEFORE INSERT
  ON chat_participants
  FOR EACH ROW
EXECUTE PROCEDURE check_room_participants_count();

CREATE OR REPLACE FUNCTION validate_create_chat_message() RETURNS TRIGGER AS
$BODY$
BEGIN
  CASE WHEN (SELECT exists(SELECT * FROM chat_room WHERE id = NEW.room_id AND chat_room.deleted_at IS NULL))
    THEN
    ELSE RAISE EXCEPTION 'forbidden to post messages in deleted or not existing room';
    END CASE;
  CASE WHEN (
    SELECT (
               (NEW.type = 'text'
                 AND NEW.text IS NOT NULL
                 AND NEW.location IS NULL
                 AND NEW.shared_contact_id IS NULL
                 AND NEW.shared_attachment_id IS NULL)
               OR (
                   NEW.type = 'location_attachment'
                   AND NEW.text IS NULL
                   AND NEW.location IS NOT NULL
                   AND NEW.shared_contact_id IS NULL
                   AND NEW.shared_attachment_id IS NULL
                 )
               OR (
                   NEW.type = 'contact_attachment'
                   AND NEW.text IS NULL
                   AND NEW.location IS NULL
                   AND NEW.shared_contact_id IS NOT NULL
                   AND NEW.shared_attachment_id IS NULL
                 )
               OR (
                   NEW.type = 'file_attachment'
                   AND NEW.text IS NULL
                   AND NEW.location IS NULL
                   AND NEW.shared_contact_id IS NULL
                   AND NEW.shared_attachment_id IS NOT NULL
                 )
             )
  )
    THEN
    ELSE RAISE EXCEPTION 'mixed message payload is not supported, please specify 1';
    END CASE;

  CASE WHEN (SELECT exists(
                        (
                        SELECT *
                         FROM chat_participants
                         WHERE chat_participants.room_id = new.room_id
                           AND chat_participants.user_id = new.created_by
                           AND chat_participants.status = 'approved')
                      )
  )
    THEN
    ELSE RAISE EXCEPTION 'You can''t post messaged while your participation in room is not approved';
    END CASE;
  UPDATE chat_room SET updated_at = date_trunc('milliseconds', CURRENT_TIMESTAMP) WHERE id = NEW.room_id;
  RETURN NEW;
END
$BODY$
  LANGUAGE plpgsql;

CREATE TRIGGER before_message_created_t
  BEFORE INSERT
  ON chat_message
  FOR EACH ROW
EXECUTE PROCEDURE validate_create_chat_message();

CREATE OR REPLACE FUNCTION inject_updated_at() RETURNS TRIGGER AS
$BODY$
BEGIN
  NEW.updated_at = date_trunc('milliseconds', CURRENT_TIMESTAMP);
  RETURN NEW;
end;
$BODY$
  LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION before_chat_participation_update() RETURNS TRIGGER AS
$BODY$
BEGIN
  CASE WHEN (OLD.status != NEW.status)
    THEN
      IF (NEW.status IN ('approved', 'rejected')) THEN
        IF (old.status NOT IN ('invited', 'leaved')) THEN
          RAISE EXCEPTION 'You can approve/reject participation only if you are invited';
        ELSE
        END IF;
      END IF;
      IF (NEW.status = 'invited')
      THEN
        IF (OLD.status = 'approved') THEN
          RAISE EXCEPTION 'participant has already approved invite.';
        END IF;
      END IF;
      ELSE
    END CASE;

    IF (NEW.last_read_message_id != OLD.last_read_message_id)
      THEN
        IF (
            (SELECT m_old.created_at FROM chat_message m_old WHERE m_old.id = OLD.last_read_message_id)
            >
            (SELECT m_new.created_at FROM chat_message m_new WHERE m_new.id = NEW.last_read_message_id)
          )
        THEN
          NEW.last_read_message_id = OLD.last_read_message_id;
        ELSE
        END IF;
      ELSE
      END IF;

  IF (NEW.updated_at = OLD.updated_at) THEN NEW.updated_at = date_trunc('milliseconds', CURRENT_TIMESTAMP); END IF;

  UPDATE chat_room SET updated_at = date_trunc('milliseconds', CURRENT_TIMESTAMP) WHERE id = NEW.room_id;

  RETURN NEW;
end;
$BODY$
  LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION before_chat_message_update() RETURNS TRIGGER AS
$BODY$
BEGIN
  IF (NEW.updated_at = OLD.updated_at) THEN NEW.updated_at = date_trunc('milliseconds', CURRENT_TIMESTAMP); END IF;

  UPDATE chat_room SET updated_at = date_trunc('milliseconds', CURRENT_TIMESTAMP) WHERE id = NEW.room_id;

  RETURN NEW;
end;
$BODY$
  LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION validate_last_read_message_before_chat_room_update() RETURNS TRIGGER AS
$BODY$
BEGIN
  IF (NEW.last_read_message_id != OLD.last_read_message_id)
  THEN
    IF (
        (SELECT m_old.created_at FROM chat_message m_old WHERE m_old.id = OLD.last_read_message_id)
        >
        (SELECT m_new.created_at FROM chat_message m_new WHERE m_new.id = NEW.last_read_message_id)
      )
    THEN
      NEW.last_read_message_id = OLD.last_read_message_id;
    ELSE
    END IF;
  ELSE
  END IF;

  RETURN NEW;
end;
$BODY$
  LANGUAGE plpgsql;

CREATE TRIGGER before_chat_participation_update
  BEFORE UPDATE
  ON chat_participants
  FOR EACH ROW
EXECUTE PROCEDURE before_chat_participation_update();

CREATE TRIGGER before_chat_room_update
  BEFORE UPDATE
  ON chat_room
  FOR EACH ROW
EXECUTE PROCEDURE inject_updated_at();

CREATE TRIGGER check_last_read_message_before_chat_room_update
  BEFORE UPDATE
  ON chat_room
  FOR EACH ROW
EXECUTE PROCEDURE validate_last_read_message_before_chat_room_update();

CREATE TRIGGER before_chat_message_update
  BEFORE UPDATE
  ON chat_message
  FOR EACH ROW
EXECUTE PROCEDURE before_chat_message_update();

--initial for clinics
CREATE TABLE medical_specializations
(
  id    SERIAL PRIMARY KEY,
  title VARCHAR(128) UNIQUE NOT NULL
);

CREATE TABLE medical_levels
(
  id    SERIAL PRIMARY KEY,
  title VARCHAR(128) UNIQUE NOT NULL
);

CREATE TABLE clinic_positions
(
  user_id                   UUID NOT NULL,
  clinic_id                 UUID NOT NULL,
  medical_specialization_id INT,
  medical_level_id          INT,
  corporate_phone_id        UUID,
  corporate_email           VARCHAR,
  chat_allowed              BOOLEAN DEFAULT FALSE,
  audio_call_allowed        BOOLEAN DEFAULT FALSE,
  video_call_allowed        BOOLEAN DEFAULT FALSE,
  contact_directly_allowed  BOOLEAN DEFAULT FALSE,
  CONSTRAINT fk_user_id_to_users FOREIGN KEY (user_id)
    REFERENCES users (id) MATCH FULL ON DELETE CASCADE,
  CONSTRAINT fk_clinic_id_to_clinics FOREIGN KEY (clinic_id)
    REFERENCES clinics (id) MATCH FULL ON DELETE CASCADE,
  CONSTRAINT medical_specialization_id_to_medical_specializations FOREIGN KEY (medical_specialization_id)
    REFERENCES medical_specializations (id) MATCH FULL ON DELETE SET NULL,
  CONSTRAINT medical_level_id_to_medical_levels FOREIGN KEY (medical_level_id)
    REFERENCES medical_levels (id) ON DELETE SET NULL,
  CONSTRAINT corporate_telephone_to_telephones FOREIGN KEY (corporate_phone_id)
      REFERENCES telephones (id) ON DELETE SET NULL,
  PRIMARY KEY (user_id, clinic_id, medical_specialization_id)
);

CREATE TABLE medical_specializations_schedule
(
  id                        BIGSERIAL PRIMARY KEY,
  user_id                   UUID                        NOT NULL,
  clinic_id                 UUID                        NOT NULL,
  medical_specialization_id INT,
  start                     TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  finish                    TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  FOREIGN KEY (user_id, clinic_id, medical_specialization_id)
    REFERENCES clinic_positions (user_id, clinic_id, medical_specialization_id)
      MATCH FULL ON DELETE CASCADE ON UPDATE CASCADE,
  CHECK ( start < finish AND finish < to_timestamp(0) + INTERVAL '7d' )
);

CREATE OR REPLACE FUNCTION check_schedule_overlaps() RETURNS TRIGGER AS
$BODY$
BEGIN
  IF (SELECT (
               SELECT count(src) > 0
               FROM medical_specializations_schedule src
               WHERE NEW.id != src.id
                 AND NEW.user_id = src.user_id
                 AND (src.start, src.finish) OVERLAPS (NEW.start, NEW.finish)
             )
  )
  THEN
    RAISE EXCEPTION 'schedule overlaps';
  ELSE

  END IF;

  RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql;

CREATE TRIGGER check_schedule_overlaps_before_insert_and_update
  BEFORE UPDATE OR INSERT
  ON medical_specializations_schedule
  FOR EACH ROW
EXECUTE PROCEDURE check_schedule_overlaps();

--intial for calendar
CREATE TYPE event_types AS ENUM ('COMMON', 'DAY_OFF', 'CONSULTATION', 'HOME_VISIT', 'CALL');
CREATE TYPE attachment_types AS ENUM ('TEXT', 'LOCATION', 'MEDIA');

CREATE TABLE event
(
  id         SERIAL PRIMARY KEY,
  owner_id   UUID        NOT NULL,
  clinic_id  UUID,
  event_type event_types NOT NULL,
  header     VARCHAR(56),
  start_at   TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  end_at     TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  remind_at  TIMESTAMP WITH TIME ZONE,
  CHECK ((start_at <= end_at) AND (remind_at <= end_at)),
  CONSTRAINT fk_event_to_user FOREIGN KEY (owner_id)
    REFERENCES "users" (id) MATCH FULL
    ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT fk_event_to_clinic FOREIGN KEY (clinic_id)
    REFERENCES "clinics" (id) MATCH FULL
    ON UPDATE NO ACTION ON DELETE CASCADE
);

CREATE TABLE event_attachment
(
  event_id INT PRIMARY KEY REFERENCES event (id) ON DELETE CASCADE,
  note     VARCHAR(256) DEFAULT '',
  place    POINT        DEFAULT NULL,
  place_description VARCHAR
);

CREATE TABLE event_participant
(
  event_id INT  NOT NULL,
  user_id  UUID NOT NULL,

  PRIMARY KEY (event_id, user_id),

  CONSTRAINT fk_event_to_user FOREIGN KEY (user_id)
    REFERENCES "users" (id) MATCH FULL
    ON UPDATE NO ACTION ON DELETE CASCADE,

  CONSTRAINT fk_event_participant_to_event FOREIGN KEY (event_id)
    REFERENCES event (id) MATCH FULL
    ON DELETE CASCADE
);

CREATE TABLE symptoms
(
  id   SERIAL PRIMARY KEY,
  name VARCHAR(256) UNIQUE NOT NULL
);

CREATE TABLE event_symptoms
(
  event_id   INT NOT NULL,
  symptom_id INT NOT NULL,
  PRIMARY KEY (event_id, symptom_id),
  CONSTRAINT fk_event_symptoms_to_event FOREIGN KEY (event_id)
    REFERENCES event (id) MATCH FULL
    ON DELETE CASCADE,
  CONSTRAINT fk_event_to_symptom FOREIGN KEY (symptom_id)
    REFERENCES symptoms (id) MATCH FULL
    ON UPDATE NO ACTION ON DELETE CASCADE
);

--initial for notifications
CREATE TABLE notification_registry
(
  id      SERIAL NOT NULL,
  status  VARCHAR(24),
  payload JSONB NOT NULL
);

--initial for medicine
CREATE TABLE medicine_companies
(
    id INTEGER PRIMARY KEY,
    name VARCHAR
);

CREATE table drug_records
(
  id                  BIGINT PRIMARY KEY,
  drug_code           VARCHAR(4)               NOT NULL,
  mt_id               VARCHAR(5)               NOT NULL,
  atc_code            VARCHAR                  NOT NULL,
  registration_year   VARCHAR(2)               NOT NULL,
  name                VARCHAR                  NOT NULL,
  type                VARCHAR                  NOT NULL,
  strength            VARCHAR                  NOT NULL,
  package_size        VARCHAR,
  manufacturer        VARCHAR                  NOT NULL,
  pharmacy_company    INTEGER,
  distributor_company INTEGER,
  leaflet_url         VARCHAR,
  available           BOOLEAN                  NOT NULL DEFAULT FALSE,
  has_price           BOOLEAN                  NOT NULL DEFAULT FALSE,
  traffic_warning     BOOLEAN                  NOT NULL DEFAULT FALSE,
  registered_at       TIMESTAMP WITH TIME ZONE,
  created_at          TIMESTAMP WITH TIME ZONE          DEFAULT CURRENT_TIMESTAMP,
  updated_at          TIMESTAMP WITH TIME ZONE          DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_pharmacy_company_to_company FOREIGN KEY (pharmacy_company)
    REFERENCES medicine_companies (id)
    ON DELETE SET NULL,
  CONSTRAINT fk_distributor_company_to_company FOREIGN KEY (distributor_company)
    REFERENCES medicine_companies (id)
    ON DELETE SET NULL
);

CREATE TABLE active_components
(
  id   SERIAL PRIMARY KEY,
  name VARCHAR UNIQUE NOT NULL
);

CREATE TABLE drugs_to_active_components
(
  drug_id             BIGINT NOT NULL,
  active_component_id INTEGER         NOT NULL,
  PRIMARY KEY (drug_id, active_component_id),
  CONSTRAINT fk_drug_to_drugs_record FOREIGN KEY (drug_id)
    REFERENCES drug_records (id) MATCH FULL
    ON DELETE CASCADE,
  CONSTRAINT fk_active_component_to_active_components FOREIGN KEY (active_component_id)
    REFERENCES active_components (id) MATCH FULL
    ON DELETE CASCADE

);

CREATE TABLE dosage_types
(
  id                INTEGER PRIMARY KEY,
  short_description VARCHAR NOT NULL,
  full_description  VARCHAR NOT NULL
);

CREATE TABLE medicines_to_dosages
(
  medicine_id    BIGINT,
  dosage_type_id INTEGER,
  PRIMARY KEY (medicine_id, dosage_type_id),
  CONSTRAINT medicine_to_medicine_id FOREIGN KEY (medicine_id)
    REFERENCES drug_records (id)
    ON DELETE CASCADE,
  CONSTRAINT dosage_to_dosage_id FOREIGN KEY (dosage_type_id)
    REFERENCES dosage_types (id)
    ON DELETE CASCADE
);

--initial for treatment
CREATE TABLE treatment_records
(
  id           SERIAL PRIMARY KEY,
  diagnosis_id UUID,
  title        VARCHAR(64) NOT NULL,
  patient_id   UUID NOT NULL,
  created_by   UUID NOT NULL,
  created_at   TIMESTAMP WITH TIME ZONE DEFAULT date_trunc('milliseconds', CURRENT_TIMESTAMP),
  updated_at   TIMESTAMP WITH TIME ZONE DEFAULT date_trunc('milliseconds', CURRENT_TIMESTAMP),
  deleted_at   TIMESTAMP WITH TIME ZONE,
  CONSTRAINT fk_treatment_to_diagnosis FOREIGN KEY (diagnosis_id)
    REFERENCES medical_icd11 (id)
    ON DELETE SET NULL,
  CONSTRAINT fk_treatment_to_patient FOREIGN KEY (patient_id)
    REFERENCES users (id) MATCH FULL
    ON DELETE CASCADE,
  CONSTRAINT fk_treatment_to_creator FOREIGN KEY (created_by)
    REFERENCES users (id) MATCH FULL
    ON DELETE CASCADE
);

CREATE TABLE treatment_prescriptions
(
  id                  SERIAL PRIMARY KEY,
  treatment_id        INT                      NOT NULL,
  title               VARCHAR(64)              NOT NULL,
  type                VARCHAR(32)              NOT NULL,
  notify_on_skipped   BOOLEAN                           DEFAULT FALSE,
  notify_on_postponed BOOLEAN                           DEFAULT FALSE,
  notify_on_completed BOOLEAN                           DEFAULT FALSE,
  notify_on_mood      INT[],
  data                JSONB                    NOT NULL DEFAULT '{}'::JSONB,
  start_at            TIMESTAMP WITH TIME ZONE NOT NULL,
  CONSTRAINT fk_prescription_to_treatment FOREIGN KEY (treatment_id)
    REFERENCES treatment_records (id) MATCH FULL
    ON DELETE CASCADE
);

CREATE TABLE prescription_procedures
(
  id                SERIAL PRIMARY KEY,
  prescription_id   INT                      NOT NULL,
  seen              BOOLEAN                  NOT NULL DEFAULT FALSE,
  dose              FLOAT,
  mood              INT,
  feedback          VARCHAR(124),
  completed         BOOLEAN DEFAULT FALSE NOT NULL,
  date              TIMESTAMP WITH TIME ZONE NOT NULL,
  last_postponed_at TIMESTAMP WITH TIME ZONE,
  created_at   TIMESTAMP WITH TIME ZONE DEFAULT date_trunc('milliseconds', CURRENT_TIMESTAMP),
  updated_at   TIMESTAMP WITH TIME ZONE DEFAULT date_trunc('milliseconds', CURRENT_TIMESTAMP),
  deleted_at   TIMESTAMP WITH TIME ZONE,
  action            VARCHAR,
  CONSTRAINT fk_procedure_to_prescription FOREIGN KEY (prescription_id)
    REFERENCES treatment_prescriptions MATCH FULL
    ON DELETE CASCADE
);

CREATE TABLE treatment_templates_folders
(
  id        SERIAL PRIMARY KEY,
  name      VARCHAR(128) NOT NULL,
  parent_id INTEGER,
  owner_id  UUID,
  clinic_id UUID,
  CHECK ( ((owner_id IS NULL) != (clinic_id IS NULL)) -- kind a XOR for fields
      AND (id != parent_id)),
  CONSTRAINT fk_template_folder_owner_id_to_user FOREIGN KEY (owner_id)
    REFERENCES users (id)
    ON DELETE CASCADE,
  CONSTRAINT fk_template_folder_clinic_to_clinic FOREIGN KEY (clinic_id)
    REFERENCES clinics (id)
    ON DELETE CASCADE,
  CONSTRAINT fk_parent_folder_id_to_folder FOREIGN KEY (parent_id)
    REFERENCES treatment_templates_folders (id)
    ON DELETE CASCADE
);

CREATE TABLE treatment_templates
(
  id            SERIAL PRIMARY KEY,
  diagnosis_id  UUID,
  name          VARCHAR(128) NOT NULL,
  prescriptions JSONB   NOT NULL,
  starred       BOOLEAN NOT NULL DEFAULT FALSE,
  folder_id     INT,
  owner_id      UUID,
  clinic_id     UUID,
    CHECK ( (owner_id IS NULL) != (clinic_id IS NULL) ), -- kind a XOR for fields
  CONSTRAINT fk_owner_id_to_user FOREIGN KEY (owner_id)
    REFERENCES users (id)
      ON DELETE CASCADE,
  CONSTRAINT fk_template_clinic_to_clinic FOREIGN KEY (clinic_id)
    REFERENCES clinics (id)
     ON DELETE CASCADE,
  CONSTRAINT fk_template_folders_to_folder FOREIGN KEY (folder_id)
    REFERENCES treatment_templates_folders (id)
     ON DELETE CASCADE,
  CONSTRAINT fk_template_to_diagnosis FOREIGN KEY(diagnosis_id)
    REFERENCES medical_icd11(id)
     ON DELETE SET NULL
);

CREATE TABLE prescription_exercises
(
  id                      SERIAL PRIMARY KEY,
  prescription_id         INT          NOT NULL,
  type                    VARCHAR(64)  NOT NULL,
  exercise_name           VARCHAR(128) NOT NULL,
  exercise_description    VARCHAR(512) NOT NULL,
  exercise_attachment_url VARCHAR(128) NOT NULL,
  holds                   INT          NOT NULL,
  reps                    INT          NOT NULL,
  set_n                   INT          NOT NULL,
  trackers                JSONB                    DEFAULT NULL,
  updated_at              TIMESTAMP WITH TIME ZONE DEFAULT current_timestamp,
  created_at              TIMESTAMP WITH TIME ZONE DEFAULT current_timestamp,
  CONSTRAINT fk_exercise_to_prescription FOREIGN KEY (prescription_id)
    REFERENCES treatment_prescriptions (id)
    ON DELETE CASCADE
);

CREATE TABLE exercise_feedback
(
  prescription_exercise_id  INT,
  prescription_procedure_id INT,
  pain_relief               INT,
  difficulty                INT,
  mood                      INT,
  reps                      INT,
  set_n                     INT,
  updated_at                TIMESTAMP WITH TIME ZONE DEFAULT current_timestamp,
  created_at                TIMESTAMP WITH TIME ZONE DEFAULT current_timestamp,
  PRIMARY KEY (prescription_exercise_id, prescription_procedure_id),
  CONSTRAINT fk_exercise_feedback_to_exercise FOREIGN KEY (prescription_exercise_id)
    REFERENCES prescription_exercises (id)
    ON DELETE CASCADE,
  CONSTRAINT fk_prescription_procedure_to_procedure FOREIGN KEY (prescription_procedure_id)
    REFERENCES prescription_procedures (id)
    ON DELETE CASCADE
);

CREATE TABLE prescription_activity
(
  id              SERIAL PRIMARY KEY,
  prescription_id INT         NOT NULL,
  type            VARCHAR(64) NOT NULL,
  load            JSONB                    DEFAULT json_build_object(),
  goal            JSONB                    DEFAULT json_build_object(),
  updated_at      TIMESTAMP WITH TIME ZONE DEFAULT current_timestamp,
  created_at      TIMESTAMP WITH TIME ZONE DEFAULT current_timestamp,
  CONSTRAINT fk_activity_to_prescription FOREIGN KEY (prescription_id)
    REFERENCES treatment_prescriptions (id)
    ON DELETE CASCADE
);

CREATE TABLE activity_feedback
(
  prescription_activity_id  INT,
  prescription_procedure_id INT,
  pain_relief               INT,
  difficulty                INT,
  mood                      INT,
  distance                  DOUBLE PRECISION,
  time                      INT,
  updated_at                TIMESTAMP WITH TIME ZONE DEFAULT current_timestamp,
  created_at                TIMESTAMP WITH TIME ZONE DEFAULT current_timestamp,
  PRIMARY KEY (prescription_activity_id, prescription_procedure_id),
  CONSTRAINT fk_exercise_feedback_to_exercise FOREIGN KEY (prescription_activity_id)
    REFERENCES prescription_activity (id)
    ON DELETE CASCADE,
  CONSTRAINT fk_prescription_procedure_to_procedure FOREIGN KEY (prescription_procedure_id)
    REFERENCES prescription_procedures (id)
    ON DELETE CASCADE
);


CREATE TABLE prescription_question
(
  id              SERIAL PRIMARY KEY,
  prescription_id INT                                    NOT NULL,
  title           VARCHAR                                NOT NULL,
  type            VARCHAR                                NOT NULL,
  answers         VARCHAR[]                DEFAULT array []::varchar[],
  required        BOOLEAN                  DEFAULT FALSE NOT NULL,
  updated_at      TIMESTAMP WITH TIME ZONE DEFAULT current_timestamp,
  created_at      TIMESTAMP WITH TIME ZONE DEFAULT current_timestamp,
  CHECK ( (array_length(answers, 1) IS NOT NULL AND type IN ('single', 'multiple')) OR
          (array_length(answers, 1) IS NULL AND type = 'open') ),
  CONSTRAINT fk_question_to_prescription FOREIGN KEY (prescription_id)
    REFERENCES treatment_prescriptions (id)
    ON DELETE CASCADE
);

CREATE TABLE question_feedback
(
  prescription_question_id  INT NOT NULL,
  prescription_procedure_id INT NOT NULL,
  answer                    JSONB,
  updated_at                TIMESTAMP WITH TIME ZONE DEFAULT current_timestamp,
  created_at                TIMESTAMP WITH TIME ZONE DEFAULT current_timestamp,
  PRIMARY KEY (prescription_procedure_id, prescription_question_id),
  CONSTRAINT fk_question_feedback_to_question FOREIGN KEY (prescription_question_id)
    REFERENCES prescription_question (id)
    ON DELETE CASCADE,
  CONSTRAINT fk_prescription_procedure_to_procedure FOREIGN KEY (prescription_procedure_id)
    REFERENCES prescription_procedures (id)
    ON DELETE CASCADE
);

CREATE TABLE prescription_medicine
(
  prescription_id INT    NOT NULL,
  medicine_id     BIGINT NOT NULL,
  directions      VARCHAR(256) DEFAULT '',
  PRIMARY KEY (prescription_id, medicine_id),
  CONSTRAINT fk_medicine_id_to_drug_record FOREIGN KEY (medicine_id)
    REFERENCES drug_records (id) MATCH FULL
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_prescription_id_to_prescription_record FOREIGN KEY (prescription_id)
    REFERENCES treatment_prescriptions (id) MATCH FULL
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE OR REPLACE FUNCTION inject_treatment_updated_at() RETURNS TRIGGER AS
$BODY$
BEGIN
  UPDATE treatment_records
  SET updated_at = date_trunc('milliseconds', CURRENT_TIMESTAMP)
  WHERE id = (
    SELECT tr.id
    FROM treatment_prescriptions
           INNER JOIN treatment_records tr ON treatment_prescriptions.treatment_id = tr.id
    WHERE treatment_prescriptions.id = NEW.prescription_id
  );
  RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql;

CREATE TRIGGER inject_updated_at_before_update
  BEFORE UPDATE
  ON prescription_procedures
  FOR EACH ROW
EXECUTE PROCEDURE inject_updated_at();

CREATE TRIGGER inject_treatment_updated_at_after_prescription_procedure_created_or_updated
  AFTER INSERT OR UPDATE
  ON prescription_procedures
  FOR EACH ROW
EXECUTE PROCEDURE inject_treatment_updated_at();


SELECT tr.id
FROM treatment_prescriptions
       INNER JOIN treatment_records tr ON treatment_prescriptions.treatment_id = tr.id
WHERE treatment_prescriptions.id = 294;

CREATE OR REPLACE FUNCTION check_procedure_action() RETURNS TRIGGER AS
$BODY$
BEGIN
  CASE WHEN NEW.action != OLD.action
    THEN
      IF NEW.action = 'Undo' AND OLD.action != 'Taken'
      THEN
        RAISE EXCEPTION 'you can undo only taken action';
      ELSE
      END IF;

      IF NEW.action IN ('Skipped', 'Postponed') AND OLD.action = 'Taken'
      THEN
        RAISE EXCEPTION 'you need to undo first';
      ELSE
      END IF;
    ELSE
    END CASE;
  RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql;

CREATE TRIGGER check_procedure_action_before_update
  BEFORE UPDATE
  ON prescription_procedures
  FOR EACH ROW
EXECUTE PROCEDURE check_procedure_action();

