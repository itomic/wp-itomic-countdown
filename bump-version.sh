#!/bin/bash
# Version Bump Script for Itomic Countdown Plugin
# Increments version number in plugin file and readme.txt

PLUGIN_FILE="itomic-countdown.php"
README_FILE="readme.txt"

if [ -z "$1" ]; then
    echo "Usage: ./bump-version.sh [patch|minor|major]"
    exit 1
fi

TYPE=$1

if [[ ! "$TYPE" =~ ^(patch|minor|major)$ ]]; then
    echo "Error: Type must be patch, minor, or major"
    exit 1
fi

echo "Bumping version ($TYPE)..."
echo ""

# Extract current version from plugin file
OLD_VERSION=$(grep -oP 'Version: \K[0-9]+\.[0-9]+\.[0-9]+' "$PLUGIN_FILE" | head -1)

if [ -z "$OLD_VERSION" ]; then
    echo "Error: Could not find version in $PLUGIN_FILE"
    exit 1
fi

echo "Current version: $OLD_VERSION"

# Parse version components
IFS='.' read -ra VERSION_PARTS <<< "$OLD_VERSION"
MAJOR=${VERSION_PARTS[0]}
MINOR=${VERSION_PARTS[1]}
PATCH=${VERSION_PARTS[2]}

# Increment version based on type
case $TYPE in
    major)
        MAJOR=$((MAJOR + 1))
        MINOR=0
        PATCH=0
        ;;
    minor)
        MINOR=$((MINOR + 1))
        PATCH=0
        ;;
    patch)
        PATCH=$((PATCH + 1))
        ;;
esac

NEW_VERSION="$MAJOR.$MINOR.$PATCH"
echo "New version: $NEW_VERSION"
echo ""

# Update plugin file
echo "Updating $PLUGIN_FILE..."
sed -i.bak "s/Version: $OLD_VERSION/Version: $NEW_VERSION/g" "$PLUGIN_FILE"
# Also update the constant
sed -i.bak "s/define( 'ITOMIC_COUNTDOWN_VERSION', '$OLD_VERSION' );/define( 'ITOMIC_COUNTDOWN_VERSION', '$NEW_VERSION' );/g" "$PLUGIN_FILE"
rm -f "${PLUGIN_FILE}.bak"
echo "✓ Plugin file updated"

# Update readme.txt
echo "Updating $README_FILE..."
sed -i.bak "s/Stable tag: $OLD_VERSION/Stable tag: $NEW_VERSION/g" "$README_FILE"
rm -f "${README_FILE}.bak"
echo "✓ readme.txt updated"

echo ""
echo "Version bumped successfully!"
echo ""
echo "Next steps:"
echo "1. Review changes: git diff"
echo "2. Commit changes: git add $PLUGIN_FILE $README_FILE"
echo "3. Commit: git commit -m 'Bump version to $NEW_VERSION'"
echo "4. Push to main: git push origin main"
echo "5. GitHub Actions will automatically create release v$NEW_VERSION"
echo ""

