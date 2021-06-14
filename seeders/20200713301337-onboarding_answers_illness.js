module.exports = {
    up: (queryInterface, Sequelize) => {
        return queryInterface.sequelize.query(`
        DELETE FROM questions WHERE id = 5;
        UPDATE answers SET leading_to = 6 WHERE id = 15;
        `)
    },
};
