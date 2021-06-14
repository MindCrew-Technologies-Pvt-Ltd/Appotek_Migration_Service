'use strict';

const initialRoles = [
    'patient',
    'doctor',
    'pharmacist',
    'receptionist',
    'clinic administrator',
    'pharmacy administrator',
    'system administrator',
    'carer',
    'nurse',
    'insurance company agent',
    ];
  
  module.exports = {
    up: (queryInterface, Sequelize) => {
      return queryInterface.bulkInsert(
        'roles',
        initialRoles.map(r => ({ name: r })),
      );
    },
  
    down: (queryInterface, Sequelize) => {
      return queryInterface.bulkDelete('roles', null, {});
    }
  };
