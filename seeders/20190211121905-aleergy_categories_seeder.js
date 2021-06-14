'use strict';

const initialCAllergyCategories = [
  'Pollen',
  'Moulds & Yeasts',
  'Mites & Cockroaches',
  'Dander & Epithelia',
  'Hymenoptera Venoms',
  'Foods',
  'Other',
];

module.exports = {
  up: (queryInterface, Sequelize) => {
    return queryInterface.bulkInsert(
      'allergy_categories',
      initialCAllergyCategories.map(r => ({ name: r })),
    );
  },

  down: (queryInterface, Sequelize) => {
    return queryInterface.bulkDelete('allergy_categories', null, {});
  }
};
