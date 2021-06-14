'use strict';

const fetch = require('node-fetch');

const fields = [
  'name',
  'alpha3Code',
  'currencies'
];

const options = {
  hostname: 'restcountries.eu',
  port: 443,
  path: `/rest/v2/all?fields=${fields.join(';')}`,
  method: 'GET',
};

module.exports = {
  up: async(queryInterface, Sequelize) => {
    const res = await fetch(`https://${options.hostname}${options.path}`);
    const json = await res.json();

    await json.forEach(async record => {
      await record.currencies.forEach(async currency_record => {

        if (!currency_record.code || currency_record.code.length > 3) return;
        const currency_db_record = await queryInterface.sequelize.query(`
          WITH new_row AS (
            INSERT INTO currencies ("code", "name", "symbol")
            SELECT '${currency_record.code}', $$${currency_record.name}$$, ${currency_record.symbol ? `'${currency_record.symbol}'` : `null`}
            WHERE NOT EXISTS (SELECT * FROM currencies ct WHERE "code" = '${currency_record.code}')
            RETURNING *
          )
          SELECT * FROM new_row
          UNION
          SELECT * FROM currencies WHERE "code" = '${currency_record.code}';
        `,
        { 
          type: Sequelize.QueryTypes.SELECT
        })
        .catch(ex => console.log(`${currency_record.code}: Currency not saved (${ex})`));
        if (!(currency_db_record && currency_db_record.length > 0 && currency_db_record[0].id)) return;

        const country_db_records = await queryInterface.sequelize.query(`
          SELECT * FROM countries WHERE "iso3Code" = $$${record.alpha3Code}$$;
        `,
        { 
          type: Sequelize.QueryTypes.SELECT
        })
        .catch(ex => console.log(`${currency_record.code}: Country not found (${ex})`));;
        if (!(country_db_records && country_db_records.length > 0 && country_db_records[0].id)) return;

        return queryInterface.sequelize.query(`
          INSERT INTO currency_to_country (country_id, currency_id)
          VALUES (${country_db_records[0].id}, ${currency_db_record[0].id});
        `);
      })
    })
  },
  
  down: async(queryInterface, Sequelize) => {
    await queryInterface.sequelize.query(`
      DELETE FROM currency_to_country;
    `);
    return queryInterface.sequelize.query(`
      DELETE FROM currencies;
    `);
  }
}