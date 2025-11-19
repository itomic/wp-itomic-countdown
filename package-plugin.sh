#!/bin/bash
# Cross-platform packaging script for GitHub Actions
# This is a bash version of package-plugin.ps1 for use in CI/CD

PLUGIN_NAME="itomic-countdown"
VERSION=$(grep -oP 'Version: \K[0-9]+\.[0-9]+\.[0-9]+' itomic-countdown.php | head -1)
OUTPUT_FILE="${PLUGIN_NAME}.zip"

echo "Packaging ${PLUGIN_NAME} plugin (v${VERSION})..."

# Create temporary directory with correct structure
mkdir -p "temp/${PLUGIN_NAME}/includes"
mkdir -p "temp/${PLUGIN_NAME}/assets/css"
mkdir -p "temp/${PLUGIN_NAME}/assets/js"
mkdir -p "temp/${PLUGIN_NAME}/languages"

# Copy plugin files
cp itomic-countdown.php "temp/${PLUGIN_NAME}/"
cp readme.txt "temp/${PLUGIN_NAME}/"
cp uninstall.php "temp/${PLUGIN_NAME}/"
cp -r assets/* "temp/${PLUGIN_NAME}/assets/"
cp -r languages/* "temp/${PLUGIN_NAME}/languages/"

# Copy updater class (for self-hosted installations)
if [ -f "includes/class-plugin-updater.php" ]; then
    cp includes/class-plugin-updater.php "temp/${PLUGIN_NAME}/includes/"
fi

# Create zip file
cd temp
zip -r "../${OUTPUT_FILE}" "${PLUGIN_NAME}/"
cd ..

# Cleanup
rm -rf temp

echo "Plugin packaged successfully: ${OUTPUT_FILE}"

