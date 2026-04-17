const { http } = require('../utils/http');

function normalizeItem(feature, index) {
  const props = feature.properties || {};
  const coordinates = feature.geometry?.coordinates || [];
  const place = String(props.place || 'Turkey');
  const segments = place.split(',').map((item) => item.trim()).filter(Boolean);
  const province = segments.at(-1) || 'Turkey';

  return {
    id: String(feature.id || props.code || index),
    location: place,
    province,
    district: segments.length > 1 ? segments[0] : '',
    magnitude: Number(props.mag || 0),
    depth: Number(coordinates[2] || 0),
    latitude: Number(coordinates[1] || 39.925533),
    longitude: Number(coordinates[0] || 32.866287),
    type: String(props.magType || 'M'),
    date: new Date(props.time || Date.now()).toISOString(),
  };
}

async function getEarthquakes(limit = 20) {
  const response = await http.get('https://earthquake.usgs.gov/fdsnws/event/1/query', {
    params: {
      format: 'geojson',
      orderby: 'time',
      limit,
      minlatitude: 35,
      maxlatitude: 43,
      minlongitude: 25,
      maxlongitude: 45,
      eventtype: 'earthquake',
    },
  });

  const items = (response.data?.features || []).map(normalizeItem);
  return {
    items,
    summary: {
      count: items.length,
      maxMagnitude: items.reduce((acc, item) => Math.max(acc, item.magnitude), 0),
      lastUpdate: new Date().toISOString(),
    },
    meta: { source: 'usgs', cached: false },
  };
}

module.exports = { getEarthquakes };
