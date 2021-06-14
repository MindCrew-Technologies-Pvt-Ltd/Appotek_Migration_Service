module.exports = {
    up: (queryInterface, Sequelize) => {
        return queryInterface.sequelize.query(`
            UPDATE questions SET is_mandatory = 1 WHERE id = 1;
            UPDATE questions SET reminder_type = 'medicine' WHERE id = 7;
            UPDATE questions SET reminder_type = 'medicine' WHERE id = 9;
      `)
    },
};
