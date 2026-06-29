# -*- coding: utf-8 -*-
"""Generator PDF Manual Guide FitArena (memakai fpdf2).
Jalankan: python docs/build_manual.py
Output  : docs/FitArena_Manual_Guide.pdf
"""
import os
from fpdf import FPDF

BASE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(BASE)
LOGO = os.path.join(ROOT, "assets", "icon", "fitarena_logo.png")
OUT = os.path.join(BASE, "FitArena_Manual_Guide.pdf")

# Palet warna brand FitArena
GREEN = (4, 57, 39)
CREAM = (225, 220, 211)
DARK = (17, 17, 17)
GRAY = (90, 90, 90)
LIGHT = (245, 243, 239)
BROWN = (158, 110, 56)


def ascii_clean(s: str) -> str:
    """Ganti karakter non-latin1 agar aman untuk core font."""
    repl = {
        "–": "-", "—": "-", "‘": "'", "’": "'",
        "“": '"', "”": '"', "…": "...", "→": "->",
        "•": "-", " ": " ",
    }
    for k, v in repl.items():
        s = s.replace(k, v)
    return s


class Manual(FPDF):
    def header(self):
        if self.page_no() == 1:
            return
        self.set_font("Helvetica", "B", 9)
        self.set_text_color(*GREEN)
        self.set_y(8)
        self.cell(0, 6, "FitArena - Manual Guide", align="L")
        self.set_text_color(*GRAY)
        self.set_font("Helvetica", "", 8)
        self.cell(0, 6, "Mobile Hybrid Solution", align="R", new_x="LMARGIN", new_y="NEXT")
        self.set_draw_color(*CREAM)
        self.set_line_width(0.5)
        self.line(self.l_margin, 16, self.w - self.r_margin, 16)
        self.set_y(22)

    def footer(self):
        if self.page_no() == 1:
            return
        self.set_y(-13)
        self.set_draw_color(*CREAM)
        self.line(self.l_margin, self.get_y(), self.w - self.r_margin, self.get_y())
        self.set_font("Helvetica", "", 8)
        self.set_text_color(*GRAY)
        self.cell(0, 8, "Halaman %d" % self.page_no(), align="C")

    # ---- komponen konten ----
    def h1(self, num, text):
        if self.get_y() > 230:
            self.add_page()
        self.ln(3)
        self.set_fill_color(*GREEN)
        self.set_text_color(255, 255, 255)
        self.set_font("Helvetica", "B", 14)
        self.cell(0, 11, ascii_clean("  %s  %s" % (num, text)),
                  new_x="LMARGIN", new_y="NEXT", fill=True)
        self.ln(3)
        self.set_text_color(*DARK)

    def h2(self, text):
        if self.get_y() > 250:
            self.add_page()
        self.ln(2)
        self.set_text_color(*BROWN)
        self.set_font("Helvetica", "B", 11.5)
        self.cell(0, 7, ascii_clean(text), new_x="LMARGIN", new_y="NEXT")
        self.set_draw_color(*CREAM)
        self.line(self.l_margin, self.get_y(), self.l_margin + 35, self.get_y())
        self.ln(2)
        self.set_text_color(*DARK)

    def body(self, text):
        self.set_font("Helvetica", "", 10.5)
        self.set_text_color(*DARK)
        self.multi_cell(0, 5.6, ascii_clean(text))
        self.ln(1.5)

    def bullet(self, text, level=0):
        self.set_font("Helvetica", "", 10.5)
        self.set_text_color(*DARK)
        indent = 5 + level * 6
        self.set_x(self.l_margin + indent)
        self.cell(5, 5.6, "-")
        self.multi_cell(0, 5.6, ascii_clean(text))
        self.ln(0.5)

    def step(self, n, text):
        self.set_font("Helvetica", "B", 10.5)
        self.set_text_color(*GREEN)
        self.set_x(self.l_margin)
        self.cell(8, 5.6, "%d." % n)
        self.set_font("Helvetica", "", 10.5)
        self.set_text_color(*DARK)
        self.multi_cell(0, 5.6, ascii_clean(text))
        self.ln(1)

    def code(self, lines):
        self.ln(1)
        self.set_font("Courier", "", 9.5)
        self.set_fill_color(*LIGHT)
        self.set_text_color(20, 20, 20)
        for ln in lines:
            self.set_x(self.l_margin)
            self.cell(0, 5.4, ascii_clean("  " + ln), new_x="LMARGIN",
                      new_y="NEXT", fill=True)
        self.ln(2)
        self.set_text_color(*DARK)

    def note(self, text, label="CATATAN"):
        self.ln(1)
        x0, y0 = self.l_margin, self.get_y()
        self.set_font("Helvetica", "B", 9)
        self.set_text_color(*BROWN)
        self.set_x(x0 + 3)
        self.cell(0, 5.4, label, new_x="LMARGIN", new_y="NEXT")
        self.set_font("Helvetica", "", 9.5)
        self.set_text_color(*DARK)
        self.set_x(x0 + 3)
        self.multi_cell(self.w - self.l_margin - self.r_margin - 6, 5.0,
                        ascii_clean(text))
        y1 = self.get_y()
        self.set_draw_color(*BROWN)
        self.set_line_width(1.2)
        self.line(x0, y0, x0, y1)
        self.set_line_width(0.2)
        self.ln(2.5)

    def table(self, headers, rows, widths):
        self.set_font("Helvetica", "B", 9.5)
        self.set_fill_color(*GREEN)
        self.set_text_color(255, 255, 255)
        for h, w in zip(headers, widths):
            self.cell(w, 7, ascii_clean(h), border=0, align="C", fill=True)
        self.ln()
        self.set_text_color(*DARK)
        fill = False
        for row in rows:
            # tinggi baris dinamis
            self.set_font("Helvetica", "", 9)
            line_h = 5.2
            n_lines = 1
            for txt, w in zip(row, widths):
                nl = len(self.multi_cell(w, line_h, ascii_clean(txt), dry_run=True,
                                         output="LINES"))
                n_lines = max(n_lines, nl)
            row_h = line_h * n_lines
            if self.get_y() + row_h > self.h - 20:
                self.add_page()
            x0 = self.get_x()
            y0 = self.get_y()
            self.set_fill_color(*(LIGHT if fill else (255, 255, 255)))
            for txt, w in zip(row, widths):
                x = self.get_x()
                y = self.get_y()
                self.multi_cell(w, line_h, ascii_clean(txt), border=0, fill=True,
                                max_line_height=line_h)
                self.set_xy(x + w, y)
            self.set_xy(x0, y0 + row_h)
            self.set_draw_color(*CREAM)
            self.line(x0, self.get_y(), x0 + sum(widths), self.get_y())
            fill = not fill
        self.ln(3)


