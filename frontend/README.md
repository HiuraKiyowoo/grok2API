# Frontend Grok2API

Frontend Grok2API adalah SPA administrasi untuk mengelola pool akun, routing model, client key, audit request, dan pengaturan runtime.

## Teknologi

- React 19 dan TypeScript
- Vite 8 dan Tailwind CSS
- shadcn/ui dan Radix UI
- TanStack Query, React Hook Form, dan Zod

## Development Lokal

Jalankan backend Go dari root repository terlebih dahulu, lalu jalankan frontend:

```bash
cd frontend
npm install
npm run dev
```

Server development berjalan di `http://127.0.0.1:5173` dan meneruskan `/api`, `/v1`, `/healthz`, serta `/readyz` ke `http://127.0.0.1:8000`.

Untuk memakai alamat backend lain:

```bash
VITE_DEV_API_TARGET=http://127.0.0.1:9000 npm run dev
```

## Build Produksi

```bash
npm run build
```

Hasil build berada di `dist/`. Backend menyajikan direktori ini pada origin yang sama berdasarkan `frontend.staticPath` di konfigurasi root dan menyediakan fallback SPA untuk path non-API. Frontend tidak membaca YAML secara langsung; informasi runtime publik diberikan melalui endpoint backend yang terkontrol.

## Struktur Kode

```text
src/app/             route dan app shell
src/features/        halaman dan interaksi berdasarkan fitur
src/entities/        DTO domain dan interface query
src/shared/          API, autentikasi, konfigurasi, komponen, utilitas
src/components/ui/   komponen dasar shadcn/ui
```

Semua request bisnis melewati `shared/api`. State server dikelola oleh TanStack Query. Halaman hanya menyusun fitur dan tidak menggandakan request, autentikasi, atau formatter.

## Validasi

```bash
npm run lint
npm run build
```
