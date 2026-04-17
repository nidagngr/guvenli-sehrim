const { cache } = require('../config/cache');

async function cacheFetch(key, ttlSeconds, task) {
  const cached = cache.get(key);
  if (cached) {
    return { ...cached, meta: { ...(cached.meta || {}), cached: true } };
  }

  const data = await task();
  cache.set(key, data, ttlSeconds);
  return { ...data, meta: { ...(data.meta || {}), cached: false } };
}

module.exports = { cacheFetch };