pdf = Manual()
pdf.set_auto_page_break(auto=True, margin=18)
pdf.set_margins(18, 22, 18)

# ============ COVER ============
pdf.add_page()
pdf.set_fill_color(*CREAM)
pdf.rect(0, 0, pdf.w, pdf.h, "F")
pdf.set_fill_color(*GREEN)
pdf.rect(0, 0, pdf.w, 14, "F")
pdf.rect(0, pdf.h - 14, pdf.w, 14, "F")
if os.path.exists(LOGO):
    pdf.image(LOGO, x=(pdf.w - 46) / 2, y=58, w=46)
pdf.set_y(112)
pdf.set_font("Helvetica", "B", 40)
pdf.set_text_color(*GREEN)
pdf.cell(0, 18, "FitArena", align="C", new_x="LMARGIN", new_y="NEXT")
pdf.set_font("Helvetica", "B", 15)
pdf.set_text_color(*BROWN)
pdf.cell(0, 9, "MANUAL GUIDE", align="C", new_x="LMARGIN", new_y="NEXT")
pdf.ln(2)
pdf.set_font("Helvetica", "", 11)
pdf.set_text_color(*DARK)
pdf.cell(0, 7, ascii_clean("Panduan Instalasi & Penggunaan Aplikasi"),
         align="C", new_x="LMARGIN", new_y="NEXT")
pdf.cell(0, 7, ascii_clean("(termasuk setup database)"),
         align="C", new_x="LMARGIN", new_y="NEXT")
pdf.ln(14)
pdf.set_font("Helvetica", "", 10)
pdf.set_text_color(*GRAY)
pdf.cell(0, 6, "Mata Kuliah: Mobile Hybrid Solution - Binus University",
         align="C", new_x="LMARGIN", new_y="NEXT")
