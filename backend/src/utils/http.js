const axios = require('axios');

const http = axios.create({
  timeout: 12000,
  maxRedirects: 5,
  headers: {
    'User-Agent': 'guvenli-sehirim/1.0',
    Accept: 'application/json, text/plain, */*',
  },
});

module.exports = { http };
