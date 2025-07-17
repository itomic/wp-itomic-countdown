#!/bin/bash

# Itomic Countdown Plugin Deployment Script
# This script packages the plugin for deployment using the version from the plugin file as single source of truth

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PLUGIN_FILE="itomic-countdown.php"
README_FILE="readme.txt"
PLUGIN_NAME="itomic-countdown"
DEPLOY_DIR="deploy"

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Read version from plugin file (single source of truth)
VERSION=$(grep "Version:" "$PLUGIN_FILE" | head -1 | sed 's/.*Version: *//' | tr -d ' \t\r\n')

if [ -z "$VERSION" ]; then
    echo "ERROR: Could not determine version from $PLUGIN_FILE"
    exit 1
fi

print_status "Building Itomic Countdown Plugin v$VERSION..."

# Validate that we're in the correct directory
if [ ! -f "$PLUGIN_FILE" ]; then
    echo "ERROR: Plugin file $PLUGIN_FILE not found. Are you in the plugin root directory?"
    exit 1
fi

# Create deployment directory
mkdir -p "$DEPLOY_DIR"

# Create plugin package (exclude development files)
print_status "Creating plugin package..."

# Create temporary directory for proper plugin structure
TEMP_DIR=$(mktemp -d)
PLUGIN_DIR="$TEMP_DIR/$PLUGIN_NAME"

# Copy plugin files to temporary directory with proper structure
mkdir -p "$PLUGIN_DIR"

# Copy files using cp with exclusions
cp -r . "$PLUGIN_DIR/"

# Remove excluded files/directories from the temporary copy
cd "$PLUGIN_DIR"
rm -rf .git* .DS_Store* deploy/ deploy.sh README.md DEVELOPMENT.md INSTALLATION.md
rm -rf *.log vendor/ composer.json composer.lock phpunit.xml tests/ bin/
rm -rf .gitignore coverage/ node_modules/ *.tmp *.temp
cd - > /dev/null

# Create ZIP with proper plugin folder structure
cd "$TEMP_DIR"
zip -r "$OLDPWD/$DEPLOY_DIR/$PLUGIN_NAME-$VERSION.zip" "$PLUGIN_NAME/"
cd "$OLDPWD"

# Clean up temporary directory
rm -rf "$TEMP_DIR"

if [ $? -eq 0 ]; then
    print_success "Plugin package created: $DEPLOY_DIR/$PLUGIN_NAME-$VERSION.zip"
else
    echo "ERROR: Failed to create plugin package"
    exit 1
fi

# Get file size for verification
PACKAGE_SIZE=$(du -h "$DEPLOY_DIR/$PLUGIN_NAME-$VERSION.zip" | cut -f1)
print_status "Package size: $PACKAGE_SIZE"

# Extract changelog from readme.txt for current version
print_status "Extracting changelog for version $VERSION..."
CHANGELOG=$(awk "/= $VERSION =/{flag=1; next} /= [0-9]+\.[0-9]+\.[0-9]+ =/{flag=0} flag && /^\*/ {gsub(/^\* /, \"\"); print}" "$README_FILE" | head -10)

# If no changelog found, use a default
if [ -z "$CHANGELOG" ]; then
    CHANGELOG="* Version $VERSION release\\n* See readme.txt for full details"
else
    # Format changelog for JSON (escape and join with \n)
    CHANGELOG=$(echo "$CHANGELOG" | sed 's/"/\\"/g' | sed 's/^/* /' | tr '\n' '\001' | sed 's/\001/\\n/g' | sed 's/\\n$//')
fi

print_status "Creating update files..."

# Create version.json (WordPress update system)
cat > "$DEPLOY_DIR/version.json" << EOF
{
    "version": "$VERSION",
    "last_updated": "$(date +%Y-%m-%d)",
    "requires": "5.0",
    "requires_php": "7.4",
    "tested": "6.8",
    "details_url": "https://itomic.com.au/plugins/itomic-countdown/"
}
EOF

# Create info.json (WordPress plugin information)
cat > "$DEPLOY_DIR/info.json" << EOF
{
    "name": "Itomic Countdown",
    "slug": "itomic-countdown",
    "version": "$VERSION",
    "author": "Itomic",
    "author_profile": "https://www.itomic.com.au/",
    "requires": "5.0",
    "requires_php": "7.4",
    "tested": "6.8",
    "last_updated": "$(date +%Y-%m-%d)",
    "sections": {
        "description": "Display a beautiful real-time countdown to any event on your WordPress site with easy configuration and multiple display positions.",
        "changelog": "= $VERSION =\\n$CHANGELOG\\n\\n= Previous Versions =\\nSee readme.txt for complete changelog history.",
        "installation": "1. Upload the plugin files to /wp-content/plugins/itomic-countdown/\\n2. Activate the plugin through the 'Plugins' menu in WordPress\\n3. Go to Settings > Itomic Countdown to configure your countdown\\n4. Enter your event details and save"
    },
    "banners": {
        "high": "https://www.itomic.com.au/wp-content/uploads/plugins/itomic-countdown/banner-772x250.jpg",
        "low": "https://www.itomic.com.au/wp-content/uploads/plugins/itomic-countdown/banner-1544x500.jpg"
    }
}
EOF

print_success "Update files created"

# Verify all files were created
echo ""
print_status "Deployment package verification:"
echo "Files created in $DEPLOY_DIR/:"

if [ -f "$DEPLOY_DIR/$PLUGIN_NAME-$VERSION.zip" ]; then
    echo "  ✓ $PLUGIN_NAME-$VERSION.zip ($PACKAGE_SIZE)"
else
    echo "  ✗ $PLUGIN_NAME-$VERSION.zip (MISSING)"
fi

if [ -f "$DEPLOY_DIR/version.json" ]; then
    echo "  ✓ version.json"
else
    echo "  ✗ version.json (MISSING)"
fi

if [ -f "$DEPLOY_DIR/info.json" ]; then
    echo "  ✓ info.json"
else
    echo "  ✗ info.json (MISSING)"
fi

echo ""
print_success "Deployment package created successfully!"
echo ""
echo "============================================"
echo "FILES TO UPLOAD TO YOUR UPDATE SERVER:"
echo "============================================"
echo "  📦 $DEPLOY_DIR/$PLUGIN_NAME-$VERSION.zip"
echo "  📄 $DEPLOY_DIR/version.json"
echo "  📄 $DEPLOY_DIR/info.json"
echo ""
echo "Upload destination: https://itomic.com.au/plugins/itomic-countdown/"
echo ""
echo "Next steps:"
echo "  1. Upload files to your update server"
echo "  2. Test update on your WordPress site"
echo "  3. Verify plugin functionality after update"
echo "" 