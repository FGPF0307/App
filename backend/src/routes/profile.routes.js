// RESTful routes untuk resource "profiles" (XP / level / badge).
const express = require('express');
const { getProfile, awardXp } = require('../controllers/profile.controller');

const router = express.Router();

router.get('/:userId', getProfile);
router.post('/:userId/award', awardXp);

module.exports = router;
