const express = require('express');
const { cacheFetch } = require('../utils/cacheFetch');
const { getRates } = require('../services/tcmb.service');

const router = express.Router();

router.get('/', async (_req, res, next) => {
  try {
    const data = await cacheFetch('doviz:gunluk', 3600, getRates);
    res.json(data);
  } catch (error) {
    next(error);
  }
});

module.exports = router;
