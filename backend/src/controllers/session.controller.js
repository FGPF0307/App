// Logika untuk tiap endpoint. Semua response berformat JSON terstruktur:
//   sukses: { success: true, data, message? }
//   gagal : { success: false, error }
const store = require('../store/sessionStore');

// GET /api/sessions
exports.list = (req, res) => {
  const data = store.getAll();
  res.json({ success: true, count: data.length, data });
};

// GET /api/sessions/:id
exports.getOne = (req, res) => {
  const session = store.getById(req.params.id);
  if (!session) {
    return res.status(404).json({ success: false, error: 'Session tidak ditemukan' });
  }
  res.json({ success: true, data: session });
};

// POST /api/sessions
exports.create = (req, res) => {
  const title = req.body && req.body.title;
  if (!title || !String(title).trim()) {
    return res
        .status(400)
        .json({ success: false, error: 'Field "title" wajib diisi' });
  }
  const created = store.create(req.body);
  res.status(201).json({ success: true, message: 'Session dibuat', data: created });
};

// PUT /api/sessions/:id
exports.update = (req, res) => {
  const updated = store.update(req.params.id, req.body);
  if (!updated) {
    return res.status(404).json({ success: false, error: 'Session tidak ditemukan' });
  }
  res.json({ success: true, message: 'Session diperbarui', data: updated });
};

// DELETE /api/sessions/:id
exports.remove = (req, res) => {
  const ok = store.remove(req.params.id);
  if (!ok) {
    return res.status(404).json({ success: false, error: 'Session tidak ditemukan' });
  }
  res.json({ success: true, message: 'Session dihapus' });
};

// POST /api/sessions/:id/join
exports.join = (req, res) => {
  const session = store.getById(req.params.id);
  if (!session) {
    return res.status(404).json({ success: false, error: 'Session tidak ditemukan' });
  }
  if (session.spotsFilled >= session.spotsTotal) {
    return res.status(409).json({ success: false, error: 'Session sudah penuh' });
  }
  const updated = store.update(session.id, { spotsFilled: session.spotsFilled + 1 });
  res.json({ success: true, message: 'Berhasil join sesi', data: updated });
};
