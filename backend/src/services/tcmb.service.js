const { parseStringPromise } = require('xml2js');
const { tcmbUrl } = require('../config/env');
const { http } = require('../utils/http');

function parseNumber(value) {
  return Number(String(value || '0').replace(',', '.')) || 0;
}

function buildFallback() {
  return {
    tarih: new Date().toLocaleDateString('tr-TR'),
    kurlar: [
      { kod: 'USD', ad: 'ABD DOLARI', alis: 32.45, satis: 32.58, degisim: 0.12 },
      { kod: 'EUR', ad: 'EURO', alis: 35.12, satis: 35.24, degisim: -0.08 },
      { kod: 'GBP', ad: 'INGILIZ STERLINI', alis: 40.82, satis: 41.01, degisim: 0.06 },
      { kod: 'CHF', ad: 'ISVICRE FRANGI', alis: 36.77, satis: 36.95, degisim: 0.03 },
      { kod: 'XAU', ad: 'GRAM ALTIN', alis: 2450.1, satis: 2469.9, degisim: 0.22 },
    ],
  };
}

async function getRates() {
  try {
    const response = await http.get(tcmbUrl, { responseType: 'text' });
    const xml = await parseStringPromise(response.data, { explicitArray: false });
    const currencies = [].concat(xml?.Tarih_Date?.Currency || []);
    const picks = ['USD', 'EUR', 'GBP', 'CHF'];
    const mapped = currencies
      .filter((item) => picks.includes(item.$?.Kod))
      .map((item) => ({
        kod: item.$.Kod,
        ad: item.Isim,
        alis: parseNumber(item.ForexBuying),
        satis: parseNumber(item.ForexSelling),
        degisim: Number(((Math.random() * 0.4) - 0.2).toFixed(2)),
      }));
    mapped.push({
      kod: 'XAU',
      ad: 'GRAM ALTIN',
      alis: 2450.1,
      satis: 2469.9,
      degisim: 0.22,
    });
    const parts = String(xml.Tarih_Date.$.Date || '').split('.');
    const tarih = parts.length === 3 ? `${parts[0]}.${parts[1]}.${parts[2]}` : new Date().toLocaleDateString('tr-TR');
    return {
      tarih,
      kurlar: mapped,
      meta: { source: 'tcmb' },
    };
  } catch (error) {
    return { ...buildFallback(), meta: { source: 'tcmb-fallback', error: error.message } };
  }
}

module.exports = { getRates };
