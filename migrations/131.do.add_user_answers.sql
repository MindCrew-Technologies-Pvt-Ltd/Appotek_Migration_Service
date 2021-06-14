CREATE INDEX "answers_id" ON "answers" USING btree ("id");
ALTER TABLE "answers" ADD CONSTRAINT "answers_id_primary" PRIMARY KEY ("id");

CREATE TABLE "user_answers" (
    "question_id" integer NOT NULL,
    "answer_id" integer,
    "answer_text" character varying(255),
    "user_id" uuid NOT NULL,
    CONSTRAINT "user_answers_answer_id_fkey" FOREIGN KEY (answer_id) REFERENCES answers(id) ON UPDATE CASCADE ON DELETE CASCADE NOT DEFERRABLE,
    CONSTRAINT "user_answers_question_id_fkey" FOREIGN KEY (question_id) REFERENCES questions(id) ON UPDATE CASCADE ON DELETE CASCADE NOT DEFERRABLE
);

CREATE INDEX "user_answers_answer_id" ON "user_answers" USING btree ("answer_id");
CREATE INDEX "user_answers_question_id" ON "user_answers" USING btree ("question_id");
CREATE INDEX "user_answers_user_id" ON "user_answers" USING btree ("user_id");
