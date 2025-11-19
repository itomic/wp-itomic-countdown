#!/bin/bash

# Get current version from plugin file
CURRENT_VERSION=$(grep "Version:" itomic-countdown.php | head -1 | sed 's/.*Version: *//' | tr -d ' \t\r\n')

if [ -z "$CURRENT_VERSION" ]; then
    echo "ERROR: Could not determine current version"
    exit 1
fi

# Split version into parts
IFS='.' read -r -a version_parts <<< "$CURRENT_VERSION"
major=${version_parts[0]}
minor=${version_parts[1]}
patch=${version_parts[2]}

# Increment patch version
new_patch=$((patch + 1))
NEW_VERSION="$major.$minor.$new_patch"

echo "Patch version bump: $CURRENT_VERSION → $NEW_VERSION"

# Call bump-version script
bin/bump-version.sh "$NEW_VERSION" --commit 