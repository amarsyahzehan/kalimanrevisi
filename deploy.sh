#!/bin/bash

# Deployment script for PT. Kaliman Karya website
# Server: 147.93.81.43
# Domain: kalimankarya.co.id
# Directory: /www/wwwroot/kalimankarya.co.id

echo "🚀 Starting deployment for PT. Kaliman Karya website..."

# Build the project
echo "📦 Building production version..."
npm run build:prod

# Check if build was successful
if [ $? -eq 0 ]; then
    echo "✅ Build completed successfully!"
else
    echo "❌ Build failed! Please check the errors above."
    exit 1
fi

# Create deployment package
echo "📁 Creating deployment package..."
cd dist
tar -czf ../kalimankarya-website.tar.gz .
cd ..

echo "📋 Deployment package created: kalimankarya-website.tar.gz"
echo ""
echo "🔧 Manual deployment steps:"
echo "1. Upload kalimankarya-website.tar.gz to your server"
echo "2. SSH to your server: ssh root@147.93.81.43"
echo "3. Navigate to web directory: cd /www/wwwroot/kalimankarya.co.id"
echo "4. Backup current files: mv * backup_$(date +%Y%m%d_%H%M%S)/ (if needed)"
echo "5. Extract new files: tar -xzf kalimankarya-website.tar.gz"
echo "6. Set proper permissions: chown -R www-data:www-data *"
echo "7. Restart web server if needed"
echo ""
echo "🌐 Your website will be available at: https://kalimankarya.co.id"
echo "🔐 Admin panel: https://kalimankarya.co.id/admin"
echo "📧 Admin login: admin@kalimankarya.co.id"
echo "🔑 Password: KalimanKarya2024!"
echo ""
echo "✨ Deployment package ready!"