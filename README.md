# PT. Kaliman Karya - Website & Admin Panel

Website perusahaan konstruksi profesional dengan sistem manajemen konten (CMS) yang lengkap.

## 🚀 Fitur Utama

### Website Publik
- **Landing Page Modern**: Desain responsif dengan animasi dan micro-interactions
- **Layanan Konstruksi**: Showcase layanan residensial, komersial, dan renovasi
- **Portfolio Proyek**: Galeri proyek dengan filter kategori
- **Testimoni Klien**: Review dan rating dari klien
- **Form Kontak**: Sistem quote request terintegrasi
- **SEO Optimized**: Meta tags, structured data, dan sitemap

### Admin Panel (CMS)
- **Dashboard Analytics**: Statistik website dan performa konten
- **Manajemen Post**: Editor konten dengan preview dan scheduling
- **Media Library**: Upload dan organisasi file media
- **Kategori & Tags**: Sistem kategorisasi konten
- **Manajemen Komentar**: Moderasi dan approval komentar
- **User Management**: Kontrol akses dan role management
- **Editorial Calendar**: Perencanaan dan penjadwalan konten
- **System Settings**: Konfigurasi website dan email

## 🛠️ Teknologi

- **Frontend**: React 18 + TypeScript + Vite
- **Styling**: Tailwind CSS
- **Icons**: Lucide React
- **Routing**: React Router DOM
- **Forms**: React Hook Form + Yup validation
- **File Upload**: React Dropzone
- **Date Handling**: date-fns

## 📦 Instalasi

1. **Clone repository**
   ```bash
   git clone <repository-url>
   cd kalimankarya.co.id
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Setup environment variables**
   ```bash
   cp .env.example .env
   # Edit .env dengan konfigurasi Anda
   ```

4. **Jalankan development server**
   ```bash
   npm run dev
   # Atau untuk akses dari network
   npm run dev:host
   ```

## 🌐 Deployment ke aaPanel

### Persiapan Server
1. **Install Node.js** di aaPanel (versi 18+)
2. **Setup domain** kalimankarya.co.id
3. **Konfigurasi SSL** certificate

### Build & Deploy
1. **Clone repository ke server**
   ```bash
   git clone <repository-url>
   cd kalimankarya.co.id
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Setup environment variables**
   ```bash
   cp .env.example .env
   # Edit .env dengan konfigurasi production
   ```

4. **Build production**
   ```bash
   npm run build:prod
   ```

2. **Upload ke server**
   - Upload folder `dist/` ke document root domain
   - Atau setup sebagai Node.js application

3. **Konfigurasi Web Server**
   - Setup reverse proxy jika menggunakan Node.js
   - Atau serve static files dari folder `dist/`

### Environment Variables Production
```env
VITE_APP_URL=https://kalimankarya.co.id
VITE_API_URL=https://api.kalimankarya.co.id
VITE_SITE_NAME=PT. Kaliman Karya
VITE_CONTACT_EMAIL=info@kalimankarya.co.id
VITE_ADMIN_EMAIL=admin@kalimankarya.co.id
# ... konfigurasi lainnya
```

## 🔐 Admin Panel

### Akses Admin
- **URL**: `https://kalimankarya.co.id/admin`
- **Email**: `admin@kalimankarya.co.id`
- **Password**: `admin123!`

### Fitur Admin
- **Dashboard**: Overview statistik dan aktivitas
- **Posts**: Manajemen artikel dan konten
- **Media**: Upload dan organisasi file
- **Categories**: Kategori konten
- **Tags**: Label dan tag konten
- **Comments**: Moderasi komentar
- **Users**: Manajemen pengguna
- **Analytics**: Laporan performa website
- **Calendar**: Penjadwalan konten
- **Settings**: Konfigurasi sistem

## 📱 Responsive Design

Website dioptimalkan untuk semua ukuran layar:
- **Mobile**: 320px - 768px
- **Tablet**: 768px - 1024px
- **Desktop**: 1024px+

## 🎨 Design System

- **Colors**: Blue primary, Orange accent
- **Typography**: System fonts dengan 3 weights
- **Spacing**: 8px grid system
- **Components**: Reusable UI components
- **Animations**: Smooth transitions dan hover effects

## 📊 SEO Features

- **Meta Tags**: Dynamic title, description, keywords
- **Open Graph**: Social media sharing optimization
- **Schema.org**: Structured data untuk search engines
- **Sitemap**: Auto-generated XML sitemap
- **Performance**: Optimized loading dan caching

## 🔧 Development

### Scripts Available
```bash
npm run dev          # Development server
npm run dev:host     # Dev server dengan network access
npm run build        # TypeScript compilation + Vite build
npm run build:prod   # Production build dengan optimizations
npm run build:server # Build for server deployment
npm run preview      # Preview production build
npm run preview:host # Preview dengan network access
npm run lint         # ESLint check
npm run deploy       # Full deployment build
```

### Project Structure
```
src/
├── components/          # React components
│   ├── admin/          # Admin panel components
│   └── public/         # Public website components
├── contexts/           # React contexts
├── hooks/             # Custom React hooks
├── services/          # API services
├── types/             # TypeScript types
├── utils/             # Utility functions
├── index.css          # Global styles
└── main.tsx           # App entry point
```

## 🤝 Contributing

1. Fork repository
2. Create feature branch
3. Commit changes
4. Push to branch
5. Create Pull Request

## 📄 License

Copyright © 2024 PT. Kaliman Karya. All rights reserved.

## 📞 Support

Untuk bantuan teknis atau pertanyaan:
- **Domain**: kalimankarya.co.id
- **Server IP**: 147.93.81.43
- **Email**: admin@kalimankarya.co.id
- **Phone**: +62 21-5555-0123
- **WhatsApp**: +62 812-3456-7890
- **Emergency**: +62 815-9876-5432

## 🌐 Server Information

- **Domain**: kalimankarya.co.id
- **Server IP**: 147.93.81.43
- **Document Root**: /www/wwwroot/kalimankarya.co.id
- **DNS**: Cloudflare (asa.ns.cloudflare.com, otto.ns.cloudflare.com)

## 🚀 Production Deployment

### Build for Production
```bash
npm run build:prod
# or
npm run deploy
```

### Server Setup (Direct on Server)
1. **Connect to server**
   ```bash
   ssh root@kalimankarya.co.id
   cd /www/wwwroot/kalimankarya.co.id
   ```

2. **Install dependencies on server**
   ```bash
   npm install
   ```

3. **Build on server**
   ```bash
   npm run build:prod
   ```

4. **Set proper permissions**
   ```bash
   chown -R www-data:www-data /www/wwwroot/kalimankarya.co.id
   chmod -R 755 /www/wwwroot/kalimankarya.co.id
   ```

### SSL Certificate
Make sure SSL certificate is properly configured for:
- kalimankarya.co.id
- www.kalimankarya.co.id (redirect to non-www)

### DNS Configuration
Ensure DNS records are properly configured:
- A record: kalimankarya.co.id → 147.93.81.43
- CNAME record: www.kalimankarya.co.id → kalimankarya.co.id
