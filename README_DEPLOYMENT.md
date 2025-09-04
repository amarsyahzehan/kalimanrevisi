# PT. Kaliman Karya - Production Deployment Guide

## 📋 Overview
Panduan lengkap untuk deploy website PT. Kaliman Karya ke production server menggunakan aaPanel. Website ini menggunakan React + Vite untuk frontend dengan admin panel lengkap.

## 🏗️ Prerequisites
- Server dengan aaPanel terinstall
- Domain sudah pointing ke server IP
- Node.js 18+ (untuk build process)
- Git (untuk version control)

## 📁 Project Structure
```
kalimankarya.co.id/
├── src/                    # Source code React
├── public/                 # Static assets
├── server-setup.md         # Server setup instructions
├── deploy.sh              # Deployment script
└── README_DEPLOYMENT.md   # This file
```

## 🚀 Deployment Steps

### Quick Deployment (Recommended - Minimal Files)

**Untuk Linux/Mac:**
```bash
# Jalankan script deployment
./deploy-production.sh
```

**Untuk Windows:**
```batch
# Double-click atau jalankan:
deploy-production.bat
```

**Script akan otomatis:**
- ✅ Install dependencies
- ✅ Build production files
- ✅ Buat file .htaccess otomatis
- ✅ Buat package deployment (.tar.gz untuk Linux, .zip untuk Windows)
- ✅ Berikan instruksi upload lengkap

**Hasil: Hanya 1 file untuk upload!**
- Linux: `deploy_YYYYMMDD_HHMM.tar.gz`
- Windows: `deploy_YYYYMMDD_HHMM.zip`

### Manual Deployment (Alternatif)

#### Step 1: Build Production Files
```bash
# Install dependencies
npm install

# Build untuk production
npm run build

# Files akan tersimpan di folder dist/
```

#### Step 2: Upload Files ke Server
**Hanya upload file-file essential:**
- `index.html` - Halaman utama
- `*.css` - File stylesheet
- `*.js` - File JavaScript
- `assets/` - Gambar dan file statis
- `.htaccess` - Konfigurasi Apache (akan dibuat otomatis)

**Jangan upload:**
- ❌ `node_modules/`
- ❌ `src/`
- ❌ File development
- ❌ File konfigurasi lokal

**Upload Methods:**
1. **Via SCP/SFTP (Recommended):**
   ```bash
   # Upload seluruh folder dist/
   scp -r dist/* user@server:/www/wwwroot/www.kalimankarya.co.id/
   ```

2. **Via FTP:**
   - Upload isi folder `dist/` ke root directory website
   - Pastikan semua file ter-upload dengan benar

### Step 3: Konfigurasi aaPanel

#### 3.1 Setup Website
1. Login ke aaPanel
2. **Website** → **Add Site**
3. Masukkan domain: `www.kalimankarya.co.id`
4. Root directory: `/www/wwwroot/www.kalimankarya.co.id/`
5. PHP Version: **Pure Static** (karena static HTML)

#### 3.2 Konfigurasi Apache
1. **Website** → **Settings** → **Configuration**
2. Pastikan Apache sudah dipilih sebagai web server
3. Buat file `.htaccess` di root directory website dengan konfigurasi berikut:

