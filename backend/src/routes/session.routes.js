// Definisi endpoint RESTful untuk resource "sessions".
const router = require('express').Router();
const controller = require('../controllers/session.controller');

router.get('/', controller.list); // READ semua
router.post('/', controller.create); // CREATE
router.get('/:id', controller.getOne); // READ satu
router.put('/:id', controller.update); // UPDATE
router.delete('/:id', controller.remove); // DELETE
router.post('/:id/join', controller.join); // aksi domain: join sesi (spotsFilled++)

module.exports = router;
