// Titik masuk server — menyalakan HTTP listener.
const app = require('./app');

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`🚀 FitArena API berjalan di http://localhost:${PORT}`);
  console.log(`   Coba: http://localhost:${PORT}/api/sessions`);
});