pdf.cell(0, 6, "Versi Aplikasi 1.0.0", align="C", new_x="LMARGIN", new_y="NEXT")

# ============ DAFTAR ISI ============
pdf.add_page()
pdf.h1("", "Daftar Isi")
toc = [
    ("1.", "Pendahuluan"),
    ("2.", "Prasyarat (Tools yang Diperlukan)"),
    ("3.", "Instalasi Aplikasi"),
    ("   3.1", "Mengunduh Source Code"),
    ("   3.2", "Menyiapkan Backend (REST API)"),
    ("   3.3", "Setup Database (Supabase & JSON Store)"),
    ("   3.4", "Menyiapkan Aplikasi Flutter"),
    ("   3.5", "Menjalankan Aplikasi"),
    ("4.", "Panduan Penggunaan Aplikasi"),
    ("5.", "Sistem XP, Level & Badge"),
    ("6.", "Troubleshooting (Masalah Umum)"),
]
for num, t in toc:
    pdf.set_font("Helvetica", "B" if not num.startswith(" ") else "", 11)
    pdf.set_text_color(*GREEN if not num.startswith(" ") else GRAY)
    pdf.set_text_color(*(GREEN if not num.startswith(" ") else DARK))
    pdf.cell(18, 8, num)
    pdf.cell(0, 8, ascii_clean(t), new_x="LMARGIN", new_y="NEXT")

# ============ 1. PENDAHULUAN ============
pdf.add_page()
pdf.h1("1.", "Pendahuluan")
pdf.body(
    "FitArena adalah aplikasi mobile sosial-kebugaran yang membantu pengguna "
    "menemukan, membuat, dan bergabung ke sesi olahraga bersama komunitas di "
    "sekitar mereka. Aplikasi dibangun dengan Flutter dan terhubung ke backend "
    "RESTful API (Node.js + Express) serta menggunakan Supabase untuk autentikasi.")
pdf.h2("Fitur Utama")
pdf.bullet("Home  : dashboard ringkasan aktivitas kebugaran.")
pdf.bullet("Map   : peta lokasi sesi olahraga (OpenStreetMap).")
pdf.bullet("Session: jelajah sesi, buat sesi (Host), dan gabung sesi (Join).")
pdf.bullet("Social: komunitas/squad, buat squad, dan chatroom grup/personal.")
pdf.bullet("Profile: level/XP, badge, fitness summary, dan reward.")
pdf.note(
    "Aplikasi memakai arsitektur client-server. Backend (REST API) WAJIB "
    "dijalankan lebih dulu agar data sesi, komunitas, dan reward dapat dimuat "
    "di aplikasi.")

# ============ 2. PRASYARAT ============
pdf.h1("2.", "Prasyarat (Tools yang Diperlukan)")
pdf.body("Pastikan perangkat lunak berikut sudah terpasang sebelum memulai:")
pdf.table(
    ["Tool", "Versi Minimum", "Kegunaan"],
    [
        ["Flutter SDK", "3.x (Dart 3.10+)", "Menjalankan aplikasi mobile"],
        ["Node.js + npm", "18 atau lebih baru", "Menjalankan backend REST API"],
        ["Git", "Terbaru", "Mengunduh (clone) source code"],
        ["Android Studio / VS Code", "Terbaru", "Editor + emulator Android"],
        ["Akun Supabase", "Gratis", "Layanan autentikasi (login)"],
    ],
    [42, 40, 92])
pdf.body("Verifikasi instalasi dengan perintah berikut di terminal:")
pdf.code([
    "flutter --version",
    "flutter doctor      # cek kelengkapan environment",
    "node -v",
    "npm -v",
    "git --version",
])

# ============ 3. INSTALASI ============
pdf.add_page()
pdf.h1("3.", "Instalasi Aplikasi")

pdf.h2("3.1  Mengunduh Source Code")
pdf.step(1, "Buka terminal / Command Prompt pada folder kerja Anda.")
pdf.step(2, "Clone repository dari GitHub, lalu masuk ke folder proyek:")
pdf.code([
    "git clone https://github.com/FGPF0307/App.git",
    "cd App/fitarenaapp",
])

