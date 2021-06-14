module.exports = {
    up: (queryInterface, Sequelize) => {
        return queryInterface.sequelize.query(`
            UPDATE questions SET type = 'weight_picker' WHERE id = 13;
            UPDATE questions SET type = 'age_picker' WHERE id = 15;
      `)
    },
};
