# FitArena Backend API

RESTful API untuk aplikasi mobile FitArena. Dibuat dengan **Node.js + Express.js**,
data disimpan di file JSON (`src/data/sessions.json`) sebagai sumber data terpusat.

## Menjalankan

```bash
cd backend
npm install
npm start        # produksi  -> http://localhost:3000
npm run dev      # mode dev (auto-reload pakai nodemon)
```

## Struktur folder

```
backend/
├── package.json
└── src/
    ├── server.js              # titik masuk (listen)
    ├── app.js                 # konfigurasi Express + middleware
    ├── routes/
    │   └── session.routes.js  # definisi endpoint
    ├── controllers/
    │   └── session.controller.js
    ├── store/
    │   └── sessionStore.js     # CRUD ke file JSON
    ├── data/
    │   └── sessions.json       # sumber data
    └── middleware/
        ├── notFound.js
        └── errorHandler.js
```

## Endpoint (resource: `sessions`)

| Method | Endpoint                 | Keterangan                         |
|--------|--------------------------|------------------------------------|
| GET    | `/api/health`            | cek server hidup                   |
| GET    | `/api/sessions`          | **Read** semua sesi                |
| GET    | `/api/sessions/:id`      | **Read** satu sesi                 |
| POST   | `/api/sessions`          | **Create** sesi baru               |
| PUT    | `/api/sessions/:id`      | **Update** sesi                    |
| DELETE | `/api/sessions/:id`      | **Delete** sesi                    |
| POST   | `/api/sessions/:id/join` | join sesi (spotsFilled + 1)        |

### Format response
```json
// sukses
{ "success": true, "data": { ... } }
// gagal
{ "success": false, "error": "pesan error" }
```

### Contoh body POST/PUT
```json
{
  "title": "MORNING RUN CLUB",
  "location": "IKEA Alam Sutera",
  "day": "Today",
  "startTime": "18.00",
  "endTime": "19.30",
  "image": "https://...",
  "host": "John Greenjim",
  "spotsFilled": 5,
  "spotsTotal": 8,
  "rewardPoints": 200,
  "xp": 300,
  "number": "01"
}
```

## Catatan untuk aplikasi Flutter (base URL)

| Target run            | Base URL                  |
|-----------------------|---------------------------|
| Chrome / Windows / iOS sim | `http://localhost:3000` |
| Android Emulator      | `http://10.0.2.2:3000`    |
| HP fisik (USB/Wi-Fi)  | `http://<IP-komputer>:3000` |
