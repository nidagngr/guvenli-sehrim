const { app } = require('./app');
const { port } = require('./config/env');
const { startScheduler } = require('./jobs/scheduler');

app.listen(port, () => {
  startScheduler();
  console.log(`Guvenli Sehirim backend ${port} portunda calisiyor.`);
});