pdf.h2("3.2  Menyiapkan Backend (REST API)")
pdf.body("Backend menyediakan data sesi, komunitas, reward, dan menghitung "
         "XP/level/badge melalui REST API.")
pdf.step(1, "Masuk ke folder backend dan pasang dependensi:")
pdf.code(["cd backend", "npm install"])
pdf.step(2, "Buat file .env dari contoh, lalu isi service role key Supabase "
            "(lihat bagian 3.3). Wajib agar fitur XP/level berfungsi:")
pdf.code([
    "copy .env.example .env      # Windows",
    "cp .env.example .env        # Mac/Linux",
])
pdf.step(3, "Jalankan server backend:")
pdf.code([
    "npm start        # mode produksi -> http://localhost:3000",
    "npm run dev      # mode dev (auto-reload dengan nodemon)",
])
pdf.step(4, "Pastikan server hidup dengan membuka URL berikut di browser:")
pdf.code(["http://localhost:3000/api/health"])
pdf.body('Jika muncul respons {"success": true, "status": "ok", ...} berarti '
         "backend sudah berjalan dengan benar.")
pdf.note(
    "Biarkan jendela terminal backend tetap terbuka selama aplikasi digunakan. "
    "Buka terminal BARU untuk langkah berikutnya (aplikasi Flutter).")

pdf.h2("3.3  Setup Database (Supabase & JSON Store)")
pdf.body("FitArena menggunakan dua sumber data:")
pdf.bullet("Supabase  : akun pengguna (autentikasi) + tabel profiles "
           "(nama, level, XP, badge).")
pdf.bullet("JSON Store: data sesi/komunitas/reward yang dilayani backend "
           "(file pada backend/src/data/). Tidak perlu instalasi tambahan.")
pdf.body("Langkah konfigurasi Supabase:")
pdf.step(1, "Buka https://supabase.com lalu buat akun / login dan buat New Project.")
pdf.step(2, "Authentication > Providers > Email: pastikan aktif, dan MATIKAN "
            "'Confirm email' agar akun bisa langsung login setelah daftar.")
pdf.step(3, "Project Settings > API: salin Project URL dan Publishable key, "
            "tempelkan ke lib/main.dart:")
pdf.code([
    "await Supabase.initialize(",
    "  url: 'https://<PROJECT-ANDA>.supabase.co',",
    "  publishableKey: '<PUBLISHABLE-KEY-ANDA>',",
    ");",
])
pdf.step(4, "Buka SQL Editor > New query, salin seluruh isi file "
            "supabase/schema.sql, lalu Run. Ini membuat tabel profiles + "
            "trigger otomatis untuk user baru.")
pdf.step(5, "Untuk fitur XP/level (dihitung di backend): Project Settings > API "
            "> salin service_role key, tempelkan ke backend/.env pada "
            "SUPABASE_SERVICE_ROLE_KEY.")
pdf.note(
    "service_role key bersifat RAHASIA - hanya dipakai di backend (.env yang "
    "tidak di-commit), jangan pernah ditaruh di kode aplikasi Flutter.")

pdf.h2("3.4  Menyiapkan Aplikasi Flutter")
pdf.step(1, "Dari folder fitarenaapp, unduh seluruh dependensi Flutter:")
pdf.code(["flutter pub get"])
pdf.step(2, "Sesuaikan base URL backend di lib/services/api_config.dart "
            "sesuai target perangkat:")
pdf.table(
    ["Target Menjalankan", "Base URL Backend"],
    [
        ["Chrome / Windows / iOS Simulator", "http://localhost:3000"],
        ["Android Emulator", "http://10.0.2.2:3000"],
        ["HP fisik (USB / satu Wi-Fi)", "http://<IP-komputer>:3000"],
    ],
    [90, 84])
pdf.note(
    "Untuk HP fisik, cari IP komputer dengan perintah ipconfig (Windows) atau "
    "ifconfig (Mac/Linux), lalu pastikan HP dan komputer berada di jaringan "
    "Wi-Fi yang sama.")

pdf.h2("3.5  Menjalankan Aplikasi")
pdf.step(1, "Pastikan emulator aktif atau perangkat terhubung:")
pdf.code(["flutter devices"])
pdf.step(2, "Jalankan aplikasi:")
pdf.code(["flutter run"])
pdf.body("Aplikasi akan terbuka dengan urutan: Splash Screen -> Onboarding "
         "-> Halaman Login -> Halaman Utama (Home).")

