#!/bin/bash
# Bash script to create GitHub pre-release via API
# Requires: GitHub Personal Access Token with repo permissions
# Usage: ./create-prerelease.sh YOUR_GITHUB_TOKEN

if [ -z "$1" ]; then
    echo "Error: GitHub token required"
    echo "Usage: ./create-prerelease.sh YOUR_GITHUB_TOKEN"
    exit 1
fi

TOKEN="$1"
REPO="itomic/wp-itomic-countdown"
TAG="v1.0.11-dev"
VERSION="1.0.11-dev"
ZIP_FILE="itomic-countdown.zip"

echo "Creating pre-release $TAG for $REPO..."

# Check if ZIP file exists
if [ ! -f "$ZIP_FILE" ]; then
    echo "Error: $ZIP_FILE not found. Run package-plugin.sh first."
    exit 1
fi

# Create release
RELEASE_BODY=$(cat <<EOF
## Version $VERSION (Development Pre-Release)

This is a pre-release from the develop branch for testing auto-update functionality.

**⚠️ Do not use in production!**

### Changes
- Added pre-release support for testing auto-updates from develop branch
- Enhanced updater class to check for pre-releases when \`ITOMIC_COUNTDOWN_CHECK_PRERELEASES\` constant is set

### Testing
This release is intended for testing the auto-update mechanism on development/staging sites.

---
*This is a development pre-release for testing purposes only.*
EOF
)

# Create the release via API
echo "Creating release..."
RELEASE_RESPONSE=$(curl -s -X POST \
  -H "Authorization: token $TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  -H "Content-Type: application/json" \
  -d "{
    \"tag_name\": \"$TAG\",
    \"name\": \"Version $VERSION (Development)\",
    \"body\": $(echo "$RELEASE_BODY" | jq -Rs .),
    \"prerelease\": true,
    \"draft\": false
  }" \
  "https://api.github.com/repos/$REPO/releases")

RELEASE_ID=$(echo "$RELEASE_RESPONSE" | jq -r '.id')
UPLOAD_URL=$(echo "$RELEASE_RESPONSE" | jq -r '.upload_url' | sed 's/{.*}//')

if [ "$RELEASE_ID" = "null" ] || [ -z "$RELEASE_ID" ]; then
    echo "Error: Failed to create release"
    echo "$RELEASE_RESPONSE" | jq '.'
    exit 1
fi

echo "Release created with ID: $RELEASE_ID"

# Upload ZIP file
echo "Uploading $ZIP_FILE..."
UPLOAD_RESPONSE=$(curl -s -X POST \
  -H "Authorization: token $TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  -H "Content-Type: application/zip" \
  --data-binary "@$ZIP_FILE" \
  "${UPLOAD_URL}?name=$ZIP_FILE")

echo "✓ Pre-release created successfully!"
RELEASE_URL=$(echo "$RELEASE_RESPONSE" | jq -r '.html_url')
echo "Release URL: $RELEASE_URL"
echo ""
echo "Next steps:"
echo "1. Verify the release at: $RELEASE_URL"
echo "2. Test update detection on wordpress.test"

