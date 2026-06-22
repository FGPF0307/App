// RESTful routes untuk resource "rewards".
const { makeController, makeCrudRouter } = require('../lib/crudFactory');
const store = require('../store/rewardStore');

module.exports = makeCrudRouter(makeController(store, 'Reward', 'name'));
