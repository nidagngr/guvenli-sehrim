const { http } = require('../utils/http');

const prayerNames = [
  ['imsak', 'imsak'],
  ['gunes', 'gunes'],
  ['ogle', 'ogle'],
  ['ikindi', 'ikindi'],
  ['aksam', 'aksam'],
  ['yatsi', 'yatsi'],
];

function toDateTime(date, time) {
  return new Date(`${date}T${time}:00+03:00`);
}

function computeNextPrayer(times, todayDate) {
  const now = new Date();

  for (const [key] of prayerNames) {
    const at = toDateTime(todayDate, times[key]);
    if (at > now) {
      return {
        nextPrayer: key,
        remainingSeconds: Math.max(0, Math.floor((at.getTime() - now.getTime()) / 1000)),
      };
    }
  }

  const tomorrowImsak = toDateTime(todayDate, times.imsak);
  tomorrowImsak.setDate(tomorrowImsak.getDate() + 1);
  return {
    nextPrayer: 'imsak',
    remainingSeconds: Math.max(0, Math.floor((tomorrowImsak.getTime() - now.getTime()) / 1000)),
  };
}

async function resolveDistrict(city) {
  const response = await http.get('https://ezanvakti.imsakiyem.com/api/locations/search/districts', {
    params: { q: city },
  });

  const matches = response.data?.data || [];
  const normalizedCity = city.trim().toLowerCase();
  const exactMatch = matches.find((item) => String(item.name || '').trim().toLowerCase() === normalizedCity);
  return exactMatch || matches[0];
}

async function getPrayerTimes(city = 'Istanbul') {
  const district = await resolveDistrict(city);
  if (!district?._id) {
    throw new Error(`Namaz verisi icin ilce bulunamadi: ${city}`);
  }

  const response = await http.get(`https://ezanvakti.imsakiyem.com/api/prayer-times/${district._id}/weekly`);
  const data = response.data?.data || [];
  const today = data[0];

  if (!today) {
    throw new Error(`Namaz verisi bulunamadi: ${city}`);
  }

  const todayDate = String(today.miladi_tarih_uzun_iso8601 || today.miladi_tarih_kisa_iso8601 || new Date().toISOString()).slice(0, 10);
  const next = computeNextPrayer(today, todayDate);

  return {
    city: district.name,
    date: todayDate,
    nextPrayer: next.nextPrayer,
    remainingSeconds: next.remainingSeconds,
    times: prayerNames.map(([name, key]) => ({ name, time: today[key] })),
    weekly: data.slice(0, 7).map((item) => ({
      city: district.name,
      date: String(item.miladi_tarih_uzun_iso8601 || item.miladi_tarih_kisa_iso8601 || new Date().toISOString()),
      times: prayerNames.map(([name, key]) => ({ name, time: item[key] })),
    })),
    meta: { source: 'imsakiyem', cached: false },
  };
}

module.exports = { getPrayerTimes };
