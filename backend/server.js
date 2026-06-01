const express = require('express');
const cors = require('cors');
const mysql = require('mysql2'); // Tangan Kanan: MySQL
const admin = require('firebase-admin'); // Tangan Kiri: Firebase
require('dotenv').config();

const app = express();
app.use(cors());
app.use(express.json());

// ─── 1. INISIASI TANGAN KIRI (FIREBASE CLOUD) ───
const serviceAccount = require('./firebase-key.json');
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});
const firestoreDb = admin.firestore();
console.log('[SYSTEM LOG] ✅ Tangan Kiri: Terhubung ke Awan Firestore!');

// ─── 2. INISIASI TANGAN KANAN (MYSQL LOKAL) ───
const mysqlDb = mysql.createConnection({
  host: process.env.DB_HOST,
  port: process.env.DB_PORT,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME
});

mysqlDb.connect((err) => {
  if (err) {
    console.error('[SYSTEM LOG] ❌ Gagal terhubung ke MySQL:', err.message);
    return;
  }
  console.log('[SYSTEM LOG] ✅ Tangan Kanan: MySQL Terkunci dan Siap!');
});

// ─── 3. RUTE UJI COBA MESIN GANDA ───
app.get('/api/hybrid-status', (req, res) => {
  res.json({
    status: 'success',
    message: 'Arsitektur Hibrida (Express + MySQL + Firebase) Berjalan 100%',
  });
});

// ─── 4. NYALAKAN MESIN ───
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`[SYSTEM LOG] 🚀 Mesin Express menyala kencang di port ${PORT}`);
});