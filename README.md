<div align="center">

<img src="assets/icon/fitarena_logo.png" width="120" alt="FitArena Logo"/>

FitArena

Find your squad. Book your spot. Level up your fitness.

Aplikasi mobile hybrid (Flutter) untuk menemukan, membuat, dan bergabung ke sesi
olahraga bersama komunitas — lengkap dengan peta lokasi, chat komunitas, sistem
level/XP, dan reward.

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Backend](https://img.shields.io/badge/Backend-Node.js%20%2B%20Express-339933?logo=node.js)](https://nodejs.org)
[![Auth](https://img.shields.io/badge/Auth-Supabase-3ECF8E?logo=supabase)](https://supabase.com)

📖 Tentang Proyek

FitArena adalah aplikasi sosial-kebugaran yang menghubungkan orang-orang yang
ingin berolahraga bersama. Pengguna dapat menemukan sesi olahraga (lari, basket,
badminton, dll.) di sekitar mereka melalui peta, mengamankan slot (*secure a spot*),
membuat sesi sendiri sebagai *host*, dan berinteraksi dengan komunitas melalui chat.
Aktivitas berolahraga memberi **XP**, **level**, **badge**, dan **reward points**
yang dapat ditukarkan di reward store.

Proyek ini dibuat untuk mata kuliah Mobile Hybrid Solution dan menerapkan
arsitektur client–server (RESTful API) yang dipisah dari aplikasi mobile.


## ✨ Fitur Utama

| 🏠 **Home** | Dashboard kebugaran: ringkasan aktivitas, sesi rekomendasi, dan akses cepat. |
| 🗺️ **Map** | Peta interaktif (OpenStreetMap) berisi lokasi sesi olahraga di sekitar pengguna. |
| ⚡ **Session** | Jelajahi semua sesi, **buat sesi (Host)**, dan **gabung sesi (Join)** dengan secure-spot. |
| 💬 **Social** | Komunitas/squad, buat squad baru, daftar pesan (buddy messages), dan chatroom (grup & personal). |
| 👤 **Profile** | Profil pengguna, **level evolution**, **badge gallery**, **fitness summary**, dan **my rewards**. |

## 📂 Struktur Proyek

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

## 👥 Kontributor

| GitHub | Nama | NIM |
|--------|------|-----|
| [FGPF0307](https://github.com/FGPF0307) | Farrel Ganendra Putra Fadia | 2802499150 |
| [Ritadolo](https://github.com/Ritadolo) | Aldinh Muhammad Hutawardana | 2802505815 |
| [rynsstuff](https://github.com/rynsstuff) | Rayyan Irfanshah | 2802503021 |
| [RaphaelKaloh](https://github.com/RaphaelKaloh) | Raphael Timothy Marice | 2802510954 |

## CARA MENJALANKAN FITARENA  
PENTING: Jalankan Backend (API) terlebih dahulu, baru aplikasi Flutter.  

1. DOWNLOAD SOURCE CODE  
Buka terminal/CMD.  
Ketik: git clone [https://github.com/FGPF0307/App.git](https://github.com/FGPF0307/App.git)  
Masuk ke folder: cd App/fitarenaapp  

2. JALANKAN BACKEND (Node.js)  
Masuk folder backend: cd backend  
  
Install dependensi: npm install  
  
Buat file .env (copy dari .env.example).(jika saat cek di folder backend->.env nya kosong isi dengan yang di bawah ini)  
Buka .env dan isi dengan:  
SUPABASE_URL=https://lloibeyejbqfqklnimtn.supabase.co  
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imxsb2liZXllamJxZnFrbG5pbXRuIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc4MDI5NjQyNywiZXhwIjoyMDk1ODcyNDI3fQ.hjeszdFxyxEc3Hm9IDDmGxbnbIPEs9db3-o_XNGlCUM  
PORT=3000  
  
  
Jalankan server: npm run dev  
  
3. JALANKAN FLUTTER  
(Buka Terminal/CMD BARU)  
Pastikan berada di folder utama: cd App/fitarenaapp  
Download dependensi: flutter pub get  
Jalankan aplikasi: flutter run -d chrome  
  
4. AKUN DEMO (Level 99 & Full Badge)  
Email : demo@fitarena.com  
Pass  : demo12345  
  
<div align="center">  
  
</div>  
