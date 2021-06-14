module.exports = {
  up: (queryInterface, Sequelize) => {
    return queryInterface.sequelize.query(`
      INSERT INTO areas_list ("title", "column_name")
      VALUES
        ('Patients', 'patients'),
        ('Calendar', 'calendar'),
        ('Treatments', 'treatments'),
        ('Waiting rooms', 'waiting_rooms'),
        ('Monitoring', 'monitoring'),
        ('EHR', 'ehr'),
        ('Wearables', 'wearables'),
        ('Chat', 'chat'),
        ('Media', 'media'),
        ('Read notifications', 'is_read'),
        ('Mobile apps', 'mobile_apps');
    `)
  },
  
  down: (queryInterface, Sequelize) => {
    return queryInterface.sequelize.query(`
      DELETE FROM areas_list;
    `)
  }
}