# ============ 4. PENGGUNAAN ============
pdf.add_page()
pdf.h1("4.", "Panduan Penggunaan Aplikasi")

pdf.h2("4.1  Splash & Onboarding")
pdf.body("Saat dibuka, aplikasi menampilkan splash screen FitArena. Ketuk layar "
         "untuk melanjutkan ke halaman onboarding yang menjelaskan fitur utama, "
         "lalu lanjut ke halaman login.")

pdf.h2("4.2  Daftar Akun & Masuk (Sign Up / Sign In)")
pdf.step(1, "Pada halaman Sign In, pengguna baru memilih opsi daftar (Sign Up).")
pdf.step(2, "Masukkan email dan password, lalu konfirmasi pendaftaran.")
pdf.step(3, "Kembali ke halaman Sign In, masukkan email & password untuk masuk.")
pdf.body("Setelah berhasil, pengguna diarahkan ke halaman utama dengan navigasi "
         "bawah berisi 5 tab: Home, Map, Session, Social, dan Profile.")

pdf.h2("4.3  Home")
pdf.body("Menampilkan dashboard kebugaran: ringkasan aktivitas dan sesi "
         "rekomendasi. Dari sini pengguna bisa langsung menuju detail sesi.")

pdf.h2("4.4  Map")
pdf.body("Menampilkan peta interaktif berisi penanda (marker) lokasi sesi "
         "olahraga. Ketuk marker untuk melihat ringkasan sesi dan membuka "
         "halaman join.")

pdf.h2("4.5  Session (Explore / Host / Join)")
pdf.bullet("Explore All: melihat seluruh daftar sesi yang tersedia.")
pdf.bullet("Host Session: membuat sesi baru - isi judul, lokasi, waktu, jumlah "
           "slot, dan detail lain, lalu simpan (data dikirim ke REST API).")
pdf.bullet("Join Session: membuka detail sesi lalu menekan Secure a Spot untuk "
           "mengamankan slot; jumlah peserta bertambah otomatis.")

pdf.h2("4.6  Social")
pdf.bullet("Sport Communities: melihat squad yang sudah diikuti dan menemukan "
           "squad baru (tekan JOIN untuk bergabung).")
pdf.bullet("Create Squad: tekan tombol + untuk membuat squad baru, lengkap "
           "dengan nama, lokasi, dan foto dari galeri.")
pdf.bullet("Buddy Messages: daftar percakapan dengan teman.")
pdf.bullet("Chatroom: membuka obrolan grup (komunitas) maupun personal, serta "
           "mengirim pesan.")

pdf.h2("4.7  Profile & Rewards")
pdf.bullet("Profil menampilkan level, XP, dan progres pengguna.")
pdf.bullet("Level Evolution: melihat perkembangan level.")
pdf.bullet("Badge Gallery: koleksi lencana yang diraih.")
pdf.bullet("Fitness Summary: ringkasan statistik kebugaran.")
pdf.bullet("My Rewards: menukar reward points yang dikumpulkan.")

pdf.h2("4.8  Keluar (Sign Out)")
pdf.body("Pada halaman Profile, pilih opsi Sign Out untuk keluar dari akun. "
         "Aplikasi akan kembali ke halaman login.")

# ============ 5. SISTEM XP, LEVEL & BADGE ============
pdf.add_page()
pdf.h1("5.", "Sistem XP, Level & Badge")
pdf.body("Logika perhitungan dijalankan di backend Express "
         "(backend/src/lib/xpEngine.js), lalu hasilnya disimpan ke tabel "
         "profiles di Supabase. Aplikasi memanggil endpoint /api/profiles/:id/award "
         "setiap user join atau host sesi.")

pdf.h2("5.1  Perolehan XP")
pdf.body("XP final = XP Dasar x Multiplier Streak.")
pdf.table(
    ["Aksi", "XP Dasar"],
    [
        ["Menyelesaikan sesi (Join)", "+100 XP"],
        ["Membuat sesi (Host)", "+150 XP"],
        ["Check-in tepat waktu", "+25 XP"],
    ],
    [120, 54])
pdf.body("Multiplier Streak = min(1.0 + (streak x 0.05), 1.5). Artinya tiap hari "
         "beruntun menambah 5%, maksimal 1.5x pada hari ke-10.")
