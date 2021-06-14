module.exports = {
    up: (queryInterface, Sequelize) => {
        return queryInterface.sequelize.query(`
        UPDATE answers set text = 'Track my fitness with wearables' WHERE id = 13;
        UPDATE answers set text = 'Track my health with medical devices' WHERE id = 14;
        `)
    },
};
