const path = require('path');
const dotenv = require('dotenv');

dotenv.config({ path: path.resolve(process.cwd(), '.env') });

module.exports = {
  port: Number(process.env.PORT || 3000),
  afadUrl: process.env.AFAD_URL || 'https://deprem.afad.gov.tr/apiv2/event/filter',
  mgmUrl: process.env.MGM_URL || 'https://servis.mgm.gov.tr',
  ibbUrl: process.env.IBB_URL || 'https://api.ibb.gov.tr',
  namazUrl: process.env.NAMAZ_URL || 'https://vakit.vercel.app',
  tcmbUrl: process.env.TCMB_URL || 'https://www.tcmb.gov.tr/kurlar/today.xml',
};
