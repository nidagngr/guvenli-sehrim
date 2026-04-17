const { http } = require('../utils/http');

function weatherCodeToDescription(code) {
  const map = {
    0: { description: 'Acik', icon: 'sunny' },
    1: { description: 'Parcali bulutlu', icon: 'partly_cloudy' },
    2: { description: 'Bulutlu', icon: 'cloudy' },
    3: { description: 'Cok bulutlu', icon: 'cloudy' },
    45: { description: 'Sisli', icon: 'fog' },
    48: { description: 'Kirağı sisli', icon: 'fog' },
    51: { description: 'Hafif cise', icon: 'rainy' },
    53: { description: 'Cise', icon: 'rainy' },
    55: { description: 'Yogun cise', icon: 'rainy' },
    61: { description: 'Hafif yagmur', icon: 'rainy' },
    63: { description: 'Yagmur', icon: 'rainy' },
    65: { description: 'Kuvvetli yagmur', icon: 'rainy' },
    71: { description: 'Hafif kar', icon: 'snowy' },
    73: { description: 'Kar', icon: 'snowy' },
    75: { description: 'Yogun kar', icon: 'snowy' },
    80: { description: 'Sagank yagmur', icon: 'rainy' },
    81: { description: 'Yagmur gecisleri', icon: 'rainy' },
    82: { description: 'Kuvvetli saganak', icon: 'rainy' },
    95: { description: 'Firtina', icon: 'storm' },
  };

  return map[code] || { description: 'Bilinmiyor', icon: 'cloudy' };
}

async function resolveCity(city) {
  const response = await http.get('https://geocoding-api.open-meteo.com/v1/search', {
    params: {
      name: city,
      count: 1,
      language: 'tr',
      countryCode: 'TR',
    },
  });

  const match = response.data?.results?.[0];
  if (!match) {
    throw new Error(`Sehir bulunamadi: ${city}`);
  }

  return {
    city: match.name,
    latitude: match.latitude,
    longitude: match.longitude,
  };
}

async function getWeather(city = 'Ankara') {
  const location = await resolveCity(city);
  const response = await http.get('https://api.open-meteo.com/v1/forecast', {
    params: {
      latitude: location.latitude,
      longitude: location.longitude,
      current: 'temperature_2m,apparent_temperature,relative_humidity_2m,pressure_msl,wind_speed_10m,wind_direction_10m,weather_code',
      hourly: 'temperature_2m,weather_code',
      daily: 'temperature_2m_max,temperature_2m_min,weather_code',
      forecast_days: 5,
      timezone: 'Europe/Istanbul',
    },
  });

  const current = response.data?.current || {};
  const daily = response.data?.daily || {};
  const hourly = response.data?.hourly || {};
  const currentCode = weatherCodeToDescription(Number(current.weather_code));

  return {
    city: location.city,
    merkezId: null,
    current: {
      sicaklik: Number(current.temperature_2m || 0),
      hissedilen: Number(current.apparent_temperature || 0),
      nem: Number(current.relative_humidity_2m || 0),
      ruzgarHizi: Number(current.wind_speed_10m || 0),
      ruzgarYonu: Number(current.wind_direction_10m || 0),
      basinc: Number(current.pressure_msl || 0),
      durumKodu: String(current.weather_code || ''),
      aciklama: currentCode.description,
      icon: currentCode.icon,
      olcumZamani: current.time || new Date().toISOString(),
    },
    hourly: (hourly.time || []).slice(0, 8).map((time, index) => {
      const hourlyCode = weatherCodeToDescription(Number(hourly.weather_code?.[index]));
      return {
        saat: String(time).slice(11, 16),
        sicaklik: Number(hourly.temperature_2m?.[index] || 0),
        icon: hourlyCode.icon,
      };
    }),
    daily: (daily.time || []).slice(0, 5).map((time, index) => {
      const dailyCode = weatherCodeToDescription(Number(daily.weather_code?.[index]));
      return {
        gun: new Date(time).toLocaleDateString('tr-TR', { weekday: 'short' }),
        min: Number(daily.temperature_2m_min?.[index] || 0),
        max: Number(daily.temperature_2m_max?.[index] || 0),
        icon: dailyCode.icon,
      };
    }),
    favorites: ['Istanbul', 'Bitlis', 'Izmir'],
    meta: { source: 'open-meteo', cached: false },
  };
}

module.exports = { getWeather };
