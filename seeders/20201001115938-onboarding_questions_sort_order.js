module.exports = {
    up: (queryInterface, Sequelize) => {
        return queryInterface.sequelize.query(`
                DELETE FROM questions WHERE id = 15;
                DELETE FROM answers WHERE question_id = 15;
                UPDATE answers SET leading_to = 16 WHERE leading_to = 15;

                ALTER TABLE "questions"
                    ALTER "image_m" TYPE character varying(255),
                    ALTER "image_m" SET DEFAULT 'https://new-back-storage.s3.eu-central-1.amazonaws.com/background/bg_onbording_m.png',
                    ALTER "image_m" DROP NOT NULL,
                    ALTER "image_w" TYPE character varying(255),
                    ALTER "image_w" SET DEFAULT 'https://new-back-storage.s3.eu-central-1.amazonaws.com/background/bg_onbording_w.png',
                    ALTER "image_w" DROP NOT NULL;
                INSERT INTO questions (id,question, type, reminder_type) 
                    VALUES (20,'Would you like us to remind you drink water?', 'radio', 'instruction');
                
                INSERT INTO questions (id,question, type, reminder_type) 
                    VALUES (21,'Would you like  a reminder when to take a break and breethe?', 'radio', 'instruction');
                SELECT setval('questionnarie_id_seq', 21);
                INSERT INTO answers (question_id, leading_to, text) 
                    VALUES (20,21, 'yes'), (20,21, 'no'), (21,null, 'yes'), (21,null, 'no');
    
                UPDATE questions SET sort = 1 WHERE id = 1;
                UPDATE questions SET sort = 2 WHERE id = 2;
                UPDATE questions SET sort = 3 WHERE id = 3;
                UPDATE questions SET sort = 4 WHERE id = 4;
                UPDATE questions SET sort = 5 WHERE id = 5;
                UPDATE questions SET sort = 6 WHERE id = 6;
                UPDATE questions SET sort = 7 WHERE id = 8;
                UPDATE questions SET sort = 8 WHERE id = 10;
                UPDATE questions SET sort = 9 WHERE id = 20;
                UPDATE questions SET sort = 10 WHERE id = 11;
                UPDATE questions SET sort = 11 WHERE id = 12;
                UPDATE questions SET sort = 12 WHERE id = 13;
                UPDATE questions SET sort = 13 WHERE id = 14;
                UPDATE questions SET sort = 14 WHERE id = 16;
                UPDATE questions SET sort = 15 WHERE id = 17;
                UPDATE questions SET sort = 16 WHERE id = 18;
                UPDATE questions SET sort = 17 WHERE id = 19;
                UPDATE questions SET sort = 18 WHERE id = 21;
        `)
    },
};
