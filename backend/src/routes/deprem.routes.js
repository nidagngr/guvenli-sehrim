const express = require('express');
const { cacheFetch } = require('../utils/cacheFetch');
const { getEarthquakes } = require('../services/afad.service');

const router = express.Router();

router.get('/', async (req, res, next) => {
  try {
    const limit = Number(req.query.limit || 20);
    const data = await cacheFetch(`deprem:${limit}`, 300, () => getEarthquakes(limit));
    res.json(data);
  } catch (error) {
    next(error);
  }
});

module.exports = router;
