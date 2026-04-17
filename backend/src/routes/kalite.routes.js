const express = require('express');
const { cacheFetch } = require('../utils/cacheFetch');
const { getAqi } = require('../services/ibb.service');

const router = express.Router();

router.get('/', async (req, res, next) => {
  try {
    const station = String(req.query.station || 'Kadikoy');
    const data = await cacheFetch(`aqi:${station}`, 900, () => getAqi(station));
    res.json(data);
  } catch (error) {
    next(error);
  }
});

module.exports = router;