```apache
# Apache Configuration for PT. Kaliman Karya
DirectoryIndex index.html

# Redirect HTTP to HTTPS
RewriteEngine On
RewriteCond %{HTTPS} off
RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]

# Security Headers
<IfModule mod_headers.c>
    Header always set X-Frame-Options "SAMEORIGIN"
    Header always set X-XSS-Protection "1; mode=block"
    Header always set X-Content-Type-Options "nosniff"
    Header always set Referrer-Policy "strict-origin-when-cross-origin"
    Header always set Content-Security-Policy "default-src 'self' https: data: blob: 'unsafe-inline' 'unsafe-eval';"
    Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"

    # Cache Control for Static Assets
    <FilesMatch "\.(jpg|jpeg|png|gif|ico|css|js|svg|woff|woff2|ttf|eot|webp)$">
        Header set Cache-Control "max-age=31536000, public, immutable"
    </FilesMatch>

    # Cache Control for HTML Files
    <FilesMatch "\.html$">
        Header set Cache-Control "max-age=3600, public, must-revalidate"
    </FilesMatch>
</IfModule>

# Block sensitive files and directories
<FilesMatch "(\.env|\.git|\.svn|node_modules|src|README|deploy\.sh)">
    Order deny,allow
    Deny from all
</FilesMatch>

# Block access to sensitive directories
RedirectMatch 404 /\.env$
RedirectMatch 404 /\.git
RedirectMatch 404 /node_modules
RedirectMatch 404 /src
RedirectMatch 404 /README
RedirectMatch 404 /deploy\.sh

# Custom Error Pages
ErrorDocument 404 /404.html
ErrorDocument 500 /502.html

# Enable compression
<IfModule mod_deflate.c>
    AddOutputFilterByType DEFLATE text/plain
    AddOutputFilterByType DEFLATE text/html
    AddOutputFilterByType DEFLATE text/xml
    AddOutputFilterByType DEFLATE text/css
    AddOutputFilterByType DEFLATE application/xml
    AddOutputFilterByType DEFLATE application/xhtml+xml
    AddOutputFilterByType DEFLATE application/rss+xml
    AddOutputFilterByType DEFLATE application/javascript
    AddOutputFilterByType DEFLATE application/x-javascript
    AddOutputFilterByType DEFLATE application/json

    # Don't compress images and other binary files
    SetEnvIfNoCase Request_URI \.(?:gif|jpe?g|png|ico|zip|gz|bz2|rar|mp3|mp4|ogg|ogv|webm|webp|svg|woff|woff2|eot|ttf)$ no-gzip dont-vary
</IfModule>

# Enable browser caching
<IfModule mod_expires.c>
    ExpiresActive On

    # Images
    ExpiresByType image/jpg "access plus 1 year"
    ExpiresByType image/jpeg "access plus 1 year"
    ExpiresByType image/gif "access plus 1 year"
    ExpiresByType image/png "access plus 1 year"
    ExpiresByType image/webp "access plus 1 year"
    ExpiresByType image/svg+xml "access plus 1 year"
    ExpiresByType image/x-icon "access plus 1 year"

    # CSS, JavaScript
    ExpiresByType text/css "access plus 1 year"
    ExpiresByType application/javascript "access plus 1 year"
    ExpiresByType application/x-javascript "access plus 1 year"

    # Fonts
    ExpiresByType font/truetype "access plus 1 year"
    ExpiresByType font/opentype "access plus 1 year"
    ExpiresByType application/x-font-woff "access plus 1 year"
    ExpiresByType application/font-woff2 "access plus 1 year"

    # HTML
    ExpiresByType text/html "access plus 1 hour"
</IfModule>

# Protect against common exploits
<IfModule mod_rewrite.c>
    RewriteEngine On

    # Block access to backup and source files
    RewriteRule \.(bak|config|sql|fla|psd|ini|log|sh|inc|swp|dist)$ - [F]

    # Block access to sensitive files
    RewriteRule ^(\.env|\.git|\.svn|\.DS_Store) - [F]

    # Prevent image hotlinking (optional)
    # RewriteCond %{HTTP_REFERER} !^$
    # RewriteCond %{HTTP_REFERER} !^https?://(www\.)?kalimankarya\.co\.id [NC]
    # RewriteRule \.(jpg|jpeg|png|gif|svg|webp)$ - [F]
</IfModule>

# Enable CORS for API calls (if needed)
<IfModule mod_headers.c>
    <FilesMatch "\.(php|html)$">
        Header set Access-Control-Allow-Origin "*"
        Header set Access-Control-Allow-Methods "GET, POST, OPTIONS"
        Header set Access-Control-Allow-Headers "Content-Type, Authorization"
    </FilesMatch>
</IfModule>

# PHP Settings (if needed for dynamic content)
<IfModule mod_php.c>
    php_value upload_max_filesize 50M
    php_value post_max_size 50M
    php_value memory_limit 256M
    php_value max_execution_time 300
</IfModule>
```

#### 3.3 SSL Certificate
1. **Website** → **SSL**
2. **Let's Encrypt** → **Apply**
3. Pilih domain dan subdomain
4. Apply certificate

### Step 4: Database Setup (Jika Diperlukan)
Jika website menggunakan database:

1. **Database** → **Add Database**
2. Database Type: MySQL/MariaDB
3. Import schema dari `database/schema.sql`
4. Update konfigurasi database di environment files

### Step 5: Environment Configuration
1. Copy `.env.example` ke `.env`
2. Update konfigurasi production:
```env
NODE_ENV=production
VITE_API_URL=https://api.kalimankarya.co.id
DATABASE_URL=mysql://user:password@localhost:3306/kalimankarya
```

### Step 6: Permissions Setup
```bash
# Set proper permissions
chown -R www:www /www/wwwroot/www.kalimankarya.co.id
chmod -R 755 /www/wwwroot/www.kalimankarya.co.id
chmod 644 /www/wwwroot/www.kalimankarya.co.id/*.html
```

