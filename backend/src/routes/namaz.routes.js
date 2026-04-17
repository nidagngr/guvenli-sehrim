const express = require('express');
const { cacheFetch } = require('../utils/cacheFetch');
const { getPrayerTimes } = require('../services/namaz.service');

const router = express.Router();

router.get('/', async (req, res, next) => {
  try {
    const city = String(req.query.city || 'Istanbul');
    const data = await cacheFetch(`namaz:${city}`, 1800, () => getPrayerTimes(city));
    res.json(data);
  } catch (error) {
    next(error);
  }
});

module.exports = router;
