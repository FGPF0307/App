// Konfigurasi aplikasi Express: middleware + mount route.
const express = require('express');
const cors = require('cors');

const sessionRoutes = require('./routes/session.routes');
const communityRoutes = require('./routes/community.routes');
const rewardRoutes = require('./routes/reward.routes');
const notFound = require('./middleware/notFound');
const errorHandler = require('./middleware/errorHandler');

const app = express();

// Middleware global
app.use(cors()); // izinkan akses dari aplikasi Flutter (web/mobile)
app.use(express.json()); // parse body JSON

// Root & health-check
app.get('/', (req, res) => {
  res.json({
    success: true,
    name: 'FitArena API',
    version: '1.0.0',
    endpoints: [
      '/api/health',
      '/api/sessions',
      '/api/communities',
      '/api/rewards',
    ],
  });
});

app.get('/api/health', (req, res) => {
  res.json({ success: true, status: 'ok', time: new Date().toISOString() });
});

// Resource routes
app.use('/api/sessions', sessionRoutes);
app.use('/api/communities', communityRoutes);
app.use('/api/rewards', rewardRoutes);

// 404 + error handler (harus paling bawah)
app.use(notFound);
app.use(errorHandler);

module.exports = app;
