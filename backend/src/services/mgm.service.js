const { mgmUrl } = require('../config/env');
const { http } = require('../utils/http');

const cityCoords = {
  Ankara: { merkezId: 6 },
  Istanbul: { merkezId: 34 },
  Izmir: { merkezId: 35 },
  Bursa: { merkezId: 16 },
};

function buildWeather(city = 'Ankara') {
  const temperatures = [22, 24, 20, 18, 21, 25];
  return {
    city,
    merkezId: cityCoords[city]?.merkezId || 6,
    current: {
      sicaklik: 22,
      hissedilen: 23,
      nem: 45,
      ruzgarHizi: 12,
      ruzgarYonu: 110,
      basinc: 1013,
      durumKodu: 'A',
      aciklama: 'Acik ve gunesli',
      icon: 'sunny',
      olcumZamani: new Date().toISOString(),
    },
    hourly: Array.from({ length: 8 }).map((_, index) => ({
      saat: `${String((9 + index) % 24).padStart(2, '0')}:00`,
      sicaklik: temperatures[index % temperatures.length],
      icon: index % 3 === 0 ? 'sunny' : index % 3 === 1 ? 'cloudy' : 'rainy',
    })),
    daily: ['Paz', 'Pzt', 'Sal', 'Car', 'Per'].map((gun, index) => ({
      gun,
      min: 14 + index,
      max: 20 + index,
      icon: index === 2 ? 'rainy' : index === 1 ? 'cloudy' : 'sunny',
    })),
    favorites: ['Istanbul', 'Bitlis', 'Izmir'],
  };
}

async function getWeather(city = 'Ankara') {
  const normalizedCity = city[0].toUpperCase() + city.slice(1).toLowerCase();
  try {
    const coord = cityCoords[normalizedCity] || cityCoords.Ankara;
    const response = await http.get(`${mgmUrl}/web/sondurumlar`, {
      params: { merkezid: coord.merkezId },
    });
    const raw = Array.isArray(response.data) ? response.data[0] : response.data;
    const weather = buildWeather(normalizedCity);
    if (raw) {
      weather.current = {
        ...weather.current,
        sicaklik: Number(raw.sicaklik || weather.current.sicaklik),
        hissedilen: Number(raw.hadpilesicaklik || weather.current.hissedilen),
        nem: Number(raw.nem || weather.current.nem),
        ruzgarHizi: Number(raw.rpilesruzgarhizi || raw.ruzgarhiz || weather.current.ruzgarHizi),
        ruzgarYonu: Number(raw.rpilesruzgaryonu || weather.current.ruzgarYonu),
        basinc: Number(raw.rpilesbasinc || raw.basinc || weather.current.basinc),
        durumKodu: raw.hadisekodu || raw.hadiseKodu || weather.current.durumKodu,
        olcumZamani: raw.olcumZamani || weather.current.olcumZamani,
      };
    }
    return { ...weather, meta: { source: 'mgm' } };
  } catch (error) {
    return {
      ...buildWeather(normalizedCity),
      meta: { source: 'mgm-fallback', error: error.message },
    };
  }
}

module.exports = { getWeather };
