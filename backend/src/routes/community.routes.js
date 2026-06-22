// RESTful routes untuk resource "communities".
const { makeController, makeCrudRouter } = require('../lib/crudFactory');
const store = require('../store/communityStore');

module.exports = makeCrudRouter(makeController(store, 'Community', 'title'));
