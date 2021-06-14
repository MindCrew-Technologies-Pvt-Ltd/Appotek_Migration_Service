'use strict';

const { uniqBy } = require('lodash/fp');

const fetch = require('node-fetch');

const fields = [
  'name',
  'alpha2Code',
  'alpha3Code',
  'capital',
  'region',
  'callingCodes',
];

const options = {
  hostname: 'restcountries.eu',
  port: 443,
  path: `/rest/v2/all?fields=${fields.join(';')}`,
  method: 'GET',
};

module.exports = {
  async up(queryInterface) {
    const res = await fetch(`https://${options.hostname}${options.path}`);
    const json = await res.json();

    return queryInterface.bulkInsert(
      'countries',
      uniqBy(({ name }) => name, json).map(
        ({ name, alpha2Code, alpha3Code, capital, region, callingCodes }) => ({
          name,
          isoCode: alpha2Code,
          iso3Code: alpha3Code,
          capital,
          region,
          phoneCodes: callingCodes,
          launched: false,
        }),
      ),
      {},
    );
  },

  down: queryInterface => queryInterface.bulkDelete('countries', null, {}),
};
