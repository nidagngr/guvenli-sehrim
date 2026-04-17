const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');

const depremRoutes = require('./routes/deprem.routes');
const havaRoutes = require('./routes/hava.routes');
const kaliteRoutes = require('./routes/kalite.routes');
const namazRoutes = require('./routes/namaz.routes');
const dovizRoutes = require('./routes/doviz.routes');
const sistemRoutes = require('./routes/sistem.routes');

const app = express();

app.use(cors());
app.use(helmet());
app.use(express.json());
app.use(morgan('dev'));

app.use('/deprem', depremRoutes);
app.use('/hava', havaRoutes);
app.use('/kalite', kaliteRoutes);
app.use('/namaz', namazRoutes);
app.use('/doviz', dovizRoutes);
app.use('/sistem', sistemRoutes);

app.use((error, _req, res, _next) => {
  res.status(500).json({
    message: 'Beklenmeyen bir hata olustu.',
    detail: error.message,
  });
});

module.exports = { app };
