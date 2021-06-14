module.exports = {
    up: (queryInterface, Sequelize) => {
        return queryInterface.sequelize.query(`UPDATE answers SET leading_to = 2 WHERE id = 1;`)
    },
};
