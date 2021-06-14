const initialClinicTypes = [
    'Mother\'s surname',
    'Driver license number',
    'Favourite song',
    'Pet\'s name',
  ];
  module.exports = {
    up: (queryInterface, Sequelize) => {
      return queryInterface.bulkInsert(
        'recovery_questions',
        initialClinicTypes.map(r => ({ title: r })),
      );
    },
  
    down: (queryInterface, Sequelize) => {
      return queryInterface.bulkDelete('recovery_questions', null, {});
    },
  };
  