module.exports = {
    up: (queryInterface, Sequelize) => {
        return queryInterface.sequelize.query(`
        UPDATE questions set question = 'Would you like to reduce your stress? We can help you. Do you want a reminder when to meditate?' WHERE id = 19;
        `)
    },
};
