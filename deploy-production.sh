#!/bin/bash

# PT. Kaliman Karya - Production Deployment Script
# Script untuk deploy website ke production dengan file minimal

echo "🚀 Starting PT. Kaliman Karya Production Deployment"
echo "=================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
PROJECT_NAME="kalimankarya.co.id"
REMOTE_HOST="your-server-ip"
REMOTE_USER="root"
REMOTE_PATH="/www/wwwroot/www.kalimankarya.co.id"
LOCAL_BUILD_DIR="dist"

# Function to print status
print_status() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Step 1: Install dependencies
echo ""
echo "📦 Installing dependencies..."
if npm install; then
    print_status "Dependencies installed successfully"
else
    print_error "Failed to install dependencies"
    exit 1
fi

# Step 2: Build production files
echo ""
echo "🔨 Building production files..."
if npm run build; then
    print_status "Production build completed"
else
    print_error "Build failed"
    exit 1
fi

# Step 3: Check build output
echo ""
echo "📁 Checking build output..."
if [ -d "$LOCAL_BUILD_DIR" ]; then
    FILE_COUNT=$(find "$LOCAL_BUILD_DIR" -type f | wc -l)
    print_status "Build directory created with $FILE_COUNT files"

    echo "Files to be uploaded:"
    find "$LOCAL_BUILD_DIR" -type f -name "*.html" -o -name "*.css" -o -name "*.js" | head -10
    if [ $FILE_COUNT -gt 10 ]; then
        echo "... and $(($FILE_COUNT - 10)) more files"
    fi
else
    print_error "Build directory not found"
    exit 1
fi

# Step 4: Create .htaccess file
echo ""
echo "📝 Creating .htaccess configuration..."
cat > "$LOCAL_BUILD_DIR/.htaccess" << 'EOF'
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
</IfModule>

# Block sensitive files
<FilesMatch "(\.env|\.git|\.svn|node_modules|src|README|deploy\.sh)">
    Order deny,allow
    Deny from all
</FilesMatch>

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
</IfModule>

# Enable browser caching
<IfModule mod_expires.c>
    ExpiresActive On
    ExpiresByType text/html "access plus 1 hour"
    ExpiresByType text/css "access plus 1 year"
    ExpiresByType application/javascript "access plus 1 year"
    ExpiresByType image/jpg "access plus 1 year"
    ExpiresByType image/jpeg "access plus 1 year"
    ExpiresByType image/png "access plus 1 year"
    ExpiresByType image/webp "access plus 1 year"
    ExpiresByType image/svg+xml "access plus 1 year"
</IfModule>
EOF
print_status ".htaccess file created"

# Step 5: Create deployment package
echo ""
echo "📦 Creating deployment package..."
DEPLOY_PACKAGE="deploy_$(date +%Y%m%d_%H%M%S).tar.gz"
cd "$LOCAL_BUILD_DIR"
tar -czf "../$DEPLOY_PACKAGE" .
cd ..
print_status "Deployment package created: $DEPLOY_PACKAGE"

# Step 6: Show upload instructions
echo ""
echo "📤 Upload Instructions:"
echo "======================"
echo ""
echo "Option 1 - Direct Upload via SCP:"
echo "scp $DEPLOY_PACKAGE $REMOTE_USER@$REMOTE_HOST:~"
echo ""
echo "Option 2 - Upload via FTP/SFTP:"
echo "Upload file: $DEPLOY_PACKAGE"
echo "to server directory: $REMOTE_PATH"
echo ""
echo "Option 3 - Manual Upload:"
echo "1. Extract $DEPLOY_PACKAGE"
echo "2. Upload all files from $LOCAL_BUILD_DIR/"
echo "3. Place in server directory: $REMOTE_PATH"
echo ""

# Step 7: Server deployment commands
echo "🖥️  Server Deployment Commands:"
echo "=============================="
echo ""
echo "# Extract and deploy on server:"
echo "cd $REMOTE_PATH"
echo "tar -xzf ~/$DEPLOY_PACKAGE"
echo "chown -R www:www ."
echo "chmod -R 755 ."
echo "chmod 644 *.html"
echo ""
echo "# Restart web server:"
echo "systemctl restart httpd"
echo ""

print_status "Deployment preparation completed!"
echo ""
echo "🎯 Next Steps:"
echo "1. Upload the deployment package to your server"
echo "2. Extract files in the web root directory"
echo "3. Set proper permissions"
echo "4. Configure SSL certificate in aaPanel"
echo "5. Test your website"
echo ""
echo "📞 Need help? Contact: support@kalimankarya.co.id"
