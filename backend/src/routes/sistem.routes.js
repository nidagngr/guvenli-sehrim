const express = require('express');
const { cache } = require('../config/cache');

const router = express.Router();

router.get('/', (_req, res) => {
  res.json({
    status: 'ok',
    now: new Date().toISOString(),
    cachedKeys: cache.keys(),
  });
});

module.exports = router;
