const { namazUrl } = require('../config/env');
const { http } = require('../utils/http');

const prayerNames = [
  ['imsak', 'Fajr'],
  ['gunes', 'Sunrise'],
  ['ogle', 'Dhuhr'],
  ['ikindi', 'Asr'],
  ['aksam', 'Maghrib'],
  ['yatsi', 'Isha'],
];

function buildFallback(date = new Date()) {
  return {
    imsak: '04:55',
    gunes: '06:20',
    ogle: '12:52',
    ikindi: '16:29',
    aksam: '19:13',
    yatsi: '20:33',
    tarih: date.toISOString(),
  };
}

function enrichDay(raw, city, offset) {
  const date = new Date();
  date.setDate(date.getDate() + offset);
  const times = prayerNames.map(([key]) => ({ name: key, time: raw[key] }));
  return { city, date: date.toISOString(), times };
}

async function getPrayerTimes(city = 'Istanbul') {
  try {
    const response = await http.get(`${namazUrl}/api/timesFromPlace`, {
      params: { city, country: 'Turkey', days: 7, timezoneOffset: 3 },
    });
    const data = Array.isArray(response.data) ? response.data : response.data?.data || [];
    const first = data[0] || buildFallback();
    return {
      city,
      date: first.tarih || new Date().toISOString(),
      nextPrayer: 'ogle',
      remainingSeconds: 3600,
      times: prayerNames.map(([key]) => ({ name: key, time: first[key] || buildFallback()[key] })),
      weekly: data.slice(0, 7).map((item, index) => enrichDay(item, city, index)),
      meta: { source: 'vakit' },
    };
  } catch (error) {
    const first = buildFallback();
    return {
      city,
      date: first.tarih,
      nextPrayer: 'ogle',
      remainingSeconds: 3600,
      times: prayerNames.map(([key]) => ({ name: key, time: first[key] })),
      weekly: Array.from({ length: 7 }).map((_, index) => enrichDay(first, city, index)),
      meta: { source: 'vakit-fallback', error: error.message },
    };
  }
}

module.exports = { getPrayerTimes };
