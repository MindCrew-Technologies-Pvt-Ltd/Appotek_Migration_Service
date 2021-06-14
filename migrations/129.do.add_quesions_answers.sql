CREATE SEQUENCE questionnarie_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;

CREATE TABLE "questions" (
                             "id" integer DEFAULT nextval('questionnarie_id_seq') NOT NULL,
                             "question" text NOT NULL,
                             "type" character varying(255) NOT NULL,
                             "image_m" character varying(255),
                             "image_w" character varying(255),
                             CONSTRAINT "questions_id" PRIMARY KEY ("id")
) WITH (oids = false);

CREATE INDEX "questions_id_index" ON "questions" USING btree ("id");

CREATE SEQUENCE answers_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;
CREATE TABLE "answers" (
                                    "id" integer DEFAULT nextval('answers_id_seq') NOT NULL,
                                    "question_id" integer NOT NULL,
                                    "leading_to" integer,
                                    "text" character varying(255) NOT NULL,
                                    CONSTRAINT "answers_question_id_fkey" FOREIGN KEY (question_id) REFERENCES questions(id) ON UPDATE CASCADE ON DELETE CASCADE NOT DEFERRABLE
) WITH (oids = false);
