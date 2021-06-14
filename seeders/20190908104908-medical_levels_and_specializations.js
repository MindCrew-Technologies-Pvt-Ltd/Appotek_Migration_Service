
  module.exports = {
    up: (queryInterface, Sequelize) => {
      return queryInterface.sequelize.query(`
INSERT INTO medical_specializations(title)
VALUES ('Allergy & immunology specialist'),('Anesthesiology specialist'),('Dermatology specialist'),('Diagnostic radiology specialist'),('Emergency medicine specialist'),('Family medicine specialist'),('Internal medicine specialist'),('Medical genetics specialist'),('Neurology specialist'),('Nuclear medicine specialist'),('Obstetrics and gynecology specialist'),('Ophthalmology specialist'),('Pathology specialist'),('Pediatrics specialist'),('Physical medicine & rehabilitation specialist'),('Preventive medicine specialist'),('Psychiatry specialist'),('Radiation oncology specialist'),('Surgery specialist'),('Urology Programs specialist');

INSERT INTO medical_levels(title)
VALUES ('Doctor of Medicine by research'),
       ('Doctor of Philosophy'),
       ('Master of Clinical Medicine'),
       ('Master of Medical Science'),
       ('Master of Medicine'),
       ('Master of Philosophy'),
       ('Master of Surgery'),
       ('Master of Science in Medicine or Surgery'),
       ('Doctor of Clinical Medicine'),
       ('Doctor of Clinical Surgery'),
       ('Doctor of Medical Science'),
       ('Doctor of Surgery');
      `)
    },

    down: (queryInterface, Sequelize) => {
      return Promise.all([
      queryInterface.bulkDelete('medical_levels', null, {}),
      queryInterface.bulkDelete('medical_specializations', null, {}),
      ])
    },
  };
