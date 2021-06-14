CREATE TABLE "user_fitbit_tokens" (
    "user_id" uuid NOT NULL,
    "access_token" text NOT NULL,
    "refresh_token" text NOT NULL,
    "token_type" character varying(255) NOT NULL,
    "fitbit_user_id" character varying(255) NOT NULL,
    "expires_at" timestamp NOT NULL
);

CREATE TABLE "user_strava_tokens" (
    "user_id" uuid NOT NULL,
    "access_token" text NOT NULL,
    "refresh_token" text NOT NULL,
    "expires_at" timestamp NOT NULL,
    "token_type" character varying(255) NOT NULL,
    "signed_at" timestamp NOT NULL,
    "athlete_id" bigint NOT NULL
);

CREATE TABLE "user_withings_tokens" (
    "user_id" uuid NOT NULL,
    "access_token" text NOT NULL,
    "refresh_token" text NOT NULL,
    "token_type" character varying(255) NOT NULL,
    "expires_at" timestamp NOT NULL,
    "signed_at" timestamp NOT NULL
);

CREATE SEQUENCE wearebles_fitbit_heart_rate_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;

CREATE TABLE "wearebles_fitbit_heart_rate" (
    "id" integer DEFAULT nextval('wearebles_fitbit_heart_rate_id_seq') NOT NULL,
    "date" date NOT NULL,
    "calories_out" real,
    "max" integer,
    "min" integer,
    "minutes" integer,
    "name" character varying(255),
    "resting_heart_rate" integer,
    "user_id" uuid NOT NULL
);

CREATE TABLE "wearebles_fitbit_sleep" (
    "id" integer NOT NULL,
    "minutes_after_wakeup" integer NOT NULL,
    "minutes_asleep" integer NOT NULL,
    "minutes_to_fall_asleep" integer NOT NULL,
    "start_time" timestamp NOT NULL,
    "time_in_bed" integer NOT NULL,
    "date_of_sleep" date NOT NULL,
    "duration" numeric NOT NULL,
    "efficiency" integer NOT NULL,
    "is_main_sleep" boolean NOT NULL,
    "summary_deep_count" integer NOT NULL,
    "summary_deep_minutes" integer NOT NULL,
    "summary_light_count" integer NOT NULL,
    "summary_light_minutes" integer NOT NULL,
    "summary_wake_count" integer NOT NULL,
    "summary_wake_minutes" integer NOT NULL,
    "user_id" uuid NOT NULL
);

CREATE SEQUENCE wearebles_strava_activities_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;

CREATE TABLE "wearebles_strava_activities" (
    "id" integer DEFAULT nextval('wearebles_strava_activities_id_seq') NOT NULL,
    "user_id" uuid NOT NULL,
    "strava_user_id" bigint NOT NULL,
    "workout_id" bigint NOT NULL,
    "moving_time" time without time zone,
    "elapsed_time" time without time zone,
    "type" text,
    "kilojoules" real,
    "activity_name" text,
    "max_heart_rate" real,
    "max_watts" real,
    "average_watts" real,
    "average_heartrate" real,
    "start_date" timestamp NOT NULL
);

CREATE SEQUENCE wearebles_withings_hearrate_list_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;

CREATE TABLE "wearebles_withings_hearrate_list" (
    "id" integer DEFAULT nextval('wearebles_withings_hearrate_list_id_seq') NOT NULL,
    "deviceid" text NOT NULL,
    "model" integer NOT NULL,
    "ecg_signalId" integer,
    "ecg_afib" integer,
    "bloodpressure_diastole" integer,
    "bloodpressure_systole" integer,
    "heart_rate" integer,
    "timestamp" timestamp NOT NULL,
    "user_id" uuid NOT NULL
);

CREATE SEQUENCE wearebles_withings_slep_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;

CREATE TABLE "wearebles_withings_sleep" (
    "user_id" uuid NOT NULL,
    "id" integer DEFAULT nextval('wearebles_withings_slep_id_seq') NOT NULL,
    "timezone" character varying(255) NOT NULL,
    "model" integer NOT NULL,
    "model_id" integer NOT NULL,
    "startdate" timestamp NOT NULL,
    "enddate" timestamp NOT NULL,
    "date" character varying(255) NOT NULL,
    "modified" timestamp,
    "breathing_disturbances_intensity" integer,
    "deepsleepduration" integer,
    "durationtosleep" integer,
    "durationtowakeup" integer,
    "hr_average" integer,
    "hr_max" integer,
    "hr_min" integer,
    "lightsleepduration" integer,
    "remsleepduration" integer,
    "rr_average" integer,
    "rr_max" integer,
    "rr_min" integer,
    "sleep_score" integer,
    "snoring" integer,
    "snoringepisodecount" integer,
    "wakeupcount" integer,
    "wakeupduration" integer
);
