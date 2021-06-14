module.exports = {
    up: (queryInterface, Sequelize) => {
        return queryInterface.sequelize.query(`
        UPDATE questions SET question = 'What would you like to get from using Appotek?' WHERE id = 1;
        `)
    },
};
