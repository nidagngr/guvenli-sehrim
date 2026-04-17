const cron = require('node-cron');
const { cache } = require('../config/cache');
const { getEarthquakes } = require('../services/afad.service');
const { getWeather } = require('../services/mgm.service');
const { getAqi } = require('../services/ibb.service');
const { getPrayerTimes } = require('../services/namaz.service');
const { getRates } = require('../services/tcmb.service');

function warm(key, ttlSeconds, task) {
  return task().then((data) => cache.set(key, data, ttlSeconds)).catch(() => null);
}

function startScheduler() {
  cron.schedule('*/2 * * * *', () => warm('deprem:20', 300, () => getEarthquakes(20)));
  cron.schedule('*/15 * * * *', () => warm('hava:Ankara', 1800, () => getWeather('Ankara')));
  cron.schedule('*/15 * * * *', () => warm('aqi:Kadikoy', 900, () => getAqi('Kadikoy')));
  cron.schedule('*/30 * * * *', () => warm('namaz:Istanbul', 1800, () => getPrayerTimes('Istanbul')));
  cron.schedule('0 * * * *', () => warm('doviz:gunluk', 3600, getRates));
}

module.exports = { startScheduler };
