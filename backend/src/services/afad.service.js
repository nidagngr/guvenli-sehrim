const { afadUrl } = require('../config/env');
const { http } = require('../utils/http');

function normalizeItem(item, index) {
  return {
    id: String(item.eventID || item.eventId || index),
    location: item.location || item.place || 'Türkiye',
    province: item.province || item.city || 'Türkiye',
    district: item.district || '',
    magnitude: Number(item.magnitude || item.mag || item.ml || 0),
    depth: Number(item.depth || 0),
    latitude: Number(item.latitude || 39.925533),
    longitude: Number(item.longitude || 32.866287),
    type: item.type || 'ML',
    date: item.date || item.eventDate || new Date().toISOString(),
  };
}

function buildFallback() {
  const now = Date.now();
  const names = [
    ['Marmara Denizi', 'İstanbul', 'Silivri'],
    ['Ankara', 'Ankara', 'Cankaya'],
    ['İzmir', 'İzmir', 'Bornova'],
    ['Kahramanmaras', 'Kahramanmaras', 'Elbistan'],
    ['Van', 'Van', 'Edremit'],
  ];
  return Array.from({ length: 12 }).map((_, index) => {
    const [location, province, district] = names[index % names.length];
    return {
      id: `fallback-${index}`,
      location,
      province,
      district,
      magnitude: Number((2.5 + (index % 5) * 0.4).toFixed(1)),
      depth: 5 + index,
      latitude: 39 + index * 0.1,
      longitude: 32 + index * 0.1,
      type: 'ML',
      date: new Date(now - index * 36e5).toISOString(),
    };
  });
}

async function getEarthquakes(limit = 20) {
  try {
    const response = await http.get(afadUrl, { params: { limit } });
    const rawList = Array.isArray(response.data)
      ? response.data
      : response.data?.items || response.data?.result || [];
    const items = rawList.slice(0, limit).map(normalizeItem);
    return {
      items,
      summary: {
        count: items.length,
        maxMagnitude: items.reduce((acc, item) => Math.max(acc, item.magnitude), 0),
        lastUpdate: new Date().toISOString(),
      },
      meta: { source: 'afad' },
    };
  } catch (error) {
    const items = buildFallback().slice(0, limit);
    return {
      items,
      summary: {
        count: items.length,
        maxMagnitude: items.reduce((acc, item) => Math.max(acc, item.magnitude), 0),
        lastUpdate: new Date().toISOString(),
      },
      meta: { source: 'afad-fallback', error: error.message },
    };
  }
}

module.exports = { getEarthquakes };
