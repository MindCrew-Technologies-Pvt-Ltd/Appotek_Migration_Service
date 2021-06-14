module.exports = {
    up: (queryInterface, Sequelize) => {
        return queryInterface.sequelize.query(`
                UPDATE answers SET leading_to = 21 WHERE question_id = 19;
                UPDATE answers SET leading_to = 20 WHERE leading_to = 11;
                UPDATE answers SET leading_to = 11 WHERE question_id = 20;
        `)
    },
};
