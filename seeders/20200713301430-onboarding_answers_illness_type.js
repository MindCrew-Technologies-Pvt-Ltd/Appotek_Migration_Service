module.exports = {
    up: (queryInterface, Sequelize) => {
        return queryInterface.sequelize.query(`
        UPDATE questions SET reminder_type = 'illness' WHERE id = 4;
        `)
    },
};
