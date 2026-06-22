// Factory penyimpanan berbasis file JSON (dipakai ulang oleh tiap resource).
const fs = require('fs');
const path = require('path');

function createStore(fileName, buildEntity) {
  const dataFile = path.join(__dirname, '..', 'data', fileName);

  const read = () => {
    try {
      return JSON.parse(fs.readFileSync(dataFile, 'utf-8'));
    } catch (_) {
      return [];
    }
  };
  const write = (list) =>
    fs.writeFileSync(dataFile, JSON.stringify(list, null, 2), 'utf-8');
  const genId = (prefix) =>
    `${prefix}_${Date.now().toString(36)}${Math.random().toString(36).slice(2, 6)}`;

  return {
    getAll: () => read(),
    getById: (id) => read().find((x) => x.id === id) || null,
    create: (payload) => {
      const list = read();
      const entity = buildEntity(payload, genId);
      list.push(entity);
      write(list);
      return entity;
    },
    update: (id, payload) => {
      const list = read();
      const idx = list.findIndex((x) => x.id === id);
      if (idx === -1) return null;
      const updated = { ...list[idx], ...payload, id: list[idx].id };
      list[idx] = updated;
      write(list);
      return updated;
    },
    remove: (id) => {
      const list = read();
      const idx = list.findIndex((x) => x.id === id);
      if (idx === -1) return false;
      list.splice(idx, 1);
      write(list);
      return true;
    },
  };
}

module.exports = { createStore };
