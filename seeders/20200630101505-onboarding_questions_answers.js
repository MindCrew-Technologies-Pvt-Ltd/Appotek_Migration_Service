module.exports = {
    up: (queryInterface, Sequelize) => {
        return queryInterface.sequelize.query(`
INSERT INTO "questions" ("id", "question", "type", "image_m", "image_w") VALUES
(1,'What would you like to get from using appotek?','multiple_choice',NULL,NULL),
(2,'Who is your personal doctor?','list_doctor',NULL,NULL),
(3,'What is your local pharmacy?','list_pharmacy',NULL,NULL),
(4,'Do you suffer from any illness?','radio',NULL,NULL),
(5,'What is the name of your ilness?','text',NULL,NULL),
(6,'Do you take any medication?','radio',NULL,NULL),
(7,'Enter your medication?','quick_step',NULL,NULL),
(8,'Do you take any further medication?','radio',NULL,NULL),
(9,'Enter your medication','quick_step',NULL,NULL),
(10,'What food do you prefer to eat?','multiple_choice',NULL,NULL),
(11,'When do you normally wake up in the morning?','time_picker',NULL,NULL),
(12,'When do you go to bed?','time_picker',NULL,NULL),
(13,'What is your body weight?','picker',NULL,NULL),
(14,'What is your activity level?','select',NULL,NULL),
(15,'What is your age?','picker',NULL,NULL);

INSERT INTO "answers" ("id", "question_id", "leading_to", "text") VALUES
(1,1,NULL,'Better healthcare'),
(2,1,2,'Search new treatments'),
(3,1,2,'Get treatment reminders'),
(4,1,2,'Online consultations'),
(5,1,2,'Faster bookings when I need it'),
(6,1,2,'Reliable medical information'),
(7,1,4,'Get in touch with patients groups'),
(8,1,2,'Help manage my illness'),
(9,1,2,'Help manage my day'),
(10,1,4,'Eat & drink healthier'),
(11,1,4,'Physical exercise'),
(12,1,4,'Reduce my stress'),
(13,1,4,'track my fitness with wearables'),
(14,1,4,'track my health with medical devices'),
(15,4,5,'yes'),
(16,4,6,'no'),
(17,6,7,'yes'),
(18,6,10,'no'),
(20,8,10,'no'),
(19,8,9,'yes'),
(21,10,11,'Vegitarian'),
(22,10,11,'Meet'),
(23,10,11,'Bread'),
(24,10,11,'Milk'),
(25,10,11,'Eggs'),
(26,10,11,'Seeds'),
(27,14,15,'None'),
(28,14,15,'Low'),
(29,14,15,'Medium'),
(30,14,15,'High'),
(31,14,15,'Athlete');
      `)
    },

    down: (queryInterface, Sequelize) => {
        return Promise.all([
            queryInterface.bulkDelete('questions', null, {}),
            queryInterface.bulkDelete('answers', null, {}),
        ])
    },
};
