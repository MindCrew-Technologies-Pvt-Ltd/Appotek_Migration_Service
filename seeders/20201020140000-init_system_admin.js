module.exports = {
  up: (queryInterface, Sequelize) => {
    return queryInterface.sequelize.query(`
      INSERT INTO telephones (id, "countryId", telephone, "countryCode", "number")
        VALUES ('101971b3-6f2b-43bf-93fb-93f25d8930e3', 63, '+45263800000', '+45', '263800000')
      ON CONFLICT (telephone) DO NOTHING;
    
      INSERT INTO users (id, "roleId", "countryId", "firstName", "lastName", "telephoneId")
      VALUES(
        '15c8b007-107f-4e64-97c4-9de3168f09c7',
        7, --system administrator
        63, --DK
        'Rasmus',
        'Gustavsen',
        '101971b3-6f2b-43bf-93fb-93f25d8930e3'
      );
      
      INSERT INTO credentials (id, "userId", "passwordHash") VALUES ('62cfc583-afe9-4457-a4bd-6f4d15e15311', '15c8b007-107f-4e64-97c4-9de3168f09c7', '$argon2i$v=19$m=4096,t=3,p=1$SUNQb1BGWVlkMzlRVWU2MQ$1TiPI46k5SAtXp9v/Tbv+w');
      
      INSERT INTO devices (id, user_id, app) VALUES ('0000', '15c8b007-107f-4e64-97c4-9de3168f09c7', 'admin');  
    `)
  },
  
  down: (queryInterface, Sequelize) => {
    return queryInterface.sequelize.query(`
      DELETE FROM users WHERE id = '15c8b007-107f-4e64-97c4-9de3168f09c7';
      DELETE FROM telephones WHERE id = '101971b3-6f2b-43bf-93fb-93f25d8930e3';
    `)
  }
}