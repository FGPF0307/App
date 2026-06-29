// =====================================================================
// FitArena - XP / Level / Badge Engine
// Semua perhitungan game-balance dijalankan di sini (sisi Express.js).
// Murni fungsi (tanpa I/O) supaya mudah diuji & dipakai ulang.
// =====================================================================

// --- Matriks XP dasar tiap aksi ---
const BASE_XP = {
  join: 100,    // menyelesaikan sesi sebagai peserta
  host: 150,    // membuat sesi (host)
  checkin: 25,  // check-in tepat waktu (<= 15 menit sebelum mulai)
};

const LEVEL_CAP = 99;

// --- 10 Tier kasta (index 0..9) ---
const TIERS = [
  'SPARK',          // 1-10
  'HABIT BUILDER',  // 11-20
  'KINETIC',        // 21-30
  'IRON CORE',      // 31-40
  'ELITE STRIDER',  // 41-50
  'APEX',           // 51-60
  'VANGUARD',       // 61-70
  'INFINITE',       // 71-80
  'OVERLORD',       // 81-90
  'ABSOLUTE MASTER',// 91-99
];

/** XP yang dibutuhkan untuk naik dari level L ke L+1. */
function xpRequired(level) {
  return level * 150 + 500;
}

/** Nama tier berdasarkan level. */
function tierForLevel(level) {
  const idx = Math.min(Math.floor((Math.max(1, level) - 1) / 10), TIERS.length - 1);
  return TIERS[idx];
}

/** Pengganda streak: +5% per hari, maksimal 1.5x. */
function streakMultiplier(streak) {
  const m = 1.0 + Math.max(0, streak) * 0.05;
  return Math.min(m, 1.5);
}

/** XP final setelah dikali multiplier streak (dibulatkan). */
function computeXpGain(action, streak) {
  const base = BASE_XP[action] || 0;
  return Math.round(base * streakMultiplier(streak));
}

/**
 * Tambahkan XP ke profil dan selesaikan kenaikan level.
 * Mengembalikan { level, currentXp, xpToNext, leveledUp }.
 */
function resolveLevel(level, currentXp, gainedXp) {
  let lvl = level;
  let xp = currentXp + gainedXp;
  let leveledUp = false;
  while (lvl < LEVEL_CAP && xp >= xpRequired(lvl)) {
    xp -= xpRequired(lvl);
    lvl += 1;
    leveledUp = true;
  }
  if (lvl >= LEVEL_CAP) {
    lvl = LEVEL_CAP;
    xp = Math.min(xp, xpRequired(lvl)); // tidak overflow di level cap
  }
  return { level: lvl, currentXp: xp, xpToNext: xpRequired(lvl), leveledUp };
}

/**
 * Update streak harian berdasarkan tanggal aktivitas terakhir.
 * today & last dalam format 'YYYY-MM-DD'.
 */
function updateStreak(currentStreak, lastActiveDate, today) {
  if (!lastActiveDate) return 1;
  if (lastActiveDate === today) return currentStreak; // sudah aktif hari ini
  const yesterday = (() => {
    const d = new Date(today + 'T00:00:00Z');
    d.setUTCDate(d.getUTCDate() - 1);
    return d.toISOString().slice(0, 10);
  })();
  if (lastActiveDate === yesterday) return currentStreak + 1;
  return 1; // streak putus
}

// --- Definisi 6 badge Badge Gallery & target progresnya ---
const BADGE_TARGETS = {
  DYNAMIC_DUO: 60, // sesi grup (>=2 peserta) selesai
  EARLY_BIRD: 20, // sesi mulai 04:00-06:30
  TRENDSETTER: 20, // host terisi >=80%
  ACTIVE_FOLLOWERS: 20, // ikut sesi orang lain (joiner)
  IRON_STREAK: 14, // streak harian 14 hari
  COMMUNITY_HOPPER: 20, // lokasi unik
};

/** True jika waktu (jam,menit) berada di jendela 04:00-06:30. */
function isEarlyWindow(hour, minute) {
  if (typeof hour !== 'number') return false;
  const t = hour * 60 + (minute || 0);
  return t >= 4 * 60 && t <= 6 * 60 + 30;
}

/**
 * Evaluasi badge yang seharusnya terbuka berdasarkan progres tiap metrik.
 * `stats.locations_count` = jumlah lokasi unik.
 * Mengembalikan array key badge yang memenuhi syarat.
 */
function evaluateBadges(stats) {
  const earned = [];
  if ((stats.bg_dynamic_duo || 0) >= BADGE_TARGETS.DYNAMIC_DUO) earned.push('DYNAMIC_DUO');
  if ((stats.bg_early_bird || 0) >= BADGE_TARGETS.EARLY_BIRD) earned.push('EARLY_BIRD');
  if ((stats.bg_trendsetter || 0) >= BADGE_TARGETS.TRENDSETTER) earned.push('TRENDSETTER');
  if ((stats.bg_active_followers || 0) >= BADGE_TARGETS.ACTIVE_FOLLOWERS) earned.push('ACTIVE_FOLLOWERS');
  if ((stats.current_streak || 0) >= BADGE_TARGETS.IRON_STREAK) earned.push('IRON_STREAK');
  if ((stats.locations_count || 0) >= BADGE_TARGETS.COMMUNITY_HOPPER) earned.push('COMMUNITY_HOPPER');
  return earned;
}

module.exports = {
  BASE_XP,
  TIERS,
  LEVEL_CAP,
  BADGE_TARGETS,
  xpRequired,
  tierForLevel,
  streakMultiplier,
  computeXpGain,
  resolveLevel,
  updateStreak,
  isEarlyWindow,
  evaluateBadges,
};
