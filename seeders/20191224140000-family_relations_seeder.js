module.exports = {
  up: (queryInterface, Sequelize) => {
    const family_relations = require('./family_relations.json').family_relations
    let relationsArray = []
    family_relations.forEach((relation) => {
      relationsArray.push({
        id: relation['id'],
        name: relation['name'],
        associations: relation['associations']
      })
    })
    return queryInterface.bulkInsert('family_relations', relationsArray)
  },
  
  down: (queryInterface, Sequelize) => {
    return queryInterface.bulkDelete('family_relations', null)
  }
}