## 🔧 Maintenance Mode

### Aktivasi Maintenance Mode
```bash
# Rename files
cd /www/wwwroot/www.kalimankarya.co.id
mv index.html index_backup.html
mv maintenance.html index.html
```

### Kembali ke Normal Mode
```bash
# Rename kembali
cd /www/wwwroot/www.kalimankarya.co.id
mv index.html maintenance.html
mv index_backup.html index.html
```

## 📊 Monitoring & Logs

### aaPanel Monitoring
1. **Website** → **Logs** → **Access Log**
2. **Website** → **Logs** → **Error Log**
3. Monitor resource usage di **Server** → **Monitor**

### Log Files Location
- Access Log: `/www/wwwlogs/www.kalimankarya.co.id.log`
- Error Log: `/www/wwwlogs/www.kalimankarya.co.id.error.log`

## 🔄 Update Deployment

### Automated Deployment Script
Gunakan `deploy.sh` untuk deployment otomatis:

```bash
# Jalankan dari local machine
./deploy.sh production
```

### Manual Update
```bash
# Di server
cd /www/wwwroot/www.kalimankarya.co.id
git pull origin main
npm install
npm run build
```

## 🧪 Testing Checklist

### Pre-Deployment
- [ ] Build berhasil tanpa error
- [ ] Semua assets tersedia
- [ ] Environment variables sudah benar
- [ ] Database connection (jika ada) berfungsi

### Post-Deployment
- [ ] Website dapat diakses via HTTPS
- [ ] SSL certificate valid
- [ ] Semua halaman dapat diakses
- [ ] Admin panel berfungsi
- [ ] Contact form berfungsi
- [ ] Mobile responsive
- [ ] Loading speed optimal

## 🚨 Troubleshooting

### Common Issues

#### 404 Errors
```bash
# Check Apache configuration
apachectl configtest

# Check .htaccess syntax
cd /www/wwwroot/www.kalimankarya.co.id
cat .htaccess

# Check file permissions
ls -la /www/wwwroot/www.kalimankarya.co.id/

# Check Apache error logs
tail -f /www/wwwlogs/www.kalimankarya.co.id.error.log
```

#### SSL Issues
1. **aaPanel** → **SSL** → **Check Certificate**
2. Verify domain DNS propagation
3. Check firewall settings

#### Performance Issues
1. Enable gzip compression
2. Optimize images
3. Enable browser caching
4. Check server resources

#### Permission Issues
```bash
# Fix permissions
chown -R www:www /www/wwwroot/www.kalimankarya.co.id
chmod -R 755 /www/wwwroot/www.kalimankarya.co.id
```

## 🔒 Security Best Practices

### Server Security
- [ ] Update aaPanel regularly
- [ ] Enable firewall (CSF/LFD)
- [ ] Disable unused services
- [ ] Regular backup

### Application Security
- [ ] Environment variables tidak expose sensitive data
- [ ] Admin panel protected dengan authentication
- [ ] Input validation pada forms
- [ ] HTTPS enforced

## 📈 Performance Optimization

### aaPanel Optimizations
1. **PHP** → **Settings** → Enable OPcache
2. **Redis** → Enable untuk caching
3. **CDN** → Setup Cloudflare jika diperlukan

### Application Optimizations
- Image optimization
- Code splitting
- Lazy loading
- Bundle analysis

## 📞 Support & Contact

### Emergency Contacts
- **Technical Support**: support@kalimankarya.co.id
- **Server Admin**: admin@kalimankarya.co.id
- **aaPanel Support**: https://www.aapanel.com/forum

### Useful Links
- [aaPanel Documentation](https://www.aapanel.com/docs)
- [Apache HTTP Server Documentation](https://httpd.apache.org/docs/)
- [Apache .htaccess Guide](https://httpd.apache.org/docs/current/howto/htaccess.html)
- [Let's Encrypt](https://letsencrypt.org/)

---

## 📋 Quick Commands

### Server Status Check
```bash
# Check Apache status
systemctl status httpd

# Check aaPanel status
/etc/init.d/bt status

# Check disk usage
df -h

# Check memory usage
free -h
```

### Backup Commands
```bash
# Backup website files
tar -czf backup_$(date +%Y%m%d).tar.gz /www/wwwroot/www.kalimankarya.co.id

# Backup database
mysqldump -u username -p database_name > backup_$(date +%Y%m%d).sql
```

---

**Last Updated**: September 2025
**Version**: 1.0.0
**Author**: PT. Kaliman Karya Development Team
