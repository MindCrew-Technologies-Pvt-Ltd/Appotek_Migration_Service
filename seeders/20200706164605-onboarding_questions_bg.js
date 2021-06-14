module.exports = {
    up: (queryInterface, Sequelize) => {
        return queryInterface.sequelize.query(`
            DELETE FROM questions WHERE id=7;
            DELETE FROM questions WHERE id=9;
            UPDATE questions SET reminder_type='medicine' WHERE id=6;
            UPDATE questions SET reminder_type='medicine' WHERE id=8;
            UPDATE answers SET leading_to=8 WHERE id=17;
            UPDATE answers SET leading_to=10 WHERE id=19;
            -- new question
            ALTER SEQUENCE questionnarie_id_seq RESTART WITH 16;
            INSERT INTO questions(question, type,reminder_type, image_m, image_w) VALUES
            ('Would you like us to remind you when to do a physical activity?', 'radio', Null, 'https://new-back-storage.s3.eu-central-1.amazonaws.com/background/bg_onbording_m.png', 'https://new-back-storage.s3.eu-central-1.amazonaws.com/background/bg_onbording_w.png'),
            ('Do you do any cardio?', 'radio', 'cardio', 'https://new-back-storage.s3.eu-central-1.amazonaws.com/background/bg_onbording_m.png', 'https://new-back-storage.s3.eu-central-1.amazonaws.com/background/bg_onbording_w.png'),
            ('Do you do any physical exercise?', 'radio','exercise', 'https://new-back-storage.s3.eu-central-1.amazonaws.com/background/bg_onbording_m.png', 'https://new-back-storage.s3.eu-central-1.amazonaws.com/background/bg_onbording_w.png');
            
            ALTER SEQUENCE answers_id_seq RESTART WITH 32;
            INSERT INTO answers(question_id, leading_to, text) VALUES
            (16,17,'yes'),
            (16,17,'no'),
            (17,18,'yes'),
            (17,18,'no'),
            (18,null,'yes'),
            (18,null,'no')
      `)
    },
};
