#!/bin/bash

# Itomic Countdown Plugin Deployment Script
# This script packages the plugin for deployment

# Read version from plugin file
VERSION=$(grep "Version:" itomic-countdown.php | head -1 | sed 's/.*Version: *//')
PLUGIN_NAME="itomic-countdown"
DEPLOY_DIR="deploy"

echo "Building Itomic Countdown Plugin v$VERSION..."

# Create deployment directory
mkdir -p $DEPLOY_DIR

# Create plugin package
zip -r "$DEPLOY_DIR/$PLUGIN_NAME-$VERSION.zip" . \
    -x "*.git*" \
    -x "*.DS_Store*" \
    -x "deploy/*" \
    -x "deploy.sh" \
    -x "README.md" \
    -x "*.log"

# Create update files
echo "Creating update files..."

# Update version.json
cat > "$DEPLOY_DIR/version.json" << EOF
{
    "version": "$VERSION",
    "last_updated": "$(date +%Y-%m-%d)",
    "requires": "5.0",
    "requires_php": "7.4",
    "tested": "6.4"
}
EOF

# Update info.json
cat > "$DEPLOY_DIR/info.json" << EOF
{
    "name": "Itomic Countdown",
    "slug": "itomic-countdown",
    "version": "$VERSION",
    "author": "Itomic",
    "author_profile": "https://www.itomic.com.au/",
    "requires": "5.0",
    "requires_php": "7.4",
    "tested": "6.4",
    "last_updated": "$(date +%Y-%m-%d)",
    "sections": {
        "description": "Display a beautiful real-time countdown to any event on your WordPress site with easy configuration and multiple display positions.",
        "changelog": "= $VERSION =\\n* Added automatic timezone detection\\n* Fixed CSS and JavaScript class name consistency\\n* Added debugging functionality\\n* Improved error handling\\n\\n= 1.0.0 =\\n* Initial release\\n* Real-time countdown functionality\\n* 9 display position options\\n* Timezone support\\n* Responsive design\\n* Admin settings interface",
        "installation": "1. Upload the plugin files to /wp-content/plugins/itomic-countdown/\\n2. Activate the plugin through the 'Plugins' menu in WordPress\\n3. Go to Settings > Itomic Countdown to configure your countdown\\n4. Enter your event details and save"
    },
    "banners": {
        "high": "https://www.itomic.com.au/wp-content/uploads/plugins/itomic-countdown/banner-772x250.jpg",
        "low": "https://www.itomic.com.au/wp-content/uploads/plugins/itomic-countdown/banner-1544x500.jpg"
    }
}
EOF

echo "Deployment package created in $DEPLOY_DIR/"
echo "Files to upload to your server:"
echo "  - $DEPLOY_DIR/$PLUGIN_NAME-$VERSION.zip"
echo "  - $DEPLOY_DIR/version.json"
echo "  - $DEPLOY_DIR/info.json"
echo ""
echo "Upload these files to: https://itomic.com.au/plugins/itomic-countdown/" 