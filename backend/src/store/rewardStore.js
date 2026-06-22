// Penyimpanan reward (voucher & nutrisi).
const { createStore } = require('./jsonStore');

module.exports = createStore('rewards.json', (payload, genId) => ({
  id: genId('rwd'),
  name: String(payload.name || '').trim(),
  cost: Number.isFinite(payload.cost) ? payload.cost : 0,
  category: payload.category === 'nutrition' ? 'nutrition' : 'voucher',
  createdAt: new Date().toISOString(),
}));
