module.exports = {
  up: (queryInterface, Sequelize) => {
    return queryInterface.sequelize.query(`
        UPDATE family_relations SET associations = ARRAY[3,4] WHERE id = 1;
        UPDATE family_relations SET associations = ARRAY[3,4] WHERE id = 2;
        UPDATE family_relations SET associations = ARRAY[1,2] WHERE id = 3;
        UPDATE family_relations SET associations = ARRAY[1,2] WHERE id = 4;
        UPDATE family_relations SET associations = ARRAY[5,6] WHERE id = 5;
        UPDATE family_relations SET associations = ARRAY[5,6] WHERE id = 6;
        UPDATE family_relations SET associations = ARRAY[30,31] WHERE id = 28;
        UPDATE family_relations SET associations = ARRAY[30,31] WHERE id = 29;
        UPDATE family_relations SET associations = ARRAY[28,29] WHERE id = 30;
        UPDATE family_relations SET associations = ARRAY[28,29] WHERE id = 31;
        UPDATE family_relations SET associations = ARRAY[32,33] WHERE id = 32;
        UPDATE family_relations SET associations = ARRAY[32,33] WHERE id = 33;
        UPDATE family_relations SET associations = ARRAY[34,35] WHERE id = 34;
        UPDATE family_relations SET associations = ARRAY[34,35] WHERE id = 35;
    `)
  },
  
  down: (queryInterface, Sequelize) => {
    return queryInterface.sequelize.query(`
        UPDATE family_relations SET associations = ARRAY[3,4,30,31] WHERE id = 1;
        UPDATE family_relations SET associations = ARRAY[3,4,30,31] WHERE id = 2;
        UPDATE family_relations SET associations = ARRAY[1,2,28,29] WHERE id = 3;
        UPDATE family_relations SET associations = ARRAY[1,2,28,29] WHERE id = 4;
        UPDATE family_relations SET associations = ARRAY[5,6,32,33,34,35] WHERE id = 5;
        UPDATE family_relations SET associations = ARRAY[5,6,32,33,34,35] WHERE id = 6;
        UPDATE family_relations SET associations = ARRAY[3,4,30,31] WHERE id = 28;
        UPDATE family_relations SET associations = ARRAY[3,4,30,31] WHERE id = 29;
        UPDATE family_relations SET associations = ARRAY[1,2,28,29] WHERE id = 30;
        UPDATE family_relations SET associations = ARRAY[1,2,28,29] WHERE id = 31;
        UPDATE family_relations SET associations = ARRAY[5,6,32,33,34,35] WHERE id = 32;
        UPDATE family_relations SET associations = ARRAY[5,6,32,33,34,35] WHERE id = 33;
        UPDATE family_relations SET associations = ARRAY[5,6,32,33,34,35] WHERE id = 34;
        UPDATE family_relations SET associations = ARRAY[5,6,32,33,34,35] WHERE id = 35;
    `)
  }
}