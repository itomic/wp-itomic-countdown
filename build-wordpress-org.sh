#!/bin/bash

# WordPress.org Plugin Builder Script
# Creates a clean version of the plugin suitable for WordPress.org submission

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
PLUGIN_FILE="itomic-countdown.php"
PLUGIN_NAME="itomic-countdown"
OUTPUT_DIR="wordpress-org-build"

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

echo ""
echo "============================================"
echo -e "${BLUE}WordPress.org Plugin Builder${NC}"
echo "============================================"
echo ""

# Validate we're in the right directory
if [ ! -f "$PLUGIN_FILE" ]; then
    echo "ERROR: Plugin file $PLUGIN_FILE not found. Are you in the plugin root directory?"
    exit 1
fi

# Get version from plugin file
VERSION=$(grep "Version:" "$PLUGIN_FILE" | head -1 | sed 's/.*Version: *//' | tr -d ' \t\r\n')

if [ -z "$VERSION" ]; then
    echo "ERROR: Could not determine version from $PLUGIN_FILE"
    exit 1
fi

print_status "Building WordPress.org compliant version v$VERSION..."

# Clean and create output directory
rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR/$PLUGIN_NAME"

print_status "Copying WordPress.org compliant files..."

# Copy ONLY the files that should be in WordPress.org
cp "$PLUGIN_FILE" "$OUTPUT_DIR/$PLUGIN_NAME/"
cp "readme.txt" "$OUTPUT_DIR/$PLUGIN_NAME/"
cp "uninstall.php" "$OUTPUT_DIR/$PLUGIN_NAME/"
cp -r "assets/" "$OUTPUT_DIR/$PLUGIN_NAME/"
cp -r "languages/" "$OUTPUT_DIR/$PLUGIN_NAME/"

print_status "Creating WordPress.org compatible main plugin file..."

# Create a WordPress.org version of the main plugin file without custom updates
cat > "$OUTPUT_DIR/$PLUGIN_NAME/itomic-countdown.php" << 'EOF'
<?php
/**
 * Plugin Name: Itomic Countdown
 * Plugin URI: https://www.itomic.com.au/itomic-countdown/
 * Description: Display a real-time countdown to any event on your WordPress site.
 * Version: PLACEHOLDER_VERSION
 * Author: Itomic
 * Author URI: https://www.itomic.com.au/
 * Developer: Itomic
 * Developer URI: https://www.itomic.com.au/
 * Text Domain: itomic-countdown
 * Domain Path: /languages
 * License: GNU General Public License v3.0
 * License URI: http://www.gnu.org/licenses/gpl-3.0.html
 * Requires at least: 5.0
 * Tested up to: 6.8
 * Requires PHP: 7.4
 *
 * @package Itomic_Countdown
 */

// Prevent direct access.
if ( ! defined( 'ABSPATH' ) ) {
	exit; // Exit if accessed directly.
}

// Define plugin constants.
define( 'ITOMIC_COUNTDOWN_VERSION', 'PLACEHOLDER_VERSION' );
define( 'ITOMIC_COUNTDOWN_PLUGIN_DIR', plugin_dir_path( __FILE__ ) );
define( 'ITOMIC_COUNTDOWN_PLUGIN_URL', plugin_dir_url( __FILE__ ) );

/**
 * Main Itomic Countdown Plugin Class
 */
class Itomic_Countdown_Plugin {

	/**
	 * Constructor
	 */
	public function __construct() {
		add_action( 'init', array( $this, 'init' ) );
		add_action( 'admin_menu', array( $this, 'add_admin_menu' ) );
		add_action( 'admin_init', array( $this, 'init_settings' ) );
		add_action( 'wp_enqueue_scripts', array( $this, 'enqueue_scripts' ) );
		add_action( 'wp_footer', array( $this, 'display_countdown' ) );
		add_filter( 'plugin_action_links_' . plugin_basename( __FILE__ ), array( $this, 'add_settings_link' ) );

		// Note: Custom update system removed for WordPress.org version
		// WordPress.org handles all plugin updates automatically
	}

	/**
	 * Initialize the plugin
	 */
	public function init() {
		load_plugin_textdomain( 'itomic-countdown', false, dirname( plugin_basename( __FILE__ ) ) . '/languages' );
	}

EOF

# Extract the core functionality from the original plugin file (excluding update system)
sed -n '/^	\/\*\*$/,/^}$/p' "$PLUGIN_FILE" | grep -v -E "(check_for_updates|plugin_info|auto_update|update|is_wordpress_org_version)" >> "$OUTPUT_DIR/$PLUGIN_NAME/itomic-countdown.php"

# Replace version placeholders
sed -i "s/PLACEHOLDER_VERSION/$VERSION/g" "$OUTPUT_DIR/$PLUGIN_NAME/itomic-countdown.php"

print_status "Creating WordPress.org package..."

# Create ZIP file
cd "$OUTPUT_DIR"
zip -r "../$PLUGIN_NAME-wordpress-org-v$VERSION.zip" "$PLUGIN_NAME/"
cd ..

# Clean up temp directory
rm -rf "$OUTPUT_DIR"

print_success "WordPress.org package created: $PLUGIN_NAME-wordpress-org-v$VERSION.zip"

echo ""
echo "============================================"
echo -e "${GREEN}WordPress.org Compliance Summary${NC}"
echo "============================================"
echo ""
echo "✅ INCLUDED in WordPress.org version:"
echo "   • itomic-countdown.php (cleaned)"
echo "   • readme.txt"
echo "   • uninstall.php"
echo "   • assets/ (CSS, JS)"
echo "   • languages/ (translations)"
echo ""
echo "❌ EXCLUDED from WordPress.org version:"
echo "   • Custom update system code"
echo "   • Development files (composer.json, tests/, bin/)"
echo "   • Build files (deploy/, bitbucket-pipelines.yml)"
echo "   • Documentation (DEVELOPMENT.md, README.md)"
echo ""
echo "📦 Package: $PLUGIN_NAME-wordpress-org-v$VERSION.zip"
echo ""
print_success "Ready for WordPress.org submission!" 