// Penyimpanan komunitas (grup chat olahraga).
const { createStore } = require('./jsonStore');

module.exports = createStore('communities.json', (payload, genId) => ({
  id: genId('com'),
  title: String(payload.title || '').trim(),
  members: payload.members || '1 Member',
  location: payload.location || '',
  lastMessage: payload.lastMessage || '',
  imageUrl: payload.imageUrl || '',
  createdAt: new Date().toISOString(),
}));
