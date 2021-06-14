module.exports = {
    up: (queryInterface, Sequelize) => {
        return queryInterface.sequelize.query(`
        INSERT INTO questions (question, type, image_m, image_w, reminder_type, is_mandatory) VALUES ('You would like to reduce your stess. We can help you.Do you want a rminder when to meditate', 'radio', 'https://new-back-storage.s3.eu-central-1.amazonaws.com/background/bg_onbording_m.png', 'https://new-back-storage.s3.eu-central-1.amazonaws.com/background/bg_onbording_w.png', 'meditation', 0);
        INSERT INTO answers (question_id, text) VALUES (19, 'yes'), (19, 'no');
        UPDATE answers set leading_to = 19 WHERE question_id = 18;
        `)
    },
};
