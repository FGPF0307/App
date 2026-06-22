// Penyimpanan data berbasis file JSON (sumber data terpusat).
// Semua operasi CRUD membaca/menulis ke src/data/sessions.json.
const fs = require('fs');
const path = require('path');

const DATA_FILE = path.join(__dirname, '..', 'data', 'sessions.json');

function _read() {
  try {
    return JSON.parse(fs.readFileSync(DATA_FILE, 'utf-8'));
  } catch (_) {
    return [];
  }
}

function _write(list) {
  fs.writeFileSync(DATA_FILE, JSON.stringify(list, null, 2), 'utf-8');
}

function _genId() {
  return 'ses_' + Date.now().toString(36) + Math.random().toString(36).slice(2, 6);
}

function getAll() {
  return _read();
}

function getById(id) {
  return _read().find((s) => s.id === id) || null;
}

function create(payload) {
  const list = _read();
  const session = {
    id: _genId(),
    title: String(payload.title).trim(),
    location: payload.location || '',
    day: payload.day || 'Today',
    startTime: payload.startTime || '00.00',
    endTime: payload.endTime || '00.00',
    image: payload.image || '',
    host: payload.host || 'Anonymous',
    spotsFilled: Number.isFinite(payload.spotsFilled) ? payload.spotsFilled : 1,
    spotsTotal: Number.isFinite(payload.spotsTotal) ? payload.spotsTotal : 6,
    rewardPoints: Number.isFinite(payload.rewardPoints) ? payload.rewardPoints : 200,
    xp: Number.isFinite(payload.xp) ? payload.xp : 300,
    number: payload.number || '',
    createdAt: new Date().toISOString(),
  };
  list.push(session);
  _write(list);
  return session;
}

function update(id, payload) {
  const list = _read();
  const idx = list.findIndex((s) => s.id === id);
  if (idx === -1) return null;
  // gabungkan field lama dengan payload; id tidak boleh berubah
  const updated = { ...list[idx], ...payload, id: list[idx].id };
  list[idx] = updated;
  _write(list);
  return updated;
}

function remove(id) {
  const list = _read();
  const idx = list.findIndex((s) => s.id === id);
  if (idx === -1) return false;
  list.splice(idx, 1);
  _write(list);
  return true;
}

module.exports = { getAll, getById, create, update, remove };
