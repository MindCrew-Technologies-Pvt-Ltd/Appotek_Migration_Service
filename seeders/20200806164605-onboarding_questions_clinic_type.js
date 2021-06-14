module.exports = {
    up: (queryInterface, Sequelize) => {
        return queryInterface.sequelize.query(`
            UPDATE questions SET question='What is your favorite clinic?', type='list_clinic' WHERE id = 2;
      `)
    },
};
