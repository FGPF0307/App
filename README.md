<div align="center">

<img src="assets/icon/fitarena_logo.png" width="120" alt="FitArena Logo"/>

# FitArena

**Find your squad. Book your spot. Level up your fitness.**

Aplikasi mobile hybrid (Flutter) untuk menemukan, membuat, dan bergabung ke sesi
olahraga bersama komunitas — lengkap dengan peta lokasi, chat komunitas, sistem
level/XP, dan reward.

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Backend](https://img.shields.io/badge/Backend-Node.js%20%2B%20Express-339933?logo=node.js)](https://nodejs.org)
[![Auth](https://img.shields.io/badge/Auth-Supabase-3ECF8E?logo=supabase)](https://supabase.com)

</div>

---

## 📖 Tentang Proyek

**FitArena** adalah aplikasi sosial-kebugaran yang menghubungkan orang-orang yang
ingin berolahraga bersama. Pengguna dapat menemukan sesi olahraga (lari, basket,
badminton, dll.) di sekitar mereka melalui peta, mengamankan slot (*secure a spot*),
membuat sesi sendiri sebagai *host*, dan berinteraksi dengan komunitas melalui chat.
Aktivitas berolahraga memberi **XP**, **level**, **badge**, dan **reward points**
yang dapat ditukarkan di reward store.

Proyek ini dibuat untuk mata kuliah **Mobile Hybrid Solution** dan menerapkan
arsitektur **client–server (RESTful API)** yang dipisah dari aplikasi mobile.

---

## ✨ Fitur Utama

| Tab | Fitur |
|-----|-------|
| 🏠 **Home** | Dashboard kebugaran: ringkasan aktivitas, sesi rekomendasi, dan akses cepat. |
| 🗺️ **Map** | Peta interaktif (OpenStreetMap) berisi lokasi sesi olahraga di sekitar pengguna. |
| ⚡ **Session** | Jelajahi semua sesi, **buat sesi (Host)**, dan **gabung sesi (Join)** dengan secure-spot. |
| 💬 **Social** | Komunitas/squad, buat squad baru, daftar pesan (buddy messages), dan chatroom (grup & personal). |
| 👤 **Profile** | Profil pengguna, **level evolution**, **badge gallery**, **fitness summary**, dan **my rewards**. |

Fitur pendukung:
- 🔐 Autentikasi (Sign Up / Sign In / Sign Out) via **Supabase Auth**.
- 🔄 Data sesi, komunitas, dan reward dilayani oleh **REST API** (Create, Read, Update, Delete).
- 🎨 Desain konsisten dengan font kustom (Bebas Neue & JetBrains Mono) dan navigasi bawah animatif.

---

## 🏗️ Arsitektur

FitArena memisahkan **frontend (Flutter)** dari **backend (REST API)**, dengan
**Supabase** menangani autentikasi.

```
┌─────────────────────────┐        HTTP/JSON         ┌──────────────────────────┐
│   FitArena Mobile App    │ ───────────────────────▶ │   Backend REST API        │
│   (Flutter / Dart)       │   GET/POST/PUT/DELETE     │   (Node.js + Express)     │
│                          │ ◀─────────────────────── │   port :3000              │
│  • UI & State            │                          │  • /api/sessions          │
│  • services/*_api.dart   │                          │  • /api/communities       │
└───────────┬─────────────┘                          │  • /api/rewards           │
            │                                         │   data: file JSON         │
            │  Auth (sign in/up/out)                  └──────────────────────────┘
            ▼
┌─────────────────────────┐
│       Supabase           │
│   (Authentication)       │
└─────────────────────────┘
```

- **Frontend** memanggil REST API lewat lapisan `lib/services/` (`session_api.dart`,
  `reward_api.dart`, `api_config.dart`).
- **Backend** menyimpan data pada file JSON (`backend/src/data/*.json`) melalui pola
  *CRUD factory* yang reusable untuk setiap resource.
- **Supabase** dipakai khusus untuk autentikasi pengguna.

---

## 🧰 Tech Stack

**Mobile (frontend)**
- Flutter (Dart SDK `^3.10.8`)
- `supabase_flutter` — autentikasi
- `flutter_map` + `latlong2` — peta OpenStreetMap
- `image_picker` — unggah foto squad
- `http` — komunikasi REST API
- `device_preview`, `animations`

**Backend**
- Node.js + Express 5
- `cors` — akses lintas origin dari aplikasi
- Penyimpanan data berbasis file JSON

---

## 📂 Struktur Proyek

```
fitarenaapp/
├── lib/
│   ├── main.dart                    # Entry point (Splash → Landing → Login → Home)
│   ├── Pages/
│   │   ├── main_navigation.dart     # Bottom navigation (5 tab)
│   │   ├── splash_screen.dart
│   │   ├── LandingPages/            # Onboarding
│   │   ├── HomePages/               # Dashboard
│   │   ├── MapPages/                # Peta sesi
│   │   ├── SessionPages/            # Explore / Host / Join sesi
│   │   ├── SocialPages/             # Hub, komunitas, chatroom
│   │   ├── ProfilePages/            # Profil, level, badge, reward
│   │   └── SignUpandSigninPage/
│   ├── services/                    # Lapisan REST API + konfigurasi
│   └── widgets/                     # Komponen reusable
├── backend/                         # REST API (Node.js + Express)
│   └── src/
│       ├── server.js / app.js
│       ├── routes/  controllers/  store/  data/  middleware/
├── assets/                          # Gambar, ikon, font
└── docs/
    └── FitArena_Manual_Guide.pdf    # Panduan instalasi & penggunaan
```

---

## 🚀 Quick Start

> 📘 **Panduan lengkap (instalasi, setup database, dan cara pemakaian) ada di
> [`docs/FitArena_Manual_Guide.pdf`](docs/FitArena_Manual_Guide.pdf).**

**1. Jalankan backend**
```bash
cd backend
npm install
cp .env.example .env   # lalu isi SUPABASE_SERVICE_ROLE_KEY (untuk fitur XP/level)
npm start              # http://localhost:3000
```

**2. Jalankan aplikasi Flutter**
```bash
flutter pub get
flutter run
```

**3. Sesuaikan base URL API** (di `lib/services/api_config.dart`)

| Target run | Base URL |
|------------|----------|
| Chrome / Windows / iOS sim | `http://localhost:3000` |
| Android Emulator | `http://10.0.2.2:3000` |
| HP fisik (USB/Wi-Fi) | `http://<IP-komputer>:3000` |

---

## 🗄️ Setup Database / Data

FitArena memakai dua sumber data:

1. **Supabase (Auth)** — buat project Supabase, lalu isi `url` & `publishableKey`
   di `lib/main.dart`. Aktifkan Email auth di dashboard Supabase.
2. **Backend JSON store** — data sesi/komunitas/reward sudah tersedia sebagai file
   contoh di `backend/src/data/`. Tidak perlu instalasi database tambahan; data
   otomatis terbaca/tertulis saat API berjalan.

Langkah detail (termasuk tangkapan layar dan troubleshooting) ada di **Manual Guide PDF**.

---

## 🔌 API Endpoints

Base URL: `http://localhost:3000`

| Method | Endpoint | Keterangan |
|--------|----------|------------|
| GET | `/api/health` | Cek server hidup |
| GET | `/api/sessions` | Daftar semua sesi |
| GET | `/api/sessions/:id` | Detail satu sesi |
| POST | `/api/sessions` | Buat sesi |
| PUT | `/api/sessions/:id` | Update sesi |
| DELETE | `/api/sessions/:id` | Hapus sesi |
| POST | `/api/sessions/:id/join` | Gabung sesi (spotsFilled +1) |
| GET/POST/PUT/DELETE | `/api/communities` | CRUD komunitas |
| GET/POST/PUT/DELETE | `/api/rewards` | CRUD reward |
| GET | `/api/profiles/:userId` | Ambil profil (level, XP, badge) |
| POST | `/api/profiles/:userId/award` | Hitung & beri XP (`join`/`host`/`checkin`) → tulis ke Supabase |

Format response:
```json
{ "success": true,  "data": { } }
{ "success": false, "error": "pesan error" }
```

---

## 🎮 Sistem Gamifikasi (XP, Level, Badge)

Logika perhitungan dijalankan di **backend Express** ([backend/src/lib/xpEngine.js](backend/src/lib/xpEngine.js)) lalu hasilnya ditulis ke tabel `profiles` Supabase.

**Perolehan XP** (XP dasar × multiplier streak):

| Aksi | XP Dasar |
|------|----------|
| Join sesi | +100 |
| Host sesi | +150 |
| Check-in tepat waktu | +25 |

- **Multiplier streak** = `min(1.0 + streak × 0.05, 1.5)` (maks 1.5× pada hari ke-10).
- **Kenaikan level**: `XP_dibutuhkan(L) = (L × 150) + 500` (Level 1 → 650 XP).
- **10 Tier**: Spark → Habit Builder → Kinetic → Iron Core → Elite Strider → Apex → Vanguard → Infinite → Overlord → Absolute Master.

**Badge Gallery** (6 lencana, terbuka otomatis saat target tercapai):

| # | Badge | Target | Logika |
|---|-------|--------|--------|
| 01 | DYNAMIC DUO | 60 sesi | sesi grup (>=2 peserta) selesai |
| 02 | EARLY BIRD | 20 sesi | sesi mulai 04:00-06:30 |
| 03 | TRENDSETTER | 20 sesi | host dengan kuota terisi >=80% |
| 04 | ACTIVE FOLLOWERS | 20 sesi | ikut sesi orang lain (joiner) |
| 05 | IRON STREAK | 14 hari | streak harian beruntun |
| 06 | COMMUNITY HOPPER | 20 lokasi | jumlah lokasi unik (DISTINCT) |

> Skema tabel & langkah setup ada di [supabase/schema.sql](supabase/schema.sql) dan Manual Guide PDF.

## 👥 Kontributor

| GitHub | Nama | NIM |
|--------|------|-----|
| [FGPF0307](https://github.com/FGPF0307) | Farrel Ganendra Putra Fadia | 2802499150 |
| [Ritadolo](https://github.com/Ritadolo) | Aldinh Muhammad Hutawardana | 2802505815 |
| [rynsstuff](https://github.com/rynsstuff) | Rayyan Irfanshah | 2802503021 |
| [RaphaelKaloh](https://github.com/RaphaelKaloh) | Raphael Timothy Marice | 2802510954 |

---

<div align="center">

Dibuat untuk mata kuliah **Mobile Hybrid Solution** · Binus University

</div>
