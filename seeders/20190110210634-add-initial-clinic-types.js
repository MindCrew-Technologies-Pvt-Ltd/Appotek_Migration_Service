const initialClinicTypes = [
    'Personal practise',
    'Private clinic',
    'Hospital',
    'Organisation',
  ];
  module.exports = {
    up: (queryInterface, Sequelize) => {
      return queryInterface.bulkInsert(
        'clinic-types',
        initialClinicTypes.map(r => ({ name: r })),
      );
    },
  
    down: (queryInterface, Sequelize) => {
      return queryInterface.bulkDelete('clinic-types', null, {});
    },
  };
  