pdf.note("Contoh: Host (+150) dengan streak 6 hari -> multiplier 1.3 -> "
         "150 x 1.3 = 195 XP.")

pdf.h2("5.2  Rumus Kenaikan Level")
pdf.body("XP yang dibutuhkan dari level L ke L+1: (L x 150) + 500. Semakin "
         "tinggi level, semakin besar XP yang dibutuhkan.")
pdf.table(
    ["Level", "XP ke Level Berikutnya"],
    [
        ["Level 1", "650 XP"],
        ["Level 2", "800 XP"],
        ["Level 10", "2.000 XP"],
        ["Level 50", "8.000 XP"],
    ],
    [80, 94])

pdf.h2("5.3  10 Tier Kasta")
pdf.body("Spark (1-10) | Habit Builder (11-20) | Kinetic (21-30) | "
         "Iron Core (31-40) | Elite Strider (41-50) | Apex (51-60) | "
         "Vanguard (61-70) | Infinite (71-80) | Overlord (81-90) | "
         "Absolute Master (91-99).")

pdf.h2("5.4  Badge Gallery (6 Lencana)")
pdf.body("Badge terbuka otomatis saat target tercapai:")
pdf.table(
    ["#", "Badge", "Target", "Logika"],
    [
        ["01", "DYNAMIC DUO", "60 sesi", "sesi grup (>=2 peserta) selesai"],
        ["02", "EARLY BIRD", "20 sesi", "sesi mulai 04:00-06:30"],
        ["03", "TRENDSETTER", "20 sesi", "host kuota terisi >=80%"],
        ["04", "ACTIVE FOLLOWERS", "20 sesi", "ikut sesi orang lain (joiner)"],
        ["05", "IRON STREAK", "14 hari", "streak harian beruntun"],
        ["06", "COMMUNITY HOPPER", "20 lokasi", "jumlah lokasi unik (DISTINCT)"],
    ],
    [12, 50, 30, 82])

# ============ 6. TROUBLESHOOTING ============
pdf.add_page()
pdf.h1("6.", "Troubleshooting (Masalah Umum)")
pdf.table(
    ["Masalah", "Solusi"],
    [
        ["Data sesi/komunitas tidak muncul",
         "Pastikan backend berjalan (npm start) dan base URL di api_config.dart "
         "sesuai target perangkat."],
        ["Android emulator tidak bisa konek ke API",
         "Gunakan http://10.0.2.2:3000 (bukan localhost) pada api_config.dart."],
        ["HP fisik tidak bisa konek ke API",
         "Gunakan IP komputer (mis. http://192.168.x.x:3000) dan pastikan satu "
         "jaringan Wi-Fi."],
        ["Gagal login / daftar",
         "Periksa URL & publishableKey Supabase di main.dart dan pastikan "
         "provider Email aktif."],
        ["flutter pub get error",
         "Jalankan flutter clean lalu flutter pub get; pastikan versi Flutter "
         "sesuai prasyarat."],
        ["Port 3000 sudah dipakai",
         "Hentikan proses yang memakai port 3000 atau ubah port pada backend."],
        ["Login 'Invalid login credentials' setelah daftar",
         "Matikan 'Confirm email' di Supabase, lalu jalankan: update auth.users "
         "set email_confirmed_at = now() where email_confirmed_at is null;"],
        ["XP/level tidak bertambah saat join/host",
         "Pastikan backend menyala, SUPABASE_SERVICE_ROLE_KEY terisi di .env, "
         "dan schema.sql sudah dijalankan."],
        ["Nama/level tidak muncul di profil",
         "Jalankan supabase/schema.sql (membuat tabel profiles + trigger), lalu "
         "login ulang."],
    ],
    [58, 116])
pdf.ln(4)
pdf.set_font("Helvetica", "I", 9.5)
pdf.set_text_color(*GRAY)
pdf.multi_cell(0, 5.4, ascii_clean(
    "Dokumen ini merupakan bagian dari proyek FitArena - Mobile Hybrid Solution, "
    "Binus University. Untuk penjelasan teknis lebih lanjut, lihat README.md pada "
    "repository GitHub."))

pdf.output(OUT)
print("PDF dibuat:", OUT)
