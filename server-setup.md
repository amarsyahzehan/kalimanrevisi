# Server Setup Guide for PT. Kaliman Karya Website

## Server Information
- **Domain**: kalimankarya.co.id
- **Server IP**: 147.93.81.43
- **Document Root**: /www/wwwroot/kalimankarya.co.id
- **DNS Provider**: Cloudflare
- **Nameservers**: 
  - asa.ns.cloudflare.com
  - otto.ns.cloudflare.com

## Prerequisites

### 1. Server Requirements
- Apache/Nginx web server
- PHP 8.0+ (for potential backend features)
- SSL certificate for HTTPS
- Gzip compression enabled
- Mod_rewrite enabled (Apache)

### 2. DNS Configuration
Ensure these DNS records are set in Cloudflare:

```
Type    Name                    Content             TTL
A       kalimankarya.co.id      147.93.81.43        Auto
A       www                     147.93.81.43        Auto
CNAME   admin                   kalimankarya.co.id  Auto
```

## Deployment Steps

### 1. Build the Website
```bash
# Install dependencies
npm install

# Build for production
npm run build:prod

# Create deployment package
./deploy.sh
```

### 2. Upload to Server
```bash
# Upload via SCP (replace with your actual SSH key/password)
scp kalimankarya-website.tar.gz root@147.93.81.43:/tmp/

# SSH to server
ssh root@147.93.81.43

# Navigate to web directory
cd /www/wwwroot/kalimankarya.co.id

# Backup existing files (if any)
mkdir -p backup_$(date +%Y%m%d_%H%M%S)
mv * backup_$(date +%Y%m%d_%H%M%S)/ 2>/dev/null || true

# Extract new files
tar -xzf /tmp/kalimankarya-website.tar.gz

# Set proper permissions
chown -R www-data:www-data *
chmod -R 755 *
chmod 644 .htaccess
```

### 3. Web Server Configuration

#### Apache Configuration
Ensure these modules are enabled:
```bash
a2enmod rewrite
a2enmod headers
a2enmod deflate
a2enmod expires
systemctl restart apache2
```

#### Virtual Host Configuration
```apache
<VirtualHost *:80>
    ServerName kalimankarya.co.id
    ServerAlias www.kalimankarya.co.id
    DocumentRoot /www/wwwroot/kalimankarya.co.id
    
    # Redirect to HTTPS
    RewriteEngine On
    RewriteCond %{HTTPS} off
    RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]
</VirtualHost>

<VirtualHost *:443>
    ServerName kalimankarya.co.id
    ServerAlias www.kalimankarya.co.id
    DocumentRoot /www/wwwroot/kalimankarya.co.id
    
    # SSL Configuration
    SSLEngine on
    SSLCertificateFile /path/to/certificate.crt
    SSLCertificateKeyFile /path/to/private.key
    SSLCertificateChainFile /path/to/ca_bundle.crt
    
    # Security headers
    Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains"
    Header always set X-Frame-Options SAMEORIGIN
    Header always set X-Content-Type-Options nosniff
    Header always set X-XSS-Protection "1; mode=block"
    
    # Compression
    SetOutputFilter DEFLATE
    SetEnvIfNoCase Request_URI \
        \.(?:gif|jpe?g|png)$ no-gzip dont-vary
    SetEnvIfNoCase Request_URI \
        \.(?:exe|t?gz|zip|bz2|sit|rar)$ no-gzip dont-vary
    
    # Caching
    ExpiresActive On
    ExpiresByType text/css "access plus 1 month"
    ExpiresByType application/javascript "access plus 1 month"
    ExpiresByType image/png "access plus 1 year"
    ExpiresByType image/jpg "access plus 1 year"
    ExpiresByType image/jpeg "access plus 1 year"
    ExpiresByType image/gif "access plus 1 year"
    ExpiresByType image/svg+xml "access plus 1 year"
</VirtualHost>
```

### 4. SSL Certificate Setup
```bash
# If using Let's Encrypt
certbot --apache -d kalimankarya.co.id -d www.kalimankarya.co.id

# Or upload your SSL certificate files to:
# /etc/ssl/certs/kalimankarya.co.id.crt
# /etc/ssl/private/kalimankarya.co.id.key
```

### 5. Cloudflare Configuration

#### DNS Settings
- Set SSL/TLS encryption mode to "Full (strict)"
- Enable "Always Use HTTPS"
- Enable "Automatic HTTPS Rewrites"

#### Performance Settings
- Enable "Auto Minify" for CSS, JavaScript, and HTML
- Enable "Brotli" compression
- Set Browser Cache TTL to "1 month"

#### Security Settings
- Enable "Security Level: Medium"
- Enable "Bot Fight Mode"
- Configure "Firewall Rules" if needed

## Post-Deployment Checklist

### 1. Website Functionality
- [ ] Homepage loads correctly
- [ ] All navigation links work
- [ ] Contact form submits successfully
- [ ] Admin panel accessible at /admin
- [ ] Mobile responsiveness works
- [ ] All images load properly

### 2. SEO & Performance
- [ ] SSL certificate working (green padlock)
- [ ] Sitemap accessible at /sitemap.xml
- [ ] Robots.txt accessible at /robots.txt
- [ ] Page speed score > 90 (Google PageSpeed Insights)
- [ ] Meta tags displaying correctly
- [ ] Structured data valid (Google Rich Results Test)

### 3. Admin Panel
- [ ] Login works with admin@kalimankarya.co.id
- [ ] Dashboard displays correctly
- [ ] All admin features functional
- [ ] File uploads working
- [ ] Settings can be saved

### 4. Contact & Communication
- [ ] Contact form sends emails
- [ ] WhatsApp links work correctly
- [ ] Phone numbers clickable on mobile
- [ ] Email links open mail client
- [ ] Social media links work

## Monitoring & Maintenance

### 1. Regular Backups
```bash
# Create backup script
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
tar -czf /backups/kalimankarya_$DATE.tar.gz /www/wwwroot/kalimankarya.co.id
```

### 2. Log Monitoring
- Monitor Apache access logs: `/var/log/apache2/access.log`
- Monitor Apache error logs: `/var/log/apache2/error.log`
- Set up log rotation

### 3. Security Updates
- Keep server OS updated
- Update SSL certificates before expiry
- Monitor for security vulnerabilities
- Regular security scans

### 4. Performance Monitoring
- Monitor website uptime
- Check page load speeds monthly
- Monitor server resources (CPU, RAM, disk)
- Optimize images and assets regularly

## Troubleshooting

### Common Issues

#### 1. 404 Errors on Page Refresh
- Ensure `.htaccess` file is uploaded and mod_rewrite is enabled
- Check Apache configuration for AllowOverride All

#### 2. SSL Certificate Issues
- Verify certificate installation
- Check Cloudflare SSL settings
- Ensure certificate covers both www and non-www domains

#### 3. Contact Form Not Working
- Check email server configuration
- Verify SMTP settings in environment variables
- Test email delivery manually

#### 4. Slow Loading Times
- Enable Cloudflare caching
- Optimize images
- Check server resources
- Enable compression

## Support Contacts

- **Technical Support**: admin@kalimankarya.co.id
- **Emergency**: +62 815-9876-5432
- **Server Provider**: Contact your hosting provider
- **DNS Support**: Cloudflare support

---

**Last Updated**: January 2024
**Version**: 1.0.0