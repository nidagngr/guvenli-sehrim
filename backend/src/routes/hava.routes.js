const express = require('express');
const { cacheFetch } = require('../utils/cacheFetch');
const { getWeather } = require('../services/mgm.service');

const router = express.Router();

router.get('/', async (req, res, next) => {
  try {
    const city = String(req.query.city || 'Ankara');
    const data = await cacheFetch(`hava:${city}`, 1800, () => getWeather(city));
    res.json(data);
  } catch (error) {
    next(error);
  }
});

module.exports = router;
