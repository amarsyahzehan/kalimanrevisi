@echo off
REM PT. Kaliman Karya - Windows Deployment Script
REM Script untuk deploy website ke production dengan file minimal

echo 🚀 Starting PT. Kaliman Karya Production Deployment
echo ==================================================

REM Configuration
set PROJECT_NAME=kalimankarya.co.id
set LOCAL_BUILD_DIR=dist
set REMOTE_HOST=your-server-ip
set REMOTE_USER=root
set REMOTE_PATH=/www/wwwroot/www.kalimankarya.co.id

echo.
echo 📦 Installing dependencies...
call npm install
if %errorlevel% neq 0 (
    echo ❌ Failed to install dependencies
    pause
    exit /b 1
)
echo ✅ Dependencies installed successfully

echo.
echo 🔨 Building production files...
call npm run build
if %errorlevel% neq 0 (
    echo ❌ Build failed
    pause
    exit /b 1
)
echo ✅ Production build completed

echo.
echo 📁 Checking build output...
if exist "%LOCAL_BUILD_DIR%" (
    for /f %%A in ('dir /b /a-d "%LOCAL_BUILD_DIR%" 2^>nul ^| find /c /v ""') do set FILE_COUNT=%%A
    echo ✅ Build directory created with %FILE_COUNT% files

    echo Files to be uploaded:
    dir /b "%LOCAL_BUILD_DIR%\*.html" "%LOCAL_BUILD_DIR%\*.css" "%LOCAL_BUILD_DIR%\*.js" 2>nul | findstr . || echo No main files found
) else (
    echo ❌ Build directory not found
    pause
    exit /b 1
)

echo.
echo 📝 Creating .htaccess configuration...
(
echo # Apache Configuration for PT. Kaliman Karya
echo DirectoryIndex index.html
echo.
echo # Redirect HTTP to HTTPS
echo RewriteEngine On
echo RewriteCond %%{HTTPS} off
echo RewriteRule ^(.*)$ https://%%{HTTP_HOST}%%{REQUEST_URI} [L,R=301]
echo.
echo # Security Headers
echo ^<IfModule mod_headers.c^>
echo     Header always set X-Frame-Options "SAMEORIGIN"
echo     Header always set X-XSS-Protection "1; mode=block"
echo     Header always set X-Content-Type-Options "nosniff"
echo     Header always set Referrer-Policy "strict-origin-when-cross-origin"
echo     Header always set Content-Security-Policy "default-src 'self' https: data: blob: 'unsafe-inline' 'unsafe-eval';"
echo     Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
echo ^</IfModule^>
echo.
echo # Block sensitive files
echo ^<FilesMatch "(\.env|\.git|\.svn|node_modules|src|README|deploy\.sh)"^>
echo     Order deny,allow
echo     Deny from all
echo ^</FilesMatch^>
echo.
echo # Custom Error Pages
echo ErrorDocument 404 /404.html
echo ErrorDocument 500 /502.html
echo.
echo # Enable compression
echo ^<IfModule mod_deflate.c^>
echo     AddOutputFilterByType DEFLATE text/plain
echo     AddOutputFilterByType DEFLATE text/html
echo     AddOutputFilterByType DEFLATE text/xml
echo     AddOutputFilterByType DEFLATE text/css
echo     AddOutputFilterByType DEFLATE application/xml
echo     AddOutputFilterByType DEFLATE application/xhtml+xml
echo     AddOutputFilterByType DEFLATE application/rss+xml
echo     AddOutputFilterByType DEFLATE application/javascript
echo     AddOutputFilterByType DEFLATE application/x-javascript
echo     AddOutputFilterByType DEFLATE application/json
echo ^</IfModule^>
echo.
echo # Enable browser caching
echo ^<IfModule mod_expires.c^>
echo     ExpiresActive On
echo     ExpiresByType text/html "access plus 1 hour"
echo     ExpiresByType text/css "access plus 1 year"
echo     ExpiresByType application/javascript "access plus 1 year"
echo     ExpiresByType image/jpg "access plus 1 year"
echo     ExpiresByType image/jpeg "access plus 1 year"
echo     ExpiresByType image/png "access plus 1 year"
echo     ExpiresByType image/webp "access plus 1 year"
echo     ExpiresByType image/svg+xml "access plus 1 year"
echo ^</IfModule^>
) > "%LOCAL_BUILD_DIR%\.htaccess"
echo ✅ .htaccess file created

echo.
echo 📦 Creating deployment package...
for /f "tokens=2-4 delims=/ " %%a in ('date /t') do set DATESTR=%%c%%a%%b
for /f "tokens=1-2 delims=: " %%a in ('time /t') do set TIMESTR=%%a%%b
set DEPLOY_PACKAGE=deploy_%DATESTR%_%TIMESTR%.zip

cd "%LOCAL_BUILD_DIR%"
powershell "Compress-Archive -Path * -DestinationPath ..\%DEPLOY_PACKAGE%.zip -Force"
cd ..
echo ✅ Deployment package created: %DEPLOY_PACKAGE%.zip

echo.
echo 📤 Upload Instructions:
echo ======================
echo.
echo Option 1 - Upload via FTP/SFTP:
echo Upload file: %DEPLOY_PACKAGE%.zip
echo to server directory: %REMOTE_PATH%
echo.
echo Option 2 - Manual Upload:
echo 1. Extract %DEPLOY_PACKAGE%.zip
echo 2. Upload all files from %LOCAL_BUILD_DIR%/
echo 3. Place in server directory: %REMOTE_PATH%
echo.
echo Option 3 - Via SCP ^(if SSH available^):
echo scp %DEPLOY_PACKAGE%.zip %REMOTE_USER%@%REMOTE_HOST%:~
echo.

echo 🖥️  Server Deployment Commands:
echo ==============================
echo.
echo # Extract and deploy on server:
echo cd %REMOTE_PATH%
echo unzip ~/%DEPLOY_PACKAGE%.zip
echo chown -R www:www .
echo chmod -R 755 .
echo chmod 644 *.html
echo.
echo # Restart web server:
echo systemctl restart httpd
echo.

echo ✅ Deployment preparation completed!
echo.
echo 🎯 Next Steps:
echo 1. Upload the deployment package to your server
echo 2. Extract files in the web root directory
echo 3. Set proper permissions
echo 4. Configure SSL certificate in aaPanel
echo 5. Test your website
echo.
echo 📞 Need help? Contact: support@kalimankarya.co.id
echo.
pause
