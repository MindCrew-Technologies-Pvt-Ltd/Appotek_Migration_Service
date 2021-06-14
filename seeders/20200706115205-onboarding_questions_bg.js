module.exports = {
    up: (queryInterface, Sequelize) => {
        return queryInterface.sequelize.query(`
            UPDATE questions SET image_w = 'https://new-back-storage.s3.eu-central-1.amazonaws.com/background/bg_onbording_w.png';
            UPDATE questions SET image_m = 'https://new-back-storage.s3.eu-central-1.amazonaws.com/background/bg_onbording_m.png';
            
      `)
    },
};
