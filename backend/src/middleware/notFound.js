// Middleware untuk route yang tidak terdaftar.
module.exports = (req, res) => {
  res.status(404).json({
    success: false,
    error: `Route tidak ditemukan: ${req.method} ${req.originalUrl}`,
  });
};
