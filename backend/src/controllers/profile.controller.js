// Controller profil: menjalankan logika XP/level/badge lalu menulis ke Supabase.
const supabase = require('../lib/supabase');
const {
  computeXpGain,
  resolveLevel,
  updateStreak,
  tierForLevel,
  isEarlyWindow,
  evaluateBadges,
} = require('../lib/xpEngine');

function num(v, fallback = 0) {
  return Number.isFinite(Number(v)) ? Number(v) : fallback;
}

async function getProfile(req, res, next) {
  try {
    if (!supabase) {
      return res.status(503).json({ success: false, error: 'Supabase belum dikonfigurasi di server (.env).' });
    }
    const { data, error } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', req.params.userId)
      .maybeSingle();
    if (error) throw error;
    if (!data) return res.status(404).json({ success: false, error: 'Profil tidak ditemukan.' });
    return res.json({ success: true, data });
  } catch (e) {
    next(e);
  }
}

// POST /api/profiles/:userId/award
// body: { action: 'join'|'host'|'checkin', startHour?, rewardPoints?, minutes? }
async function awardXp(req, res, next) {
  try {
    if (!supabase) {
      return res.status(503).json({ success: false, error: 'Supabase belum dikonfigurasi di server (.env).' });
    }

    const { userId } = req.params;
    const action = String(req.body.action || '').toLowerCase();
    if (!['join', 'host', 'checkin'].includes(action)) {
      return res.status(400).json({ success: false, error: "action harus 'join', 'host', atau 'checkin'." });
    }
    const startHour = req.body.startHour != null ? num(req.body.startHour, null) : null;
    const startMinute = num(req.body.startMinute, 0);
    const spotsFilled = num(req.body.spotsFilled, 0);
    const spotsTotal = num(req.body.spotsTotal, 0);
    const location = (req.body.location || '').toString().trim();
    const rewardPoints = num(req.body.rewardPoints, 0);
    const minutes = num(req.body.minutes, 0);

    // 1) Ambil profil saat ini
    const { data: p, error: readErr } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', userId)
      .maybeSingle();
    if (readErr) throw readErr;
    if (!p) return res.status(404).json({ success: false, error: 'Profil tidak ditemukan.' });

    // Pakai tanggal lokal device bila valid (YYYY-MM-DD); jika tidak, tanggal server.
    const clientDate = String(req.body.clientDate || '');
    const today = /^\d{4}-\d{2}-\d{2}$/.test(clientDate)
      ? clientDate
      : new Date().toISOString().slice(0, 10);

    // 2) Multiplier memakai streak SEBELUM update (sesuai contoh kasus spec)
    const gainedXp = computeXpGain(action, p.current_streak || 0);

    // 3) Selesaikan kenaikan level
    const lv = resolveLevel(p.level || 1, p.current_xp || 0, gainedXp);

    // 4) Update streak harian
    const newStreak = updateStreak(p.current_streak || 0, p.last_active_date, today);

    // 5) Hitung statistik sesi
    const isSession = action === 'join' || action === 'host';
    const sessionsCompleted = (p.sessions_completed || 0) + (isSession ? 1 : 0);
    const sessionsHosted = (p.sessions_hosted || 0) + (action === 'host' ? 1 : 0);

    // 6) Progres 6 badge (Badge Gallery)
    // 01 DYNAMIC DUO: sesi grup (>=2 peserta)
    const isGroup = spotsTotal >= 2;
    const bgDynamicDuo = (p.bg_dynamic_duo || 0) + (isSession && isGroup ? 1 : 0);

    // 02 EARLY BIRD: sesi mulai 04:00-06:30
    const isEarly = isSession && isEarlyWindow(startHour, startMinute);
    const bgEarlyBird = (p.bg_early_bird || 0) + (isEarly ? 1 : 0);

    // 03 TRENDSETTER: host dengan kuota terisi >=80%
    const fillRatio = spotsTotal > 0 ? spotsFilled / spotsTotal : 0;
    const isFullHost = action === 'host' && fillRatio >= 0.8;
    const bgTrendsetter = (p.bg_trendsetter || 0) + (isFullHost ? 1 : 0);

    // 04 ACTIVE FOLLOWERS: ikut sesi sebagai joiner
    const bgActiveFollowers = (p.bg_active_followers || 0) + (action === 'join' ? 1 : 0);

    // 06 COMMUNITY HOPPER: kumpulan lokasi unik
    const existingLocs = Array.isArray(p.bg_locations) ? p.bg_locations : [];
    const bgLocations =
      isSession && location && !existingLocs.includes(location)
        ? [...existingLocs, location]
        : existingLocs;

    // 7) Susun statistik baru lalu evaluasi badge (05 IRON STREAK pakai current_streak)
    const stats = {
      bg_dynamic_duo: bgDynamicDuo,
      bg_early_bird: bgEarlyBird,
      bg_trendsetter: bgTrendsetter,
      bg_active_followers: bgActiveFollowers,
      current_streak: newStreak,
      locations_count: bgLocations.length,
    };
    const qualified = evaluateBadges(stats);
    const existing = Array.isArray(p.badges) ? p.badges : [];
    const mergedBadges = Array.from(new Set([...existing, ...qualified]));
    const newBadges = qualified.filter((b) => !existing.includes(b));

    // 8) Tulis kembali ke Supabase
    const updatePayload = {
      level: lv.level,
      current_xp: lv.currentXp,
      xp_to_next: lv.xpToNext,
      title: tierForLevel(lv.level),
      current_streak: newStreak,
      last_active_date: today,
      sessions_completed: sessionsCompleted,
      sessions_hosted: sessionsHosted,
      points_total: (p.points_total || 0) + rewardPoints,
      minutes_training: (p.minutes_training || 0) + minutes,
      bg_dynamic_duo: bgDynamicDuo,
      bg_early_bird: bgEarlyBird,
      bg_trendsetter: bgTrendsetter,
      bg_active_followers: bgActiveFollowers,
      bg_locations: bgLocations,
      badges: mergedBadges,
    };

    const { data: updated, error: writeErr } = await supabase
      .from('profiles')
      .update(updatePayload)
      .eq('id', userId)
      .select()
      .single();
    if (writeErr) throw writeErr;

    return res.json({
      success: true,
      data: {
        ...updated,
        gainedXp,
        leveledUp: lv.leveledUp,
        newBadges,
      },
    });
  } catch (e) {
    next(e);
  }
}

module.exports = { getProfile, awardXp };
