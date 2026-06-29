// Klien Supabase sisi server memakai SERVICE ROLE key (bypass RLS) agar
// backend bisa membaca/menulis tabel `profiles` milik user mana pun.
// Kredensial diambil dari environment (.env) - jangan hardcode service key.
require('dotenv').config();
const { createClient } = require('@supabase/supabase-js');

const url = process.env.SUPABASE_URL;
const serviceKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

let supabase = null;
if (url && serviceKey) {
  supabase = createClient(url, serviceKey, {
    auth: { persistSession: false, autoRefreshToken: false },
  });
} else {
  console.warn(
    '[FitArena] SUPABASE_URL / SUPABASE_SERVICE_ROLE_KEY belum di-set di .env. ' +
      'Endpoint XP (/api/profiles) tidak akan berfungsi sampai diisi.'
  );
}

module.exports = supabase;
