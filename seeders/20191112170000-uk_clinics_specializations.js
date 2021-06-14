
  module.exports = {
    up: (queryInterface, Sequelize) => {
      return queryInterface.sequelize.query(`
      insert into "clinic-types"(id, "name") values
      (100000, 'Other'),
      (100001, 'WIC Practice'),
      (100002, 'OOH Practice'),
      (100003, 'WIC + OOH Practice'),
      (100004, 'GP Practice'),
      (100008, 'Public Health Service'),
      (100009, 'Community Health Service'),
      (100010, 'Hospital Service'),
      (100011, 'Optometry Service'),
      (100012, 'Urgent & Emergency Care'),
      (100013, 'Hospice'),
      (100014, 'Care Home / Nursing Home'),
      (100015, 'Border Force'),
      (100016, 'Young Offender Institution'),
      (100017, 'Secure Training Centre'),
      (100018, 'Secure Children''s Home'),
      (100019, 'Immigration Removal Centre'),
      (100020, 'Court'),
      (100021, 'Police Custody'),
      (100022, 'Sexual Assault Referral Centre (SARC)'),
      (100024, 'Other – Justice Estate'),
      (100025, 'Prison infirmary');
      `)
    },

    down: (queryInterface, Sequelize) => {
      return queryInterface.bulkDelete('clinic-types', {id: { [Op.and]: { [Op.gte]: 100000, [Op.lt]: 200000 }}}, {});
    },
  };
