module.exports = {
  up: (queryInterface, Sequelize) => {
    const Icd11 = require('./medical_icd11.json').medical_icd11
    let icd11Array = []
    Icd11.forEach((icd11) => {
      icd11Array.push({
        id: icd11['id'],
        releaseURI: icd11['releaseURI'],
        code: icd11['code'],
        title: icd11['title'],
        type: icd11['type'],
        parent: icd11['parent'],
        definition: icd11['definition'],
        inclusions: icd11['inclusions'],
        exclusions: icd11['exclusions'],
        indexTerms: icd11['indexTerms'],
        version: icd11['version']
      })
    })
    return queryInterface.bulkInsert('medical_icd11', icd11Array)
  },
  
  down: (queryInterface, Sequelize) => {
    return queryInterface.bulkDelete('medical_icd11', null)
  }
}