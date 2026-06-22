// Factory controller + router CRUD generik dengan response JSON terstruktur.

function makeController(store, label, requiredField) {
  return {
    list: (req, res) => {
      const data = store.getAll();
      res.json({ success: true, count: data.length, data });
    },
    getOne: (req, res) => {
      const item = store.getById(req.params.id);
      if (!item) {
        return res.status(404).json({ success: false, error: `${label} tidak ditemukan` });
      }
      res.json({ success: true, data: item });
    },
    create: (req, res) => {
      if (requiredField) {
        const value = req.body ? req.body[requiredField] : null;
        if (!value || !String(value).trim()) {
          return res
              .status(400)
              .json({ success: false, error: `Field "${requiredField}" wajib diisi` });
        }
      }
      const created = store.create(req.body || {});
      res.status(201).json({ success: true, message: `${label} dibuat`, data: created });
    },
    update: (req, res) => {
      const updated = store.update(req.params.id, req.body || {});
      if (!updated) {
        return res.status(404).json({ success: false, error: `${label} tidak ditemukan` });
      }
      res.json({ success: true, message: `${label} diperbarui`, data: updated });
    },
    remove: (req, res) => {
      const ok = store.remove(req.params.id);
      if (!ok) {
        return res.status(404).json({ success: false, error: `${label} tidak ditemukan` });
      }
      res.json({ success: true, message: `${label} dihapus` });
    },
  };
}

function makeCrudRouter(controller) {
  const router = require('express').Router();
  router.get('/', controller.list);
  router.post('/', controller.create);
  router.get('/:id', controller.getOne);
  router.put('/:id', controller.update);
  router.delete('/:id', controller.remove);
  return router;
}

module.exports = { makeController, makeCrudRouter };
