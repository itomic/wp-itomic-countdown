#!/bin/bash

# Sync WordPress plugin files to clean plugin directory
# This script updates the plugin/ directory with only the WordPress plugin files
# Used for local development with symlinked WordPress installation

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PLUGIN_DIR="plugin"
SOURCE_FILES=(
    "itomic-countdown.php"
    "readme.txt"
    "uninstall.php"
    "assets/"
    "languages/"
)

# Function to print colored output
print_status() {
    echo -e "${BLUE}[SYNC]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Validate that we're in the correct directory
if [ ! -f "itomic-countdown.php" ]; then
    echo "ERROR: Plugin file itomic-countdown.php not found. Are you in the plugin root directory?"
    exit 1
fi

print_status "Syncing WordPress plugin files to $PLUGIN_DIR..."

# Create plugin directory if it doesn't exist
mkdir -p "$PLUGIN_DIR"

# Remove existing files to ensure clean sync
rm -rf "$PLUGIN_DIR"/*

# Copy WordPress plugin files
for file in "${SOURCE_FILES[@]}"; do
    if [ -e "$file" ]; then
        print_status "Copying $file..."
        cp -r "$file" "$PLUGIN_DIR/"
    else
        echo "WARNING: $file not found, skipping..."
    fi
done

print_success "WordPress plugin files synced to $PLUGIN_DIR/"
print_status "Symlink location: /home/spaceman/vanilla/public_html/wp-content/plugins/itomic-countdown -> $(pwd)/$PLUGIN_DIR"

# List contents for verification
echo ""
echo "Plugin directory contents:"
ls -la "$PLUGIN_DIR/"
